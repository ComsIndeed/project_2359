abstract class Source {
  final String id;
  final String label;
  final String? path;
  SourceType get type;
  final String? indexContent;

  Source({
    required this.id,
    required this.label,
    required this.path,
    required this.indexContent,
  });
}

enum SourceType { document, video, audio, image, text }

class DocumentSource extends Source {
  @override
  SourceType get type => SourceType.document;
  final String documentText;

  DocumentSource({
    required super.id,
    required super.label,
    required super.path,
    super.indexContent,
    required this.documentText,
  });
}

class VideoSource extends Source {
  @override
  SourceType get type => SourceType.video;
  final String videoTranscript;

  VideoSource({
    required super.id,
    required super.label,
    required super.path,
    super.indexContent,
    required this.videoTranscript,
  });
}

class AudioSource extends Source {
  @override
  SourceType get type => SourceType.audio;
  final String audioTranscript;

  AudioSource({
    required super.id,
    required super.label,
    required super.path,
    super.indexContent,
    required this.audioTranscript,
  });
}

class ImageSource extends Source {
  @override
  SourceType get type => SourceType.image;
  final String imageInterpretation;

  ImageSource({
    required super.id,
    required super.label,
    required super.path,
    super.indexContent,
    required this.imageInterpretation,
  });
}

class TextSource extends Source {
  @override
  SourceType get type => SourceType.text;
  final String textContent;

  TextSource({
    required super.id,
    required super.label,
    required super.path,
    super.indexContent,
    required this.textContent,
  });
}
