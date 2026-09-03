import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

class MemoryEngine {
  // Types that require disposal
  static const List<String> _disposableTypes = [
    'AnimationController',
    'TextEditingController',
    'ScrollController',
    'FocusNode',
    'PageController',
    'TabController',
    'ChangeNotifier',
  ];

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
        findings.addAll(FileCache.getFindings(entity).where((f) => f.category == 'MEMORY'));
        continue;
      }

      try {
        final content = await entity.readAsString();
        final lines = content.split('\n');

        final hasCancel = content.contains('.cancel()');
        final hasDispose = RegExp(r'\.dispose\s*\(\s*\)').hasMatch(content);

        // 1. Check for stream subscriptions that lack cancel
        if (!hasCancel) {
          for (int i = 0; i < lines.length; i++) {
            final line = lines[i];
            if (line.contains('.listen(') && !line.trim().startsWith('//')) {
              final finding = Finding(
                id: 'MEM-001',
                category: 'MEMORY',
                severity: 'MEDIUM',
                confidence: 'MEDIUM',
                title: 'Potential StreamSubscription Memory Leak',
                file: relativePath,
                line: i + 1,
                evidence: line.trim(),
                description: 'A stream listener was established in $relativePath at line ${i + 1}, but no corresponding ".cancel()" call was detected in the file.',
                risk: 'Active stream subscriptions retain references to listeners and context, which can keep widgets/controllers in memory forever if not canceled when no longer needed.',
                recommendation: 'Store the StreamSubscription in a variable and call subscription.cancel() in dispose() or onClose().',
                fixAvailable: false,
              );
              findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
            }
          }
        }

        // 2. Check for Timers that lack cancel
        if (!hasCancel) {
          for (int i = 0; i < lines.length; i++) {
            final line = lines[i];
            if ((line.contains('Timer.periodic(') || (line.contains('Timer(') && !line.contains('Timer.run('))) && !line.trim().startsWith('//')) {
              final finding = Finding(
                id: 'MEM-002',
                category: 'MEMORY',
                severity: 'MEDIUM',
                confidence: 'MEDIUM',
                title: 'Potential Timer Memory Leak',
                file: relativePath,
                line: i + 1,
                evidence: line.trim(),
                description: 'A Timer is created in $relativePath at line ${i + 1}, but no ".cancel()" call was found.',
                risk: 'Periodic timers keep running in the background and prevent garbage collection of their callback contexts, leading to memory and CPU leaks.',
                recommendation: 'Keep a reference to the Timer and cancel it inside the dispose() or onClose() methods.',
                fixAvailable: false,
              );
              findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
            }
          }
        }

        // 3. Check for disposable controllers and ChangeNotifier
        if (!hasDispose) {
          for (final type in _disposableTypes) {
            final creationPattern = RegExp('$type\\s*\\(');
            for (int i = 0; i < lines.length; i++) {
              final line = lines[i];
              if (creationPattern.hasMatch(line) && !line.trim().startsWith('//')) {
                final finding = Finding(
                  id: 'MEM-003',
                  category: 'MEMORY',
                  severity: 'HIGH',
                  confidence: 'MEDIUM',
                  title: 'Potential Memory Leak: Un-disposed $type',
                  file: relativePath,
                  line: i + 1,
                  evidence: line.trim(),
                  description: 'A $type was instantiated in $relativePath at line ${i + 1} but there is no call to dispose() in the class.',
                  risk: 'Failing to dispose controllers leaves native observers and resources registered, causing severe memory leaks in the app.',
                  recommendation: 'Override the dispose() method in State or GetxController/BLoC and call controller.dispose().',
                  fixAvailable: false,
                );
                findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
              }
            }
          }
        }

        // 4. GetX specific checks
        if (content.contains('extends GetxController')) {
          final hasClose = content.contains('void onClose()') || content.contains('@override\n  void onClose()');
          final hasStreamListen = content.contains('.listen(');
          final hasTimer = content.contains('Timer.periodic(') || content.contains('Timer(');
          if (!hasClose && (hasStreamListen || hasTimer)) {
            final classLineIdx = _findLine(lines, 'extends GetxController');
            final finding = Finding(
              id: 'MEM-GETX-001',
              category: 'MEMORY',
              severity: 'MEDIUM',
              confidence: 'MEDIUM',
              title: 'GetxController Lacks onClose for Resource Cleanup',
              file: relativePath,
              line: classLineIdx,
              evidence: lines[classLineIdx - 1].trim(),
              description: 'This GetxController uses streams or timers but does not override onClose() to clean up resources.',
              risk: 'Resources allocated by GetX controllers may persist in memory even after the controller is deleted from GetX context if streams/timers are not cancelled.',
              recommendation: 'Override onClose() in this class to cancel subscriptions and timers.',
              fixAvailable: false,
            );
            findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
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
