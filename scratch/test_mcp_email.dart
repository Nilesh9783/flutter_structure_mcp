import 'dart:convert';
import 'package:flutter_architect_mcp/technologies/flutter/analyzer/project_detector.dart';
import 'package:flutter_architect_mcp/technologies/flutter/security/security_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/memory/memory_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/performance/performance_engine.dart';
import 'package:flutter_architect_mcp/technologies/flutter/code_quality/code_quality_scanner.dart';
import 'package:flutter_architect_mcp/reports/report_generator.dart';
import 'package:flutter_architect_mcp/core/models/finding.dart';
import 'package:flutter_architect_mcp/services/email_service.dart';
import 'package:flutter_architect_mcp/core/constants/report_constants.dart';
import 'dart:io';

// Mock class to instantiate FlutterArchitectMcpServer and test the handle method
void main() async {
  print('Starting simulated MCP Full Flutter Audit with email...');
  final projectPath = Directory.current.path;
  const recipientEmail = 'nilesh.gurjar@indianic.com';

  try {
    final meta = ProjectDetector.detectMetadata(projectPath);
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
    final reportPdfHtmlPath = paths['pdfHtml'] ?? '';

    print('PDF HTML Report generated at: $reportPdfHtmlPath');

    if (reportPdfHtmlPath.isNotEmpty) {
      final pdfHtmlFile = File(reportPdfHtmlPath);
      if (pdfHtmlFile.existsSync()) {
        final htmlBytes = pdfHtmlFile.readAsBytesSync();
        final base64Html = base64Encode(htmlBytes);

        final score = SecurityEngine.calculateScore(findings);
        final emailSubject = ReportConstants.emailSubjectTemplate.replaceAll('{projectName}', meta.projectName);
        final emailBody = ReportConstants.emailBodyTemplate
            .replaceAll('{projectName}', meta.projectName)
            .replaceAll('{score}', score.finalScore.toString())
            .replaceAll('{findingsCount}', findings.length.toString())
            .replaceAll('{architecture}', 'MVC')
            .replaceAll('{stateManagement}', 'Provider');

        print('Sending report to $recipientEmail via EmailService...');
        final emailService = EmailService();
        final emailRes = await emailService.sendReport(
          to: recipientEmail,
          subject: emailSubject,
          body: emailBody,
          pdfBase64: base64Html,
          filename: 'security-report-${meta.projectName}.html',
        );

        print('=== EMAIL DELIVERY RESULT ===');
        print(JsonEncoder.withIndent('  ').convert(emailRes));
      }
    }
  } catch (e, stack) {
    print('Error: $e\n$stack');
  }
}
