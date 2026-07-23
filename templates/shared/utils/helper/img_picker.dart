import 'dart:io';

import 'package:expense_tracker/reusable_component/widgets/common_head_bar.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:expense_tracker/utils/theme/app_text_style.dart';
import 'package:expense_tracker/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:camera/camera.dart';

enum ImagePickerType { gallary, camera }

class ImagePickerHelper extends StatelessWidget {
  const ImagePickerHelper(
      {super.key,
      this.onDone,
      this.isCropped,
      this.size,
      this.cropStyle = CropStyle.rectangle,
      required this.textTitle});
  final Function(File?)? onDone;
  final bool? isCropped;
  final Size? size;
  final CropStyle cropStyle;
  final String? textTitle;

  // ImagePickerHelperState(
  //     {this.onDone,
  //     this.isCropped,
  //     this.size,
  //     this.cropStyle = CropStyle.rectangle,
  //     this.textTitle});

  // final Function(File?)? onDone;
  // final bool? isCropped;
  // final Size? size;
  // final CropStyle cropStyle;
  // final String? textTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CommonHeadBar(
                    title: textTitle != null && (textTitle ?? '').isNotEmpty
                        ? textTitle ?? ''
                        : 'Set Your Profile Pic'.tr())
                .paddingSymmetric(horizontal: 15),
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
                      child: Center(
                          child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.mainColor,
                        size: 20,
                      ))),
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
                  onDone!(img);
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
                      child: Center(
                          child: Icon(
                        Icons.image_outlined,
                        color: AppColors.mainColor,
                        size: 20,
                      ))),
                  10.0.widthSizedBox,
                  Text('Choose Photo'.tr(),
                      style: AppTextStyles.textStyle16w400(AppColors.c24262D)),
                ],
              ).paddingOnly(left: 5),
              onTap: () async {
                ///old start
                // getCroppedImage(ImagePickerType.gallary, size!.height,
                //         size!.width, context, cropStyle)
                //     .then((File? img) {
                //
                // context.navigateBack();
                // onDone!(img);
                // });
                ///old end
                ///new start
                // final ImagePicker _picker = ImagePicker();
                // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                // context.navigateBack();
                // onDone!(File(image?.path ?? ''));
                ///new end
                ///nilesh bhai
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                _cropImageNew(File(image?.path ?? ''), cropStyle).then((value) {
                  context.navigateBack();
                  onDone!(value);
                });
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
        File? file = await _cropImage(xfile, cropStyle);
        return file;
      }
      return null;
    } catch (e) {
      debugPrint('-- image picker issue --- $e ---------');
    }
    return null;
  }

  Future<File?> _cropImage(XFile file, CropStyle cropStyle) async {
    Size kSquareSize = const Size(300, 300);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 70,
      maxHeight: kSquareSize.height.toInt(),
      maxWidth: kSquareSize.width.toInt(),
      // cropStyle: cropStyle,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.mainColor,
            activeControlsWidgetColor: AppColors.c4483F7,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
            title: 'Cropper',
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true),
      ],
    );
    if (croppedFile != null) {
      final File file = File(croppedFile.path);
      return file;
    }
    return null;
  }

  ///this code fixed the issue of crashing when we picked from gallary in ios
  Future<File?> _cropImageNew(File file, CropStyle cropStyle) async {
    Size kSquareSize = const Size(300, 300);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 70,
      maxHeight: kSquareSize.height.toInt(),
      maxWidth: kSquareSize.width.toInt(),
      //  cropStyle: cropStyle,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.mainColor,
            activeControlsWidgetColor: AppColors.c4483F7,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
            title: 'Cropper',
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true),
      ],
    );
    if (croppedFile != null) {
      final File file = File(croppedFile.path);
      return file;
    }
    return null;
  }

  /// end
}
