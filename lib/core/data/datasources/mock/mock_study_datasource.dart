/// Mock study datasource implementation for Project 2359
///
/// In-memory implementation for all study content types.
library;

import 'dart:async';

import '../interfaces/study_datasource.dart';
import '../../../models/models.dart';
import 'mock_data.dart';

/// Mock implementation of [StudyDatasource] for test mode.
class MockStudyDatasource implements StudyDatasource {
  late List<Flashcard> _flashcards;
  late List<QuizQuestion> _quizQuestions;
  late List<IdentificationQuestion> _identificationQuestions;
  late List<ImageOcclusion> _imageOcclusions;
  late List<MatchingSet> _matchingSets;

  final _flashcardsController = StreamController<List<Flashcard>>.broadcast();
  final _quizController = StreamController<List<QuizQuestion>>.broadcast();

  MockStudyDatasource() {
    // Clone mock data
    _flashcards = List.from(mockFlashcards);
    _quizQuestions = List.from(mockQuizQuestions);
    _identificationQuestions = List.from(mockIdentificationQuestions);
    _imageOcclusions = List.from(mockImageOcclusions);
    _matchingSets = List.from(mockMatchingSets);
  }

  // ==================== Flashcards ====================

  @override
  Future<List<Flashcard>> getFlashcards({String? sourceId}) async {
    if (sourceId == null) return List.unmodifiable(_flashcards);
    return _flashcards.where((f) => f.sourceId == sourceId).toList();
  }

  @override
  Future<List<Flashcard>> getFlashcardsDueForReview() async {
    final now = DateTime.now();
    return _flashcards.where((f) {
      if (f.nextReviewAt == null) return true;
      return f.nextReviewAt!.isBefore(now);
    }).toList();
  }

  @override
  Future<void> addFlashcard(Flashcard flashcard) async {
    _flashcards.add(flashcard);
    _flashcardsController.add(List.unmodifiable(_flashcards));
  }

  @override
  Future<void> updateFlashcard(Flashcard flashcard) async {
    final index = _flashcards.indexWhere((f) => f.id == flashcard.id);
    if (index != -1) {
      _flashcards[index] = flashcard;
      _flashcardsController.add(List.unmodifiable(_flashcards));
    }
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    _flashcards.removeWhere((f) => f.id == id);
    _flashcardsController.add(List.unmodifiable(_flashcards));
  }

  @override
  Stream<List<Flashcard>> watchFlashcards({String? sourceId}) {
    return _flashcardsController.stream.map((cards) {
      if (sourceId == null) return cards;
      return cards.where((f) => f.sourceId == sourceId).toList();
    });
  }

  // ==================== Quiz Questions ====================

  @override
  Future<List<QuizQuestion>> getQuizQuestions({String? sourceId}) async {
    if (sourceId == null) return List.unmodifiable(_quizQuestions);
    return _quizQuestions.where((q) => q.sourceId == sourceId).toList();
  }

  @override
  Future<void> addQuizQuestion(QuizQuestion question) async {
    _quizQuestions.add(question);
    _quizController.add(List.unmodifiable(_quizQuestions));
  }

  @override
  Future<void> updateQuizQuestion(QuizQuestion question) async {
    final index = _quizQuestions.indexWhere((q) => q.id == question.id);
    if (index != -1) {
      _quizQuestions[index] = question;
      _quizController.add(List.unmodifiable(_quizQuestions));
    }
  }

  @override
  Future<void> deleteQuizQuestion(String id) async {
    _quizQuestions.removeWhere((q) => q.id == id);
    _quizController.add(List.unmodifiable(_quizQuestions));
  }

  @override
  Stream<List<QuizQuestion>> watchQuizQuestions({String? sourceId}) {
    return _quizController.stream.map((questions) {
      if (sourceId == null) return questions;
      return questions.where((q) => q.sourceId == sourceId).toList();
    });
  }

  // ==================== Identification Questions ====================

  @override
  Future<List<IdentificationQuestion>> getIdentificationQuestions({
    String? sourceId,
  }) async {
    if (sourceId == null) return List.unmodifiable(_identificationQuestions);
    return _identificationQuestions
        .where((q) => q.sourceId == sourceId)
        .toList();
  }

  @override
  Future<void> addIdentificationQuestion(
    IdentificationQuestion question,
  ) async {
    _identificationQuestions.add(question);
  }

  @override
  Future<void> updateIdentificationQuestion(
    IdentificationQuestion question,
  ) async {
    final index = _identificationQuestions.indexWhere(
      (q) => q.id == question.id,
    );
    if (index != -1) {
      _identificationQuestions[index] = question;
    }
  }

  @override
  Future<void> deleteIdentificationQuestion(String id) async {
    _identificationQuestions.removeWhere((q) => q.id == id);
  }

  // ==================== Image Occlusions ====================

  @override
  Future<List<ImageOcclusion>> getImageOcclusions({String? sourceId}) async {
    if (sourceId == null) return List.unmodifiable(_imageOcclusions);
    return _imageOcclusions.where((o) => o.sourceId == sourceId).toList();
  }

  @override
  Future<void> addImageOcclusion(ImageOcclusion occlusion) async {
    _imageOcclusions.add(occlusion);
  }

  @override
  Future<void> updateImageOcclusion(ImageOcclusion occlusion) async {
    final index = _imageOcclusions.indexWhere((o) => o.id == occlusion.id);
    if (index != -1) {
      _imageOcclusions[index] = occlusion;
    }
  }

  @override
  Future<void> deleteImageOcclusion(String id) async {
    _imageOcclusions.removeWhere((o) => o.id == id);
  }

  // ==================== Matching Sets ====================

  @override
  Future<List<MatchingSet>> getMatchingSets({String? sourceId}) async {
    if (sourceId == null) return List.unmodifiable(_matchingSets);
    return _matchingSets.where((m) => m.sourceId == sourceId).toList();
  }

  @override
  Future<void> addMatchingSet(MatchingSet set) async {
    _matchingSets.add(set);
  }

  @override
  Future<void> updateMatchingSet(MatchingSet set) async {
    final index = _matchingSets.indexWhere((m) => m.id == set.id);
    if (index != -1) {
      _matchingSets[index] = set;
    }
  }

  @override
  Future<void> deleteMatchingSet(String id) async {
    _matchingSets.removeWhere((m) => m.id == id);
  }

  /// Dispose resources
  void dispose() {
    _flashcardsController.close();
    _quizController.close();
  }
}
