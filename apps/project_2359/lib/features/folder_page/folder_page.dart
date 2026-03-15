import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';

class FolderPage extends StatefulWidget {
  final String initialFolderName;

  const FolderPage({super.key, required this.initialFolderName});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late String folderName;

  @override
  void initState() {
    super.initState();
    folderName = widget.initialFolderName;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundAlt,
      body: ExpandableFab(
        collapsed: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(FontAwesomeIcons.plus, size: 14),
            const SizedBox(width: 10),
            Text(
              'Create',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        expanded: const _FolderFabContent(),
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            // COLLAPSING HEADER → APPBAR
            SliverPersistentHeader(
              pinned: true,
              delegate: _CollapsingHeaderDelegate(
                folderName: folderName,
                topPadding: MediaQuery.of(context).padding.top,
                onBack: () => Navigator.pop(context),
                onSourcesTap: () => _SourcesBottomSheet.show(context),
                onSettingsTap: () {},
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              sliver: SliverToBoxAdapter(child: const _StudyMaterialsList()),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// COLLAPSING HEADER DELEGATE
// ---------------------------------------------------------------------------
// This drives the animated collapse from a large header (title + action chips)
// down to a compact appbar (title next to back button, icon-only actions on
// the right). Everything is driven by `shrinkOffset` — no setState needed.
// ---------------------------------------------------------------------------

class _CollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String folderName;
  final double topPadding;
  final VoidCallback onBack;
  final VoidCallback onSourcesTap;
  final VoidCallback onSettingsTap;

  _CollapsingHeaderDelegate({
    required this.folderName,
    required this.topPadding,
    required this.onBack,
    required this.onSourcesTap,
    required this.onSettingsTap,
  });

  static const double _collapsedBarHeight = 56.0;
  static const double _expandedContentHeight = 110.0;

  @override
  double get maxExtent =>
      topPadding + _collapsedBarHeight + _expandedContentHeight;

  @override
  double get minExtent => topPadding + _collapsedBarHeight;

  @override
  bool shouldRebuild(covariant _CollapsingHeaderDelegate oldDelegate) =>
      folderName != oldDelegate.folderName ||
      topPadding != oldDelegate.topPadding;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);

    // 0.0 = fully expanded, 1.0 = fully collapsed
    final double t = (shrinkOffset / _expandedContentHeight).clamp(0.0, 1.0);

    // Bottom border fades in as we collapse
    final borderOpacity = (t * 0.12).clamp(0.0, 0.12);

    // Appbar background — solid color with very slight transparency at top
    final bgColor = Color.lerp(
      theme.scaffoldBackgroundAlt.withValues(alpha: 0.0),
      theme.scaffoldBackgroundAlt,
      t,
    )!;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: borderOpacity),
            width: 0.6,
          ),
        ),
      ),
      child: Stack(
        children: [
          // ── EXPANDED: Large title + action chips ──
          Positioned(
            left: 16,
            right: 16,
            top: topPadding + _collapsedBarHeight,
            bottom: 0,
            child: Opacity(
              opacity: (1.0 - t * 2.5).clamp(0.0, 1.0),
              child: IgnorePointer(
                ignoring: t > 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Large title
                    Text(
                      folderName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Action chips row
                    Row(
                      children: [
                        _ActionButtonChip(
                          label: "Sources",
                          icon: FontAwesomeIcons.layerGroup,
                          onTap: onSourcesTap,
                        ),
                        const SizedBox(width: 8),
                        _ActionButtonChip(
                          label: "Settings",
                          icon: FontAwesomeIcons.gear,
                          onTap: onSettingsTap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── COLLAPSED: Appbar row (back + title + icon actions) ──
          Positioned(
            left: 0,
            right: 0,
            top: topPadding,
            height: _collapsedBarHeight,
            child: Row(
              children: [
                // Back button — always visible
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 18),
                  onPressed: onBack,
                  color: theme.colorScheme.onSurface,
                ),

                // Collapsed title — fades/slides in
                Expanded(
                  child: Opacity(
                    opacity: (t * 2.0 - 0.6).clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 8 * (1.0 - t)),
                      child: Text(
                        folderName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),

                // Collapsed action icons — fade in from right
                Opacity(
                  opacity: (t * 2.0 - 0.6).clamp(0.0, 1.0),
                  child: IgnorePointer(
                    ignoring: t < 0.8,
                    child: Transform.translate(
                      offset: Offset(16 * (1.0 - t), 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CompactIconButton(
                            icon: FontAwesomeIcons.layerGroup,
                            onTap: onSourcesTap,
                          ),
                          _CompactIconButton(
                            icon: FontAwesomeIcons.gear,
                            onTap: onSettingsTap,
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// COMPACT ICON BUTTON (for collapsed appbar actions)
// ---------------------------------------------------------------------------

class _CompactIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CompactIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        onPressed: onTap,
        icon: FaIcon(
          icon,
          size: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EXISTING WIDGETS (preserved from original)
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// COMPACT GENERATION WIZARD CONTENT
// ---------------------------------------------------------------------------

class _FolderFabContent extends StatefulWidget {
  const _FolderFabContent();

  @override
  State<_FolderFabContent> createState() => _FolderFabContentState();
}

class _FolderFabContentState extends State<_FolderFabContent> {
  final Set<String> _selectedTypes = {'flashcards'};
  final Set<int> _selectedSources = {0, 2};
  String _strategy = 'Spaced'; // 'Spaced' or 'Cram'

  final List<({String id, String label, IconData icon, Color color})> _types = [
    (
      id: 'flashcards',
      label: 'Flashcards',
      icon: FontAwesomeIcons.layerGroup,
      color: const Color(0xFF4ECDC4),
    ),
    (
      id: 'quizzes',
      label: 'Practice Quiz',
      icon: FontAwesomeIcons.listCheck,
      color: const Color(0xFFFF6B6B),
    ),
    (
      id: 'assessment',
      label: 'Assessment',
      icon: FontAwesomeIcons.fileCircleExclamation,
      color: const Color(0xFFF1C40F),
    ),
  ];

  final List<({String name, IconData icon})> _folderSources = [
    (name: "Lecture_Notes_W1.pdf", icon: FontAwesomeIcons.filePdf),
    (name: "Diagrams_Final.png", icon: FontAwesomeIcons.fileImage),
    (name: "Research_Summary", icon: FontAwesomeIcons.fileLines),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FaIcon(
                  FontAwesomeIcons.wandMagicSparkles,
                  size: 16,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Generate Materials",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    "Select format and sources to begin",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // SECTION 1: FORMATS
          const _SubHeader(title: "Choose Formats"),
          const SizedBox(height: 8),
          ProjectListGroup(
            backgroundColor: cs.surfaceContainer.withValues(alpha: 0.5),
            children: [
              for (int i = 0; i < _types.length; i++)
                ProjectListTile.simple(
                  label: _types[i].label,
                  icon: _types[i].icon,
                  showDivider: i < _types.length - 1,
                  backgroundColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      if (_selectedTypes.contains(_types[i].id)) {
                        if (_selectedTypes.length > 1) {
                          _selectedTypes.remove(_types[i].id);
                        }
                      } else {
                        _selectedTypes.add(_types[i].id);
                      }
                    });
                  },
                  trailing: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _selectedTypes.contains(_types[i].id)
                        ? FaIcon(
                            FontAwesomeIcons.circleCheck,
                            size: 18,
                            color: cs.primary,
                            key: const ValueKey('checked'),
                          )
                        : FaIcon(
                            FontAwesomeIcons.circle,
                            size: 18,
                            color: cs.onSurface.withValues(alpha: 0.1),
                            key: const ValueKey('unchecked'),
                          ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // SECTION 2: SOURCES
          const _SubHeader(title: "Select Sources"),
          const SizedBox(height: 8),
          ProjectListGroup(
            backgroundColor: cs.surfaceContainer.withValues(alpha: 0.5),
            children: [
              for (int i = 0; i < _folderSources.length; i++)
                ProjectListTile.simple(
                  label: _folderSources[i].name,
                  icon: _folderSources[i].icon,
                  showDivider: i < _folderSources.length - 1,
                  backgroundColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      if (_selectedSources.contains(i)) {
                        _selectedSources.remove(i);
                      } else {
                        _selectedSources.add(i);
                      }
                    });
                  },
                  trailing: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _selectedSources.contains(i)
                        ? FaIcon(
                            FontAwesomeIcons.squareCheck,
                            size: 18,
                            color: cs.primary,
                            key: const ValueKey('checked'),
                          )
                        : FaIcon(
                            FontAwesomeIcons.square,
                            size: 18,
                            color: cs.onSurface.withValues(alpha: 0.1),
                            key: const ValueKey('unchecked'),
                          ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // SECTION 3: STRATEGY
          const _SubHeader(title: "Learning Strategy"),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cs.surfaceContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                _StrategyButton(
                  label: "Spaced",
                  icon: FontAwesomeIcons.clockRotateLeft,
                  isSelected: _strategy == 'Spaced',
                  onTap: () => setState(() => _strategy = 'Spaced'),
                ),
                _StrategyButton(
                  label: "Cram",
                  icon: FontAwesomeIcons.bolt,
                  isSelected: _strategy == 'Cram',
                  onTap: () => setState(() => _strategy = 'Cram'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // GENERATE BUTTON
          ElevatedButton(
            onPressed: _selectedSources.isEmpty || _selectedTypes.isEmpty
                ? null
                : () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.wandSparkles, size: 14),
                const SizedBox(width: 10),
                Text(
                  "Begin Generation",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SubHeader extends StatelessWidget {
  final String title;
  const _SubHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _StrategyButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _StrategyButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? cs.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 12,
                color: isSelected
                    ? cs.primary
                    : cs.onSurface.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? cs.onSurface
                      : cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
