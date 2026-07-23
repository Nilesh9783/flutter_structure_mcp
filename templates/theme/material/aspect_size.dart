import 'package:flutter/material.dart';

/// Give size as per ratio which is used in app design
class AspectSize {
  static const int designWidth = 414;

  static double getWithSize(
      {required BuildContext context, required double sizeConstant}) {
    return sizeConstant != 0.0
        ? ((MediaQuery.of(context).size.width * sizeConstant) / designWidth)
        : 0.0;
  }

  static double getScreenWidth({required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeightWithSize(
      {required BuildContext context, required double sizeConstant}) {
    return sizeConstant != 0.0
        ? ((MediaQuery.of(context).size.height * sizeConstant) /
            MediaQuery.of(context).size.height)
        : 0.0;
  }

  static double getHeight(
      {required BuildContext context, required double sizeConstant}) {
    return MediaQuery.of(context).size.height;
  }
}
