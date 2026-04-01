import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final labsSettings = LabsSettings();

class LabsSettings extends ChangeNotifier {
  static const _smartSelectionKey = 'smart_selection_enabled';

  bool _smartSelectionEnabled = true;

  bool get smartSelectionEnabled => _smartSelectionEnabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _smartSelectionEnabled = prefs.getBool(_smartSelectionKey) ?? true;
    notifyListeners();
  }

  Future<void> setSmartSelectionEnabled(bool value) async {
    _smartSelectionEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_smartSelectionKey, value);
  }
}
