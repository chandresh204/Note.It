import 'package:flutter/material.dart';
import 'package:note_it2/ui/theme/text_styles.dart';

class NoteTile extends StatelessWidget {
  final String noteText;
  final String createdTime;
  final String editTime;
  final Function() onClick;
  final Function() onLongClick;
  const NoteTile({
    super.key,
    required this.noteText,
    required this.createdTime,
    required this.editTime,
    required this.onClick,
    required this.onLongClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      onLongPress: onLongClick,
      child: Card(
        elevation: 9,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noteText,
                  style: AppTextStyles.heading2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(createdTime),
                Text(editTime),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
