import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A single action item shown inside the expanded [ExpandableFab] panel.
class FabAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const FabAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });
}

/// Wraps page content and provides an expanding FAB overlay.
///
/// When tapped with [actions] provided, the pill springs open into a
/// full panel covering ~52% of the screen. The page content scales
/// down and dims behind an animated scrim.
///
/// Usage:
/// ```dart
/// body: ExpandableFab(
///   label: "Create",
///   icon: FontAwesomeIcons.circlePlus,
///   isPrimary: false,
///   actions: [ FabAction(...), ... ],
///   child: YourPageContent(),
/// )
/// ```
class ExpandableFab extends StatefulWidget {
  final Widget child;
  final String label;
  final IconData icon;
  final bool isPrimary;
  final Color? backgroundColor;
  final List<FabAction> actions;

  const ExpandableFab({
    super.key,
    required this.child,
    required this.label,
    required this.icon,
    required this.actions,
    this.isPrimary = true,
    this.backgroundColor,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with TickerProviderStateMixin {
  late final AnimationController _expandCtrl;
  late final AnimationController _rotateCtrl;
  late final Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 400),
    );
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandCtrl,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  void _open() {
    _expandCtrl.forward();
    _rotateCtrl.repeat();
  }

  void _close() {
    _expandCtrl.reverse();
    _rotateCtrl.stop();
  }

  void _handleScrimTap(TapUpDetails details, Size screenSize) {
    final pos = details.globalPosition;
    // Dead zones: bottom 90px (near the panel/pill edge), sides 24px
    if (pos.dy > screenSize.height - 90) return;
    if (pos.dx < 24 || pos.dx > screenSize.width - 24) return;
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenSize = mq.size;
    final bottomPad = mq.padding.bottom;
    final fabBottom = bottomPad + 12.0;

    final expandedWidth = screenSize.width * 0.88;
    final expandedHeight = min(screenSize.height * 0.52, 400.0);

    return AnimatedBuilder(
      animation: _expandAnim,
      builder: (context, _) {
        // Clamp overshoot for geometry, raw value for opacities/timing
        final rawT = _expandAnim.value;
        final t = rawT.clamp(0.0, 1.0);
        final isActive = _expandCtrl.status != AnimationStatus.dismissed;

        return Stack(
          children: [
            // ── PAGE CONTENT (scales down into the background) ──
            Transform.scale(
              scale: 1.0 - (0.045 * t),
              alignment: Alignment.topCenter,
              child: widget.child,
            ),

            // ── SCRIM ──
            if (isActive)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (d) => _handleScrimTap(d, screenSize),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.bottomCenter,
                        radius: 1.5,
                        colors: [
                          Colors.black.withValues(alpha: 0.75 * t),
                          Colors.black.withValues(alpha: 0.55 * t),
                          Colors.black.withValues(alpha: 0.95 * t),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

            // ── ROTATING GRADIENT TEXTURE (decorative, on top of scrim) ──
            if (isActive)
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: (t * 0.9).clamp(0.0, 0.9),
                    child: AnimatedBuilder(
                      animation: _rotateCtrl,
                      builder: (context, _) => Transform.rotate(
                        angle: _rotateCtrl.value * 2 * pi,
                        child: const _SweepOverlay(),
                      ),
                    ),
                  ),
                ),
              ),

            // ── EXPANDED PANEL (absorbs all taps so scrim doesn't see them) ──
            if (isActive)
              Positioned(
                bottom: fabBottom,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: _ExpandedPanel(
                      t: t,
                      rawT: rawT,
                      expandedWidth: expandedWidth,
                      expandedHeight: expandedHeight,
                      actions: widget.actions,
                      onClose: _close,
                      isPrimary: widget.isPrimary,
                      backgroundColor: widget.backgroundColor,
                    ),
                  ),
                ),
              ),

            // ── COLLAPSED PILL (only while fully dismissed) ──
            if (!isActive)
              Positioned(
                bottom: fabBottom,
                left: 0,
                right: 0,
                child: Center(
                  child: _CollapsedPill(
                    label: widget.label,
                    icon: widget.icon,
                    isPrimary: widget.isPrimary,
                    onTap: widget.actions.isNotEmpty ? _open : null,
                    backgroundColor: widget.backgroundColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// EXPANDED PANEL
// ---------------------------------------------------------------------------

class _ExpandedPanel extends StatelessWidget {
  final double t;
  final double rawT;
  final double expandedWidth;
  final double expandedHeight;
  final List<FabAction> actions;
  final VoidCallback onClose;
  final bool isPrimary;
  final Color? backgroundColor;

  const _ExpandedPanel({
    required this.t,
    required this.rawT,
    required this.expandedWidth,
    required this.expandedHeight,
    required this.actions,
    required this.onClose,
    required this.isPrimary,
    this.backgroundColor,
  });

  static const double _pillWidth = 148.0;
  static const double _pillHeight = 52.0;

  double _lerp(double a, double b, double tValue) => a + (b - a) * tValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor = _getFabBackgroundColor(context, isPrimary, backgroundColor);
    final width = _lerp(_pillWidth, expandedWidth, t);
    final height = _lerp(_pillHeight, expandedHeight, t);
    final radius = _lerp(28.0, 24.0, t);

    // Subtle downward bump at the peak of the spring (weight feel)
    final shiftDown = sin(t * pi) * 10.0;

    // Content appears after the panel is mostly open
    final contentT = ((t - 0.45) / 0.4).clamp(0.0, 1.0);

    return Transform.translate(
      offset: Offset(0, shiftDown),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bgColor.withValues(alpha: 0.85 * t),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color:
                (isPrimary
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface)
                    .withValues(alpha: 0.15 * t),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25 * t),
              blurRadius: 40 * t,
              spreadRadius: 2 * t,
              offset: Offset(0, 15 * t),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12 * t, sigmaY: 12 * t),
            child: Stack(
              children: [
                // Actions list
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 80,
                  child: Opacity(
                    opacity: contentT,
                    child: _ActionsList(
                      actions: actions,
                      t: t,
                      onClose: onClose,
                    ),
                  ),
                ),
                // Cancel button pinned at bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: contentT,
                    child: _CancelRow(onClose: onClose),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ACTIONS LIST
// ---------------------------------------------------------------------------

class _ActionsList extends StatelessWidget {
  final List<FabAction> actions;
  final double t;
  final VoidCallback onClose;

  const _ActionsList({
    required this.actions,
    required this.t,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            _ActionRow(action: actions[i], index: i, t: t, onClose: onClose),
            if (i < actions.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SINGLE ACTION ROW
// ---------------------------------------------------------------------------

class _ActionRow extends StatelessWidget {
  final FabAction action;
  final int index;
  final double t;
  final VoidCallback onClose;

  const _ActionRow({
    required this.action,
    required this.index,
    required this.t,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Stagger: each item starts fading in 60ms later than the previous
    final itemStart = 0.45 + (index * 0.06);
    final itemEnd = itemStart + 0.38;
    final itemT = ((t - itemStart) / (itemEnd - itemStart)).clamp(0.0, 1.0);
    final slideOffset = (1.0 - itemT) * 14.0;
    final accentColor = action.color ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: () {
        onClose();
        // Fire the action after a short delay so the user sees the collapse
        Future.delayed(const Duration(milliseconds: 150), action.onTap);
      },
      child: Opacity(
        opacity: itemT,
        child: Transform.translate(
          offset: Offset(0, slideOffset),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.2),
                        accentColor.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: FaIcon(action.icon, size: 18, color: accentColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    action.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.95,
                      ),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CANCEL ROW
// ---------------------------------------------------------------------------

class _CancelRow extends StatelessWidget {
  final VoidCallback onClose;
  const _CancelRow({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onClose,
      child: Container(
        height: 60,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.xmark,
              size: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 10),
            Text(
              "Dismiss",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// COLLAPSED PILL
// ---------------------------------------------------------------------------

class _CollapsedPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const _CollapsedPill({
    required this.label,
    required this.icon,
    this.isPrimary = true,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bgColor = _getFabBackgroundColor(context, isPrimary, backgroundColor);
    final borderColor = isPrimary
        ? cs.primary.withValues(alpha: 0.4)
        : cs.onSurface.withValues(alpha: 0.15);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  icon,
                  size: 15,
                  color: isPrimary
                      ? cs.onPrimary
                      : cs.onSurface.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPrimary
                        ? cs.onPrimary
                        : cs.onSurface.withValues(alpha: 0.8),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HELPER: SHARED BACKGROUND COLOR LOGIC
// ---------------------------------------------------------------------------

Color _getFabBackgroundColor(
  BuildContext context,
  bool isPrimary,
  Color? overrideColor,
) {
  if (overrideColor != null) return overrideColor;

  final theme = Theme.of(context);
  final cs = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;

  final activeColor = isDark
      ? Color.lerp(cs.primary, Colors.black, 0.35)!
      : Color.lerp(cs.primary, Colors.white, 0.1)!;

  if (isPrimary) {
    return activeColor.withValues(alpha: 0.96);
  }

  return isDark
      ? Color.lerp(
          theme.scaffoldBackgroundColor,
          Colors.white,
          0.08,
        )!.withValues(alpha: 0.95)
      : Color.lerp(
          theme.scaffoldBackgroundColor,
          Colors.black,
          0.03,
        )!.withValues(alpha: 0.95);
}

// ---------------------------------------------------------------------------
// ROTATING GRADIENT OVERLAY (decorative scrim texture)
// ---------------------------------------------------------------------------

class _SweepOverlay extends StatelessWidget {
  const _SweepOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: SweepGradient(
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.07),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.04),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}
