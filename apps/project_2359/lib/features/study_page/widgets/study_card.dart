import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';

class StudyCard extends StatelessWidget {
  final String frontText;
  final String backText;
  final bool isAnswerRevealed;
  final VoidCallback onTap;
  final VoidCallback? onViewSource;

  const StudyCard({
    super.key,
    required this.frontText,
    required this.backText,
    required this.isAnswerRevealed,
    required this.onTap,
    this.onViewSource,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Define colors for states
    final frontColor = Color.lerp(
      theme.colorScheme.surface,
      theme.colorScheme.primary,
      0.03, // Very subtle tint for front
    );

    final revealedColor = Color.lerp(
      theme.colorScheme.surface,
      theme.colorScheme.primary,
      0.1, // Subtle tint
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: ShapeDecoration(
          color: isAnswerRevealed ? revealedColor : frontColor,
          shape: AppTheme.cardShape,
          shadows: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Column(
                    key: ValueKey<bool>(isAnswerRevealed),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isAnswerRevealed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            "ANSWER",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.4,
                              ),
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Text(
                        isAnswerRevealed ? backText : frontText,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontSize: 28, // Slightly bigger for the bigger card
                          fontWeight: isAnswerRevealed ? FontWeight.w600 : FontWeight.w500,
                          color: isAnswerRevealed
                              ? theme.colorScheme.primary.withValues(alpha: 0.9)
                              : theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (onViewSource != null && !isAnswerRevealed)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: onViewSource,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.fileLines,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
