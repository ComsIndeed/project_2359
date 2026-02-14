import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/card_button.dart';

// ---------------------------------------------------------------------------
// Utility class – pure functions that return generated colours
// ---------------------------------------------------------------------------

/// Static helpers that turn a [GenerationSeed] into deterministic colours.
///
/// Use this when you need the generated colours *without* the full background
/// widget (e.g. to tint an icon or build a custom decoration).
class SpecialBackgroundUtils {
  SpecialBackgroundUtils._(); // non‐instantiable

  /// Returns the two gradient colours that [SpecialBackgroundGenerator] would
  /// use for the given [seed] resolved against [label], [icon] and [subLabel].
  ///
  /// [style] defaults to [AppTheme.cardButtonStyle].
  /// Set [isDisabled] to use the disabled saturation/lightness values.
  static ({Color primary, Color secondary}) gradientColors({
    required GenerationSeed seed,
    required String label,
    required IconData icon,
    String? subLabel,
    CardButtonStyle? style,
    bool isDisabled = false,
  }) {
    final cardStyle = style ?? AppTheme.cardButtonStyle;
    final seedString = seed.resolve(label, icon, subLabel);
    final hash = seedString.hashCode;
    final r = Random(hash);

    final double hue = r.nextDouble() * 360;
    final double saturation = isDisabled
        ? cardStyle.disabledSaturation
        : cardStyle.saturation;
    final double lightness = isDisabled
        ? cardStyle.disabledLightness
        : cardStyle.lightness;

    final Color primary = HSLColor.fromAHSL(
      1.0,
      hue,
      saturation,
      lightness,
    ).toColor();

    final double secondaryHue = (hue + (r.nextBool() ? 25 : 155)) % 360;
    final Color secondary = HSLColor.fromAHSL(
      1.0,
      secondaryHue,
      saturation,
      lightness * 1.5,
    ).toColor();

    return (primary: primary, secondary: secondary);
  }

  /// Returns a single vibrant colour seeded by [seed], suitable for icon tints.
  static Color iconColor({
    required GenerationSeed seed,
    required String label,
    required IconData icon,
    String? subLabel,
  }) {
    final seedString = seed.resolve(label, icon, subLabel);
    final hash = seedString.hashCode;
    final r = Random(hash);

    final double hue = r.nextDouble() * 360;
    final double saturation = 0.85 + (r.nextDouble() * 0.15); // 0.85 – 1.0
    final double lightness = 0.55 + (r.nextDouble() * 0.1); // 0.55 – 0.65

    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  /// Builds the full [BoxDecoration] for a generated background card.
  ///
  /// When [hasBackground] is false a plain surface‐coloured decoration is
  /// returned instead.
  static BoxDecoration decoration({
    required GenerationSeed seed,
    required String label,
    required IconData icon,
    String? subLabel,
    CardButtonStyle? style,
    bool isDisabled = false,
    double borderRadius = 24,
  }) {
    final colors = gradientColors(
      seed: seed,
      label: label,
      icon: icon,
      subLabel: subLabel,
      style: style,
      isDisabled: isDisabled,
    );

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.primary, colors.secondary],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: isDisabled ? 0.05 : 0.15),
        width: 1,
      ),
      boxShadow: [
        if (!isDisabled)
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
      ],
    );
  }

  /// Returns the hash used by the abstract‐art painter for the given seed.
  static int painterHash({
    required GenerationSeed seed,
    required String label,
    required IconData icon,
    String? subLabel,
  }) {
    return seed.resolve(label, icon, subLabel).hashCode;
  }
}

// ---------------------------------------------------------------------------
// Widget – drop‐in background for any child
// ---------------------------------------------------------------------------

