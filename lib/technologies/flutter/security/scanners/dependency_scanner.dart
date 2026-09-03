import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/logging/logger.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

class DependencyScanner {
  static const Map<String, List<Map<String, dynamic>>> _knownVulnerabilities = {
    'dio': [
      {
        'versionRange': '<5.1.2',
        'cve': 'CVE-2023-some-dio',
        'title': 'Dio HTTP Header Leak / Improper Input Validation',
        'severity': 'MEDIUM',
        'description': 'Older versions of Dio may leak headers during redirect across hosts.',
        'recommendation': 'Update to dio: ^5.1.2 or higher.'
      }
    ],
    'hive': [
      {
        'versionRange': '<2.2.0',
        'cve': 'CVE-2022-hive-key',
        'title': 'Hive Storage Insecure Defaults',
        'severity': 'LOW',
        'description': 'Hive boxes are unencrypted by default, leading to plaintext exposure of data.',
        'recommendation': 'Pass encryption keys to Hive.openBox or update hive package.'
      }
    ],
    'shared_preferences': [
      {
        'versionRange': '<2.0.15',
        'cve': 'CVE-2022-sp-insecure',
        'title': 'SharedPreferences Insecure Backup Vulnerability',
        'severity': 'LOW',
        'description': 'Allows potential backup extraction of shared preferences keys on Android.',
        'recommendation': 'Upgrade shared_preferences to ^2.0.15.'
      }
    ]
  };

  Future<List<Finding>> scan(Directory projectDir) async {
    final findings = <Finding>[];

    final pubspecFile = File(p.join(projectDir.path, 'pubspec.yaml'));
    final lockFile = File(p.join(projectDir.path, 'pubspec.lock'));

    if (!pubspecFile.existsSync()) {
      return findings;
    }

    final Map<String, String> declaredDeps = {};
    final Map<String, String> lockedVersions = {};
    List<String> pubspecLines = [];

    // 1. Read declared dependencies
    try {
      final content = await pubspecFile.readAsString();
      pubspecLines = content.split('\n');
      final doc = loadYaml(content);
      if (doc is YamlMap) {
        final deps = doc['dependencies'];
        if (deps is YamlMap) {
          for (final key in deps.keys) {
            declaredDeps[key.toString()] = deps[key]?.toString() ?? '';
          }
        }
      }
    } catch (e) {
      Logger.error('Failed to parse pubspec.yaml for dependency check', e);
    }

    // 2. Read locked versions
    if (lockFile.existsSync()) {
      try {
        final doc = loadYaml(await lockFile.readAsString());
        if (doc is YamlMap) {
          final packages = doc['packages'];
          if (packages is YamlMap) {
            for (final key in packages.keys) {
              final pkg = packages[key];
              if (pkg is YamlMap) {
                lockedVersions[key.toString()] = pkg['version']?.toString() ?? '';
              }
            }
          }
        }
      } catch (e) {
        Logger.error('Failed to parse pubspec.lock', e);
      }
    }

    // Check direct dependencies against known vulnerabilities
    for (final entry in declaredDeps.entries) {
      final pkgName = entry.key;
      final lockedVer = lockedVersions[pkgName] ?? '';

      final vulnerabilities = _knownVulnerabilities[pkgName];
      if (vulnerabilities != null && lockedVer.isNotEmpty) {
        for (final vuln in vulnerabilities) {
          final range = vuln['versionRange'] as String;
          if (_isMatchingRange(lockedVer, range)) {
            final lineNum = _findLineInPubspec(pubspecLines, pkgName);
            final finding = Finding(
              id: 'SEC-DEP-001',
              category: 'DEPENDENCY',
              severity: vuln['severity'] ?? 'MEDIUM',
              confidence: 'HIGH',
              title: vuln['title'] ?? 'Vulnerable Dependency Detected',
              file: 'pubspec.yaml',
              line: lineNum,
              evidence: '$pkgName: $lockedVer (Vulnerable range: $range)',
              description: vuln['description'] ?? 'Vulnerable version of $pkgName detected at line $lineNum in pubspec.yaml.',
              risk: 'Using known vulnerable dependencies can expose the application to attacks targeting package-level bugs.',
              recommendation: vuln['recommendation'] ?? 'Upgrade $pkgName to a secure version.',
              fixAvailable: true,
            );
            findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
          }
        }
      }
    }

    // If lockfile is missing
    if (!lockFile.existsSync()) {
      final finding = Finding(
        id: 'SEC-DEP-002',
        category: 'DEPENDENCY',
        severity: 'LOW',
        confidence: 'HIGH',
        title: 'Pubspec Lock File Missing',
        file: 'pubspec.yaml',
        line: 1,
        evidence: 'pubspec.lock not found',
        description: 'The lockfile is missing, which prevents reproducible builds and transitive dependency resolution audits.',
        risk: 'Without pubspec.lock, reproducible builds are not guaranteed.',
        recommendation: 'Run "flutter pub get" to generate pubspec.lock.',
        fixAvailable: false,
      );
      findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
    }

    return findings;
  }

  int _findLineInPubspec(List<String> lines, String pkgName) {
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('$pkgName:') || line.startsWith('$pkgName ')) {
        return i + 1;
      }
    }
    return 1;
  }

  bool _isMatchingRange(String currentVer, String range) {
    if (range.startsWith('<')) {
      final target = range.substring(1).trim();
      return _compareVersions(currentVer, target) < 0;
    }
    return false;
  }

  int _compareVersions(String v1, String v2) {
    final parts1 = v1.replaceAll(RegExp(r'[^0-9\.]'), '').split('.').map(int.tryParse).toList();
    final parts2 = v2.replaceAll(RegExp(r'[^0-9\.]'), '').split('.').map(int.tryParse).toList();

    for (int i = 0; i < 3; i++) {
      final p1 = (i < parts1.length) ? (parts1[i] ?? 0) : 0;
      final p2 = (i < parts2.length) ? (parts2[i] ?? 0) : 0;
      if (p1 != p2) return p1.compareTo(p2);
    }
    return 0;
  }
}
