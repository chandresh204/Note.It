import 'package:flutter/material.dart';

ThemeData createLightTheme(Color seedColor) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
    useMaterial3: true,
  );
}

ThemeData createDarkTheme(Color seedColor) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark
    ),
    useMaterial3: true,
  );
}

