/// Riverpod providers for data layer
///
/// Provides datasource instances based on app configuration (test/production mode).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../datasources/interfaces/interfaces.dart';
import '../datasources/mock/mock.dart';
import '../datasources/drift/drift.dart';

/// Provider for the Drift database instance.
///
/// Singleton pattern ensures only one database connection is used.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider for [SourcesDatasource].
///
/// Returns mock implementation in test mode, Drift implementation in production.
final sourcesDatasourceProvider = Provider<SourcesDatasource>((ref) {
  if (kTestMode) {
    return MockSourcesDatasource();
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftSourcesDatasource(db);
});

/// Provider for [StudyDatasource].
final studyDatasourceProvider = Provider<StudyDatasource>((ref) {
  if (kTestMode) {
    return MockStudyDatasource();
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftStudyDatasource(db);
});

/// Provider for [UserDatasource].
final userDatasourceProvider = Provider<UserDatasource>((ref) {
  if (kTestMode) {
    return MockUserDatasource();
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftUserDatasource(db);
});
