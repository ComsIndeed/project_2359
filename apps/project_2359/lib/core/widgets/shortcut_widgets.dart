import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:project_2359/core/settings/labs_settings.dart';

class ShortcutKeyWidget extends StatelessWidget {
  final String label;
  final bool isSmall;

  const ShortcutKeyWidget({
    super.key,
    required this.label,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 4 : 6,
        vertical: isSmall ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: cs.onSurface.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 0,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: isSmall ? 10 : 12,
            fontWeight: FontWeight.bold,
            color: cs.onSurfaceVariant.withValues(alpha: 0.8),
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

class ShortcutCombinationWidget extends StatelessWidget {
  final ShortcutInfo info;
  final bool isSmall;

  const ShortcutCombinationWidget({
    super.key,
    required this.info,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> parts = [];
    final isMac = ProjectShortcutManager.isApple;

    for (final mod in info.modifiers) {
      switch (mod) {
        case ShortcutModifier.alt:
          parts.add(isMac ? '⌥' : 'Alt');
        case ShortcutModifier.shift:
          parts.add('⇧');
        case ShortcutModifier.control:
          parts.add(isMac ? '⌃' : 'Ctrl');
        case ShortcutModifier.meta:
          parts.add(isMac ? '⌘' : 'Win');
      }
    }

    parts.add(_getKeyLabel(info.key));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < parts.length; i++) ...[
          ShortcutKeyWidget(label: parts[i], isSmall: isSmall),
          if (i < parts.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: isSmall ? 10 : 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
        ],
      ],
    );
  }

  String _getKeyLabel(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.enter) return '↵';
    if (key == LogicalKeyboardKey.escape) return 'Esc';
    if (key == LogicalKeyboardKey.backspace) return '⌫';
    if (key == LogicalKeyboardKey.delete) return '⌦';
    if (key == LogicalKeyboardKey.space) return 'Space';
    if (key == LogicalKeyboardKey.slash) return '/';
    if (key == LogicalKeyboardKey.comma) return ',';

    final label = key.keyLabel;
    if (label.length == 1) return label.toUpperCase();
    return label;
  }
}

class ShortcutDisplay extends StatefulWidget {
  final Widget child;
  final ShortcutInfo? info;
  final bool hoverOnly;
  final Axis direction; // Direction relative to child
  final bool showInline;

  const ShortcutDisplay({
    super.key,
    required this.child,
    this.info,
    this.hoverOnly = false,
    this.direction = Axis.vertical,
    this.showInline = false,
  });

  @override
  State<ShortcutDisplay> createState() => _ShortcutDisplayState();
}

class _ShortcutDisplayState extends State<ShortcutDisplay> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: labsSettings,
      builder: (context, _) {
        // Automatically listens to MediaQuery because it's inside build
        if (widget.info == null || !ProjectShortcutManager.isShortcutsEnabled) {
          return widget.child;
        }

        if (widget.hoverOnly) {
          return MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                widget.child,
                if (_isHovered)
                  Positioned(
                    bottom: -20,
                    child: ShortcutCombinationWidget(
                      info: widget.info!,
                      isSmall: true,
                    ),
                  ),
              ],
            ),
          );
        }

        if (widget.showInline) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.child,
              const SizedBox(width: 8),
              ShortcutCombinationWidget(info: widget.info!, isSmall: true),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child,
            const SizedBox(height: 4),
            ShortcutCombinationWidget(info: widget.info!, isSmall: true),
          ],
        );
      },
    );
  }
}
