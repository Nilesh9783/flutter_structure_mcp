import 'dart:io';

import 'package:expense_tracker/utils/common/utils.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:expense_tracker/utils/theme/app_text_style.dart';
import 'package:expense_tracker/utils/theme/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../reusable_component/widgets/common_head_bar.dart';

//import 'package:camera/camera.dart';

enum ImagePickerType { gallary, camera }

// ignore: must_be_immutable
class ImagePickerHelperWithDocPicker extends StatelessWidget {
  ImagePickerHelperWithDocPicker(
      {super.key,
      this.onDone,
      this.isCropped,
      this.size,
      this.cropStyle = CropStyle.rectangle,
      required this.textTitle});
  final Function(List<File>?)? onDone;
  final bool? isCropped;
  final Size? size;
  final CropStyle cropStyle;
  final String? textTitle;
  List<File> lstFile = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CommonHeadBar(title:  textTitle != null && (textTitle ?? '').isNotEmpty
                ? textTitle ?? ''
                : 'Set Your Profile Pic'.tr()).paddingSymmetric(horizontal: 15),
            8.0.heightSizedBox,
            ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.mainDarkColor,
                      ),
                      child: Center(child: Icon(Icons.camera_alt_outlined,color: AppColors.mainColor,size: 20,))),
                  10.0.widthSizedBox,
                  Text(
                    'Take Photo'.tr(),
                    style: AppTextStyles.textStyle16w400(AppColors.c24262D),
                  ),
                ],
              ).paddingOnly(left: 5),
              onTap: () async {
                // await requestPermissions();
                // showCameraPreview(widget.size!.height, widget.size!.width,
                //     context, widget.cropStyle);

                //comment  two line and comment getCroppedImage method call for test new camera coustom ui
                getCroppedImage(ImagePickerType.camera, size!.height,
                    size!.width, context, cropStyle)
                    .then((File? img) {
                  context.navigateBack();
                  if (img != null) {
                    lstFile.add(img);
                    onDone!(lstFile);
                  }
                });
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.mainDarkColor,
                      ),
                      child: Center(child: Icon(Icons.image_outlined,color: AppColors.mainColor,size: 20,))),
                  10.0.widthSizedBox,
                  Text(
                    'Choose Receipt'.tr(),
                    style: AppTextStyles.textStyle16w400(AppColors.c24262D),
                  ),
                ],
              ).paddingOnly(left: 5),
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  File file = File(image.path);
                  // ignore: use_build_context_synchronously
                  context.navigateBack();

                  lstFile.add(file);
                  onDone!(lstFile);
                }
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.mainDarkColor,
                      ),
                      child: Center(child: Icon(Icons.folder,color: AppColors.mainColor,size: 20,))),
                  10.0.widthSizedBox,
                  Text(
                    'Choose From Mobile'.tr(),
                    style: AppTextStyles.textStyle16w400(AppColors.c24262D),
                  ),
                ],
              ).paddingOnly(left: 5),
              onTap: () async {
                FilePickerResult? result = await Utils.openFilePicker();

                for (PlatformFile platformFile in result?.files ?? []) {
                  lstFile.add(File(platformFile.path ?? ""));
                }
                // ignore: use_build_context_synchronously
                context.navigateBack();
                onDone!(lstFile);
              },
            ),
            20.0.heightSizedBox
          ],
        ),
      ),
    );
  }

  Future<File?> getCroppedImage(ImagePickerType type, double height,
      double width, BuildContext context, CropStyle cropStyle) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? xfile = await picker.pickImage(
          source: type == ImagePickerType.camera
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 50);

      if (xfile != null) {
        File? file = File(xfile.path);
        return file;
      }
      return null;
    } catch (e) {
      debugPrint('-- image picker issue --- $e ---------');
    }
    return null;
  }

  /// end
}
