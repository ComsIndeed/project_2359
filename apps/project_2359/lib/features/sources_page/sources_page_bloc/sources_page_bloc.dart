import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';

class SourcesPageBloc extends Bloc<SourcesPageEvent, SourcesPageState> {
  SourcesPageBloc() : super(const SourcesPageStateInitial()) {
    on<SourcesPageEventInitial>((event, emit) {
      emit(SourcesPageStateLoadedFiles(pendingFiles: [], files: []));
    });

    on<ImportDocumentSourcesPageEvent>((event, emit) {
      if (state is! SourcesPageStateLoadedFiles) return;
      final loadedState = state as SourcesPageStateLoadedFiles;
      final files = event.files;

      emit(
        loadedState.copyWith(
          pendingFiles: [...loadedState.pendingFiles, ...files],
        ),
      );
    });
  }
}
