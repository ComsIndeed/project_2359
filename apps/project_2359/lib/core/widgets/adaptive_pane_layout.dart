import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

typedef PaneBuilder = Widget Function(
  BuildContext context,
  AdaptivePaneController controller,
);

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
            child: _buildDetailContent(context, panelDecoration),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterContent(BuildContext context) {
    return Stack(
      children: [
        // Expanded Content
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _controller.isCollapsed ? 0.0 : 1.0,
            child: IgnorePointer(
              ignoring: _controller.isCollapsed,
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
            opacity: _controller.isCollapsed ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !_controller.isCollapsed,
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

  Widget _buildDetailContent(BuildContext context, Decoration decoration) {
    final detail = widget.detail?.call(context, _controller);
    final emptyDetail = widget.emptyDetail?.call(context, _controller);
    final child = detail ?? emptyDetail ?? const SizedBox.shrink(key: ValueKey('none'));

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

    if (detail != null && !widget.wrapDetail) {
      return SizedBox.expand(child: animatedChild);
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: decoration,
      child: animatedChild,
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
