/// User datasource interface for Project 2359
///
/// Abstract interface for user and settings operations.
library;

import '../../../models/models.dart';

/// Abstract interface for user data operations.
abstract class UserDatasource {
  /// Get the current user (local user for now)
  Future<User?> getCurrentUser();

  /// Create or update the current user
  Future<void> saveUser(User user);

  /// Update user statistics
  Future<void> updateStats({
    int? addStudyMinutes,
    int? addCardsReviewed,
    int? addQuizzesTaken,
    double? newScore,
  });

  /// Add credits to user account
  Future<void> addCredits(int amount);

  /// Deduct credits from user account
  Future<bool> deductCredits(int amount);

  /// Watch the current user (reactive)
  Stream<User?> watchCurrentUser();
}
