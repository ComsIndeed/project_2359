import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_2359/core/models/study_material.dart';

void main() {
  group('MultipleChoiceQuestionMaterial Serialization', () {
    late StudyMaterialMultipleChoiceQuestion material;

    setUp(() {
      material = StudyMaterialMultipleChoiceQuestion(
        id: 'mcq-123',
        question: 'What is 2 + 2?',
        options: ['3', '4', '5', '6'],
        answer: '4',
      );
    });

    group('toMap', () {
      test('should convert to map with all required fields', () {
        final map = material.toMap();

        expect(map['id'], equals('mcq-123'));
        expect(map['type'], equals('multipleChoiceQuestion'));
        expect(map['question'], equals('What is 2 + 2?'));
        expect(map['options'], equals(['3', '4', '5', '6']));
        expect(map['answer'], equals('4'));
      });

      test('should include correct material type name', () {
        final map = material.toMap();
        expect(
          map['type'],
          equals(StudyMaterialType.multipleChoiceQuestion.name),
        );
      });

      test('should preserve empty options list', () {
        final emptyOptionsMaterial = StudyMaterialMultipleChoiceQuestion(
          id: 'mcq-empty',
          question: 'Empty question',
          options: [],
          answer: '',
        );
        final map = emptyOptionsMaterial.toMap();
        expect(map['options'], isEmpty);
      });

      test('should handle special characters in strings', () {
        final specialMaterial = StudyMaterialMultipleChoiceQuestion(
          id: 'mcq-special',
          question: 'What is "quoted" & <tagged>?',
          options: ['Option with\nnewline', 'Option\twith\ttabs', 'émoji 🎉'],
          answer: 'émoji 🎉',
        );
        final map = specialMaterial.toMap();

        expect(map['question'], equals('What is "quoted" & <tagged>?'));
        expect(map['options'], contains('Option with\nnewline'));
        expect(map['options'], contains('émoji 🎉'));
      });

      test('should handle very long strings', () {
        final longString = 'A' * 10000;
        final longMaterial = StudyMaterialMultipleChoiceQuestion(
          id: 'mcq-long',
          question: longString,
          options: [longString],
          answer: longString,
        );
        final map = longMaterial.toMap();

        expect(map['question'], hasLength(10000));
      });
    });

    group('toJson', () {
      test('should convert to valid JSON string', () {
        final jsonString = material.toJson();

        expect(() => json.decode(jsonString), returnsNormally);
      });

      test('should be decodable back to map', () {
        final jsonString = material.toJson();
        final decoded = json.decode(jsonString) as Map<String, dynamic>;

        expect(decoded['id'], equals('mcq-123'));
        expect(decoded['type'], equals('multipleChoiceQuestion'));
      });
    });

    group('fromMap', () {
      test('should create instance from valid map', () {
        final map = {
          'id': 'mcq-456',
          'type': 'multipleChoiceQuestion',
          'question': 'Test question',
          'options': ['A', 'B', 'C'],
          'answer': 'B',
        };

        final result = StudyMaterialMultipleChoiceQuestion.fromMap(map);

        expect(result.id, equals('mcq-456'));
        expect(result.question, equals('Test question'));
        expect(result.options, equals(['A', 'B', 'C']));
        expect(result.answer, equals('B'));
      });

      test('should throw when id is missing', () {
        final map = {
          'type': 'multipleChoiceQuestion',
          'question': 'Test',
          'options': ['A'],
          'answer': 'A',
        };

        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw when question is missing', () {
        final map = {
          'id': 'mcq-test',
          'type': 'multipleChoiceQuestion',
          'options': ['A'],
          'answer': 'A',
        };

        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw when options is missing', () {
        final map = {
          'id': 'mcq-test',
          'type': 'multipleChoiceQuestion',
          'question': 'Test',
          'answer': 'A',
        };

        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw when answer is missing', () {
        final map = {
          'id': 'mcq-test',
          'type': 'multipleChoiceQuestion',
          'question': 'Test',
          'options': ['A'],
        };

        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw when id is wrong type', () {
        final map = {
          'id': 123, // Should be String
          'type': 'multipleChoiceQuestion',
          'question': 'Test',
          'options': ['A'],
          'answer': 'A',
        };

        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw when options is wrong type', () {
        final map = {
          'id': 'mcq-test',
          'type': 'multipleChoiceQuestion',
          'question': 'Test',
          'options': 'not a list', // Should be List
          'answer': 'A',
        };

        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });

      test('should handle options with non-string elements', () {
        final map = {
          'id': 'mcq-test',
          'type': 'multipleChoiceQuestion',
          'question': 'Test',
          'options': [1, 2, 3], // Integers instead of strings
          'answer': 'A',
        };

        // This should throw because we're casting to List<String>
        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('fromJson', () {
      test('should create instance from valid JSON string', () {
        final jsonString = '''
        {
          "id": "mcq-json",
          "type": "multipleChoiceQuestion",
          "question": "JSON test",
          "options": ["X", "Y", "Z"],
          "answer": "Y"
        }
        ''';

        final result = StudyMaterialMultipleChoiceQuestion.fromJson(jsonString);

        expect(result.id, equals('mcq-json'));
        expect(result.options, equals(['X', 'Y', 'Z']));
      });

      test('should throw on invalid JSON', () {
        const invalidJson = '{invalid json}';

        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromJson(invalidJson),
          throwsA(isA<FormatException>()),
        );
      });

      test('should throw on empty JSON', () {
        const emptyJson = '';

        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromJson(emptyJson),
          throwsA(isA<FormatException>()),
        );
      });

      test('should throw on JSON array instead of object', () {
        const jsonArray = '["a", "b", "c"]';

        expect(
          () => StudyMaterialMultipleChoiceQuestion.fromJson(jsonArray),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('Round-trip serialization', () {
      test('should survive toMap -> fromMap round trip', () {
        final map = material.toMap();
        final restored = StudyMaterialMultipleChoiceQuestion.fromMap(map);

        expect(restored.id, equals(material.id));
        expect(restored.question, equals(material.question));
        expect(restored.options, equals(material.options));
        expect(restored.answer, equals(material.answer));
        expect(restored.materialType, equals(material.materialType));
      });

      test('should survive toJson -> fromJson round trip', () {
        final jsonString = material.toJson();
        final restored = StudyMaterialMultipleChoiceQuestion.fromJson(
          jsonString,
        );

        expect(restored.id, equals(material.id));
        expect(restored.question, equals(material.question));
        expect(restored.options, equals(material.options));
        expect(restored.answer, equals(material.answer));
      });
    });
  });

  group('FreeTextQuestionMaterial Serialization', () {
    late StudyMaterialFreeTextQuestion material;

    setUp(() {
      material = StudyMaterialFreeTextQuestion(
        id: 'ftq-123',
        question: 'Explain photosynthesis.',
        answer: 'Process by which plants convert sunlight to energy.',
      );
    });

    group('toMap', () {
      test('should convert to map with all required fields', () {
        final map = material.toMap();

        expect(map['id'], equals('ftq-123'));
        expect(map['type'], equals('freeTextQuestion'));
        expect(map['question'], equals('Explain photosynthesis.'));
        expect(
          map['answer'],
          equals('Process by which plants convert sunlight to energy.'),
        );
      });

      test('should include correct material type name', () {
        final map = material.toMap();
        expect(map['type'], equals(StudyMaterialType.freeTextQuestion.name));
      });

      test('should handle empty strings', () {
        final emptyMaterial = StudyMaterialFreeTextQuestion(
          id: '',
          question: '',
          answer: '',
        );
        final map = emptyMaterial.toMap();

        expect(map['id'], equals(''));
        expect(map['question'], equals(''));
        expect(map['answer'], equals(''));
      });

      test('should handle multiline text', () {
        final multilineMaterial = StudyMaterialFreeTextQuestion(
          id: 'ftq-multiline',
          question: 'Line 1\nLine 2\nLine 3',
          answer: 'Answer line 1\nAnswer line 2',
        );
        final map = multilineMaterial.toMap();

        expect(map['question'], contains('\n'));
        expect(map['answer'], contains('\n'));
      });

      test('should handle unicode and special characters', () {
        final unicodeMaterial = StudyMaterialFreeTextQuestion(
          id: 'ftq-unicode',
          question: '你好世界 🌍 مرحبا',
          answer: 'Ñoño café résumé',
        );
        final map = unicodeMaterial.toMap();

        expect(map['question'], equals('你好世界 🌍 مرحبا'));
        expect(map['answer'], equals('Ñoño café résumé'));
      });
    });

    group('toJson', () {
      test('should convert to valid JSON string', () {
        final jsonString = material.toJson();

        expect(() => json.decode(jsonString), returnsNormally);
      });

      test('should properly escape special JSON characters', () {
        final specialMaterial = StudyMaterialFreeTextQuestion(
          id: 'ftq-escape',
          question: 'Quote: "Hello" and backslash: \\',
          answer: 'Tab:\t Newline:\n',
        );
        final jsonString = specialMaterial.toJson();

        expect(() => json.decode(jsonString), returnsNormally);
        final decoded = json.decode(jsonString) as Map<String, dynamic>;
        expect(decoded['question'], equals('Quote: "Hello" and backslash: \\'));
      });
    });

    group('fromMap', () {
      test('should create instance from valid map', () {
        final map = {
          'id': 'ftq-456',
          'type': 'freeTextQuestion',
          'question': 'Test question',
          'answer': 'Test answer',
        };

        final result = StudyMaterialFreeTextQuestion.fromMap(map);

        expect(result.id, equals('ftq-456'));
        expect(result.question, equals('Test question'));
        expect(result.answer, equals('Test answer'));
      });

      test('should throw when id is missing', () {
        final map = {
          'type': 'freeTextQuestion',
          'question': 'Test',
          'answer': 'Answer',
        };

        expect(
          () => StudyMaterialFreeTextQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw when question is missing', () {
        final map = {
          'id': 'ftq-test',
          'type': 'freeTextQuestion',
          'answer': 'Answer',
        };

        expect(
          () => StudyMaterialFreeTextQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw when answer is missing', () {
        final map = {
          'id': 'ftq-test',
          'type': 'freeTextQuestion',
          'question': 'Test',
        };

        expect(
          () => StudyMaterialFreeTextQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw when values are wrong type', () {
        final map = {
          'id': 123, // Should be String
          'type': 'freeTextQuestion',
          'question': true, // Should be String
          'answer': ['array'], // Should be String
        };

        expect(
          () => StudyMaterialFreeTextQuestion.fromMap(map),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('fromJson', () {
      test('should create instance from valid JSON string', () {
        final jsonString = '''
        {
          "id": "ftq-json",
          "type": "freeTextQuestion",
          "question": "JSON question",
          "answer": "JSON answer"
        }
        ''';

        final result = StudyMaterialFreeTextQuestion.fromJson(jsonString);

        expect(result.id, equals('ftq-json'));
        expect(result.question, equals('JSON question'));
        expect(result.answer, equals('JSON answer'));
      });

      test('should throw on invalid JSON', () {
        const invalidJson = 'not valid json at all';

        expect(
          () => StudyMaterialFreeTextQuestion.fromJson(invalidJson),
          throwsA(isA<FormatException>()),
        );
      });

      test('should throw on null JSON', () {
        const nullJson = 'null';

        expect(
          () => StudyMaterialFreeTextQuestion.fromJson(nullJson),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('Round-trip serialization', () {
      test('should survive toMap -> fromMap round trip', () {
        final map = material.toMap();
        final restored = StudyMaterialFreeTextQuestion.fromMap(map);

        expect(restored.id, equals(material.id));
        expect(restored.question, equals(material.question));
        expect(restored.answer, equals(material.answer));
        expect(restored.materialType, equals(material.materialType));
      });

      test('should survive toJson -> fromJson round trip', () {
        final jsonString = material.toJson();
        final restored = StudyMaterialFreeTextQuestion.fromJson(jsonString);

        expect(restored.id, equals(material.id));
        expect(restored.question, equals(material.question));
        expect(restored.answer, equals(material.answer));
      });
    });
  });

  group('StudyMaterial Polymorphic Serialization', () {
    group('fromMap polymorphic deserialization', () {
      test(
        'should create MultipleChoiceQuestionMaterial from map with correct type',
        () {
          final map = {
            'id': 'mcq-poly',
            'type': 'multipleChoiceQuestion',
            'question': 'Polymorphic question',
            'options': ['A', 'B'],
            'answer': 'A',
          };

          final result = StudyMaterial.fromMap(map);

          expect(result, isA<StudyMaterialMultipleChoiceQuestion>());
          expect(result.id, equals('mcq-poly'));
          expect(
            (result as StudyMaterialMultipleChoiceQuestion).options,
            equals(['A', 'B']),
          );
        },
      );

      test(
        'should create FreeTextQuestionMaterial from map with correct type',
        () {
          final map = {
            'id': 'ftq-poly',
            'type': 'freeTextQuestion',
            'question': 'Free text question',
            'answer': 'Free text answer',
          };

          final result = StudyMaterial.fromMap(map);

          expect(result, isA<StudyMaterialFreeTextQuestion>());
          expect(result.id, equals('ftq-poly'));
          expect(
            (result as StudyMaterialFreeTextQuestion).answer,
            equals('Free text answer'),
          );
        },
      );

      test('should throw UnimplementedError for imageOcclusion type', () {
        final map = {'id': 'io-test', 'type': 'imageOcclusion'};

        expect(
          () => StudyMaterial.fromMap(map),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('should throw when type field is missing', () {
        final map = {'id': 'no-type', 'question': 'Test', 'answer': 'Test'};

        expect(() => StudyMaterial.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when type field is invalid', () {
        final map = {
          'id': 'invalid-type',
          'type': 'invalidType',
          'question': 'Test',
          'answer': 'Test',
        };

        expect(
          () => StudyMaterial.fromMap(map),
          throwsA(
            isA<StateError>(),
          ), // firstWhere throws StateError when not found
        );
      });

      test('should throw when type field is null', () {
        final map = {
          'id': 'null-type',
          'type': null,
          'question': 'Test',
          'answer': 'Test',
        };

        expect(() => StudyMaterial.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when type field is wrong type', () {
        final map = {
          'id': 'wrong-type',
          'type': 123,
          'question': 'Test',
          'answer': 'Test',
        };

        expect(() => StudyMaterial.fromMap(map), throwsA(isA<TypeError>()));
      });
    });

    group('fromJson polymorphic deserialization', () {
      test('should create correct subclass from JSON', () {
        const mcqJson = '''
        {
          "id": "mcq-json-poly",
          "type": "multipleChoiceQuestion",
          "question": "JSON MCQ",
          "options": ["1", "2"],
          "answer": "1"
        }
        ''';

        const ftqJson = '''
        {
          "id": "ftq-json-poly",
          "type": "freeTextQuestion",
          "question": "JSON FTQ",
          "answer": "Answer"
        }
        ''';

        final mcqResult = StudyMaterial.fromJson(mcqJson);
        final ftqResult = StudyMaterial.fromJson(ftqJson);

        expect(mcqResult, isA<StudyMaterialMultipleChoiceQuestion>());
        expect(ftqResult, isA<StudyMaterialFreeTextQuestion>());
      });

      test('should throw on invalid JSON', () {
        const invalidJson = '{broken';

        expect(
          () => StudyMaterial.fromJson(invalidJson),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('Polymorphic round-trip', () {
      test('should preserve type through StudyMaterial.fromMap round trip', () {
        final mcq = StudyMaterialMultipleChoiceQuestion(
          id: 'mcq-roundtrip',
          question: 'Round trip MCQ',
          options: ['A', 'B', 'C'],
          answer: 'B',
        );

        final ftq = StudyMaterialFreeTextQuestion(
          id: 'ftq-roundtrip',
          question: 'Round trip FTQ',
          answer: 'Answer',
        );

        final mcqRestored = StudyMaterial.fromMap(mcq.toMap());
        final ftqRestored = StudyMaterial.fromMap(ftq.toMap());

        expect(mcqRestored, isA<StudyMaterialMultipleChoiceQuestion>());
        expect(ftqRestored, isA<StudyMaterialFreeTextQuestion>());
        expect(
          mcqRestored.materialType,
          equals(StudyMaterialType.multipleChoiceQuestion),
        );
        expect(
          ftqRestored.materialType,
          equals(StudyMaterialType.freeTextQuestion),
        );
      });

      test(
        'should preserve all data through StudyMaterial.fromJson round trip',
        () {
          final original = StudyMaterialMultipleChoiceQuestion(
            id: 'mcq-full-roundtrip',
            question: 'Full round trip test',
            options: ['Option 1', 'Option 2', 'Option 3'],
            answer: 'Option 2',
          );

          final restored = StudyMaterial.fromJson(original.toJson());

          expect(restored, isA<StudyMaterialMultipleChoiceQuestion>());
          final restoredMcq = restored as StudyMaterialMultipleChoiceQuestion;
          expect(restoredMcq.id, equals(original.id));
          expect(restoredMcq.question, equals(original.question));
          expect(restoredMcq.options, equals(original.options));
          expect(restoredMcq.answer, equals(original.answer));
        },
      );
    });
  });

  group('StudyMaterialType', () {
    test('should have correct enum values', () {
      expect(StudyMaterialType.values, hasLength(3));
      expect(
        StudyMaterialType.values,
        contains(StudyMaterialType.multipleChoiceQuestion),
      );
      expect(
        StudyMaterialType.values,
        contains(StudyMaterialType.freeTextQuestion),
      );
      expect(
        StudyMaterialType.values,
        contains(StudyMaterialType.imageOcclusion),
      );
    });

    test('should have correct name property', () {
      expect(
        StudyMaterialType.multipleChoiceQuestion.name,
        equals('multipleChoiceQuestion'),
      );
      expect(
        StudyMaterialType.freeTextQuestion.name,
        equals('freeTextQuestion'),
      );
      expect(StudyMaterialType.imageOcclusion.name, equals('imageOcclusion'));
    });
  });

  group('Edge Cases', () {
    test('should handle null values in map gracefully by throwing', () {
      final mapWithNulls = {
        'id': null,
        'type': 'multipleChoiceQuestion',
        'question': null,
        'options': null,
        'answer': null,
      };

      expect(
        () => StudyMaterialMultipleChoiceQuestion.fromMap(mapWithNulls),
        throwsA(isA<TypeError>()),
      );
    });

    test('should handle deeply nested JSON', () {
      // This tests that options with complex strings work
      final complexMaterial = StudyMaterialMultipleChoiceQuestion(
        id: 'complex',
        question: 'Question with {"nested": "json"}',
        options: ['{"a": 1}', '{"b": 2}', '{"c": [1,2,3]}'],
        answer: '{"a": 1}',
      );

      final jsonString = complexMaterial.toJson();
      final restored = StudyMaterialMultipleChoiceQuestion.fromJson(jsonString);

      expect(restored.question, equals('Question with {"nested": "json"}'));
      expect(restored.options, contains('{"a": 1}'));
    });

    test('should handle whitespace-only strings', () {
      final whitespaceMaterial = StudyMaterialFreeTextQuestion(
        id: '   ',
        question: '\t\n  ',
        answer: '   \n\t  ',
      );

      final restored = StudyMaterialFreeTextQuestion.fromJson(
        whitespaceMaterial.toJson(),
      );

      expect(restored.id, equals('   '));
      expect(restored.question, equals('\t\n  '));
    });

    test('should handle very large lists of options', () {
      final manyOptions = List.generate(1000, (i) => 'Option $i');
      final largeMaterial = StudyMaterialMultipleChoiceQuestion(
        id: 'large',
        question: 'Many options question',
        options: manyOptions,
        answer: 'Option 0',
      );

      final restored = StudyMaterialMultipleChoiceQuestion.fromJson(
        largeMaterial.toJson(),
      );

      expect(restored.options, hasLength(1000));
      expect(restored.options.first, equals('Option 0'));
      expect(restored.options.last, equals('Option 999'));
    });
  });
}
