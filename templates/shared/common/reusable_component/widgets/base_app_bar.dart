import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';

import '../import.dart';

PreferredSizeWidget baseAppBar({
  required BuildContext context,
  String? title,
  Color? backgroundColor,
  Color? leadingIconThemeColor,
  VoidCallback? onTapArrow,
  List<Widget>? actions,
  bool isAutomaticallyImplyLeading = false,
  bool? isNavigateBackWIthPrams = false,
  dynamic backParams,
}) {
  return AppBar(
    backgroundColor: backgroundColor,
    elevation: 0.0,
    titleSpacing: 0,
    centerTitle: false,
    iconTheme: IconThemeData(
      color: leadingIconThemeColor, //change your color here
    ),
    automaticallyImplyLeading: isAutomaticallyImplyLeading,
    actions: actions,
    title: Row(
      children: [
        InkWell(
          onTap: () {
            if(onTapArrow!=null){
              onTapArrow();
              return;
            }

            if (isNavigateBackWIthPrams ?? false) {
              context.navigatorBackWithParam(value: backParams);
            } else {
              context.navigateBack();
            }
          },
          child: Container(
            height: 30,
            width: 50,
            padding: const EdgeInsets.only(left: 20.0, right: 5),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: AppColors.isLightModeColor,
            ),
          ),
        ),
        Text(
          title ?? '',
          style: AppTextStyles.textStyle16w700(
              AppColors.isLightModeColor),
        ),
      ],
    ),
  );
}
