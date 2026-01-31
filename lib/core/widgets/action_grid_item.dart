import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class ActionGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subLabel;
  final Color iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const ActionGridItem({
    super.key,
    required this.icon,
    required this.label,
    this.subLabel,
    this.iconColor = AppTheme.primary,
    this.backgroundColor = AppTheme.secondarySurface,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: AppTheme.cardShape,
      child: InkWell(
        onTap: onTap,
        customBorder: AppTheme.cardShape,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const Spacer(),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subLabel != null) ...[
                const SizedBox(height: 4),
                Text(
                  subLabel!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
