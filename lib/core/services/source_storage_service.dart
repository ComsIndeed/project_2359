/// Source storage service for Project 2359
///
/// Handles storing source files in app-local storage.
/// Pipeline: User file → Copy to app storage → Return stored path
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/source.dart';

/// Service for managing source file storage.
///
/// Files are stored in the app's documents directory under 'sources/'.
/// Each file is given a unique name to prevent collisions.
class SourceStorageService {
  static const _uuid = Uuid();
  static const _sourcesDir = 'sources';

  /// Gets the base directory for source storage
  Future<Directory> getSourcesDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final sourcesDir = Directory(p.join(appDir.path, _sourcesDir));
    if (!await sourcesDir.exists()) {
      await sourcesDir.create(recursive: true);
    }
    return sourcesDir;
  }

  /// Gets the subdirectory for a specific source type
  Future<Directory> _getTypeDirectory(SourceType type) async {
    final sourcesDir = await getSourcesDirectory();
    final typeDir = Directory(p.join(sourcesDir.path, type.name));
    if (!await typeDir.exists()) {
      await typeDir.create(recursive: true);
    }
    return typeDir;
  }

  /// Copies a file to app storage and returns the new path.
  ///
  /// The file is stored under 'sources/{type}/{uuid}_{originalName}'
  Future<String> storeFile(String sourcePath, SourceType type) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw FileSystemException('Source file not found', sourcePath);
    }

    final typeDir = await _getTypeDirectory(type);
    final originalName = p.basename(sourcePath);
    final uniqueId = _uuid.v4().substring(0, 8);
    final newFileName = '${uniqueId}_$originalName';
    final destinationPath = p.join(typeDir.path, newFileName);

    await sourceFile.copy(destinationPath);
    return destinationPath;
  }

  /// Stores raw content as a file (for notes, etc.)
  Future<String> storeContent(
    String content,
    String fileName,
    SourceType type,
  ) async {
    final typeDir = await _getTypeDirectory(type);
    final uniqueId = _uuid.v4().substring(0, 8);
    final newFileName = '${uniqueId}_$fileName';
    final destinationPath = p.join(typeDir.path, newFileName);

    final file = File(destinationPath);
    await file.writeAsString(content);
    return destinationPath;
  }

  /// Deletes a stored source file
  Future<void> deleteFile(String storedPath) async {
    final file = File(storedPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Deletes all files for a source type
  Future<void> deleteTypeDirectory(SourceType type) async {
    final sourcesDir = await getSourcesDirectory();
    final typeDir = Directory(p.join(sourcesDir.path, type.name));
    if (await typeDir.exists()) {
      await typeDir.delete(recursive: true);
    }
  }

  /// Gets the total size of all stored files in bytes
  Future<int> getTotalStorageSize() async {
    final sourcesDir = await getSourcesDirectory();
    if (!await sourcesDir.exists()) return 0;

    int totalSize = 0;
    await for (final entity in sourcesDir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    return totalSize;
  }

  /// Lists all stored files with their metadata
  Future<List<StoredFileInfo>> listStoredFiles() async {
    final sourcesDir = await getSourcesDirectory();
    if (!await sourcesDir.exists()) return [];

    final files = <StoredFileInfo>[];
    await for (final entity in sourcesDir.list(recursive: true)) {
      if (entity is File) {
        final stat = await entity.stat();
        final relativePath = p.relative(entity.path, from: sourcesDir.path);
        final parts = p.split(relativePath);
        final typeStr = parts.isNotEmpty ? parts.first : 'unknown';

        files.add(
          StoredFileInfo(
            path: entity.path,
            name: p.basename(entity.path),
            type: _parseSourceType(typeStr),
            sizeBytes: stat.size,
            modifiedAt: stat.modified,
          ),
        );
      }
    }
    return files;
  }

  /// Clears all stored source files
  Future<void> clearAllStorage() async {
    final sourcesDir = await getSourcesDirectory();
    if (await sourcesDir.exists()) {
      await sourcesDir.delete(recursive: true);
      await sourcesDir.create();
    }
  }

  SourceType? _parseSourceType(String typeStr) {
    try {
      return SourceType.values.firstWhere((t) => t.name == typeStr);
    } catch (_) {
      return null;
    }
  }
}

/// Information about a stored file
class StoredFileInfo {
  final String path;
  final String name;
  final SourceType? type;
  final int sizeBytes;
  final DateTime modifiedAt;

  const StoredFileInfo({
    required this.path,
    required this.name,
    this.type,
    required this.sizeBytes,
    required this.modifiedAt,
  });

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
