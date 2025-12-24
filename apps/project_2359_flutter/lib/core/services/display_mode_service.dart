import 'package:flutter/foundation.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

/// Service for managing high refresh rate display modes on supported devices.
///
/// This service handles initialization of high refresh rate displays with
/// graceful fallbacks for devices that don't support them.
class DisplayModeService {
  static final DisplayModeService _instance = DisplayModeService._internal();

  bool _initialized = false;
  bool _isHighRefreshRateSupported = false;

  DisplayModeService._internal();

  factory DisplayModeService() {
    return _instance;
  }

  /// Returns whether high refresh rate is supported on this device
  bool get isHighRefreshRateSupported => _isHighRefreshRateSupported;

  /// Returns whether the service has been initialized
  bool get isInitialized => _initialized;

  /// Initialize high refresh rate support
  ///
  /// This method attempts to enable the highest available refresh rate
  /// on the device. If the device doesn't support high refresh rates,
  /// it will gracefully fall back to the default refresh rate.
  ///
  /// Returns true if initialization was successful, false otherwise.
  Future<bool> initialize() async {
    if (_initialized) {
      return _isHighRefreshRateSupported;
    }

    try {
      // Get all supported display modes
      final modes = await FlutterDisplayMode.supported;

      if (modes.isEmpty) {
        _initialized = true;
        _isHighRefreshRateSupported = false;
        return false;
      }

      // Find the mode with the highest refresh rate (skip auto mode which is #0)
      DisplayMode highestRefreshRateMode = modes.first;
      for (final mode in modes) {
        if (mode.refreshRate > highestRefreshRateMode.refreshRate) {
          highestRefreshRateMode = mode;
        }
      }

      // Only set if we found a mode with higher refresh rate than auto
      if (highestRefreshRateMode.refreshRate > 0) {
        await FlutterDisplayMode.setPreferredMode(highestRefreshRateMode);
        _isHighRefreshRateSupported = true;
      } else {
        _isHighRefreshRateSupported = false;
      }

      _initialized = true;
      return _isHighRefreshRateSupported;
    } catch (e) {
      // Device doesn't support display mode API (common on older devices)
      // Gracefully handle and continue without high refresh rate
      if (kDebugMode) {
        print('DisplayModeService: Failed to initialize high refresh rate: $e');
      }
      _isHighRefreshRateSupported = false;
      _initialized = true;
      return false;
    }
  }

  /// Reset display mode to device default (auto)
  ///
  /// Call this if you need to restore the default display mode.
  Future<void> resetToDefault() async {
    try {
      final modes = await FlutterDisplayMode.supported;
      if (modes.isNotEmpty) {
        // Set to auto mode (first mode is usually auto with 0Hz)
        await FlutterDisplayMode.setPreferredMode(modes.first);
      }
    } catch (e) {
      // Silently fail if reset is not supported
      if (kDebugMode) {
        print('DisplayModeService: Failed to reset to default: $e');
      }
    }
  }
}
