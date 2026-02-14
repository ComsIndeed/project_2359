import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/pressable_scale.dart';

/// The layout direction for a [CardButton]
enum CardLayoutDirection {
  /// Icon on top, text below (default)
  vertical,

  /// Icon on the left, text on the right
  horizontal,
}

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
  final CardLayoutDirection layoutDirection;
  final EdgeInsetsGeometry? padding;
  final double? labelFontSize;
  final double? subLabelFontSize;
  final TextStyle? labelStyle;
  final TextStyle? subLabelStyle;
  final bool isCompact;
  final Color? accentColor;
  final GenerationSeed? iconColorGenerator;

  const CardButton({
    super.key,
    required this.icon,
    required this.label,
    this.subLabel,
    this.backgroundGenerator,
    this.onTap,
    this.style,
    this.layoutDirection = CardLayoutDirection.vertical,
    this.padding,
    this.labelFontSize,
    this.subLabelFontSize,
    this.labelStyle,
    this.subLabelStyle,
    this.isCompact = false,
    this.accentColor,
    this.iconColorGenerator,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasBackground = backgroundGenerator != null;
    final bool isDisabled = onTap == null;

    // Resolve the seed (defaults to label for deterministic properties even if background is hidden)
    final seedResolver = backgroundGenerator ?? GenerationSeed.useLabel();
    final seedString = seedResolver.resolve(label, icon, subLabel);
    final hash = seedString.hashCode;
    final r = Random(hash);

    // Determine decoration and painter color
    BoxDecoration decoration;
    Color? painterBaseColor;

    if (hasBackground) {
      final cardStyle = style ?? AppTheme.cardButtonStyle;
      final double hue = r.nextDouble() * 360;
      final double saturation = isDisabled
          ? cardStyle.disabledSaturation
          : cardStyle.saturation;
      final double lightness = isDisabled
          ? cardStyle.disabledLightness
          : cardStyle.lightness;

      painterBaseColor = HSLColor.fromAHSL(
        1.0,
        hue,
        saturation,
        lightness,
      ).toColor();
      final double secondaryHue = (hue + (r.nextBool() ? 25 : 155)) % 360;
      final Color secondaryColor = HSLColor.fromAHSL(
        1.0,
        secondaryHue,
        saturation,
        lightness * 1.5,
      ).toColor();

      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [painterBaseColor, secondaryColor],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDisabled ? 0.05 : 0.15),
          width: 1,
        ),
        boxShadow: [
          if (!isDisabled)
            BoxShadow(
              color: painterBaseColor.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      );
    } else {
      decoration = BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      );
    }

    return PressableScale(
      onTap: onTap,
      child: Container(
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: AppTheme.cardShape,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Opacity(
                opacity: isDisabled ? 0.4 : 1.0,
                child: Stack(
                  children: [
                    // Pattern Layer: Proc-gen Abstract Art (only if showing background)
                    if (hasBackground && painterBaseColor != null)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _AbstractArtPainter(hash, painterBaseColor),
                        ),
                      ),

                    // Content Layer
                    Padding(
                      padding:
                          padding ??
                          (isCompact
                              ? const EdgeInsets.all(12.0)
                              : const EdgeInsets.all(16.0)),
                      child: layoutDirection == CardLayoutDirection.horizontal
                          ? _buildHorizontalContent(context)
                          : _buildVerticalContent(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    final double iconSize = isCompact ? 22 : 28;
    final double containerPadding = isCompact ? 8 : 10;

    Color? generatedColor;
    if (iconColorGenerator != null) {
      final seedString = iconColorGenerator!.resolve(label, icon, subLabel);
      final hash = seedString.hashCode;
      final r = Random(hash);

      // Use vibrant colors for icons
      final double hue = r.nextDouble() * 360;
      final double saturation = 0.85 + (r.nextDouble() * 0.15); // 0.85 - 1.0
      final double lightness = 0.55 + (r.nextDouble() * 0.1); // 0.55 - 0.65

      generatedColor = HSLColor.fromAHSL(
        1.0,
        hue,
        saturation,
        lightness,
      ).toColor();
    }

    final Color effectiveIconColor =
        accentColor ?? generatedColor ?? Colors.white;

    // Calculate bg/border based on the effective color
    final Color backgroundColor = effectiveIconColor == Colors.white
        ? Colors.white.withValues(alpha: 0.12)
        : effectiveIconColor.withValues(alpha: 0.15);

    final Color borderColor = effectiveIconColor == Colors.white
        ? Colors.white.withValues(alpha: 0.25)
        : effectiveIconColor.withValues(alpha: 0.25);

    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: FaIcon(icon, color: effectiveIconColor, size: iconSize),
    );
  }

  Widget _buildVerticalContent(BuildContext context) {
    final cardStyle = style ?? AppTheme.cardButtonStyle;
    final effectiveLabelStyle = (labelStyle ?? cardStyle.labelStyle)?.copyWith(
      fontSize: labelFontSize,
    );
    final effectiveSubLabelStyle = (subLabelStyle ?? cardStyle.subLabelStyle)
        ?.copyWith(fontSize: subLabelFontSize);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconContainer(),
        const SizedBox(height: 16),
        Text(
          label,
          style: effectiveLabelStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subLabel != null) ...[
          const SizedBox(height: 4),
          Text(
            subLabel!,
            style: effectiveSubLabelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildHorizontalContent(BuildContext context) {
    final cardStyle = style ?? AppTheme.cardButtonStyle;
    final effectiveLabelStyle = (labelStyle ?? cardStyle.labelStyle)?.copyWith(
      fontSize: labelFontSize,
    );
    final effectiveSubLabelStyle = (subLabelStyle ?? cardStyle.subLabelStyle)
        ?.copyWith(fontSize: subLabelFontSize);

    return Row(
      children: [
        _buildIconContainer(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: effectiveLabelStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subLabel != null) ...[
                const SizedBox(height: 2),
                Text(
                  subLabel!,
                  style: effectiveSubLabelStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
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
  bool shouldRepaint(covariant _AbstractArtPainter oldDelegate) =>
      oldDelegate.seed != seed;
}
