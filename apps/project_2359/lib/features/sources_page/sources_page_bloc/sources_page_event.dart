import 'package:file_picker/file_picker.dart';

abstract class SourcesPageEvent {
  const SourcesPageEvent();
}

class SourcesPageEventInitial extends SourcesPageEvent {
  const SourcesPageEventInitial();
}

class ImportDocumentSourcesPageEvent extends SourcesPageEvent {
  final List<PlatformFile> files;

  const ImportDocumentSourcesPageEvent(this.files);
}
