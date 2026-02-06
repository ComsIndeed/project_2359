import 'dart:io';

abstract class SourcesPageEvent {
  const SourcesPageEvent();
}

class SourcesPageEventInitial extends SourcesPageEvent {
  const SourcesPageEventInitial();
}

class UploadDocumentSourcesPageEvent extends SourcesPageEvent {
  final File file;
  const UploadDocumentSourcesPageEvent(this.file);
}
