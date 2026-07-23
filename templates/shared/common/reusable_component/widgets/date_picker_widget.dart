import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:expense_tracker/utils/theme/app_text_style.dart';
import 'package:expense_tracker/utils/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BirthDate {
  BirthDate(
      {required this.day,
      required this.month,
      required this.year,
      this.dateInISOFormat});
  DateTime? dateInISOFormat;
  int day;
  int month;
  int year;
}

typedef DateTimePickerCallback = void Function(BirthDate? birthDate);

class BirthDatePicker {
  void openCupertinoDatePicker({
    required BuildContext context,
    required DateTimePickerCallback dateTimePickerCallback,
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    BirthDate? birthDate;
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: AppColors.grey.withOpacity(1.0),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.textStyle16w400(
                          AppColors.primaryRed,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        dateTimePickerCallback(birthDate);
                        Navigator.of(context).pop();
                      },
                      child: Text('Done',
                          style: AppTextStyles.textStyle16w400(
                            AppColors.dark,
                          )),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                height: context.getHeightWithSize(sizeConstant: 250),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime dateTime) {
                    birthDate = BirthDate(
                        day: dateTime.day,
                        month: dateTime.month,
                        year: dateTime.year,
                        dateInISOFormat: dateTime);
                  },
                  initialDateTime: selectedDate ?? DateTime.now(),
                  maximumDate: endDate ?? DateTime.now(),
                  minimumDate: startDate ??
                      DateTime.now().subtract(const Duration(days: 100 * 365)),
                ),
              ),
            ],
          );
        });
  }
}
