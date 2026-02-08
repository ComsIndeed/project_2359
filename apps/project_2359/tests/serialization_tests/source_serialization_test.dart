import 'package:flutter_test/flutter_test.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/sources_page/data/source_items.dart';

void main() {
  group('SourceItem Serialization', () {
    late SourceItem source;

    setUp(() {
      source = SourceItem(
        id: 'doc-123',
        label: 'Test Document',
        path: '/path/to/doc.pdf',
        type: SourceType.document.name,
        extractedContent: 'This is the document text content.',
      );
    });

    group('toJson', () {
      test('should convert to valid JSON', () {
        final jsonMap = source.toJson();
        expect(jsonMap['id'], equals('doc-123'));
        expect(jsonMap['type'], equals('document'));
        expect(jsonMap['label'], equals('Test Document'));
        expect(jsonMap['path'], equals('/path/to/doc.pdf'));
        expect(
          jsonMap['extractedContent'],
          equals('This is the document text content.'),
        );
      });

      test('should include correct source type name', () {
        final jsonMap = source.toJson();
        expect(jsonMap['type'], equals(SourceType.document.name));
      });

      test('should handle null path', () {
        final nullPathSource = SourceItem(
          id: 'doc-null',
          label: 'Null Path Doc',
          path: null,
          type: SourceType.document.name,
          extractedContent: 'content',
        );
        final jsonMap = nullPathSource.toJson();
        expect(jsonMap['path'], isNull);
      });

      test('should handle null extractedContent', () {
        final nullContentSource = SourceItem(
          id: 'doc-null-content',
          label: 'Null Content Doc',
          path: '/path',
          type: SourceType.document.name,
        );
        final jsonMap = nullContentSource.toJson();
        expect(jsonMap['extractedContent'], isNull);
      });
    });

    group('fromJson', () {
      test('should create instance from valid JSON map', () {
        final jsonMap = {
          'id': 'doc-456',
          'type': 'document',
          'label': 'Test Label',
          'path': '/some/path',
          'extractedContent': 'some text',
        };

        final result = SourceItem.fromJson(jsonMap);

        expect(result.id, equals('doc-456'));
        expect(result.label, equals('Test Label'));
        expect(result.path, equals('/some/path'));
        expect(result.type, equals('document'));
        expect(result.extractedContent, equals('some text'));
      });

      test('should handle null path and extractedContent', () {
        final jsonMap = {
          'id': 'doc-nulls',
          'type': 'document',
          'label': 'Test',
          'path': null,
          'extractedContent': null,
        };

        final result = SourceItem.fromJson(jsonMap);

        expect(result.path, isNull);
        expect(result.extractedContent, isNull);
      });
    });

    group('Round-trip serialization', () {
      test('should survive toJson -> fromJson round trip', () {
        final jsonMap = source.toJson();
        final restored = SourceItem.fromJson(jsonMap);

        expect(restored.id, equals(source.id));
        expect(restored.label, equals(source.label));
        expect(restored.path, equals(source.path));
        expect(restored.type, equals(source.type));
        expect(restored.extractedContent, equals(source.extractedContent));
      });
    });

    group('copyWith', () {
      test('should create copy with updated id', () {
        final copy = source.copyWith(id: 'new-id');

        expect(copy.id, equals('new-id'));
        expect(copy.label, equals(source.label));
        expect(copy.path, equals(source.path));
        expect(copy.extractedContent, equals(source.extractedContent));
      });

      test('should create copy with updated label', () {
        final copy = source.copyWith(label: 'New Label');

        expect(copy.id, equals(source.id));
        expect(copy.label, equals('New Label'));
      });

      test('should create identical copy when no parameters provided', () {
        final copy = source.copyWith();

        expect(copy.id, equals(source.id));
        expect(copy.label, equals(source.label));
        expect(copy.type, equals(source.type));
      });

      test('should preserve type in copy', () {
        final copy = source.copyWith(id: 'new-id');
        expect(copy.type, equals(SourceType.document.name));
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
      final special = SourceItem(
        id: 'special-chars',
        label: 'Quote: "Hello" & <tag>',
        path: '/path/with spaces/and émojis 🎉',
        type: SourceType.document.name,
        extractedContent: '你好世界\n\tNewlines and tabs',
      );

      final restored = SourceItem.fromJson(special.toJson());

      expect(restored.label, equals('Quote: "Hello" & <tag>'));
      expect(restored.path, equals('/path/with spaces/and émojis 🎉'));
      expect(restored.extractedContent, equals('你好世界\n\tNewlines and tabs'));
    });

    test('should handle very long content', () {
      final longContent = 'A' * 100000;
      final longSource = SourceItem(
        id: 'long',
        label: 'Long',
        path: null,
        type: SourceType.text.name,
        extractedContent: longContent,
      );

      final restored = SourceItem.fromJson(longSource.toJson());

      expect(restored.extractedContent, hasLength(100000));
    });

    test('should handle empty strings', () {
      final empty = SourceItem(
        id: '',
        label: '',
        path: '',
        type: SourceType.document.name,
        extractedContent: '',
      );

      final restored = SourceItem.fromJson(empty.toJson());

      expect(restored.id, equals(''));
      expect(restored.label, equals(''));
      expect(restored.path, equals(''));
      expect(restored.extractedContent, equals(''));
    });
  });
}
