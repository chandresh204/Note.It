import 'package:flutter/material.dart';
import 'package:note_it/util/runtime_constants.dart';

import '../theme/text_styles.dart';

class TextIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? backgroundColor;
  final Function() onClick;
  const TextIconButton({super.key, required this.icon, required this.text, required this.onClick, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? RuntimeConstants.lightThemeData.primaryColor.withAlpha(100),
          borderRadius: BorderRadius.circular(16)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              SizedBox(width: 8),
              Text(text, style: AppTextStyles.body)
            ],
          ),
        ),
      ),
    );
  }
}
