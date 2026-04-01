import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectBackButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor =
        color ??
        theme.appBarTheme.iconTheme?.color ??
        theme.colorScheme.onSurface;

    return InkWell(
      onTap: onPressed ?? () => Navigator.maybePop(context),
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
            if (useFullWidth) const Spacer(),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
