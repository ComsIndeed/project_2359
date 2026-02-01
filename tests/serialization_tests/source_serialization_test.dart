import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_2359/core/models/source.dart';

void main() {
  group('DocumentSource Serialization', () {
    late DocumentSource source;

    setUp(() {
      source = DocumentSource(
        id: 'doc-123',
        label: 'Test Document',
        path: '/path/to/doc.pdf',
        indexContent: 'indexed content here',
        documentText: 'This is the document text content.',
      );
    });

    group('toMap', () {
      test('should convert to map with all required fields', () {
        final map = source.toMap();

        expect(map['id'], equals('doc-123'));
        expect(map['type'], equals('document'));
        expect(map['label'], equals('Test Document'));
        expect(map['path'], equals('/path/to/doc.pdf'));
        expect(map['indexContent'], equals('indexed content here'));
        expect(
          map['documentText'],
          equals('This is the document text content.'),
        );
      });

      test('should include correct source type name', () {
        final map = source.toMap();
        expect(map['type'], equals(SourceType.document.name));
      });

      test('should handle null path', () {
        final nullPathSource = DocumentSource(
          id: 'doc-null',
          label: 'Null Path Doc',
          path: null,
          documentText: 'content',
        );
        final map = nullPathSource.toMap();
        expect(map['path'], isNull);
      });

      test('should handle null indexContent', () {
        final nullIndexSource = DocumentSource(
          id: 'doc-null-index',
          label: 'Null Index Doc',
          path: '/path',
          documentText: 'content',
        );
        final map = nullIndexSource.toMap();
        expect(map['indexContent'], isNull);
      });
    });

    group('toJson', () {
      test('should convert to valid JSON string', () {
        final jsonString = source.toJson();
        expect(() => json.decode(jsonString), returnsNormally);
      });

      test('should be decodable back to map', () {
        final jsonString = source.toJson();
        final decoded = json.decode(jsonString) as Map<String, dynamic>;

        expect(decoded['id'], equals('doc-123'));
        expect(decoded['type'], equals('document'));
      });
    });

    group('fromMap', () {
      test('should create instance from valid map', () {
        final map = {
          'id': 'doc-456',
          'type': 'document',
          'label': 'Test Label',
          'path': '/some/path',
          'indexContent': 'some index',
          'documentText': 'some text',
        };

        final result = DocumentSource.fromMap(map);

        expect(result.id, equals('doc-456'));
        expect(result.label, equals('Test Label'));
        expect(result.path, equals('/some/path'));
        expect(result.indexContent, equals('some index'));
        expect(result.documentText, equals('some text'));
      });

      test('should handle null path and indexContent', () {
        final map = {
          'id': 'doc-nulls',
          'type': 'document',
          'label': 'Test',
          'path': null,
          'indexContent': null,
          'documentText': 'text',
        };

        final result = DocumentSource.fromMap(map);

        expect(result.path, isNull);
        expect(result.indexContent, isNull);
      });

      test('should throw when id is missing', () {
        final map = {
          'type': 'document',
          'label': 'Test',
          'documentText': 'text',
        };

        expect(() => DocumentSource.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when label is missing', () {
        final map = {
          'id': 'doc-test',
          'type': 'document',
          'documentText': 'text',
        };

        expect(() => DocumentSource.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when documentText is missing', () {
        final map = {'id': 'doc-test', 'type': 'document', 'label': 'Test'};

        expect(() => DocumentSource.fromMap(map), throwsA(isA<TypeError>()));
      });
    });

    group('fromJson', () {
      test('should create instance from valid JSON string', () {
        final jsonString = '''
        {
          "id": "doc-json",
          "type": "document",
          "label": "JSON Doc",
          "path": "/json/path",
          "indexContent": "json index",
          "documentText": "json text"
        }
        ''';

        final result = DocumentSource.fromJson(jsonString);

        expect(result.id, equals('doc-json'));
        expect(result.label, equals('JSON Doc'));
      });

      test('should throw on invalid JSON', () {
        const invalidJson = '{invalid json}';
        expect(
          () => DocumentSource.fromJson(invalidJson),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('Round-trip serialization', () {
      test('should survive toMap -> fromMap round trip', () {
        final map = source.toMap();
        final restored = DocumentSource.fromMap(map);

        expect(restored.id, equals(source.id));
        expect(restored.label, equals(source.label));
        expect(restored.path, equals(source.path));
        expect(restored.indexContent, equals(source.indexContent));
        expect(restored.documentText, equals(source.documentText));
        expect(restored.type, equals(source.type));
      });

      test('should survive toJson -> fromJson round trip', () {
        final jsonString = source.toJson();
        final restored = DocumentSource.fromJson(jsonString);

        expect(restored.id, equals(source.id));
        expect(restored.label, equals(source.label));
        expect(restored.documentText, equals(source.documentText));
      });
    });

    group('copyWith', () {
      test('should create copy with updated id', () {
        final copy = source.copyWith(id: 'new-id');

        expect(copy.id, equals('new-id'));
        expect(copy.label, equals(source.label));
        expect(copy.path, equals(source.path));
        expect(copy.documentText, equals(source.documentText));
      });

      test('should create copy with updated label', () {
        final copy = source.copyWith(label: 'New Label');

        expect(copy.id, equals(source.id));
        expect(copy.label, equals('New Label'));
      });

      test('should create copy with updated documentText', () {
        final copy = source.copyWith(documentText: 'New text');

        expect(copy.documentText, equals('New text'));
      });

      test('should create identical copy when no parameters provided', () {
        final copy = source.copyWith();

        expect(copy.id, equals(source.id));
        expect(copy.label, equals(source.label));
        expect(copy.path, equals(source.path));
        expect(copy.indexContent, equals(source.indexContent));
        expect(copy.documentText, equals(source.documentText));
        expect(copy.type, equals(source.type));
      });

      test('should preserve type in copy', () {
        final copy = source.copyWith(id: 'new-id');
        expect(copy.type, equals(SourceType.document));
      });
    });
  });

  group('VideoSource Serialization', () {
    late VideoSource source;

    setUp(() {
      source = VideoSource(
        id: 'vid-123',
        label: 'Test Video',
        path: '/path/to/video.mp4',
        indexContent: 'video index',
        videoTranscript: 'This is the video transcript.',
      );
    });

    group('toMap', () {
      test('should convert to map with all required fields', () {
        final map = source.toMap();

        expect(map['id'], equals('vid-123'));
        expect(map['type'], equals('video'));
        expect(map['label'], equals('Test Video'));
        expect(map['videoTranscript'], equals('This is the video transcript.'));
      });
    });

    group('fromMap', () {
      test('should create instance from valid map', () {
        final map = {
          'id': 'vid-456',
          'type': 'video',
          'label': 'Test',
          'path': '/path',
          'indexContent': null,
          'videoTranscript': 'transcript',
        };

        final result = VideoSource.fromMap(map);

        expect(result.id, equals('vid-456'));
        expect(result.videoTranscript, equals('transcript'));
        expect(result.type, equals(SourceType.video));
      });
    });

    group('Round-trip serialization', () {
      test('should survive toJson -> fromJson round trip', () {
        final jsonString = source.toJson();
        final restored = VideoSource.fromJson(jsonString);

        expect(restored.id, equals(source.id));
        expect(restored.videoTranscript, equals(source.videoTranscript));
      });
    });

    group('copyWith', () {
      test('should create copy with updated videoTranscript', () {
        final copy = source.copyWith(videoTranscript: 'New transcript');
        expect(copy.videoTranscript, equals('New transcript'));
        expect(copy.type, equals(SourceType.video));
      });
    });
  });

  group('AudioSource Serialization', () {
    late AudioSource source;

    setUp(() {
      source = AudioSource(
        id: 'aud-123',
        label: 'Test Audio',
        path: '/path/to/audio.mp3',
        indexContent: 'audio index',
        audioTranscript: 'This is the audio transcript.',
      );
    });

    group('toMap', () {
      test('should convert to map with all required fields', () {
        final map = source.toMap();

        expect(map['id'], equals('aud-123'));
        expect(map['type'], equals('audio'));
        expect(map['audioTranscript'], equals('This is the audio transcript.'));
      });
    });

    group('fromMap', () {
      test('should create instance from valid map', () {
        final map = {
          'id': 'aud-456',
          'type': 'audio',
          'label': 'Test',
          'path': '/path',
          'indexContent': null,
          'audioTranscript': 'transcript',
        };

        final result = AudioSource.fromMap(map);

        expect(result.id, equals('aud-456'));
        expect(result.audioTranscript, equals('transcript'));
        expect(result.type, equals(SourceType.audio));
      });
    });

    group('Round-trip serialization', () {
      test('should survive toJson -> fromJson round trip', () {
        final jsonString = source.toJson();
        final restored = AudioSource.fromJson(jsonString);

        expect(restored.id, equals(source.id));
        expect(restored.audioTranscript, equals(source.audioTranscript));
      });
    });

    group('copyWith', () {
      test('should create copy with updated audioTranscript', () {
        final copy = source.copyWith(audioTranscript: 'New transcript');
        expect(copy.audioTranscript, equals('New transcript'));
        expect(copy.type, equals(SourceType.audio));
      });
    });
  });

  group('ImageSource Serialization', () {
    late ImageSource source;

    setUp(() {
      source = ImageSource(
        id: 'img-123',
        label: 'Test Image',
        path: '/path/to/image.png',
        indexContent: 'image index',
        imageInterpretation: 'This is an image of a cat.',
      );
    });

    group('toMap', () {
      test('should convert to map with all required fields', () {
        final map = source.toMap();

        expect(map['id'], equals('img-123'));
        expect(map['type'], equals('image'));
        expect(
          map['imageInterpretation'],
          equals('This is an image of a cat.'),
        );
      });
    });

    group('fromMap', () {
      test('should create instance from valid map', () {
        final map = {
          'id': 'img-456',
          'type': 'image',
          'label': 'Test',
          'path': '/path',
          'indexContent': null,
          'imageInterpretation': 'interpretation',
        };

        final result = ImageSource.fromMap(map);

        expect(result.id, equals('img-456'));
        expect(result.imageInterpretation, equals('interpretation'));
        expect(result.type, equals(SourceType.image));
      });
    });

    group('Round-trip serialization', () {
      test('should survive toJson -> fromJson round trip', () {
        final jsonString = source.toJson();
        final restored = ImageSource.fromJson(jsonString);

        expect(restored.id, equals(source.id));
        expect(
          restored.imageInterpretation,
          equals(source.imageInterpretation),
        );
      });
    });

    group('copyWith', () {
      test('should create copy with updated imageInterpretation', () {
        final copy = source.copyWith(imageInterpretation: 'New interpretation');
        expect(copy.imageInterpretation, equals('New interpretation'));
        expect(copy.type, equals(SourceType.image));
      });
    });
  });

  group('TextSource Serialization', () {
    late TextSource source;

    setUp(() {
      source = TextSource(
        id: 'txt-123',
        label: 'Test Text',
        path: null,
        indexContent: 'text index',
        textContent: 'This is the raw text content.',
      );
    });

    group('toMap', () {
      test('should convert to map with all required fields', () {
        final map = source.toMap();

        expect(map['id'], equals('txt-123'));
        expect(map['type'], equals('text'));
        expect(map['textContent'], equals('This is the raw text content.'));
      });
    });

    group('fromMap', () {
      test('should create instance from valid map', () {
        final map = {
          'id': 'txt-456',
          'type': 'text',
          'label': 'Test',
          'path': null,
          'indexContent': null,
          'textContent': 'content',
        };

        final result = TextSource.fromMap(map);

        expect(result.id, equals('txt-456'));
        expect(result.textContent, equals('content'));
        expect(result.type, equals(SourceType.text));
      });
    });

    group('Round-trip serialization', () {
      test('should survive toJson -> fromJson round trip', () {
        final jsonString = source.toJson();
        final restored = TextSource.fromJson(jsonString);

        expect(restored.id, equals(source.id));
        expect(restored.textContent, equals(source.textContent));
      });
    });

    group('copyWith', () {
      test('should create copy with updated textContent', () {
        final copy = source.copyWith(textContent: 'New content');
        expect(copy.textContent, equals('New content'));
        expect(copy.type, equals(SourceType.text));
      });
    });
  });

  group('Source Polymorphic Serialization', () {
    group('fromMap polymorphic deserialization', () {
      test('should create DocumentSource from map with document type', () {
        final map = {
          'id': 'doc-poly',
          'type': 'document',
          'label': 'Doc',
          'path': '/path',
          'indexContent': null,
          'documentText': 'text',
        };

        final result = Source.fromMap(map);

        expect(result, isA<DocumentSource>());
        expect(result.id, equals('doc-poly'));
        expect(result.type, equals(SourceType.document));
      });

      test('should create VideoSource from map with video type', () {
        final map = {
          'id': 'vid-poly',
          'type': 'video',
          'label': 'Vid',
          'path': '/path',
          'indexContent': null,
          'videoTranscript': 'transcript',
        };

        final result = Source.fromMap(map);

        expect(result, isA<VideoSource>());
        expect(result.type, equals(SourceType.video));
      });

      test('should create AudioSource from map with audio type', () {
        final map = {
          'id': 'aud-poly',
          'type': 'audio',
          'label': 'Aud',
          'path': '/path',
          'indexContent': null,
          'audioTranscript': 'transcript',
        };

        final result = Source.fromMap(map);

        expect(result, isA<AudioSource>());
        expect(result.type, equals(SourceType.audio));
      });

      test('should create ImageSource from map with image type', () {
        final map = {
          'id': 'img-poly',
          'type': 'image',
          'label': 'Img',
          'path': '/path',
          'indexContent': null,
          'imageInterpretation': 'interpretation',
        };

        final result = Source.fromMap(map);

        expect(result, isA<ImageSource>());
        expect(result.type, equals(SourceType.image));
      });

      test('should create TextSource from map with text type', () {
        final map = {
          'id': 'txt-poly',
          'type': 'text',
          'label': 'Txt',
          'path': null,
          'indexContent': null,
          'textContent': 'content',
        };

        final result = Source.fromMap(map);

        expect(result, isA<TextSource>());
        expect(result.type, equals(SourceType.text));
      });

      test('should throw when type field is missing', () {
        final map = {'id': 'no-type', 'label': 'Test'};

        expect(() => Source.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when type field is invalid', () {
        final map = {
          'id': 'invalid-type',
          'type': 'invalidType',
          'label': 'Test',
        };

        expect(() => Source.fromMap(map), throwsA(isA<StateError>()));
      });
    });

    group('fromJson polymorphic deserialization', () {
      test('should create correct subclass from JSON', () {
        const docJson = '''
        {
          "id": "doc-json-poly",
          "type": "document",
          "label": "Doc",
          "path": "/path",
          "indexContent": null,
          "documentText": "text"
        }
        ''';

        const vidJson = '''
        {
          "id": "vid-json-poly",
          "type": "video",
          "label": "Vid",
          "path": "/path",
          "indexContent": null,
          "videoTranscript": "transcript"
        }
        ''';

        final docResult = Source.fromJson(docJson);
        final vidResult = Source.fromJson(vidJson);

        expect(docResult, isA<DocumentSource>());
        expect(vidResult, isA<VideoSource>());
      });

      test('should throw on invalid JSON', () {
        const invalidJson = '{broken';

        expect(
          () => Source.fromJson(invalidJson),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('Polymorphic round-trip', () {
      test('should preserve type through Source.fromMap round trip', () {
        final doc = DocumentSource(
          id: 'doc-roundtrip',
          label: 'Doc',
          path: '/path',
          documentText: 'text',
        );

        final vid = VideoSource(
          id: 'vid-roundtrip',
          label: 'Vid',
          path: '/path',
          videoTranscript: 'transcript',
        );

        final docRestored = Source.fromMap(doc.toMap());
        final vidRestored = Source.fromMap(vid.toMap());

        expect(docRestored, isA<DocumentSource>());
        expect(vidRestored, isA<VideoSource>());
        expect(docRestored.type, equals(SourceType.document));
        expect(vidRestored.type, equals(SourceType.video));
      });

      test('should preserve all data through Source.fromJson round trip', () {
        final original = DocumentSource(
          id: 'doc-full-roundtrip',
          label: 'Full Test',
          path: '/full/path',
          indexContent: 'full index',
          documentText: 'full text',
        );

        final restored = Source.fromJson(original.toJson());

        expect(restored, isA<DocumentSource>());
        final restoredDoc = restored as DocumentSource;
        expect(restoredDoc.id, equals(original.id));
        expect(restoredDoc.label, equals(original.label));
        expect(restoredDoc.path, equals(original.path));
        expect(restoredDoc.indexContent, equals(original.indexContent));
        expect(restoredDoc.documentText, equals(original.documentText));
      });
    });
  });

  group('SourceType', () {
    test('should have correct enum values', () {
      expect(SourceType.values, hasLength(5));
      expect(SourceType.values, contains(SourceType.document));
      expect(SourceType.values, contains(SourceType.video));
      expect(SourceType.values, contains(SourceType.audio));
      expect(SourceType.values, contains(SourceType.image));
      expect(SourceType.values, contains(SourceType.text));
    });

    test('should have correct name property', () {
      expect(SourceType.document.name, equals('document'));
      expect(SourceType.video.name, equals('video'));
      expect(SourceType.audio.name, equals('audio'));
      expect(SourceType.image.name, equals('image'));
      expect(SourceType.text.name, equals('text'));
    });
  });

  group('Edge Cases', () {
    test('should handle special characters in strings', () {
      final special = DocumentSource(
        id: 'special-chars',
        label: 'Quote: "Hello" & <tag>',
        path: '/path/with spaces/and émojis 🎉',
        documentText: '你好世界\n\tNewlines and tabs',
      );

      final restored = DocumentSource.fromJson(special.toJson());

      expect(restored.label, equals('Quote: "Hello" & <tag>'));
      expect(restored.path, equals('/path/with spaces/and émojis 🎉'));
      expect(restored.documentText, equals('你好世界\n\tNewlines and tabs'));
    });

    test('should handle very long content', () {
      final longContent = 'A' * 100000;
      final longSource = TextSource(
        id: 'long',
        label: 'Long',
        path: null,
        textContent: longContent,
      );

      final restored = TextSource.fromJson(longSource.toJson());

      expect(restored.textContent, hasLength(100000));
    });

    test('should handle empty strings', () {
      final empty = DocumentSource(
        id: '',
        label: '',
        path: '',
        documentText: '',
      );

      final restored = DocumentSource.fromJson(empty.toJson());

      expect(restored.id, equals(''));
      expect(restored.label, equals(''));
      expect(restored.path, equals(''));
      expect(restored.documentText, equals(''));
    });
  });
}
