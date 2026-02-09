import 'package:file_picker/file_picker.dart';

abstract class SourcesPageState {
  const SourcesPageState();
}

class SourcesPageStateInitial extends SourcesPageState {
  const SourcesPageStateInitial();
}

class SourcesPageStateLoadedFiles extends SourcesPageState {
  final List<PlatformFile> files;

  const SourcesPageStateLoadedFiles({required this.files});

  SourcesPageStateLoadedFiles copyWith({List<PlatformFile>? files}) {
    return SourcesPageStateLoadedFiles(files: files ?? this.files);
  }
}
