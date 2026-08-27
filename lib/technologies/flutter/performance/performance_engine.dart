import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';

class PerformanceEngine {
  // Pattern to find controller creations in build() method
  static final RegExp _controllerInBuildPattern = RegExp(
    r'Widget\s+build\([\s\S]*?(?:TextEditingController|ScrollController|TabController|AnimationController)[\s\S]*?\}',
    caseSensitive: false,
  );

  // Pattern to find ListView usage (non-builder)
  static final RegExp _listViewPattern = RegExp(
    r'ListView\s*\(\s*children\s*:',
    caseSensitive: false,
  );

  // Pattern to detect API or Database call directly inside build method
  static final RegExp _apiCallInBuildPattern = RegExp(
    r'Widget\s+build\([\s\S]*?(?:http\.get|dio\.get|apiService\.|database\.|db\.)[\s\S]*?\}',
    caseSensitive: false,
  );

  Future<List<Finding>> scan(Directory projectDir) async {
    final findings = <Finding>[];

    await for (final entity in projectDir.list(recursive: true, followLinks: false)) {
      if (entity is! File || p.extension(entity.path) != '.dart') continue;

      final relativePath = p.relative(entity.path, from: projectDir.path);
      if (relativePath.startsWith('.git/') ||
          relativePath.startsWith('.dart_tool/') ||
          relativePath.startsWith('build/') ||
          relativePath.startsWith('reports/') ||
          relativePath.startsWith('test/') ||
          relativePath.contains('/reports/') ||
          relativePath.contains('/test/')) {
        continue;
      }

      if (FileCache.isCached(entity)) {
        findings.addAll(FileCache.getFindings(entity).where((f) => f.category == 'PERFORMANCE'));
        continue;
      }

      try {
        final content = await entity.readAsString();
        final lines = content.split('\n');

        // Check for controller initialization inside build method
        if (_controllerInBuildPattern.hasMatch(content)) {
          findings.add(Finding(
            id: 'PERF-001',
            category: 'PERFORMANCE',
            severity: 'HIGH',
            confidence: 'MEDIUM',
            title: 'Controller Instantiation Inside Widget build() Method',
            file: relativePath,
            line: _findLine(lines, 'build('),
            evidence: 'Controller instantiated inside build(...) method',
            description: 'A controller is created inside the build() method of a widget in $relativePath.',
            risk: 'Controllers will be re-instantiated on every single widget build/rebuild, resetting their states and causing CPU spikes/memory leaks.',
            recommendation: 'Convert the widget to a StatefulWidget and instantiate controllers in initState() and dispose them in dispose().',
            fixAvailable: false,
          ));
        }

        // Check for API calls inside build method
        if (_apiCallInBuildPattern.hasMatch(content)) {
          findings.add(Finding(
            id: 'PERF-002',
            category: 'PERFORMANCE',
            severity: 'HIGH',
            confidence: 'MEDIUM',
            title: 'API / Database Call Inside Widget build() Method',
            file: relativePath,
            line: _findLine(lines, 'build('),
            evidence: 'API/DB call within build(...)',
            description: 'Detected a network request or database operation inside the build() method in $relativePath.',
            risk: 'Running synchronous or asynchronous API/DB operations inside build() causes severe interface lags, UI blocking, and generates excessive, duplicated calls on rebuild.',
            recommendation: 'Trigger the network or database requests inside initState() or within controller lifecycle methods, and bind the widget using FutureBuilder (referencing a cached Future) or state managers.',
            fixAvailable: false,
          ));
        }

        // Check for ListView instead of ListView.builder
        for (int i = 0; i < lines.length; i++) {
          final lineContent = lines[i];
          if (_listViewPattern.hasMatch(lineContent)) {
            findings.add(Finding(
              id: 'PERF-003',
              category: 'PERFORMANCE',
              severity: 'MEDIUM',
              confidence: 'HIGH',
              title: 'Use of Static ListView Instead of Lazy ListView.builder',
              file: relativePath,
              line: i + 1,
              evidence: lineContent.trim(),
              description: 'Using "ListView(children: ...)" instead of "ListView.builder(...)".',
              risk: 'A standard ListView instantiates all children items at once, regardless of whether they are visible on screen, causing memory pressure and rendering delays for long lists.',
              recommendation: 'Refactor to "ListView.builder(...)" to enable lazy-loading and item recycling for better scrolling performance.',
              fixAvailable: false,
            ));
          }
        }
      } catch (_) {}
    }

    return findings;
  }

  int _findLine(List<String> lines, String keyword) {
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains(keyword)) return i + 1;
    }
    return 1;
  }
}
