import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_architect_mcp/core/constants/report_constants.dart';
import 'package:flutter_architect_mcp/utils/path_utils.dart';
import 'yaml_service.dart';

class EmailService {
  final YamlService _yamlService = YamlService();
  bool forceSimulation = false;

  Future<bool> _convertHtmlToPdf(String htmlPath, String pdfPath) async {
    try {
      final chromePath = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
      if (!File(chromePath).existsSync()) {
        return false;
      }
      final result = await Process.run(chromePath, [
        '--headless',
        '--disable-gpu',
        '--no-sandbox',
        '--print-to-pdf=$pdfPath',
        htmlPath,
      ]);
      return result.exitCode == 0 && File(pdfPath).existsSync();
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> sendReport({
    required String to,
    required String subject,
    required String body,
    required String pdfBase64,
    required String filename,
  }) async {
    // 1. Resolve project root
    String projectRoot = PathUtils.resolvePackageRoot();
    try {
      Directory(projectRoot).createSync(recursive: true);
    } catch (_) {}

    final tempDir = Directory.systemTemp;
    
    // Check if source is HTML and try converting to PDF
    final isHtmlSource = filename.endsWith('.html');
    String finalFilename = filename;
    String finalBase64 = pdfBase64;
    File? tempPdfFile;
    File? tempHtmlFile;

    if (isHtmlSource) {
      try {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        tempHtmlFile = File(p.join(tempDir.path, 'temp_${timestamp}_source.html'));
        tempHtmlFile.writeAsBytesSync(base64Decode(pdfBase64));
        
        final targetPdfPath = p.join(tempDir.path, 'temp_${timestamp}_converted.pdf');
        final converted = await _convertHtmlToPdf(tempHtmlFile.path, targetPdfPath);
        
        if (converted) {
          tempPdfFile = File(targetPdfPath);
          finalBase64 = base64Encode(tempPdfFile.readAsBytesSync());
          finalFilename = filename.replaceAll('.html', '.pdf');
        }
      } catch (e) {
        print('⚠️ PDF conversion failed: $e. Reverting to original HTML file.');
      }
    }

    final tempAttachmentFile = File(p.join(tempDir.path, 'temp_${DateTime.now().millisecondsSinceEpoch}_$finalFilename'));
    
    // Primarily Try Sending Via Mailman (User's local MCP tool)
    if (!forceSimulation) {
      try {
        tempAttachmentFile.writeAsBytesSync(base64Decode(finalBase64));
        
        final mailmanClient = _MailmanClient();
        final mailmanResult = await mailmanClient.sendMail(
          to: to,
          subject: subject,
          body: body,
          attachments: [tempAttachmentFile.absolute.path],
        );

        // Clean up temp files
        try {
          if (tempAttachmentFile.existsSync()) {
            tempAttachmentFile.deleteSync();
          }
          if (tempHtmlFile != null && tempHtmlFile.existsSync()) {
            tempHtmlFile.deleteSync();
          }
          if (tempPdfFile != null && tempPdfFile.existsSync()) {
            tempPdfFile.deleteSync();
          }
        } catch (_) {}

        // If Mailman started and completed, return its outcome (success or configuration error)
        if (mailmanResult['status'] == 'success' || 
            mailmanResult['message']?.contains('Mailman Tool Error') == true || 
            mailmanResult['message']?.contains('Mailman MCP Error') == true || 
            mailmanResult['message']?.contains('Mailman Error') == true) {
          return mailmanResult;
        }
      } catch (e) {
        print('⚠️ Mailman CLI not available or failed: $e. Falling back to SMTP/Simulation...');
        try {
          if (tempAttachmentFile.existsSync()) {
            tempAttachmentFile.deleteSync();
          }
        } catch (_) {}
      }
    }

    // 2. SMTP Delivery Fallback
    final configPath = p.join(projectRoot, ReportConstants.emailConfigPath);
    final configMap = _yamlService.loadYamlFile(configPath);
    final smtpConfig = configMap['smtp'];

    if (smtpConfig is Map && smtpConfig.isNotEmpty) {
      final host = smtpConfig['host'] as String?;
      final port = (smtpConfig['port'] as num?)?.toInt() ?? 465;
      final username = smtpConfig['username'] as String?;
      final password = smtpConfig['password'] as String?;
      final secure = smtpConfig['secure'] as bool? ?? true;
      final fromAddress = smtpConfig['from_address'] as String? ?? username ?? 'noreply@flutterarchitect.com';
      final fromName = smtpConfig['from_name'] as String? ?? 'Flutter Architect MCP';

      if (host != null && host.isNotEmpty && username != null && password != null) {
        try {
          final smtpServer = SmtpServer(
            host,
            port: port,
            ssl: secure,
            username: username,
            password: password,
          );

          final pdfBytes = base64Decode(finalBase64);
          final smtpTempFile = File(p.join(tempDir.path, 'temp_smtp_${DateTime.now().millisecondsSinceEpoch}_$finalFilename'));
          smtpTempFile.writeAsBytesSync(pdfBytes);

          final attachment = FileAttachment(smtpTempFile)
            ..contentType = finalFilename.endsWith('.html') ? 'text/html' : 'application/pdf'
            ..fileName = finalFilename;

          final message = Message()
            ..from = Address(fromAddress, fromName)
            ..recipients.add(to)
            ..subject = subject
            ..text = body
            ..attachments.add(attachment);

          await send(message, smtpServer);

          try {
            if (smtpTempFile.existsSync()) {
              smtpTempFile.deleteSync();
            }
            if (tempHtmlFile != null && tempHtmlFile.existsSync()) {
              tempHtmlFile.deleteSync();
            }
            if (tempPdfFile != null && tempPdfFile.existsSync()) {
              tempPdfFile.deleteSync();
            }
          } catch (_) {}
          print('✉️ [Email Sent] Successfully sent audit report to $to via SMTP.');
          return {
            'status': 'success',
            'mode': 'smtp',
            'message': 'Email successfully sent to $to via SMTP.',
          };
        } catch (e) {
          print('❌ [SMTP Error] Failed to send email via SMTP: $e. Falling back to simulation mode...');
        }
      }
    }

    // 3. Simulation Mode Fallback
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final simulatedDir = Directory(p.join(projectRoot, ReportConstants.simulatedEmailDir));
    if (!simulatedDir.existsSync()) {
      simulatedDir.createSync(recursive: true);
    }

    final htmlLogPath = p.join(simulatedDir.path, 'email_$timestamp.html');
    final pdfAttachmentPath = p.join(simulatedDir.path, 'attachment_$timestamp.pdf');

    // Decode and save PDF
    final pdfBytes = base64Decode(finalBase64);
    File(pdfAttachmentPath).writeAsBytesSync(pdfBytes);

    // Save HTML Log
    final relativePdfLink = 'attachment_$timestamp.pdf';
    final htmlContent = '''<!DOCTYPE html>
<html>
<head>
    <title>Simulated Email - Audit Report</title>
    <style>
        body { font-family: sans-serif; line-height: 1.5; color: #333; max-width: 600px; margin: 40px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }
        h2 { color: #2563eb; border-bottom: 2px solid #2563eb; padding-bottom: 8px; }
        .meta { background: #f8fafc; padding: 12px; border-radius: 6px; font-size: 14px; border: 1px solid #e2e8f0; margin-bottom: 20px; }
        .body { white-space: pre-wrap; font-size: 15px; }
        .attachment { background: #eff6ff; border: 1px solid #bfdbfe; color: #1e3a8a; padding: 10px; border-radius: 6px; display: inline-block; text-decoration: none; font-weight: bold; margin-top: 20px; }
    </style>
</head>
<body>
    <h2>✉️ [SIMULATED EMAIL SENT]</h2>
    <div class="meta">
        <strong>To:</strong> $to<br>
        <strong>Subject:</strong> $subject<br>
        <strong>Date:</strong> ${DateTime.now().toLocal()}<br>
    </div>
    <div class="body">$body</div>
    <a href="$relativePdfLink" class="attachment" download="$finalFilename">📎 Download Attachment ($finalFilename)</a>
</body>
</html>
''';

    File(htmlLogPath).writeAsStringSync(htmlContent);
    try {
      if (tempHtmlFile != null && tempHtmlFile.existsSync()) {
        tempHtmlFile.deleteSync();
      }
      if (tempPdfFile != null && tempPdfFile.existsSync()) {
        tempPdfFile.deleteSync();
      }
    } catch (_) {}

    print('✉️ [Simulated Email Sent] To: $to, Subject: $subject');
    print('   -> Saved simulated email log to: $htmlLogPath');
    print('   -> Saved attachment PDF to: $pdfAttachmentPath');

    return {
      'status': 'success',
      'mode': 'simulated',
      'message': 'Email successfully simulated! Saved email log to reports/simulated_emails/email_$timestamp.html and attachment to reports/simulated_emails/attachment_$timestamp.pdf',
      'logPath': htmlLogPath,
      'attachmentPath': pdfAttachmentPath,
    };
  }
}

class _MailmanClient {
  Future<Map<String, dynamic>> sendMail({
    required String to,
    required String subject,
    required String body,
    required List<String> attachments,
  }) async {
    Process? process;
    final exe = PathUtils.findMailmanExecutable();
    try {
      process = await Process.start(exe, []);
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Mailman CLI is not installed or not found in system PATH. Ensure "@integratex/mailman" is installed globally.',
      };
    }

    final completer = Completer<Map<String, dynamic>>();
    final lines = process.stdout.transform(utf8.decoder).transform(const LineSplitter());
    
    int step = 0; // 0: initialize, 2: draft_email, 3: confirm_send
    String? draftId;

    final subscription = lines.listen((line) {
      try {
        final decoded = jsonDecode(line) as Map<String, dynamic>;
        final id = decoded['id'];
        final error = decoded['error'];
        final result = decoded['result'] as Map<String, dynamic>?;

        if (error != null) {
          if (!completer.isCompleted) {
            completer.complete({
              'status': 'error',
              'message': 'Mailman MCP Error: ${error['message'] ?? error}',
            });
          }
          return;
        }

        if (result != null && result['isError'] == true) {
          final content = result['content'] as List?;
          final errorMsg = (content != null && content.isNotEmpty) ? content[0]['text'] : 'Unknown tool error';
          if (!completer.isCompleted) {
            completer.complete({
              'status': 'error',
              'message': 'Mailman Tool Error: $errorMsg',
            });
          }
          return;
        }

        if (step == 0) {
          // Handshake initialize response received, send initialized notification
          step = 1;
          final initNotification = {
            "jsonrpc": "2.0",
            "method": "notifications/initialized"
          };
          process!.stdin.writeln(jsonEncode(initNotification));

          // Send draft_email request
          step = 2;
          final draftRequest = {
            "jsonrpc": "2.0",
            "id": 2,
            "method": "tools/call",
            "params": {
              "name": "draft_email",
              "arguments": {
                "to": to,
                "subject": subject,
                "body": body,
                "attachments": attachments,
              }
            }
          };
          process.stdin.writeln(jsonEncode(draftRequest));
        } else if (step == 2 && id == 2) {
          // draft_email response received
          final content = result?['content'] as List?;
          if (content == null || content.isEmpty) {
            if (!completer.isCompleted) {
              completer.complete({
                'status': 'error',
                'message': 'Invalid response from draft_email: missing content.',
              });
            }
            return;
          }

          final text = content[0]['text'] as String?;
          if (text == null || text.isEmpty) {
            if (!completer.isCompleted) {
              completer.complete({
                'status': 'error',
                'message': 'Invalid response from draft_email: empty text.',
              });
            }
            return;
          }

          final draftDetails = jsonDecode(text) as Map<String, dynamic>;
          
          if (draftDetails.containsKey('code') && draftDetails.containsKey('message')) {
            if (!completer.isCompleted) {
              completer.complete({
                'status': 'error',
                'message': 'Mailman Error: ${draftDetails['message']}',
              });
            }
            return;
          }

          draftId = draftDetails['draftId'] as String?;
          if (draftId == null) {
            if (!completer.isCompleted) {
              completer.complete({
                'status': 'error',
                'message': 'Failed to retrieve draft ID from preview.',
              });
            }
            return;
          }

          // Call confirm_send
          step = 3;
          final confirmRequest = {
            "jsonrpc": "2.0",
            "id": 3,
            "method": "tools/call",
            "params": {
              "name": "confirm_send",
              "arguments": {
                "draftId": draftId,
                "confirm": true,
              }
            }
          };
          process!.stdin.writeln(jsonEncode(confirmRequest));
        } else if (step == 3 && id == 3) {
          // confirm_send response received
          final content = result?['content'] as List?;
          if (content == null || content.isEmpty) {
            if (!completer.isCompleted) {
              completer.complete({
                'status': 'error',
                'message': 'Invalid response from confirm_send: missing content.',
              });
            }
            return;
          }

          final text = content[0]['text'] as String?;
          if (text == null || text.isEmpty) {
            if (!completer.isCompleted) {
              completer.complete({
                'status': 'error',
                'message': 'Invalid response from confirm_send: empty text.',
              });
            }
            return;
          }

          final confirmDetails = jsonDecode(text) as Map<String, dynamic>;
          if (confirmDetails.containsKey('code') && confirmDetails.containsKey('message')) {
            if (!completer.isCompleted) {
              completer.complete({
                'status': 'error',
                'message': 'Mailman Error: ${confirmDetails['message']}',
              });
            }
            return;
          }

          if (!completer.isCompleted) {
            completer.complete({
              'status': 'success',
              'mode': 'mailman',
              'message': 'Email successfully sent via Mailman!',
            });
          }
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.complete({
            'status': 'error',
            'message': 'Error processing JSON-RPC message: $e',
          });
        }
      }
    });

    // Start Handshake by sending initialize request
    final initRequest = {
      "jsonrpc": "2.0",
      "id": 1,
      "method": "initialize",
      "params": {
        "protocolVersion": "2024-11-05",
        "capabilities": {},
        "clientInfo": {"name": "flutter-mcp-client", "version": "1.0.0"}
      }
    };
    process.stdin.writeln(jsonEncode(initRequest));

    // Wait with a timeout
    final Future<Map<String, dynamic>> timeout = Future.delayed(Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete({
          'status': 'error',
          'message': 'Timeout waiting for Mailman response. Ensure Mailman is configured correctly and logged in.',
        });
      }
      return <String, dynamic>{};
    });

    final Map<String, dynamic> res = await Future.any<Map<String, dynamic>>([completer.future, timeout]);
    subscription.cancel();
    process.kill();
    return res;
  }
}
