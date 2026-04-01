import 'package:flutter/material.dart';

/// A premium, colored card icon that matches the application's design system.
///
/// It follows the style of source icons but with a more card-centric feel,
/// using [RoundedSuperellipseBorder] and vibrant gradients. It represents a
/// stack of flashcards with high fidelity.
class CardIcon extends StatelessWidget {
  /// The base accent color of the card. If null, uses the theme's primary color.
  final Color? color;

  /// The height of the icon. The width is automatically scaled by 0.75.
  final double size;

  const CardIcon({
    super.key,
    this.color,
    this.size = 24, // Optimized for toolbars
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Ensure we have a vibrant base color
    final baseColor = color ?? cs.primary;

    // Scale widths and radii
    final height = size;
    final width = size * 0.75;
    final baseRadius = size * 0.25;

    return SizedBox(
      width: width + (size * 0.1), // Extra space for the stack offset
      height: height + (size * 0.1),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Card (Deep Stack Element)
          // Represents the cards underneath in a deck
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: width,
              height: height,
              decoration: ShapeDecoration(
                color: baseColor.withValues(alpha: 0.3),
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(baseRadius),
                ),
              ),
            ),
          ),

          // Middle Card (Slightly shifted for depth)
          Positioned(
            right: size * 0.05,
            bottom: size * 0.05,
            child: Container(
              width: width,
              height: height,
              decoration: ShapeDecoration(
                color: baseColor.withValues(alpha: 0.5),
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(baseRadius),
                ),
              ),
            ),
          ),

          // Main Foreground Card
          Container(
            width: width,
            height: height,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [baseColor, Color.lerp(baseColor, Colors.black, 0.1)!],
              ),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(baseRadius),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              shadows: [
                BoxShadow(
                  color: baseColor.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Minimalist Accent Header (Matches WizardSourcePagePreview style)
                Container(
                  height: height * 0.18,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(baseRadius * 0.8),
                    ),
                  ),
                ),
                const Spacer(),
                // Representational content lines
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.18,
                    0,
                    width * 0.18,
                    height * 0.16,
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          margin: const EdgeInsets.only(bottom: 2.2),
                          height: 1.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: i == 2 ? 0.2 : 0.45,
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
