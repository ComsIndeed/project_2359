import 'package:flutter/material.dart';
import 'package:project_2359/features/card_creation_page/expandable_card_creation_toolbar.dart';

class CardCreationToolbarController extends ChangeNotifier {
  CardCreationToolbarMode _mode = CardCreationToolbarMode.collapsed;

  CardCreationToolbarMode get mode => _mode;

  void setMode(CardCreationToolbarMode mode) {
    _mode = mode;
    notifyListeners();
  }
}
