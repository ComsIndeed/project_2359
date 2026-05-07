import 'package:file_picker/file_picker.dart';

abstract class SourcesPageEvent {
  const SourcesPageEvent();
}

class LoadSourcesEvent extends SourcesPageEvent {
  final String? collectionId;
  const LoadSourcesEvent({this.collectionId});
}

class ImportDocumentsEvent extends SourcesPageEvent {
  final List<PlatformFile> files;
  final String? collectionId;
  const ImportDocumentsEvent(this.files, {this.collectionId});
}

class DeleteSourceEvent extends SourcesPageEvent {
  final String sourceId;
  const DeleteSourceEvent(this.sourceId);
}
