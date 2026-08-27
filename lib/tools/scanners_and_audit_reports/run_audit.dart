import 'dart:io';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/security_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/memory/memory_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/performance/performance_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/code_quality/code_quality_scanner.dart';
import 'package:flutter_architect_mcp/reports/report_generator.dart';
import 'package:flutter_architect_mcp/core/models/finding.dart';

Future<void> main(List<String> args) async {
  final projectPath = args.isEmpty ? Directory.current.path : args[0];
  print('Auditing project at: $projectPath...');

  try {
    final meta = ProjectDetector.detectMetadata(projectPath);
    print('-------------------------------------------');
    print('Project Name: ${meta.projectName}');
    print('Flutter SDK:  ${meta.flutterVersion}');
    print('Dart SDK:     ${meta.dartVersion}');
    print('-------------------------------------------');

    print('Running scanners...');
    final findings = <Finding>[];
    findings.addAll(await SecurityEngine().runAllScans(Directory(projectPath), hasFirebase: meta.hasFirebase));
    findings.addAll(await MemoryEngine().scan(Directory(projectPath)));
    findings.addAll(await PerformanceEngine().scan(Directory(projectPath)));
    findings.addAll(await CodeQualityScanner().scan(Directory(projectPath)));

    final reporter = ReportGenerator(
      projectPath: projectPath,
      findings: findings,
      metadata: meta,
    );
    final paths = await reporter.generateAllReports();

    print('-------------------------------------------');
    print('✅ Audit completed successfully!');
    print('- Findings detected: ${findings.length}');
    print('- JSON Report:       ${paths['json']}');
    print('- Markdown Report:   ${paths['markdown']}');
    print('- HTML Report:       ${paths['html']}');
    print('- PDF HTML View:     ${paths['pdfHtml']}');
    print('-------------------------------------------');
  } catch (e) {
    print('❌ Error running audit: $e');
  }
}
