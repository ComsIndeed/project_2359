import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const List<Color> _accentColors = [
    Color(0xFF448AFF),
    Color(0xFF7C4DFF),
    Color(0xFFE040FB),
    Color(0xFFFF5252),
    Color(0xFFFF6D00),
    Color(0xFFFFAB40),
    Color(0xFF69F0AE),
    Color(0xFF00E5FF),
    Color(0xFF40C4FF),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: themeNotifier,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Appearance', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 24),
              Text('Theme Mode', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Dark'),
                    icon: FaIcon(FontAwesomeIcons.moon),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Light'),
                    icon: FaIcon(FontAwesomeIcons.sun),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('System'),
                    icon: FaIcon(FontAwesomeIcons.circleHalfStroke),
                  ),
                ],
                selected: {themeNotifier.themeMode},
                onSelectionChanged: (modes) =>
                    themeNotifier.setThemeMode(modes.first),
              ),
              const SizedBox(height: 32),
              Text('Accent Color', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _accentColors.map((color) {
                  final isSelected =
                      themeNotifier.accentColor.toARGB32() == color.toARGB32();
                  return GestureDetector(
                    onTap: () => themeNotifier.setAccentColor(color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: theme.colorScheme.onSurface,
                                width: 3,
                              )
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const FaIcon(
                              FontAwesomeIcons.check,
                              color: Colors.white,
                              size: 24,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
