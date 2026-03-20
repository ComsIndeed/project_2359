import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';

class SpecialSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;

  const SpecialSearchBar({
    super.key,
    this.hintText = "Search your collections...",
    this.controller,
    this.onChanged,
    this.onClear,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      height: 54,
      decoration: ShapeDecoration(
        color: cs.surface,
        shape: (AppTheme.cardShape as OutlinedBorder).copyWith(
          side: BorderSide(
            color: cs.onSurface.withValues(alpha: 0.1),
            width: 1.0,
          ),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.2 : 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: cs.onSurface.withValues(alpha: 0.9),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.3),
            letterSpacing: -0.2,
          ),
          prefixIcon: Center(
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 12),
              child: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                size: 16,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      controller!.clear();
                      onClear?.call();
                      onChanged?.call('');
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.circleXmark,
                      size: 16,
                      color: cs.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          filled: false,
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
