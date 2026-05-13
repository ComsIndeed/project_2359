import 'package:file_picker/file_picker.dart';

abstract class SourcesPageEvent {
  const SourcesPageEvent();
}

class LoadSourcesEvent extends SourcesPageEvent {
  final String? deckId;
  const LoadSourcesEvent({this.deckId});
}

class ImportDocumentsEvent extends SourcesPageEvent {
  final List<PlatformFile> files;
  final String? deckId;
  const ImportDocumentsEvent(this.files, {this.deckId});
}

class DeleteSourceEvent extends SourcesPageEvent {
  final String sourceId;
  const DeleteSourceEvent(this.sourceId);
}
