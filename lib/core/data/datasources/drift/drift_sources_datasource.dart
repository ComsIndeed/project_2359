/// Drift sources datasource implementation for Project 2359
///
/// SQLite-backed implementation of SourcesDatasource for persistent storage.
library;

import 'dart:async';

import 'package:drift/drift.dart';

import '../interfaces/sources_datasource.dart';
import '../../../models/models.dart';
import 'app_database.dart';

/// Drift implementation of [SourcesDatasource] for production mode.
class DriftSourcesDatasource implements SourcesDatasource {
  final AppDatabase _db;

  DriftSourcesDatasource(this._db);

  // ==================== Mapping Helpers ====================

  Source _entryToSource(SourceEntry entry) {
    return Source(
      id: entry.id,
      title: entry.title,
      type: entry.type,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entry.createdAt),
      lastAccessedAt: DateTime.fromMillisecondsSinceEpoch(entry.lastAccessedAt),
      filePath: entry.filePath,
      url: entry.url,
      content: entry.content,
      sizeBytes: entry.sizeBytes,
      durationSeconds: entry.durationSeconds,
      thumbnailPath: entry.thumbnailPath,
      tags: entry.tags,
      isIndexed: entry.isIndexed,
    );
  }

  SourcesCompanion _sourceToCompanion(Source source) {
    return SourcesCompanion(
      id: Value(source.id),
      title: Value(source.title),
      type: Value(source.type),
      createdAt: Value(source.createdAt.millisecondsSinceEpoch),
      lastAccessedAt: Value(source.lastAccessedAt.millisecondsSinceEpoch),
      filePath: Value(source.filePath),
      url: Value(source.url),
      content: Value(source.content),
      sizeBytes: Value(source.sizeBytes),
      durationSeconds: Value(source.durationSeconds),
      thumbnailPath: Value(source.thumbnailPath),
      tags: Value(source.tags),
      isIndexed: Value(source.isIndexed),
    );
  }

  // ==================== Interface Implementation ====================

  @override
  Future<List<Source>> getSources({SourceType? type}) async {
    final query = _db.select(_db.sources);
    if (type != null) {
      query.where((s) => s.type.equals(type.index));
    }
    final entries = await query.get();
    return entries.map(_entryToSource).toList();
  }

  @override
  Future<Source?> getSourceById(String id) async {
    final query = _db.select(_db.sources)..where((s) => s.id.equals(id));
    final entry = await query.getSingleOrNull();
    return entry != null ? _entryToSource(entry) : null;
  }

  @override
  Future<List<Source>> getRecentSources({int limit = 10}) async {
    final query = _db.select(_db.sources)
      ..orderBy([(s) => OrderingTerm.desc(s.lastAccessedAt)])
      ..limit(limit);
    final entries = await query.get();
    return entries.map(_entryToSource).toList();
  }

  @override
  Future<void> addSource(Source source) async {
    await _db.into(_db.sources).insert(_sourceToCompanion(source));
  }

  @override
  Future<void> updateSource(Source source) async {
    await (_db.update(
      _db.sources,
    )..where((s) => s.id.equals(source.id))).write(_sourceToCompanion(source));
  }

  @override
  Future<void> deleteSource(String id) async {
    await (_db.delete(_db.sources)..where((s) => s.id.equals(id))).go();
  }

  @override
  Future<List<Source>> searchSources(String query) async {
    final lowerQuery = '%${query.toLowerCase()}%';
    final results = await (_db.select(
      _db.sources,
    )..where((s) => s.title.lower().like(lowerQuery))).get();
    return results.map(_entryToSource).toList();
  }

  @override
  Stream<List<Source>> watchSources({SourceType? type}) {
    var query = _db.select(_db.sources);
    if (type != null) {
      query.where((s) => s.type.equals(type.index));
    }
    return query.watch().map((entries) => entries.map(_entryToSource).toList());
  }

  @override
  Future<void> markSourceAccessed(String id) async {
    await (_db.update(_db.sources)..where((s) => s.id.equals(id))).write(
      SourcesCompanion(
        lastAccessedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
