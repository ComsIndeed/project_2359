import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

final windowStateManager = WindowStateManager();

class WindowStateManager with WindowListener {
  static const String _widthKey = 'window_width';
  static const String _heightKey = 'window_height';
  static const String _xKey = 'window_x';
  static const String _yKey = 'window_y';
  static const String _isMaximizedKey = 'window_is_maximized';

  Future<void> init() async {
    windowManager.addListener(this);
  }

  Future<void> saveWindowState() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (await windowManager.isMaximized()) {
      await prefs.setBool(_isMaximizedKey, true);
      return;
    } else {
      await prefs.setBool(_isMaximizedKey, false);
    }

    final size = await windowManager.getSize();
    final pos = await windowManager.getPosition();

    await prefs.setDouble(_widthKey, size.width);
    await prefs.setDouble(_heightKey, size.height);
    await prefs.setDouble(_xKey, pos.dx);
    await prefs.setDouble(_yKey, pos.dy);
  }

  Future<WindowOptions> loadWindowOptions() async {
    final prefs = await SharedPreferences.getInstance();
    
    final width = prefs.getDouble(_widthKey) ?? 1200.0;
    final height = prefs.getDouble(_heightKey) ?? 800.0;
    final x = prefs.getDouble(_xKey);
    final y = prefs.getDouble(_yKey);

    return WindowOptions(
      size: Size(width, height),
      center: x == null || y == null,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
  }

  Future<void> applyAfterShow() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getDouble(_xKey);
    final y = prefs.getDouble(_yKey);
    final isMaximized = prefs.getBool(_isMaximizedKey) ?? false;

    if (x != null && y != null) {
      await windowManager.setPosition(Offset(x, y));
    }
    
    if (isMaximized) {
      await windowManager.maximize();
    }
  }

  @override
  void onWindowResized() {
    saveWindowState();
  }

  @override
  void onWindowMoved() {
    saveWindowState();
  }

  @override
  void onWindowMaximize() {
    saveWindowState();
  }

  @override
  void onWindowUnmaximize() {
    saveWindowState();
  }
}
