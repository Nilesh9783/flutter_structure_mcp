import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

class PerformanceEngine {
  static final RegExp _listViewPattern = RegExp(
    r'ListView\s*\(\s*children\s*:',
    caseSensitive: false,
  );

  static const List<String> _controllerTypes = [
    'TextEditingController',
    'ScrollController',
    'TabController',
    'AnimationController',
    'PageController',
  ];

  static final RegExp _apiCallPatterns = RegExp(
    r'(?:http\.get|dio\.get|dio\.post|http\.post|apiService\.|database\.|db\.)',
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

        bool inBuildMethod = false;
        int buildBraceDepth = 0;

        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];
          final trimmed = line.trim();

          // Track build method boundaries
          if (trimmed.startsWith('Widget build(') || trimmed.contains('Widget build(BuildContext')) {
            inBuildMethod = true;
            buildBraceDepth = 0;
          }

          if (inBuildMethod) {
            buildBraceDepth += _countOccurrences(line, '{') - _countOccurrences(line, '}');
            if (buildBraceDepth <= 0 && line.contains('}')) {
              inBuildMethod = false;
            } else {
              // 1. Check for controller initialization inside build method
              for (final ctrlType in _controllerTypes) {
                if (line.contains('$ctrlType(') && !trimmed.startsWith('//')) {
                  final finding = Finding(
                    id: 'PERF-001',
                    category: 'PERFORMANCE',
                    severity: 'HIGH',
                    confidence: 'HIGH',
                    title: 'Controller Instantiation Inside Widget build() Method',
                    file: relativePath,
                    line: i + 1,
                    evidence: trimmed,
                    description: 'A $ctrlType is instantiated inside build() at line ${i + 1} of $relativePath.',
                    risk: 'Controllers will be re-instantiated on every single widget build/rebuild, resetting their states and causing CPU spikes/memory leaks.',
                    recommendation: 'Convert the widget to a StatefulWidget, instantiate $ctrlType in initState(), and dispose it in dispose().',
                    fixAvailable: false,
                  );
                  findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
                }
              }

              // 2. Check for API / DB calls inside build method
              if (_apiCallPatterns.hasMatch(line) && !trimmed.startsWith('//')) {
                final finding = Finding(
                  id: 'PERF-002',
                  category: 'PERFORMANCE',
                  severity: 'HIGH',
                  confidence: 'HIGH',
                  title: 'API / Database Call Inside Widget build() Method',
                  file: relativePath,
                  line: i + 1,
                  evidence: trimmed,
                  description: 'Detected a network or database call inside build() at line ${i + 1} of $relativePath.',
                  risk: 'Running synchronous or asynchronous API/DB operations inside build() causes severe interface lags, UI blocking, and generates excessive, duplicated calls on rebuild.',
                  recommendation: 'Trigger the network or database requests inside initState() or within controller lifecycle methods, and bind the widget using FutureBuilder (referencing a cached Future) or state managers.',
                  fixAvailable: false,
                );
                findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
              }
            }
          }

          // 3. Check for ListView instead of ListView.builder
          if (_listViewPattern.hasMatch(line) && !trimmed.startsWith('//')) {
            final finding = Finding(
              id: 'PERF-003',
              category: 'PERFORMANCE',
              severity: 'MEDIUM',
              confidence: 'HIGH',
              title: 'Use of Static ListView Instead of Lazy ListView.builder',
              file: relativePath,
              line: i + 1,
              evidence: trimmed,
              description: 'Using "ListView(children: ...)" instead of "ListView.builder(...)" at line ${i + 1}.',
              risk: 'A standard ListView instantiates all children items at once, regardless of whether they are visible on screen, causing memory pressure and rendering delays for long lists.',
              recommendation: 'Refactor to "ListView.builder(...)" to enable lazy-loading and item recycling for better scrolling performance.',
              fixAvailable: false,
            );
            findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
          }
        }
      } catch (_) {}
    }

    return findings;
  }

  int _countOccurrences(String source, String pattern) {
    return pattern.allMatches(source).length;
  }
}
