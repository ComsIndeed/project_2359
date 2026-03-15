import 'package:project_2359/app_database.dart';

/// Service for CRUD operations on study folders, materials (packs), and cards.
class StudyMaterialService {
  final AppDatabase _db;

  StudyMaterialService(this._db);

  // --- Folders ---

  Future<List<StudyFolderItem>> getAllFolders() async {
    return await _db.select(_db.studyFolderItems).get();
  }

  Stream<List<StudyFolderItem>> watchAllFolders() {
    return _db.select(_db.studyFolderItems).watch();
  }

  Future<StudyFolderItem?> getFolderById(String id) async {
    return await (_db.select(
      _db.studyFolderItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertFolder(StudyFolderItemsCompanion folder) async {
    await _db.into(_db.studyFolderItems).insert(folder);
  }

  Future<void> deleteFolder(String id) async {
    await _db.transaction(() async {
      // 1. Get all materials (packs) in this folder
      final materials = await (_db.select(
        _db.studyMaterialItems,
      )..where((t) => t.folderId.equals(id))).get();

      // 2. For each material, delete its cards
      for (final material in materials) {
        await (_db.delete(
          _db.studyCardItems,
        )..where((t) => t.materialId.equals(material.id))).go();
      }

      // 3. Delete materials
      await (_db.delete(
        _db.studyMaterialItems,
      )..where((t) => t.folderId.equals(id))).go();

      // 4. Delete sources (if they also belong to folders)
      await (_db.delete(
        _db.sourceItems,
      )..where((t) => t.folderId.equals(id))).go();

      // 5. Finally, delete the folder
      await (_db.delete(
        _db.studyFolderItems,
      )..where((t) => t.id.equals(id))).go();
    });
  }

  /// Fetches all folders and joins them with their associated sources.
  Future<List<(StudyFolderItem, List<SourceItem>)>>
  getFoldersWithSources() async {
    final folders = await getAllFolders();
    final result = <(StudyFolderItem, List<SourceItem>)>[];

    for (final folder in folders) {
      final sources = await (_db.select(
        _db.sourceItems,
      )..where((t) => t.folderId.equals(folder.id))).get();
      result.add((folder, sources));
    }
    return result;
  }

  // --- Materials (Packs) ---

  Future<List<StudyMaterialItem>> getMaterialsByFolderId(
    String folderId,
  ) async {
    return await (_db.select(
      _db.studyMaterialItems,
    )..where((t) => t.folderId.equals(folderId))).get();
  }

  Stream<List<StudyMaterialItem>> watchMaterialsByFolderId(String folderId) {
    return (_db.select(
      _db.studyMaterialItems,
    )..where((t) => t.folderId.equals(folderId))).watch();
  }

  Future<void> insertMaterial(StudyMaterialItemsCompanion material) async {
    await _db.into(_db.studyMaterialItems).insert(material);
  }

  Future<void> deleteMaterial(String id) async {
    await _db.transaction(() async {
      // Delete cards first
      await (_db.delete(
        _db.studyCardItems,
      )..where((t) => t.materialId.equals(id))).go();
      // Then delete material
      await (_db.delete(
        _db.studyMaterialItems,
      )..where((t) => t.id.equals(id))).go();
    });
  }

  // --- Cards ---

  Future<List<StudyCardItem>> getCardsByMaterialId(String materialId) async {
    return await (_db.select(
      _db.studyCardItems,
    )..where((t) => t.materialId.equals(materialId))).get();
  }

  Future<void> insertCard(StudyCardItemsCompanion card) async {
    await _db.into(_db.studyCardItems).insert(card);
  }

  Future<void> insertCards(List<StudyCardItemsCompanion> cards) async {
    await _db.batch((batch) {
      batch.insertAll(_db.studyCardItems, cards);
    });
  }

  Future<void> deleteCard(String id) async {
    await (_db.delete(_db.studyCardItems)..where((t) => t.id.equals(id))).go();
  }

  // --- Combined Operations ---

  /// Creates a material (pack) and all its cards in a single transaction.
  Future<void> createMaterialWithCards({
    required StudyMaterialItemsCompanion material,
    required List<StudyCardItemsCompanion> cards,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.studyMaterialItems).insert(material);
      await _db.batch((batch) {
        batch.insertAll(_db.studyCardItems, cards);
      });
    });
  }
}
