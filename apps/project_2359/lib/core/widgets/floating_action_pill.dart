import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingActionPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const FloatingActionPill({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // A more sophisticated adaptive primary that isn't too "punchy"
    final activeColor = isDark
        ? Color.lerp(cs.primary, Colors.black, 0.4)!
        : Color.lerp(cs.primary, Colors.white, 0.15)!;

    // Solid background with high opacity — no blur needed.
    // The slight transparency gives a subtle "frosted" feel without GPU cost.
    final bgColor = isPrimary
        ? activeColor.withValues(alpha: 0.92)
        : isDark
        ? Color.lerp(
            theme.scaffoldBackgroundColor,
            Colors.white,
            0.10,
          )!.withValues(alpha: 0.95)
        : Color.lerp(
            theme.scaffoldBackgroundColor,
            Colors.black,
            0.04,
          )!.withValues(alpha: 0.95);

    final borderColor = isPrimary
        ? cs.primary.withValues(alpha: 0.3)
        : cs.onSurface.withValues(alpha: 0.1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 0.6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  icon,
                  size: 15,
                  color: isPrimary
                      ? cs.onPrimary
                      : cs.onSurface.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPrimary
                        ? cs.onPrimary
                        : cs.onSurface.withValues(alpha: 0.8),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
