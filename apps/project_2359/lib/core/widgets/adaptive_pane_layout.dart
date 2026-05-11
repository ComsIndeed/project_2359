import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

typedef PaneBuilder = Widget Function(
  BuildContext context,
  AdaptivePaneController controller,
);

enum AdaptivePaneTransitionType {
  /// The layout of the content snaps to its target size immediately,
  /// and the container clips it during the animation.
  snap,

  /// Allows the content to animate its layout along with the container.
  animate,

  /// Immediately changes the layout but fades between the old and new states.
  /// For the detail panel, this fades between the content at its current size
  /// and its target size.
  fade,
}

class AdaptivePaneTransition {
  final AdaptivePaneTransitionType master;
  final AdaptivePaneTransitionType detail;

  const AdaptivePaneTransition({required this.master, required this.detail});

  const AdaptivePaneTransition.all(AdaptivePaneTransitionType type)
    : master = type,
      detail = type;

  const AdaptivePaneTransition.only({
    this.master = AdaptivePaneTransitionType.fade,
    this.detail = AdaptivePaneTransitionType.fade,
  });

  static const fade = AdaptivePaneTransition.all(AdaptivePaneTransitionType.fade);
  static const snap = AdaptivePaneTransition.all(AdaptivePaneTransitionType.snap);
  static const animate = AdaptivePaneTransition.all(
    AdaptivePaneTransitionType.animate,
  );
}

class AdaptivePaneController extends ChangeNotifier {
  bool _isCollapsed;

  AdaptivePaneController({bool initialCollapsed = false})
    : _isCollapsed = initialCollapsed;

  bool get isCollapsed => _isCollapsed;

  void toggleCollapsed() {
    _isCollapsed = !_isCollapsed;
    notifyListeners();
  }

  void setCollapsed(bool value) {
    if (_isCollapsed == value) return;
    _isCollapsed = value;
    notifyListeners();
  }
}
class AdaptivePaneLayout extends StatefulWidget {
  final PaneBuilder master;
  final PaneBuilder? masterCollapsed;
  final PaneBuilder? detail;
  final double masterWidth;
  final double collapsedMasterWidth;
  final PaneBuilder? emptyDetail;
  final EdgeInsets? padding;
  final bool isNested;
  final bool wrapDetail;
  final AdaptivePaneController? controller;
  final AdaptivePaneTransition transition;

  const AdaptivePaneLayout({
    super.key,
    required this.master,
    this.masterCollapsed,
    this.detail,
    this.masterWidth = 350,
    this.collapsedMasterWidth = 80,
    this.emptyDetail,
    this.padding,
    this.isNested = false,
    this.wrapDetail = true,
    this.controller,
    this.transition = AdaptivePaneTransition.fade,
  });

  @override
  State<AdaptivePaneLayout> createState() => _AdaptivePaneLayoutState();
}

