import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_2359/features/card_creation_page/expandable_card_creation_toolbar.dart';

class CardCreationToolbarController extends ChangeNotifier {
  CardCreationToolbarMode _mode = CardCreationToolbarMode.collapsed;
  final StreamController<String?> _selectedTextController =
      StreamController<String?>.broadcast();

  String? _selectedText;
  String _frontText = '';
  String _backText = '';

  CardCreationToolbarMode get mode => _mode;
  String? get selectedText => _selectedText;
  Stream<String?> get selectedTextStream => _selectedTextController.stream;

  String get frontText => _frontText;
  String get backText => _backText;

  void setMode(CardCreationToolbarMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void updateSelectedText(String? text) {
    _selectedText = text;
    _selectedTextController.add(text);
    notifyListeners();
  }

  void setFrontText(String text) {
    _frontText = text;
    notifyListeners();
  }

  void setBackText(String text) {
    _backText = text;
    notifyListeners();
  }

  void resetCardFields() {
    _frontText = '';
    _backText = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _selectedTextController.close();
    super.dispose();
  }
}
