import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';

class StorageScanner {
  // Pattern to find SharedPreferences, Hive or Sqflite storage write/reads
  // that use potentially sensitive keys.
  static final RegExp _storageWritePattern = RegExp(
    r"""\.(?:setString|put|write|insert|execute)\s*\(\s*["']([^"']+)["']""",
    caseSensitive: false,
  );

  static final List<String> _sensitiveKeys = [
    'token', 'jwt', 'auth', 'password', 'passwd', 'secret', 'session',
    'credential', 'key', 'access_token', 'refresh_token', 'privatekey'
  ];

  Future<List<Finding>> scan(Directory projectDir) async {
    final findings = <Finding>[];

    await for (final entity in projectDir.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;

      final relativePath = p.relative(entity.path, from: projectDir.path);
      if (relativePath.startsWith('.git/') ||
          relativePath.startsWith('.dart_tool/') ||
          relativePath.startsWith('build/') ||
          relativePath.startsWith('reports/') ||
          relativePath.startsWith('test/') ||
          relativePath.contains('/reports/') ||
          relativePath.contains('/test/') ||
          p.extension(entity.path) != '.dart') {
        continue;
      }

      if (FileCache.isCached(entity)) {
        findings.addAll(FileCache.getFindings(entity).where((f) => f.id.startsWith('SEC-STR-')));
        continue;
      }

      try {
        final content = await entity.readAsString();
        final lines = content.split('\n');

        for (int i = 0; i < lines.length; i++) {
          final lineContent = lines[i];
          final match = _storageWritePattern.firstMatch(lineContent);
          if (match != null) {
            final keyUsed = match.group(1)?.toLowerCase() ?? '';
            // If the key contains onboarding, theme, count, etc. ignore it.
            // But if it contains sensitive keyword:
            final isSensitive = _sensitiveKeys.any((k) => keyUsed.contains(k));
            
            if (isSensitive) {
              findings.add(Finding(
                id: 'SEC-STR-001',
                category: 'SECURITY',
                severity: 'HIGH',
                confidence: 'MEDIUM',
                title: 'Potentially Insecure Storage of Sensitive Data',
                file: relativePath,
                line: i + 1,
                evidence: lineContent.trim(),
                description: 'Detected a storage write operation storing key "$keyUsed" in unencrypted storage (SharedPreferences, Hive, or local DB).',
                risk: 'Storing authentication tokens, credentials, or session keys in plain text allows malware or physical attackers with access to the device file system to compromise the user accounts.',
                recommendation: 'Use flutter_secure_storage for sensitive keys. If using Hive, open the box with an encryption key retrieved from secure storage.',
                fixAvailable: false,
              ));
            }
          }
        }
      } catch (_) {}
    }
    return findings;
  }
}
