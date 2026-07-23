import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';

import '../../model/common_profile_management_model.dart';
import '../../utils/common/constants.dart';
import '../../utils/common/utils.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/app_text_style.dart';
import 'app_add_image.dart';

class CommonUserCard extends StatelessWidget {
  final CommonProfileManageMentModel userModel;
  final double? amount;

  const CommonUserCard({super.key, required this.userModel, this.amount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getHeightWithSize(sizeConstant: 82.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                userImage(
                    imgURL: userModel.profilePic,
                    context: context,
                    height: context.getHeightWithSize(sizeConstant: 60.0),
                    width: context.getWidthWithSize(sizeConstant: 60.0),
                    borderRadius: 35,
                    initials: getNameInitials(
                        firstName: userModel.firstName,
                        lastName: userModel.lastName)),
                Positioned(
                  bottom: context.getHeightWithSize(sizeConstant: 1),
                  right: context.getHeightWithSize(sizeConstant: 0),
                  child: addImage(
                      context: context,
                      height: context.getHeightWithSize(sizeConstant: 22.5),
                      width: context.getWidthWithSize(sizeConstant: 22.5),
                      img: ImgConstants.icOrganisation),
                ),
              ],
            ),
            10.0.widthSizedBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userModel.firstName.capitalizeFirstLetter(),
                        style: AppTextStyles.textStyle13w700(AppColors.c24262D),
                      ),
                      5.0.widthSizedBox,
                      if (userModel.isAdmin??false) ...[
                        CircleAvatar(
                          radius: 2.5,
                          backgroundColor: AppColors.c4483F7,
                        ),
                        5.0.widthSizedBox,
                        Text(
                          "Admin",
                          style:
                              AppTextStyles.textStyle13w700(AppColors.c4483F7),
                        ),
                      ]
                    ],
                  ).paddingOnly(top: 15.0,bottom: 4.0),
                  if(userModel.email?.isNotEmpty??false)...[
                    Text(
                      userModel.email ?? "",
                      style:
                      AppTextStyles.textStyle12w400(AppColors.c24262D),
                    ),
                    4.0.heightSizedBox,
                  ],
                  Text(
                    "+${userModel.countryCode} ${userModel.mobile}",
                    style:
                        AppTextStyles.textStyle12w400(AppColors.c24262D),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
