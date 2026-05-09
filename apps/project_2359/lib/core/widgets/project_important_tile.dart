import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class ProjectImportantTile extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const ProjectImportantTile({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Use AppTheme.important for the red theme
    final Color tintColor = AppTheme.important;
    final Color backgroundColor = tintColor.withValues(alpha: 0.08);
    final Color borderColor = tintColor.withValues(alpha: 0.5);

    final ShapeBorder shape = (AppTheme.cardShape as OutlinedBorder).copyWith(
      side: BorderSide(color: borderColor, width: 1.0),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: double.infinity,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: ShapeDecoration(color: backgroundColor, shape: shape),
          child: child,
        ),
      ),
    );
  }
}
