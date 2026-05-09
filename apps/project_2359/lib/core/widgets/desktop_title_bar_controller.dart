import 'package:flutter/material.dart';

class DesktopTitleBarController extends ChangeNotifier {
  String? _centeredTitle;
  VoidCallback? _onBack;
  bool _hideBack = false;

  String? get centeredTitle => _centeredTitle;
  VoidCallback? get onBack => _onBack;
  bool get hideBack => _hideBack;

  void setCenteredTitle(String? title) {
    if (_centeredTitle == title) return;
    _centeredTitle = title;
    notifyListeners();
  }

  void setOnBack(VoidCallback? onBack) {
    if (_onBack == onBack) return;
    _onBack = onBack;
    notifyListeners();
  }

  void setHideBack(bool hide) {
    if (_hideBack == hide) return;
    _hideBack = hide;
    notifyListeners();
  }

  void reset() {
    _centeredTitle = null;
    _onBack = null;
    _hideBack = false;
    notifyListeners();
  }
}
