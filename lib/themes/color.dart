import 'package:flutter/material.dart';

class MyColor {
  final int colorId;
  final Color basicColor;
  final MaterialColor primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color onPrimary;

  MyColor(this.colorId, this.basicColor, this.primary, this.primaryLight,
      this.primaryDark, this.onPrimary);
}
