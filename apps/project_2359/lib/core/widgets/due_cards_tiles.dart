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
    final appController = context.watch<AppController>();
    final schedulingService = appController.schedulingService;
    final database = context.read<AppDatabase>();

    return StreamBuilder<List<CardItem>>(
      stream: schedulingService.watchTotalDueCardItems(),
      builder: (context, snapshot) {
        final cards = snapshot.data ?? [];
        if (cards.isEmpty) return const SizedBox.shrink();

        return FutureBuilder<Map<String, int>>(
          future: _groupCardsByRootDeck(database, cards),
          builder: (context, deckSnapshot) {
            final rootDeckCounts = deckSnapshot.data ?? {};
            if (rootDeckCounts.isEmpty) return const SizedBox.shrink();

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
                items: rootDeckCounts,
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, int>> _groupCardsByRootDeck(
    AppDatabase db,
    List<CardItem> cards,
  ) async {
    final Map<String, int> rootCounts = {};
    final deckIds = cards.map((c) => c.deckId).whereType<String>().toSet();

    if (deckIds.isEmpty) return rootCounts;

    // Fetch all involved decks
    final decks = await (db.select(db.deckItems)..where((t) => t.id.isIn(deckIds))).get();
    final deckMap = {for (var d in decks) d.id: d};

    for (var card in cards) {
      final deck = deckMap[card.deckId];
      if (deck == null) continue;

      // Find the root deck name
      // If we use parentId hierarchy, we'd need to traverse up.
      // For now, let's assume names might still have Anki-style hierarchy or we use root name.
      final rootName = deck.name.rootDeckName;
      rootCounts[rootName] = (rootCounts[rootName] ?? 0) + 1;
    }

    return rootCounts;
  }
}

class DeckDueCardsTile extends StatelessWidget {
  final String deckId;
  final VoidCallback? onTap;
  const DeckDueCardsTile({
    super.key,
    required this.deckId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appController = context.watch<AppController>();
    final schedulingService = appController.schedulingService;
    final database = context.read<AppDatabase>();

    return StreamBuilder<List<CardItem>>(
      stream: schedulingService.watchDueCardItems(deckId: deckId),
      builder: (context, snapshot) {
        final cards = snapshot.data ?? [];
        if (cards.isEmpty) return const SizedBox.shrink();

        return FutureBuilder<Map<String, int>>(
          future: _groupCardsBySubDecks(database, deckId, cards),
          builder: (context, subDeckSnapshot) {
            final subCounts = subDeckSnapshot.data ?? {};
            if (subCounts.isEmpty) return const SizedBox.shrink();

            return ProjectImportantTile(
              onTap: onTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudyPage(
                          deckId: deckId,
                          title: "Deck Review",
                        ),
                      ),
                    );
                  },
              child: DueCardsOverview(
                totalDue: cards.length,
                items: subCounts,
                isCollectionPage: true,
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, int>> _groupCardsBySubDecks(
    AppDatabase db,
    String parentDeckId,
    List<CardItem> cards,
  ) async {
    final Map<String, int> groupCounts = {};
    
    // We want to group by immediate sub-decks of parentDeckId.
    // If a card is in parentDeckId, group it under "Current Deck" or its own name.
    // If a card is in a sub-deck, group it under that immediate sub-deck's name.

    final deckIds = cards.map((c) => c.deckId).whereType<String>().toSet();
    if (deckIds.isEmpty) return groupCounts;

    // Fetch all decks involved in these cards
    final decks = await (db.select(db.deckItems)..where((t) => t.id.isIn(deckIds))).get();
    final deckMap = {for (var d in decks) d.id: d};
    
    final parentDeck = await (db.select(db.deckItems)..where((t) => t.id.equals(parentDeckId))).getSingleOrNull();
    final parentName = parentDeck?.name ?? "Current Deck";

    for (var card in cards) {
      final deck = deckMap[card.deckId];
      if (deck == null) continue;

      if (deck.id == parentDeckId) {
        groupCounts[parentName.cleanDeckName] = (groupCounts[parentName.cleanDeckName] ?? 0) + 1;
      } else {
        // Find which immediate child of parentDeckId this deck belongs to
        // This is a bit complex without recursive traversal in memory, but let's approximate
        // by looking at the Anki name if available, or just use the deck's own name cleaned.
        final relativeName = deck.name;
        // Simple heuristic: if name is "Parent::Child::Grandchild", and we are at "Parent",
        // we want to group under "Child".
        if (relativeName.startsWith("${parentDeck?.name}::")) {
          final suffix = relativeName.substring(parentDeck!.name.length + 2);
          final firstSub = suffix.split('::').first;
          groupCounts[firstSub] = (groupCounts[firstSub] ?? 0) + 1;
        } else {
          groupCounts[deck.name.cleanDeckName] = (groupCounts[deck.name.cleanDeckName] ?? 0) + 1;
        }
      }
    }

    return groupCounts;
  }
}
