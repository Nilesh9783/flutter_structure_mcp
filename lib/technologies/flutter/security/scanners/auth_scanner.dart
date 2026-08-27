import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';

class AuthScanner {
  // Pattern to find hardcoded passwords or keys
  static final RegExp _passwordFieldPattern = RegExp(
    r"""(?:String|var|final)\s+[a-zA-Z0-9_]*(?:password|passwd|pwd|secret|token|key)[a-zA-Z0-9_]*\s*=\s*["']([^"']{4,})["']""",
    caseSensitive: false,
  );

  // Pattern to check if logout doesn't delete/clear tokens
  static final RegExp _logoutFunctionPattern = RegExp(
    r'void\s+logout\(\)[^\{]*\{([^\}]*)\}',
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
        findings.addAll(FileCache.getFindings(entity).where((f) => f.id.startsWith('SEC-ATH-')));
        continue;
      }

      try {
        final content = await entity.readAsString();
        final lines = content.split('\n');

        // Check for hardcoded password field assignments
        for (int i = 0; i < lines.length; i++) {
          final lineContent = lines[i];
          final match = _passwordFieldPattern.firstMatch(lineContent);
          if (match != null) {
            final val = match.group(1) ?? '';
            
            // Extract the variable name to run heuristics
            final varMatch = RegExp(r'(?:String|var|final)\s+([a-zA-Z0-9_]+)', caseSensitive: false).firstMatch(lineContent);
            final varName = varMatch?.group(1) ?? '';

            if (!_isLikelyFalsePositive(varName, val)) {
              findings.add(Finding(
                id: 'SEC-ATH-001',
                category: 'SECURITY',
                severity: 'HIGH',
                confidence: 'MEDIUM', // Potential
                title: 'Potential Hardcoded Password or Auth Key',
                file: relativePath,
                line: i + 1,
                evidence: lineContent.trim(),
                description: 'Found variable assignment indicating a hardcoded password or token: "${match.group(0)}"',
                risk: 'Hardcoding passwords in code makes them accessible to any attacker who extracts the application binary.',
                recommendation: 'Retrieve passwords dynamically from user input or encrypted vaults.',
                fixAvailable: false,
              ));
            }
          }
        }

        // Check for logout implementation completeness
        final logoutMatches = _logoutFunctionPattern.allMatches(content);
        for (final match in logoutMatches) {
          final body = match.group(1) ?? '';
          if (body.trim().isEmpty || (!body.contains('clear') && !body.contains('delete') && !body.contains('remove'))) {
            findings.add(Finding(
              id: 'SEC-ATH-002',
              category: 'SECURITY',
              severity: 'MEDIUM',
              confidence: 'LOW', // Informational / Potential
              title: 'Incomplete Logout Implementation',
              file: relativePath,
              line: 1,
              evidence: 'void logout() { ... }',
              description: 'The logout function in $relativePath does not appear to clear local authentication tokens or cache.',
              risk: 'If local storage is not wiped during logout, another user or an attacker could potentially access the preceding session.',
              recommendation: 'Ensure SharedPreferences, Hive boxes, and local caches are cleared or deleted when the user logs out.',
              fixAvailable: false,
            ));
          }
        }
      } catch (_) {}
    }
    return findings;
  }

  bool _isLikelyFalsePositive(String varName, String value) {
    final nameLower = varName.toLowerCase();
    final valLower = value.toLowerCase();

    // 1. If it's a dynamic string template, it's not a hardcoded secret
    if (value.contains('\$')) {
      return true;
    }

    // 2. If the value contains spaces, it's likely a UI label, error message, or description
    if (value.contains(' ') || value.contains('?') || value.contains('!') || value.contains(':')) {
      return true;
    }

    // 3. UI-related variable suffixes are not secrets
    final uiSuffixes = ['error', 'hint', 'label', 'title', 'message', 'text', 'prompt', 'suffix', 'prefix', 'type', 'name'];
    if (uiSuffixes.any((suffix) => nameLower.endsWith(suffix))) {
      return true;
    }

    // 4. If variable name matches the value, it is just a storage key string
    final normalizedVarName = nameLower.replaceAll('_', '').replaceAll(r'$', '');
    final normalizedVal = valLower.replaceAll('_', '').replaceAll(r'$', '');
    if (normalizedVarName == normalizedVal) {
      return true;
    }

    // 5. Common generic dummy strings
    if (valLower == 'password' || valLower == 'passwd' || valLower == 'key' || valLower == 'token' || valLower == 'secret') {
      return true;
    }

    // 6. UI display strings
    if (value.contains('*')) {
      return true;
    }

    return false;
  }
}
