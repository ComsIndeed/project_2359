import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';

class FolderPage extends StatefulWidget {
  final String initialFolderName;

  const FolderPage({super.key, required this.initialFolderName});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late String folderName;
  final TextEditingController _titleController = TextEditingController();
  bool _isEditingTitle = false;

  @override
  void initState() {
    super.initState();
    folderName = widget.initialFolderName;
    _titleController.text = folderName;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header with Background
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  SpecialBackgroundGenerator(
                    seed: GenerationSeed.fromString(folderName),
                    label: folderName,
                    icon: FontAwesomeIcons.folder,
                    type: SpecialBackgroundType.vibrantGradients,
                    showBorder: false,
                    borderRadius: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            theme.scaffoldBackgroundColor.withValues(
                              alpha: 0.8,
                            ),
                            theme.scaffoldBackgroundColor,
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEditableTitle(theme),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Last studied: 2 hours ago",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: cs.onSurface.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "65% Mastered",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.primary.withValues(alpha: 0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Primary Actions
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _ActionButton(
                        label: "Study Now",
                        icon: FontAwesomeIcons.play,
                        isPrimary: true,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        label: "Generate",
                        icon: FontAwesomeIcons.wandMagicSparkles,
                        isPrimary: false,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Quick Stats
                const _QuickStats(
                  message: "12 cards mastered, 45 pending review",
                ),
                const SizedBox(height: 32),

                // Source Materials
                const _SectionLabel(title: "Source Materials"),
                const SizedBox(height: 12),
                _SourceList(),
                const SizedBox(height: 16),
                _AddSourceButton(onTap: () {}),

                const SizedBox(height: 32),

                // Generated Materials
                const _SectionLabel(title: "Study Decks"),
                const SizedBox(height: 12),
                _GeneratedMaterialsList(),
                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTitle(ThemeData theme) {
    if (_isEditingTitle) {
      return TextField(
        controller: _titleController,
        autofocus: true,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onSubmitted: (value) {
          setState(() {
            folderName = value;
            _isEditingTitle = false;
          });
        },
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _isEditingTitle = true),
      child: Row(
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
          const SizedBox(width: 8),
          FaIcon(
            FontAwesomeIcons.pen,
            size: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: isPrimary ? cs.primary : cs.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                size: 20,
                color: isPrimary ? cs.onPrimary : cs.onSurface,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? cs.onPrimary : cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
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

class _SourceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sources = [
      (name: "Lecture_Notes_W1.pdf", icon: FontAwesomeIcons.filePdf),
      (name: "Diagrams_Final.png", icon: FontAwesomeIcons.fileImage),
      (name: "Research_Summary", icon: FontAwesomeIcons.fileLines),
    ];

    if (sources.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              FaIcon(
                FontAwesomeIcons.cloudArrowUp,
                size: 32,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 12),
              Text(
                "Drop a PDF or photo to start",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ProjectListGroup(
      children: [
        for (int i = 0; i < sources.length; i++)
          ProjectListTile.simple(
            label: sources[i].name,
            icon: sources[i].icon,
            subLabel: "Added Mar 10 • 2.4 MB",
            showDivider: i < sources.length - 1,
            onTap: () {},
            // Use long press for delete simulator
            trailing: IconButton(
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical, size: 14),
              onPressed: () {},
              visualDensity: VisualDensity.compact,
            ),
          ),
      ],
    );
  }
}

class _AddSourceButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddSourceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.plus,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                "Add Source",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GeneratedMaterialsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decks = [
      (name: "Key Concepts Flashcards", count: 24, lastStudied: "Today"),
      (name: "Practice Quiz - Mechanics", count: 15, lastStudied: "Yesterday"),
    ];

    if (decks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              "No materials generated yet",
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap 'Generate' to create study materials from your sources",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ProjectListGroup(
      children: [
        for (int i = 0; i < decks.length; i++)
          ProjectListTile.simple(
            label: decks[i].name,
            subLabel: "${decks[i].count} cards • ${decks[i].lastStudied}",
            showDivider: i < decks.length - 1,
            onTap: () {},
            showChevron: true,
          ),
      ],
    );
  }
}

class _QuickStats extends StatelessWidget {
  final String message;
  const _QuickStats({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.chartLine,
            size: 12,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
