import 'package:flutter/material.dart';
import '../../util/runtime_constants.dart';
import '../theme/text_styles.dart';

class EmptyListView extends StatelessWidget {
  final String searchQuery;
  const EmptyListView({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
            searchQuery.isNotEmpty ? 'No result found for "$searchQuery"' : 'Click on + button to create new Note',
            style: AppTextStyles.heading2, 
            textScaler: TextScaler.linear(RuntimeConstants.currentTextScaler),
            textAlign: TextAlign.center),
      ),
    );
  }
}
