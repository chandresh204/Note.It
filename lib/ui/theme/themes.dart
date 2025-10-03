import 'package:flutter/material.dart';
import 'package:note_it/ui/theme/app_colors.dart';
import 'package:note_it/util/runtime_constants.dart';

ThemeData createLightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: RuntimeConstants.selectedAppColor.mapToMaterialColor()),
    useMaterial3: true,
    fontFamily: RuntimeConstants.selectedFontFamily.fontName
  );
}

ThemeData createDarkTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: RuntimeConstants.selectedAppColor.mapToMaterialColor(),
      brightness: Brightness.dark
    ),
    useMaterial3: true,
    fontFamily: RuntimeConstants.selectedFontFamily.fontName
  );
}

