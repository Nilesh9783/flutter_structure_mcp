import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense_tracker/model/common_profile_management_model.dart';
import 'package:expense_tracker/model/organization_model.dart';
import 'package:expense_tracker/utils/common/base_bloc.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';

import '../../utils/common/utils.dart';
import '../import.dart';

Widget userImage(
    {required BuildContext context,
    double? borderRadius,
    String? initials,
    double? initialsTextSize,
    String? imgURL,
    double? height,
    TextStyle? textStyle,
    Color? loaderColor,
    double? width}) {
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadiusDirectional.circular(borderRadius ?? 0.0),
          // border: Border.all(
          //     width: 1.0, style: BorderStyle.solid, color: AppColors.cF3F3F3),
        ),
        child: CachedNetworkImage(
          height: AspectSize.getWithSize(
            context: context,
            sizeConstant: height ?? 0,
          ),
          width: AspectSize.getWithSize(
            context: context,
            sizeConstant: width ?? 0,
          ),
          imageUrl: imgURL ?? '',
          imageBuilder: (context, imageProvider) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          // progressIndicatorBuilder: (context, url, downloadProgress) =>
          //     AppLoader(type: LoaderType.activityIndicator),
          errorWidget: (context, url, error) => initials != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius ?? 0),
                  child: Container(
                    color: AppColors.isLightModeColor,
                    child: Center(
                      child: Text(
                        initials,
                        style: textStyle ??
                            AppTextStyles.textStyle20w700(AppColors.whiteColor)
                                .copyWith(fontSize: initialsTextSize ?? 20),
                      ),
                    ),
                  ),
                ).paddingAll(2)
              : (aGeneralBloc.currentOrganizationModelStream.valueOrNull
                          ?.accountType ==
                      CommonProfileTypeModelEnum.personal.typeKey)
                  ? Utils.personImage(
                      height: AspectSize.getWithSize(
                        context: context,
                        sizeConstant: height ?? 0,
                      ),
                      width: AspectSize.getWithSize(
                        context: context,
                        sizeConstant: width ?? 0,
                      ))
                  : Utils.organizationImage(
                      height: AspectSize.getWithSize(
                        context: context,
                        sizeConstant: height ?? 0,
                      ),
                      width: AspectSize.getWithSize(
                        context: context,
                        sizeConstant: width ?? 0,
                      )),
          placeholder: (context, url) => SizedBox(
            height: height,
            width: width,
            child:  Center(
              child: CircularProgressIndicator(
                color: AppColors.isLightModeColor,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget addImage(
    {required BuildContext context,
    double? height,
    bool isCenter = true,
    double? width,
    String? img,
    VoidCallback? onTap,
    BoxFit? fit}) {
  return GestureDetector(
    onTap: onTap ?? () {},
    child: isCenter
        ? Center(
            child: Image.asset(
              img ?? ImgConstants.icUserProfile,
              height: AspectSize.getWithSize(
                context: context,
                sizeConstant: height ?? 0,
              ),
              width: AspectSize.getWithSize(
                context: context,
                sizeConstant: width ?? 0,
              ),
              fit: fit ?? BoxFit.contain,
            ),
          )
        : Image.asset(
            img ?? ImgConstants.icUserProfile,
            height: AspectSize.getWithSize(
              context: context,
              sizeConstant: height ?? 0,
            ),
            width: AspectSize.getWithSize(
              context: context,
              sizeConstant: width ?? 0,
            ),
            fit: fit ?? BoxFit.contain,
          ),
  );
}

Widget addImageFile(File? data,
    {required BuildContext context,
    double? height,
    double? width,
    VoidCallback? onTap,
    BoxFit? fit}) {
  return GestureDetector(
    onTap: onTap ?? () {},
    child: data == null
        ? Container()
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              data,
              height: AspectSize.getWithSize(
                context: context,
                sizeConstant: height ?? 0,
              ),
              width: AspectSize.getWithSize(
                context: context,
                sizeConstant: width ?? 0,
              ),
              fit: fit ?? BoxFit.contain,
            ),
          ),
  );
}

Widget getProfileImage(CommonProfileManageMentModel organizationModel) {
  if (organizationModel.accountType ==
      CommonProfileTypeModelEnum.personal.typeKey) {
    return ((organizationModel.profilePic ?? '').isNotEmpty)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: organizationModel.profilePic
                .loadNetworkImage(height: 48, width: 48, fit: BoxFit.fill),
          )
        : Image.asset(
            ImgConstants.icPersonal,
            height: 48,
            width: 48,
            fit: BoxFit.fill,
          );
  } else {
    return ((organizationModel.profilePic ?? '').isNotEmpty)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: organizationModel.profilePic
                .loadNetworkImage(height: 48, width: 48, fit: BoxFit.fill),
          )
        : Image.asset(
            ImgConstants.icOrganisation,
            height: 48,
            width: 48,
            fit: BoxFit.fill,
          );
  }
}
