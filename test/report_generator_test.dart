import 'dart:io';
import 'package:test/test.dart';
import 'package:flutter_architect_mcp/reports/report_generator.dart';
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';

void main() {
  group('ReportGenerator PDF HTML Tests', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('report_generator_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('should generate all reports including pdfHtml and verify paths', () async {
      final metadata = ProjectMetadata(
        projectName: 'test_app',
        flutterVersion: '3.19.0',
        dartVersion: '3.3.0',
        dependencies: {'flutter': 'sdk', 'path': '^1.9.0'},
        devDependencies: {'test': '^1.25.0'},
        detectedArchitecture: 'Clean Architecture',
        detectedStateManagement: 'BLoC',
        detectedRouter: 'go_router',
        detectedNetwork: 'Dio',
        detectedDatabase: 'Isar',
        hasFirebase: true,
        hasAuthentication: true,
        targetPlatforms: ['android', 'ios'],
      );

      final findings = [
        Finding(
          id: 'SEC-STR-001',
          category: 'SECURITY',
          severity: 'HIGH',
          confidence: 'HIGH',
          title: 'Insecure Password Storage',
          file: 'lib/utils/common/base_bloc.dart',
          line: 497,
          evidence: 'Raw plaintext password saved to SharedPreferences',
          description: 'Insecure Password Storage: Raw plaintext password saved to SharedPreferences ( \'savedPassword\' ).',
          risk: 'Plaintext credentials can be retrieved by anyone with physical access or a backup of the device.',
          recommendation: 'Migrate user credentials to flutter_secure_storage (backed by Android Keystore and iOS Keychain).',
          fixAvailable: true,
        ),
        Finding(
          id: 'PERF-001',
          category: 'PERFORMANCE',
          severity: 'MEDIUM',
          confidence: 'HIGH',
          title: 'Controller Instantiation inside build()',
          file: 'lib/reusable_component/dropdown/coustom_dropdown.dart',
          line: 67,
          evidence: 'TextEditingController _controller = TextEditingController();',
          description: 'Instantiating controllers inside build() forces memory re-allocations on every frame render.',
          risk: 'Causes UI stutter, dropped text inputs, and lost scroll states.',
          recommendation: 'Refactor to StatefulWidget lifecycle and initialize/dispose controller in initState/dispose.',
          fixAvailable: false,
        ),
      ];

      final reporter = ReportGenerator(
        projectPath: tempDir.path,
        findings: findings,
        metadata: metadata,
      );

      final paths = await reporter.generateAllReports();

      expect(paths, contains('json'));
      expect(paths, contains('markdown'));
      expect(paths, contains('html'));
      expect(paths, contains('pdfHtml'));

      final jsonPath = paths['json']!;
      final mdPath = paths['markdown']!;
      final htmlPath = paths['html']!;
      final pdfHtmlPath = paths['pdfHtml']!;

      expect(File(jsonPath).existsSync(), isTrue);
      expect(File(mdPath).existsSync(), isTrue);
      expect(File(htmlPath).existsSync(), isTrue);
      expect(File(pdfHtmlPath).existsSync(), isTrue);

      final pdfContent = await File(pdfHtmlPath).readAsString();
      expect(pdfContent, contains('PDF Download View'));
      expect(pdfContent, contains('Code Quality & Security Audit Report'));
      expect(pdfContent, contains('Insecure Password Storage'));
      expect(pdfContent, contains('Controller Instantiation inside build()'));
      expect(pdfContent, contains('test_app'));
      expect(pdfContent, contains('html2pdf().from(element).set(opt).save()'));
    });
  });
}
