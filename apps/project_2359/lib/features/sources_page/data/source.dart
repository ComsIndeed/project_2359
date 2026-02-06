import 'dart:convert';

abstract class Source {
  final String id;
  final String label;
  final String? path;
  SourceType get type;
  final String? indexContent;

  Source({required this.id, required this.label, this.path, this.indexContent});

  // Abstract serialization methods
  Map<String, dynamic> toMap();
  String toJson() => json.encode(toMap());

  // Abstract copyWith
  Source copyWith({
    String? id,
    String? label,
    String? path,
    String? indexContent,
  });

  // Factory constructor to create the correct subclass from a map
  static Source fromMap(Map<String, dynamic> map) {
    final typeString = map['type'] as String;
    final type = SourceType.values.firstWhere((e) => e.name == typeString);

    switch (type) {
      case SourceType.document:
        return DocumentSource.fromMap(map);
      case SourceType.video:
        return VideoSource.fromMap(map);
      case SourceType.audio:
        return AudioSource.fromMap(map);
      case SourceType.image:
        return ImageSource.fromMap(map);
      case SourceType.text:
        return TextSource.fromMap(map);
    }
  }

  // Factory constructor to create from JSON string
  static Source fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}

enum SourceType { document, video, audio, image, text }

class DocumentSource extends Source {
  @override
  SourceType get type => SourceType.document;
  final String documentText;

  DocumentSource({
    required super.id,
    required super.label,
    super.path,
    super.indexContent,
    required this.documentText,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'path': path,
      'indexContent': indexContent,
      'documentText': documentText,
    };
  }

  factory DocumentSource.fromMap(Map<String, dynamic> map) {
    return DocumentSource(
      id: map['id'] as String,
      label: map['label'] as String,
      path: map['path'] as String?,
      indexContent: map['indexContent'] as String?,
      documentText: map['documentText'] as String,
    );
  }

  factory DocumentSource.fromJson(String source) =>
      DocumentSource.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  DocumentSource copyWith({
    String? id,
    String? label,
    String? path,
    String? indexContent,
    String? documentText,
  }) {
    return DocumentSource(
      id: id ?? this.id,
      label: label ?? this.label,
      path: path ?? this.path,
      indexContent: indexContent ?? this.indexContent,
      documentText: documentText ?? this.documentText,
    );
  }
}

class VideoSource extends Source {
  @override
  SourceType get type => SourceType.video;
  final String videoTranscript;

  VideoSource({
    required super.id,
    required super.label,
    super.path,
    super.indexContent,
    required this.videoTranscript,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'path': path,
      'indexContent': indexContent,
      'videoTranscript': videoTranscript,
    };
  }

  factory VideoSource.fromMap(Map<String, dynamic> map) {
    return VideoSource(
      id: map['id'] as String,
      label: map['label'] as String,
      path: map['path'] as String?,
      indexContent: map['indexContent'] as String?,
      videoTranscript: map['videoTranscript'] as String,
    );
  }

  factory VideoSource.fromJson(String source) =>
      VideoSource.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  VideoSource copyWith({
    String? id,
    String? label,
    String? path,
    String? indexContent,
    String? videoTranscript,
  }) {
    return VideoSource(
      id: id ?? this.id,
      label: label ?? this.label,
      path: path ?? this.path,
      indexContent: indexContent ?? this.indexContent,
      videoTranscript: videoTranscript ?? this.videoTranscript,
    );
  }
}

class AudioSource extends Source {
  @override
  SourceType get type => SourceType.audio;
  final String audioTranscript;

  AudioSource({
    required super.id,
    required super.label,
    super.path,
    super.indexContent,
    required this.audioTranscript,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'path': path,
      'indexContent': indexContent,
      'audioTranscript': audioTranscript,
    };
  }

  factory AudioSource.fromMap(Map<String, dynamic> map) {
    return AudioSource(
      id: map['id'] as String,
      label: map['label'] as String,
      path: map['path'] as String?,
      indexContent: map['indexContent'] as String?,
      audioTranscript: map['audioTranscript'] as String,
    );
  }

  factory AudioSource.fromJson(String source) =>
      AudioSource.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  AudioSource copyWith({
    String? id,
    String? label,
    String? path,
    String? indexContent,
    String? audioTranscript,
  }) {
    return AudioSource(
      id: id ?? this.id,
      label: label ?? this.label,
      path: path ?? this.path,
      indexContent: indexContent ?? this.indexContent,
      audioTranscript: audioTranscript ?? this.audioTranscript,
    );
  }
}

class ImageSource extends Source {
  @override
  SourceType get type => SourceType.image;
  final String imageInterpretation;

  ImageSource({
    required super.id,
    required super.label,
    super.path,
    super.indexContent,
    required this.imageInterpretation,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'path': path,
      'indexContent': indexContent,
      'imageInterpretation': imageInterpretation,
    };
  }

  factory ImageSource.fromMap(Map<String, dynamic> map) {
    return ImageSource(
      id: map['id'] as String,
      label: map['label'] as String,
      path: map['path'] as String?,
      indexContent: map['indexContent'] as String?,
      imageInterpretation: map['imageInterpretation'] as String,
    );
  }

  factory ImageSource.fromJson(String source) =>
      ImageSource.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  ImageSource copyWith({
    String? id,
    String? label,
    String? path,
    String? indexContent,
    String? imageInterpretation,
  }) {
    return ImageSource(
      id: id ?? this.id,
      label: label ?? this.label,
      path: path ?? this.path,
      indexContent: indexContent ?? this.indexContent,
      imageInterpretation: imageInterpretation ?? this.imageInterpretation,
    );
  }
}

class TextSource extends Source {
  @override
  SourceType get type => SourceType.text;
  final String textContent;

  TextSource({
    required super.id,
    required super.label,
    super.path,
    super.indexContent,
    required this.textContent,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'path': path,
      'indexContent': indexContent,
      'textContent': textContent,
    };
  }

  factory TextSource.fromMap(Map<String, dynamic> map) {
    return TextSource(
      id: map['id'] as String,
      label: map['label'] as String,
      path: map['path'] as String?,
      indexContent: map['indexContent'] as String?,
      textContent: map['textContent'] as String,
    );
  }

  factory TextSource.fromJson(String source) =>
      TextSource.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  TextSource copyWith({
    String? id,
    String? label,
    String? path,
    String? indexContent,
    String? textContent,
  }) {
    return TextSource(
      id: id ?? this.id,
      label: label ?? this.label,
      path: path ?? this.path,
      indexContent: indexContent ?? this.indexContent,
      textContent: textContent ?? this.textContent,
    );
  }
}
