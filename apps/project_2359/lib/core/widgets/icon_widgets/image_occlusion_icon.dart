import 'package:flutter/material.dart';

/// A premium, colored image occlusion icon that matches the application's design system.
///
/// It represents a photograph with occlusion boxes layered over it,
/// using [RoundedSuperellipseBorder] and vibrant gradients.
class ImageOcclusionIcon extends StatelessWidget {
  /// The base accent color of the icon. If null, uses the theme's primary color.
  final Color? color;

  /// The size of the icon (width). The height is automatically scaled.
  final double size;

  const ImageOcclusionIcon({
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
    final width = size;
    final height = size * 0.85;
    final baseRadius = size * 0.2;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main "Photo" Background
          Container(
            width: width,
            height: height,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  baseColor.withValues(alpha: 0.8),
                  baseColor.withValues(alpha: 1.0),
                ],
              ),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(baseRadius),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              shadows: [
                BoxShadow(
                  color: baseColor.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: ClipPath(
              clipper: _SuperellipseClipper(
                borderRadius: BorderRadius.circular(baseRadius),
              ),
              child: Stack(
                children: [
                  // Representational "Image Content" (Mountain/Sun)
                  Positioned(
                    bottom: -height * 0.2,
                    left: -width * 0.1,
                    child: Container(
                      width: width * 0.7,
                      height: height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.2,
                    right: width * 0.15,
                    child: Container(
                      width: width * 0.15,
                      height: width * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Occlusion Box 1
          Positioned(
            top: height * 0.25,
            left: width * 0.2,
            child: _buildOcclusionBox(
              width * 0.35,
              height * 0.2,
              Colors.amber.shade400,
            ),
          ),

          // Occlusion Box 2
          Positioned(
            bottom: height * 0.2,
            right: width * 0.15,
            child: _buildOcclusionBox(
              width * 0.3,
              height * 0.15,
              Colors.redAccent.shade200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOcclusionBox(double w, double h, Color boxColor) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(size * 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

/// A simple clipper to keep the "image content" inside the superellipse bounds.
class _SuperellipseClipper extends CustomClipper<Path> {
  final BorderRadius borderRadius;

  _SuperellipseClipper({required this.borderRadius});

  @override
  Path getClip(Size size) {
    // We use a regular RoundedRect for the clip to keep it simple,
    // as it closely matches the superellipse's inner bounds for child content.
    return Path()..addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ),
    );
  }

  @override
  bool shouldReclip(covariant _SuperellipseClipper oldClipper) =>
      oldClipper.borderRadius != borderRadius;
}
