import 'package:flutter/material.dart';

import '../../main.dart';

class AppColors {
  static Color get mainColor => const Color(0xFFFFFFFF);

  static Color get secondColor => const Color(0xFFFFFFFF);

  static Color get accentColor => const Color(0xFFFFFFFF);

  static Color get mainDarkColor => const Color(0xFF000000);

  static Color get secondDarkColor => const Color(0xFF000000);

  static Color get accentDarkColor => const Color(0xFF000000);

  static Color get transparent => Colors.transparent;
  static Color get c4483F7 => const Color(0xFF4483F7);
  static Color get c1B2850 => const Color.fromRGBO(27, 40, 80, 0.2);
  static Color get c4483F701 => const Color.fromRGBO(68, 131, 247, 0.1);
  static Color get c817B75 => (brightness == Brightness.dark)
      ? const Color.fromRGBO(244, 244, 244, 1)
      : const Color.fromRGBO(129, 123, 117, 1);
  static Color get cF4F4F4 => const Color.fromRGBO(244, 244, 244, 1);
  static Color get c4A4A4A => const Color.fromRGBO(74, 74, 74, 1);
  static Color get cD7DBE1 => const Color.fromRGBO(215, 219, 225, 1);
  static Color get cFFFFFF => const Color.fromRGBO(255, 255, 255, 0.6);

  //grdiant text
  static Color get cFF9D9D => const Color.fromRGBO(255, 157, 157, 0.15);
  static Color get cC8FFE1 => const Color.fromRGBO(200, 255, 225, 0.15);
  static Color get cBFAOFF => const Color.fromRGBO(191, 160, 255, 0.15);
  static Color get cFF9BD7 => const Color.fromRGBO(255, 155, 215, 0.15);
  static Color get cFFEA9F => const Color.fromRGBO(255, 234, 159, 0.15);

  static Color get c000000 => const Color.fromRGBO(0, 0, 0, 1);
  static Color get c57B683 => const Color.fromRGBO(87, 182, 131, 1);
  static Color get c7354B5 => const Color.fromRGBO(115, 84, 181, 1);
  static Color get c82245C => const Color.fromRGBO(130, 36, 92, 1);

  static Color get cD0D0D0 => const Color(0xFFD0D0D0);
  // static Color get cD7DBE1 => const Color(0xFFD7DBE1);
  static Color get cB3B3B3 => const Color(0xFFB3B3B3);
  static Color get c333333 => (brightness == Brightness.dark)
      ? const Color.fromRGBO(244, 244, 244, 1)
      : const Color(0xFF333333);
  static Color get cE0E0E0 => const Color(0xFFE0E0E0);
  static Color get cD1D8E0 => const Color(0xFFD1D8E0);
  static Color get cA3A3A3 => const Color(0xFFA3A3A3);
  static Color get c15292E => const Color(0xFF15292E);
  static Color get c0091FF => const Color(0xFF0091FF);
  static Color get c007AFF => const Color(0xFF007AFF);
  static Color get c9C989C => const Color(0xFF9C989C);
  static Color get cFF1000 => const Color(0xFFFF1000);
  // static Color get cFFFFFF => const Color(0xFFFFFFFF);
  static Color get greenLight => const Color.fromRGBO(56, 150, 63, 1);
  static Color get yellow => const Color.fromRGBO(255, 191, 76, 1);
  static Color get cFFBF4C02 => const Color.fromRGBO(255, 191, 76, 0.2);
  static Color get c25314C => const Color(0xFF25314C);
  static Color get cA6A6A640 => const Color.fromRGBO(166, 166, 166, 0.25);
  static Color get cFFFFFF50 => const Color.fromRGBO(255, 255, 255, 0.5);
  static Color get c4483F714 => const Color.fromRGBO(68, 131, 247, 0.08);
  static Color get cFF771C => const Color.fromRGBO(255, 119, 28, 1);

