import 'package:flutter/material.dart';
import 'package:expense_tracker/utils/common/constants.dart';
import 'aspect_size.dart';

extension AppTextStyle on TextStyle {
  TextStyle getStyle(
      {required BuildContext context,
      String fontFamily = 'Montserrat',
      FontWeight weight = FontWeight.normal,
      double fontSize = 12.0,
      Color color = Colors.black,
      double letterSpacing = 0.0}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: weight,
      fontSize: AspectSize.getWithSize(
        context: context,
        sizeConstant: fontSize,
      ),
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}

class AppTextStyles {
  static TextStyle textStyle24Bold(Color color) {
    return TextStyle(
      color: color,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      fontFamily: MsgConstants.sFProDisplayFont,
    );
  }

  static TextStyle textStyle15w400(Color color, {double? lineHeight}) {
    return TextStyle(
        color: color,
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        height: lineHeight,
        letterSpacing: -0.12,
        fontFamily: MsgConstants.sFProDisplayFont);
  }

  static TextStyle textStyle12w400(Color color) {
    return TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle11w400(Color color) {
    return TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.w400,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle11w700(Color color) {
    return TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.w700,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle10w400(Color color) {
    return TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w400,
        fontFamily: MsgConstants.sFProDisplayFont,
        color: color,
        letterSpacing: 0.1);
  }

  static TextStyle textStyle10w700(Color color) {
    return TextStyle(
      fontSize: 10.0,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w700,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle7w700(Color color) {
    return TextStyle(
      fontSize: 7.0,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w700,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle16w700(Color color) {
    return TextStyle(
      fontSize: 16.0,
      letterSpacing: -0.25,
      fontWeight: FontWeight.w700,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle16w400(Color color) {
    return TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        fontFamily: MsgConstants.sFProDisplayFont,
        color: color,
        letterSpacing: -0.25);
  }

  static TextStyle textStyle9w400(Color color) {
    return TextStyle(
        fontSize: 9.94,
        fontWeight: FontWeight.w400,
        fontFamily: MsgConstants.sFProDisplayFont,
        color: color,
        letterSpacing: -0.08);
  }

  static TextStyle textStyle7w400(Color color) {
    return TextStyle(
      fontSize: 7.94,
      fontWeight: FontWeight.w700,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle1193w400(Color color) {
    return TextStyle(
        fontSize: 11.93,
        fontWeight: FontWeight.w700,
        fontFamily: MsgConstants.sFProDisplayFont,
        color: color,
        letterSpacing: -0.17);
  }

  static TextStyle textStyle22w400(Color color) {
    return TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w400,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle12w700(Color color) {
    return TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w700,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle18w700(Color color) {
    return TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle18w400(Color color) {
    return TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle40w700(Color color) {
    return TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.w700,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle14w500(Color color) {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle14w400(Color color) {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle13w400(Color color) {
    return TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        fontFamily: MsgConstants.sFProDisplayFont,
        color: color,
        letterSpacing: -0.03);
  }

  static TextStyle textStyle13w700(Color color) {
    return TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w700,
        fontFamily: MsgConstants.sFProDisplayFont,
        color: color,
        letterSpacing: -0.03);
  }

  static TextStyle textStyle15w700(Color color) {
    return TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w700,
        fontFamily: MsgConstants.sFProDisplayFont,
        color: color,
        letterSpacing: -0.12);
  }

  static TextStyle textStyle20w700(Color color) {
    return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }

  static TextStyle textStyle24w700(Color color) {
    return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      fontFamily: MsgConstants.sFProDisplayFont,
      color: color,
    );
  }
}
