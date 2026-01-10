/// Drift database for Project 2359
///
/// SQLite database using Drift for persistent local storage.
/// Includes all tables for sources, study materials, FSRS scheduling, and user data.
library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../models/models.dart';
import '../../config/app_config.dart';

part 'app_database.g.dart';

// ==================== Type Converters ====================

/// Converter for List<String> stored as JSON
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final decoded = jsonDecode(fromDb);
    return (decoded as List).cast<String>();
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

/// Converter for SourceType enum
class SourceTypeConverter extends TypeConverter<SourceType, int> {
  const SourceTypeConverter();

  @override
  SourceType fromSql(int fromDb) => SourceType.values[fromDb];

  @override
  int toSql(SourceType value) => value.index;
}

/// Converter for ReferenceType enum
class ReferenceTypeConverter extends TypeConverter<ReferenceType, int> {
  const ReferenceTypeConverter();

  @override
  ReferenceType fromSql(int fromDb) => ReferenceType.values[fromDb];

  @override
  int toSql(ReferenceType value) => value.index;
}

// ==================== Tables ====================

/// Sources table - learning materials (PDFs, notes, links, etc.)
@DataClassName('SourceEntry')
class Sources extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get type => integer().map(const SourceTypeConverter())();
  IntColumn get createdAt => integer()();
  IntColumn get lastAccessedAt => integer()();
  TextColumn get filePath => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get content => text().nullable()();
  IntColumn get sizeBytes => integer().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter())();
  BoolColumn get isIndexed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Flashcards table with FSRS scheduling
@DataClassName('FlashcardEntry')
class Flashcards extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text().references(Sources, #id)();
  TextColumn get front => text()();
  TextColumn get back => text()();
  TextColumn get frontImagePath => text().nullable()();
  TextColumn get backImagePath => text().nullable()();
  TextColumn get sourceReferenceId => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter())();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  // FSRS scheduling data stored as JSON
  TextColumn get fsrsData => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Quiz questions table (multiple choice) with FSRS
@DataClassName('QuizQuestionEntry')
class QuizQuestions extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text().references(Sources, #id)();
  TextColumn get question => text()();
  TextColumn get options => text().map(const StringListConverter())();
  IntColumn get correctOptionIndex => integer()();
  TextColumn get explanation => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get sourceReferenceId => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter())();
  IntColumn get difficulty => integer().withDefault(const Constant(3))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get fsrsData => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Identification questions (renamed from FreeFormQuestion) with FSRS
@DataClassName('IdentificationQuestionEntry')
class IdentificationQuestions extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text().references(Sources, #id)();
  TextColumn get question => text()();
  TextColumn get modelAnswer => text()();
  TextColumn get hints => text().map(const StringListConverter())();
  TextColumn get keywords => text().map(const StringListConverter())();
  TextColumn get sourceReferenceId => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter())();
  IntColumn get difficulty => integer().withDefault(const Constant(3))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get fsrsData => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Image occlusions table with FSRS
@DataClassName('ImageOcclusionEntry')
class ImageOcclusions extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text().references(Sources, #id)();
  TextColumn get title => text()();
  TextColumn get imagePath => text()();
  // Regions stored as JSON array of {id, x, y, width, height, label, hint}
  TextColumn get regions => text().withDefault(const Constant('[]'))();
  TextColumn get sourceReferenceId => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter())();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get fsrsData => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Matching sets table with FSRS
@DataClassName('MatchingSetEntry')
class MatchingSets extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text().references(Sources, #id)();
  TextColumn get title => text()();
  TextColumn get instructions => text().nullable()();
  // Pairs stored as JSON array of {id, left, right}
  TextColumn get pairs => text().withDefault(const Constant('[]'))();
  TextColumn get sourceReferenceId => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter())();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get fsrsData => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Source references table - tracks where content originated
@DataClassName('SourceReferenceEntry')
class SourceReferences extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text().references(Sources, #id)();
  IntColumn get type => integer().map(const ReferenceTypeConverter())();
  IntColumn get pageNumber => integer().nullable()();
  IntColumn get startOffset => integer().nullable()();
  IntColumn get endOffset => integer().nullable()();
  TextColumn get matchedText => text().nullable()();
  RealColumn get startTimestamp => real().nullable()();
  RealColumn get endTimestamp => real().nullable()();
  RealColumn get regionX => real().nullable()();
  RealColumn get regionY => real().nullable()();
  RealColumn get regionWidth => real().nullable()();
  RealColumn get regionHeight => real().nullable()();
  TextColumn get anchor => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Review logs table - tracks FSRS review history
@DataClassName('ReviewLogEntry')
class ReviewLogs extends Table {
  TextColumn get id => text()();
  TextColumn get cardType => text()(); // 'flashcard', 'quiz', etc.
  TextColumn get cardId => text()();
  IntColumn get reviewDateTime => integer()();
  IntColumn get rating => integer()(); // 1=Again, 2=Hard, 3=Good, 4=Easy
  IntColumn get scheduledDays => integer()();
  IntColumn get elapsedDays => integer()();
  IntColumn get state => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Users table - local user profile and stats
@DataClassName('UserEntry')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get institution => text().nullable()();
  TextColumn get major => text().nullable()();
  TextColumn get yearLevel => text().nullable()();
  IntColumn get totalStudyMinutes => integer().withDefault(const Constant(0))();
  IntColumn get totalCardsReviewed =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalQuizzesTaken => integer().withDefault(const Constant(0))();
  RealColumn get averageScore => real().withDefault(const Constant(0.0))();
  IntColumn get credits => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get lastActiveAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// ==================== Database ====================

@DriftDatabase(
  tables: [
    Sources,
    Flashcards,
    QuizQuestions,
    IdentificationQuestions,
    ImageOcclusions,
    MatchingSets,
    SourceReferences,
    ReviewLogs,
    Users,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ==================== Storage Stats ====================

  /// Get total count of each item type for storage page
  Future<Map<String, int>> getStorageStats() async {
    final sourcesCount = await (select(sources)..limit(1000)).get();
    final flashcardsCount = await (select(flashcards)..limit(10000)).get();
    final quizCount = await (select(quizQuestions)..limit(10000)).get();
    final identificationCount = await (select(
      identificationQuestions,
    )..limit(10000)).get();
    final occlusionCount = await (select(imageOcclusions)..limit(10000)).get();
    final matchingCount = await (select(matchingSets)..limit(10000)).get();

    return {
      'sources': sourcesCount.length,
      'flashcards': flashcardsCount.length,
      'quizQuestions': quizCount.length,
      'identificationQuestions': identificationCount.length,
      'imageOcclusions': occlusionCount.length,
      'matchingSets': matchingCount.length,
    };
  }

  /// Get total file size of imported sources
  Future<int> getTotalSourceFilesSize() async {
    final result = await customSelect(
      'SELECT COALESCE(SUM(size_bytes), 0) as total FROM sources WHERE size_bytes IS NOT NULL',
    ).getSingle();
    return result.data['total'] as int;
  }
}

/// Opens a connection to the SQLite database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, kAppName, kDatabaseName));

    // Ensure directory exists
    await file.parent.create(recursive: true);

    return NativeDatabase.createInBackground(file);
  });
}
