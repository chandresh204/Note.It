import 'package:flutter/material.dart';

class BottomSheetDeleteConfirm extends StatelessWidget {
  final String noteText;
  final Function() onDelete;
  const BottomSheetDeleteConfirm({
    super.key,
    required this.noteText,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  'Sure To delete this?',
                  style: TextStyle(fontSize: 22),
                ),
                Text(noteText, maxLines: 2),
              ],
            ),
            Row(
              children: [
                //---------------------------------------------confirm delete
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                          (states) => Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.check, color: Colors.white),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text('Delete', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                //-----------------------------------------------cancel delete
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.cancel_outlined),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text('Cancel'),
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
