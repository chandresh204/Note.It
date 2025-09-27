import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import '../theme/text_styles.dart';

class BottomSheetUrlOpen {
  final String url;
  final BuildContext context;
  BottomSheetUrlOpen({required this.url, required this.context});

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
                  Text('Do you want to visit?', style: textStyle,),
                  Text(url),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(onPressed: () {
                          Navigator.pop(context);
                          launchUrl(Uri.parse(url));
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
                          Clipboard.setData(ClipboardData(text: url));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Link copied to clipboard'))
                          );
                        },
                            child: const Text('Copy Link')),
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
