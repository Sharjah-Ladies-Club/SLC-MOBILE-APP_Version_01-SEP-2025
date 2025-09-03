import 'package:flutter/material.dart';

class ColorData {
  static const Color primaryColor = const Color(0xFFFFFFFF);
  static const Color primaryDarkColor = const Color(0xFFFFFFFF);
  static const Color accentColor = const Color(0xFF3EB5E3);
  static const Color lightAccentColor = const Color(0xFFCCE9F5);

  static const Color backgroundColor = const Color(0xFFF1F6FA);

//  static const Color primaryTextColor = const Color(0xFF9E9E9E);
//  static const Color secondaryTextColor = const Color(0xFFBDBDBD);

  static const Color primaryTextColor = const Color(0xff53575A);
  static const Color secondaryTextColor = const Color(0xff53575A);

  static const Color activeIconColor = const Color(0xFF3EB5E3);
  static const Color inActiveIconColor = const Color(0xFF9E9E9E);

  static const Color blackColor = const Color(0xFF000000);
  static const Color whiteColor = const Color(0xFFFFFFFF);

  static const Color sampleColor = const Color(0xFF9BC800);
  static const Color eventHomePageBodyColor = const Color(0xFFFCFEFF);
  static const Color eventHomePageSelectedCircularBorder =
      const Color(0xFF3AB5E4);
  static const Color eventHomePageSelectedCircularFill =
      const Color(0xFFC7E6F2);
  static const Color eventHomePageDeSelectedCircularBorder =
      const Color(0xFFBCBFC2);
  static const Color eventHomePageDeSelectedCircularFill =
      const Color(0xFFE6E9EB);
  static const Color cardTimeAndDateColor = const Color(0xFF53575A);
  static const Color colorBlue = const Color(0xFF3EB5E3);
  static const Color colorRed = Colors.red;
  static const Color loginBtnColor = const Color(0xFF3EB5E3);

  static const Color warningSnakBr = Colors.orange;
  static const Color successSnakBr = Colors.green;
  static const Color failureSnakBr = Colors.red;
  static const Color loginBackgroundColor = const Color(0xFFFAFAFA);
  static const Color facilityBtnBG = const Color(0xFF0E9677);
  static const Color eventTabColor = const Color(0x3AB5E4);
  static const Color eventTabUnSelectedColor = const Color(0xF9F9F9);
  static const Color grey300 = const Color(0xFFE9E9E9);
  static const Color textFieldUnderLine = const Color(0xFFE5E5E5);

  static const Color fitnessFacilityColor = const Color(0xffA81B8D);
  static const Color fitnessBgColor = const Color(0xffBBD400);
  static const Color fitnessTextBgColor = const Color(0xffEAF2C1);

  static const Color konBgColor = const Color(0xff199D9A);

  static const Color notificationTimeTextColor = const Color(0xffF7933A);

  static toColor(String color) {
    var hexColor = color != null ? color.replaceAll("#", "") : "";
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return primaryTextColor;
  }
}