  // category color
  static Color get c3ED600 => const Color.fromRGBO(62, 214, 0, 1);
  static Color get cFFCB9B => const Color.fromRGBO(255, 203, 155, 1);
  static Color get cCD73C9 => const Color.fromRGBO(205, 115, 201, 1);
  static Color get c9C8BFF => const Color.fromRGBO(156, 139, 255, 1);
  static Color get c47D187 => const Color.fromRGBO(71, 209, 135, 1);
  static Color get c73ADCD => const Color.fromRGBO(115, 173, 205, 1);
  static Color get cBABABA => const Color.fromRGBO(186, 186, 186, 1);

  static Color get transCardColor => (brightness == Brightness.dark)
      ? const Color.fromRGBO(22, 23, 28, 1)
      : const Color(0xFFFFFFFF);

  static Color get c24262D => (brightness == Brightness.dark)
      ? const Color(0xFFF3F3F3)
      : const Color(0xFF24262D);

  //////////////
  static Color get isLightModeColor =>
      (brightness == Brightness.dark) ? mainColor : mainDarkColor;

  static Color get isLightModeColor2WithGray =>
      (brightness == Brightness.dark) ? mainColor : grey;
  static Color get scaffoldColor => (brightness == Brightness.dark)
      ? const Color.fromRGBO(22, 23, 28, 1)
      : const Color(0xFFFFFFFF);

  static Color get cF3F3F3 => (brightness == Brightness.dark)
      ? const Color.fromRGBO(10, 11, 13, 1)
      : const Color(0xFFF3F3F3);

  ////////////////
  static Color get lineColor => (brightness == Brightness.dark)
      ? const Color(0xFFF3F3F3)
      : const Color.fromRGBO(10, 11, 13, 1);

  static Color get c181818 => (brightness == Brightness.dark)
      ? const Color(0xFFE3E4E6)
      : const Color(0xFF181818);

  static Color get c252425 => (brightness == Brightness.dark)
      ? const Color(0xFF252425)
      : const Color(0xFFE3E4E6);

  static Color get c949A9C => (brightness == Brightness.dark)
      ? const Color.fromRGBO(148, 154, 156, 0.2)
      : const Color(0xFFE3E4E6);

  static Color get cE3E4E6 => (brightness == Brightness.dark)
      ? const Color(0xFF0E1525)
      : const Color(0xFFE3E4E6);

  static Color get cF8F8F8 => (brightness == Brightness.dark)
      ? const Color(0xFF0E1525)
      : const Color(0xFFF8F8F8);

  static Color get cECFBE6 => (brightness == Brightness.dark)
      ? const Color(0xFF0E1525)
      : const Color.fromRGBO(236, 251, 230, 1);

  static Color get cFBE6E6 => (brightness == Brightness.dark)
      ? const Color(0xFF0E1525)
      : const Color.fromRGBO(251, 230, 230, 1);

  static Color get searchBackDropdown => (brightness == Brightness.dark)
      ? const Color(0xFF0E1525)
      : const Color(0xFFFFFFFF);

  static Color get whiteColor => (brightness == Brightness.dark)
      ? const Color(0xFF0E1525)
      : const Color(0xFFFFFFFF);
  //static Color get whiteColor => const Color(0xFFFFFFFF);

  static MaterialColor get primaryRed => const MaterialColor(
        0xffDF3545,
        <int, Color>{
          100: Color(0xFFF7D2D6),
          200: Color(0xFFF1AAB1),
          300: Color(0xFFEB828D),
          400: Color(0xFFE55B69),
          500: Color(0xFFDF3545),
          600: Color(0xFFBD1D2D),
          700: Color(0xFF8C1622),
          800: Color(0xFF5D0E16),
          900: Color(0xFF2C070B),
        },
      );

  static MaterialColor get secondaryYellow => const MaterialColor(
        0xffFEB908,
        <int, Color>{
          100: Color(0xFFFEF0CB),
          200: Color(0xFFFEE39D),
          300: Color(0xFFFED46B),
          400: Color(0xFFFEC73D),
          500: Color(0xFFFEB908),
          600: Color(0xFFD59900),
          700: Color(0xFF9D7100),
          800: Color(0xFF6B4D00),
          900: Color(0xFF332500),
        },
      );

