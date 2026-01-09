/// Study datasource interface for Project 2359
///
/// Abstract interface for study content operations (flashcards, quizzes, etc).
library;

import '../../../models/models.dart';

/// Abstract interface for study content operations.
///
/// Manages all generated study materials:
/// - Flashcards
/// - Quiz questions (MCQ)
/// - Free-form Socratic questions
/// - Image occlusions
/// - Matching sets
abstract class StudyDatasource {
  // ==================== Flashcards ====================

  /// Get flashcards, optionally filtered by source
  Future<List<Flashcard>> getFlashcards({String? sourceId});

  /// Get flashcards due for review (spaced repetition)
  Future<List<Flashcard>> getFlashcardsDueForReview();

  /// Add a flashcard
  Future<void> addFlashcard(Flashcard flashcard);

  /// Update a flashcard (e.g., after review)
  Future<void> updateFlashcard(Flashcard flashcard);

  /// Delete a flashcard
  Future<void> deleteFlashcard(String id);

  /// Watch flashcards (reactive)
  Stream<List<Flashcard>> watchFlashcards({String? sourceId});

  // ==================== Quiz Questions ====================

  /// Get quiz questions, optionally filtered by source
  Future<List<QuizQuestion>> getQuizQuestions({String? sourceId});

  /// Add a quiz question
  Future<void> addQuizQuestion(QuizQuestion question);

  /// Update a quiz question
  Future<void> updateQuizQuestion(QuizQuestion question);

  /// Delete a quiz question
  Future<void> deleteQuizQuestion(String id);

  /// Watch quiz questions (reactive)
  Stream<List<QuizQuestion>> watchQuizQuestions({String? sourceId});

  // ==================== Free-form Questions ====================

  /// Get free-form Socratic questions
  Future<List<FreeFormQuestion>> getFreeFormQuestions({String? sourceId});

  /// Add a free-form question
  Future<void> addFreeFormQuestion(FreeFormQuestion question);

  /// Update a free-form question
  Future<void> updateFreeFormQuestion(FreeFormQuestion question);

  /// Delete a free-form question
  Future<void> deleteFreeFormQuestion(String id);

  // ==================== Image Occlusions ====================

  /// Get image occlusions
  Future<List<ImageOcclusion>> getImageOcclusions({String? sourceId});

  /// Add an image occlusion
  Future<void> addImageOcclusion(ImageOcclusion occlusion);

  /// Update an image occlusion
  Future<void> updateImageOcclusion(ImageOcclusion occlusion);

  /// Delete an image occlusion
  Future<void> deleteImageOcclusion(String id);

  // ==================== Matching Sets ====================

  /// Get matching sets
  Future<List<MatchingSet>> getMatchingSets({String? sourceId});

  /// Add a matching set
  Future<void> addMatchingSet(MatchingSet set);

  /// Update a matching set
  Future<void> updateMatchingSet(MatchingSet set);

  /// Delete a matching set
  Future<void> deleteMatchingSet(String id);
}
