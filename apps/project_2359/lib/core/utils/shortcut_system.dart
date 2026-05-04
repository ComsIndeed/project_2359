import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:project_2359/core/settings/labs_settings.dart';
import 'dart:io' show Platform;

enum ShortcutModifier {
  alt,
  shift,
  control,
  meta, // Command on Mac
}

class ShortcutInfo {
  final String label;
  final LogicalKeyboardKey key;
  final List<ShortcutModifier> modifiers;
  final bool isHoverOnly;

  const ShortcutInfo({
    required this.label,
    required this.key,
    this.modifiers = const [],
    this.isHoverOnly = false,
  });

  String get printable {
    final List<String> parts = [];
    final isMac = ProjectShortcutManager.isApple;

    for (final mod in modifiers) {
      switch (mod) {
        case ShortcutModifier.alt:
          parts.add(isMac ? 'Option' : 'Alt');
        case ShortcutModifier.shift:
          parts.add('Shift');
        case ShortcutModifier.control:
          parts.add(isMac ? 'Control' : 'Ctrl');
        case ShortcutModifier.meta:
          parts.add(isMac ? 'Command' : 'Win');
      }
    }

    parts.add(key.keyLabel.toUpperCase());
    return parts.join(' + ');
  }

  bool matches(KeyEvent event, Set<LogicalKeyboardKey> pressedKeys) {
    // Check key
    if (event.logicalKey != key) return false;

    // Check modifiers

    bool altPressed =
        pressedKeys.contains(LogicalKeyboardKey.altLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.altRight);
    bool shiftPressed =
        pressedKeys.contains(LogicalKeyboardKey.shiftLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.shiftRight);
    bool controlPressed =
        pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.controlRight);
    bool metaPressed =
        pressedKeys.contains(LogicalKeyboardKey.metaLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.metaRight);

    for (final mod in ShortcutModifier.values) {
      final expected = modifiers.contains(mod);
      bool actual = false;
      switch (mod) {
        case ShortcutModifier.alt:
          actual = altPressed;
        case ShortcutModifier.shift:
          actual = shiftPressed;
        case ShortcutModifier.control:
          actual = controlPressed;
        case ShortcutModifier.meta:
          actual = metaPressed;
      }
      if (expected != actual) return false;
    }

    return true;
  }
}

class ProjectShortcutManager {
  static bool get isShortcutsEnabled {
    final dispatcher = PlatformDispatcher.instance;
    if (dispatcher.views.isEmpty) return true;
    final view = dispatcher.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    final isPhoneSize = size.width < 600;

    final isActualPhone = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    if (isPhoneSize) {
      // Disable if actual phone or if emulating phone on desktop
      if (isActualPhone) return false;
      if (labsSettings.mobileEmulationEnabled) return false;
    }

    return true;
  }

  static bool get isApple {
    if (labsSettings.macEmulationEnabled) return true;
    if (kIsWeb) {
      return false;
    }
    return Platform.isMacOS || Platform.isIOS;
  }

  static final Map<ShortcutInfo, VoidCallback> _globalShortcuts = {};
  static final List<ShortcutInfo> _registeredShortcuts = [];

  static void registerShortcut(ShortcutInfo info, VoidCallback onTrigger) {
    _globalShortcuts[info] = onTrigger;
    if (!_registeredShortcuts.contains(info)) {
      _registeredShortcuts.add(info);
    }
  }

  static void unregisterShortcut(ShortcutInfo info) {
    _globalShortcuts.remove(info);
    _registeredShortcuts.remove(info);
  }

  static List<ShortcutInfo> get allShortcuts =>
      List.unmodifiable(_registeredShortcuts);

  static bool handleKeyEvent(KeyEvent event) {
    if (!isShortcutsEnabled) return false;
    if (event is! KeyDownEvent) return false;

    final pressedKeys = HardwareKeyboard.instance.logicalKeysPressed;

    for (final entry in _globalShortcuts.entries) {
      if (entry.key.matches(event, pressedKeys)) {
        entry.value();
        return true;
      }
    }

    return false;
  }
}
