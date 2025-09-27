import 'package:flutter/material.dart';

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
          color: backgroundColor ?? ColorScheme.dark().primaryContainer,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              SizedBox(width: 8),
              Text(text, style: AppTextStyles.heading2)
            ],
          ),
        ),
      ),
    );
  }
}
