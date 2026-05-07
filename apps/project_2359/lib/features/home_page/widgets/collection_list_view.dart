import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/features/collection_page/collection_page.dart';
import 'package:responsive_framework/responsive_framework.dart';

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

class PinnedCollectionsSection extends StatelessWidget {
  final Stream<List<(StudyCollectionItem, int)>> stream;
  final String searchQuery;
  final Set<String> selectedIds;
  final Function(String) onToggleSelection;
  final Function(String) onSelect;
  final bool isSelecting;
  final bool isLandscape;
  final String? activeCollectionId;
  final Function(Offset, String, bool)? onContextMenu;

  const PinnedCollectionsSection({
    super.key,
    required this.stream,
    required this.searchQuery,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onSelect,
    required this.isSelecting,
    this.isLandscape = false,
    this.activeCollectionId,
    this.onContextMenu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<(StudyCollectionItem, int)>>(
      stream: stream,
      builder: (context, snapshot) {
        final collectionPairs = (snapshot.data ?? []).where((p) {
          if (searchQuery.isEmpty) return true;
          return p.$1.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (collectionPairs.isEmpty) return const SizedBox.shrink();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: "Pinned"),
            for (final pair in collectionPairs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onSecondaryTapDown: (details) {
                    if (onContextMenu != null) {
                      onContextMenu!(details.globalPosition, pair.$1.id, true);
                    }
                  },
                  child: ProjectCardTile(
                    title: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.thumbtack,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            pair.$1.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.layerGroup,
                          size: 10,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text("${pair.$2} Card${pair.$2 == 1 ? '' : 's'}"),
                      ],
                    ),
                    isSelected:
                        selectedIds.contains(pair.$1.id) ||
                        (isLandscape && activeCollectionId == pair.$1.id),
                    isCompact: isLandscape,
                    onTap: isSelecting
                        ? () => onToggleSelection(pair.$1.id)
                        : () {
                            if (ResponsiveBreakpoints.of(
                              context,
                            ).largerThan(MOBILE)) {
                              onSelect(pair.$1.id);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CollectionPage(
                                    collectionId: pair.$1.id,
                                    initialCollectionName: pair.$1.name,
                                  ),
                                ),
                              );
                            }
                          },
                    onLongTap: () => onToggleSelection(pair.$1.id),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CollectionList extends StatelessWidget {
  final Stream<List<(StudyCollectionItem, int)>> stream;
  final String searchQuery;
  final Color? backgroundColor;
  final Set<String> selectedIds;
  final Function(String) onToggleSelection;
  final Function(String) onSelect;
  final bool isSelecting;
  final bool isLandscape;
  final String? activeCollectionId;
  final Function(Offset, String, bool)? onContextMenu;

  const CollectionList({
    super.key,
    required this.stream,
    required this.searchQuery,
    this.backgroundColor,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onSelect,
    required this.isSelecting,
    this.isLandscape = false,
    this.activeCollectionId,
    this.onContextMenu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<(StudyCollectionItem, int)>>(
      stream: stream,
      builder: (context, snapshot) {
        final collectionPairs = (snapshot.data ?? []).where((p) {
          if (searchQuery.isEmpty) return true;
          return p.$1.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (collectionPairs.isEmpty) {
          final isSearching = searchQuery.isNotEmpty;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                isSearching
                    ? "No matching collections found."
                    : "No collections yet. Create one below!",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final pair in collectionPairs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onSecondaryTapDown: (details) {
                    if (onContextMenu != null) {
                      onContextMenu!(details.globalPosition, pair.$1.id, true);
                    }
                  },
                  child: ProjectCardTile(
                    title: Row(
                      children: [
                        if (pair.$1.isPinned) ...[
                          FaIcon(
                            FontAwesomeIcons.thumbtack,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            pair.$1.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.layerGroup,
                          size: 10,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text("${pair.$2} Card${pair.$2 == 1 ? '' : 's'}"),
                      ],
                    ),
                    isSelected:
                        selectedIds.contains(pair.$1.id) ||
                        (isLandscape && activeCollectionId == pair.$1.id),
                    isCompact: isLandscape,
                    onTap: isSelecting
                        ? () => onToggleSelection(pair.$1.id)
                        : () {
                            if (ResponsiveBreakpoints.of(
                              context,
                            ).largerThan(MOBILE)) {
                              onSelect(pair.$1.id);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CollectionPage(
                                    collectionId: pair.$1.id,
                                    initialCollectionName: pair.$1.name,
                                  ),
                                ),
                              );
                            }
                          },
                    onLongTap: () => onToggleSelection(pair.$1.id),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
