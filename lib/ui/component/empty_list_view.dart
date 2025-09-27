import 'package:flutter/material.dart';
import '../../util/runtime_constants.dart';
import '../theme/text_styles.dart';

class EmptyListView extends StatelessWidget {
  const EmptyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text('Click on + button to create new Note', 
            style: AppTextStyles.heading2, 
            textScaler: TextScaler.linear(RuntimeConstants.currentTextScaler),
            textAlign: TextAlign.center),
      ),
    );
  }
}
