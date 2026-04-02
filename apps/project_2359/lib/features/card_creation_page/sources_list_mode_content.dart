import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

class SourcesListModeContent extends StatefulWidget {
  final CardCreationToolbarController controller;
  final String folderId;

  const SourcesListModeContent({
    super.key,
    required this.controller,
    required this.folderId,
  });

  @override
  State<SourcesListModeContent> createState() => _SourcesListModeContentState();
}

class _SourcesListModeContentState extends State<SourcesListModeContent> {
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
              child: _buildSourceList(cs),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(ColorScheme cs) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Search sources...",
        prefixIcon: Icon(Icons.search, size: 20, color: cs.primary),
        isDense: true,
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildSourceList(ColorScheme cs) {
    return FutureBuilder<List<SourceItem>>(
      future: context.read<SourceService>().getSourcesByFolderId(
        widget.folderId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final query = widget.controller.searchQuery.toLowerCase();
        final items = snapshot.data!
            .where((item) => item.label.toLowerCase().contains(query))
            .toList();

        if (items.isEmpty) {
          return _buildEmptyState("No sources in this folder", cs);
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
