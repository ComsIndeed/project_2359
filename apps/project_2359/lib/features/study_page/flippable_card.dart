import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class FlippableCard extends StatelessWidget {
  final String frontText;
  final String backText;
  final bool isFlipped;
  final VoidCallback onTap;

  const FlippableCard({
    super.key,
    required this.frontText,
    required this.backText,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: isFlipped ? 180 : 0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutBack,
        builder: (context, value, child) {
          final isBack = value > 90;
          final rotation = value * pi / 180;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotation),
            alignment: Alignment.center,
            child: isBack
                ? Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildCardFace(context, backText, true),
                  )
                : _buildCardFace(context, frontText, false),
          );
        },
      ),
    );
  }

  Widget _buildCardFace(BuildContext context, String text, bool isBack) {
    final theme = Theme.of(context);
    return Material(
      elevation: 4,
      color: theme.colorScheme.surface,
      shape: AppTheme.cardShape,
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: isBack
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.04),
                    theme.colorScheme.surface,
                  ],
                ),
              )
            : null,
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isBack)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "ANSWER",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Text(
                  text,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 24,
                    fontWeight: isBack ? FontWeight.w600 : FontWeight.w500,
                    color: isBack
                        ? theme.colorScheme.primary.withValues(alpha: 0.8)
                        : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
