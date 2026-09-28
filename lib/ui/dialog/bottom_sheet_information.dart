import 'package:flutter/material.dart';
import 'package:note_it/ui/theme/text_styles.dart';

class BottomSheetInformation extends StatelessWidget {
  final String information;
  final Function() onDismissed;
  const BottomSheetInformation({super.key, required this.information, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(information, style: AppTextStyles.body),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDismissed();
                      }, child: Text('Okay'))
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}
