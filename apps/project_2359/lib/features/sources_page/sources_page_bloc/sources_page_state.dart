import 'package:file_picker/file_picker.dart';

abstract class SourcesPageState {
  const SourcesPageState();
}

class SourcesPageStateInitial extends SourcesPageState {
  const SourcesPageStateInitial();
}

class SourcesPageStateLoadedFiles extends SourcesPageState {
  final List<PlatformFile> pendingFiles;
  final List<PlatformFile> files;

  const SourcesPageStateLoadedFiles({
    required this.pendingFiles,
    required this.files,
  });

  SourcesPageStateLoadedFiles copyWith({
    List<PlatformFile>? pendingFiles,
    List<PlatformFile>? files,
  }) {
    return SourcesPageStateLoadedFiles(
      pendingFiles: pendingFiles ?? this.pendingFiles,
      files: files ?? this.files,
    );
  }
}
