import 'dart:typed_data';

import 'package:project_2359/features/sources_page/data/source.dart';

/// Service class for managing source operations.
/// Uses platform-agnostic types (Uint8List, String) for web compatibility.
class SourceService {
  /// =============================
  /// CRUD METHODS (SUPABASE)
  /// =============================

  static Future<List<Source>> getAllSources() async {
    throw UnimplementedError();
  }

  static Future<Source> getSourceById(String id) async {
    throw UnimplementedError();
  }

  static Future<void> deleteSource(String id) async {
    throw UnimplementedError();
  }

  /// =============================
  /// CRUD METHODS (LOCAL)
  /// =============================

  static Future<List<Source>> getAllLocalSources() async {
    throw UnimplementedError();
  }

  static Future<Source> getLocalSourceById(String id) async {
    throw UnimplementedError();
  }

  static Future<void> deleteLocalSource(String id) async {
    throw UnimplementedError();
  }

  /// =============================
  /// IMPORT METHODS
  /// =============================

  /// Imports a document from raw bytes.
  /// [fileName] - The original file name.
  /// [fileBytes] - The raw bytes of the document.
  static Future<void> importDocument(
    String fileName,
    Uint8List fileBytes,
  ) async {
    throw UnimplementedError();
  }

  /// Imports a photo from raw bytes.
  /// [fileName] - The original file name.
  /// [fileBytes] - The raw bytes of the photo.
  static Future<void> importPhoto(String fileName, Uint8List fileBytes) async {
    throw UnimplementedError();
  }

  /// Imports an audio file from raw bytes.
  /// [fileName] - The original file name.
  /// [fileBytes] - The raw bytes of the audio.
  static Future<void> importAudio(String fileName, Uint8List fileBytes) async {
    throw UnimplementedError();
  }

  /// Imports a video file from raw bytes.
  /// [fileName] - The original file name.
  /// [fileBytes] - The raw bytes of the video.
  static Future<void> importVideo(String fileName, Uint8List fileBytes) async {
    throw UnimplementedError();
  }

  /// Imports a flashcards file from raw bytes.
  /// [fileName] - The original file name.
  /// [fileBytes] - The raw bytes of the flashcards file.
  static Future<void> importFlashcards(
    String fileName,
    Uint8List fileBytes,
  ) async {
    throw UnimplementedError();
  }

  static Future<void> importCloudDrive() async {
    throw UnimplementedError();
  }

  static Future<void> importWebsite() async {
    throw UnimplementedError();
  }

  static Future<void> importNoteApp() async {
    throw UnimplementedError();
  }
}
