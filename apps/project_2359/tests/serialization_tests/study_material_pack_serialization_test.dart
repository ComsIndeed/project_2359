import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_2359/core/models/study_material.dart';
import 'package:project_2359/core/models/study_material_pack.dart';

void main() {
  group('StudyMaterialPack Serialization', () {
    late StudyMaterialPack pack;
    late List<StudyMaterial> materials;

    setUp(() {
      materials = [
        StudyMaterialMultipleChoiceQuestion(
          id: 'mcq-1',
          question: 'What is 2+2?',
          options: ['3', '4', '5'],
          answer: '4',
        ),
        StudyMaterialFreeTextQuestion(
          id: 'ftq-1',
          question: 'Explain photosynthesis',
          answer: 'Process of converting sunlight to energy',
        ),
        StudyMaterialMultipleChoiceQuestion(
          id: 'mcq-2',
          question: 'Capital of France?',
          options: ['London', 'Paris', 'Berlin'],
          answer: 'Paris',
        ),
      ];

      pack = StudyMaterialPack(
        id: 'pack-123',
        name: 'Biology Basics',
        description: 'Introduction to biology concepts',
        studyMaterials: materials,
      );
    });

    group('toMap', () {
      test('should convert to map with all required fields', () {
        final map = pack.toMap();

        expect(map['id'], equals('pack-123'));
        expect(map['name'], equals('Biology Basics'));
        expect(map['description'], equals('Introduction to biology concepts'));
        expect(map['studyMaterials'], isA<List>());
        expect(map['studyMaterials'], hasLength(3));
      });

      test('should serialize nested StudyMaterial items correctly', () {
        final map = pack.toMap();
        final materialsMap = map['studyMaterials'] as List;

        expect(materialsMap[0]['type'], equals('multipleChoiceQuestion'));
        expect(materialsMap[0]['question'], equals('What is 2+2?'));
        expect(materialsMap[1]['type'], equals('freeTextQuestion'));
        expect(materialsMap[1]['question'], equals('Explain photosynthesis'));
        expect(materialsMap[2]['type'], equals('multipleChoiceQuestion'));
      });

      test('should handle null description', () {
        final packNoDesc = StudyMaterialPack(
          id: 'pack-null',
          name: 'No Description',
          description: null,
          studyMaterials: [],
        );

        final map = packNoDesc.toMap();

        expect(map['description'], isNull);
      });

      test('should handle empty studyMaterials list', () {
        final emptyPack = StudyMaterialPack(
          id: 'pack-empty',
          name: 'Empty Pack',
          description: 'No materials',
          studyMaterials: [],
        );

        final map = emptyPack.toMap();

        expect(map['studyMaterials'], isEmpty);
      });

      test('should preserve order of studyMaterials', () {
        final map = pack.toMap();
        final materialsMap = map['studyMaterials'] as List;

        expect(materialsMap[0]['id'], equals('mcq-1'));
        expect(materialsMap[1]['id'], equals('ftq-1'));
        expect(materialsMap[2]['id'], equals('mcq-2'));
      });

      test('should handle special characters in name and description', () {
        final specialPack = StudyMaterialPack(
          id: 'special',
          name: 'Quote: "Test" & <tag>',
          description: 'Émojis 🎉 and\nnewlines',
          studyMaterials: [],
        );

        final map = specialPack.toMap();

        expect(map['name'], equals('Quote: "Test" & <tag>'));
        expect(map['description'], equals('Émojis 🎉 and\nnewlines'));
      });
    });

    group('toJson', () {
      test('should convert to valid JSON string', () {
        final jsonString = pack.toJson();

        expect(() => json.decode(jsonString), returnsNormally);
      });

      test('should be decodable back to map', () {
        final jsonString = pack.toJson();
        final decoded = json.decode(jsonString) as Map<String, dynamic>;

        expect(decoded['id'], equals('pack-123'));
        expect(decoded['name'], equals('Biology Basics'));
        expect(decoded['studyMaterials'], isA<List>());
      });

      test('should properly encode nested objects', () {
        final jsonString = pack.toJson();
        final decoded = json.decode(jsonString) as Map<String, dynamic>;
        final materials = decoded['studyMaterials'] as List;

        expect(materials[0], isA<Map>());
        expect(materials[0]['type'], equals('multipleChoiceQuestion'));
        expect(materials[0]['options'], isA<List>());
      });
    });

    group('fromMap', () {
      test('should create instance from valid map', () {
        final map = {
          'id': 'pack-456',
          'name': 'Test Pack',
          'description': 'Test Description',
          'studyMaterials': [
            {
              'id': 'mcq-test',
              'type': 'multipleChoiceQuestion',
              'question': 'Test Q',
              'options': ['A', 'B'],
              'answer': 'A',
            },
            {
              'id': 'ftq-test',
              'type': 'freeTextQuestion',
              'question': 'Free Q',
              'answer': 'Free A',
            },
          ],
        };

        final result = StudyMaterialPack.fromMap(map);

        expect(result.id, equals('pack-456'));
        expect(result.name, equals('Test Pack'));
        expect(result.description, equals('Test Description'));
        expect(result.studyMaterials, hasLength(2));
        expect(
          result.studyMaterials[0],
          isA<StudyMaterialMultipleChoiceQuestion>(),
        );
        expect(result.studyMaterials[1], isA<StudyMaterialFreeTextQuestion>());
      });

      test('should correctly deserialize polymorphic StudyMaterial types', () {
        final map = pack.toMap();
        final result = StudyMaterialPack.fromMap(map);

        expect(
          result.studyMaterials[0],
          isA<StudyMaterialMultipleChoiceQuestion>(),
        );
        expect(result.studyMaterials[1], isA<StudyMaterialFreeTextQuestion>());
        expect(
          result.studyMaterials[2],
          isA<StudyMaterialMultipleChoiceQuestion>(),
        );

        final mcq =
            result.studyMaterials[0] as StudyMaterialMultipleChoiceQuestion;
        expect(mcq.question, equals('What is 2+2?'));
        expect(mcq.options, equals(['3', '4', '5']));
      });

      test('should handle null description', () {
        final map = {
          'id': 'pack-null',
          'name': 'Test',
          'description': null,
          'studyMaterials': [],
        };

        final result = StudyMaterialPack.fromMap(map);

        expect(result.description, isNull);
      });

      test('should handle empty studyMaterials list', () {
        final map = {
          'id': 'pack-empty',
          'name': 'Empty',
          'description': 'Empty pack',
          'studyMaterials': [],
        };

        final result = StudyMaterialPack.fromMap(map);

        expect(result.studyMaterials, isEmpty);
      });

      test('should throw when id is missing', () {
        final map = {'name': 'Test', 'studyMaterials': []};

        expect(() => StudyMaterialPack.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when name is missing', () {
        final map = {'id': 'pack-test', 'studyMaterials': []};

        expect(() => StudyMaterialPack.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when studyMaterials is missing', () {
        final map = {'id': 'pack-test', 'name': 'Test'};

        expect(() => StudyMaterialPack.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when id is wrong type', () {
        final map = {'id': 123, 'name': 'Test', 'studyMaterials': []};

        expect(() => StudyMaterialPack.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when studyMaterials is wrong type', () {
        final map = {
          'id': 'pack-test',
          'name': 'Test',
          'studyMaterials': 'not a list',
        };

        expect(() => StudyMaterialPack.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should throw when studyMaterials contains invalid items', () {
        final map = {
          'id': 'pack-test',
          'name': 'Test',
          'studyMaterials': [
            {'id': 'invalid', 'type': 'invalidType', 'question': 'Test'},
          ],
        };

        expect(
          () => StudyMaterialPack.fromMap(map),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('fromJson', () {
      test('should create instance from valid JSON string', () {
        final jsonString = '''
        {
          "id": "pack-json",
          "name": "JSON Pack",
          "description": "From JSON",
          "studyMaterials": [
            {
              "id": "mcq-json",
              "type": "multipleChoiceQuestion",
              "question": "JSON Q",
              "options": ["A", "B", "C"],
              "answer": "B"
            }
          ]
        }
        ''';

        final result = StudyMaterialPack.fromJson(jsonString);

        expect(result.id, equals('pack-json'));
        expect(result.name, equals('JSON Pack'));
        expect(result.studyMaterials, hasLength(1));
        expect(
          result.studyMaterials[0],
          isA<StudyMaterialMultipleChoiceQuestion>(),
        );
      });

      test('should throw on invalid JSON', () {
        const invalidJson = '{invalid json}';

        expect(
          () => StudyMaterialPack.fromJson(invalidJson),
          throwsA(isA<FormatException>()),
        );
      });

      test('should throw on empty JSON', () {
        const emptyJson = '';

        expect(
          () => StudyMaterialPack.fromJson(emptyJson),
          throwsA(isA<FormatException>()),
        );
      });

      test('should throw on JSON array instead of object', () {
        const jsonArray = '["a", "b", "c"]';

        expect(
          () => StudyMaterialPack.fromJson(jsonArray),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('Round-trip serialization', () {
      test('should survive toMap -> fromMap round trip', () {
        final map = pack.toMap();
        final restored = StudyMaterialPack.fromMap(map);

        expect(restored.id, equals(pack.id));
        expect(restored.name, equals(pack.name));
        expect(restored.description, equals(pack.description));
        expect(restored.studyMaterials, hasLength(pack.studyMaterials.length));

        for (var i = 0; i < restored.studyMaterials.length; i++) {
          expect(
            restored.studyMaterials[i].id,
            equals(pack.studyMaterials[i].id),
          );
          expect(
            restored.studyMaterials[i].materialType,
            equals(pack.studyMaterials[i].materialType),
          );
        }
      });

      test('should survive toJson -> fromJson round trip', () {
        final jsonString = pack.toJson();
        final restored = StudyMaterialPack.fromJson(jsonString);

        expect(restored.id, equals(pack.id));
        expect(restored.name, equals(pack.name));
        expect(restored.description, equals(pack.description));
        expect(restored.studyMaterials, hasLength(3));

        final mcq1 =
            restored.studyMaterials[0] as StudyMaterialMultipleChoiceQuestion;
        expect(mcq1.question, equals('What is 2+2?'));
        expect(mcq1.answer, equals('4'));

        final ftq = restored.studyMaterials[1] as StudyMaterialFreeTextQuestion;
        expect(ftq.question, equals('Explain photosynthesis'));
      });

      test('should preserve all nested data through round trip', () {
        final original = StudyMaterialPack(
          id: 'full-test',
          name: 'Full Test Pack',
          description: 'Complete test',
          studyMaterials: [
            StudyMaterialMultipleChoiceQuestion(
              id: 'mcq-full',
              question: 'Full question?',
              options: ['Option A', 'Option B', 'Option C'],
              answer: 'Option B',
            ),
          ],
        );

        final restored = StudyMaterialPack.fromJson(original.toJson());

        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.description, equals(original.description));

        final restoredMcq =
            restored.studyMaterials[0] as StudyMaterialMultipleChoiceQuestion;
        final originalMcq =
            original.studyMaterials[0] as StudyMaterialMultipleChoiceQuestion;

        expect(restoredMcq.id, equals(originalMcq.id));
        expect(restoredMcq.question, equals(originalMcq.question));
        expect(restoredMcq.options, equals(originalMcq.options));
        expect(restoredMcq.answer, equals(originalMcq.answer));
      });
    });

    group('copyWith', () {
      test('should create copy with updated id', () {
        final copy = pack.copyWith(id: 'new-id');

        expect(copy.id, equals('new-id'));
        expect(copy.name, equals(pack.name));
        expect(copy.description, equals(pack.description));
        expect(copy.studyMaterials, equals(pack.studyMaterials));
      });

      test('should create copy with updated name', () {
        final copy = pack.copyWith(name: 'New Name');

        expect(copy.id, equals(pack.id));
        expect(copy.name, equals('New Name'));
        expect(copy.description, equals(pack.description));
        expect(copy.studyMaterials, equals(pack.studyMaterials));
      });

      test('should create copy with updated description', () {
        final copy = pack.copyWith(description: 'New Description');

        expect(copy.id, equals(pack.id));
        expect(copy.name, equals(pack.name));
        expect(copy.description, equals('New Description'));
        expect(copy.studyMaterials, equals(pack.studyMaterials));
      });

      test('should create copy with updated studyMaterials', () {
        final newMaterials = [
          StudyMaterialFreeTextQuestion(
            id: 'new-ftq',
            question: 'New question',
            answer: 'New answer',
          ),
        ];

        final copy = pack.copyWith(studyMaterials: newMaterials);

        expect(copy.id, equals(pack.id));
        expect(copy.name, equals(pack.name));
        expect(copy.studyMaterials, hasLength(1));
        expect(copy.studyMaterials[0].id, equals('new-ftq'));
      });

      test('should create copy with multiple updates', () {
        final newMaterials = [
          StudyMaterialMultipleChoiceQuestion(
            id: 'updated-mcq',
            question: 'Updated?',
            options: ['Yes', 'No'],
            answer: 'Yes',
          ),
        ];

        final copy = pack.copyWith(
          id: 'updated-id',
          name: 'Updated Name',
          description: 'Updated Description',
          studyMaterials: newMaterials,
        );

        expect(copy.id, equals('updated-id'));
        expect(copy.name, equals('Updated Name'));
        expect(copy.description, equals('Updated Description'));
        expect(copy.studyMaterials, hasLength(1));
        expect(copy.studyMaterials[0].id, equals('updated-mcq'));
      });

      test('should create identical copy when no parameters provided', () {
        final copy = pack.copyWith();

        expect(copy.id, equals(pack.id));
        expect(copy.name, equals(pack.name));
        expect(copy.description, equals(pack.description));
        expect(copy.studyMaterials, equals(pack.studyMaterials));
      });

      test('should be a new instance, not the same reference', () {
        final copy = pack.copyWith();

        expect(identical(copy, pack), isFalse);
      });
    });

    group('Edge Cases', () {
      test('should handle very large number of studyMaterials', () {
        final largeMaterials = List.generate(
          1000,
          (i) => StudyMaterialFreeTextQuestion(
            id: 'ftq-$i',
            question: 'Question $i',
            answer: 'Answer $i',
          ),
        );

        final largePack = StudyMaterialPack(
          id: 'large-pack',
          name: 'Large Pack',
          description: 'Contains 1000 materials',
          studyMaterials: largeMaterials,
        );

        final restored = StudyMaterialPack.fromJson(largePack.toJson());

        expect(restored.studyMaterials, hasLength(1000));
        expect(restored.studyMaterials.first.id, equals('ftq-0'));
        expect(restored.studyMaterials.last.id, equals('ftq-999'));
      });

      test('should handle mixed StudyMaterial types', () {
        final mixedMaterials = [
          StudyMaterialMultipleChoiceQuestion(
            id: 'mcq-1',
            question: 'MCQ',
            options: ['A'],
            answer: 'A',
          ),
          StudyMaterialFreeTextQuestion(
            id: 'ftq-1',
            question: 'FTQ',
            answer: 'Answer',
          ),
          StudyMaterialMultipleChoiceQuestion(
            id: 'mcq-2',
            question: 'MCQ2',
            options: ['B'],
            answer: 'B',
          ),
          StudyMaterialFreeTextQuestion(
            id: 'ftq-2',
            question: 'FTQ2',
            answer: 'Answer2',
          ),
        ];

        final mixedPack = StudyMaterialPack(
          id: 'mixed',
          name: 'Mixed',
          studyMaterials: mixedMaterials,
        );

        final restored = StudyMaterialPack.fromJson(mixedPack.toJson());

        expect(
          restored.studyMaterials[0],
          isA<StudyMaterialMultipleChoiceQuestion>(),
        );
        expect(
          restored.studyMaterials[1],
          isA<StudyMaterialFreeTextQuestion>(),
        );
        expect(
          restored.studyMaterials[2],
          isA<StudyMaterialMultipleChoiceQuestion>(),
        );
        expect(
          restored.studyMaterials[3],
          isA<StudyMaterialFreeTextQuestion>(),
        );
      });

      test('should handle empty strings', () {
        final emptyPack = StudyMaterialPack(
          id: '',
          name: '',
          description: '',
          studyMaterials: [],
        );

        final restored = StudyMaterialPack.fromJson(emptyPack.toJson());

        expect(restored.id, equals(''));
        expect(restored.name, equals(''));
        expect(restored.description, equals(''));
      });

      test('should handle special characters in all fields', () {
        final specialPack = StudyMaterialPack(
          id: 'special-🎉',
          name: 'Name with "quotes" & <tags>',
          description: 'Description\nwith\nnewlines\tand\ttabs',
          studyMaterials: [
            StudyMaterialFreeTextQuestion(
              id: 'special-ftq',
              question: '你好世界',
              answer: 'émoji 🌍',
            ),
          ],
        );

        final restored = StudyMaterialPack.fromJson(specialPack.toJson());

        expect(restored.id, equals('special-🎉'));
        expect(restored.name, equals('Name with "quotes" & <tags>'));
        expect(restored.description, contains('\n'));
      });

      test('should handle null values in map gracefully by throwing', () {
        final mapWithNulls = {
          'id': null,
          'name': null,
          'description': null,
          'studyMaterials': null,
        };

        expect(
          () => StudyMaterialPack.fromMap(mapWithNulls),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
