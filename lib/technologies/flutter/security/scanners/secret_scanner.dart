import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';

class SecretScanner {
  final List<RegExp> _patterns = [
    // AWS Client ID/Secret
    RegExp(r'([^A-Z0-9_-]|^)(AKIA[0-9A-Z]{16})([^A-Z0-9_-]|$)', caseSensitive: true),
    // Generic Secret or private key
    RegExp(r'-----BEGIN (?:RSA |EC |DSA |GPG |)?PRIVATE KEY-----'),
    // Google API key (sometimes public, but let's check)
    RegExp(r'AIza[0-9A-Za-z-_]{35}'),
    // Firebase credentials block / project_id/private_key
    RegExp(r'"private_key"\s*:\s*"[^"]+"'),
    // GitHub token
    RegExp(r'gh[opr]_[0-9a-zA-Z]{36,255}'),
    // Slack token
    RegExp(r'xox[bapr]-[0-9a-zA-Z]{10,200}'),
    // JWT token pattern
    RegExp(r'eyJhbGciOi[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+/=]*'),
    RegExp(r"""(?:api_key|apikey|secret_key|secretkey|access_token|oauth_token|aws_secret|db_password)\s*[:=]\s*["']([^"']{8,})["']""", caseSensitive: false),
  ];

  static const List<String> _scanExtensions = [
    '.dart', '.yaml', '.yml', '.json', '.xml', '.properties', '.gradle', '.kt', '.swift', '.m', '.plist'
  ];

  Future<List<Finding>> scan(Directory projectDir) async {
    final findings = <Finding>[];

    await for (final entity in projectDir.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;

      final relativePath = p.relative(entity.path, from: projectDir.path);
      // Skip ignorable folders
      if (relativePath.startsWith('.git/') ||
          relativePath.startsWith('.dart_tool/') ||
          relativePath.startsWith('build/') ||
          relativePath.startsWith('reports/') ||
          relativePath.startsWith('test/') ||
          relativePath.contains('/.symlinks/') ||
          relativePath.contains('/reports/') ||
          relativePath.contains('/test/')) {
        continue;
      }

      final ext = p.extension(entity.path).toLowerCase();
      if (!_scanExtensions.contains(ext)) continue;

      // Check cache first
      if (FileCache.isCached(entity)) {
        findings.addAll(FileCache.getFindings(entity).where((f) => f.category == 'SECURITY'));
        continue;
      }

      final fileFindings = <Finding>[];
      try {
        final content = await entity.readAsString();
        final lines = content.split('\n');
        final fileName = p.basename(entity.path).toLowerCase();
        final isFirebaseClientConfig = fileName == 'google-services.json' ||
            fileName == 'googleservice-info.plist' ||
            fileName == 'firebase_options.dart';

        for (int i = 0; i < lines.length; i++) {
          final lineContent = lines[i];
          for (final pattern in _patterns) {
            if (isFirebaseClientConfig && pattern.pattern.contains('AIza')) {
              continue;
            }
            final matches = pattern.allMatches(lineContent);
            for (final match in matches) {
              final rawSecret = match.group(0) ?? '';
              final masked = _maskSecret(rawSecret);

              fileFindings.add(Finding(
                id: 'SEC-SEC-001',
                category: 'SECURITY',
                severity: 'HIGH',
                confidence: 'HIGH',
                title: 'Potential Hardcoded Secret / API Key Detected',
                file: relativePath,
                line: i + 1,
                evidence: masked,
                description: 'A line matching typical credential/secret patterns was found in $relativePath.',
                risk: 'Storing credentials in clear text within code or resource files can result in security breaches if the code is decompiled or leaked.',
                recommendation: 'Use secure environment variables or a secure key store (such as flutter_secure_storage) to retrieve configurations dynamically. Remove hardcoded values from source control.',
                fixAvailable: false,
              ));
            }
          }
        }
        
        if (fileFindings.isNotEmpty) {
          findings.addAll(fileFindings);
        }
      } catch (_) {
        // Skip unreadable binary/corrupt files
      }
    }
    return findings;
  }

  String _maskSecret(String secret) {
    if (secret.length <= 8) return '[MASKED]';
    return '${secret.substring(0, 4)}...[MASKED]...${secret.substring(secret.length - 4)}';
  }
}
