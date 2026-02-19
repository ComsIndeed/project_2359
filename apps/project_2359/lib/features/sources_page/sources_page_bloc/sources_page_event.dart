import 'package:file_picker/file_picker.dart';

abstract class SourcesPageEvent {
  const SourcesPageEvent();
}

class LoadSourcesEvent extends SourcesPageEvent {
  const LoadSourcesEvent();
}

class ImportDocumentsEvent extends SourcesPageEvent {
  final List<PlatformFile> files;
  const ImportDocumentsEvent(this.files);
}

class DeleteSourceEvent extends SourcesPageEvent {
  final String sourceId;
  const DeleteSourceEvent(this.sourceId);
}
