import 'package:flutter_test/flutter_test.dart';
import 'package:project_2359/features/anki_import_page/services/anki_import_service.dart';

void main() {
  group('AnkiImportService — field splitting', () {
    test('splits fields on the \\x1f separator', () {
      const raw = 'Front text\x1fBack text\x1fExtra field';
      final fields = AnkiImportService.splitFields(raw);
      expect(fields, ['Front text', 'Back text', 'Extra field']);
    });

    test('handles single field (no separator)', () {
      final fields = AnkiImportService.splitFields('Only field');
      expect(fields, ['Only field']);
    });

    test('handles empty string', () {
      final fields = AnkiImportService.splitFields('');
      expect(fields, ['']); // split always returns at least one element
    });

    test('preserves empty fields in the middle', () {
      final fields = AnkiImportService.splitFields('A\x1f\x1fC');
      expect(fields, ['A', '', 'C']);
    });
  });

  group('AnkiImportService — due date decoding', () {
    test('decodes review card due date from crt + day offset', () {
      // crt = Unix epoch seconds for 2024-01-01 00:00:00 UTC
      final crt = DateTime.utc(2024, 1, 1).millisecondsSinceEpoch ~/ 1000;
      final due = AnkiImportService.decodeDueDate(crt, 10);
      final expected = DateTime.utc(2024, 1, 11);
      expect(due.year, expected.year);
      expect(due.month, expected.month);
      expect(due.day, expected.day);
    });

    test('due = 0 returns the crt date', () {
      final crt = DateTime.utc(2024, 6, 15).millisecondsSinceEpoch ~/ 1000;
      final due = AnkiImportService.decodeDueDate(crt, 0);
      expect(due.year, 2024);
      expect(due.month, 6);
      expect(due.day, 15);
    });
  });

  group('AnkiImportService — FSRS data parsing', () {
    test('parses stability and difficulty from valid JSON', () {
      final result =
          AnkiImportService.parseFsrsData('{"s": 12.5, "d": 6.2}');
      expect(result.stability, closeTo(12.5, 0.001));
      expect(result.difficulty, closeTo(6.2, 0.001));
    });

    test('returns null values for empty string', () {
      final result = AnkiImportService.parseFsrsData('');
      expect(result.stability, isNull);
      expect(result.difficulty, isNull);
    });

    test('returns null values for JSON missing keys', () {
      final result = AnkiImportService.parseFsrsData('{}');
      expect(result.stability, isNull);
      expect(result.difficulty, isNull);
    });

    test('returns null values for malformed JSON', () {
      final result = AnkiImportService.parseFsrsData('{broken json}');
      expect(result.stability, isNull);
      expect(result.difficulty, isNull);
    });

    test('handles integer values', () {
      final result =
          AnkiImportService.parseFsrsData('{"s": 5, "d": 3}');
      expect(result.stability, 5.0);
      expect(result.difficulty, 3.0);
    });
  });
}
