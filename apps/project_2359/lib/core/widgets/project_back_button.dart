import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:project_2359/core/widgets/shortcut_widgets.dart';
import 'package:flutter/services.dart';

class ProjectBackButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final bool useFullWidth;

  const ProjectBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.useFullWidth = false,
  });

  @override
  State<ProjectBackButton> createState() => _ProjectBackButtonState();
}

class _ProjectBackButtonState extends State<ProjectBackButton> {
  final _shortcut = const ShortcutInfo(
    label: 'Back',
    key: LogicalKeyboardKey.escape,
  );

  @override
  void initState() {
    super.initState();
    ProjectShortcutManager.registerShortcut(_shortcut, _onBack);
  }

  @override
  void dispose() {
    ProjectShortcutManager.unregisterShortcut(_shortcut);
    super.dispose();
  }

  void _onBack() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor =
        widget.color ??
        theme.appBarTheme.iconTheme?.color ??
        theme.colorScheme.onSurface;

    return ShortcutDisplay(
      info: _shortcut,
      showInline: true,
      child: InkWell(
        onTap: _onBack,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: buttonColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Back',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: buttonColor,
                  letterSpacing: -0.3,
                ),
              ),
              if (widget.useFullWidth) const Spacer(),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
