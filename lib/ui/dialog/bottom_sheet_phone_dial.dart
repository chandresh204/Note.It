import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import '../theme/text_styles.dart';

class BottomSheetPhoneDial {
  final String phone;
  final BuildContext context;
  BottomSheetPhoneDial({required this.phone, required this.context});

  getUi() {
    final textStyle = AppTextStyles.heading2;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Do you want to dial?', style: textStyle,),
                  Text(phone),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(onPressed: () {
                          Navigator.pop(context);
                          launchUrl(Uri.parse('tel:$phone'));
                        },style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.red),
                        ), child: const Text('Yes', style: TextStyle(color: Colors.white),)),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: ElevatedButton(onPressed: () => Navigator.pop(context),
                            child: const Text('No')),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: ElevatedButton(onPressed: () {
                          Navigator.pop(context);
                          Clipboard.setData(ClipboardData(text: phone));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Numbers copied to clipboard'))
                          );
                        },
                            child: const Text('Copy Numbers')),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
