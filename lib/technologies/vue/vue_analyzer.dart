import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/base_analyzer.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';

class VueAnalyzer implements BaseAnalyzer {
  @override
  String get technologyId => 'vue';

  @override
  String get technologyName => 'Vue.js';

  @override
  bool canAnalyze(String projectPath) {
    // Check package.json for Vue dependency
    final packageJson = File(p.join(projectPath, 'package.json'));
    if (packageJson.existsSync()) {
      try {
        final content = packageJson.readAsStringSync();
        final parsed = jsonDecode(content);
        if (parsed is Map) {
          final deps = parsed['dependencies'];
          final devDeps = parsed['devDependencies'];
          if ((deps is Map && deps.containsKey('vue')) || (devDeps is Map && devDeps.containsKey('vue'))) {
            return true;
          }
        }
      } catch (_) {}
    }

    // Fallback: Check if there are any .vue files in the project
    final dir = Directory(projectPath);
    if (dir.existsSync()) {
      try {
        final files = dir.listSync(recursive: true, followLinks: false);
        return files.any((file) => file is File && p.extension(file.path).toLowerCase() == '.vue');
      } catch (_) {}
    }
    return false;
  }

  @override
  Future<List<Finding>> analyze(String projectPath, {String scanLevel = 'standard'}) async {
    final findings = <Finding>[];
    final dir = Directory(projectPath);
    if (!dir.existsSync()) return findings;

    await _scanDirectory(dir, projectPath, findings);
    return findings;
  }

  Future<void> _scanDirectory(Directory dir, String rootPath, List<Finding> findings) async {
    final excludedDirs = {'node_modules', '.git', 'dist', 'build', '.nuxt', 'coverage', 'reports'};

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: rootPath);
        final pathSegments = p.split(relativePath);
        if (pathSegments.any((seg) => excludedDirs.contains(seg))) continue;

