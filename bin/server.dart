import 'dart:async';
import 'dart:io';
import 'package:dart_mcp/stdio.dart';
import 'package:flutter_architect_mcp/tools/mcp_server_router.dart';
import 'package:flutter_architect_mcp/tools/runtime_perf_check/perf_server.dart';

void main() async {
  // Automatically start performance server in the background silently so local report pages
  // can send emails and record metrics without needing to manually run the start tool.
  Future.microtask(() async {
    final perfServer = PerfServer();
    final ports = [8080, 8089, 8081, 9000];
    for (final port in ports) {
      try {
        await perfServer.start(port: port, silent: true);
        break; // Successfully bound!
      } catch (_) {
        // Try next port if port in use
      }
    }
  });

  final channel = stdioChannel(input: stdin, output: stdout);

  final server = McpServerRouter(channel);
  await server.done;
}
