import 'package:flutter/material.dart';
import 'package:interactive_text/view/interactive_text.dart';
import '../../util/runtime_constants.dart';
import '../dialog/bottom_sheet_mail_compose.dart';
import '../dialog/bottom_sheet_phone_dial.dart';
import '../theme/text_styles.dart';
import '../dialog/bottom_sheet_url_open.dart';

class MyInteractiveText extends StatelessWidget {
  final String text;
  const MyInteractiveText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InteractiveText(
      text: text,
      textStyle: AppTextStyles.body,
      linkStyle: AppTextStyles.body.copyWith(
          color: Colors.blue,
          decoration: TextDecoration.underline),
      textScalerFactor: RuntimeConstants.currentTextScaler,
      onUrlClick: (url) {
        final dialog = BottomSheetUrlOpen(url: url, context: context);
        dialog.getUi();
      },
      onPhoneClick: (phone) {
        final dialog = BottomSheetPhoneDial(phone: phone, context: context);
        dialog.getUi();
      },
      onEmailClick: (email) {
        final dialog = BottomSheetMailCompose(eAddress: email, context: context);
        dialog.getUi();
      },
    );
  }
}
