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
  const SourcesPageStateLoaded();
}

class SourcesPageStateError extends SourcesPageState {
  final String error;
  const SourcesPageStateError(this.error);
}
