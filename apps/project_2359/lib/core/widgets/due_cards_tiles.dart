import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/app_controller.dart';
import 'package:project_2359/core/widgets/project_important_tile.dart';
import 'package:project_2359/features/home_page/widgets/due_cards_overview.dart';
import 'package:project_2359/core/widgets/sensor_reactive_border.dart';

class HomeDueCardsTile extends StatelessWidget {
  const HomeDueCardsTile({super.key});

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
          future: _groupCardsByFolder(database, cards),
          builder: (context, folderSnapshot) {
            final folderCounts = folderSnapshot.data ?? {};
            if (folderCounts.isEmpty) return const SizedBox.shrink();

            return ProjectImportantTile(
              child: DueCardsOverview(
                totalDue: cards.length,
                items: folderCounts,
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, int>> _groupCardsByFolder(
    AppDatabase db,
    List<CardItem> cards,
  ) async {
    final Map<String, int> folderCounts = {};
    final deckIds = cards.map((c) => c.deckId).whereType<String>().toSet();

    if (deckIds.isEmpty) return folderCounts;

    final decks = await (db.select(
      db.deckItems,
    )..where((t) => t.id.isIn(deckIds))).get();
    final deckToFolder = {for (var d in decks) d.id: d.folderId};

    final folderIds = deckToFolder.values.toSet();
    final folders = await (db.select(
      db.studyFolderItems,
    )..where((t) => t.id.isIn(folderIds))).get();
    final folderIdToName = {for (var f in folders) f.id: f.name};

    for (var card in cards) {
      final folderId = deckToFolder[card.deckId];
      final folderName = folderIdToName[folderId] ?? "Unknown Folder";
      folderCounts[folderName] = (folderCounts[folderName] ?? 0) + 1;
    }

    return folderCounts;
  }
}

class FolderDueCardsTile extends StatelessWidget {
  final String folderId;
  const FolderDueCardsTile({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = context.watch<AppController>();
    final schedulingService = appController.schedulingService;
    final database = context.read<AppDatabase>();

    return StreamBuilder<List<CardItem>>(
      stream: schedulingService.watchDueCardItemsForFolder(folderId: folderId),
      builder: (context, snapshot) {
        final cards = snapshot.data ?? [];
        if (cards.isEmpty) return const SizedBox.shrink();

        return FutureBuilder<Map<String, int>>(
          future: _groupCardsByDeck(database, cards),
          builder: (context, deckSnapshot) {
            final deckCounts = deckSnapshot.data ?? {};
            if (deckCounts.isEmpty) return const SizedBox.shrink();

            return SensorReactiveBorder(
              innerColor:
                  theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.8,
                  ),
              borderRadius: 24,
              borderWidth: 2.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: DueCardsOverview(
                  totalDue: cards.length,
                  items: deckCounts,
                  isFolderPage: true,
                ),
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
      final deckName = deckIdToName[card.deckId] ?? "Unknown Deck";
      deckCounts[deckName] = (deckCounts[deckName] ?? 0) + 1;
    }

    return deckCounts;
  }
}
