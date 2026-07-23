import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/reusable_component/widgets/app_add_image.dart';
import 'package:expense_tracker/reusable_component/widgets/filled_button.dart';
import 'package:expense_tracker/utils/common/constants.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:expense_tracker/utils/theme/app_text_style.dart';
import 'package:expense_tracker/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class NoDataErrorWidget extends StatelessWidget {
  const NoDataErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.whiteColor, //AppColors.scaffoldColor,

          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    addImage(
                        context: context,
                        img: ImgConstants.icOpps,
                        height: context.getHeightWithSize(sizeConstant: 200),
                        width: context.getWidthWithSize(sizeConstant: 200)),
                    30.0.heightSizedBox,
                    Text(
                      'Opps!!',
                      style: AppTextStyles.textStyle20w700(AppColors.c4A4A4A),
                    ),
                    5.0.heightSizedBox,
                    Text(
                      MsgConstants.noInterNet,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyle20w700(AppColors.c4A4A4A)
                          .copyWith(fontWeight: FontWeight.w400),
                    ).paddingSymmetric(horizontal: 25, vertical: 12),
                    // 50.0.heightSizedBox,
                    // if(buttonText.isNotEmpty)
                    // CommonFilledButton(btnText: buttonText,onPressed: (){
                    //   onTap();
                    // },).paddingSymmetric(horizontal: 50)
                  ],
                ),
              ),
              CommonFilledButton(
                  height: 48,
                  radious: 12,
                  btnText: MsgConstants.retry,
                  onPressed: () {
                    connectivity.initialise();
                  }).paddingSymmetric(horizontal: 25, vertical: 12),
            ],
          )),
    );
  }
}
