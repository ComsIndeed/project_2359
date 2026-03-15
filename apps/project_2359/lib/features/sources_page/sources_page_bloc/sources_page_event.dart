import 'package:file_picker/file_picker.dart';

abstract class SourcesPageEvent {
  const SourcesPageEvent();
}

class LoadSourcesEvent extends SourcesPageEvent {
  final String? folderId;
  const LoadSourcesEvent({this.folderId});
}

class ImportDocumentsEvent extends SourcesPageEvent {
  final List<PlatformFile> files;
  final String? folderId;
  const ImportDocumentsEvent(this.files, {this.folderId});
}

class DeleteSourceEvent extends SourcesPageEvent {
  final String sourceId;
  const DeleteSourceEvent(this.sourceId);
}
