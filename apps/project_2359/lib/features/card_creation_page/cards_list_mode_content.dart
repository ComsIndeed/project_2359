import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

class CardsListModeContent extends StatefulWidget {
  final CardCreationToolbarController controller;
  final String folderId;

  const CardsListModeContent({
    super.key,
    required this.controller,
    required this.folderId,
  });

  @override
  State<CardsListModeContent> createState() => _CardsListModeContentState();
}

class _CardsListModeContentState extends State<CardsListModeContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _shouldAnimate = true;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.controller.searchQuery;
    _searchController.addListener(() {
      widget.controller.setSearchQuery(_searchController.text);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(800.ms, () {
        if (mounted) setState(() => _shouldAnimate = false);
      });
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

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(cs),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 500),
              child: _buildCardList(cs),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(ColorScheme cs) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search cards...",
              prefixIcon: Icon(Icons.search, size: 20, color: cs.primary),
              isDense: true,
              filled: true,
              fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (widget.controller.selectedItemIds.isNotEmpty) ...[
          const SizedBox(width: 12),
          IconButton.filledTonal(
            onPressed: () => widget.controller.deleteSelectedCards(),
            icon: Icon(Icons.delete_outline, color: cs.error),
            style: IconButton.styleFrom(
              backgroundColor: cs.errorContainer.withValues(alpha: 0.5),
            ),
          ).animate().scale().fadeIn(),
        ],
      ],
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildCardList(ColorScheme cs) {
    return StreamBuilder<List<StudyCardItem>>(
      stream: context.read<StudyMaterialService>().watchCardsByFolderId(
        widget.folderId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final query = widget.controller.searchQuery.toLowerCase();
        final items = snapshot.data!
            .where(
              (c) =>
                  (c.question?.toLowerCase().contains(query) ?? false) ||
                  (c.answer?.toLowerCase().contains(query) ?? false),
            )
            .toList();

        if (items.isEmpty) {
          return _buildEmptyState("No cards in this folder", cs);
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = widget.controller.selectedItemIds.contains(
              item.id,
            );

            final tile = Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ProjectCardTile(
                title: Text(item.question ?? "Untitled"),
                subtitle: Text(item.answer ?? ""),
                leading: const WizardFlashcardPreview(),
                backgroundColor: cs.surface.withValues(alpha: 0.4),
                isSelected: isSelected,
                isCompact: true,
                onTap: () {
                  if (widget.controller.selectedItemIds.isNotEmpty) {
                    widget.controller.toggleSelection(item.id);
                  } else {
                    widget.controller.requestCard(item.id);
                  }
                },
                onLongTap: () => widget.controller.toggleSelection(item.id),
              ),
            );

            if (!_shouldAnimate) return tile;
            return tile
                .animate(delay: (index * 50).ms)
                .fadeIn()
                .slideX(begin: 0.1);
          },
        );
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
