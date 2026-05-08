import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar.dart';
import 'package:project_2359/core/services/draft_service.dart';
import 'package:project_2359/app_database.dart';
import 'package:drift/drift.dart';
import 'package:project_2359/core/widgets/widget_stage.dart';
import 'package:project_2359/core/models/project_rect.dart';
import 'package:project_2359/core/models/note_type.dart';
import 'package:uuid/uuid.dart';

class CardCreationToolbarController extends ChangeNotifier {
  final DraftService? _draftService;
  final WidgetStageController stageController = WidgetStageController();

  CardCreationToolbarMode _mode = CardCreationToolbarMode.collapsed;
  final StreamController<String?> _selectedTextController =
      StreamController<String?>.broadcast();

  // Drafting Identity
  String? _draftId;
  String? _targetDeckId;
  String? _collectionId;
  NoteType _selectedNoteType = NoteType.basic;
  final List<NoteItemsCompanion> _notes = [];

  String? _selectedText;
  String? _feedbackText;
  String _frontText = '';
  String _backText = '';
  String _contentText = '';

  // Image Occlusion State
  Rect? _occlusionRect;
  Uint8List? _capturedOcclusionImage;

  // Citation Metadata
  String? _sourceId;
  List<int>? _pageNumbers;
  List<ProjectRect>? _rects;

  // List State
  String _searchQuery = '';
  final Set<String> _selectedItemIds = {};
  String? _requestedSourceId;
  String? _requestedCardId;

  CardCreationToolbarController({DraftService? draftService})
    : _draftService = draftService;

  /// Controller for targeting a specific deck name.
  ///
  /// Kept here so the UI can bind it directly without manual debouncing logic.
  final TextEditingController deckNameController = TextEditingController(
    text: 'New Deck',
  );

  String? get draftId => _draftId;
  String? get targetDeckId => _targetDeckId;
  String? get collectionId => _collectionId;
  NoteType get selectedNoteType => _selectedNoteType;
  List<NoteItemsCompanion> get notes => List.unmodifiable(_notes);

  CardCreationToolbarMode get mode => _mode;
  String? get selectedText => _selectedText;
  String? get feedbackText => _feedbackText;
  Stream<String?> get selectedTextStream => _selectedTextController.stream;

  String get frontText => _frontText;
  String get backText => _backText;
  String get contentText => _contentText;

  Rect? get occlusionRect => _occlusionRect;
  Uint8List? get capturedOcclusionImage => _capturedOcclusionImage;

  String get searchQuery => _searchQuery;
  Set<String> get selectedItemIds => _selectedItemIds;
  String? get requestedSourceId => _requestedSourceId;
  String? get requestedCardId => _requestedCardId;

  String? get sourceId => _sourceId;
  List<int>? get pageNumbers => _pageNumbers;
  List<ProjectRect>? get rects => _rects;

  /// Initializes the drafting identities for this session.
  void setDraftDetails({
    required String draftId,
    required String targetDeckId,
    required String collectionId,
  }) {
    _draftId = draftId;
    _targetDeckId = targetDeckId;
    _collectionId = collectionId;
    notifyListeners();
  }

  /// Sets the initial list of notes for a resumed draft.
  void setInitialNotes(List<NoteItemsCompanion> initialNotes) {
    _notes.clear();
    _notes.addAll(initialNotes);
    notifyListeners();
  }

  void setSelectedNoteType(NoteType type) {
    _selectedNoteType = type;
    notifyListeners();
  }

  /// Adds a new note to the draft and triggers an automatic sync.
  Future<void> addNote(NoteItemsCompanion note) async {
    NoteItemsCompanion noteToInsert = note;

    // Handle Citation if metadata exists
    if (_sourceId != null && (_pageNumbers != null || _rects != null)) {
      final citationId = const Uuid().v4();
      final citation = CitationItemsCompanion.insert(
        id: citationId,
        sourceIds: Value([_sourceId!]),
        pageNumbers: Value(_pageNumbers ?? []),
        rects: Value(_rects ?? []),
        citedText: Value(_selectedText),
      );

      // Insert citation first
      if (_draftService != null) {
        await _draftService.insertCitation(citation);
      }
      noteToInsert = noteToInsert.copyWith(citationId: Value(citationId));
    }

    _notes.add(noteToInsert);
    notifyListeners();
    _feedbackText = "Saved Note!";
    stageController.flash(
      'card_action',
      duration: const Duration(milliseconds: 800),
    );
    await syncDraft(_notes);
  }

  /// Synchronizes the current note list with the database draft.
  Future<void> syncDraft(List<NoteItemsCompanion> notes) async {
    if (_draftService == null ||
        _draftId == null ||
        _targetDeckId == null ||
        _collectionId == null) {
      return;
    }

    await _draftService.syncDraft(
      draftId: _draftId!,
      targetDeckId: _targetDeckId!,
      collectionId: _collectionId!,
      notes: notes,
    );
  }

  /// Promotes the current draft and its cards into a real deck.
  ///
  /// If [asNewDeck] is true, a fresh UUID is generated and passed to the service,
  /// causing the cards to be moved to a new deck record instead of the original target.
  Future<void> saveAsDeck() async {
    if (_draftId == null || _draftService == null) return;

    // We delegate the movement of cards and draft updating to the service's logic.
    await _draftService.saveDraft(
      draftId: _draftId!,
      deckName: deckNameController.text,
      collectionId: _collectionId,
      deckId: _targetDeckId!,
    );

    // 4. Clear the draft identity after a successful commit
    _draftId = null;
    stageController.flash('save_status', duration: const Duration(seconds: 2));
    notifyListeners();
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

  void setContentText(String text) {
    _contentText = text;
    notifyListeners();
  }

  void updateCitationMetadata({
    String? sourceId,
    List<int>? pageNumbers,
    List<ProjectRect>? rects,
  }) {
    _sourceId = sourceId ?? _sourceId;
    _pageNumbers = pageNumbers;
    _rects = rects;
    notifyListeners();
  }

  void resetCardFields() {
    _frontText = '';
    _backText = '';
    _contentText = '';
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
    _feedbackText = "Opening Source...";
    stageController.flash('card_action', duration: const Duration(seconds: 1));
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
    stageController.dispose();
    _selectedTextController.close();
    deckNameController.dispose();
    super.dispose();
  }
}
