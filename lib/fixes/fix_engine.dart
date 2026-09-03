import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/logging/logger.dart';
import 'package:flutter_architect_mcp/core/process/process_runner.dart';

class FixDiff {
  final String filePath;
  final String oldContent;
  final String newContent;

  FixDiff({
    required this.filePath,
    required this.oldContent,
    required this.newContent,
  });

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'oldContent': oldContent,
      'newContent': newContent,
    };
  }
}

class FixEngine {
  final String projectPath;

  FixEngine(this.projectPath);

  /// Analyzes findings and returns suggested fixes as proposed diffs, without modifying files.
  List<FixDiff> suggestFixes(List<Finding> findings) {
    final suggestions = <FixDiff>[];

    for (final f in findings) {
      if (!f.fixAvailable) continue;

      final file = File(p.join(projectPath, f.file));
      if (!file.existsSync()) continue;

      try {
        final content = file.readAsStringSync();
        final lines = content.split('\n');
        
        // Safety check: skip lines if the file index is out of bounds
        if (f.line - 1 >= lines.length || f.line <= 0) continue;

        final targetLine = lines[f.line - 1];

        // Safe Fix 1: Cleartext HTTP URL rewrite
        if (f.id == 'SEC-NET-002' && targetLine.contains('http://')) {
          final updatedLine = targetLine.replaceAll('http://', 'https://');
          suggestions.add(FixDiff(
            filePath: f.file,
            oldContent: targetLine.trim(),
            newContent: updatedLine.trim(),
          ));
        }

        // Safe Fix 2: Android AllowBackup disable
        if (f.id == 'SEC-AND-001' && targetLine.contains('android:allowBackup="true"')) {
          final updatedLine = targetLine.replaceAll('android:allowBackup="true"', 'android:allowBackup="false"');
          suggestions.add(FixDiff(
            filePath: f.file,
            oldContent: targetLine.trim(),
            newContent: updatedLine.trim(),
          ));
        }

        // Safe Fix 3: Android Cleartext Traffic disable
        if (f.id == 'SEC-AND-002' && targetLine.contains('android:usesCleartextTraffic="true"')) {
          final updatedLine = targetLine.replaceAll('android:usesCleartextTraffic="true"', 'android:usesCleartextTraffic="false"');
          suggestions.add(FixDiff(
            filePath: f.file,
            oldContent: targetLine.trim(),
            newContent: updatedLine.trim(),
          ));
        }
      } catch (e) {
        Logger.error('Failed to generate fix suggestion for ${f.id}', e);
      }
    }

    return suggestions;
  }

  /// Backs up files, applies safe fixes, runs analyzer, and rolls back if compilation fails.
  Future<List<String>> applySafeFixes(List<Finding> findings) async {
    final applied = <String>[];
    final suggestions = suggestFixes(findings);

    if (suggestions.isEmpty) return applied;

    // 1. Create backups first
    final backups = <String, String>{}; // Maps original absolute path to backup absolute path
    for (final diff in suggestions) {
      final origPath = p.join(projectPath, diff.filePath);
      final backupPath = '$origPath.bak';
      
      try {
        final origFile = File(origPath);
        if (origFile.existsSync()) {
          origFile.copySync(backupPath);
          backups[origPath] = backupPath;
        }
      } catch (e) {
        Logger.error('Failed to create backup for $origPath', e);
      }
    }

    bool success = true;
    try {
      // 2. Apply modifications
      for (final diff in suggestions) {
        final origPath = p.join(projectPath, diff.filePath);
        final file = File(origPath);
        if (!file.existsSync()) continue;

        final content = await file.readAsString();
        final updatedContent = content.replaceAll(diff.oldContent, diff.newContent);
        
        if (content != updatedContent) {
          await file.writeAsString(updatedContent);
          applied.add(diff.filePath);
        }
      }

      // 3. Run Dart/Flutter analyzer to ensure build integrity (if flutter project)
      final pubspec = File(p.join(projectPath, 'pubspec.yaml'));
      if (pubspec.existsSync()) {
        Logger.info('Verifying changes by running analysis...');
        final analysisResult = await ProcessRunner.run(
          'flutter',
          ['analyze'],
          workingDirectory: projectPath,
        );

        if (analysisResult.exitCode != 0) {
          Logger.warning('Analysis failed after applying fixes. Rolling back changes...');
          success = false;
        }
      }
    } catch (e, stack) {
      Logger.error('Error occurred while applying fixes', e, stack);
      success = false;
    }

    // 4. Handle rollbacks or cleanups
    if (!success) {
      // Rollback
      for (final entry in backups.entries) {
        try {
          final origFile = File(entry.key);
          final backupFile = File(entry.value);
          if (backupFile.existsSync()) {
            backupFile.copySync(origFile.path);
            backupFile.deleteSync();
          }
        } catch (_) {}
      }
      return []; // No fixes applied due to failure
    } else {
      // Cleanup backups
      for (final backupPath in backups.values) {
        try {
          final backupFile = File(backupPath);
          if (backupFile.existsSync()) {
            backupFile.deleteSync();
          }
        } catch (_) {}
      }
      return applied;
    }
  }
}
