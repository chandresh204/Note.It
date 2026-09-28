import 'package:flutter/material.dart';
import '/ui/theme/text_styles.dart';

class BottomSheetNoteActions extends StatelessWidget {
  final String noteText;
  final Function() onNoteShare;
  final Function() onDelete;
  const BottomSheetNoteActions({
    super.key,
    required this.noteText,
    required this.onNoteShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(noteText, maxLines: 4, style: AppTextStyles.heading2),
            Row(
              children: [
                //-------------------------------------------------delete button
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                          (states) => Colors.red,
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.white),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text('Delete', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
      
                ///------------------------------------------------ export Button
      
                //------------------------------------------------- Share Button
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onNoteShare();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.share),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text('Share'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
