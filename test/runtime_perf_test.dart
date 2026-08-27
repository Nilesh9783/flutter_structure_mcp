import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:flutter_architect_mcp/tools/runtime_perf_check/perf_server.dart';

void main() {
  group('Runtime Performance Server Tests', () {
    late PerfServer server;
    final int port = 8089;
    final client = HttpClient();

    setUpAll(() async {
      server = PerfServer();
      await server.start(port: port);
    });

    tearDownAll(() async {
      await server.stop();
      client.close();
    });

    test('should serve dashboard html on GET /', () async {
      final request = await client.get('127.0.0.1', port, '/');
      final response = await request.close();
      expect(response.statusCode, equals(200));
      expect(response.headers.contentType?.mimeType, equals('text/html'));
      
      final body = await response.transform(utf8.decoder).join();
      expect(body, contains('Flutter Runtime Performance Monitor'));
    });

    test('should record and aggregate metrics on POST /api/record', () async {
      final screenPayload = {
        'type': 'screen',
        'screenName': 'ProductListPage',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      final apiPayload = {
        'type': 'network',
        'method': 'GET',
        'url': 'https://api.example.com/products',
        'status': 200,
        'latency': 120,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      final memPayload = {
        'type': 'memory',
        'ram': 48.5,
        'storage': 2.3,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      final req1 = await client.post('127.0.0.1', port, '/api/record');
      req1.headers.contentType = ContentType.json;
      req1.write(jsonEncode(screenPayload));
      final res1 = await req1.close();
      expect(res1.statusCode, equals(200));

      final req2 = await client.post('127.0.0.1', port, '/api/record');
      req2.headers.contentType = ContentType.json;
      req2.write(jsonEncode(apiPayload));
      final res2 = await req2.close();
      expect(res2.statusCode, equals(200));

      final req3 = await client.post('127.0.0.1', port, '/api/record');
      req3.headers.contentType = ContentType.json;
      req3.write(jsonEncode(memPayload));
      final res3 = await req3.close();
      expect(res3.statusCode, equals(200));
    });

    test('should stop session and return generated report on POST /api/stop', () async {
      final req = await client.post('127.0.0.1', port, '/api/stop');
      final res = await req.close();
      expect(res.statusCode, equals(200));
      expect(res.headers.contentType?.mimeType, equals('text/html'));
      
      final body = await res.transform(utf8.decoder).join();
      expect(body, contains('Flutter Runtime Performance Report'));
      expect(body, contains('ProductListPage'));
      expect(body, contains('https://api.example.com/products'));
    });
  });
}
