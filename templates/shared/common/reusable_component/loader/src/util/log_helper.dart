import 'package:flutter/material.dart';

class LoadLogHelper {
  static bool showLog = false;

  static void log(String msg) {
    if (showLog) debugPrint("load library: $msg");
  }
}
