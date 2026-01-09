/// Mock user datasource implementation for Project 2359
library;

import 'dart:async';

import '../interfaces/user_datasource.dart';
import '../../../models/models.dart';
import 'mock_data.dart';

/// Mock implementation of [UserDatasource] for test mode.
class MockUserDatasource implements UserDatasource {
  late User _currentUser;
  final _userController = StreamController<User?>.broadcast();

  MockUserDatasource() {
    _currentUser = mockUser;
  }

  void _notifyListeners() {
    _userController.add(_currentUser);
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> saveUser(User user) async {
    _currentUser = user;
    _notifyListeners();
  }

  @override
  Future<void> updateStats({
    int? addStudyMinutes,
    int? addCardsReviewed,
    int? addQuizzesTaken,
    double? newScore,
  }) async {
    double avgScore = _currentUser.averageScore;
    if (newScore != null) {
      final totalQuizzes =
          _currentUser.totalQuizzesTaken + (addQuizzesTaken ?? 0);
      if (totalQuizzes > 0) {
        avgScore =
            ((_currentUser.averageScore * _currentUser.totalQuizzesTaken) +
                newScore) /
            totalQuizzes;
      }
    }

    _currentUser = _currentUser.copyWith(
      totalStudyMinutes:
          _currentUser.totalStudyMinutes + (addStudyMinutes ?? 0),
      totalCardsReviewed:
          _currentUser.totalCardsReviewed + (addCardsReviewed ?? 0),
      totalQuizzesTaken:
          _currentUser.totalQuizzesTaken + (addQuizzesTaken ?? 0),
      averageScore: avgScore,
      lastActiveAt: DateTime.now(),
    );
    _notifyListeners();
  }

  @override
  Future<void> addCredits(int amount) async {
    _currentUser = _currentUser.copyWith(
      credits: _currentUser.credits + amount,
    );
    _notifyListeners();
  }

  @override
  Future<bool> deductCredits(int amount) async {
    if (_currentUser.credits < amount) {
      return false;
    }
    _currentUser = _currentUser.copyWith(
      credits: _currentUser.credits - amount,
    );
    _notifyListeners();
    return true;
  }

  @override
  Stream<User?> watchCurrentUser() {
    return _userController.stream;
  }

  /// Dispose resources
  void dispose() {
    _userController.close();
  }
}
