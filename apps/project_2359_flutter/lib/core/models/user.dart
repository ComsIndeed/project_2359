/// User domain model for Project 2359
library;

/// User profile and study statistics.
class User {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;

  /// Academic info
  final String? institution;
  final String? major;
  final String? yearLevel;

  /// Study statistics
  final int totalStudyMinutes;
  final int totalCardsReviewed;
  final int totalQuizzesTaken;
  final double averageScore;

  /// Credits for generation
  final int credits;

  final DateTime createdAt;
  final DateTime lastActiveAt;

  const User({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
    this.institution,
    this.major,
    this.yearLevel,
    this.totalStudyMinutes = 0,
    this.totalCardsReviewed = 0,
    this.totalQuizzesTaken = 0,
    this.averageScore = 0.0,
    this.credits = 0,
    required this.createdAt,
    required this.lastActiveAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? institution,
    String? major,
    String? yearLevel,
    int? totalStudyMinutes,
    int? totalCardsReviewed,
    int? totalQuizzesTaken,
    double? averageScore,
    int? credits,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      institution: institution ?? this.institution,
      major: major ?? this.major,
      yearLevel: yearLevel ?? this.yearLevel,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      totalCardsReviewed: totalCardsReviewed ?? this.totalCardsReviewed,
      totalQuizzesTaken: totalQuizzesTaken ?? this.totalQuizzesTaken,
      averageScore: averageScore ?? this.averageScore,
      credits: credits ?? this.credits,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  String get formattedStudyTime {
    final hours = totalStudyMinutes ~/ 60;
    final minutes = totalStudyMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
