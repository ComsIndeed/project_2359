import 'package:project_2359/app_database.dart';

class SourceService {
  final AppDatabase _db;

  SourceService(this._db);

  Future<List<SourceItem>> getAllSources() async {
    return await _db.select(_db.sourceItems).get();
  }

  Stream<List<SourceItem>> watchAllSources() {
    return _db.select(_db.sourceItems).watch();
  }

  Future<List<SourceItem>> getSourcesByFolderId(String folderId) async {
    return await (_db.select(
      _db.sourceItems,
    )..where((t) => t.folderId.equals(folderId))).get();
  }

  Stream<List<SourceItem>> watchSourcesByFolderId(String folderId) {
    return (_db.select(
      _db.sourceItems,
    )..where((t) => t.folderId.equals(folderId))).watch();
  }

  Future<SourceItem?> getSourceById(String id) async {
    return await (_db.select(
      _db.sourceItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertSource(SourceItemsCompanion source) async {
    await _db.into(_db.sourceItems).insert(source);
  }

  Future<void> deleteSource(String id) async {
    await (_db.delete(_db.sourceItems)..where((t) => t.id.equals(id))).go();
  }

  Future<List<SourceItemBlob>> getAllSourceBlobs() async {
    return await _db.select(_db.sourceItemBlobs).get();
  }

  Future<SourceItemBlob?> getSourceBlobBySourceId(String sourceItemId) async {
    return await (_db.select(
      _db.sourceItemBlobs,
    )..where((t) => t.sourceItemId.equals(sourceItemId))).getSingleOrNull();
  }

  Future<void> insertSourceBlob(SourceItemBlobsCompanion blob) async {
    await _db.into(_db.sourceItemBlobs).insert(blob);
  }

  Future<void> deleteSourceBlobBySourceId(String sourceItemId) async {
    await (_db.delete(
      _db.sourceItemBlobs,
    )..where((t) => t.sourceItemId.equals(sourceItemId))).go();
  }
}
