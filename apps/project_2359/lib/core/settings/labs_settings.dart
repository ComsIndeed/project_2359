import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final labsSettings = LabsSettings();

class LabsSettings extends ChangeNotifier {
  static const _smartSelectionKey = 'smart_selection_enabled';
  static const _macEmulationKey = 'mac_emulation_enabled';
  static const _mobileEmulationKey = 'mobile_emulation_enabled';

  bool _smartSelectionEnabled = true;
  bool _macEmulationEnabled = false;
  bool _mobileEmulationEnabled = kDebugMode;

  bool get smartSelectionEnabled => _smartSelectionEnabled;
  bool get macEmulationEnabled => _macEmulationEnabled;
  bool get mobileEmulationEnabled => _mobileEmulationEnabled;

  bool isMobileMode(BuildContext context) {
    if (_mobileEmulationEnabled) return true;
    return MediaQuery.of(context).size.width < 600;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _smartSelectionEnabled = prefs.getBool(_smartSelectionKey) ?? true;
    _macEmulationEnabled = prefs.getBool(_macEmulationKey) ?? false;
    _mobileEmulationEnabled = prefs.getBool(_mobileEmulationKey) ?? kDebugMode;
    notifyListeners();
  }

  Future<void> setSmartSelectionEnabled(bool value) async {
    _smartSelectionEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_smartSelectionKey, value);
  }

  Future<void> setMacEmulationEnabled(bool value) async {
    _macEmulationEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_macEmulationKey, value);
  }

  Future<void> setMobileEmulationEnabled(bool value) async {
    _mobileEmulationEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mobileEmulationKey, value);
  }
}
