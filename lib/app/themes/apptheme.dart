import 'package:flutter/material.dart';

class AppTheme {
  // Theme Colors
  static const Color themeColor = Color.fromARGB(255, 0, 102, 255);
  static const Color FontColor = Color.fromARGB(255, 52, 60, 68);
  static const Color FontHoverColor = Color.fromARGB(255, 47, 54, 61);
  static const Color IconColor = Color.fromARGB(255, 52, 60, 68);
  static const Color IconHoverColor = Color.fromARGB(255, 47, 54, 61);
  static const Color lightblackColor = Color.fromARGB(255, 39, 45, 51);
  static const Color floatingButtonBgColor = Color.fromARGB(255, 255, 136, 0);
  static const Color starColor = Color.fromARGB(255, 255, 208, 0);
  static const Color whiteColor = Colors.white;
  static const Color dimwhiteColor = Color.fromARGB(97, 255, 255, 255);
  static const Color greyColor = Colors.grey;
  static const Color greenColor = Colors.green;
  static const Color redColor = Colors.red;
  static const Color purpleColor = Color.fromARGB(160, 155, 39, 176);
  static const Color yellowColor = Colors.yellow;
  static const Color blackColor = Colors.black;
  static const Color transparentColor = Colors.transparent;
}

class MyTheme {
  static ThemeData myTheme = ThemeData(
    primaryColor: AppTheme.themeColor,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppTheme.themeColor, // Progress color
      circularTrackColor: Colors.grey[300], // Base color (unfilled part)
    ),
  );
}