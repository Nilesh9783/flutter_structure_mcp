import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:expense_tracker/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';

import '../../utils/common/constants.dart';
import '../../utils/theme/colors.dart';

class CommonHeadBar extends StatelessWidget {
  final String title;
  final Function? callBackClose;
  final bool? isSkipShow;
  const CommonHeadBar(
      {super.key,
      required this.title,
      this.callBackClose,
      this.isSkipShow = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.c949A9C),
            width: context.getWidthWithSize(sizeConstant: 50.0),
            height: 5,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.textStyle16w700(AppColors.isLightModeColor),
            ).paddingOnly(top: 21.5),
            InkWell(
              onTap: () {
                if (callBackClose != null) {
                  callBackClose!();
                  context.navigateBack();
                } else {
                  context.navigateBack();
                }
              },
              child: (isSkipShow ?? false)
                  ? Text(
                      'Skip',
                      style: AppTextStyles.textStyle16w400(
                          AppColors.isLightModeColor),
                    ).paddingOnly(top: 21.5)
                  : ImgConstants.icCloseBlue
                      .svgAssetImage(color: AppColors.isLightModeColor)
                      .paddingOnly(right: 7.5, left: 7.5, top: 21.5),
            ),
          ],
        ),
      ],
    );
  }
}
