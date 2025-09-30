import 'package:flutter/material.dart';

enum AppColors {
  orange, blue, green, red
}

AppColors getAppColorFromName(String name) {
  return AppColors.values.byName(name);
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
    }
  }
}