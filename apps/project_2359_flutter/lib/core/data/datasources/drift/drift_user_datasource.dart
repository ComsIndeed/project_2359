/// Drift user datasource implementation for Project 2359
///
/// SQLite-backed implementation for user profile and statistics.
library;

import 'dart:async';

import 'package:drift/drift.dart';

import '../interfaces/user_datasource.dart';
import '../../../models/models.dart';
import 'app_database.dart';

/// Drift implementation of [UserDatasource] for production mode.
class DriftUserDatasource implements UserDatasource {
  final AppDatabase _db;

  DriftUserDatasource(this._db);

  // ==================== Mapping Helpers ====================

  User _entryToUser(UserEntry entry) {
    return User(
      id: entry.id,
      name: entry.name,
      email: entry.email,
      avatarUrl: entry.avatarUrl,
      institution: entry.institution,
      major: entry.major,
      yearLevel: entry.yearLevel,
      totalStudyMinutes: entry.totalStudyMinutes,
      totalCardsReviewed: entry.totalCardsReviewed,
      totalQuizzesTaken: entry.totalQuizzesTaken,
      averageScore: entry.averageScore,
      credits: entry.credits,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entry.createdAt),
      lastActiveAt: DateTime.fromMillisecondsSinceEpoch(entry.lastActiveAt),
    );
  }

  UsersCompanion _userToCompanion(User user) {
    return UsersCompanion(
      id: Value(user.id),
      name: Value(user.name),
      email: Value(user.email),
      avatarUrl: Value(user.avatarUrl),
      institution: Value(user.institution),
      major: Value(user.major),
      yearLevel: Value(user.yearLevel),
      totalStudyMinutes: Value(user.totalStudyMinutes),
      totalCardsReviewed: Value(user.totalCardsReviewed),
      totalQuizzesTaken: Value(user.totalQuizzesTaken),
      averageScore: Value(user.averageScore),
      credits: Value(user.credits),
      createdAt: Value(user.createdAt.millisecondsSinceEpoch),
      lastActiveAt: Value(user.lastActiveAt.millisecondsSinceEpoch),
    );
  }

  // ==================== Interface Implementation ====================

  @override
  Future<User?> getCurrentUser() async {
    // Get the first (and should be only) user
    final result = await (_db.select(_db.users)..limit(1)).getSingleOrNull();
    return result != null ? _entryToUser(result) : null;
  }

  @override
  Future<void> saveUser(User user) async {
    // Upsert: insert or update
    await _db.into(_db.users).insertOnConflictUpdate(_userToCompanion(user));
  }

  @override
  Future<void> updateStats({
    int? addStudyMinutes,
    int? addCardsReviewed,
    int? addQuizzesTaken,
    double? newScore,
  }) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) return;

    int totalStudyMinutes = currentUser.totalStudyMinutes;
    int totalCardsReviewed = currentUser.totalCardsReviewed;
    int totalQuizzesTaken = currentUser.totalQuizzesTaken;
    double averageScore = currentUser.averageScore;

    if (addStudyMinutes != null) {
      totalStudyMinutes += addStudyMinutes;
    }
    if (addCardsReviewed != null) {
      totalCardsReviewed += addCardsReviewed;
    }
    if (addQuizzesTaken != null) {
      totalQuizzesTaken += addQuizzesTaken;
      // Recalculate average score
      if (newScore != null) {
        final totalQuizzes = totalQuizzesTaken;
        averageScore =
            ((averageScore * (totalQuizzes - 1)) + newScore) / totalQuizzes;
      }
    }

    await (_db.update(
      _db.users,
    )..where((u) => u.id.equals(currentUser.id))).write(
      UsersCompanion(
        totalStudyMinutes: Value(totalStudyMinutes),
        totalCardsReviewed: Value(totalCardsReviewed),
        totalQuizzesTaken: Value(totalQuizzesTaken),
        averageScore: Value(averageScore),
        lastActiveAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  @override
  Future<void> addCredits(int amount) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) return;

    await (_db.update(_db.users)..where((u) => u.id.equals(currentUser.id)))
        .write(UsersCompanion(credits: Value(currentUser.credits + amount)));
  }

  @override
  Future<bool> deductCredits(int amount) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) return false;
    if (currentUser.credits < amount) return false;

    await (_db.update(_db.users)..where((u) => u.id.equals(currentUser.id)))
        .write(UsersCompanion(credits: Value(currentUser.credits - amount)));
    return true;
  }

  @override
  Stream<User?> watchCurrentUser() {
    return (_db.select(_db.users)..limit(1)).watchSingleOrNull().map(
      (entry) => entry != null ? _entryToUser(entry) : null,
    );
  }
}
