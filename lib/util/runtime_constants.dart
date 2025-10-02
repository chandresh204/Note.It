import 'package:flutter/material.dart';
import 'package:note_it/ui/theme/app_colors.dart';
import 'package:note_it/ui/theme/font_family.dart';
import 'package:note_it/ui/theme/themes.dart';

class RuntimeConstants {
  static String? securePassword;
  static double currentTextScaler = 1;
  static AppColors selectedAppColor = AppColors.orange;
  static FontFamily selectedFontFamily = FontFamily.raleway;
  static ThemeData lightThemeData = createLightTheme();
  static ThemeData darkThemeData = createDarkTheme();
}