import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';
import 'package:project_2359/features/help_page/help_page.dart';
import 'package:project_2359/features/anki_import_page/anki_import_page.dart';
import 'package:project_2359/core/utils/navigator_utils.dart';
import 'package:project_2359/core/widgets/desktop_title_bar_controller.dart';
import 'package:provider/provider.dart';

class DesktopTitleBar extends StatelessWidget {
  const DesktopTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb ||
        (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final controller = context.watch<DesktopTitleBarController>();

    final canPop = rootNavigatorKey.currentState?.canPop() ?? false;
    final showBackButton =
        !controller.hideBack && (controller.onBack != null || canPop);
    final onBack =
        controller.onBack ?? () => rootNavigatorKey.currentState?.pop();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          // Animated Back Button
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: showBackButton
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TitleBarAction(
                        icon: Icons.arrow_back,
                        onTap: onBack,
                        tooltip: "Back",
                      ),
                      const SizedBox(width: 4),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          Image.asset(
            isDark
                ? 'assets/images/app_icon_light_nobg.png'
                : 'assets/images/app_icon_nobg.png',
            height: 20,
          ),
          const SizedBox(width: 10),
          Text(
            "Project 2359",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.95),
            ),
          ),
          // Centered Title
          Expanded(
            child: DragToMoveArea(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: controller.centeredTitle != null
                      ? Text(
                          controller.centeredTitle!,
                          key: ValueKey(controller.centeredTitle),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          // Custom Actions
          if (controller.actions != null) ...[
            ...controller.actions!,
            const SizedBox(width: 4),
          ],
          // Import Anki Deck
          TitleBarAction(
            icon: FontAwesomeIcons.fileImport,
            onTap: () {
              rootNavigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (context) => const AnkiImportPage(),
                ),
              );
            },
            tooltip: "Import Anki Deck",
          ),
          const SizedBox(width: 4),
          // Help Action
          TitleBarAction(
            icon: FontAwesomeIcons.question,
            onTap: () {
              rootNavigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
            tooltip: "Help",
          ),
          const SizedBox(width: 4),
          // Settings Action
          TitleBarAction(
            icon: FontAwesomeIcons.gear,
            onTap: () {
              rootNavigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            tooltip: "Settings",
          ),
          const SizedBox(width: 4),
          const WindowButtons(),
        ],
      ),
    );
  }
}

class TitleBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const TitleBarAction({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FaIcon(
            icon,
            size: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _WindowButton(
          icon: Icons.remove,
          onPressed: () => windowManager.minimize(),
        ),
        _WindowButton(
          icon: Icons.crop_square,
          onPressed: () async {
            if (await windowManager.isMaximized()) {
              windowManager.unmaximize();
            } else {
              windowManager.maximize();
            }
          },
        ),
        _WindowButton(
          icon: Icons.close,
          isClose: true,
          onPressed: () => windowManager.close(),
        ),
      ],
    );
  }
}

class _WindowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    this.isClose = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      hoverColor: isClose
          ? Colors.red.withValues(alpha: 0.8)
          : theme.colorScheme.onSurface.withValues(alpha: 0.1),
      child: Container(
        width: 46,
        height: 40,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
