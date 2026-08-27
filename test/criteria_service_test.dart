import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_architect_mcp/services/criteria_service.dart';
import 'package:flutter_architect_mcp/core/models/finding.dart';

void main() {
  group('CriteriaService Tests', () {
    late CriteriaService criteriaService;

    setUp(() {
      criteriaService = CriteriaService();
    });

    test('CriteriaService is a singleton', () {
      final instance1 = CriteriaService();
      final instance2 = CriteriaService();
      expect(identical(instance1, instance2), isTrue);
    });

    test('initialize loads local yaml and sheet criteria', () async {
      await criteriaService.initialize();

      // Check default criteria was parsed
      expect(criteriaService.defaultCriteria, isNotEmpty);
      expect(criteriaService.maxLinesOfCode, equals(500));

      // Check sheet criteria was loaded (either fetched, cached, or fallback)
      expect(criteriaService.sheetCriteria, isNotEmpty);
      
      // Each sheet criteria entry should have Category and Analysis Criteria
      final firstEntry = criteriaService.sheetCriteria.first;
      expect(firstEntry.containsKey('Category'), isTrue);
      expect(firstEntry.containsKey('Analysis Criteria'), isTrue);
      expect(firstEntry['Category'], equals('Code Quality'));
    });

    test('getCriteriaObservationMessage formats observation output correctly', () async {
      await criteriaService.initialize();
      final msg = criteriaService.getCriteriaObservationMessage();

      expect(msg, contains('📋 ANALYSIS CRITERIA OBSERVED FOR YOUR PROJECT:'));
      expect(msg, contains('Source: ${CriteriaService.sheetUrl}'));
      expect(msg, contains('🔹 Code Quality'));
      expect(msg, contains('🔹 Security'));
      expect(msg, contains('Max Lines of Code per file: 500'));
    });

    test('Local cached file exists post-initialization', () {
      final scriptUri = Platform.script;
      final scriptPath = scriptUri.isScheme('file') ? scriptUri.toFilePath() : '.';
      String projectRoot = p.dirname(p.dirname(scriptPath));
      if (!Directory(p.join(projectRoot, 'config')).existsSync()) {
        projectRoot = Directory.current.path;
      }
      final cacheCsvPath = p.join(projectRoot, 'config', 'cached_criteria.csv');
      final cacheFile = File(cacheCsvPath);
      expect(cacheFile.existsSync(), isTrue);
    });

    test('getRuleThreshold retrieves thresholds dynamically from sheet', () async {
      await criteriaService.initialize();

      // CQ-001 has "file_code_loc > 500" -> should extract 500.0
      expect(criteriaService.getRuleThreshold('CQ-001'), equals(500.0));
      // QAL-001 (maps to CQ-001) -> should resolve and return 500.0
      expect(criteriaService.getRuleThreshold('QAL-001'), equals(500.0));

      // CQ-002 has "class_code_loc > 300" -> should extract 300.0
      expect(criteriaService.getRuleThreshold('CQ-002'), equals(300.0));
    });

    test('enrichFindingWithSheet dynamically enriches finding details', () async {
      await criteriaService.initialize();

      final initialFinding = Finding(
        id: 'QAL-001',
        category: 'CODE_QUALITY',
        severity: 'LOW',
        confidence: 'LOW',
        title: 'Original Title',
        file: 'lib/main.dart',
        line: 10,
        evidence: 'original evidence',
        description: 'original description',
        risk: 'original risk',
        recommendation: 'original recommendation',
      );

      final enriched = criteriaService.enrichFindingWithSheet(initialFinding);

      // Check fields mapped to CQ-001 in the sheet
      expect(enriched.id, equals('QAL-001'));
      expect(enriched.title, equals('Large File LOC'));
      expect(enriched.severity, equals('MEDIUM')); // From sheet Severity
      expect(enriched.confidence, equals('HIGH'));  // From sheet Confidence
      expect(enriched.recommendation, equals('Split large files into smaller focused units'));
    });
  });
}
