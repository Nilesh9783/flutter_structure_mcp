import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import '../import.dart';

class BankCardCashWidget extends StatelessWidget {
  const BankCardCashWidget(
      {super.key,
      required this.onSelected,
      required this.activeIndex,
      this.isCardHide = false,
      required this.childrens});

  final List<Widget> childrens;
  //required double height,
  final int activeIndex;
  final bool? isCardHide;
  final Function(int i) onSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadiusDirectional.circular(10.0),
            border: Border.all(
                width: 1.0, style: BorderStyle.solid, color: AppColors.cF3F3F3),
          ),
          child: Row(
            mainAxisAlignment: (!(isCardHide ?? false))
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {onSelected(0)},
                child: Column(children: [
                  _tabIcons(
                    isSelected: activeIndex == 0,
                    imgTab: activeIndex == 0
                        ? ImgConstants.icSelectedCash
                        : ImgConstants.icUnselectedCash,
                    titleTab: MsgConstants.cash,
                    context: context,
                  ),
                  12.0.heightSizedBox,
                  Text(
                    MsgConstants.cash,
                    style: AppTextStyles.textStyle16w400(AppColors.c24262D),
                  ),
                ]),
              ),
              if (isCardHide ?? false)
                context.getWidthWithSize(sizeConstant: 45.0).widthSizedBox,
              GestureDetector(
                onTap: () => {onSelected(1)},
                child: Column(children: [
                  _tabIcons(
                    isSelected: activeIndex == 1,
                    imgTab: activeIndex == 1
                        ? ImgConstants.icSelectedBank
                        : ImgConstants.icUnselectedBank,
                    titleTab: MsgConstants.bank,
                    context: context,
                  ),
                  12.0.heightSizedBox,
                  Text(
                    MsgConstants.bank,
                    style: AppTextStyles.textStyle16w400(AppColors.c24262D),
                  ),
                ]),
              ),
              if (!(isCardHide ?? false))
                GestureDetector(
                  onTap: () => {onSelected(2)},
                  child: Column(children: [
                    _tabIcons(
                      isSelected: activeIndex == 2,
                      imgTab: activeIndex == 2
                          ? ImgConstants.icSelectedCard
                          : ImgConstants.icUnselectedCard,
                      titleTab: MsgConstants.card,
                      context: context,
                    ),
                    12.0.heightSizedBox,
                    Text(
                      MsgConstants.card,
                      style: AppTextStyles.textStyle16w400(AppColors.c24262D),
                    )
                  ]),
                ),
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 12),
        ),
        8.0.heightSizedBox,
        childrens[activeIndex]
      ],
    );
  }

  Widget _tabIcons(
      {String? imgTab,
      String? titleTab,
      bool isSelected = false,
      required BuildContext context}) {
    return Container(
      height: AspectSize.getWithSize(
        context: context,
        sizeConstant: 60.0,
      ),
      width: AspectSize.getWithSize(
        context: context,
        sizeConstant: 60.0,
      ),
      decoration: isSelected
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.c4483F7,
              border: Border.all(color: AppColors.c4483F7, width: 1))
          : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //color: AppColors.cD0D0D0,
              border: Border.all(color: AppColors.cD0D0D0, width: 1)),
      child: Align(
        alignment: Alignment.center,
        child: Image.asset(
          imgTab ?? '',
          color: isSelected?AppColors.mainColor:AppColors.isLightModeColor,
          height: AspectSize.getWithSize(
            context: context,
            sizeConstant: 20.0,
          ),
          width: AspectSize.getWithSize(
            context: context,
            sizeConstant: 20.0,
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
