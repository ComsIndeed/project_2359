import 'dart:io';

import 'package:project_2359/features/sources_page/data/source.dart';

class SourceService {
  /// =============================
  /// CRUD METHODS
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
  /// IMPORT METHODS
  /// =============================

  static Future<void> importDocument(File file) async {
    throw UnimplementedError();
  }

  static Future<void> importPhoto(File file) async {
    throw UnimplementedError();
  }

  static Future<void> importAudio(File file) async {
    throw UnimplementedError();
  }

  static Future<void> importVideo(File file) async {
    throw UnimplementedError();
  }

  static Future<void> importFlashcards(File file) async {
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
