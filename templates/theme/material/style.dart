import 'package:flutter/material.dart';
import 'package:expense_tracker/utils/theme/colors.dart';
import 'package:flutter/services.dart';

enum AppTheme { light, dark }

ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  primaryColor: Colors.white,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0, foregroundColor: Colors.white),
  brightness: Brightness.light,
  dividerColor: AppColors.accentColor,
  focusColor: AppColors.accentColor,
  hintColor: AppColors.secondColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  ),
  textTheme: TextTheme(
    headlineSmall: TextStyle(
      fontSize: 22.0,
      color: AppColors.secondColor,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        color: AppColors.secondColor,
        height: 1.3),
    displaySmall: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
        color: AppColors.secondColor,
        height: 1.3),
    displayMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: AppColors.mainColor,
        height: 1.4),
    displayLarge: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.w300,
        color: AppColors.secondColor,
        height: 1.4),
    titleMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        color: AppColors.secondColor,
        height: 1.3),
    titleLarge: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w700,
        color: AppColors.mainColor,
        height: 1.3),
    bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: AppColors.secondColor,
        height: 1.2),
    bodyLarge: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        color: AppColors.mainDarkColor,
        height: 1.3),
    bodySmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w300,
        color: AppColors.accentColor,
        height: 1.2),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: false,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0, foregroundColor: Colors.black),
  scaffoldBackgroundColor: Colors.black,
  dividerColor: AppColors.accentColor,
  hintColor: AppColors.secondColor,
  focusColor: AppColors.secondColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: TextTheme(
    headlineSmall:
        TextStyle(fontSize: 22.0, color: AppColors.secondColor, height: 1.3),
    headlineMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        color: AppColors.secondColor,
        height: 1.3),
    displaySmall: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
        color: AppColors.secondColor,
        height: 1.3),
    displayMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: AppColors.mainColor,
        height: 1.4),
    displayLarge: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.w300,
        color: AppColors.secondColor,
        height: 1.4),
    titleMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        color: AppColors.secondColor,
        height: 1.3),
    titleLarge: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w700,
        color: AppColors.mainColor,
        height: 1.3),
    bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: AppColors.secondColor,
        height: 1.2),
    bodyLarge: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        color: AppColors.secondColor,
        height: 1.3),
    bodySmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w300,
        color: AppColors.secondColor,
        height: 1.2),
  ),
);
