import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';

class SourcesPageBloc extends Bloc<SourcesPageEvent, SourcesPageState> {
  SourcesPageBloc() : super(const SourcesPageStateInitial()) {
    on<SourcesPageEventInitial>((event, emit) {
      emit(const SourcesPageStateLoadedFiles(files: []));
    });

    on<ImportDocumentSourcesPageEvent>((event, emit) {
      final loadedState = state as SourcesPageStateLoadedFiles;
      final oldFiles = loadedState.files;
      final newFiles = event.files;

      emit(loadedState.copyWith(files: [...newFiles, ...oldFiles]));
    });
  }
}
