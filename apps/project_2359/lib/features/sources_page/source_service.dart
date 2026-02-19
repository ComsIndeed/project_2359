import 'dart:typed_data';

import 'package:project_2359/app_database.dart';

/// Service class for managing source operations.
/// Uses platform-agnostic types (Uint8List, String) for web compatibility.
class SourceService {
  final AppDatabase _db;

  SourceService(this._db);

  /// =============================
  /// CRUD SOURCE BLOB (LOCAL DATABASE)
  /// =============================

  Future<void> insertSourceBlob(SourceItemBlob sourceBlob) async {
    await _db.into(_db.sourceItemBlobs).insert(sourceBlob);
  }

  Future<void> updateSourceBlob(SourceItemBlob sourceBlob) async {
    await _db.update(_db.sourceItemBlobs).replace(sourceBlob);
  }

  Future<void> deleteSourceBlob(String id) async {
    await (_db.delete(_db.sourceItemBlobs)..where((t) => t.id.equals(id))).go();
  }

  Future<SourceItemBlob?> getSourceBlobById(String id) async {
    return await (_db.select(
      _db.sourceItemBlobs,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<SourceItemBlob>> getAllSourceBlobs() async {
    return await _db.select(_db.sourceItemBlobs).get();
  }

  /// =============================
  /// CRUD SOURCE FILE (LOCAL DATABASE)
  /// =============================

  Future<List<SourceItem>> getAllSources() async {
    return await _db.select(_db.sourceItems).get();
  }

  Future<SourceItem?> getSourceById(String id) async {
    return await (_db.select(
      _db.sourceItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertSource(SourceItem source) async {
    await _db.into(_db.sourceItems).insert(source);
  }

  Future<void> updateSource(SourceItem source) async {
    await _db.update(_db.sourceItems).replace(source);
  }

  Future<void> deleteSource(String id) async {
    await (_db.delete(_db.sourceItems)..where((t) => t.id.equals(id))).go();
  }
}
