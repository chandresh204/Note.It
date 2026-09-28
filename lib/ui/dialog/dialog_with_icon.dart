import 'package:flutter/material.dart';

import '../theme/text_styles.dart';

class DialogWithIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Function() onDismiss;
  const DialogWithIcon({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    double widgetSpacing = 16;
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.heading2),
            SizedBox(height: widgetSpacing),
            Icon(icon, size: 90),
            SizedBox(height: widgetSpacing),
            Text(description),
            SizedBox(height: widgetSpacing),
            TextButton(onPressed: onDismiss, child: Text('Okay'))
          ],
        ),
      ),
    );
  }
}
