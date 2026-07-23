import 'package:country_picker/country_picker.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';

import '../../utils/common/constants.dart';
import '../../utils/helpers/validation_helper.dart';
import '../../utils/theme/app_text_style.dart';
import '../../utils/theme/aspect_size.dart';
import '../../utils/theme/colors.dart';

class CommonMobileFeild extends StatelessWidget {
  final TextEditingController countryController;
  final TextEditingController mobileController;
  final Function onSelectCountry;
  final Function onChangeMobile;
  final bool? isErrorOccur;
  final String? errorMsg;

  const CommonMobileFeild({
    super.key,
    required this.mobileController,
    required this.countryController,
    required this.onSelectCountry,
    required this.onChangeMobile,
    this.isErrorOccur = false,
    this.errorMsg = '',
  });

  @override
  Widget build(BuildContext context) {
    return _mobileTxtField(context);
  }

  Widget _mobileTxtField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${MsgConstants.mobileNumber}*",
          style: AppTextStyles.textStyle12w700(AppColors.cA3A3A3),
        ),
        5.0.heightSizedBox,
        Container(
          height: context.getHeightWithSize(sizeConstant: 50.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: (isErrorOccur ?? false)
                    ? AppColors.dangerRed
                    : AppColors.cD0D0D0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 75,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    showCountryPicker(
                      context: context,
                      favorite: ["IN"],
                      exclude: ["IN"],
                      showPhoneCode: true,
                      countryListTheme: CountryListThemeData(
                        flagSize: 20,
                        backgroundColor: AppColors.scaffoldColor,
                        textStyle: AppTextStyles.textStyle18w400(
                            AppColors.isLightModeColor),
                        bottomSheetHeight: context.height -
                            200, // Optional. Country list modal height
                        //Optional. Sets the border radius for the bottomsheet.
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        searchTextStyle: AppTextStyles.textStyle16w400(
                            AppColors.isLightModeColor),

                        //Optional. Styles the search field.
                        inputDecoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Start typing to search',
                          prefixIcon: const Icon(Icons.search),
                          fillColor: AppColors.cD0D0D0,
                          prefixIconColor: AppColors.cD0D0D0,
                          focusColor: AppColors.cD0D0D0,
                          hoverColor: AppColors.cD0D0D0,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.cD0D0D0,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.cD0D0D0,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      onSelect: (Country country) {
                        countryController.text =
                            "${country.flagEmoji} +${country.phoneCode}";
                        onSelectCountry(country);
                      },
                    );
                  },
                  child: TextFormField(
                    controller: countryController,
                    cursorColor: AppColors.cB3B3B3,
                    maxLength: 3,
                    enabled: false,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.textStyle15w400(
                        AppColors.isLightModeColor),
                    decoration: InputDecoration(
                      counterText: "",
                      focusColor: AppColors.cB3B3B3,
                      hintText: MsgConstants.countryCode,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                        left: 15.0,
                        bottom: 11.0,
                        top: 10.0,
                      ),
                      hintStyle:
                          AppTextStyles.textStyle15w400(AppColors.cB3B3B3),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: AspectSize.getWithSize(
                    context: context,
                    sizeConstant: 20.0,
                  ),
                ),
                child: Container(
                  height: AspectSize.getWithSize(
                    context: context,
                    sizeConstant: 30.0,
                  ),
                  width: 1.0,
                  color: AppColors.cD0D0D0,
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: mobileController,
                  cursorColor: AppColors.cB3B3B3,
                  keyboardType: TextInputType.number,
                  maxLength: 15,
                  validator: (String? val) {
                    return Validations().validateMobileNumber(val ?? '');
                  },
                  onChanged: (value) {
                    onChangeMobile(value);
                  },
                  inputFormatters: [
                    MaskedInputFormatter(MsgConstants.maskMobileFormat),
                    FilteringTextInputFormatter.allow(RegExp("[0-9\\-]")),
                  ],
                  textAlign: TextAlign.left,
                  style:
                      AppTextStyles.textStyle15w400(AppColors.isLightModeColor),
                  decoration: InputDecoration(
                    counterText: "",
                    focusColor: AppColors.cB3B3B3,
                    hintText: MsgConstants.mobileNumber,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 15.0, bottom: 11.0, top: 10.0, right: 15.0),
                    hintStyle: AppTextStyles.textStyle15w400(AppColors.cB3B3B3),
                  ),
                ),
              ),
            ],
          ),
        ),
        3.0.heightSizedBox,
        Text(errorMsg ?? '',
            style: AppTextStyles.textStyle12w400(
              AppColors.dangerRed,
            ))
      ],
    );
  }
}
