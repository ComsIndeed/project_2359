import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:project_2359/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:project_2359/core/enums/media_type.dart';
import 'package:project_2359/core/tables/source_item_blobs.dart';

class DebugSeeder {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/ComsIndeed/project_2359/main/seeds/';
  static const List<String> _seedFiles = [
    'map-stuff.pdf',
    'presentation.pdf',
    'text-stuff.pdf',
  ];

  static Future<void> seed(AppDatabase db) async {
    final uuid = const Uuid();

    // 1. Create a Debug Folder
    final folderId = uuid.v4();
    await db
        .into(db.studyFolderItems)
        .insert(
          StudyFolderItemsCompanion(
            id: Value(folderId),
            name: const Value('🧪 Debug Playground'),
            isPinned: const Value(true),
            createdAt: Value(DateTime.now().toIso8601String()),
            updatedAt: Value(DateTime.now().toIso8601String()),
          ),
        );

    // 2. Download and Create Sources
    final List<String> sourceIds = [];
    for (final fileName in _seedFiles) {
      try {
        final response = await http.get(Uri.parse('$_baseUrl$fileName'));
        if (response.statusCode == 200) {
          final sourceId = uuid.v4();
          final blobId = uuid.v4();
          sourceIds.add(sourceId);

          await db
              .into(db.sourceItemBlobs)
              .insert(
                SourceItemBlobsCompanion(
                  id: Value(blobId),
                  sourceItemId: Value(sourceId),
                  sourceItemName: Value(fileName),
                  type: const Value(SourceFileType.pdf),
                  bytes: Value(response.bodyBytes),
                ),
              );

          await db
              .into(db.sourceItems)
              .insert(
                SourceItemsCompanion(
                  id: Value(sourceId),
                  folderId: Value(folderId),
                  label: Value(fileName),
                  type: const Value(MediaType.document),
                ),
              );
        }
      } catch (e) {
        print('Error seeding $fileName: $e');
      }
    }

    // 3. Create 3 Decks
    final deck1Id = uuid.v4(); // Fresh
    final deck2Id = uuid.v4(); // Mixed
    final deck3Id = uuid.v4(); // Veteran

    await db.batch((batch) {
      batch.insertAll(db.deckItems, [
        DeckItemsCompanion(
          id: Value(deck1Id),
          folderId: Value(folderId),
          name: const Value('🌱 Fresh Deck (New)'),
          description: const Value('All cards are new and have no history.'),
        ),
        DeckItemsCompanion(
          id: Value(deck2Id),
          folderId: Value(folderId),
          name: const Value('🧠 Mixed Deck (Learning)'),
          description: const Value('A mix of new, learning, and review cards.'),
        ),
        DeckItemsCompanion(
          id: Value(deck3Id),
          folderId: Value(folderId),
          name: const Value('🏆 Veteran Deck (Mastery)'),
          description: const Value('High stability cards with long history.'),
        ),
      ]);
    });

    // 4. Create 20 Cards
    final List<CardItemsCompanion> cards = [];

    // --- Deck 1: 6 Fresh Cards ---
    for (int i = 0; i < 6; i++) {
      cards.add(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck1Id),
          frontText: Value('Fresh Question $i'),
          backText: Value('Fresh Answer $i'),
          spacedDue: Value(DateTime.now()),
          spacedState: const Value(0), // New
        ),
      );
    }

    // --- Deck 2: 7 Mixed Cards ---
    for (int i = 0; i < 7; i++) {
      final isDue = i < 3;
      cards.add(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck2Id),
          frontText: Value('Mixed Question $i'),
          backText: Value('Mixed Answer $i'),
          spacedDue: Value(
            isDue
                ? DateTime.now().subtract(const Duration(days: 1))
                : DateTime.now().add(Duration(days: i + 1)),
          ),
          spacedState: const Value(1), // Learning
          spacedStability: Value(2.0 + i),
          spacedDifficulty: Value(4.0 + (i % 3)),
          spacedLastReview: Value(
            DateTime.now().subtract(const Duration(days: 2)),
          ),
        ),
      );
    }

    // --- Deck 3: 7 Veteran Cards ---
    for (int i = 0; i < 7; i++) {
      cards.add(
        CardItemsCompanion(
          id: Value(uuid.v4()),
          deckId: Value(deck3Id),
          frontText: Value('Veteran Question $i'),
          backText: Value('Veteran Answer $i'),
          spacedDue: Value(DateTime.now().add(Duration(days: 30 + (i * 10)))),
          spacedState: const Value(2), // Review
          spacedStability: Value(100.0 + (i * 20)),
          spacedDifficulty: const Value(2.5),
          spacedLastReview: Value(
            DateTime.now().subtract(const Duration(days: 5)),
          ),
        ),
      );
    }

    await db.batch((batch) {
      batch.insertAll(db.cardItems, cards);
    });
  }
}
