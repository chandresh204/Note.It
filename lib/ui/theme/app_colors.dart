import 'package:flutter/material.dart';

enum AppColors {
  orange, blue, green, red, purple, pink, yellow, cyan
}

AppColors getAppColorFromName(String name) {
  try {
    return AppColors.values.byName(name);
  } catch (e) {
    return AppColors.orange;
  }

}

extension MapToMaterialColor on AppColors {
  Color mapToMaterialColor() {
    switch(this) {
      case AppColors.orange:
        return Colors.orange;
      case AppColors.blue:
        return Colors.blue;
      case AppColors.green:
        return Colors.green;
      case AppColors.red:
        return Colors.red;
      case AppColors.purple:
        return Colors.purple;
      case AppColors.pink:
        return Colors.pink;
      case AppColors.yellow:
        return Colors.yellow;
      case AppColors.cyan:
        return Colors.cyan;
    }
  }
}