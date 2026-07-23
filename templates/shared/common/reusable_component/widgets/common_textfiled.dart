import 'package:expense_tracker/reusable_component/import.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonFormFiledTextBox extends StatelessWidget {
  final TextEditingController? controller;
  final String? txtTitle;
  final TextInputType? keyboardType;
  final bool? isMandatory;
  final Widget? suffixIcon;
  final TextCapitalization? textCapitalizationtype;
  final TextInputAction? textInputAction;
  final bool? isErrorOccur;
  final String? errorMsg;
  final String? placeHoderString;
  final int? maxLine;
  final int? maxLength;
  final Function? onChange;
  final bool? isBorderShow;

  final List<TextInputFormatter>? textInputFormat;
  // final String? hintText;
  // final String? icon;
  final bool? isEnable;
  // final bool? isSufixiconShow;
  const CommonFormFiledTextBox(
      {super.key,
      this.txtTitle,
      this.textCapitalizationtype,
      this.controller,
      this.keyboardType,
      this.suffixIcon,
      this.textInputAction,
      this.isMandatory = false,
      this.isErrorOccur = false,
      this.isBorderShow = false,
      this.errorMsg = '',
      this.maxLine = 1,
      this.maxLength,
      this.placeHoderString,
      //this.hintText,
      // this.icon,
      this.isEnable,
      this.textInputFormat,
      this.onChange
      // this.isSufixiconShow,
      });

  @override
  Widget build(BuildContext context) {
    return _txtField(context);
  }

  Widget _txtField(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(txtTitle?.isNotEmpty??false)...[
          Text(
            (isMandatory ?? false) ? '${txtTitle ?? ''} *' : txtTitle ?? '',
            style: AppTextStyles.textStyle12w700(AppColors.cA3A3A3),
          ),
          6.0.heightSizedBox,
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLine,
          cursorColor: AppColors.cB3B3B3,
          keyboardType: keyboardType,
          enabled: isEnable,
          inputFormatters: textInputFormat ?? [],
          // validator: Validations().validateMobileNumber(_txtEnterMobile.text),
          textAlign: TextAlign.left,
          maxLength: maxLength,
          onChanged: (value) {
            if (onChange != null) {
              onChange!(value);
            }
          },

          style: AppTextStyles.textStyle16w400(AppColors.isLightModeColor),
          textInputAction: textInputAction ?? TextInputAction.done,
          decoration: InputDecoration(
            counterText: "",
            isDense: !(isBorderShow ?? false),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 5,
              minHeight: 5,
            ),
            focusColor: AppColors.cB3B3B3,
            border: InputBorder.none,
            focusedBorder: (isBorderShow ?? false)
                ? OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        width: 1,
                        color: (isErrorOccur ?? false)
                            ? AppColors.dangerRed
                            : AppColors.grey), //<-- SEE HERE
                  )
                : InputBorder.none,
            enabledBorder: (isBorderShow ?? false)
                ? OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        width: 1,
                        color: (isErrorOccur ?? false)
                            ? AppColors.dangerRed
                            : AppColors.cD0D0D0), //<-- SEE HERE
                  )
                : InputBorder.none,
            errorBorder: (isBorderShow ?? false)
                ? OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        width: 1, color: AppColors.dangerRed), //<-- SEE HERE
                  )
                : InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: (isBorderShow ?? false)
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 0)
                : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            hintText: placeHoderString,
            hintStyle: AppTextStyles.textStyle15w400(AppColors.cB3B3B3),
          ),

          textCapitalization: textCapitalizationtype ?? TextCapitalization.none,
        ),
        if (isBorderShow ?? false) ...[
          3.0.heightSizedBox,
          Text(errorMsg ?? '',
              style: AppTextStyles.textStyle12w400(
                AppColors.dangerRed,
              ))
        ],
        if (!(isBorderShow ?? false)) ...[
          6.0.heightSizedBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1.0,
                color: (isErrorOccur ?? false)
                    ? AppColors.dangerRed
                    : AppColors.cD1D8E0,
              ),
              if (isErrorOccur ?? false) 3.0.heightSizedBox,
              if (isErrorOccur ?? false)
                Text(errorMsg ?? '',
                    style: AppTextStyles.textStyle12w400(
                      AppColors.dangerRed,
                    ))
            ],
          ),
        ]
      ],
    );
  }
}
