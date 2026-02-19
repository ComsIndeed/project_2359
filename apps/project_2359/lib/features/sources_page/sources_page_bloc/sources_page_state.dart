import 'package:project_2359/app_database.dart';

abstract class SourcesPageState {
  const SourcesPageState();
}

class SourcesPageStateInitial extends SourcesPageState {
  const SourcesPageStateInitial();
}

class SourcesPageStateLoaded extends SourcesPageState {
  final List<SourceItem> sources;

  const SourcesPageStateLoaded({required this.sources});

  SourcesPageStateLoaded copyWith({List<SourceItem>? sources}) {
    return SourcesPageStateLoaded(sources: sources ?? this.sources);
  }
}
