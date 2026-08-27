class ReportConstants {
  static const String emailSubjectTemplate = 'Audit Report: {projectName}';

  static const String emailBodyTemplate = '''
Hello,

Please find attached the security and code quality audit report for the project "{projectName}".

Audit Summary:
- Security Score: {score}/100
- Total Findings: {findingsCount}
- Detected Architecture: {architecture}
- Detected State Management: {stateManagement}

All review criteria are added in the sheet. Please check and review the attached PDF report.

Best regards,
Flutter Architect MCP Analyzer
''';

  static const String criteriaMessage = 'All review criteria added in sheet, please check and review report';

  static const String emailConfigPath = 'config/email_config.yaml';

  static const String simulatedEmailDir = 'reports/simulated_emails';
}
