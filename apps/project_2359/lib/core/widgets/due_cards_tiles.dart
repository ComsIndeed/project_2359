import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/app_controller.dart';
import 'package:project_2359/features/home_page/widgets/due_cards_overview.dart';
import 'package:project_2359/features/study_page/study_page.dart';
import 'package:project_2359/core/widgets/project_important_tile.dart';
import 'package:project_2359/core/utils/deck_name_utils.dart';

class HomeDueCardsTile extends StatelessWidget {
  final VoidCallback? onTap;
  const HomeDueCardsTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = context.watch<AppController>();
    final schedulingService = appController.schedulingService;
    final database = context.read<AppDatabase>();

    return StreamBuilder<List<CardItem>>(
      stream: schedulingService.watchTotalDueCardItems(),
      builder: (context, snapshot) {
        final cards = snapshot.data ?? [];
        if (cards.isEmpty) return const SizedBox.shrink();

        return FutureBuilder<Map<String, int>>(
          future: _groupCardsByCollection(database, cards),
          builder: (context, collectionSnapshot) {
            final collectionCounts = collectionSnapshot.data ?? {};
            if (collectionCounts.isEmpty) return const SizedBox.shrink();

            return ProjectImportantTile(
              onTap: onTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudyPage(
                          title: "Global Review",
                        ),
                      ),
                    );
                  },
              child: DueCardsOverview(
                totalDue: cards.length,
                items: collectionCounts,
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, int>> _groupCardsByCollection(
    AppDatabase db,
    List<CardItem> cards,
  ) async {
    final Map<String, int> collectionCounts = {};
    final deckIds = cards.map((c) => c.deckId).whereType<String>().toSet();

    if (deckIds.isEmpty) return collectionCounts;

    final decks = await (db.select(
      db.deckItems,
    )..where((t) => t.id.isIn(deckIds))).get();
    final deckToCollection = {for (var d in decks) d.id: d.collectionId};

    final collectionIds = deckToCollection.values.toSet();
    final collections = await (db.select(
      db.studyCollectionItems,
    )..where((t) => t.id.isIn(collectionIds))).get();
    final collectionIdToName = {for (var f in collections) f.id: f.name};

    for (var card in cards) {
      final collectionId = deckToCollection[card.deckId];
      final collectionName = collectionIdToName[collectionId] ?? "Unknown Collection";
      collectionCounts[collectionName] = (collectionCounts[collectionName] ?? 0) + 1;
    }

    return collectionCounts;
  }
}

class CollectionDueCardsTile extends StatelessWidget {
  final String collectionId;
  final VoidCallback? onTap;
  const CollectionDueCardsTile({
    super.key,
    required this.collectionId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = context.watch<AppController>();
    final schedulingService = appController.schedulingService;
    final database = context.read<AppDatabase>();

    return StreamBuilder<List<CardItem>>(
      stream: schedulingService.watchDueCardItemsForCollection(collectionId: collectionId),
      builder: (context, snapshot) {
        final cards = snapshot.data ?? [];
        if (cards.isEmpty) return const SizedBox.shrink();

        return FutureBuilder<Map<String, int>>(
          future: _groupCardsByDeck(database, cards),
          builder: (context, deckSnapshot) {
            final deckCounts = deckSnapshot.data ?? {};
            if (deckCounts.isEmpty) return const SizedBox.shrink();

            return ProjectImportantTile(
              onTap: onTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudyPage(
                          collectionId: collectionId,
                          title: "Collection Review",
                        ),
                      ),
                    );
                  },
              child: DueCardsOverview(
                totalDue: cards.length,
                items: deckCounts,
                isCollectionPage: true,
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, int>> _groupCardsByDeck(
    AppDatabase db,
    List<CardItem> cards,
  ) async {
    final Map<String, int> deckCounts = {};
    final deckIds = cards.map((c) => c.deckId).whereType<String>().toSet();

    if (deckIds.isEmpty) return deckCounts;

    final decks = await (db.select(
      db.deckItems,
    )..where((t) => t.id.isIn(deckIds))).get();
    final deckIdToName = {for (var d in decks) d.id: d.name};

    for (var card in cards) {
      final deckName = (deckIdToName[card.deckId] ?? "Unknown Deck").cleanDeckName;
      deckCounts[deckName] = (deckCounts[deckName] ?? 0) + 1;
    }

    return deckCounts;
  }
}
