import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';

import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/floating_action_pill.dart';

class FolderPage extends StatefulWidget {
  final String initialFolderName;

  const FolderPage({super.key, required this.initialFolderName});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late String folderName;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    folderName = widget.initialFolderName;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final show = _scrollController.offset > 120;
    if (show != _showTitle) {
      setState(() => _showTitle = show);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundAlt,
      extendBody: true,

      body: Stack(
        children: [
          // MAIN SCROLLABLE CONTENT
          CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              // LARGE HEADER (SCROLLS AWAY)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    MediaQuery.of(context).padding.top + 64,
                    16,
                    32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditableTitle(theme),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _ActionButtonChip(
                            label: "Sources",
                            icon: FontAwesomeIcons.layerGroup,
                            onTap: () => _SourcesBottomSheet.show(context),
                          ),
                          const SizedBox(width: 8),
                          _ActionButtonChip(
                            label: "Settings",
                            icon: FontAwesomeIcons.gear,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // SECTION LABEL
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: const _SectionLabel(title: "Study Materials"),
                ),
              ),

              // MATERIALS LIST
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                sliver: SliverToBoxAdapter(child: const _StudyMaterialsList()),
              ),
            ],
          ),

          // CUSTOM GLASSMORPHIC APP BAR (PINNED)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: MediaQuery.of(context).padding.top + 56,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(_showTitle ? 0.05 : 0)
                        : Colors.black.withOpacity(_showTitle ? 0.02 : 0),
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(
                          _showTitle ? 0.08 : 0,
                        ),
                        width: 0.6,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          size: 18,
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: theme.colorScheme.onSurface,
                      ),
                      AnimatedOpacity(
                        opacity: _showTitle ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          folderName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionPill(
        label: "Create",
        icon: FontAwesomeIcons.circlePlus,
        isPrimary: false,
        onTap: () {},
      ),
    );
  }

  Widget _buildEditableTitle(ThemeData theme) {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.folder,
          size: 20,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            folderName,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButtonChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButtonChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.onSurface.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                size: 12,
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyMaterialsList extends StatelessWidget {
  const _StudyMaterialsList();

  @override
  Widget build(BuildContext context) {
    final materials = [
      (
        name: "Key Concepts Flashcards",
        type: "Flashcards",
        count: 24,
        icon: FontAwesomeIcons.clone,
      ),
      (
        name: "Introduction Quiz",
        type: "Quiz",
        count: 15,
        icon: FontAwesomeIcons.clipboardCheck,
      ),
      (
        name: "Research_Summary",
        type: "Summary",
        count: 1,
        icon: FontAwesomeIcons.fileLines,
      ),
      for (int i = 1; i <= 15; i++)
        (
          name: "Extra Material #$i",
          type: "Study Guide",
          count: i * 2,
          icon: FontAwesomeIcons.bookOpen,
        ),
    ];

    return ProjectListGroup(
      children: [
        for (int i = 0; i < materials.length; i++)
          ProjectListTile.simple(
            label: materials[i].name,
            subLabel: "${materials[i].type} • ${materials[i].count} items",
            icon: materials[i].icon,
            showDivider: i < materials.length - 1,
            onTap: () {},
            showChevron: true,
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}

class _SourcesBottomSheet extends StatelessWidget {
  const _SourcesBottomSheet();

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _SourcesBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sources = [
      (name: "Lecture_Notes_W1.pdf", icon: FontAwesomeIcons.filePdf),
      (name: "Diagrams_Final.png", icon: FontAwesomeIcons.fileImage),
      (name: "Research_Summary", icon: FontAwesomeIcons.fileLines),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Source Materials",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProjectListGroup(
            children: [
              for (int i = 0; i < sources.length; i++)
                ProjectListTile.simple(
                  label: sources[i].name,
                  icon: sources[i].icon,
                  subLabel: "Added Mar 10 • 2.4 MB",
                  showDivider: i < sources.length - 1,
                  onTap: () {},
                  trailing: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.ellipsisVertical,
                      size: 14,
                    ),
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
