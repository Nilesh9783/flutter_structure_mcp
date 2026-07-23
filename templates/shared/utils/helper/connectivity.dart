import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  final StreamController<dynamic> controller =
      StreamController<dynamic>.broadcast();

  Stream<dynamic> get myStream => controller.stream;

  Future<void> initialise() async {
    final List<ConnectivityResult> result =
        await connectivity.checkConnectivity();
    checkStatus(result.first);
    connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      checkStatus(result.first);
    });
  }

  Future<void> checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('https://www.google.com/');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    // ignore: always_specify_types
    final dynamic data = {result: isOnline};
    controller.sink.add(data);
  }

  void disposeStream() => controller.close();
}
