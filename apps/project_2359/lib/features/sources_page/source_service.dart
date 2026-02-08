import 'dart:typed_data';

import 'package:project_2359/app_database.dart';

/// Service class for managing source operations.
/// Uses platform-agnostic types (Uint8List, String) for web compatibility.
class SourceService {
  final AppDatabase _db;

  SourceService(this._db);

  /// =============================
  /// CRUD METHODS (LOCAL DATABASE)
  /// =============================

  // TODO: AI GENERATED THIS CODE, DOUBLE CHECK

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

  /// =============================
  /// IMPORT METHODS (STUBS)
  /// =============================

  /// Imports a document from raw bytes.
  /// [fileName] - The original file name.
  /// [fileBytes] - The raw bytes of the document.
  Future<SourceItem> importDocument(
    String fileName,
    Uint8List fileBytes,
  ) async {
    // TODO: Implement PDF text extraction using syncfusion_flutter_pdf
    throw UnimplementedError();
  }

  /// Imports a photo from raw bytes.
  Future<SourceItem> importPhoto(String fileName, Uint8List fileBytes) async {
    // TODO: Implement image OCR
    throw UnimplementedError();
  }

  /// Imports an audio file from raw bytes.
  Future<SourceItem> importAudio(String fileName, Uint8List fileBytes) async {
    // TODO: Implement audio transcription
    throw UnimplementedError();
  }

  /// Imports a video file from raw bytes.
  Future<SourceItem> importVideo(String fileName, Uint8List fileBytes) async {
    // TODO: Implement video transcription
    throw UnimplementedError();
  }
}
