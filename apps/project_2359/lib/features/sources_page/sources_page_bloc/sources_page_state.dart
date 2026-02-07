import 'package:project_2359/features/sources_page/data/source.dart';

abstract class SourcesPageState {
  const SourcesPageState();
}

class SourcesPageStateInitial extends SourcesPageState {
  const SourcesPageStateInitial();
}

class SourcesPageStateLoading extends SourcesPageState {
  const SourcesPageStateLoading();
}

class SourcesPageStateLoaded extends SourcesPageState {
  final List<Source> sources;

  const SourcesPageStateLoaded(this.sources);
}

class SourcesPageStateError extends SourcesPageState {
  final String error;
  const SourcesPageStateError(this.error);
}
