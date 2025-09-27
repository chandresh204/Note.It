import 'package:flutter/material.dart';

import '../theme/text_styles.dart';

class ConfirmationDialog extends StatelessWidget {
  final String confirmationText;
  final String positiveButtonText;
  final String negativeButtonText;
  final Function() positiveButtonClick;
  final Function() negativeButtonClick;
  const ConfirmationDialog({
    super.key,
    required this.confirmationText,
    required this.positiveButtonText,
    required this.negativeButtonText,
    required this.positiveButtonClick,
    required this.negativeButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(confirmationText, style: AppTextStyles.heading2),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: negativeButtonClick,
                  child: Text(negativeButtonText),
                ),
                ElevatedButton(
                  onPressed: positiveButtonClick,
                  child: Text(positiveButtonText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
