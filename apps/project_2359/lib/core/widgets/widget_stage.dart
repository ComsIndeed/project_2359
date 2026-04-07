import 'dart:async';
import 'package:flutter/material.dart';

// ============================================================================
// WidgetStageController
// ============================================================================

/// A [ChangeNotifier] that manages the activation state of named widget slots.
///
/// Each slot ID can be either "active" or "inactive". When a
/// [WidgetStageSlot] references a given ID, it renders [alternate] when active
/// and [child] when inactive.
///
/// Supports:
/// - [activate] / [deactivate] — set explicit state
/// - [toggle] — flip the state
/// - [flash] — temporarily activate (or deactivate) for a [Duration], then
///   revert automatically
class WidgetStageController extends ChangeNotifier {
  final Set<String> _active;
  final Map<String, Timer> _flashTimers = {};

  /// Creates a controller. [initiallyActive] defines which IDs start in the
  /// active state (showing their [alternate] widget).
  WidgetStageController({Set<String>? initiallyActive})
    : _active = {...?initiallyActive};

  /// Whether the given [id] is in the active state.
  bool isActive(String id) => _active.contains(id);

  /// Sets [id] to active. The corresponding [WidgetStageSlot] will crossfade
  /// to its [alternate] widget.
  void activate(String id) {
    if (_active.add(id)) notifyListeners();
  }

  /// Sets [id] to inactive. The corresponding [WidgetStageSlot] will crossfade
  /// back to its [child] widget.
  void deactivate(String id) {
    if (_active.remove(id)) notifyListeners();
  }

  /// Toggles the state of [id].
  void toggle(String id) {
    if (_active.contains(id)) {
      _active.remove(id);
    } else {
      _active.add(id);
    }
    notifyListeners();
  }

  /// Temporarily activates [id] for [duration], then deactivates it.
  ///
  /// If [reverse] is true, it deactivates first, then re-activates after
  /// [duration].
  ///
  /// Any previous flash on the same [id] is cancelled before starting a new
  /// one.
  ///
  /// [onComplete] is called after the flash reverts.
  void flash(
    String id, {
    Duration duration = const Duration(seconds: 2),
    bool reverse = false,
    VoidCallback? onComplete,
  }) {
    // Cancel any existing flash for this ID.
    _flashTimers[id]?.cancel();

    if (reverse) {
      deactivate(id);
    } else {
      activate(id);
    }

    _flashTimers[id] = Timer(duration, () {
      if (reverse) {
        activate(id);
      } else {
        deactivate(id);
      }
      _flashTimers.remove(id);
      onComplete?.call();
    });
  }

  @override
  void dispose() {
    for (final timer in _flashTimers.values) {
      timer.cancel();
    }
    _flashTimers.clear();
    super.dispose();
  }
}

// ============================================================================
// WidgetStage
// ============================================================================

/// A builder widget that provides a [WidgetStageController] to its subtree.
///
/// If [controller] is not provided, an internal one is created and disposed
/// automatically. The controller is exposed through [builder] so that child
/// widgets (buttons, callbacks, etc.) can call [activate], [flash], etc.
///
/// ```dart
/// WidgetStage(
///   builder: (context, controller) {
///     return WidgetStageSlot(
///       controller: controller,
///       id: 'saved',
///       child: Text("Save"),
///       alternate: Text("Saved!"),
///     );
///   },
/// );
/// ```
class WidgetStage extends StatefulWidget {
  /// An optional external controller. If null, one is created internally.
  final WidgetStageController? controller;

  /// IDs that should start in the active state. Only used when the controller
  /// is created internally.
  final Set<String>? initiallyActive;

  /// Builder that receives the controller.
  final Widget Function(BuildContext context, WidgetStageController controller)
  builder;

  const WidgetStage({
    super.key,
    this.controller,
    this.initiallyActive,
    required this.builder,
  });

  @override
  State<WidgetStage> createState() => _WidgetStageState();
}

class _WidgetStageState extends State<WidgetStage> {
  late final WidgetStageController _internalController;
  bool _ownsController = false;

  WidgetStageController get _controller =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = WidgetStageController(
        initiallyActive: widget.initiallyActive,
      );
      _ownsController = true;
    } else {
      // Still need to initialize field so Dart doesn't complain.
      _internalController = WidgetStageController();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _internalController.dispose();
    } else {
      // We created a dummy — dispose it too.
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => widget.builder(context, _controller),
    );
  }
}

// ============================================================================
// WidgetStageSlot
// ============================================================================

/// A widget slot that crossfades between [child] (default) and [alternate]
/// based on the activation state of [id] in the [controller].
///
/// When the controller's [id] is inactive → shows [child].
/// When the controller's [id] is active → shows [alternate].
///
/// If [alternate] is null, the slot simply renders nothing (a zero-size gap)
/// when activated — useful for temporarily hiding a widget.
///
/// Uses [AnimatedSwitcher] for crossfade and [AnimatedSize] to prevent layout
/// jumps.
class WidgetStageSlot extends StatefulWidget {
  final WidgetStageController controller;
  final String id;

  /// The default widget shown when the slot is inactive.
  final Widget child;

  /// The widget shown when the slot is active. If null, the slot shows nothing
  /// (a zero-size gap) when activated.
  final Widget? alternate;

  /// If true, the slot registers its [id] as active on the controller during
  /// initialization, so it starts showing [alternate].
  final bool initiallyActive;

  /// Duration for the crossfade transition.
  final Duration transitionDuration;

  /// Duration for the size animation that prevents layout jumps.
  final Duration sizeDuration;

  /// The curve for the crossfade.
  final Curve switchCurve;

  /// Alignment for the animated size transition.
  final Alignment sizeAlignment;

  /// Clip behavior for the animated size container.
  final Clip clipBehavior;

  const WidgetStageSlot({
    super.key,
    required this.controller,
    required this.id,
    required this.child,
    this.alternate,
    this.initiallyActive = false,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.sizeDuration = const Duration(milliseconds: 200),
    this.switchCurve = Curves.easeInOut,
    this.sizeAlignment = Alignment.topCenter,
    this.clipBehavior = Clip.none,
  });

  @override
  State<WidgetStageSlot> createState() => _WidgetStageSlotState();
}

class _WidgetStageSlotState extends State<WidgetStageSlot> {
  @override
  void initState() {
    super.initState();
    if (widget.initiallyActive) {
      // Schedule so we don't notify during the build phase.
      Future.microtask(() => widget.controller.activate(widget.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final isActive = widget.controller.isActive(widget.id);
        final Widget current = isActive
            ? (widget.alternate ?? const SizedBox.shrink())
            : widget.child;

        return AnimatedSize(
          duration: widget.sizeDuration,
          curve: widget.switchCurve,
          alignment: widget.sizeAlignment,
          clipBehavior: widget.clipBehavior,
          child: AnimatedSwitcher(
            duration: widget.transitionDuration,
            switchInCurve: widget.switchCurve,
            switchOutCurve: widget.switchCurve,
            child: KeyedSubtree(key: ValueKey<bool>(isActive), child: current),
          ),
        );
      },
    );
  }
}
