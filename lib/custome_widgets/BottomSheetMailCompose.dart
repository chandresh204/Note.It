import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetMailCompose {
  final String eAddress;
  final BuildContext context;
  BottomSheetMailCompose({required this.eAddress, required this.context});

  getUi() {
    final textStyle = TextStyle(fontSize: MyTheme.primaryFontSize);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Do you want to send email?', style: textStyle,),
                Text(eAddress),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(onPressed: () {
                        Navigator.pop(context);
                        launchUrl(Uri.parse('mailto:$eAddress'));
                      },style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red),
                      ), child: const Text('Compose', style: TextStyle(color: Colors.white),)),
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
                        Clipboard.setData(ClipboardData(text: eAddress));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Email address copied to clipboard'))
                        );
                      },
                          child: const Text('Copy Address')),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
