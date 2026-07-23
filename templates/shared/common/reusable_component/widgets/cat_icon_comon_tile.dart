import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:expense_tracker/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class CategoryIconImageCommonWidget extends StatelessWidget {
  const CategoryIconImageCommonWidget(
      {super.key,
      required this.iconIconUrl,
      required this.color,
      this.isSelcted = false});
  final Color? color;
  final String? iconIconUrl;
  final bool? isSelcted;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: context.getHeightWithSize(sizeConstant: 48),
        width: context.getWidthWithSize(sizeConstant: 48),
        // margin: const EdgeInsets.only(left: 10, right: 10, top: 24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color ?? AppColors.dark,
            border: (isSelcted ?? false)
                ? Border.all(color: AppColors.c0091FF, width: 1)
                : null),
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child:
            (iconIconUrl).loadNetworkImageSvgCatIcons(height: 20, width: 20));
  }
}
