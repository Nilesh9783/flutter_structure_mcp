import 'package:flutter/material.dart';

import '../../utils/theme/aspect_size.dart';

Widget commonSizedBox(
    {required double sizeConstant, required BuildContext context}) {
  return SizedBox(
    height: AspectSize.getWithSize(
      context: context,
      sizeConstant: sizeConstant,
    ),
  );
}

Widget commonSizedBoxWithWidth(
    {required double sizeConstant, required BuildContext context}) {
  return SizedBox(
    width: AspectSize.getWithSize(
      context: context,
      sizeConstant: sizeConstant,
    ),
  );
}
