import 'package:flutter/material.dart';

import '../../utils/theme/colors.dart';
import '../../utils/theme/app_text_style.dart';

// ignore: must_be_immutable
class CommonFilledButton extends StatelessWidget {
  CommonFilledButton(
      {super.key,
      required this.btnText,
      this.onPressed,
      this.height = 45.0,
      this.radious = 10.0,
      this.isEnable,
      this.isElevation = true,
      this.borderColor,
      this.titleColor,
      this.textStyle,
      this.color});

  final String btnText;
  final VoidCallback? onPressed;
  final double height;
  final double radious;
  final bool? isEnable;
  final bool? isElevation;
  final Color? borderColor;
  final Color? titleColor;
  TextStyle? textStyle;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    textStyle = textStyle ??
        AppTextStyles.textStyle16w700(titleColor ?? AppColors.mainColor);
    return filledButton();
  }

  Widget filledButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(isEnable == false
            ? AppColors.cD0D0D0
            : (color ?? AppColors.c4483F7)),
        minimumSize: WidgetStateProperty.all(Size.fromHeight(height)),
        elevation: (isElevation ?? false)
            ? WidgetStateProperty.all(1)
            : WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radious),
              side: BorderSide(
                  color: isEnable == false
                      ? AppColors.cD0D0D0
                      : (borderColor ?? AppColors.c4483F7))),
        ),
      ),
      child: Text(
        btnText,
        style: textStyle,
      ),
    );
  }
}
// Widget filledButton(
//     {required String btnText,
//     VoidCallback? onPressed,
//     double height = 45.0,
//     bool? isEnable,
//     bool? isElevation = true,
//     Color? borderColor,
//     Color? titleColor,
//     TextStyle? textStyle,
//     Color? color}) {
//   textStyle = textStyle ??
//       AppTextStyles.textStyle16w700(titleColor ?? AppColors.scaffoldColor);
//   return ElevatedButton(
//     onPressed: onPressed,
//     child: Text(
//       btnText,
//       style: textStyle,
//     ),
//     style: ButtonStyle(
//       backgroundColor: MaterialStateProperty.all(
//           isEnable == false ? AppColors.cD0D0D0 : (color ?? AppColors.c4483F7)),
//       minimumSize: MaterialStateProperty.all(Size.fromHeight(height)),
//       elevation: (isElevation ?? false)
//           ? MaterialStateProperty.all(1)
//           : MaterialStateProperty.all(0),
//       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//         RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             side: BorderSide(
//                 color: isEnable == false
//                     ? AppColors.cD0D0D0
//                     : (borderColor ?? AppColors.c4483F7))),
//       ),
//     ),
//   );
// }

// Widget filledGreyButton({required String btnText, VoidCallback? onPressed}) {
//   return ElevatedButton(
//     onPressed: onPressed,
//     child: Text(
//       btnText,
//       style: AppTextStyles.textStyle16w700(AppColors.scaffoldColor),
//     ),
//     style: ButtonStyle(
//       backgroundColor: MaterialStateProperty.all(AppColors.cF3F3F3),
//       minimumSize: MaterialStateProperty.all(const Size.fromHeight(45.0)),
//       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//         RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             side: BorderSide(color: AppColors.cF3F3F3)),
//       ),
//     ),
//   );
// }
