import 'dart:io';
import 'package:flutter_architect_mcp/tools/runtime_perf_check/perf_server.dart';

Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    print('Usage: dart run lib/tools/scanners_and_audit_reports/run_runtime_perf.dart [options]');
    print('Options:');
    print('  --port <port>   Port to run the dashboard server on (default: 8080)');
    return;
  }

  int port = 8080;
  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--port' && i + 1 < args.length) {
      port = int.tryParse(args[++i]) ?? 8080;
    }
  }

  final server = PerfServer();
  await server.start(port: port);

  print('----------------------------------------------------');
  print('📊 RUNTIME PERFORMANCE MONITOR STARTED');
  print('👉 Open in browser: http://localhost:$port');
  print('👉 Feed API Logs to: http://localhost:$port/api/record');
  print('Press Ctrl+C to terminate the server.');
  print('----------------------------------------------------');

  // Keep process alive
  ProcessSignal.sigint.watch().listen((signal) async {
    await server.stop();
    exit(0);
  });
}