  static MaterialColor get tertiaryBlue => const MaterialColor(
        0xff8733FE,
        <int, Color>{
          100: Color(0xFFE0CBFE),
          200: Color(0xFFCBA7FE),
          300: Color(0xFFB480FE),
          400: Color(0xFF9F5CFE),
          500: Color(0xFF8733FE),
          600: Color(0xFF6600F4),
          700: Color(0xFF4A00B2),
          800: Color(0xFF310075),
          900: Color(0xFF150033),
        },
      );

  static MaterialColor get dark => const MaterialColor(
        0xff0D1321,
        <int, Color>{
          100: Color(0xFFD9E0F0),
          200: Color(0xFF90A4D3),
          300: Color(0xFF4869B6),
          400: Color(0xFF2A3D6A),
          500: Color(0xFF0D1321),
          600: Color(0xFF0D1321),
          700: Color(0xFF0E1525),
          800: Color(0xFF0E1525),
          900: Color(0xFF0E1525),
        },
      );

  static MaterialColor get light => const MaterialColor(
        0xffFEFEFE,
        <int, Color>{
          100: Color(0xFFE5E5E5),
          200: Color(0xFFECECEC),
          300: Color(0xFFF1F1F1),
          400: Color(0xFFF9F9F9),
          500: Color(0xFFFEFEFE),
          600: Color(0xFFC6C6C6),
          700: Color(0xFF8B8B8B),
          800: Color(0xFF545454),
          900: Color(0xFF1A1A1A),
        },
      );

  static MaterialColor get grey => const MaterialColor(
        0xffA5A5A5,
        <int, Color>{
          100: Color(0xFFF5F5F5),
          200: Color(0xFFEFEFEF),
          300: Color(0xFFE2E2E2),
          400: Color(0xFFBBBBBB),
          500: Color(0xFFA5A5A5),
          600: Color(0xFF707070),
          700: Color(0xFF5C5C5C),
          800: Color(0xFF3F3F3F),
          900: Color(0xFF222222),
        },
      );

  static MaterialColor get successGreen => const MaterialColor(
        0xff47B872,
        <int, Color>{
          100: Color(0xFFDAF1E3),
          200: Color(0xFFB5E3C7),
          300: Color(0xFF91D4AA),
          400: Color(0xFF6CC68E),
          500: Color(0xFF47B872),
          600: Color(0xFF39935B),
          700: Color(0xFF2B6E44),
          800: Color(0xFF1D492D),
          900: Color(0xFF0F2517),
        },
      );

  static MaterialColor get dangerRed => const MaterialColor(
        0xffED3E3E,
        <int, Color>{
          100: Color(0xFFF9CEC6),
          200: Color(0xFFF6ADA2),
          300: Color(0xFFF28D7C),
          400: Color(0xFFF07C6A),
          500: Color(0xFFED3E3E),
          600: Color(0xFFED5D45),
          700: Color(0xFFEB4B33),
          800: Color(0xFFE93A21),
          900: Color(0xFFCC2D14),
        },
      );

  static MaterialColor get warningYellow => const MaterialColor(
        0xffF3C32F,
        <int, Color>{
          100: Color(0xFFF9E39F),
          200: Color(0xFFF7D777),
          300: Color(0xFFF6D265),
          400: Color(0xFFF5CB50),
          500: Color(0xFFF3C32F),
          600: Color(0xFFF1BB18),
          700: Color(0xFFE7B10F),
          800: Color(0xFFD4A20D),
          900: Color(0xFFC1930A),
        },
      );

  static MaterialColor get infoBlue => const MaterialColor(
        0xff1C3AA7,
        <int, Color>{
          100: Color(0xFF859BEA),
          200: Color(0xFF5070E1),
          300: Color(0xFF2E53DC),
          400: Color(0xFF2143C0),
          500: Color(0xFF1C3AA7),
          600: Color(0xFF1C379D),
          700: Color(0xFF18318C),
          800: Color(0xFF152B7A),
          900: Color(0xFF112669),
        },
      );
}
