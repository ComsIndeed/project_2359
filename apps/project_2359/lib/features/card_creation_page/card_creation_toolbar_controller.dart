import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project_2359/features/card_creation_page/expandable_card_creation_toolbar.dart';

class CardCreationToolbarController extends ChangeNotifier {
  CardCreationToolbarMode _mode = CardCreationToolbarMode.collapsed;
  final StreamController<String?> _selectedTextController =
      StreamController<String?>.broadcast();

  String? _selectedText;
  String _frontText = '';
  String _backText = '';

  // Image Occlusion State
  Rect? _occlusionRect;
  Uint8List? _capturedOcclusionImage;

  // List State
  String _searchQuery = '';
  final Set<String> _selectedItemIds = {};
  String? _requestedSourceId;
  String? _requestedCardId;

  CardCreationToolbarMode get mode => _mode;
  String? get selectedText => _selectedText;
  Stream<String?> get selectedTextStream => _selectedTextController.stream;

  String get frontText => _frontText;
  String get backText => _backText;

  Rect? get occlusionRect => _occlusionRect;
  Uint8List? get capturedOcclusionImage => _capturedOcclusionImage;

  String get searchQuery => _searchQuery;
  Set<String> get selectedItemIds => _selectedItemIds;
  String? get requestedSourceId => _requestedSourceId;
  String? get requestedCardId => _requestedCardId;

  void updateOcclusionRect(Rect? rect) {
    _occlusionRect = rect;
    notifyListeners();
  }

  void setCapturedOcclusionImage(Uint8List? bytes) {
    _capturedOcclusionImage = bytes;
    notifyListeners();
  }

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

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSelection(String id) {
    if (_selectedItemIds.contains(id)) {
      _selectedItemIds.remove(id);
    } else {
      _selectedItemIds.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedItemIds.clear();
    notifyListeners();
  }

  void requestSource(String id) {
    _requestedSourceId = id;
    notifyListeners();
    // Reset after notify so listeners can react and we don't trigger again
    _requestedSourceId = null;
  }

  void requestCard(String id) {
    _requestedCardId = id;
    notifyListeners();
    _requestedCardId = null;
  }

  @override
  void dispose() {
    _selectedTextController.close();
    super.dispose();
  }
}
