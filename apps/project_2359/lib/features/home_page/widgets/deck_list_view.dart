import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/features/deck_page/deck_page.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          letterSpacing: 0.5,
          fontSize: 12,
        ),
      ),
    );
  }
}

class DeckSection extends StatelessWidget {
  final Stream<List<DeckItem>> stream;
  final String title;
  final String searchQuery;
  final Set<String> selectedIds;
  final Function(String) onToggleSelection;
  final Function(String) onSelect;
  final bool isSelecting;
  final bool isDesktop;
  final bool isCollapsed;
  final String? activeDeckId;
  final Function(Offset, String)? onContextMenu;

  const DeckSection({
    super.key,
    required this.stream,
    required this.title,
    required this.searchQuery,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onSelect,
    required this.isSelecting,
    this.isDesktop = false,
    this.isCollapsed = false,
    this.activeDeckId,
    this.onContextMenu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<DeckItem>>(
      stream: stream,
      builder: (context, snapshot) {
        final decks = (snapshot.data ?? []).where((d) {
          if (searchQuery.isEmpty) return true;
          return d.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (decks.isEmpty) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isCollapsed
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            if (!isCollapsed) SectionHeader(title: title),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: decks.length,
              itemBuilder: (context, i) {
                final deck = decks[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onSecondaryTapDown: (details) {
                      if (onContextMenu != null) {
                        onContextMenu!(details.globalPosition, deck.id);
                      }
                    },
                    child: ProjectCardTile(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      isCollapsed: isCollapsed,
                      leading: FaIcon(
                        deck.isPinned
                            ? FontAwesomeIcons.thumbtack
                            : FontAwesomeIcons.folder,
                        size: 14,
                        color: deck.isPinned
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                      ),
                      title: Text(deck.name, overflow: TextOverflow.ellipsis),
                      subtitle: Text(deck.description ?? "Study Deck"),
                      isSelected:
                          selectedIds.contains(deck.id) ||
                          activeDeckId == deck.id,
                      isCompact: isDesktop,
                      onTap: isSelecting
                          ? () => onToggleSelection(deck.id)
                          : () {
                              if (isDesktop) {
                                onSelect(deck.id);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DeckPage(
                                      deckId: deck.id,
                                      initialDeckName: deck.name,
                                    ),
                                  ),
                                );
                              }
                            },
                      onLongTap: () => onToggleSelection(deck.id),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
