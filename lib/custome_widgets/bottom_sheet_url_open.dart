import 'package:flutter/material.dart';

import '../themes/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetUrlOpen {
  final String url;
  final BuildContext context;
  BottomSheetUrlOpen({required this.url, required this.context});

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
                Text('Do you want to visit?', style: textStyle,),
                Text(url),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(onPressed: () {
                        launchUrl(Uri.parse(url));
                      },style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red),
                      ), child: const Text('Yes', style: TextStyle(color: Colors.white),)),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: ElevatedButton(onPressed: () => Navigator.pop(context),
                          child: const Text('No')),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
