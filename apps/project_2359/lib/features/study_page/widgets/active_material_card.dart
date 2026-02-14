import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';

class ActiveMaterialCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final Color? accentColor;
  final GenerationSeed? backgroundGenerator;

  const ActiveMaterialCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    this.accentColor,
    this.backgroundGenerator,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = accentColor ?? cs.primary;
    final bool hasBackground = backgroundGenerator != null;

    // Define colors based on whether we have a dark generated background or standard surface
    final Color textColor = hasBackground ? Colors.white : cs.onSurface;
    final Color subTextColor = hasBackground
        ? Colors.white.withValues(alpha: 0.7)
        : cs.onSurface.withValues(alpha: 0.7);
    final Color iconBgColor = hasBackground
        ? Colors.white.withValues(alpha: 0.15)
        : accent.withValues(alpha: 0.15);
    final Color iconColor = hasBackground ? Colors.white : accent;
    final Color progressBarBg = hasBackground
        ? Colors.white.withValues(alpha: 0.2)
        : accent.withValues(alpha: 0.2);
    final Color progressBarColor = hasBackground ? Colors.white : accent;

    // The inner content of the card
    final Widget content = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: FaIcon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              color: textColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12, color: subTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mastery",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: subTextColor,
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: progressBarBg,
            color: progressBarColor,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );

    // If using generator, wrap with SpecialBackgroundGenerator
    if (hasBackground) {
      return Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        child: SpecialBackgroundGenerator(
          seed: backgroundGenerator!,
          label: title,
          icon: icon,
          child: content,
        ),
      );
    }

    // Default container implementation
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: ShapeDecoration(color: cs.surface, shape: AppTheme.cardShape),
      child: content,
    );
  }
}
