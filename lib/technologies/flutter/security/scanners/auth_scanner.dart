import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';
import 'package:flutter_architect_mcp/utils/solution_generator.dart';

class AuthScanner {
  // Pattern to find hardcoded passwords or keys
  static final RegExp _passwordFieldPattern = RegExp(
    r"""(?:String|var|final)\s+[a-zA-Z0-9_]*(?:password|passwd|pwd|secret|token|key)[a-zA-Z0-9_]*\s*=\s*["']([^"']{4,})["']""",
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
          if (lineContent.trim().startsWith('//')) continue;

          final match = _passwordFieldPattern.firstMatch(lineContent);
          if (match != null) {
            final val = match.group(1) ?? '';
            
            // Extract the variable name to run heuristics
            final varMatch = RegExp(r'(?:String|var|final)\s+([a-zA-Z0-9_]+)', caseSensitive: false).firstMatch(lineContent);
            final varName = varMatch?.group(1) ?? '';

            if (!_isLikelyFalsePositive(varName, val)) {
              final finding = Finding(
                id: 'SEC-ATH-001',
                category: 'SECURITY',
                severity: 'HIGH',
                confidence: 'MEDIUM',
                title: 'Potential Hardcoded Password or Auth Key',
                file: relativePath,
                line: i + 1,
                evidence: lineContent.trim(),
                description: 'Found variable assignment indicating a hardcoded password or auth credential at line ${i + 1} in $relativePath.',
                risk: 'Hardcoding passwords in code makes them accessible to any attacker who extracts the application binary.',
                recommendation: 'Retrieve passwords dynamically from user input or encrypted vaults.',
                fixAvailable: false,
              );
              findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
            }
          }
        }

        // Check for logout implementation completeness with exact line
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];
          if ((line.contains('void logout(') || line.contains('Future<void> logout(')) && !line.trim().startsWith('//')) {
            // Find logout block
            final blockContent = _extractFunctionBlock(lines, i);
            if (blockContent.isNotEmpty && !blockContent.contains('clear') && !blockContent.contains('delete') && !blockContent.contains('remove')) {
              final finding = Finding(
                id: 'SEC-ATH-002',
                category: 'SECURITY',
                severity: 'MEDIUM',
                confidence: 'LOW',
                title: 'Incomplete Logout Implementation',
                file: relativePath,
                line: i + 1,
                evidence: line.trim(),
                description: 'The logout function at line ${i + 1} in $relativePath does not appear to clear local authentication tokens or cache.',
                risk: 'If local storage is not wiped during logout, another user or an attacker could potentially access the preceding session.',
                recommendation: 'Ensure SharedPreferences, FlutterSecureStorage, Hive boxes, and local caches are cleared or deleted when the user logs out.',
                fixAvailable: false,
              );
              findings.add(SolutionGenerator.attachSolutionAndPrompt(finding));
            }
          }
        }
      } catch (_) {}
    }
    return findings;
  }

  String _extractFunctionBlock(List<String> lines, int startLine) {
    final buffer = StringBuffer();
    int braceCount = 0;
    bool foundOpen = false;

    for (int i = startLine; i < lines.length && i < startLine + 40; i++) {
      final line = lines[i];
      buffer.writeln(line);
      if (line.contains('{')) {
        foundOpen = true;
        braceCount += line.split('{').length - 1;
      }
      if (line.contains('}')) {
        braceCount -= line.split('}').length - 1;
      }
      if (foundOpen && braceCount <= 0) {
        break;
      }
    }
    return buffer.toString();
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
