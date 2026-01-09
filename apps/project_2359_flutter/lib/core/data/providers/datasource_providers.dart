/// Riverpod providers for data layer
///
/// Provides datasource instances based on app configuration (test/production mode).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../datasources/interfaces/interfaces.dart';
import '../datasources/mock/mock.dart';

/// Provider for [SourcesDatasource].
///
/// Returns mock implementation in test mode, Drift implementation in production.
final sourcesDatasourceProvider = Provider<SourcesDatasource>((ref) {
  if (kTestMode) {
    return MockSourcesDatasource();
  }
  // TODO: Return DriftSourcesDatasource when implemented
  return MockSourcesDatasource();
});

/// Provider for [StudyDatasource].
final studyDatasourceProvider = Provider<StudyDatasource>((ref) {
  if (kTestMode) {
    return MockStudyDatasource();
  }
  // TODO: Return DriftStudyDatasource when implemented
  return MockStudyDatasource();
});

/// Provider for [UserDatasource].
final userDatasourceProvider = Provider<UserDatasource>((ref) {
  if (kTestMode) {
    return MockUserDatasource();
  }
  // TODO: Return DriftUserDatasource when implemented
  return MockUserDatasource();
});
