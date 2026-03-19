import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';
import 'package:uuid/uuid.dart';

class SourcesPageBloc extends Bloc<SourcesPageEvent, SourcesPageState> {
  final SourceService sourceService;
  String? _currentFolderId;

  SourcesPageBloc(this.sourceService) : super(const SourcesPageStateInitial()) {
    on<LoadSourcesEvent>(_onLoad);
    on<ImportDocumentsEvent>(_onImport);
    on<DeleteSourceEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadSourcesEvent event,
    Emitter<SourcesPageState> emit,
  ) async {
    final sources = event.folderId != null
        ? await sourceService.getSourcesByFolderId(event.folderId!)
        : await sourceService.getAllSources();
    emit(SourcesPageStateLoaded(sources: sources));
  }

  Future<void> _onImport(
    ImportDocumentsEvent event,
    Emitter<SourcesPageState> emit,
  ) async {
    final effectiveFolderId = event.folderId ?? _currentFolderId;
    const uuid = Uuid();

    for (final file in event.files) {
      print('--- Importing Document ---');
      print('Name: ${file.name}');
      print('Extension: ${file.extension}');
      print('Path: ${file.path}');
      print('Bytes is null: ${file.bytes == null}');
      if (file.bytes != null) {
        print('Bytes length: ${file.bytes!.length}');
      }

      if (file.bytes == null) {
        print('Skipping file ${file.name} because bytes are null.');
        continue;
      }

      final sourceId = uuid.v4();
      final blobId = uuid.v4();

      final extension = file.extension ?? 'unknown';

      await sourceService.insertSource(
        SourceItemsCompanion.insert(
          id: sourceId,
          folderId: Value(effectiveFolderId),
          label: file.name,
          path: Value(file.path),
          type: 'document',
        ),
      );

      await sourceService.insertSourceBlob(
        SourceItemBlobsCompanion.insert(
          id: blobId,
          sourceItemId: sourceId,
          sourceItemName: file.name,
          type: extension,
          bytes: file.bytes!,
        ),
      );
    }

    final sources = effectiveFolderId != null
        ? await sourceService.getSourcesByFolderId(effectiveFolderId)
        : await sourceService.getAllSources();
    emit(SourcesPageStateLoaded(sources: sources));
  }

  Future<void> _onDelete(
    DeleteSourceEvent event,
    Emitter<SourcesPageState> emit,
  ) async {
    await sourceService.deleteSource(event.sourceId);
    await sourceService.deleteSourceBlobBySourceId(event.sourceId);

    final sources = _currentFolderId != null
        ? await sourceService.getSourcesByFolderId(_currentFolderId!)
        : await sourceService.getAllSources();
    emit(SourcesPageStateLoaded(sources: sources));
  }
}
