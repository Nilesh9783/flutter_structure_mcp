import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';

import '../../utils/common/constants.dart';
import '../../utils/theme/app_text_style.dart';
import '../../utils/theme/colors.dart';

class CommonRadioCardItem extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? imgProfileType;
  final VoidCallback? onTap;
  final bool? isSelected;
  final bool? isbuttonHide;

  const CommonRadioCardItem(
      {super.key,
      this.title,
      this.subTitle,
      this.imgProfileType,
      this.onTap,
      this.isSelected,
      this.isbuttonHide = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title ?? '',
                    style: AppTextStyles.textStyle16w400(
                        AppColors.isLightModeColor),
                  ),
                  9.5.widthSizedBox,
                  if (imgProfileType != null)
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: AppColors.cFF771C,
                      child: Text(
                        imgProfileType ?? '',
                        style: AppTextStyles.textStyle9w400(AppColors.mainColor)
                            .copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: (imgProfileType?.length ?? 0) >= 2
                                    ? 8
                                    : 12),
                      ),
                    ),
                ],
              ),
              if (subTitle != null)
                Text(
                  subTitle ?? '',
                  style: AppTextStyles.textStyle12w400(AppColors.cA3A3A3),
                ),
            ],
          ),
          if (!(isbuttonHide ?? false))
            Image.asset(
              isSelected == true
                  ? ImgConstants.icSelectedRadio
                  : ImgConstants.icUnselectedRadio,
              height: 20.0,
              width: 20.0,
              fit: BoxFit.contain,
            ),
        ],
      ),
    );
  }
}
