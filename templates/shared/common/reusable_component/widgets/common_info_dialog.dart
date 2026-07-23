import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';

import '../../utils/common/constants.dart';
import '../../utils/theme/app_text_style.dart';
import '../../utils/theme/colors.dart';

class CommonInfoDialog extends StatelessWidget {
  final String mainText;
  final String messageText;
  final String confButtonText;
  final String? cancelButtonText;
  final Function onConfirm;
  final Function? onCancel;
  final Color? confButtonTextColor;
  final Color? cancelButtonTextColor;
  final bool? isCancleShow;
  final bool? isCloseButtonShow;
  final bool? isConformShow;
  const CommonInfoDialog(
      {super.key,
      required this.confButtonText,
      required this.mainText,
      required this.messageText,
      this.isCancleShow = true,
      this.isConformShow = true,
      this.confButtonTextColor,
      this.cancelButtonTextColor,
      this.cancelButtonText,
      this.isCloseButtonShow = true,
      required this.onConfirm,
      this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        backgroundColor: AppColors.scaffoldColor,
        content: SizedBox(
          width: context.getWidthWithSize(sizeConstant: 358.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mainText,
                      style: AppTextStyles.textStyle20w700(
                          AppColors.isLightModeColor),
                    ),
                    if (isCloseButtonShow ?? false)
                      GestureDetector(
                        onTap: () {
                          context.navigateBack();
                        },
                        child: ImgConstants.icCloseBlue
                            .svgAssetImage(color: AppColors.isLightModeColor),
                      ),
                  ],
                ),
              ),
              20.0.heightSizedBox,
              Text(
                messageText,
                style:
                    AppTextStyles.textStyle16w400(AppColors.isLightModeColor),
              ).paddingSymmetric(horizontal: 20),
              20.0.heightSizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isCancleShow ?? false) ...[
                    GestureDetector(
                      onTap: () {
                        context.navigateBack();
                        if (onCancel != null) {
                          onCancel!();
                        }
                      },
                      child: Text(
                        cancelButtonText ?? MsgConstants.cancel,
                        style: AppTextStyles.textStyle16w700(
                            cancelButtonTextColor ??
                                AppColors.isLightModeColor),
                      ),
                    ),
                    10.0.widthSizedBox
                  ],
                  if (isConformShow ?? false) ...[
                    GestureDetector(
                      onTap: () {
                        onConfirm();
                      },
                      child: Text(
                        confButtonText,
                        style: AppTextStyles.textStyle16w700(
                            confButtonTextColor ?? AppColors.primaryRed),
                      ).paddingSymmetric(horizontal: 20),
                    ),
                  ]
                ],
              )
            ],
          ),
        ));
  }
}
