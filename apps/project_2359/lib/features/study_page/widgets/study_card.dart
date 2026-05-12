import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/app_controller.dart';
import 'package:provider/provider.dart';

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
        duration: const Duration(milliseconds: 150),
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
                  duration: const Duration(milliseconds: 100),
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
                      Html(
                        data: isAnswerRevealed ? backText : frontText,
                        extensions: [
                          TagExtension(
                            tagsToExtend: {"img"},
                            builder: (extensionContext) {
                              final src = extensionContext.attributes['src'];
                              if (src != null) {
                                return _DatabaseImage(name: src);
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                        style: {
                          "body": Style(
                            fontSize: FontSize(24),
                            fontWeight: isAnswerRevealed ? FontWeight.w600 : FontWeight.w500,
                            color: isAnswerRevealed
                                ? theme.colorScheme.primary.withValues(alpha: 0.9)
                                : theme.colorScheme.onSurface,
                            textAlign: TextAlign.center,
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          ".cloze-placeholder": Style(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          ".cloze-hint": Style(
                            color: theme.colorScheme.primary.withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                          ".cloze-answer": Style(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        },
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

class _DatabaseImage extends StatelessWidget {
  final String name;
  const _DatabaseImage({required this.name});

  @override
  Widget build(BuildContext context) {
    final appController = context.read<AppController>();
    final db = appController.appDatabase;

    return FutureBuilder<AssetItem?>(
      future: (db.select(db.assetItems)..where((t) => t.name.equals(name))).getSingleOrNull(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!.data,
            fit: BoxFit.contain,
          );
        }
        // If image not found, might be a network image or just missing
        if (name.startsWith('http')) {
          return Image.network(name);
        }
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.broken_image, size: 32, color: Colors.grey),
        );
      },
    );
  }
}
