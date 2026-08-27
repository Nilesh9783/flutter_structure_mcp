import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';

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

        // 1. Check for stream subscriptions / timers that lack cancel
        final hasStreamListen = content.contains('.listen(');
        final hasTimer = content.contains('Timer.periodic(') || content.contains('Timer(');
        final hasCancel = content.contains('.cancel()');

        if (hasStreamListen && !hasCancel) {
          findings.add(Finding(
            id: 'MEM-001',
            category: 'MEMORY',
            severity: 'MEDIUM',
            confidence: 'MEDIUM',
            title: 'Potential StreamSubscription Memory Leak',
            file: relativePath,
            line: _findLine(lines, '.listen('),
            evidence: 'StreamSubscription without .cancel()',
            description: 'A stream listener was established in $relativePath, but no corresponding ".cancel()" call was detected in the file.',
            risk: 'Active stream subscriptions retain references to listeners and context, which can keep widgets/controllers in memory forever if not canceled when no longer needed.',
            recommendation: 'Store the StreamSubscription in a variable and call subscription.cancel() in dispose() or onClose().',
            fixAvailable: false,
          ));
        }

        if (hasTimer && !hasCancel) {
          findings.add(Finding(
            id: 'MEM-002',
            category: 'MEMORY',
            severity: 'MEDIUM',
            confidence: 'MEDIUM',
            title: 'Potential Timer Memory Leak',
            file: relativePath,
            line: _findLine(lines, 'Timer'),
            evidence: 'Timer instantiated without .cancel()',
            description: 'A Timer (or Timer.periodic) is created in $relativePath, but no ".cancel()" call was found.',
            risk: 'Periodic timers keep running in the background and prevent garbage collection of their callback contexts, leading to memory and CPU leaks.',
            recommendation: 'Keep a reference to the Timer and cancel it inside the dispose() or onClose() methods.',
            fixAvailable: false,
          ));
        }

        // 2. Check for disposable controllers and ChangeNotifier
        for (final type in _disposableTypes) {
          // Check if controller is created, e.g. final textController = TextEditingController() or similar
          final creationPattern = RegExp('$type\\s*\\(');
          if (creationPattern.hasMatch(content)) {
            // Check if .dispose() is called
            final disposePattern = RegExp(r'\.dispose\s*\(\s*\)');
            if (!disposePattern.hasMatch(content)) {
              findings.add(Finding(
                id: 'MEM-003',
                category: 'MEMORY',
                severity: 'HIGH',
                confidence: 'MEDIUM',
                title: 'Potential Memory Leak: Un-disposed $type',
                file: relativePath,
                line: _findLine(lines, type),
                evidence: '$type created without .dispose()',
                description: 'A $type was created in $relativePath but there is no call to dispose() in the class.',
                risk: 'Failing to dispose controllers leaves native observers and resources registered, causing severe memory leaks in the app.',
                recommendation: 'Override the dispose() method in State or GetxController/BLoC and call controller.dispose().',
                fixAvailable: false,
              ));
            }
          }
        }

        // 3. GetX specific checks
        if (content.contains('extends GetxController')) {
          final hasClose = content.contains('void onClose()') || content.contains('@override\n  void onClose()');
          if (!hasClose && (hasStreamListen || hasTimer)) {
            findings.add(Finding(
              id: 'MEM-GETX-001',
              category: 'MEMORY',
              severity: 'MEDIUM',
              confidence: 'MEDIUM',
              title: 'GetxController Lacks onClose for Resource Cleanup',
              file: relativePath,
              line: _findLine(lines, 'extends GetxController'),
              evidence: 'GetxController without onClose overrides',
              description: 'This GetxController uses streams or timers but does not override onClose() to clean up resources.',
              risk: 'Resources allocated by GetX controllers may persist in memory even after the controller is deleted from GetX context if streams/timers are not cancelled.',
              recommendation: 'Override onClose() in this class to cancel subscriptions and timers.',
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