/// A widget that wraps its [child] with a procedurally generated gradient
/// background and optional abstract‐art overlay pattern.
///
/// ```dart
/// SpecialBackgroundGenerator(
///   seed: GenerationSeed.fromString('some-id'),
///   label: 'Biochemistry',
///   icon: FontAwesomeIcons.fileLines,
///   child: Text('Hello'),
/// )
/// ```
class SpecialBackgroundGenerator extends StatelessWidget {
  /// The generation seed that drives the deterministic background.
  final GenerationSeed seed;

  /// A label used to resolve [GenerationSeed] when the seed source is `label`.
  final String label;

  /// An icon used to resolve [GenerationSeed] when the seed source is `icon`.
  final IconData icon;

  /// An optional sublabel used to resolve [GenerationSeed] when the seed
  /// source is `sublabel`.
  final String? subLabel;

  /// Optional style overrides (saturation, lightness, etc.).
  final CardButtonStyle? style;

  /// Whether the background should use the disabled colour palette.
  final bool isDisabled;

  /// Border radius applied to the outer container and clip.
  final double borderRadius;

  /// The widget rendered on top of the background.
  final Widget child;

  const SpecialBackgroundGenerator({
    super.key,
    required this.seed,
    required this.label,
    required this.icon,
    this.subLabel,
    this.style,
    this.isDisabled = false,
    this.borderRadius = 24,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = SpecialBackgroundUtils.gradientColors(
      seed: seed,
      label: label,
      icon: icon,
      subLabel: subLabel,
      style: style,
      isDisabled: isDisabled,
    );

    final hash = SpecialBackgroundUtils.painterHash(
      seed: seed,
      label: label,
      icon: icon,
      subLabel: subLabel,
    );

    final decoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.primary, colors.secondary],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: isDisabled ? 0.05 : 0.15),
        width: 1,
      ),
      boxShadow: [
        if (!isDisabled)
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
      ],
    );

    return Container(
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Abstract art pattern layer
            Positioned.fill(
              child: CustomPaint(
                painter: AbstractArtPainter(hash, colors.primary),
              ),
            ),
            // Content layer
            child,
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Painter – moved here so it can be shared
// ---------------------------------------------------------------------------

/// Procedural abstract‐art painter driven by a deterministic [seed].
///
/// This is intentionally public so callers can use it standalone if needed.
class AbstractArtPainter extends CustomPainter {
  final int seed;
  final Color baseColor;

  AbstractArtPainter(this.seed, this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    final r = Random(seed);
    final paint = Paint()..isAntiAlias = true;
    final baseHue = HSLColor.fromColor(baseColor).hue;

    // Layer count: 3 to 6 layers for richness
    final int layerCount = 3 + (seed.abs() % 4);

    for (int i = 0; i < layerCount; i++) {
      final effectType = r.nextInt(100);

      if (effectType < 20) {
        _drawOrbs(canvas, size, r, paint, baseHue);
      } else if (effectType < 40) {
        _drawWavyStreams(canvas, size, r, paint, baseHue);
      } else if (effectType < 60) {
        _drawGeometry(canvas, size, r, paint, baseHue);
      } else if (effectType < 80) {
        _drawStars(canvas, size, r, paint, baseHue);
      } else {
        _drawAtmosphere(canvas, size, r, paint, baseHue);
      }
    }
  }

  void _drawOrbs(
    Canvas canvas,
    Size size,
    Random r,
    Paint paint,
    double baseHue,
  ) {
    final count = 2 + r.nextInt(4);
    for (int i = 0; i < count; i++) {
      final center = Offset(
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
      );
      final radius = 20.0 + r.nextDouble() * 120.0;
      final opacity = 0.02 + r.nextDouble() * 0.06;

      paint.style = PaintingStyle.fill;
      paint.color = HSLColor.fromAHSL(opacity, baseHue, 0.9, 0.6).toColor();

      if (r.nextBool()) {
        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: radius * 2,
            height: radius * (0.4 + r.nextDouble()),
          ),
          paint,
        );
      } else {
        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  void _drawWavyStreams(
    Canvas canvas,
    Size size,
    Random r,
    Paint paint,
    double baseHue,
  ) {
    final count = 3 + r.nextInt(5);
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;

    for (int i = 0; i < count; i++) {
      final opacity = 0.04 + r.nextDouble() * 0.1;
      paint.strokeWidth = 0.5 + r.nextDouble() * 30.0;
      final streamHue = (baseHue + (r.nextInt(20) - 10)) % 360;
      paint.color = HSLColor.fromAHSL(opacity, streamHue, 0.8, 0.7).toColor();

      final path = Path();
      final startX = r.nextDouble() * size.width;
      final startY = -20.0;
      path.moveTo(startX, startY);

      double currentX = startX;
      double currentY = startY;
      final frequency = 0.01 + r.nextDouble() * 0.05;
      final amplitude = 20.0 + r.nextDouble() * 60.0;

      while (currentY < size.height + 20) {
        currentY += 5;
        currentX = startX + sin(currentY * frequency + i) * amplitude;
        path.lineTo(currentX, currentY);
      }
      canvas.drawPath(path, paint);
    }
  }

  void _drawGeometry(
    Canvas canvas,
    Size size,
    Random r,
    Paint paint,
    double baseHue,
  ) {
    final count = 1 + r.nextInt(3);
    final sides = 3 + r.nextInt(4);

    for (int i = 0; i < count; i++) {
      final center = Offset(
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
      );
      final radius = 40.0 + r.nextDouble() * 150.0;
      final opacity = 0.02 + r.nextDouble() * 0.04;

      paint.style = r.nextBool() ? PaintingStyle.stroke : PaintingStyle.fill;
      paint.strokeWidth = 1.0;
      paint.color = Colors.white.withValues(alpha: opacity);

      final path = Path();
      for (int s = 0; s < sides; s++) {
        final angle = (s / sides) * 2 * pi + (r.nextDouble() * 0.5);
        final dist = radius * (0.8 + r.nextDouble() * 0.4);
        final px = center.dx + dist * cos(angle);
        final py = center.dy + dist * sin(angle);
        if (s == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  void _drawStars(
    Canvas canvas,
    Size size,
    Random r,
    Paint paint,
    double baseHue,
  ) {
    final count = 1 + r.nextInt(3);
    for (int i = 0; i < count; i++) {
      final center = Offset(
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
      );
      final outerRadius = 30.0 + r.nextDouble() * 100.0;
      final innerRadius = outerRadius * (0.3 + r.nextDouble() * 0.4);
      final points = 4 + r.nextInt(6);
      final opacity = 0.02 + r.nextDouble() * 0.05;

      paint.style = PaintingStyle.fill;
      paint.color = HSLColor.fromAHSL(opacity, baseHue, 0.9, 0.8).toColor();

      final path = Path();
      for (int p = 0; p < points * 2; p++) {
        final angle = (p / (points * 2)) * 2 * pi;
        final r = (p % 2 == 0) ? outerRadius : innerRadius;
        final px = center.dx + r * cos(angle);
        final py = center.dy + r * sin(angle);
        if (p == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  void _drawAtmosphere(
    Canvas canvas,
    Size size,
    Random r,
    Paint paint,
    double baseHue,
  ) {
    final count = 8 + r.nextInt(8);
    for (int i = 0; i < count; i++) {
      final center = Offset(
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
      );
      final radius = 60.0 + r.nextDouble() * 160.0;

      final shaderHue = (baseHue + (r.nextInt(40) - 20)) % 360;
      final gradient = RadialGradient(
        colors: [
          HSLColor.fromAHSL(0.15, shaderHue, 0.8, 0.6).toColor(),
          Colors.transparent,
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
      canvas.drawCircle(center, radius, paint);
      paint.shader = null;
    }
  }

  @override
  bool shouldRepaint(covariant AbstractArtPainter oldDelegate) =>
      oldDelegate.seed != seed;
}
