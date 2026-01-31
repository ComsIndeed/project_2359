import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    this.hintText = "Search...",
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: AppTheme.secondarySurface,
        shape: AppTheme.defaultShape, // Using the squircle shape
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                filled: false, // Handled by container
              ),
            ),
          ),
          if (onFilterTap != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onFilterTap,
              child: const Icon(
                Icons.filter_list,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
