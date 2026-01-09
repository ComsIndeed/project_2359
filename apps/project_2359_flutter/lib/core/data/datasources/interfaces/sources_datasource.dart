/// Sources datasource interface for Project 2359
///
/// Abstract interface for source data operations.
/// Implemented by both mock and Drift datasources.
library;

import '../../../models/models.dart';

/// Abstract interface for source data operations.
///
/// This interface defines all operations for managing sources.
/// Implementations include:
/// - [MockSourcesDatasource] for test mode (in-memory)
/// - [DriftSourcesDatasource] for production mode (SQLite)
abstract class SourcesDatasource {
  /// Get all sources, optionally filtered by type
  Future<List<Source>> getSources({SourceType? type});

  /// Get a single source by ID
  Future<Source?> getSourceById(String id);

  /// Get recently accessed sources
  Future<List<Source>> getRecentSources({int limit = 10});

  /// Add a new source
  Future<void> addSource(Source source);

  /// Update an existing source
  Future<void> updateSource(Source source);

  /// Delete a source by ID
  Future<void> deleteSource(String id);

  /// Search sources by title
  Future<List<Source>> searchSources(String query);

  /// Watch all sources (reactive stream)
  Stream<List<Source>> watchSources({SourceType? type});

  /// Mark a source as accessed (updates lastAccessedAt)
  Future<void> markSourceAccessed(String id);
}
