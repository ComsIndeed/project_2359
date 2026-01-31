import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllTap;

  const SectionHeader({super.key, required this.title, this.onViewAllTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          if (onViewAllTap != null)
            TextButton(
              onPressed: onViewAllTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "View All",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
