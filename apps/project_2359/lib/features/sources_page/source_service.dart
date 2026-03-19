import 'package:drift/drift.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/utils/logger.dart';

class SourceService {
  final AppDatabase _db;
  static const String _tag = 'SourceService';

  SourceService(this._db);

  Future<List<SourceItem>> getAllSources() async {
    AppLogger.debug('Fetching all sources', tag: _tag);
    return await _db.select(_db.sourceItems).get();
  }

  Stream<List<SourceItem>> watchAllSources() {
    AppLogger.debug('Watching all sources', tag: _tag);
    return _db.select(_db.sourceItems).watch();
  }

  Stream<List<SourceItem>> watchPinnedSources() {
    AppLogger.debug('Watching pinned sources', tag: _tag);
    return (_db.select(
      _db.sourceItems,
    )..where((t) => t.isPinned.equals(true))).watch();
  }

  Future<List<SourceItem>> getSourcesByFolderId(String folderId) async {
    AppLogger.debug('Fetching sources for folder: $folderId', tag: _tag);
    return await (_db.select(
      _db.sourceItems,
    )..where((t) => t.folderId.equals(folderId))).get();
  }

  Stream<List<SourceItem>> watchSourcesByFolderId(String folderId) {
    AppLogger.debug('Watching sources for folder: $folderId', tag: _tag);
    return (_db.select(
      _db.sourceItems,
    )..where((t) => t.folderId.equals(folderId))).watch();
  }

  Future<SourceItem?> getSourceById(String id) async {
    AppLogger.debug('Fetching source by ID: $id', tag: _tag);
    return await (_db.select(
      _db.sourceItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertSource(SourceItemsCompanion source) async {
    AppLogger.info('Inserting source: ${source.id.value}', tag: _tag);
    await _db.into(_db.sourceItems).insert(source);
  }

  Future<void> deleteSource(String id) async {
    AppLogger.warning('Deleting source: $id', tag: _tag);
    await (_db.delete(_db.sourceItems)..where((t) => t.id.equals(id))).go();
  }

  Future<void> toggleSourcePin(String id, bool isPinned) async {
    AppLogger.info(
      '${isPinned ? 'Pinning' : 'Unpinning'} source: $id',
      tag: _tag,
    );
    await (_db.update(_db.sourceItems)..where((t) => t.id.equals(id))).write(
      SourceItemsCompanion(isPinned: Value(isPinned)),
    );
  }

  Future<List<SourceItemBlob>> getAllSourceBlobs() async {
    AppLogger.debug('Fetching all source blobs', tag: _tag);
    return await _db.select(_db.sourceItemBlobs).get();
  }

  Future<SourceItemBlob?> getSourceBlobBySourceId(String sourceItemId) async {
    AppLogger.debug(
      'Fetching source blob for source: $sourceItemId',
      tag: _tag,
    );
    return await (_db.select(
      _db.sourceItemBlobs,
    )..where((t) => t.sourceItemId.equals(sourceItemId))).getSingleOrNull();
  }

  Future<void> insertSourceBlob(SourceItemBlobsCompanion blob) async {
    AppLogger.info('Inserting source blob', tag: _tag);
    await _db.into(_db.sourceItemBlobs).insert(blob);
  }

  Future<void> deleteSourceBlobBySourceId(String sourceItemId) async {
    AppLogger.warning(
      'Deleting source blob for source: $sourceItemId',
      tag: _tag,
    );
    await (_db.delete(
      _db.sourceItemBlobs,
    )..where((t) => t.sourceItemId.equals(sourceItemId))).go();
  }
}
