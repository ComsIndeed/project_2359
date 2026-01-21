/// Drift study datasource implementation for Project 2359
///
/// SQLite-backed implementation for all study content types.
library;

import 'dart:convert';

import 'package:drift/drift.dart';

import '../interfaces/study_datasource.dart';
import '../../../models/models.dart';
import 'app_database.dart';

/// Drift implementation of [StudyDatasource] for production mode.
class DriftStudyDatasource implements StudyDatasource {
  final AppDatabase _db;

  DriftStudyDatasource(this._db);

  // ==================== Flashcards ====================

  Flashcard _flashcardEntryToModel(FlashcardEntry entry) {
    return Flashcard(
      id: entry.id,
      sourceId: entry.sourceId,
      front: entry.front,
      back: entry.back,
      frontImagePath: entry.frontImagePath,
      backImagePath: entry.backImagePath,
      tags: entry.tags,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entry.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(entry.updatedAt),
      // FSRS data is stored separately, not in the domain model directly
    );
  }

  FlashcardsCompanion _flashcardToCompanion(Flashcard flashcard) {
    return FlashcardsCompanion(
      id: Value(flashcard.id),
      sourceId: Value(flashcard.sourceId),
      front: Value(flashcard.front),
      back: Value(flashcard.back),
      frontImagePath: Value(flashcard.frontImagePath),
      backImagePath: Value(flashcard.backImagePath),
      sourceReferenceId: Value(flashcard.sourceReference?.id),
      tags: Value(flashcard.tags),
      createdAt: Value(flashcard.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(flashcard.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<List<Flashcard>> getFlashcards({String? sourceId}) async {
    var query = _db.select(_db.flashcards);
    if (sourceId != null) {
      query.where((f) => f.sourceId.equals(sourceId));
    }
    final entries = await query.get();
    return entries.map(_flashcardEntryToModel).toList();
  }

  @override
  Future<List<Flashcard>> getFlashcardsDueForReview() async {
    // For FSRS, we check the fsrsData JSON for due date
    // This is a simplified query - in production you'd parse the JSON
    final entries = await _db.select(_db.flashcards).get();
    final now = DateTime.now();
    return entries
        .where((entry) {
          if (entry.fsrsData.isEmpty || entry.fsrsData == '{}') return true;
          try {
            final fsrs = jsonDecode(entry.fsrsData) as Map<String, dynamic>;
            final dueMs = fsrs['due'] as int?;
            if (dueMs == null) return true;
            return DateTime.fromMillisecondsSinceEpoch(dueMs).isBefore(now);
          } catch (_) {
            return true;
          }
        })
        .map(_flashcardEntryToModel)
        .toList();
  }

  @override
  Future<void> addFlashcard(Flashcard flashcard) async {
    await _db.into(_db.flashcards).insert(_flashcardToCompanion(flashcard));
  }

  @override
  Future<void> updateFlashcard(Flashcard flashcard) async {
    await (_db.update(_db.flashcards)..where((f) => f.id.equals(flashcard.id)))
        .write(_flashcardToCompanion(flashcard));
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    await (_db.delete(_db.flashcards)..where((f) => f.id.equals(id))).go();
  }

  @override
  Stream<List<Flashcard>> watchFlashcards({String? sourceId}) {
    var query = _db.select(_db.flashcards);
    if (sourceId != null) {
      query.where((f) => f.sourceId.equals(sourceId));
    }
    return query.watch().map(
      (entries) => entries.map(_flashcardEntryToModel).toList(),
    );
  }

  // ==================== Quiz Questions ====================

  QuizQuestion _quizEntryToModel(QuizQuestionEntry entry) {
    return QuizQuestion(
      id: entry.id,
      sourceId: entry.sourceId,
      question: entry.question,
      options: entry.options,
      correctOptionIndex: entry.correctOptionIndex,
      explanation: entry.explanation,
      imagePath: entry.imagePath,
      tags: entry.tags,
      difficulty: entry.difficulty,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entry.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(entry.updatedAt),
    );
  }

  QuizQuestionsCompanion _quizToCompanion(QuizQuestion question) {
    return QuizQuestionsCompanion(
      id: Value(question.id),
      sourceId: Value(question.sourceId),
      question: Value(question.question),
      options: Value(question.options),
      correctOptionIndex: Value(question.correctOptionIndex),
      explanation: Value(question.explanation),
      imagePath: Value(question.imagePath),
      sourceReferenceId: Value(question.sourceReference?.id),
      tags: Value(question.tags),
      difficulty: Value(question.difficulty),
      createdAt: Value(question.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(question.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<List<QuizQuestion>> getQuizQuestions({String? sourceId}) async {
    var query = _db.select(_db.quizQuestions);
    if (sourceId != null) {
      query.where((q) => q.sourceId.equals(sourceId));
    }
    final entries = await query.get();
    return entries.map(_quizEntryToModel).toList();
  }

  @override
  Future<void> addQuizQuestion(QuizQuestion question) async {
    await _db.into(_db.quizQuestions).insert(_quizToCompanion(question));
  }

  @override
  Future<void> updateQuizQuestion(QuizQuestion question) async {
    await (_db.update(_db.quizQuestions)
          ..where((q) => q.id.equals(question.id)))
        .write(_quizToCompanion(question));
  }

  @override
  Future<void> deleteQuizQuestion(String id) async {
    await (_db.delete(_db.quizQuestions)..where((q) => q.id.equals(id))).go();
  }

  @override
  Stream<List<QuizQuestion>> watchQuizQuestions({String? sourceId}) {
    var query = _db.select(_db.quizQuestions);
    if (sourceId != null) {
      query.where((q) => q.sourceId.equals(sourceId));
    }
    return query.watch().map(
      (entries) => entries.map(_quizEntryToModel).toList(),
    );
  }

  // ==================== Identification Questions ====================

  IdentificationQuestion _identificationEntryToModel(
    IdentificationQuestionEntry entry,
  ) {
    return IdentificationQuestion(
      id: entry.id,
      sourceId: entry.sourceId,
      question: entry.question,
      modelAnswer: entry.modelAnswer,
      hints: entry.hints,
      keywords: entry.keywords,
      tags: entry.tags,
      difficulty: entry.difficulty,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entry.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(entry.updatedAt),
    );
  }

  IdentificationQuestionsCompanion _identificationToCompanion(
    IdentificationQuestion question,
  ) {
    return IdentificationQuestionsCompanion(
      id: Value(question.id),
      sourceId: Value(question.sourceId),
      question: Value(question.question),
      modelAnswer: Value(question.modelAnswer),
      hints: Value(question.hints),
      keywords: Value(question.keywords),
      sourceReferenceId: Value(question.sourceReference?.id),
      tags: Value(question.tags),
      difficulty: Value(question.difficulty),
      createdAt: Value(question.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(question.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<List<IdentificationQuestion>> getIdentificationQuestions({
    String? sourceId,
  }) async {
    var query = _db.select(_db.identificationQuestions);
    if (sourceId != null) {
      query.where((q) => q.sourceId.equals(sourceId));
    }
    final entries = await query.get();
    return entries.map(_identificationEntryToModel).toList();
  }

  @override
  Future<void> addIdentificationQuestion(
    IdentificationQuestion question,
  ) async {
    await _db
        .into(_db.identificationQuestions)
        .insert(_identificationToCompanion(question));
  }

  @override
  Future<void> updateIdentificationQuestion(
    IdentificationQuestion question,
  ) async {
    await (_db.update(_db.identificationQuestions)
          ..where((q) => q.id.equals(question.id)))
        .write(_identificationToCompanion(question));
  }

  @override
  Future<void> deleteIdentificationQuestion(String id) async {
    await (_db.delete(
      _db.identificationQuestions,
    )..where((q) => q.id.equals(id))).go();
  }

  // ==================== Image Occlusions ====================

  ImageOcclusion _occlusionEntryToModel(ImageOcclusionEntry entry) {
    List<OcclusionRegion> regions = [];
    if (entry.regions.isNotEmpty && entry.regions != '[]') {
      final decoded = jsonDecode(entry.regions) as List;
      regions = decoded
          .map(
            (r) => OcclusionRegion(
              id: r['id'] as String,
              x: (r['x'] as num).toDouble(),
              y: (r['y'] as num).toDouble(),
              width: (r['width'] as num).toDouble(),
              height: (r['height'] as num).toDouble(),
              label: r['label'] as String,
              hint: r['hint'] as String?,
            ),
          )
          .toList();
    }
    return ImageOcclusion(
      id: entry.id,
      sourceId: entry.sourceId,
      title: entry.title,
      imagePath: entry.imagePath,
      regions: regions,
      tags: entry.tags,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entry.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(entry.updatedAt),
    );
  }

  ImageOcclusionsCompanion _occlusionToCompanion(ImageOcclusion occlusion) {
    final regionsJson = jsonEncode(
      occlusion.regions
          .map(
            (r) => {
              'id': r.id,
              'x': r.x,
              'y': r.y,
              'width': r.width,
              'height': r.height,
              'label': r.label,
              'hint': r.hint,
            },
          )
          .toList(),
    );
    return ImageOcclusionsCompanion(
      id: Value(occlusion.id),
      sourceId: Value(occlusion.sourceId),
      title: Value(occlusion.title),
      imagePath: Value(occlusion.imagePath),
      regions: Value(regionsJson),
      sourceReferenceId: Value(occlusion.sourceReference?.id),
      tags: Value(occlusion.tags),
      createdAt: Value(occlusion.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(occlusion.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<List<ImageOcclusion>> getImageOcclusions({String? sourceId}) async {
    var query = _db.select(_db.imageOcclusions);
    if (sourceId != null) {
      query.where((o) => o.sourceId.equals(sourceId));
    }
    final entries = await query.get();
    return entries.map(_occlusionEntryToModel).toList();
  }

  @override
  Future<void> addImageOcclusion(ImageOcclusion occlusion) async {
    await _db
        .into(_db.imageOcclusions)
        .insert(_occlusionToCompanion(occlusion));
  }

  @override
  Future<void> updateImageOcclusion(ImageOcclusion occlusion) async {
    await (_db.update(_db.imageOcclusions)
          ..where((o) => o.id.equals(occlusion.id)))
        .write(_occlusionToCompanion(occlusion));
  }

  @override
  Future<void> deleteImageOcclusion(String id) async {
    await (_db.delete(_db.imageOcclusions)..where((o) => o.id.equals(id))).go();
  }

  // ==================== Matching Sets ====================

  MatchingSet _matchingEntryToModel(MatchingSetEntry entry) {
    List<MatchingPair> pairs = [];
    if (entry.pairs.isNotEmpty && entry.pairs != '[]') {
      final decoded = jsonDecode(entry.pairs) as List;
      pairs = decoded
          .map(
            (p) => MatchingPair(
              id: p['id'] as String,
              left: p['left'] as String,
              right: p['right'] as String,
            ),
          )
          .toList();
    }
    return MatchingSet(
      id: entry.id,
      sourceId: entry.sourceId,
      title: entry.title,
      instructions: entry.instructions,
      pairs: pairs,
      tags: entry.tags,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entry.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(entry.updatedAt),
    );
  }

  MatchingSetsCompanion _matchingToCompanion(MatchingSet matchingSet) {
    final pairsJson = jsonEncode(
      matchingSet.pairs
          .map((p) => {'id': p.id, 'left': p.left, 'right': p.right})
          .toList(),
    );
    return MatchingSetsCompanion(
      id: Value(matchingSet.id),
      sourceId: Value(matchingSet.sourceId),
      title: Value(matchingSet.title),
      instructions: Value(matchingSet.instructions),
      pairs: Value(pairsJson),
      sourceReferenceId: Value(matchingSet.sourceReference?.id),
      tags: Value(matchingSet.tags),
      createdAt: Value(matchingSet.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(matchingSet.updatedAt.millisecondsSinceEpoch),
    );
  }

  @override
  Future<List<MatchingSet>> getMatchingSets({String? sourceId}) async {
    var query = _db.select(_db.matchingSets);
    if (sourceId != null) {
      query.where((m) => m.sourceId.equals(sourceId));
    }
    final entries = await query.get();
    return entries.map(_matchingEntryToModel).toList();
  }

  @override
  Future<void> addMatchingSet(MatchingSet set) async {
    await _db.into(_db.matchingSets).insert(_matchingToCompanion(set));
  }

  @override
  Future<void> updateMatchingSet(MatchingSet set) async {
    await (_db.update(
      _db.matchingSets,
    )..where((m) => m.id.equals(set.id))).write(_matchingToCompanion(set));
  }

  @override
  Future<void> deleteMatchingSet(String id) async {
    await (_db.delete(_db.matchingSets)..where((m) => m.id.equals(id))).go();
  }
}
