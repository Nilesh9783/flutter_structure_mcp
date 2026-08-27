import 'dart:convert';
import 'dart:io';

void main() async {
  print('Starting mailman process...');
  final process = await Process.start('mailman', []);
  
  process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
    print('SERVER OUT: $line');
    try {
      final decoded = jsonDecode(line);
      final id = decoded['id'];
      if (id == 3) {
        // Parse draft_email response
        final text = decoded['result']['content'][0]['text'];
        final draftDetails = jsonDecode(text);
        final draftId = draftDetails['draftId'];
        print('Extracted draftId: $draftId');
        
        // Call confirm_send
        final confirmRequest = {
          "jsonrpc": "2.0",
          "id": 4,
          "method": "tools/call",
          "params": {
            "name": "confirm_send",
            "arguments": {
              "draftId": draftId,
              "confirm": true
            }
          }
        };
        print('Sending confirm_send request...');
        process.stdin.writeln(jsonEncode(confirmRequest));
      } else if (id == 4) {
        print('=== CONFIRM SEND RESPONSE RECEIVED ===');
      }
    } catch (e) {
      print('Parse error: $e');
    }
  });
  
  process.stderr.transform(utf8.decoder).listen((data) {
    print('SERVER ERR: $data');
  });

  // Handshake
  final initRequest = {
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2024-11-05",
      "capabilities": {},
      "clientInfo": {"name": "dart-client", "version": "1.0.0"}
    }
  };

  await Future.delayed(Duration(milliseconds: 500));
  process.stdin.writeln(jsonEncode(initRequest));
  
  await Future.delayed(Duration(milliseconds: 500));
  final initNotification = {
    "jsonrpc": "2.0",
    "method": "notifications/initialized"
  };
  process.stdin.writeln(jsonEncode(initNotification));

  // Call draft_email
  await Future.delayed(Duration(milliseconds: 500));
  final draftRequest = {
    "jsonrpc": "2.0",
    "id": 3,
    "method": "tools/call",
    "params": {
      "name": "draft_email",
      "arguments": {
        "to": "nilesh.gurjar@indianic.com",
        "subject": "Test Audit Report Draft",
        "body": "Hello Nilesh, this is a test draft."
      }
    }
  };
  print('Sending draft_email request...');
  process.stdin.writeln(jsonEncode(draftRequest));

  await Future.delayed(Duration(seconds: 5));
  process.kill();
}
