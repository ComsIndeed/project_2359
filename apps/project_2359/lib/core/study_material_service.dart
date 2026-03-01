import 'package:project_2359/app_database.dart';

/// Service for CRUD operations on study material packs and items.
class StudyMaterialService {
  final AppDatabase _db;

  StudyMaterialService(this._db);

  // --- Packs ---

  Future<List<StudyMaterialPackItem>> getAllPacks() async {
    return await _db.select(_db.studyMaterialPackItems).get();
  }

  Future<StudyMaterialPackItem?> getPackById(String id) async {
    return await (_db.select(
      _db.studyMaterialPackItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertPack(StudyMaterialPackItemsCompanion pack) async {
    await _db.into(_db.studyMaterialPackItems).insert(pack);
  }

  Future<void> deletePack(String id) async {
    // Delete all items in the pack first, then delete the pack
    await (_db.delete(
      _db.studyMaterialItems,
    )..where((t) => t.packId.equals(id))).go();
    await (_db.delete(
      _db.studyMaterialPackItems,
    )..where((t) => t.id.equals(id))).go();
  }

  // --- Items ---

  Future<List<StudyMaterialItem>> getItemsByPackId(String packId) async {
    return await (_db.select(
      _db.studyMaterialItems,
    )..where((t) => t.packId.equals(packId))).get();
  }

  Future<void> insertItem(StudyMaterialItemsCompanion item) async {
    await _db.into(_db.studyMaterialItems).insert(item);
  }

  Future<void> insertItems(List<StudyMaterialItemsCompanion> items) async {
    await _db.batch((batch) {
      batch.insertAll(_db.studyMaterialItems, items);
    });
  }

  Future<void> deleteItem(String id) async {
    await (_db.delete(
      _db.studyMaterialItems,
    )..where((t) => t.id.equals(id))).go();
  }

  /// Creates a pack and all its items in a single transaction.
  Future<void> createPackWithItems({
    required StudyMaterialPackItemsCompanion pack,
    required List<StudyMaterialItemsCompanion> items,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.studyMaterialPackItems).insert(pack);
      await _db.batch((batch) {
        batch.insertAll(_db.studyMaterialItems, items);
      });
    });
  }
}
