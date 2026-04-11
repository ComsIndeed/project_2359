import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';

class HomeHeader extends StatelessWidget {
  final bool isLandscape;
  final VoidCallback? onPlusTap;

  const HomeHeader({super.key, this.isLandscape = false, this.onPlusTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Compact App Icon
        Hero(
          tag: 'app_icon',
          child: Image.asset(
            isDark
                ? 'assets/images/app_icon_light_nobg.png'
                : 'assets/images/app_icon_nobg.png',
            height: 28, // More compact icon
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "Project 2359",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.95),
            ),
          ),
        ),
        // Settings Action
        if (!isLandscape) const _HeaderActions(),
        if (isLandscape)
          IconButton(
            onPressed: onPlusTap,
            icon: const FaIcon(FontAwesomeIcons.circlePlus, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.onSurface.withValues(
                alpha: 0.05,
              ),
            ),
          ),
      ],
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: FaIcon(
              FontAwesomeIcons.gear,
              size: 15,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}
