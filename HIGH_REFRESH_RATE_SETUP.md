# High Refresh Rate Support Documentation

## Overview

This project now includes support for high refresh rate displays on compatible devices. The implementation uses the `flutter_displaymode` package to enable the highest available refresh rate on devices that support it, while gracefully falling back to default behavior on devices that don't support this feature.

## Features

✅ **Automatic High Refresh Rate Detection**: The app automatically detects and sets the highest available refresh rate when it starts.

✅ **Graceful Fallback**: On devices that don't support the display mode API (older Android devices, iOS, web), the app continues to work normally without any crashes.

✅ **Safe Error Handling**: All platform-specific calls are wrapped in try-catch blocks to prevent crashes on unsupported devices.

✅ **Singleton Pattern**: The `DisplayModeService` uses a singleton pattern to ensure display mode is initialized only once.

## Implementation Details

### Files Added/Modified

#### 1. **lib/core/services/display_mode_service.dart** (NEW)
A service class that manages high refresh rate initialization:

- `initialize()`: Attempts to set the highest available refresh rate mode
  - Returns `true` if high refresh rate was successfully enabled
  - Returns `false` if the device doesn't support it or if an error occurred
  - Catches all exceptions to prevent crashes on unsupported devices

- `isHighRefreshRateSupported`: A getter that indicates whether high refresh rate is active

- `resetToDefault()`: Resets the display mode back to auto (device default)

#### 2. **lib/main.dart** (MODIFIED)
Updated to initialize the display mode service:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize high refresh rate support
  await DisplayModeService().initialize();
  
  runApp(const MainApp());
}
```

#### 3. **pubspec.yaml** (MODIFIED)
Added the `flutter_displaymode` package dependency:

```yaml
dependencies:
  flutter_displaymode: ^0.7.0
```

## How It Works

1. **App Startup**: When the app starts, `main()` initializes the `DisplayModeService` before running the app.

2. **Mode Detection**: The service calls `FlutterDisplayMode.supported` to get all available display modes.

3. **Mode Selection**: It finds the mode with the highest refresh rate.

4. **Mode Setting**: It sets the selected mode as the preferred display mode.

5. **Error Handling**: If any error occurs (unsupported device, no API available, etc.), it catches the exception and logs it in debug mode without crashing.

## Device Compatibility

### Supported Devices
- ✅ Android 6.0+ (API 23+) with display mode API support
- ✅ Devices with discrete refresh rates (60Hz, 90Hz, 120Hz, 144Hz, etc.)

### Partially Supported / Not Effective
- ⚠️ iOS ProMotion devices: Package available but ineffective (iOS handles refresh rate automatically)
- ⚠️ Android devices with LTPO panels: Package available but ineffective (LTPO automatically manages refresh rates)
- ❌ Web: Platform not supported (but won't crash)
- ❌ Older Android devices (pre-Marshmallow): Graceful fallback

## Usage Example

### Access Display Mode Information
```dart
final service = DisplayModeService();
final isSupported = service.isHighRefreshRateSupported;
final isInitialized = service.isInitialized;

print('High Refresh Rate Supported: $isSupported');
```

### Reset to Default (Optional)
If needed, you can reset the display mode back to automatic:

```dart
await DisplayModeService().resetToDefault();
```

## Error Handling

The implementation handles errors in multiple ways:

1. **Try-Catch Blocks**: All platform calls are wrapped in try-catch
2. **Graceful Fallback**: If initialization fails, the app continues normally
3. **Debug Logging**: Errors are printed in debug mode for troubleshooting
4. **No Crashes**: Exceptions are caught and logged, never propagated

## Testing on Different Devices

### Android (High-end device with 90Hz+ support)
- App will automatically set to highest available refresh rate
- May see improved animation smoothness

### Android (Budget device with 60Hz only)
- App will work normally with 60Hz refresh rate
- No errors or crashes

### iOS
- App will work normally
- iOS handles refresh rate automatically for ProMotion devices

### Older Devices / Non-Supported
- App works normally
- Display mode setting silently falls back to device default

## Performance Considerations

- **Minimal Overhead**: Initialization happens once at app startup
- **Async Operation**: Uses `async/await` to prevent blocking
- **No Runtime Impact**: After initialization, there's no continuous monitoring or resource usage

## Troubleshooting

### App crashes when initializing display mode
This shouldn't happen as all errors are caught. If it does:
1. Check that the package is properly imported
2. Ensure `WidgetsFlutterBinding.ensureInitialized()` is called before initializing the service
3. Check debug logs for error messages

### High refresh rate not applied
This is normal on:
- iOS devices (handled by OS)
- Android devices with LTPO displays (managed by hardware)
- Budget devices that don't support variable refresh rates

### See which modes are available
You can modify the service to log available modes:

```dart
final modes = await FlutterDisplayMode.supported;
modes.forEach(print); // Prints all available modes
```

## Future Enhancements

Possible improvements:
- Add UI toggle to switch between power-saving and high refresh rate modes
- Store user preference in shared preferences
- Dynamically adjust refresh rate based on battery level
- Add analytics to track which devices support high refresh rate

## References

- [flutter_displaymode Package](https://pub.dev/packages/flutter_displaymode)
- [GitHub Repository](https://github.com/ajinasokan/flutter_displaymode)
- [Flutter Issue #35162](https://github.com/flutter/flutter/issues/35162)
