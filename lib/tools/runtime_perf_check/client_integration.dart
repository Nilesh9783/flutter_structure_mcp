class ClientIntegrationCode {
  static const String dioInterceptor = """
import 'package:dio/dio.dart';

/// Dio Interceptor to log network requests to the runtime performance server.
/// 
/// Add this to your Dio client instance:
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(PerfNetworkInterceptor(serverUrl: 'http://localhost:8080/api/record'));
/// ```
class PerfNetworkInterceptor extends Interceptor {
  final String serverUrl;
  final Map<RequestOptions, DateTime> _startTimes = {};

  PerfNetworkInterceptor({required this.serverUrl});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTimes[options] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = _startTimes.remove(response.requestOptions);
    if (startTime != null) {
      final latency = DateTime.now().difference(startTime).inMilliseconds;
      _sendMetric({
        'type': 'network',
        'method': response.requestOptions.method,
        'url': response.requestOptions.uri.toString(),
        'status': response.statusCode ?? 200,
        'latency': latency,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = _startTimes.remove(err.requestOptions);
    if (startTime != null) {
      final latency = DateTime.now().difference(startTime).inMilliseconds;
      _sendMetric({
        'type': 'network',
        'method': err.requestOptions.method,
        'url': err.requestOptions.uri.toString(),
        'status': err.response?.statusCode ?? 500,
        'latency': latency,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
    super.onError(err, handler);
  }

  void _sendMetric(Map<String, dynamic> data) async {
    try {
      await Dio().post(serverUrl, data: data);
    } catch (_) {}
  }
}
""";

  static const String navigatorObserver = """
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// Navigator Observer to track screen routing changes in real time.
/// 
/// Register this in your MaterialApp navigation observer:
/// ```dart
/// MaterialApp(
///   navigatorObservers: [
///     PerfNavigatorObserver(serverUrl: 'http://localhost:8080/api/record'),
///   ],
///   ...
/// );
/// ```
class PerfNavigatorObserver extends NavigatorObserver {
  final String serverUrl;

  PerfNavigatorObserver({required this.serverUrl});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      _sendMetric({
        'type': 'screen',
        'screenName': route.settings.name,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  void _sendMetric(Map<String, dynamic> data) async {
    try {
      await Dio().post(serverUrl, data: data);
    } catch (_) {}
  }
}
""";

  static const String memoryTracker = """
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

/// Starts a periodic background timer to profile and stream memory (RAM)
/// and storage space utilization.
/// 
/// Invoke this at application launch:
/// ```dart
/// void main() {
///   runApp(const MyApp());
///   startRuntimePerformanceTracker(serverUrl: 'http://localhost:8080/api/record');
/// }
/// ```
void startRuntimePerformanceTracker({required String serverUrl, Duration interval = const Duration(seconds: 4)}) {
  Timer.periodic(interval, (timer) async {
    // Heap RAM consumption in MB (RSS)
    final double ramMb = ProcessInfo.currentRss / (1024 * 1024);

    // Storage consumption estimation in MB (e.g. database size)
    double storageMb = 0.0;
    try {
      // You can estimate DB sizes or check files inside application document directories:
      // final docDir = await getApplicationDocumentsDirectory();
      // storageMb = _calculateDirectorySize(docDir) / (1024 * 1024);
      storageMb = 1.8; // Fallback mock value
    } catch (_) {}

    try {
      await Dio().post(serverUrl, data: {
        'type': 'memory',
        'ram': ramMb,
        'storage': storageMb,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (_) {}
  });
}
""";
}
