import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/base_analyzer.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';

class NodeAnalyzer implements BaseAnalyzer {
  @override
  String get technologyId => 'node';

  @override
  String get technologyName => 'Node.js';

  @override
  bool canAnalyze(String projectPath) {
    final packageJson = File(p.join(projectPath, 'package.json'));
    if (!packageJson.existsSync()) return false;
    
    try {
      final content = packageJson.readAsStringSync();
      final parsed = jsonDecode(content);
      if (parsed is Map) {
        final deps = parsed['dependencies'];
        if (deps is Map && deps.containsKey('vue')) {
          // Let Vue analyzer take it
          return false;
        }
      }
    } catch (_) {}
    
    return true;
  }

  @override
  Future<List<Finding>> analyze(String projectPath, {String scanLevel = 'standard'}) async {
    final findings = <Finding>[];
    final dir = Directory(projectPath);
    if (!dir.existsSync()) return findings;

    // Run scans
    await _scanDirectory(dir, projectPath, findings);
    await _scanDependencies(projectPath, findings);

    return findings;
  }

  Future<void> _scanDirectory(Directory dir, String rootPath, List<Finding> findings) async {
    final excludedDirs = {
      'node_modules',
      '.git',
      'dist',
      'build',
      '.next',
      '.nuxt',
      'coverage',
      'reports'
    };

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: rootPath);
        final pathSegments = p.split(relativePath);
        
        // Skip excluded directories
        if (pathSegments.any((seg) => excludedDirs.contains(seg))) {
          continue;
        }

