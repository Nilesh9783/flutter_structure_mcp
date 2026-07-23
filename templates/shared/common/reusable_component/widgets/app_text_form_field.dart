import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/utils/common/utils.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../import.dart';

class TextAmountFiled extends StatelessWidget {
  final TextEditingController? controller;
  final String? txtTitle;
  final String? currencyTitle;
  final Function? onCurrencyTap;
  final Function? onChange;
  final bool? isErrorOccur;
  final String? errorMsg;
  final bool enable;

  final Color? prefixiconColor;
  const TextAmountFiled(
      {super.key,
      this.controller,
      this.txtTitle,
      this.currencyTitle,
      this.isErrorOccur = false,
      this.errorMsg = '',
      this.prefixiconColor,
      this.onCurrencyTap,
      this.enable = true,
      this.onChange});

  static const _locale = 'hi';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  // String get _currency =>
  //     NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  @override
  Widget build(BuildContext context) {
    return txtAmountFormField();
  }

  Widget txtAmountFormField() {
    return SizedBox(
      height: 105,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txtTitle ?? '',
            style: AppTextStyles.textStyle12w700(AppColors.cA3A3A3),
          ),
          6.0.heightSizedBox,
          Flexible(
            child: TextFormField(
              enabled: enable,
              maxLines: 1,
              controller: controller,
              cursorColor: prefixiconColor ?? AppColors.c4483F7,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              maxLength: 12,
              inputFormatters: const [
                // CurrencyTextInputFormatter(
                //     symbol: "",  customPattern: "#,##,##,###.##",locale: "en")
              ],
              // validator: Validations().validateMobileNumber(_txtEnterMobile.text),
              textAlign: TextAlign.left,
              style: AppTextStyles.textStyle40w700(
                  prefixiconColor ?? AppColors.c4483F7),
              onChanged: (value) {
                String string = _formatNumber(value.replaceAll(',', ''));
                controller?.value = TextEditingValue(
                  text: string,
                  selection: TextSelection.collapsed(offset: string.length),
                );
                if (onChange != null) {
                  onChange!(value);
                }
              },
              decoration: InputDecoration(
                counterText: "",
                prefixIcon: InkWell(
                  onTap: () {
                    if (onCurrencyTap != null) {
                      onCurrencyTap!();
                    }
                  },
                  child: Text(
                    currencyTitle ?? '\u{20B9}',
                    style: AppTextStyles.textStyle40w700(
                        prefixiconColor ?? AppColors.c4483F7),
                  ).paddingOnly(bottom: 10),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 5,
                  minHeight: 5,
                ),
                focusColor: AppColors.cB3B3B3,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                    left: 0.0, bottom: 18.0, top: 5.0, right: 15.0),
                hintStyle: AppTextStyles.textStyle40w700(AppColors.c4483F7),
              ),
            ),
          ),
          Utils.containerLineWithPadding(),
          6.0.heightSizedBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isErrorOccur ?? false) 3.0.heightSizedBox,
              if (isErrorOccur ?? false)
                Text(errorMsg ?? 'df',
                    style: AppTextStyles.textStyle12w400(
                      AppColors.dangerRed,
                    ))
            ],
          ),
        ],
      ),
    );
  }
}

Widget txtSearchFormField({
  TextEditingController? controller,
  String? txtTitle,
  TextInputType? keyboardType,
  required BuildContext context,
  ValueChanged<String>? onChanged,
}) {
  return SizedBox(
    height: txtTitle?.isNotEmpty ?? false ? 50 : 32,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (txtTitle?.isNotEmpty ?? false) ...[
          Text(
            txtTitle ?? '',
            style: AppTextStyles.textStyle12w700(AppColors.cA3A3A3),
          ),
          6.0.heightSizedBox,
        ],
        Flexible(
          child: TextFormField(
            controller: controller,
            cursorColor: AppColors.cB3B3B3,
            keyboardType: keyboardType,
            // validator: Validations().validateMobileNumber(_txtEnterMobile.text),
            textAlign: TextAlign.left,
            style: AppTextStyles.textStyle12w400(AppColors.accentDarkColor),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.c0091FF,
                size: 13.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: AppColors.cE3E4E6,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: AppColors.cE3E4E6,
                ),
              ),
              focusColor: AppColors.cB3B3B3,
              contentPadding: const EdgeInsets.only(
                  left: 0.0, bottom: 0.0, top: 0.0, right: 15.0),
              hintStyle: AppTextStyles.textStyle11w400(AppColors.cB3B3B3),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}

Widget txtSearchFormFieldSecond({
  TextEditingController? controller,
  String? txtTitle,
  TextInputType? keyboardType,
  required BuildContext context,
  ValueChanged<String>? onChanged,
}) {
  return SizedBox(
    height: context.getWidthWithSize(sizeConstant: 45),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            cursorColor: AppColors.cB3B3B3,
            keyboardType: keyboardType,
            // validator: Validations().validateMobileNumber(_txtEnterMobile.text),
            textAlign: TextAlign.left,
            style: AppTextStyles.textStyle15w400(AppColors.isLightModeColor)
                .copyWith(fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: ImgConstants.icSearch
                  .svgAssetImage(color: AppColors.isLightModeColor,)
                  .paddingOnly(top: 14, bottom: 14, left: 10),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: AppColors.cD7DBE1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: AppColors.cD7DBE1,
                ),
              ),
              filled: true, //<-- SEE HERE
              fillColor: AppColors.transCardColor,
              // focusColor: AppColors.primaryRed,
              contentPadding: const EdgeInsets.only(
                  left: 0.0, bottom: 0.0, top: 0.0, right: 15.0),
              hintStyle: AppTextStyles.textStyle11w400(AppColors.cB3B3B3),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}

Widget txtStartEndDateFormFiled({
  Color? textColor,
  FocusNode? focusNode,
  TextEditingController? controller,
  String? txtTitle,
  required BuildContext context,
}) {
  return Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txtTitle ?? '',
            style: AppTextStyles.textStyle12w700(AppColors.cA3A3A3),
          ),
          commonSizedBox(sizeConstant: 4.0, context: context),
          TextFormField(
            enabled: false,
            focusNode: focusNode,
            controller: controller,
            cursorColor: Colors.black,
            keyboardType: TextInputType.datetime,
            style:
                AppTextStyles.textStyle16w400(textColor ?? AppColors.c15292E),
            onChanged: (text) {},
            decoration: InputDecoration(
              suffixIcon: Image.asset(
                ImgConstants.icCalendar,
                fit: BoxFit.none,
                color: textColor ?? AppColors.c25314C,
              ),
              filled: true,
              fillColor: AppColors.cF3F3F3,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                  left: 11, bottom: 11, top: 11, right: 1),
            ),
          ),
        ],
      ),
    ],
  );
}

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'\/'));
      if (nonZeroIndex % 2 == 0 &&
          nonZeroIndex != newValueString.length &&
          !(contains)) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}
