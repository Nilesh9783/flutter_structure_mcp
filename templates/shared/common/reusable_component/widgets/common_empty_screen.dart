import 'package:expense_tracker/reusable_component/import.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/cupertino.dart';

class CommonEmptyScreen extends StatelessWidget {
  final String imageIcon;
  final String notFountText;
  final String notFountSubText;
  final String? buttonText;
  final Function? onTap;

  const CommonEmptyScreen({
    super.key,
    this.buttonText,
    required this.imageIcon,
    required this.notFountSubText,
    required this.notFountText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addImage(
              context: context,
              img: imageIcon,
              height: context.getHeightWithSize(sizeConstant: 100),
              width: context.getWidthWithSize(sizeConstant: 100)),
          10.0.heightSizedBox,
          Text(
            notFountText,
            style: AppTextStyles.textStyle20w700(AppColors.isLightModeColor),
          ),
          5.0.heightSizedBox,
          Text(
            notFountSubText,
            maxLines: 5,
            textAlign: TextAlign.center,
            style: AppTextStyles.textStyle20w700(AppColors.isLightModeColor)
                .copyWith(fontWeight: FontWeight.w400),
          ).paddingSymmetric(horizontal: 30),
          if (buttonText?.isNotEmpty ?? false) ...[
            notFountSubText.isEmpty ? 10.0.heightSizedBox : 50.0.heightSizedBox,
            CommonFilledButton(
              btnText: "$buttonText",
              onPressed: () {
                if (onTap != null) {
                  onTap!();
                }
              },
            ).paddingSymmetric(horizontal: 50)
          ]
        ],
      ),
    );
  }
}
