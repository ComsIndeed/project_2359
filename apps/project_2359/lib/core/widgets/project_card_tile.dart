import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/pressable_scale.dart';

class ProjectCardTile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? minHeight;
  final bool isSelected;
  final bool isCompact;

  const ProjectCardTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongTap,
    this.backgroundColor,
    this.padding,
    this.minHeight,
    this.isSelected = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Selection colors
    final Color effectiveBg = isSelected
        ? Color.lerp(backgroundColor ?? cs.surface, cs.primary, 0.08)!
        : (backgroundColor ?? cs.surface);

    final Color effectiveBorderColor = isSelected
        ? cs.primary
        : cs.onSurface.withValues(alpha: 0.1);

    final double effectiveBorderWidth = isSelected ? 3.0 : 1.0;

    // We cast to OutlinedBorder to use copyWith(side: ...)
    // AppTheme.cardShape is a ShapeBorder but RoundedSuperellipseBorder is an OutlinedBorder.
    final ShapeBorder effectiveShape = (AppTheme.cardShape as OutlinedBorder)
        .copyWith(
          side: BorderSide(
            color: effectiveBorderColor,
            width: effectiveBorderWidth,
          ),
        );

    return PressableScale(
      onTap: onTap,
      onLongPress: onLongTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: ShapeDecoration(color: effectiveBg, shape: effectiveShape),
        clipBehavior: Clip.antiAlias,
        child: Container(
          constraints: BoxConstraints(
            minHeight: minHeight ?? (isCompact ? 68 : 92),
          ),
          padding:
              padding ??
              EdgeInsets.symmetric(
                horizontal: isCompact ? 16 : 20,
                vertical: isCompact ? 10 : 16,
              ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 16)],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      DefaultTextStyle(
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: -0.3,
                          color: cs.onSurface.withValues(alpha: 0.9),
                        ),
                        child: title!,
                      ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      DefaultTextStyle(
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                        child: subtitle!,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 12), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
