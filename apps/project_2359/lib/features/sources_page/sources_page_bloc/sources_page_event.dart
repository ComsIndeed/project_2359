abstract class SourcesPageEvent {
  const SourcesPageEvent();
}

class SourcesPageEventInitial extends SourcesPageEvent {
  const SourcesPageEventInitial();
}

class ImportDocumentSourcesPageEvent extends SourcesPageEvent {
  /// The path or URI to the file to import.
  /// Using String instead of File for web compatibility.
  final String filePath;
  const ImportDocumentSourcesPageEvent(this.filePath);
}
