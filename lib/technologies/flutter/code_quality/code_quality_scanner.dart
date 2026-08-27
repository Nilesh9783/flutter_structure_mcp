import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/core/filesystem/file_cache.dart';
import 'package:flutter_architect_mcp/services/criteria_service.dart';

class CodeQualityScanner {
  // Pattern to detect TODO/FIXME comments
  static final RegExp _todoPattern = RegExp(
    r'//\s*(?:TODO|FIXME)\s*[:\s](.*)',
    caseSensitive: false,
  );

  // Pattern to find database queries or network requests in UI files
  static final RegExp _dbInUiPattern = RegExp(
    r'(?:db|database|isar|hive|drift)\.(?:rawQuery|query|insert|update|delete|put|get)\b',
    caseSensitive: false,
  );

  Future<List<Finding>> scan(Directory projectDir) async {
    final findings = <Finding>[];
    
    final criteriaService = CriteriaService();
    await criteriaService.initialize();
    final maxLoc = criteriaService.maxLinesOfCode;
    final codeQualityConf = criteriaService.defaultCriteria['code_quality'];
    final allowTodo = codeQualityConf is Map ? (codeQualityConf['allow_todo_comments'] ?? false) : false;

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
        findings.addAll(FileCache.getFindings(entity).where((f) => f.category == 'CODE_QUALITY'));
        continue;
      }

      try {
        final content = await entity.readAsString();
        final lines = content.split('\n');

        // 1. Check file size (long files)
        if (lines.length > maxLoc) {
          findings.add(Finding(
            id: 'QAL-001',
            category: 'CODE_QUALITY',
            severity: 'LOW',
            confidence: 'HIGH',
            title: 'Excessively Long File (Class Size)',
            file: relativePath,
            line: 1,
            evidence: 'Lines count: ${lines.length}',
            description: 'The file $relativePath is longer than $maxLoc lines.',
            risk: 'Large files indicate bloated classes that violate the Single Responsibility Principle, making maintaining, testing, and understanding the code difficult.',
            recommendation: 'Break down the class or widgets into smaller, modular helper components or service classes.',
            fixAvailable: false,
          ));
        }

        // 2. Check for TODO / FIXME comments
        if (!allowTodo) {
          for (int i = 0; i < lines.length; i++) {
            final lineContent = lines[i];
            final match = _todoPattern.firstMatch(lineContent);
            if (match != null) {
              final todoText = match.group(1)?.trim() ?? '';
              findings.add(Finding(
                id: 'QAL-002',
                category: 'CODE_QUALITY',
                severity: 'LOW',
                confidence: 'HIGH',
                title: 'Pending TODO / FIXME Comment',
                file: relativePath,
                line: i + 1,
                evidence: lineContent.trim(),
                description: 'Found a developer note: "$todoText"',
                risk: 'Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.',
                recommendation: 'Address the TODO item or track it in your team\'s issue management system.',
                fixAvailable: false,
              ));
            }
          }
        }

        // 3. Architecture violations (DB / API calls directly in UI widgets)
        final isUiFile = relativePath.contains('/views/') ||
            relativePath.contains('/screens/') ||
            relativePath.contains('/widgets/') ||
            relativePath.endsWith('_screen.dart') ||
            relativePath.endsWith('_page.dart') ||
            relativePath.endsWith('_widget.dart');

        if (isUiFile) {
          // Check for DB references
          if (_dbInUiPattern.hasMatch(content)) {
            findings.add(Finding(
              id: 'QAL-ARC-001',
              category: 'CODE_QUALITY',
              severity: 'HIGH',
              confidence: 'HIGH',
              title: 'Database Access Performed Inside UI Layer',
              file: relativePath,
              line: _findLine(lines, '.'),
              evidence: 'Direct DB command within UI widget',
              description: 'The UI file $relativePath executes direct query, write or access commands on a database.',
              risk: 'Direct database execution from widgets violates architectural segregation, resulting in high coupling and rendering UI testing impossible.',
              recommendation: 'Delegate database actions to a Repository or Data Source provider class.',
              fixAvailable: false,
            ));
          }

          // Check for direct raw HTTP/Dio references in UI
          if (content.contains('dio.get(') || content.contains('http.get(') || content.contains('dio.post(')) {
            findings.add(Finding(
              id: 'QAL-ARC-002',
              category: 'CODE_QUALITY',
              severity: 'HIGH',
              confidence: 'HIGH',
              title: 'Direct Network Call Performed Inside UI Layer',
              file: relativePath,
              line: _findLine(lines, 'get('),
              evidence: 'Direct http/dio call within UI widget',
              description: 'The UI file $relativePath executes direct http or dio request calls.',
              risk: 'Performing raw network interactions inside UI screens violates architecture boundaries and makes caching/offline syncing complex.',
              recommendation: 'Perform network queries in an API client and fetch results using view models, blocs, or services.',
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
