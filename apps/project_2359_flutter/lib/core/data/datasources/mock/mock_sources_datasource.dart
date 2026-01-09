/// Mock sources datasource implementation for Project 2359
///
/// In-memory implementation that uses predefined mock data.
/// Data can be modified during runtime but resets on app restart.
library;

import 'dart:async';

import '../interfaces/sources_datasource.dart';
import '../../../models/models.dart';
import 'mock_data.dart';

/// Mock implementation of [SourcesDatasource] for test mode.
///
/// Uses in-memory storage initialized from [mockSources].
/// Changes persist during the session but reset on app restart.
class MockSourcesDatasource implements SourcesDatasource {
  /// In-memory storage, initialized from mock data
  late List<Source> _sources;

  /// Stream controller for reactive updates
  final _sourcesController = StreamController<List<Source>>.broadcast();

  MockSourcesDatasource() {
    // Clone mock data to allow modifications
    _sources = List.from(mockSources);
  }

  void _notifyListeners() {
    _sourcesController.add(List.unmodifiable(_sources));
  }

  @override
  Future<List<Source>> getSources({SourceType? type}) async {
    if (type == null) {
      return List.unmodifiable(_sources);
    }
    return _sources.where((s) => s.type == type).toList();
  }

  @override
  Future<Source?> getSourceById(String id) async {
    try {
      return _sources.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Source>> getRecentSources({int limit = 10}) async {
    final sorted = List<Source>.from(_sources)
      ..sort((a, b) => b.lastAccessedAt.compareTo(a.lastAccessedAt));
    return sorted.take(limit).toList();
  }

  @override
  Future<void> addSource(Source source) async {
    _sources.add(source);
    _notifyListeners();
  }

  @override
  Future<void> updateSource(Source source) async {
    final index = _sources.indexWhere((s) => s.id == source.id);
    if (index != -1) {
      _sources[index] = source;
      _notifyListeners();
    }
  }

  @override
  Future<void> deleteSource(String id) async {
    _sources.removeWhere((s) => s.id == id);
    _notifyListeners();
  }

  @override
  Future<List<Source>> searchSources(String query) async {
    final lowerQuery = query.toLowerCase();
    return _sources.where((s) {
      return s.title.toLowerCase().contains(lowerQuery) ||
          s.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  @override
  Stream<List<Source>> watchSources({SourceType? type}) {
    // Emit current state immediately, then listen for changes
    return _sourcesController.stream
        .map((sources) {
          if (type == null) return sources;
          return sources.where((s) => s.type == type).toList();
        })
        .transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) => sink.add(data),
            handleDone: (sink) => sink.close(),
          ),
        );
  }

  @override
  Future<void> markSourceAccessed(String id) async {
    final index = _sources.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sources[index] = _sources[index].copyWith(
        lastAccessedAt: DateTime.now(),
      );
      _notifyListeners();
    }
  }

  /// Dispose resources
  void dispose() {
    _sourcesController.close();
  }
}
