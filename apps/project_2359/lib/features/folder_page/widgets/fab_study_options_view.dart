import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/core/widgets/sensor_reactive_border.dart';

class FabStudyOptionsView extends StatelessWidget {
  final String folderId;

  const FabStudyOptionsView({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Ready to Level Up?",
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Choose your training method",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 32),

          // 1. STUDY DUE - Main Action
          _StudyOptionCard(
            title: "Study Due Cards",
            description: "Do you want to study your cards due right now?",
            icon: FontAwesomeIcons.boltLightning,
            color: Colors.orange,
            isPrimary: true,
            onTap: () {
              // TODO: Navigate to study due
            },
          ),
          const SizedBox(height: 16),

          // 2. MEMORIZE LESSONS - Secondary
          _StudyOptionCard(
            title: "Memorize All",
            description:
                "Do you want to memorize all your cards in a structured way?",
            icon: FontAwesomeIcons.brain,
            color: Colors.blue,
            onTap: () {
              // TODO: Navigate to memorize mode
            },
          ),
          const SizedBox(height: 16),

          // 3. PRACTICE QUIZZES - Third
          _StudyOptionCard(
            title: "Practice Quizzes",
            description: "Do you want to practice with quiz questions?",
            icon: FontAwesomeIcons.listCheck,
            color: Colors.green,
            onTap: () {
              // TODO: Navigate to quiz mode
            },
          ),
          const SizedBox(height: 32),

          // THE FINAL BOSS - Assessment (Hidden/Scrolled)
          const _FinalBossDivider(),
          const SizedBox(height: 24),

          _StudyOptionCard(
            title: "Mockup Assessment",
            description: "Timed and graded assessment with no distractions.",
            icon: FontAwesomeIcons.trophy,
            color: const Color(0xFFD4AF37), // Gold
            isGold: true,
            onTap: () {
              // TODO: Navigate to assessment mode
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _StudyOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isGold;

  const _StudyOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isPrimary = false,
    this.isGold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget content = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPrimary
            ? color.withValues(alpha: 0.1)
            : cs.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPrimary
              ? color.withValues(alpha: 0.3)
              : cs.onSurface.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: FaIcon(icon, color: color, size: 24)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 14,
            color: cs.onSurface.withValues(alpha: 0.2),
          ),
        ],
      ),
    );

    if (isPrimary || isGold) {
      content = SensorReactiveBorder(
        borderRadius: 24,
        borderWidth: 2,
        colors: isGold
            ? [
                const Color(0xFFFFD700),
                const Color(0xFFB8860B),
                const Color(0xFFD4AF37),
              ]
            : [color, color.withValues(alpha: 0.5), color],
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: content,
      ),
    );
  }
}

class _FinalBossDivider extends StatelessWidget {
  const _FinalBossDivider();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: cs.onSurface.withValues(alpha: 0.1))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "THE FINAL BOSS",
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: cs.onSurface.withValues(alpha: 0.2),
              letterSpacing: 2.0,
            ),
          ),
        ),
        Expanded(child: Divider(color: cs.onSurface.withValues(alpha: 0.1))),
      ],
    );
  }
}
