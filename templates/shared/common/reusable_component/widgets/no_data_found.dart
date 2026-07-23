import 'package:expense_tracker/utils/common/constants.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:expense_tracker/utils/theme/app_text_style.dart';
import 'package:expense_tracker/utils/theme/aspect_size.dart';
import 'package:expense_tracker/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({super.key, this.titleText});
  final String? titleText;

  @override
  build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(ImgConstants.noArticleImage),
          20.0.heightSizedBox,
          Text(
            titleText ?? 'No Data Found',
            style: AppTextStyles.textStyle12w400(AppColors.transparent),
          ),
        ],
      ),
    ).paddingAll(10);
  }
}

class LoadingShimmerListView extends StatelessWidget {
  const LoadingShimmerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return cellView(context);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1.0,
                  color: AppColors.cD1D8E0,
                );
              },
              itemCount: 5)
          .applyShimmer(),
    );
  }

  Widget cellView(BuildContext context) {
    return SizedBox(
      height: AspectSize.getWithSize(
        context: context,
        sizeConstant: 72.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.grey),
                  height: 48,
                  width: 42,
                  child: const SizedBox(height: 20, width: 17),
                ).paddingOnly(left: 8, top: 12, bottom: 12),
                10.0.widthSizedBox,
                Container(
                  width: context.getWidthWithSize(sizeConstant: 200),
                  height: 48,
                  color: AppColors.grey,
                ).paddingOnly(left: 8, top: 12, bottom: 12),
              ],
            ),
            8.0.widthSizedBox,
          ],
        ),
      ),
    );
  }
}
