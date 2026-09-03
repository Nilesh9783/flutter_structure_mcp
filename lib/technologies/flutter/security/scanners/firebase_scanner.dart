import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

class FirebaseScanner {
  Future<List<Finding>> scan(Directory projectDir, {bool hasFirebase = false}) async {
    final findings = <Finding>[];

    // Find rule files
    final List<File> ruleFiles = [];
    try {
      await for (final entity in projectDir.list(recursive: true, followLinks: false)) {
        if (entity is! File) continue;
        final relativePath = p.relative(entity.path, from: projectDir.path);
        if (relativePath.startsWith('reports/') ||
            relativePath.startsWith('test/') ||
            relativePath.contains('/reports/') ||
            relativePath.contains('/test/')) {
          continue;
        }
        final name = p.basename(entity.path);
        if (name == 'firestore.rules' || name == 'storage.rules' || name == 'database.rules.json') {
          ruleFiles.add(entity);
        }
      }
    } catch (_) {}

    if (ruleFiles.isEmpty) {
      if (hasFirebase) {
        final finding = Finding(
          id: 'SEC-FB-001',
          category: 'SECURITY',
          severity: 'MEDIUM',
          confidence: 'HIGH',
          title: 'Firebase Security Rules Verification Unavailable',
          file: 'pubspec.yaml',
          line: 1,
          evidence: 'Firebase dependencies declared without local security rules',
          description: 'Firebase rules could not be verified because security rules (e.g. firestore.rules) were not found locally.',
          risk: 'Without locally declared security rules, we cannot verify if the remote database is protected against unauthorized read/write requests.',
          recommendation: 'Ensure your Firestore, Storage, or Realtime Database rules are checked into the repository (e.g., firestore.rules) so they can be statically analyzed and deployed.',
          fixAvailable: false,
        );
        findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
      }
      return findings;
    }

    // If rules files exist, analyze them for wildcard read/write access
    final openRulesPattern = RegExp(r'allow\s+(read|write|create|update|delete)\s*:\s*if\s+true\s*;', caseSensitive: false);

    for (final file in ruleFiles) {
      final relativePath = p.relative(file.path, from: projectDir.path);
      try {
        final content = await file.readAsString();
        final lines = content.split('\n');

        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (openRulesPattern.hasMatch(line) && !line.trim().startsWith('//')) {
            final finding = Finding(
              id: 'SEC-FB-002',
              category: 'SECURITY',
              severity: 'CRITICAL',
              confidence: 'HIGH',
              title: 'Permissive Wildcard Firebase Rule Detected',
              file: relativePath,
              line: i + 1,
              evidence: line.trim(),
              description: 'The security rules file "$relativePath" contains permissive allow rules without authentication checks at line ${i + 1}.',
              risk: 'Any remote client can query, edit, or delete database and storage assets without authentication or validation, leading to potential data loss or leaks.',
              recommendation: 'Update rules to require authentication, e.g., "if request.auth != null;", and define fine-grained object ownership validations.',
              fixAvailable: false,
            );
            findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
          }
        }
      } catch (_) {}
    }

    return findings;
  }
}