        final ext = p.extension(entity.path).toLowerCase();
        if (ext == '.vue' || ext == '.js' || ext == '.ts') {
          await _scanFile(entity, relativePath, findings);
        }
      }
    }
  }

  Future<void> _scanFile(File file, String relativePath, List<Finding> findings) async {
    final lines = await file.readAsLines();
    final ext = p.extension(file.path).toLowerCase();

    // 1. Large component check (Code Quality)
    if (ext == '.vue' && lines.length > 400) {
      findings.add(Finding(
        id: 'CQ-VUE-001',
        category: 'CODE_QUALITY',
        severity: 'MEDIUM',
        confidence: 'HIGH',
        title: 'Large Vue Single File Component (SFC)',
        file: relativePath,
        line: lines.length,
        evidence: 'Total lines: ${lines.length}',
        description: 'Single File Component exceeds recommended 400 lines limit.',
        risk: 'Massive SFCs are difficult to read, reuse, unit-test, and maintain.',
        recommendation: 'Extract sub-components or split logical scripts into Vue composables (Composition API).',
      ));
    }

    final secretRegex = RegExp(
      r"""[a-zA-Z0-9_-]*(key|secret|password|passwd|token|auth|credential|jwt)[a-zA-Z0-9_-]*\s*[:=]\s*['"]([A-Za-z0-9\-_+=/]{16,})['"]""",
      caseSensitive: false,
    );
    final vHtmlRegex = RegExp(r'\bv-html\b');
    final rawStorageRegex = RegExp(r'\b(localStorage|sessionStorage)\.(setItem|getItem|removeItem)\(');
    final unscopedStyleRegex = RegExp(r'<style(?!\s*scoped)\b[^>]*>');
    final vForNoKeyRegex = RegExp(r'v-for="[^"]+"(?!\s*[^>]*:key\b)');
    final deepWatcherRegex = RegExp(r'\bdeep\s*:\s*true\b');
    final consoleLogRegex = RegExp(r'\bconsole\.log\s*\(');

    for (int i = 0; i < lines.length; i++) {
      final lineText = lines[i];
      final lineNum = i + 1;

      // 2. Secrets Scan
      if (secretRegex.hasMatch(lineText)) {
        final match = secretRegex.firstMatch(lineText)!;
        findings.add(Finding(
          id: 'SEC-001',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'HIGH',
          title: 'Hardcoded Secret Exposure',
          file: relativePath,
          line: lineNum,
          evidence: lineText.replaceAll(match.group(2)!, '[REDACTED]'),
          description: 'A hardcoded api key or client secret was exposed in code.',
          risk: 'Frontend clients are completely public. Any keys shipped in Vue builds can be easily extracted by users.',
          recommendation: 'Never embed private keys on Vue templates or scripts. Run APIs via a backend proxy/gateway.',
        ));
      }

      // 3. v-html XSS (Security)
      if (vHtmlRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-VUE-001',
          category: 'SECURITY',
          severity: 'HIGH',
          confidence: 'HIGH',
          title: 'Cross-Site Scripting (XSS) via v-html',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Usage of the "v-html" directive detected.',
          risk: 'v-html renders raw HTML strings directly into the DOM, making it highly vulnerable to script injection if HTML contains user input.',
          recommendation: 'Avoid v-html. Prefer standard template text binding ({{ }}). If necessary, sanitize the HTML string using DOMPurify.',
        ));
      }

      // 4. Raw Storage usage (Security)
      if (rawStorageRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-VUE-002',
          category: 'SECURITY',
          severity: 'MEDIUM',
          confidence: 'HIGH',
          title: 'Raw Unencrypted Local / Session Storage Access',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'The code directly accesses localStorage/sessionStorage API without security custom wrapper.',
          risk: 'Local storage is readable by any script on the domain (including third-party scripts/CDN dependencies via XSS). Storing unencrypted sessions or tokens here is unsafe.',
          recommendation: 'Sanitize stored items, cryptographically sign state where necessary, or use secure httpOnly cookies for session storage.',
        ));
      }

      // 5. Unscoped styling (Code Quality)
      if (ext == '.vue' && unscopedStyleRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'CQ-VUE-002',
          category: 'CODE_QUALITY',
          severity: 'LOW',
          confidence: 'HIGH',
          title: 'Global Unscoped CSS Style Pollution',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'A <style> block was declared in a Vue SFC without the "scoped" attribute.',
          risk: 'Styles declared globally will leak and alter UI elements on other unrelated pages, making styling unpredictable.',
          recommendation: 'Change to <style scoped> to encapsulate styles within this component.',
        ));
      }

      // 6. v-for without :key (Code Quality)
      if (ext == '.vue' && vForNoKeyRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'CQ-VUE-003',
          category: 'CODE_QUALITY',
          severity: 'MEDIUM',
          confidence: 'MEDIUM',
          title: 'Missing Loop Binding Key (:key)',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'A "v-for" loop is used without a corresponding ":key" binding.',
          risk: 'Vue cannot track individual DOM nodes efficiently on list updates, causing slow rendering or state synchronization bugs.',
          recommendation: 'Always bind a unique property to :key, e.g. <div v-for="item in items" :key="item.id">.',
        ));
      }

      // 7. Deep watchers (Performance)
      if (deepWatcherRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'PERF-VUE-001',
          category: 'PERFORMANCE',
          severity: 'LOW',
          confidence: 'MEDIUM',
          title: 'Expensive Deep Watcher Observer',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Vue watcher declared with deep: true.',
          risk: 'Deep watchers recursively traverse the entire nested structure of an object, causing substantial CPU overhead on large state changes.',
          recommendation: 'Use shallow watchers, watch specific nested fields (e.g. () => obj.field), or restructure Vue reactive state.',
        ));
      }

      // 8. Console.log (Code Quality)
      if (consoleLogRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'CQ-VUE-004',
          category: 'CODE_QUALITY',
          severity: 'LOW',
          confidence: 'HIGH',
          title: 'Leftover Debug console.log Statement',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'console.log statement found in Vue component script.',
          risk: 'Console log output is visible in browser inspect panels, exposing internal structure and increasing browser overhead.',
          recommendation: 'Remove debugger console statements before deploying to staging/production.',
        ));
      }
    }
  }

  @override
  Future<ProjectMetadata> getMetadata(String projectPath) async {
    final packageJsonFile = File(p.join(projectPath, 'package.json'));
    String projectName = p.basename(projectPath);
    String vueVersion = '3.x (Assuming)';
    final Map<String, String> dependencies = {};
    final Map<String, String> devDependencies = {};

    if (packageJsonFile.existsSync()) {
      try {
        final content = packageJsonFile.readAsStringSync();
        final doc = jsonDecode(content);
        if (doc is Map) {
          projectName = doc['name']?.toString() ?? projectName;
          final deps = doc['dependencies'];
          if (deps is Map) {
            deps.forEach((k, v) => dependencies[k.toString()] = v.toString());
          }
          final devDeps = doc['devDependencies'];
          if (devDeps is Map) {
            devDeps.forEach((k, v) => devDependencies[k.toString()] = v.toString());
          }
        }
      } catch (_) {}
    }

    if (dependencies.containsKey('vue')) {
      vueVersion = dependencies['vue']!.replaceAll(RegExp(r'[^0-9\.]'), '');
    }

    String stateManagement = 'None';
    if (dependencies.containsKey('pinia')) {
      stateManagement = 'Pinia';
    } else if (dependencies.containsKey('vuex')) {
      stateManagement = 'Vuex';
    }

    String router = 'None';
    if (dependencies.containsKey('vue-router')) {
      router = 'Vue Router';
    }

    String network = 'Axios / Fetch';
    if (dependencies.containsKey('axios')) {
      network = 'Axios';
    }

    return ProjectMetadata(
      projectName: projectName,
      flutterVersion: 'N/A (Vue.js)',
      dartVersion: 'Vue.js $vueVersion',
      dependencies: dependencies,
      devDependencies: devDependencies,
      detectedArchitecture: 'SFC Single-Page App (Vue)',
      detectedStateManagement: stateManagement,
      detectedRouter: router,
      detectedNetwork: network,
      detectedDatabase: 'None (Client Side)',
      hasFirebase: dependencies.containsKey('firebase') || dependencies.containsKey('@angular/fire'),
      hasAuthentication: dependencies.keys.any((k) => k.contains('auth')) || dependencies.containsKey('auth0-vue'),
      targetPlatforms: ['Web Browser', 'Mobile (Capacitor/Cordova)'],
    );
  }
}
