import 'package:flutter/material.dart';
import 'package:note_it/ui/theme/app_colors.dart';
import 'package:note_it/ui/theme/themes.dart';

class RuntimeConstants {
  static String? securePassword;
  static double currentTextScaler = 1;
  static AppColors selectedAppColor = AppColors.orange;
  static ThemeData lightThemeData = createLightTheme(Colors.orange);
  static ThemeData darkThemeData = createDarkTheme(Colors.orange);
}