import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/expandable_card_creation_toolbar.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

class MenuModeContent extends StatefulWidget {
  final CardCreationToolbarController controller;
  const MenuModeContent({super.key, required this.controller});

  @override
  State<MenuModeContent> createState() => _MenuModeContentState();
}

class _MenuModeContentState extends State<MenuModeContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _shouldAnimate = true;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.controller.searchQuery;
    _searchController.addListener(() {
      widget.controller.setSearchQuery(_searchController.text);
    });

    // Disable staggered animation after initial render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(800.ms, () {
          if (mounted) {
            setState(() {
              _shouldAnimate = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final isPdfMode =
            widget.controller.mode == CardCreationToolbarMode.sourcesList;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Search + Mode Toggle
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search ${isPdfMode ? 'PDFs' : 'Cards'}...",
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: cs.primary,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildModeToggleButton(cs),
              ],
            ).animate().fadeIn().slideY(begin: -0.2),

            const SizedBox(height: 16),

            // List Content
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 540),
              child: isPdfMode
                  ? _buildPdfList(cs, textTheme)
                  : _buildCardList(cs, textTheme),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModeToggleButton(ColorScheme cs) {
    final isPdfMode =
        widget.controller.mode == CardCreationToolbarMode.sourcesList;
    return Material(
      color: cs.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          setState(() {
            _shouldAnimate = true;
          });
          widget.controller.setMode(
            isPdfMode
                ? CardCreationToolbarMode.cardsList
                : CardCreationToolbarMode.sourcesList,
          );
          // Register post frame callback to disable animation after the new list renders
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Future.delayed(800.ms, () {
                if (mounted) {
                  setState(() {
                    _shouldAnimate = false;
                  });
                }
              });
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPdfMode ? Icons.picture_as_pdf_rounded : Icons.style_rounded,
                size: 18,
                color: cs.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isPdfMode ? "PDFs" : "Cards",
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfList(ColorScheme cs, TextTheme textTheme) {
    return FutureBuilder<List<SourceItem>>(
      future: context.read<SourceService>().getAllSources(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final query = widget.controller.searchQuery.toLowerCase();
        final items = snapshot.data!
            .where((item) => item.label.toLowerCase().contains(query))
            .toList();

        if (items.isEmpty) {
          return _buildEmptyState("No PDFs found", cs);
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          padding: const EdgeInsets.only(bottom: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = widget.controller.selectedItemIds.contains(
              item.id,
            );

            final tile = Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ProjectCardTile(
                title: Text(item.label),
                subtitle: Text(item.type.toUpperCase()),
                leading: const WizardSourcePagePreview(),
                backgroundColor: cs.surface.withValues(alpha: 0.4),
                isSelected: isSelected,
                isCompact: true,
                onTap: () {
                  if (widget.controller.selectedItemIds.isNotEmpty) {
                    widget.controller.toggleSelection(item.id);
                  } else {
                    widget.controller.requestSource(item.id);
                  }
                },
                onLongTap: () => widget.controller.toggleSelection(item.id),
              ),
            );

            if (!_shouldAnimate) return tile;

            return tile
                .animate(delay: (index * 50).ms)
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.1, curve: Curves.easeOutCubic);
          },
        );
      },
    );
  }

  Widget _buildCardList(ColorScheme cs, TextTheme textTheme) {
    // Placeholder data for cards
    final List<Map<String, String>> placeholderCards = List.generate(
      20,
      (i) => {
        'id': 'card_$i',
        'front': 'Card Front #$i',
        'back': 'This is the back content for card number $i.',
      },
    );

    final query = widget.controller.searchQuery.toLowerCase();
    final items = placeholderCards
        .where(
          (c) =>
              c['front']!.toLowerCase().contains(query) ||
              c['back']!.toLowerCase().contains(query),
        )
        .toList();

    if (items.isEmpty) {
      return _buildEmptyState("No cards found", cs);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      padding: const EdgeInsets.only(bottom: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = widget.controller.selectedItemIds.contains(
          item['id']!,
        );

        final tile = Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ProjectCardTile(
            title: Text(item['front']!),
            subtitle: Text(item['back']!),
            leading: const WizardFlashcardPreview(),
            backgroundColor: cs.surface.withValues(alpha: 0.4),
            isSelected: isSelected,
            isCompact: true,
            onTap: () {
              if (widget.controller.selectedItemIds.isNotEmpty) {
                widget.controller.toggleSelection(item['id']!);
              } else {
                widget.controller.requestCard(item['id']!);
              }
            },
            onLongTap: () => widget.controller.toggleSelection(item['id']!),
          ),
        );

        if (!_shouldAnimate) return tile;

        return tile
            .animate(delay: (index * 50).ms)
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.1, curve: Curves.easeOutCubic);
      },
    );
  }

  Widget _buildEmptyState(String message, ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          message,
          style: TextStyle(color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}
