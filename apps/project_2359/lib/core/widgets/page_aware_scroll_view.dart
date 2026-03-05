import 'package:flutter/material.dart';

/// A wrapper widget that allows a scrollable child to coexist with a parent
/// [PageView]. When the child scrollable reaches its scroll extent and the
/// user continues to drag, the overscroll is forwarded to the [PageController]
/// to trigger a page transition.
///
/// This solves the problem where an inner [ListView] or [SingleChildScrollView]
/// consumes all vertical gestures, preventing the user from swiping to the
/// next page in a vertical [PageView].
class PageAwareScrollView extends StatefulWidget {
  /// The [PageController] of the parent [PageView].
  final PageController pageController;

  /// The scrollable content. Should use [ClampingScrollPhysics] or
  /// [NeverScrollableScrollPhysics] — bouncing physics will interfere.
  final Widget child;

  /// How far (in logical pixels) the user must overscroll before
  /// a page transition is triggered.
  final double overscrollThreshold;

  const PageAwareScrollView({
    super.key,
    required this.pageController,
    required this.child,
    this.overscrollThreshold = 80.0,
  });

  @override
  State<PageAwareScrollView> createState() => _PageAwareScrollViewState();
}

class _PageAwareScrollViewState extends State<PageAwareScrollView> {
  double _accumulatedOverscroll = 0.0;
  bool _isPageAnimating = false;

  void _handleOverscrollNotification(OverscrollNotification notification) {
    if (_isPageAnimating) return;

    final overscroll = notification.overscroll;
    _accumulatedOverscroll += overscroll;

    final currentPage = widget.pageController.page ?? 0;

    // Dragging down past the top → go to previous page
    if (_accumulatedOverscroll < -widget.overscrollThreshold &&
        currentPage > 0) {
      _triggerPageChange(currentPage.round() - 1);
    }
    // Dragging up past the bottom → go to next page
    else if (_accumulatedOverscroll > widget.overscrollThreshold) {
      // We don't know total pages, but animateToPage will clamp
      _triggerPageChange(currentPage.round() + 1);
    }
  }

  void _triggerPageChange(int targetPage) {
    _isPageAnimating = true;
    _accumulatedOverscroll = 0.0;

    widget.pageController
        .animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
        )
        .then((_) {
          _isPageAnimating = false;
        });
  }

  void _handleScrollEndNotification() {
    // Reset accumulated overscroll when the user lifts their finger
    _accumulatedOverscroll = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          _handleOverscrollNotification(notification);
          return true;
        }
        if (notification is ScrollEndNotification) {
          _handleScrollEndNotification();
          return true;
        }
        return false;
      },
      child: widget.child,
    );
  }
}
