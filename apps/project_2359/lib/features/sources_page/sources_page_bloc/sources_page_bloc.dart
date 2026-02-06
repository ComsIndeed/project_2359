import 'package:flutter_bloc/flutter_bloc.dart';

class SourcesPageBloc extends Bloc<SourcesPageEvent, SourcesPageState> {
  SourcesPageBloc() : super(SourcesPageState()) {
    on<SourcesPageEvent>((event, emit) {});
  }
}

class SourcesPageEvent {}

class SourcesPageState {}
