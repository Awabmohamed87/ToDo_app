import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static const Color bluishClr = Color(0xFF4e5ae8);
  static const Color orangeClr = Color(0xCFFF8746);
  static const Color pinkClr = Color(0xFFff4667);
  static const Color white = Colors.white;
  static const primaryClr = bluishClr;
  static const Color darkGreyClr = Color(0xFF121212);
  static const Color darkHeaderClr = Color(0xFF424242);

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
        background: Colors.white,
        primary: primaryClr,
        brightness: Brightness.light),
  );
  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
        background: darkGreyClr,
        primary: darkGreyClr,
        brightness: Brightness.dark),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : MyTheme.darkGreyClr,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : MyTheme.darkGreyClr,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 16,
  ));
}
