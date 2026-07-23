import 'package:expense_tracker/model/common_profile_management_model.dart';
import 'package:expense_tracker/model/organization_model.dart';
import 'package:expense_tracker/reusable_component/widgets/app_add_image.dart';
import 'package:expense_tracker/screens/profile/switch_profile/switch_profile_tabs.dart';
import 'package:expense_tracker/utils/common/base_bloc.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:expense_tracker/utils/theme/aspect_size.dart';
import 'package:flutter/material.dart';

import '../utils/common/constants.dart';
import '../utils/common/utils.dart';
import '../utils/theme/app_text_style.dart';
import '../utils/theme/colors.dart';

class ProfileNameAppBarPart extends StatelessWidget {
  final Function onProfileTab;
  final Function switchProfileEvent;
  final bool isProfileTab;
  const ProfileNameAppBarPart(
      {super.key,
      required this.onProfileTab,
      this.isProfileTab = false,
      required this.switchProfileEvent});
  //final AsyncSnapshot<OrganizationModel?> userTypeStreamSnapshot;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CommonProfileManageMentModel?>(
        stream: aGeneralBloc.currentOrganizationModelStream,
        builder: (context, userTypeStreamSnapshot) {
          return Row(
            children: [
              18.0.heightSizedBox,
              GestureDetector(
                onTap: () {
                  onProfileTab();
                },
                child: Stack(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: userImage(
                            context: context,
                            imgURL: userTypeStreamSnapshot.data?.profilePic,
                            width: context.getWidthWithSize(sizeConstant: 48),
                            height: context.getHeightWithSize(sizeConstant: 48),
                            borderRadius: 30)),
                    if ((userTypeStreamSnapshot.data?.profilePic ?? '')
                        .isNotEmpty)
                      Positioned(
                        bottom: context.getHeightWithSize(sizeConstant: 1),
                        right: context.getHeightWithSize(sizeConstant: 5),
                        child: (userTypeStreamSnapshot.data?.accountType ==
                                CommonProfileTypeModelEnum.personal.typeKey)
                            ? Utils.personImage(
                                outerPadding: const EdgeInsets.all(1.2),
                                innerPadding: const EdgeInsets.all(3.2),
                                height: context.getHeightWithSize(
                                    sizeConstant: 23.0),
                                width: context.getWidthWithSize(
                                    sizeConstant: 23.0),
                              )
                            : Utils.organizationImage(
                                outerPadding: const EdgeInsets.all(1.5),
                                innerPadding: const EdgeInsets.all(1.8),
                                height: context.getHeightWithSize(
                                    sizeConstant: 23.0),
                                width: context.getWidthWithSize(
                                    sizeConstant: 23.0),
                              ),
                      ),
                  ],
                ),
              ),
              10.0.widthSizedBox,
              StreamBuilder<CommonProfileManageMentModel?>(
                  stream: aGeneralBloc.currentOrganizationModelStream,
                  builder: (context, userTypeStreamSnapshot) {
                    return GestureDetector(
                      onTap: () {
                        SwitchProfileTabs()
                            .switchProfileBottomSheet(context)
                            .then((value) {
                          if (value != null) {
                            switchProfileEvent();
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(right: 10),
                        color: AppColors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  MsgConstants.hello +
                                      longStringToShort(userTypeStreamSnapshot
                                              .data?.firstName ??
                                          ""),
                                  style: (isProfileTab)
                                      ? AppTextStyles.textStyle18w700(
                                          AppColors.mainColor)
                                      : AppTextStyles.textStyle18w700(
                                          AppColors.isLightModeColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: AspectSize.getWithSize(
                                      context: context,
                                      sizeConstant: 14.25,
                                    ),
                                    top: AspectSize.getWithSize(
                                      context: context,
                                      sizeConstant: 6,
                                    ),
                                  ),
                                  child: (isProfileTab)
                                      ? ImgConstants.icArrowDown.svgAssetImage(
                                          width: 15.5,
                                          height: 8.5,
                                          color: AppColors.mainColor)
                                      : ImgConstants.icArrowDown.svgAssetImage(
                                          width: 15.5, height: 8.5,color: AppColors.isLightModeColor),
                                )
                              ],
                            ),

                            // if (aGeneralBloc.isPersonalUser()) {
                            //   return const SizedBox();
                            // }
                            Text(
                              (aGeneralBloc.currentOrganizationModelStream
                                      .valueOrNull?.orgName)
                                  .capitalizeFirstWordOnly(),
                              style: (isProfileTab)
                                  ? AppTextStyles.textStyle10w700(
                                      AppColors.mainColor)
                                  : AppTextStyles.textStyle10w700(
                                      AppColors.isLightModeColor),
                            )

                            // Text(
                            //   MsgConstants.indiaNic,
                            //   style: AppTextStyles.textStyle10w700(AppColors.c15292E),
                            // ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          );
        });
  }
}
