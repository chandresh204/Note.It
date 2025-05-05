import 'package:flutter/material.dart';

extension MySnackBar on BuildContext {
  void snackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(content: Text(text))
    );
  }
}

extension NullOrEmptyCheck on String? {
  bool isNullOrEmpty() {
    if(this == null || this!.isEmpty) {
      return true;
    }
    return false;
  }
}