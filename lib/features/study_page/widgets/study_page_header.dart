import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class StudyPageHeader extends StatelessWidget {
  final VoidCallback? onNewTap;

  const StudyPageHeader({super.key, this.onNewTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Study Hub', style: Theme.of(context).textTheme.displayMedium),
          ElevatedButton.icon(
            onPressed: onNewTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: AppTheme.defaultShape as OutlinedBorder,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'New',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
