import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

enum _SeedSource { manual, label, icon, sublabel }

class GenerationSeed {
  final String? _value;
  final _SeedSource _source;

  const GenerationSeed._(this._value, this._source);

  factory GenerationSeed.fromString(String value) {
    return GenerationSeed._(value, _SeedSource.manual);
  }

  static const GenerationSeed label = GenerationSeed._(null, _SeedSource.label);
  static const GenerationSeed icon = GenerationSeed._(null, _SeedSource.icon);
  static const GenerationSeed sublabel = GenerationSeed._(
    null,
    _SeedSource.sublabel,
  );

  factory GenerationSeed.useLabel() => label;
  factory GenerationSeed.useIcon() => icon;
  factory GenerationSeed.useSublabel() => sublabel;

  String resolve(String label, IconData icon, String? subLabel) {
    switch (_source) {
      case _SeedSource.manual:
        return _value!;
      case _SeedSource.label:
        return label;
      case _SeedSource.icon:
        return icon.codePoint.toString();
      case _SeedSource.sublabel:
        return subLabel ?? label; // Fallback to label if sublabel is null
    }
  }
}

class CardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subLabel;
  final GenerationSeed? backgroundGenerator;
  final VoidCallback? onTap;
  final CardButtonStyle? style;

  const CardButton({
    super.key,
    required this.icon,
    required this.label,
    this.subLabel,
    this.backgroundGenerator,
    this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve the seed
    final seedResolver = backgroundGenerator ?? GenerationSeed.useLabel();
    final seedString = seedResolver.resolve(label, icon, subLabel);

    // Deterministic random generator from hash
    final hash = seedString.hashCode;
    final r = Random(hash);

    final bool isDisabled = onTap == null;

    // Use provided style or fall back to AppTheme defaults
    final cardStyle = style ?? AppTheme.cardButtonStyle;

    // 1. Hue Selection (Determined by hash, but consistent S/L from style)
    final double hue = r.nextDouble() * 360;
    final double saturation = isDisabled
        ? cardStyle.disabledSaturation
        : cardStyle.saturation;
    final double lightness = isDisabled
        ? cardStyle.disabledLightness
        : cardStyle.lightness;

    final Color baseColor = HSLColor.fromAHSL(
      1.0,
      hue,
      saturation,
      lightness,
    ).toColor();
    // Secondary color for gradient (Shifted based on hash)
    final double secondaryHue = (hue + (r.nextBool() ? 25 : 155)) % 360;
    final Color secondaryColor = HSLColor.fromAHSL(
      1.0,
      secondaryHue,
      saturation,
      lightness * 1.5,
    ).toColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: AppTheme.cardShape,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [baseColor, secondaryColor],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDisabled ? 0.05 : 0.15),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Opacity(
              opacity: isDisabled ? 0.4 : 1.0,
              child: Stack(
                children: [
                  // Pattern Layer: Proc-gen Abstract Art
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _AbstractArtPainter(hash, baseColor),
                    ),
                  ),

                  // Content Layer
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Icon(icon, color: Colors.white, size: 28),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          label,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subLabel != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subLabel!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.55),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AbstractArtPainter extends CustomPainter {
  final int seed;
  final Color baseColor;

  _AbstractArtPainter(this.seed, this.baseColor);

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
      // Jitter hue slightly for "rainbow" streams if hash bits allow
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
        if (s == 0)
          path.moveTo(px, py);
        else
          path.lineTo(px, py);
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
        if (p == 0)
          path.moveTo(px, py);
        else
          path.lineTo(px, py);
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
  bool shouldRepaint(covariant _AbstractArtPainter oldDelegate) =>
      oldDelegate.seed != seed;
}
