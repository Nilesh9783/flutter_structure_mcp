import 'package:expense_tracker/reusable_component/import.dart';
import 'package:expense_tracker/reusable_component/widgets/common_textfiled.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';

class DisputeDialog extends StatefulWidget {
  final Function onDispute;
  const DisputeDialog({super.key, required this.onDispute});

  @override
  State<DisputeDialog> createState() => _DisputeDialogState();
}

class _DisputeDialogState extends State<DisputeDialog> {
  TextEditingController controller = TextEditingController();

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
                      MsgConstants.addReason,
                      style: AppTextStyles.textStyle20w700(AppColors.isLightModeColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.navigateBack();
                      },
                      child: ImgConstants.icCloseBlue.svgAssetImage(color: AppColors.isLightModeColor),
                    ),
                  ],
                ),
              ),
              20.0.heightSizedBox,
              CommonFormFiledTextBox(
                      // context: context,
                      txtTitle: MsgConstants.reason,
                      controller: controller)
                  .paddingSymmetric(horizontal: 16),
              13.0.heightSizedBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: CommonFilledButton(
                    btnText: MsgConstants.disputeText,
                    height: 48.0,
                    onPressed: () {
                      context.navigateBack();
                      widget.onDispute(controller.text);
                    },
                    borderColor: AppColors.yellow,
                    color: AppColors.yellow),
              )
            ],
          ),
        ));
  }
}
