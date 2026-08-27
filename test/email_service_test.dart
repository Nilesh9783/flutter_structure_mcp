import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:flutter_architect_mcp/services/email_service.dart';
import 'package:flutter_architect_mcp/core/constants/report_constants.dart';

void main() {
  group('EmailService Tests', () {
    late EmailService emailService;

    setUp(() {
      emailService = EmailService()..forceSimulation = true;
      
      // Setup temporary directories if needed
      final current = Directory.current;
      final reportsDir = Directory(p.join(current.path, ReportConstants.simulatedEmailDir));
      if (!reportsDir.existsSync()) {
        reportsDir.createSync(recursive: true);
      }
    });

    test('sendReport simulated fallback works correctly', () async {
      const recipient = 'test@example.com';
      const subject = 'Test Audit Subject';
      const body = 'This is a test audit body summary';
      final dummyPdfBase64 = base64Encode(utf8.encode('PDF DUMMY CONTENT'));
      const filename = 'test-report.pdf';

      final result = await emailService.sendReport(
        to: recipient,
        subject: subject,
        body: body,
        pdfBase64: dummyPdfBase64,
        filename: filename,
      );

      // Verify response
      expect(result['status'], equals('success'));
      expect(result['mode'], equals('simulated'));
      expect(result.containsKey('logPath'), isTrue);
      expect(result.containsKey('attachmentPath'), isTrue);

      final logFile = File(result['logPath'] as String);
      final attachmentFile = File(result['attachmentPath'] as String);

      expect(logFile.existsSync(), isTrue);
      expect(attachmentFile.existsSync(), isTrue);

      // Verify file contents
      final logContent = logFile.readAsStringSync();
      expect(logContent.contains(recipient), isTrue);
      expect(logContent.contains(subject), isTrue);
      expect(logContent.contains(body), isTrue);

      final attachmentContent = attachmentFile.readAsStringSync();
      expect(attachmentContent, equals('PDF DUMMY CONTENT'));

      // Cleanup
      logFile.deleteSync();
      attachmentFile.deleteSync();
    });
  });
}
