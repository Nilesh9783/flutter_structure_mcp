import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

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
              final lineEvidence = lineContent.replaceAll(rawSecret, masked).trim();

              final finding = Finding(
                id: 'SEC-SEC-001',
                category: 'SECURITY',
                severity: 'HIGH',
                confidence: 'HIGH',
                title: 'Potential Hardcoded Secret / API Key Detected',
                file: relativePath,
                line: i + 1,
                evidence: lineEvidence.isNotEmpty ? lineEvidence : masked,
                description: 'Hardcoded credential or API secret pattern detected in $relativePath at line ${i + 1}.',
                risk: 'Storing credentials in clear text within code or resource files can result in security breaches if the code is decompiled or leaked.',
                recommendation: 'Extract secrets to secure environment variables (.env via flutter_dotenv) or a secure key store (flutter_secure_storage). Remove hardcoded values from source code.',
                fixAvailable: false,
              );

              fileFindings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
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