class _AdaptivePaneLayoutState extends State<AdaptivePaneLayout> {
  late AdaptivePaneController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? AdaptivePaneController();
    _controller.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(AdaptivePaneLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      _controller = widget.controller ?? AdaptivePaneController();
      _controller.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!isWide) {
      return Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: widget.master(context, _controller),
      );
    }

    final outerPadding =
        widget.isNested
            ? EdgeInsets.zero
            : (widget.padding ?? const EdgeInsets.all(12));
    const panelSpacing = 12.0;

    final panelDecoration = ShapeDecoration(
      color: theme.colorScheme.surface,
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
          width: 1.2,
        ),
      ),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );

    final currentMasterWidth =
        _controller.isCollapsed ? widget.collapsedMasterWidth : widget.masterWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final targetDetailWidth =
            totalWidth -
            (_controller.isCollapsed
                ? widget.collapsedMasterWidth
                : widget.masterWidth) -
            panelSpacing;

        return Padding(
          padding: outerPadding,
          child: Row(
            children: [
              // Master Panel
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuart,
                width: currentMasterWidth,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: panelDecoration,
                  child: _buildMasterContent(context),
                ),
              ),

              const SizedBox(width: panelSpacing),

              // Detail Panel
              Expanded(
                child: _buildDetailContent(
                  context,
                  panelDecoration,
                  targetDetailWidth,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMasterContent(BuildContext context) {
    final isCollapsed = _controller.isCollapsed;

    switch (widget.transition.master) {
      case AdaptivePaneTransitionType.animate:
        return _buildAnimatedContent(context, isCollapsed);
      case AdaptivePaneTransitionType.snap:
        return _buildSnapContent(context, isCollapsed);
      case AdaptivePaneTransitionType.fade:
        return _buildFadeContent(context, isCollapsed);
    }
  }

  Widget _buildFadeContent(BuildContext context, bool isCollapsed) {
    return Stack(
      children: [
        // Expanded Content
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isCollapsed ? 0.0 : 1.0,
            child: IgnorePointer(
              ignoring: isCollapsed,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                minWidth: widget.masterWidth,
                maxWidth: widget.masterWidth,
                child: widget.master(context, _controller),
              ),
            ),
          ),
        ),

        // Collapsed Content
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isCollapsed ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !isCollapsed,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                minWidth: widget.collapsedMasterWidth,
                maxWidth: widget.collapsedMasterWidth,
                child:
                    widget.masterCollapsed?.call(context, _controller) ??
                    _DefaultCollapsedMaster(controller: _controller),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSnapContent(BuildContext context, bool isCollapsed) {
    return OverflowBox(
      alignment: Alignment.topLeft,
      minWidth: isCollapsed ? widget.collapsedMasterWidth : widget.masterWidth,
      maxWidth: isCollapsed ? widget.collapsedMasterWidth : widget.masterWidth,
      child:
          isCollapsed
              ? (widget.masterCollapsed?.call(context, _controller) ??
                  _DefaultCollapsedMaster(controller: _controller))
              : widget.master(context, _controller),
    );
  }

  Widget _buildAnimatedContent(BuildContext context, bool isCollapsed) {
    // For animated content, we don't use OverflowBox so that the child
    // can respond to the constraints of the parent AnimatedContainer.
    return isCollapsed
        ? (widget.masterCollapsed?.call(context, _controller) ??
            _DefaultCollapsedMaster(controller: _controller))
        : widget.master(context, _controller);
  }

  Widget _buildDetailContent(
    BuildContext context,
    Decoration decoration,
    double targetWidth,
  ) {
    final detail = widget.detail?.call(context, _controller);
    final emptyDetail = widget.emptyDetail?.call(context, _controller);
    final child =
        detail ?? emptyDetail ?? const SizedBox.shrink(key: ValueKey('none'));

    final animatedChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutQuart,
      switchOutCurve: Curves.easeInQuart,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.01, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: child,
    );

    Widget wrappedChild;
    switch (widget.transition.detail) {
      case AdaptivePaneTransitionType.animate:
        wrappedChild = animatedChild;
        break;
      case AdaptivePaneTransitionType.snap:
        wrappedChild = OverflowBox(
          alignment: Alignment.topLeft,
          minWidth: targetWidth,
          maxWidth: targetWidth,
          child: animatedChild,
        );
        break;
      case AdaptivePaneTransitionType.fade:
        // For detail fade, we cross-fade between target sizes.
        // Since detail usually has one widget, we use a simple AnimatedOpacity
        // over an OverflowBox with the target size.
        wrappedChild = AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: OverflowBox(
            key: ValueKey(targetWidth), // Trigger fade when target width changes
            alignment: Alignment.topLeft,
            minWidth: targetWidth,
            maxWidth: targetWidth,
            child: animatedChild,
          ),
        );
        break;
    }

    if (detail != null && !widget.wrapDetail) {
      return SizedBox.expand(child: wrappedChild);
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: decoration,
      child: wrappedChild,
    );
  }
}

class _DefaultCollapsedMaster extends StatelessWidget {
  final AdaptivePaneController controller;

  const _DefaultCollapsedMaster({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
            onPressed: controller.toggleCollapsed,
            icon: const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
          ),
        ),
      ],
    );
  }
}
