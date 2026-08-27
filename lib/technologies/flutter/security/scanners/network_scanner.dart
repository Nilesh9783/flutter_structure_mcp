import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';

class NetworkScanner {
  // Pattern to detect badCertificateCallback returning true
  static final RegExp _badCertCallbackPattern = RegExp(
    r'badCertificateCallback\s*=\s*\([^\)]*\)\s*=>\s*true',
    caseSensitive: false,
  );

  static final RegExp _badCertBodyPattern = RegExp(
    r'badCertificateCallback\s*=\s*\([^\)]*\)\s*\{\s*return\s+true\s*;\s*\}',
    caseSensitive: false,
  );

  // Pattern to detect http:// connections (excluding localhost)
  static final RegExp _httpUrlPattern = RegExp(
    r'http://(?!localhost|127\.0\.0\.1|10\.0\.2\.2)[a-zA-Z0-9\-\.]+',
    caseSensitive: false,
  );

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
        findings.addAll(FileCache.getFindings(entity).where((f) => f.id.startsWith('SEC-NET-')));
        continue;
      }

      try {
        final content = await entity.readAsString();
        final lines = content.split('\n');

        // Look for certificate validation bypasses
        if (_badCertCallbackPattern.hasMatch(content) || _badCertBodyPattern.hasMatch(content)) {
          findings.add(Finding(
            id: 'SEC-NET-001',
            category: 'SECURITY',
            severity: 'CRITICAL',
            confidence: 'HIGH',
            title: 'TLS/SSL Certificate Verification Bypass Detected',
            file: relativePath,
            line: 1, // Report at start of file or find exact line
            evidence: 'badCertificateCallback = ... => true',
            description: 'The code bypasses SSL/TLS certificate verification using badCertificateCallback.',
            risk: 'Bypassing TLS validation exposes the application to Man-In-The-Middle (MITM) attacks, allowing attackers to intercept or alter sensitive API traffic.',
            recommendation: 'Remove certificate bypass overrides in production builds. Use valid, trusted certificates on API servers.',
            fixAvailable: false,
          ));
        }

        // Look for http:// cleartext endpoints
        for (int i = 0; i < lines.length; i++) {
          final lineContent = lines[i];
          final match = _httpUrlPattern.firstMatch(lineContent);
          if (match != null) {
            findings.add(Finding(
              id: 'SEC-NET-002',
              category: 'SECURITY',
              severity: 'HIGH',
              confidence: 'HIGH',
              title: 'Cleartext HTTP Traffic Detected',
              file: relativePath,
              line: i + 1,
              evidence: match.group(0) ?? '',
              description: 'The application contains an unencrypted HTTP link: ${match.group(0)}.',
              risk: 'HTTP traffic is sent in clear text, making it vulnerable to eavesdropping and manipulation by third parties.',
              recommendation: 'Replace all "http://" endpoints with secure "https://" channels.',
              fixAvailable: true, // We can automatically rewrite this if user approves!
            ));
          }
        }
      } catch (_) {}
    }
    return findings;
  }
}
