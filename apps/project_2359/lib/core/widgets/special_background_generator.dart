import 'dart:math';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/card_button.dart';

// ---------------------------------------------------------------------------
// Enums & Utilities
// ---------------------------------------------------------------------------

/// Different styles of procedurally generated backgrounds.
enum SpecialBackgroundType {
  /// The original style with wavy lines, geometry, and atmosphere.
  wavedLines,

  /// A modern mesh-style background with vibrant overlapping gradients.
  vibrantGradients,

  /// A geometric background with deterministic layered squares.
  geometricSquares,
}

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
    Brightness brightness = Brightness.dark,
    Color? adaptiveColor,
    Color? backgroundColor,
  }) {
    final cardStyle = style ?? AppTheme.cardButtonStyle;
    final seedString = seed.resolve(label, icon, subLabel);
    final hash = seedString.hashCode;
    final r = Random(hash);

    if (backgroundColor != null) {
      return (primary: backgroundColor, secondary: backgroundColor);
    }

    double hue;
    if (adaptiveColor != null) {
      // Use theme color hue with a small deterministic offset (+/- 30 deg)
      final baseHue = HSLColor.fromColor(adaptiveColor).hue;
      hue = (baseHue + (r.nextDouble() * 60 - 30)) % 360;
    } else {
      hue = r.nextDouble() * 360;
    }

    // Adjust lightness based on theme
    double saturation = isDisabled
        ? cardStyle.disabledSaturation
        : cardStyle.saturation;

    double lightness = isDisabled
        ? cardStyle.disabledLightness
        : cardStyle.lightness;

    if (brightness == Brightness.light) {
      // For light mode, we want a very soft, light background (pastel)
      // We flip from e.g. 0.05 to 0.95
      lightness = 1.0 - lightness;
      // Clamp to ensure it's readable and looks "light"
      lightness = lightness.clamp(0.9, 0.97);
      saturation = (saturation * 0.5).clamp(0.1, 0.4);
    }

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
      brightness == Brightness.dark ? lightness * 1.5 : lightness * 0.9,
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
    Brightness brightness = Brightness.dark,
    Color? backgroundColor,
  }) {
    final colors = gradientColors(
      seed: seed,
      label: label,
      icon: icon,
      subLabel: subLabel,
      style: style,
      isDisabled: isDisabled,
      brightness: brightness,
      backgroundColor: backgroundColor,
    );

    final isDark = brightness == Brightness.dark;

    return BoxDecoration(
      color: backgroundColor,
      gradient: backgroundColor != null
          ? null
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.secondary],
            ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: (isDark ? Colors.white : Colors.black).withValues(
          alpha: isDisabled ? 0.05 : 0.1,
        ),
        width: 1,
      ),
      boxShadow: [
        if (!isDisabled)
          BoxShadow(
            color: colors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
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
class SpecialBackgroundGenerator extends StatefulWidget {
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

  /// Whether the background colors should be derived from the theme's primary color.
  final bool isAdaptive;

  /// Whether to show the outer border.
  final bool showBorder;

  /// Whether to show the drop shadow.
  final bool showShadow;

  /// Border radius applied to the outer container and clip.
  final double borderRadius;

  /// The style of the generated background.
  final SpecialBackgroundType type;

  /// Whether to apply a drop-shadow clone of the child for depth.
  ///
  /// When enabled, a dark, blurred, slightly-offset copy of [child] is
  /// rendered behind the real content, giving uniform depth to all elements.
  final bool applyContentShadow;

  /// The widget rendered on top of the background.
  final Widget child;

  /// An optional background color. If provided, the generator will use this
  /// color instead of creating a gradient.
  final Color? backgroundColor;

  /// An optional brightness. If provided, the generator will use this
  /// to adjust the colors/patterns instead of the theme's brightness.
  final Brightness? overrideBrightness;

  const SpecialBackgroundGenerator({
    super.key,
    required this.seed,
    required this.label,
    required this.icon,
    this.subLabel,
    this.style,
    this.isDisabled = false,
    this.isAdaptive = true,
    this.showBorder = true,
    this.showShadow = true,
    this.borderRadius = 24,
    this.type = SpecialBackgroundType.wavedLines,
    this.applyContentShadow = false,
    required this.child,
    this.backgroundColor,
    this.overrideBrightness,
  });

  @override
  State<SpecialBackgroundGenerator> createState() =>
      _SpecialBackgroundGeneratorState();
}

class _SpecialBackgroundGeneratorState extends State<SpecialBackgroundGenerator>
    with SingleTickerProviderStateMixin {
  /// Global cache of pre-rendered art images, keyed by a composite hash.
  static final Map<int, ui.Image> _imageCache = {};

  ui.Image? _cachedImage;
  int? _cacheKey;

  // Animation & Sensors
  late AnimationController _controller;
  StreamSubscription<AccelerometerEvent>? _sensorSubscription;
  Offset _sensorOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _sensorSubscription = accelerometerEventStream().listen((event) {
      if (mounted) {
        setState(() {
          // Low-pass filter for smoothness
          _sensorOffset = Offset(
            (_sensorOffset.dx * 0.9) + (event.x * 0.1),
            (_sensorOffset.dy * 0.9) + (event.y * 0.1),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _sensorSubscription?.cancel();
    _cachedImage = null;
    _cacheKey = null;
    super.dispose();
  }

  /// Builds a composite cache key from all inputs that affect the painted output.
  int _buildCacheKey(
    int hash,
    double width,
    double height,
    SpecialBackgroundType type,
    Brightness brightness,
  ) {
    return Object.hash(hash, width.round(), height.round(), type, brightness);
  }

  /// Paints the [AbstractArtPainter] to an offscreen [ui.Image] and caches it.
  void _renderToImage(
    int painterHash,
    Color baseColor,
    Size size,
    SpecialBackgroundType type,
    Brightness brightness,
  ) {
    final key = _buildCacheKey(
      painterHash,
      size.width,
      size.height,
      type,
      brightness,
    );

    // Already cached (either by us or another instance with the same key).
    if (key == _cacheKey && _cachedImage != null) return;

    final existing = _imageCache[key];
    if (existing != null) {
      setState(() {
        _cacheKey = key;
        _cachedImage = existing;
      });
      return;
    }

    // Paint to an offscreen picture.
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = AbstractArtPainter(
      painterHash,
      baseColor,
      type,
      brightness,
    );
    painter.paint(canvas, size);
    final picture = recorder.endRecording();
    final image = picture.toImageSync(size.width.round(), size.height.round());
    picture.dispose();

    _imageCache[key] = image;

    setState(() {
      _cacheKey = key;
      _cachedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness =
        widget.overrideBrightness ?? Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    var colors = SpecialBackgroundUtils.gradientColors(
      seed: widget.seed,
      label: widget.label,
      icon: widget.icon,
      subLabel: widget.subLabel,
      style: widget.style,
      isDisabled: widget.isDisabled,
      brightness: brightness,
      adaptiveColor: widget.isAdaptive
          ? Theme.of(context).colorScheme.primary
          : null,
      backgroundColor: widget.backgroundColor,
    );

    // Decisive vibrancy boost - ensuring dark enough for white text protection
    if (widget.type == SpecialBackgroundType.vibrantGradients &&
        !widget.isDisabled &&
        widget.backgroundColor == null) {
      final hslPrimary = HSLColor.fromColor(colors.primary);
      final hslSecondary = HSLColor.fromColor(colors.secondary);

      colors = (
        primary: hslPrimary
            .withLightness(isDark ? 0.12 : 0.92)
            .withSaturation(1.0)
            .toColor(),
        secondary: hslSecondary
            .withLightness(isDark ? 0.18 : 0.88)
            .withSaturation(1.0)
            .toColor(),
      );
    }

    final hash = SpecialBackgroundUtils.painterHash(
      seed: widget.seed,
      label: widget.label,
      icon: widget.icon,
      subLabel: widget.subLabel,
    );

    final decoration = BoxDecoration(
      color: widget.backgroundColor,
      gradient: widget.backgroundColor != null
          ? null
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.secondary],
            ),
      borderRadius: BorderRadius.circular(widget.borderRadius),
      border: widget.showBorder
          ? Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: widget.isDisabled ? 0.05 : 0.08,
              ),
              width: 1,
            )
          : null,
      boxShadow: [
        if (!widget.isDisabled && widget.showShadow)
          BoxShadow(
            color: colors.primary.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
      ],
    );

    return Container(
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          children: [
            // Abstract art pattern layer – rendered from cached image
            Positioned.fill(
              child: RepaintBoundary(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );

                    // Only render when we have a real size.
                    if (size.width > 0 && size.height > 0) {
                      // Geometric squares are animated, so we don't cache them as images
                      // to avoid lag. Instead, we paint them directly every frame.
                      if (widget.type ==
                          SpecialBackgroundType.geometricSquares) {
                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: AbstractArtPainter(
                                hash,
                                colors.primary,
                                widget.type,
                                brightness,
                                sensorOffset: _sensorOffset,
                                flowValue: _controller.value,
                              ),
                              isComplex: true,
                              willChange: true,
                            );
                          },
                        );
                      }

                      // Synchronously build/fetch the cached image for static patterns.
                      final key = _buildCacheKey(
                        hash,
                        size.width,
                        size.height,
                        widget.type,
                        brightness,
                      );
                      if (key != _cacheKey || _cachedImage == null) {
                        // Schedule the render after this build frame.
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            _renderToImage(
                              hash,
                              colors.primary,
                              size,
                              widget.type,
                              brightness,
                            );
                          }
                        });
                      }
                    }

                    if (_cachedImage != null) {
                      return CustomPaint(
                        painter: _CachedImagePainter(_cachedImage!),
                        isComplex: false,
                        willChange: false,
                      );
                    }

                    // First frame: nothing to show yet (gradient behind is visible).
                    return const SizedBox.expand();
                  },
                ),
              ),
            ),
            // Legibility overlay (PROTECTIVE GRADIENT)
            if (widget.type == SpecialBackgroundType.vibrantGradients)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (isDark ? Colors.black : Colors.white).withValues(
                          alpha: 0.35,
                        ),
                        Colors.transparent,
                        Colors.transparent,
                        (isDark ? Colors.black : Colors.white).withValues(
                          alpha: 0.45,
                        ),
                        (isDark ? Colors.black : Colors.white).withValues(
                          alpha: 0.75,
                        ),
                      ],
                      stops: const [0.0, 0.25, 0.6, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
            // Content layer with optional shadow clone
            if (widget.applyContentShadow)
              ..._buildShadowedContent(isDark)
            else
              widget.child,
          ],
        ),
      ),
    );
  }

  /// Builds a shadow clone + the real child in a Stack.
  List<Widget> _buildShadowedContent(bool isDark) {
    return [
      // Shadow clone: non-interactive, invisible to a11y
      Positioned.fill(
        child: IgnorePointer(
          child: ExcludeSemantics(
            child: Transform.translate(
              offset: const Offset(0, 2),
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Opacity(
                  opacity: isDark ? 0.45 : 0.2,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // Real content on top
      widget.child,
    ];
  }
}

/// A trivial painter that just blits a pre-rendered [ui.Image].
class _CachedImagePainter extends CustomPainter {
  final ui.Image image;

  _CachedImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(
      canvas: canvas,
      rect: Offset.zero & size,
      image: image,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.low,
    );
  }

  @override
  bool shouldRepaint(covariant _CachedImagePainter oldDelegate) =>
      oldDelegate.image != image;
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
  final SpecialBackgroundType type;
  final Brightness brightness;
  final Offset sensorOffset;
  final double flowValue;

  AbstractArtPainter(
    this.seed,
    this.baseColor,
    this.type,
    this.brightness, {
    this.sensorOffset = Offset.zero,
    this.flowValue = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final r = Random(seed);
    final paint = Paint()..isAntiAlias = true;
    final baseHSL = HSLColor.fromColor(baseColor);
    final baseHue = baseHSL.hue;

    if (type == SpecialBackgroundType.vibrantGradients) {
      _drawVibrantGradients(canvas, size, r, paint, baseHue);
      return;
    }

    if (type == SpecialBackgroundType.geometricSquares) {
      _drawGeometricSquares(canvas, size, r, paint, baseHue);
      return;
    }

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

  void _drawGeometricSquares(
    Canvas canvas,
    Size size,
    Random r,
    Paint paint,
    double baseHue,
  ) {
    final isDark = brightness == Brightness.dark;

    // Very faint strokes
    final strokePaint = Paint()
      ..color = HSLColor.fromAHSL(
        isDark ? 0.1 : 0.08,
        baseHue,
        isDark ? 1.0 : 0.6,
        isDark ? 0.5 : 0.8,
      ).toColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Use a vertical sectioning approach to avoid clustering
    final int sections = 4;
    final double sectionHeight = size.height / sections;

    // ── FLOW & PARALLAX CALCULATIONS ──
    // Deterministic flow source (center, top, bottom, etc. based on seed)
    final flowSourceX = (seed % 3 == 0)
        ? size.width
        : (seed % 3 == 1 ? 0.0 : size.width / 2);
    final flowSourceY = (seed % 4 == 0)
        ? 0.0
        : (seed % 4 == 1 ? size.height : size.height / 2);
    final sourcePoint = Offset(flowSourceX, flowSourceY);

    // ── LARGE SQUARES (RIGHT) ──
    final int largeCount = 3 + r.nextInt(2);
    const double largeSize = 90;
    fillPaint.color = HSLColor.fromAHSL(
      isDark ? 0.12 : 0.08,
      baseHue,
      isDark ? 1.0 : 0.6,
      isDark ? 0.5 : 0.9,
    ).toColor();

    for (int i = 0; i < largeCount; i++) {
      final section = i % sections;

      // Target position
      final targetX = size.width - largeSize - (r.nextDouble() * 50);
      final targetY =
          (section * sectionHeight) +
          (r.nextDouble() * sectionHeight * 0.5) -
          20;

      _drawAnimatedSquare(
        canvas: canvas,
        source: sourcePoint,
        target: Offset(targetX, targetY),
        baseSize: largeSize,
        parallaxFactor: 3.5, // Move more (closest)
        fillPaint: fillPaint,
        strokePaint: strokePaint,
        r: r,
      );
    }

    // ── MEDIUM SQUARES (MIDDLE-RIGHT) ──
    final int medCount = 7 + r.nextInt(4);
    const double medSize = 45;
    fillPaint.color = HSLColor.fromAHSL(
      isDark ? 0.08 : 0.05,
      baseHue,
      isDark ? 1.0 : 0.6,
      isDark ? 0.5 : 0.9,
    ).toColor();

    for (int i = 0; i < medCount; i++) {
      final section = i % (sections * 2);
      final subSectionHeight = size.height / (sections * 2);

      final targetX = size.width - 180 - (r.nextDouble() * 90);
      final targetY =
          (section * subSectionHeight) +
          (r.nextDouble() * subSectionHeight * 0.5) -
          10;

      _drawAnimatedSquare(
        canvas: canvas,
        source: sourcePoint,
        target: Offset(targetX, targetY),
        baseSize: medSize,
        parallaxFactor: 1.5,
        fillPaint: fillPaint,
        strokePaint: strokePaint,
        r: r,
      );
    }

    // ── SMALL SQUARES (LEFT-ISH BREAKDOWN) ──
    final int smallCount = 15 + r.nextInt(10);
    const double smallSize = 22;
    fillPaint.color = HSLColor.fromAHSL(
      isDark ? 0.05 : 0.03,
      baseHue,
      isDark ? 1.0 : 0.6,
      isDark ? 0.5 : 0.95,
    ).toColor();

    for (int i = 0; i < smallCount; i++) {
      final targetX = size.width - 270 - (r.nextDouble() * 160);
      final targetY = r.nextDouble() * size.height - 10;

      _drawAnimatedSquare(
        canvas: canvas,
        source: sourcePoint,
        target: Offset(targetX, targetY),
        baseSize: smallSize,
        parallaxFactor: 0.5, // Move less (farthest)
        fillPaint: fillPaint,
        strokePaint: strokePaint,
        r: r,
      );
    }
  }

  void _drawAnimatedSquare({
    required Canvas canvas,
    required Offset source,
    required Offset target,
    required double baseSize,
    required double parallaxFactor,
    required Paint fillPaint,
    required Paint strokePaint,
    required Random r,
  }) {
    // 1. Calculate Flow (Shrink to/from source)
    // We use a phase shift for each square so they don't move in a block
    final phase = r.nextDouble();
    final t = (flowValue + phase) % 1.0;

    // Lerp position from source to target (or beyond)
    final currentPos = Offset.lerp(
      source,
      target + (target - source) * 0.5,
      t,
    )!;

    // Scale size based on flow (shrink as they get further from target, or grow from source)
    final scale = t < 0.2 ? (t / 0.2) : (t > 0.8 ? (1.0 - t) / 0.2 : 1.0);
    final currentSize = baseSize * scale;

    // 2. Apply Parallax (Sensor Offset)
    final finalPos =
        currentPos +
        Offset(
          sensorOffset.dx * parallaxFactor,
          -sensorOffset.dy * parallaxFactor,
        );

    // 3. Draw

    // Rotation (also seed-based + slow rotation over time)
    canvas.save();
    canvas.translate(
      finalPos.dx + currentSize / 2,
      finalPos.dy + currentSize / 2,
    );
    canvas.rotate((seed % 10) * 0.1 + (flowValue * pi * 0.2));

    final centeredRect = Rect.fromCenter(
      center: Offset.zero,
      width: currentSize,
      height: currentSize,
    );
    canvas.drawRect(centeredRect, fillPaint);
    canvas.drawRect(centeredRect, strokePaint);
    canvas.restore();
  }

  void _drawVibrantGradients(
    Canvas canvas,
    Size size,
    Random r,
    Paint paint,
    double baseHue,
  ) {
    final isDark = brightness == Brightness.dark;

    // 1. Draw Mesh Bubbles
    final bubbleCount = 5 + r.nextInt(3);
    for (int i = 0; i < bubbleCount; i++) {
      final center = Offset(
        r.nextDouble() * size.width,
        r.nextDouble() * size.height,
      );
      final radius = size.width * (0.6 + r.nextDouble() * 0.4);

      final hueOffset = (i * 72 + r.nextInt(30)) % 360;
      final bubbleHue = (baseHue + hueOffset) % 360;

      // Tight, bold color ranges - NO BLACK/WHITE CENTERS
      // For Dark Mode, we use mid-tones (0.25-0.35) so they stay colored but protect white text
      final double bubbleLightness = isDark
          ? 0.25 + (r.nextDouble() * 0.1)
          : 0.85;
      final double opacity = isDark ? 0.6 : 0.4;
      final double saturation = 1.0;

      final gradient = RadialGradient(
        colors: [
          HSLColor.fromAHSL(
            opacity,
            bubbleHue,
            saturation,
            bubbleLightness,
          ).toColor(),
          HSLColor.fromAHSL(
            0.0,
            bubbleHue,
            saturation,
            bubbleLightness,
          ).toColor(),
        ],
        stops: const [0.0, 1.0],
      );

      paint.shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
      // Screen for light additive blending, but since colors are dark, it won't hit white
      paint.blendMode = isDark ? BlendMode.screen : BlendMode.plus;
      canvas.drawCircle(center, radius, paint);
    }

    // 2. Add extra colored "blobs" for central richness (no white highlights)
    for (int i = 0; i < 2; i++) {
      final center = Offset(
        0.3 * size.width + r.nextDouble() * 0.4 * size.width,
        0.3 * size.height + r.nextDouble() * 0.4 * size.height,
      );
      final radius = size.width * 0.5;

      final blobHue = (baseHue + 180 + r.nextInt(40)) % 360;

      final gradient = RadialGradient(
        colors: [
          HSLColor.fromAHSL(0.4, blobHue, 1.0, isDark ? 0.2 : 0.9).toColor(),
          Colors.transparent,
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
      paint.blendMode = isDark ? BlendMode.overlay : BlendMode.softLight;
      canvas.drawCircle(center, radius, paint);
    }

    paint.blendMode = BlendMode.srcOver;
  }

  @override
  bool shouldRepaint(covariant AbstractArtPainter oldDelegate) =>
      oldDelegate.seed != seed ||
      oldDelegate.type != type ||
      oldDelegate.brightness != brightness ||
      oldDelegate.sensorOffset != sensorOffset ||
      oldDelegate.flowValue != flowValue;
}
