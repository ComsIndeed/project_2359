import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';
import 'package:project_2359/core/enums/media_type.dart';
import 'package:project_2359/core/tables/source_item_blobs.dart';

class SourcesPageBloc extends Bloc<SourcesPageEvent, SourcesPageState> {
  final SourceService sourceService;
  static const String _tag = 'SourcesPageBloc';
  String? _currentCollectionId;

  SourcesPageBloc(this.sourceService) : super(const SourcesPageStateInitial()) {
    on<LoadSourcesEvent>(_onLoad);
    on<ImportDocumentsEvent>(_onImport);
    on<DeleteSourceEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadSourcesEvent event,
    Emitter<SourcesPageState> emit,
  ) async {
    AppLogger.debug('Loading sources for collection: ${event.collectionId}', tag: _tag);
    _currentCollectionId = event.collectionId;
    final sources = event.collectionId != null
        ? await sourceService.getSourcesByCollectionId(event.collectionId!)
        : await sourceService.getAllSources();
    emit(SourcesPageStateLoaded(sources: sources));
  }

  Future<void> _onImport(
    ImportDocumentsEvent event,
    Emitter<SourcesPageState> emit,
  ) async {
    final effectiveCollectionId = event.collectionId ?? _currentCollectionId;
    const uuid = Uuid();

    AppLogger.info('Importing ${event.files.length} documents', tag: _tag);

    for (final file in event.files) {
      if (file.bytes == null) {
        AppLogger.warning(
          'Skipping file ${file.name} because bytes are null.',
          tag: _tag,
        );
        continue;
      }

      final sourceId = uuid.v4();
      final blobId = uuid.v4();
      final extension = file.extension ?? 'unknown';

      final sourceFileType = switch (extension.toLowerCase()) {
        'pdf' => SourceFileType.pdf,
        'docx' => SourceFileType.docx,
        'xlsx' => SourceFileType.xlsx,
        'txt' => SourceFileType.txt,
        _ => SourceFileType.unknown,
      };

      await sourceService.insertSource(
        SourceItemsCompanion.insert(
          id: sourceId,
          collectionId: Value(effectiveCollectionId),
          label: file.name,
          path: Value(file.path),
          type: MediaType.document,
        ),
      );

      await sourceService.insertSourceBlob(
        SourceItemBlobsCompanion.insert(
          id: blobId,
          sourceItemId: sourceId,
          sourceItemName: file.name,
          type: sourceFileType,
          bytes: file.bytes!,
        ),
      );
    }

    // Reload sources
    add(LoadSourcesEvent(collectionId: effectiveCollectionId));
  }

  Future<void> _onDelete(
    DeleteSourceEvent event,
    Emitter<SourcesPageState> emit,
  ) async {
    AppLogger.warning('Deleting source: ${event.sourceId}', tag: _tag);
    await sourceService.deleteSource(event.sourceId);
    await sourceService.deleteSourceBlobBySourceId(event.sourceId);

    // Reload sources
    add(LoadSourcesEvent(collectionId: _currentCollectionId));
  }
}
