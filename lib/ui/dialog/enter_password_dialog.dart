import 'package:flutter/material.dart';
import 'package:note_it/ui/theme/text_styles.dart';

class EnterPasswordDialog extends StatefulWidget {
  final Function(String) onSubmit;
  const EnterPasswordDialog({super.key, required this.onSubmit});

  @override
  State<EnterPasswordDialog> createState() => _EnterPasswordDialogState();
}

class _EnterPasswordDialogState extends State<EnterPasswordDialog> {

  final TextEditingController _controller = TextEditingController();

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
            Text('Enter Your Password', style: AppTextStyles.heading2),
            SizedBox(height: 16),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('Cancel')),
                ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                  widget.onSubmit(_controller.text);
                }, child: Text('Submit')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