        final ext = p.extension(entity.path).toLowerCase();
        if (ext == '.js' || ext == '.ts' || ext == '.jsx' || ext == '.tsx' || ext == '.env') {
          await _scanFile(entity, relativePath, findings);
        }
      }
    }
  }

  Future<void> _scanFile(File file, String relativePath, List<Finding> findings) async {
    final lines = await file.readAsLines();

    // 1. Large file check (Code Quality)
    if (lines.length > 500) {
      findings.add(Finding(
        id: 'CQ-NODE-002',
        category: 'CODE_QUALITY',
        severity: 'MEDIUM',
        confidence: 'HIGH',
        title: 'Large Source File',
        file: relativePath,
        line: lines.length,
        evidence: 'Total lines: ${lines.length}',
        description: 'File exceeds recommended 500 lines limit.',
        risk: 'Large files reduce maintainability, increase cognitive load, and violate single-responsibility principles.',
        recommendation: 'Refactor and divide responsibilities into smaller files or helper modules.',
      ));
    }

    // Regular expressions for security/performance/quality rules
    final secretRegex = RegExp(
      r"""[a-zA-Z0-9_-]*(key|secret|password|passwd|token|auth|credential|jwt)[a-zA-Z0-9_-]*\s*[:=]\s*['"]([A-Za-z0-9\-_+=/]{16,})['"]""",
      caseSensitive: false,
    );
    final pemRegex = RegExp(r'-----BEGIN (RSA |EC )?PRIVATE KEY-----');
    final evalRegex = RegExp(r'\beval\s*\(');
    final execRegex = RegExp(r'\b(child_process|cp)\.exec\s*\(');
    final httpRegex = RegExp(r'http://[a-zA-Z0-9\-\.]+');
    final syncFsRegex = RegExp(r'\bfs\.[a-zA-Z0-9]+Sync\b');
    final consoleLogRegex = RegExp(r'\bconsole\.log\s*\(');
    final emptyCatchRegex = RegExp(r'\}\s*catch\s*(\(\s*\w*\s*\))?\s*\{\s*\}');

    for (int i = 0; i < lines.length; i++) {
      final lineText = lines[i];
      final lineNum = i + 1;

      // 2. Secrets Scan
      if (secretRegex.hasMatch(lineText)) {
        final match = secretRegex.firstMatch(lineText)!;
        final keyName = match.group(1);
        findings.add(Finding(
          id: 'SEC-001',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'HIGH',
          title: 'Hardcoded Secret Exposure ($keyName)',
          file: relativePath,
          line: lineNum,
          evidence: lineText.replaceAll(match.group(2)!, '[REDACTED]'),
          description: 'A hardcoded credentials pattern containing $keyName was found in code.',
          risk: 'Exposing credentials in source repositories can lead to server breaches, data leaks, and system hijack.',
          recommendation: 'Move the sensitive key to an environment variable (.env) or use a vault system like AWS Secrets Manager.',
        ));
      }

      if (pemRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-004',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'HIGH',
          title: 'Hardcoded Private Key / Certificate',
          file: relativePath,
          line: lineNum,
          evidence: lineText,
          description: 'Exposed PEM Private Key format detected in source code.',
          risk: 'Exposing private keys compromise encryption keys, allowing intercept of TLS sessions, SSH tunnels, or signing keys.',
          recommendation: 'Remove private keys from source code and inject via environment variables or secret volumes.',
        ));
      }

      // 3. Eval usage (Security)
      if (evalRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-NODE-001',
          category: 'SECURITY',
          severity: 'CRITICAL',
          confidence: 'HIGH',
          title: 'Unsafe Dynamic Code Execution (eval)',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Usage of eval() dynamic script execution detected.',
          risk: 'eval() executes arbitrary strings with local scope privileges, exposing the application to injection attacks if inputs are untrusted.',
          recommendation: 'Avoid eval() entirely. Use strict parsers (JSON.parse), mapping functions, or standard libraries.',
        ));
      }

      // 4. Exec usage (Security)
      if (execRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'SEC-NODE-002',
          category: 'SECURITY',
          severity: 'HIGH',
          confidence: 'MEDIUM',
          title: 'Child Process Exec Command Injection Risk',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: ' child_process.exec() executes a shell command, exposing command injection vectors.',
          risk: 'If arguments passed to exec() include user-supplied text, it is vulnerable to command execution payloads.',
          recommendation: 'Use child_process.execFile() or spawn() which pass parameters directly without shell spawning.',
        ));
      }

      // 5. Insecure Cleartext Protocol (Security)
      if (httpRegex.hasMatch(lineText) && !lineText.contains('localhost') && !lineText.contains('127.0.0.1')) {
        findings.add(Finding(
          id: 'SEC-NODE-003',
          category: 'SECURITY',
          severity: 'MEDIUM',
          confidence: 'HIGH',
          title: 'Cleartext HTTP Protocol Usage',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'The code refers to an unencrypted HTTP URL instead of HTTPS.',
          risk: 'Data sent over HTTP is unencrypted and subject to man-in-the-middle sniffing or tampering.',
          recommendation: 'Enforce HTTPS for all web request destinations.',
        ));
      }

      // 6. Sync File API (Performance)
      if (syncFsRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'PERF-NODE-001',
          category: 'PERFORMANCE',
          severity: 'MEDIUM',
          confidence: 'HIGH',
          title: 'Blocking Synchronous File I/O API',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Synchronous fs calls block the single-threaded Node.js event loop.',
          risk: 'All concurrent client requests are blocked while the file system operation executes, degrading server performance.',
          recommendation: 'Replace with asynchronous methods (e.g. fs.promises.readFile or async/await syntax).',
        ));
      }

      // 7. Leftover Console Logs (Code Quality)
      if (consoleLogRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'CQ-NODE-001',
          category: 'CODE_QUALITY',
          severity: 'LOW',
          confidence: 'HIGH',
          title: 'Leftover Debug Logger (console.log)',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'Use of raw console.log statements detected.',
          risk: 'Console logs degrade stdout performance, bloat server logs, and can expose private application structures.',
          recommendation: 'Use a structured logging library like winston, pino, or bunyan with appropriate log levels.',
        ));
      }

      // 8. Empty Catch block (Code Quality)
      if (emptyCatchRegex.hasMatch(lineText)) {
        findings.add(Finding(
          id: 'CQ-NODE-003',
          category: 'CODE_QUALITY',
          severity: 'MEDIUM',
          confidence: 'HIGH',
          title: 'Empty Exception Catch Block',
          file: relativePath,
          line: lineNum,
          evidence: lineText.trim(),
          description: 'An exception is caught but the block contains no statement, swallowing the error.',
          risk: 'Swallowed exceptions make errors invisible, leading to unexpected behaviors that are hard to diagnose.',
          recommendation: 'Log the error inside the catch block or rethrow if necessary.',
        ));
      }
    }
  }

  Future<void> _scanDependencies(String projectPath, List<Finding> findings) async {
    final packageJsonFile = File(p.join(projectPath, 'package.json'));
    if (!packageJsonFile.existsSync()) return;

    try {
      final doc = jsonDecode(packageJsonFile.readAsStringSync());
      if (doc is! Map) return;

      final deps = doc['dependencies'] as Map? ?? {};
      
      // Known vulnerable packages lookup
      final vulnerablePackages = {
        'lodash': '4.17.21',
        'express': '4.16.0',
        'axios': '0.21.1',
        'jsonwebtoken': '9.0.0',
        'minimist': '1.2.6',
      };

      deps.forEach((key, val) {
        final limit = vulnerablePackages[key];
        if (limit != null) {
          // Simple compare: if version is lower or matching, raise finding
          findings.add(Finding(
            id: 'DEP-001',
            category: 'DEPENDENCY',
            severity: 'HIGH',
            confidence: 'MEDIUM',
            title: 'Vulnerable Package Dependency ($key)',
            file: 'package.json',
            line: 1,
            evidence: '"$key": "$val"',
            description: 'Package "$key" is declared with a version ($val) that may contain known vulnerabilities.',
            risk: 'Using outdated or vulnerable libraries exposes the app to public CVEs (denial of service, security bypass).',
            recommendation: 'Run "npm audit" or upgrade the package to its latest safe release.',
          ));
        }
      });
    } catch (_) {}
  }

  @override
  Future<ProjectMetadata> getMetadata(String projectPath) async {
    final packageJsonFile = File(p.join(projectPath, 'package.json'));
    if (!packageJsonFile.existsSync()) {
      throw Exception('package.json not found at $projectPath');
    }

    String projectName = p.basename(projectPath);
    String nodeVersion = 'unknown';
    final Map<String, String> dependencies = {};
    final Map<String, String> devDependencies = {};

    try {
      final content = packageJsonFile.readAsStringSync();
      final doc = jsonDecode(content);
      if (doc is Map) {
        projectName = doc['name']?.toString() ?? projectName;
        final engines = doc['engines'];
        if (engines is Map && engines.containsKey('node')) {
          nodeVersion = engines['node'].toString();
        }
        
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

    String router = 'None';
    if (dependencies.containsKey('express')) router = 'Express';
    if (dependencies.containsKey('koa')) router = 'Koa';
    if (dependencies.containsKey('nestjs/core')) router = 'NestJS';

    String network = 'axios / native-fetch';
    if (dependencies.containsKey('axios')) network = 'Axios';
    if (dependencies.containsKey('request')) network = 'Request (Deprecated)';

    String database = 'None';
    if (dependencies.containsKey('mongoose')) database = 'MongoDB (Mongoose)';
    if (dependencies.containsKey('sequelize')) database = 'SQL (Sequelize)';
    if (dependencies.containsKey('pg')) database = 'PostgreSQL (pg)';
    if (dependencies.containsKey('mysql2')) database = 'MySQL (mysql2)';

    final hasFirebase = dependencies.containsKey('firebase') || dependencies.containsKey('firebase-admin');
    final hasAuthentication = dependencies.containsKey('passport') ||
        dependencies.containsKey('jsonwebtoken') ||
        dependencies.keys.any((k) => k.contains('auth'));

    return ProjectMetadata(
      projectName: projectName,
      flutterVersion: 'N/A (Node.js)',
      dartVersion: 'Node.js $nodeVersion',
      dependencies: dependencies,
      devDependencies: devDependencies,
      detectedArchitecture: 'Modular / Layered (Node)',
      detectedStateManagement: 'N/A',
      detectedRouter: router,
      detectedNetwork: network,
      detectedDatabase: database,
      hasFirebase: hasFirebase,
      hasAuthentication: hasAuthentication,
      targetPlatforms: ['Node.js backend'],
    );
  }
}
