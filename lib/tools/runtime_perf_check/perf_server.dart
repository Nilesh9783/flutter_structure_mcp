import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'perf_dashboard_html.dart';
import 'perf_pdf_generator.dart';

import 'package:flutter_architect_mcp/services/email_service.dart';

class PerfServer {
  HttpServer? _server;
  final List<WebSocket> _sockets = [];
  bool _silent = false;
  
  // Active session metrics
  final Map<String, dynamic> _session = {
    'projectName': 'Flutter App Session',
    'startTime': DateTime.now().millisecondsSinceEpoch,
    'isRecording': true,
    'activeScreen': 'None',
    'currentRam': 0.0,
    'peakRam': 0.0,
    'apiCalls': <Map<String, dynamic>>[],
    'memoryHistory': <Map<String, dynamic>>[],
    'screenHistory': <Map<String, dynamic>>[],
  };

  void _resetSession() {
    _session['startTime'] = DateTime.now().millisecondsSinceEpoch;
    _session['isRecording'] = true;
    _session['activeScreen'] = 'None';
    _session['currentRam'] = 0.0;
    _session['peakRam'] = 0.0;
    (_session['apiCalls'] as List).clear();
    (_session['memoryHistory'] as List).clear();
    (_session['screenHistory'] as List).clear();
    _broadcastState();
  }

  Future<void> start({int port = 8080, bool silent = false}) async {
    _silent = silent;
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    if (!_silent) {
      print('🚀 Runtime Performance Server running at http://localhost:$port');
    }

    _server!.listen((HttpRequest request) async {
      // CORS configuration
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers.add('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
      request.response.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');

      if (request.method == 'OPTIONS') {
        request.response.statusCode = HttpStatus.ok;
        await request.response.close();
        return;
      }

      final path = request.uri.path;

      // WebSocket upgrading
      if (path == '/ws') {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          final socket = await WebSocketTransformer.upgrade(request);
          _sockets.add(socket);
          if (!_silent) {
            print('🔌 Dashboard client connected to WebSocket stream.');
          }
          
          // Send initial state
          socket.add(jsonEncode({
            'type': 'session_state',
            'payload': _session,
          }));

          socket.listen(
            (message) {},
            onDone: () => _sockets.remove(socket),
            onError: (_) => _sockets.remove(socket),
          );
        } else {
          request.response.statusCode = HttpStatus.badRequest;
          await request.response.close();
        }
        return;
      }

      // Serve Dashboard
      if (path == '/' && request.method == 'GET') {
        request.response
          ..headers.contentType = ContentType.html
          ..write(dashboardHtml);
        await request.response.close();
        return;
      }

      // Record Event REST API
      if (path == '/api/record' && request.method == 'POST') {
        try {
          final body = await utf8.decoder.bind(request).join();
          final data = jsonDecode(body) as Map<String, dynamic>;

          if (_session['isRecording'] == true) {
            final String type = data['type'] ?? '';
            final timestamp = data['timestamp'] ?? DateTime.now().millisecondsSinceEpoch;

            if (type == 'screen') {
              final String screenName = data['screenName'] ?? 'Unknown';
              _session['activeScreen'] = screenName;
              (_session['screenHistory'] as List).add({
                'screenName': screenName,
                'timestamp': timestamp,
              });
            } else if (type == 'network') {
              (_session['apiCalls'] as List).add({
                'method': data['method'] ?? 'GET',
                'url': data['url'] ?? '',
                'status': data['status'] ?? 200,
                'latency': data['latency'] ?? 0,
                'timestamp': timestamp,
              });
            } else if (type == 'memory') {
              final double ram = (data['ram'] as num?)?.toDouble() ?? 0.0;
              final double storage = (data['storage'] as num?)?.toDouble() ?? 0.0;
              _session['currentRam'] = ram;
              if (ram > (_session['peakRam'] as double)) {
                _session['peakRam'] = ram;
              }
              (_session['memoryHistory'] as List).add({
                'ram': ram,
                'storage': storage,
                'timestamp': timestamp,
              });
            }
            
            _broadcastState();
          }

          request.response.statusCode = HttpStatus.ok;
          request.response.write(jsonEncode({'status': 'success'}));
        } catch (e) {
          request.response.statusCode = HttpStatus.badRequest;
          request.response.write(jsonEncode({'status': 'error', 'message': e.toString()}));
        }
        await request.response.close();
        return;
      }

      // Send Email REST API
      if (path == '/api/send-email' && request.method == 'POST') {
        try {
          final body = await utf8.decoder.bind(request).join();
          final data = jsonDecode(body) as Map<String, dynamic>;

          final to = data['to'] as String?;
          final subject = data['subject'] as String? ?? 'Audit Report';
          final emailBody = data['body'] as String? ?? '';
          final pdfBase64 = data['pdfBase64'] as String?;
          final filename = data['filename'] as String? ?? 'audit-report.pdf';

          if (to == null || to.isEmpty || pdfBase64 == null || pdfBase64.isEmpty) {
            request.response.statusCode = HttpStatus.badRequest;
            request.response.write(jsonEncode({'status': 'error', 'message': 'Missing recipient "to" or PDF attachment data.'}));
          } else {
            final emailService = EmailService();
            final res = await emailService.sendReport(
              to: to,
              subject: subject,
              body: emailBody,
              pdfBase64: pdfBase64,
              filename: filename,
            );
            request.response.statusCode = HttpStatus.ok;
            request.response.write(jsonEncode(res));
          }
        } catch (e) {
          request.response.statusCode = HttpStatus.internalServerError;
          request.response.write(jsonEncode({'status': 'error', 'message': e.toString()}));
        }
        await request.response.close();
        return;
      }

      // Stop Session & Compile PDF HTML report
      if (path == '/api/stop' && request.method == 'POST') {
        _session['isRecording'] = false;
        _broadcastState();

        // Compile report
        final htmlContent = PerfPdfGenerator.generate(_session);

        // Ensure reports directory exists and save copy
        try {
          final reportsDir = Directory('reports');
          if (!reportsDir.existsSync()) {
            reportsDir.createSync();
          }
          final reportFile = File(p.join(reportsDir.path, 'runtime-performance-report.html'));
          reportFile.writeAsStringSync(htmlContent);
          if (!_silent) {
            print('💾 Runtime performance HTML report saved to: ${reportFile.path}');
          }
        } catch (_) {}

        request.response
          ..headers.contentType = ContentType.html
          ..write(htmlContent);
        await request.response.close();
        return;
      }

      // Reset Session
      if (path == '/api/reset' && request.method == 'POST') {
        _resetSession();
        request.response.statusCode = HttpStatus.ok;
        await request.response.close();
        return;
      }

      // Fallback
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
    });
  }

  void _broadcastState() {
    final payload = jsonEncode({
      'type': 'session_state',
      'payload': _session,
    });
    for (final socket in _sockets) {
      if (socket.readyState == WebSocket.open) {
        socket.add(payload);
      }
    }
  }

  Future<void> stop() async {
    for (final socket in _sockets) {
      await socket.close();
    }
    _sockets.clear();
    await _server?.close(force: true);
    if (!_silent) {
      print('🛑 Runtime Performance Server stopped.');
    }
  }
}
