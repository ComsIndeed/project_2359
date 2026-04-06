import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar.dart';
import 'package:project_2359/core/services/draft_service.dart';
import 'package:project_2359/app_database.dart';
import 'package:drift/drift.dart';

class CardCreationToolbarController extends ChangeNotifier {
  final DraftService? _draftService;

  CardCreationToolbarMode _mode = CardCreationToolbarMode.collapsed;
  final StreamController<String?> _selectedTextController =
      StreamController<String?>.broadcast();

  // Drafting Identity
  String? _draftId;
  String? _targetDeckId;
  String? _folderId;

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

  CardCreationToolbarController({DraftService? draftService})
    : _draftService = draftService;

  String? get draftId => _draftId;
  String? get targetDeckId => _targetDeckId;
  String? get folderId => _folderId;

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

  /// Initializes the drafting identities for this session.
  void setDraftDetails({
    required String draftId,
    required String targetDeckId,
    required String folderId,
  }) {
    _draftId = draftId;
    _targetDeckId = targetDeckId;
    _folderId = folderId;
    notifyListeners();
  }

  /// Synchronizes the current card list with the database draft.
  Future<void> syncDraft(List<CardItemsCompanion> cards) async {
    if (_draftService == null ||
        _draftId == null ||
        _targetDeckId == null ||
        _folderId == null) {
      return;
    }

    await _draftService.syncDraft(
      draftId: _draftId!,
      targetDeckId: _targetDeckId!,
      folderId: _folderId!,
      cards: cards,
    );
  }

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
