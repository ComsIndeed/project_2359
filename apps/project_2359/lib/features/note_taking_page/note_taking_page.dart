import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/desktop_title_bar_controller.dart';
import 'package:project_2359/core/widgets/adaptive_pane_layout.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/core/services/draft_service.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/features/deck_page/widgets/shared_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/enums/media_type.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:shared_core/shared_core.dart';
import 'note_taking_controller.dart';
import 'package:project_2359/core/models/note_type.dart';

class NoteTakingPage extends StatefulWidget {
  final String? deckId;
  final String? draftId;

  const NoteTakingPage({super.key, this.deckId, this.draftId});

  @override
  State<NoteTakingPage> createState() => _NoteTakingPageState();
}

class _NoteTakingPageState extends State<NoteTakingPage> {
  late final NoteTakingController _controller;
  List<SourceItem>? _sources;
  StreamSubscription? _sourcesSub;
  SourceItem? _selectedSource;
  Uint8List? _pdfBytes;
  bool _isLoadingPdf = false;
  NoteType? _hoveredNoteType;

  @override
  void initState() {
    super.initState();
    final db = context.read<AppDatabase>();
    _controller = NoteTakingController(draftService: DraftService(db));
    _controller.addListener(_onControllerChanged);
    _controller.initializeDraftSession(
      existingDraftId: widget.draftId,
      existingDeckId: widget.deckId,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitleBar();
    });

    if (widget.deckId != null) {
      final sourceService = SourceService(db);
      _sourcesSub = sourceService.watchSourcesByDeckId(widget.deckId!).listen((
        sources,
      ) {
        if (mounted) setState(() => _sources = sources);
      });
    }
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _updateTitleBar() {
    if (!mounted) return;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    if (!isDesktop) return;

    final titleBar = context.read<DesktopTitleBarController>();
    titleBar.setCenteredTitle('Taking Notes');
    titleBar.setHideBack(false);
    titleBar.setOnBack(() {
      titleBar.reset();
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _sourcesSub?.cancel();
    // Reset title bar when leaving the page
    Future.microtask(() {
      if (mounted) {
        context.read<DesktopTitleBarController>().reset();
      }
    });
    super.dispose();
  }

  void _showSaveDeckDialog() {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final nameController = TextEditingController(text: 'New Deck');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Deck'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter a name for your new deck:'),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Deck name...',
                filled: true,
                fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                await _controller.saveAsDeck(name);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deck saved successfully!')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(NoteItemsCompanion draft) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final type = draft.noteType.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.05)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (type == NoteType.basic ||
                type == NoteType.basicAndReversed) ...[
              _buildPreviewField("Front", draft.front.value ?? ""),
              const SizedBox(height: 16),
              _buildPreviewField("Back", draft.back.value ?? ""),
            ] else if (type == NoteType.cloze) ...[
              _buildPreviewField("Content", draft.content.value ?? ""),
            ] else if (type == NoteType.imageOcclusion) ...[
              const Center(
                child: Text("Image Occlusion Preview Not Supported"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewField(String label, String content) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content.isEmpty ? "No content" : content,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    return ChangeNotifierProvider.value(
      value: _controller,
      child: isDesktop
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final masterWidth = _controller.isMaximized
        ? screenWidth * 0.8
        : screenWidth * 0.25;

    return Scaffold(
      body: AdaptivePaneLayout(
        transition: const AdaptivePaneTransition.only(
          master: AdaptivePaneTransitionType.animate,
          detail: AdaptivePaneTransitionType.fade,
        ),
        masterWidth: masterWidth,
        master: (context, controller) =>
            _buildSidePanel(context, controller, isCollapsed: false),
        masterCollapsed: (context, controller) =>
            _buildSidePanel(context, controller, isCollapsed: true),
        detail: (context, controller) => _buildMainContent(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: Stack(
        children: [
          _buildMainContent(context),
          _buildDraggableBottomSheet(context),
        ],
      ),
    );
  }

  Widget _buildSidePanel(
    BuildContext context,
    AdaptivePaneController controller, {
    required bool isCollapsed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: isCollapsed
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              if (!isCollapsed) Expanded(child: _buildTabSwitcher()),
              if (!isCollapsed) const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isCollapsed)
                    IconButton(
                      onPressed: () => _controller.toggleMaximize(),
                      icon: Icon(
                        _controller.isMaximized
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                      ),
                      tooltip: _controller.isMaximized ? 'Restore' : 'Maximize',
                    ),
                  IconButton(
                    onPressed: controller.toggleCollapsed,
                    icon: Icon(isCollapsed ? Icons.menu : Icons.menu_open),
                    tooltip: isCollapsed ? 'Expand' : 'Collapse',
                  ),
                ],
              ),
            ],
          ),
          if (!isCollapsed) ...[
            const SizedBox(height: 24),
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _controller.pageController,
                    onPageChanged: (index) =>
                        _controller.setTabIndex(index, animate: false),
                    children: [
                      _buildNotesTab(),
                      _buildSourcesTab(),
                      _buildDraftTab(),
                    ],
                  ),
                  if (_controller.selectedTabIndex == 2 &&
                      _controller.notes.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child:
                          FloatingActionButton.extended(
                                onPressed: _showSaveDeckDialog,
                                icon: const Icon(Icons.check_circle_rounded),
                                label: const Text('Save Deck'),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                              )
                              .animate()
                              .scale(
                                curve: Curves.easeOutBack,
                                duration: const Duration(milliseconds: 400),
                              )
                              .fadeIn(),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    final theme = Theme.of(context);
    final tabs = ['Notes', 'Sources', 'Draft'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
            alignment: Alignment(
              -1.0 + (_controller.selectedTabIndex * 1.0),
              0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Row(
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value;
              final isSelected = _controller.selectedTabIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _controller.setTabIndex(index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getSourceIcon(MediaType type) {
    switch (type) {
      case MediaType.document:
        return FontAwesomeIcons.filePdf;
      case MediaType.text:
        return FontAwesomeIcons.fileLines;
      case MediaType.video:
        return FontAwesomeIcons.youtube;
      case MediaType.audio:
        return FontAwesomeIcons.fileAudio;
      case MediaType.image:
        return FontAwesomeIcons.fileImage;
    }
  }

  Widget _buildSourcesTab() {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (_sources == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_sources!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.layerGroup,
              size: 48,
              color: cs.onSurface.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Text(
              "No sources in this deck",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _sources!.length,
      itemBuilder: (context, i) {
        final source = _sources![i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child:
              ProjectCardTile(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    title: Text(source.label),
                    subtitle: Row(
                      children: [
                        FaIcon(
                          _getSourceIcon(source.type),
                          size: 10,
                          color: cs.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${source.type.name.toUpperCase()} | ${source.extractedContent?.length ?? 0} chars",
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                    leading: const WizardSourcePagePreview(),
                    onTap: () {
                      final isDesktop = ResponsiveBreakpoints.of(
                        context,
                      ).largerThan(MOBILE);
                      if (isDesktop) {
                        _loadPdf(source);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SourcePageLoader(
                              sourceId: source.id,
                              sourceLabel: source.label,
                            ),
                          ),
                        );
                      }
                    },
                  )
                  .animate()
                  .fadeIn(delay: (i * 50).ms)
                  .slideY(begin: 0.1, curve: Curves.easeOutQuad),
        );
      },
    );
  }

  Widget _buildDraftTab() {
    if (_controller.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 48,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              "No drafts yet",
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _controller.notes.length,
      itemBuilder: (context, index) {
        final draft = _controller.notes[index];
        final type = draft.noteType.value;
        return _DraftTile(index: index, type: type, draft: draft);
      },
    );
  }

  Widget _buildNotesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuoteWidget(),
        _buildNoteTypeSelector(),
        const SizedBox(height: 24),
        Expanded(child: SingleChildScrollView(child: _buildNoteFields())),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: () => _controller.addDraftNote(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Note'),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteWidget() {
    if (_controller.selectedText == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        _controller.setQuoteExpanded(!_controller.isQuoteExpanded);
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _controller.isQuoteFaded ? 0.3 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.quoteLeft,
                    size: 10,
                    color: cs.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Selected Text",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.primary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_controller.isQuoteExpanded)
                    Icon(
                      Icons.keyboard_arrow_up,
                      size: 14,
                      color: cs.primary.withValues(alpha: 0.5),
                    )
                  else
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: cs.primary.withValues(alpha: 0.5),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Text(
                  _controller.selectedText!,
                  maxLines: _controller.isQuoteExpanded ? null : 2,
                  overflow: _controller.isQuoteExpanded
                      ? null
                      : TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1, curve: Curves.easeOutQuart);
  }

  Widget _buildNoteFields() {
    switch (_controller.selectedNoteType) {
      case NoteType.basic:
      case NoteType.basicAndReversed:
        return _buildBasicFields();
      case NoteType.cloze:
        return _buildClozeFields();
      case NoteType.imageOcclusion:
        return _buildImageOcclusionFields();
      case NoteType.custom:
        // TODO: Implement custom field editor if needed for manual creation
        return const Center(
          child: Text("Custom note type - editing not yet supported"),
        );
    }
  }

  Widget _buildBasicFields() {
    return Column(
      children: [
        _buildTextField(
          label: 'Front',
          hint: 'Enter question...',
          minLines: 3,
          controller: _controller.frontController,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Back',
          hint: 'Enter answer...',
          minLines: 3,
          controller: _controller.backController,
        ),
      ],
    );
  }

  Widget _buildClozeFields() {
    return Column(
      children: [
        _buildTextField(
          label: 'Text',
          hint: 'Paste text here and use {{c1::...}} for clozes',
          minLines: 5,
          controller: _controller.clozeTextController,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Back Extra',
          hint: 'Extra information (optional)',
          minLines: 2,
          controller: _controller.clozeExtraController,
        ),
      ],
    );
  }

  Widget _buildImageOcclusionFields() {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        _buildTextField(
          label: 'Title',
          hint: 'Name this occlusion set',
          controller: _controller.occlusionTitleController,
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 48,
                color: cs.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Select an image or a PDF region',
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int minLines = 1,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            const Spacer(),
            _buildFieldActionButton(
              icon: Icons.undo_rounded,
              tooltip: 'Undo',
              onTap: () {
                // Flutter's built-in undo can be triggered via shortcut
                // but programmatic undo is tricky without a FocusNode
                // For now, let's at least have the UI
              },
            ),
            const SizedBox(width: 8),
            _buildFieldActionButton(
              icon: Icons.format_quote_rounded,
              tooltip: 'Paste Citation',
              onTap: _controller.selectedText == null
                  ? null
                  : () => _controller.pasteCitation(controller),
            ),
            const SizedBox(width: 8),
            _buildFieldActionButton(
              icon: Icons.delete_sweep_outlined,
              tooltip: 'Clear',
              onTap: () => controller.clear(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          minLines: minLines,
          maxLines: null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.primary.withValues(alpha: 0.5)),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldActionButton({
    required IconData icon,
    required String tooltip,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isEnabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isEnabled
                    ? cs.onSurface.withValues(alpha: 0.1)
                    : cs.onSurface.withValues(alpha: 0.05),
              ),
            ),
            child: Icon(
              icon,
              size: 14,
              color: isEnabled
                  ? cs.onSurface.withValues(alpha: 0.6)
                  : cs.onSurface.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteTypeSelector() {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final types = NoteType.values;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / types.length;
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuart,
                alignment: Alignment(
                  -1.0 +
                      (_controller.selectedNoteType.index *
                          (2.0 / (types.length - 1))),
                  0,
                ),
                child: Container(
                  width: itemWidth,
                  height: 72,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.primary.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                ),
              ),
              Row(
                children: types.map((type) {
                  final isSelected = _controller.selectedNoteType == type;
                  final isHovered = _hoveredNoteType == type;

                  return Expanded(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _hoveredNoteType = type),
                      onExit: (_) => setState(() => _hoveredNoteType = null),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _controller.setNoteType(type),
                          borderRadius: BorderRadius.circular(12),
                          hoverColor: cs.primary.withValues(alpha: 0.04),
                          splashColor: cs.primary.withValues(alpha: 0.08),
                          highlightColor: Colors.transparent,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 72,
                            padding: EdgeInsets.symmetric(
                              horizontal: _controller.isMaximized ? 12 : 0,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: _controller.isMaximized
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AnimatedScale(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          scale: isSelected || isHovered
                                              ? 1.05
                                              : 1.0,
                                          child: _NoteTypeIcon(
                                            type: type,
                                            isSelected: isSelected,
                                          ),
                                        ),
                                        AnimatedSize(
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          curve: Curves.easeOutQuart,
                                          child: _controller.isMaximized
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 12.0,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        _getNoteTypeLabel(type),
                                                        style: theme
                                                            .textTheme
                                                            .labelMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: isSelected
                                                                  ? cs.primary
                                                                  : cs.onSurface,
                                                            ),
                                                      ),
                                                      Text(
                                                        _getNoteTypeDescription(
                                                          type,
                                                        ),
                                                        style: theme
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              color: cs
                                                                  .onSurfaceVariant
                                                                  .withValues(
                                                                    alpha: 0.7,
                                                                  ),
                                                              fontSize: 10,
                                                            ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                    AnimatedSize(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeOutQuart,
                                      child: !_controller.isMaximized
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(height: 6),
                                                Text(
                                                  _getNoteTypeLabel(type),
                                                  style: theme
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                        fontWeight: isSelected
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        color: isSelected
                                                            ? cs.primary
                                                            : cs.onSurfaceVariant
                                                                  .withValues(
                                                                    alpha:
                                                                        isHovered
                                                                        ? 1
                                                                        : 0.6,
                                                                  ),
                                                        fontSize: 10,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getNoteTypeLabel(NoteType type) {
    switch (type) {
      case NoteType.basic:
        return "Basic";
      case NoteType.basicAndReversed:
        return "Reversed";
      case NoteType.cloze:
        return "Cloze";
      case NoteType.imageOcclusion:
        return "Occlusion";
      case NoteType.custom:
        return "Custom";
    }
  }

  String _getNoteTypeDescription(NoteType type) {
    switch (type) {
      case NoteType.basic:
        return "Standard front/back card";
      case NoteType.basicAndReversed:
        return "Two-way front/back card";
      case NoteType.cloze:
        return "Fill-in-the-blanks card";
      case NoteType.imageOcclusion:
        return "Hide parts of an image";
      case NoteType.custom:
        return "Imported custom note type";
    }
  }

  Future<void> _loadPdf(SourceItem source) async {
    setState(() {
      _selectedSource = source;
      _isLoadingPdf = true;
      _pdfBytes = null;
    });

    final sourceService = SourceService(context.read<AppDatabase>());
    final blob = await sourceService.getSourceBlobBySourceId(source.id);

    if (mounted && _selectedSource?.id == source.id) {
      setState(() {
        _pdfBytes = blob?.bytes;
        _isLoadingPdf = false;
        _controller.clearHover();
      });
    }
  }

  Widget _buildPdfHeader() {
    final theme = Theme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.7),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: Row(
            children: [
              FaIcon(
                _getSourceIcon(_selectedSource!.type),
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _selectedSource!.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => _controller.toggleInvert(),
                icon: Icon(
                  _controller.isInverted ? Icons.light_mode : Icons.dark_mode,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                tooltip: _controller.isInverted
                    ? "Light Mode"
                    : "Dark Mode (Invert)",
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => setState(() {
                  _selectedSource = null;
                  _pdfBytes = null;
                }),
                icon: const Icon(Icons.close, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                tooltip: "Close Viewer",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfViewer() {
    final theme = Theme.of(context);
    final originalBg = theme.colorScheme.surface;
    final backgroundColor = _controller.isInverted
        ? Color.fromARGB(
            255,
            (255 - originalBg.r * 255).round().clamp(0, 255),
            (255 - originalBg.g * 255).round().clamp(0, 255),
            (255 - originalBg.b * 255).round().clamp(0, 255),
          )
        : originalBg;

    Widget viewer = PdfViewer.data(
      _pdfBytes!,
      sourceName: _selectedSource!.label,
      controller: _controller.pdfController,
      params: PdfViewerParams(
        backgroundColor: backgroundColor,
        boundaryMargin: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 128,
        ),
        textSelectionParams: PdfTextSelectionParams(
          enabled: true,
          onTextSelectionChange: _controller.onSelectionChanged,
        ),
        buildContextMenu: (context, params) {
          if (params.contextMenuFor != PdfViewerPart.selectedText) return null;

          final items = [
            ContextMenuButtonItem(
              onPressed: () {
                params.textSelectionDelegate.copyTextSelection();
                params.dismissContextMenu();
              },
              type: ContextMenuButtonType.copy,
            ),
            ContextMenuButtonItem(
              onPressed: () {
                // TODO: Implement add to front
                params.dismissContextMenu();
              },
              label: 'Add to Front',
            ),
            ContextMenuButtonItem(
              onPressed: () {
                // TODO: Implement add to back
                params.dismissContextMenu();
              },
              label: 'Add to Back',
            ),
          ];

          return Align(
            alignment: Alignment.topLeft,
            child: AdaptiveTextSelectionToolbar.buttonItems(
              anchors: TextSelectionToolbarAnchors(
                primaryAnchor: params.anchorA,
                secondaryAnchor: params.anchorB,
              ),
              buttonItems: items,
            ),
          );
        },
        pagePaintCallbacks: [_paintHoverHighlight],
        onGeneralTap: (context, controller, details) {
          _controller.handleTap(details);
          return true;
        },
        pageBackgroundPaintCallbacks: [
          (canvas, pageRect, page) {
            final shadowColor = _controller.isInverted
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1);

            final paint = Paint()
              ..color = shadowColor
              ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

            canvas.drawRect(pageRect, paint);
          },
        ],
      ),
    );
    if (_controller.isInverted) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          -1,
          0,
          0,
          0,
          255,
          0,
          -1,
          0,
          0,
          255,
          0,
          0,
          -1,
          0,
          255,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: viewer,
      );
    }
    return viewer;
  }

  void _paintHoverHighlight(Canvas canvas, Rect pageRect, PdfPage page) {
    _controller.paintHoverHighlight(
      canvas,
      pageRect,
      page,
      Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildMainContent(BuildContext context) {
    if (_selectedSource == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.filePdf,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            const SizedBox(height: 16),
            Text(
              "Select a source to view",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoadingPdf) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pdfBytes == null) {
      return const Center(child: Text("Could not load PDF bytes"));
    }

    return ClipRect(
      child: MouseRegion(
        onHover: (event) async {
          if (_pdfBytes == null) return;
          final result = _controller.pdfController.getPdfPageHitTestResult(
            event.localPosition,
            useDocumentLayoutCoordinates: false,
          );

          if (result != null) {
            final pageText = await result.page.loadStructuredText();
            final charIndex = PdfTextBoundaryDetector.findNearestCharIndex(
              pageText,
              result.offset,
            );
            _controller.handleHover(
              result.page.pageNumber,
              charIndex,
              pageText,
            );
          } else {
            _controller.clearHover();
          }
        },
        onExit: (_) => _controller.clearHover(),
        child: Stack(
          children: [
            Positioned.fill(child: _buildPdfViewer()),
            Positioned(top: 0, left: 0, right: 0, child: _buildPdfHeader()),
            _buildPreviewOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewOverlay(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final previewIndex =
        _controller.clickedDraftIndex ?? _controller.hoveredDraftIndex;

    return Positioned(
      bottom: 24,
      left: 64,
      right: 64,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeInCubic,
                    ),
                  ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: (previewIndex == null)
              ? const SizedBox.shrink()
              : KeyedSubtree(
                  key: const ValueKey('preview-container'),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Container(
                      height: 180,
                      padding: const EdgeInsets.all(24),
                      decoration: ShapeDecoration(
                        color: theme.colorScheme.surface,
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: BorderSide(
                            color: cs.onSurface.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: cs.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.visibility_outlined,
                                  size: 20,
                                  color: cs.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Note Preview",
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Draft #${previewIndex + 1}",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              if (_controller.clickedDraftIndex != null) ...[
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit_note, size: 18),
                                  label: const Text("Edit"),
                                ),
                                const SizedBox(width: 8),
                              ],
                              IconButton(
                                onPressed: () {
                                  _controller.setClickedDraftIndex(null);
                                  _controller.setHoveredDraftIndex(null);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: _buildPreviewContent(
                              _controller.notes[previewIndex],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDraggableBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: ShapeDecoration(
            color: theme.colorScheme.surface,
            shape: RoundedSuperellipseBorder(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              side: BorderSide(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.1,
                ),
                width: 1,
              ),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Note Details',
                          style: theme.textTheme.titleMedium?.copyWith(
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
        );
      },
    );
  }
}

class _NoteTypeIcon extends StatelessWidget {
  final NoteType type;
  final bool isSelected;

  const _NoteTypeIcon({required this.type, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = cs.primary;

    switch (type) {
      case NoteType.basic:
        return _BasicIcon(color: color);
      case NoteType.basicAndReversed:
        return _ReversedIcon(color: color);
      case NoteType.cloze:
        return _ClozeIcon(color: color);
      case NoteType.imageOcclusion:
        return _ImageOcclusionIcon(color: color);
      case NoteType.custom:
        return Icon(FontAwesomeIcons.gears, color: color, size: 16);
    }
  }
}

class _BasicIcon extends StatelessWidget {
  final Color color;
  const _BasicIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 3,
          width: 20,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 3,
          width: 14,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ],
    );
  }
}

class _ReversedIcon extends StatelessWidget {
  final Color color;
  const _ReversedIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.rightLeft,
          size: 18,
          color: color.withValues(alpha: 0.8),
        ),
      ],
    );
  }
}

class _ClozeIcon extends StatelessWidget {
  final Color color;
  const _ClozeIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "[...]",
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ImageOcclusionIcon extends StatelessWidget {
  final Color color;
  const _ImageOcclusionIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.image,
          size: 20,
          color: color.withValues(alpha: 0.5),
        ),
        Positioned(
          top: 8,
          left: 6,
          child: Container(
            width: 12,
            height: 8,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

class _DraftTile extends StatelessWidget {
  final int index;
  final NoteType type;
  final NoteItemsCompanion draft;

  const _DraftTile({
    required this.index,
    required this.type,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final controller = context.watch<NoteTakingController>();

    final isHovered = controller.hoveredDraftIndex == index;
    final isClicked = controller.clickedDraftIndex == index;
    final isOcclusion = type == NoteType.imageOcclusion;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => controller.setHoveredDraftIndex(index),
        onExit: (_) => controller.setHoveredDraftIndex(null),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                controller.setClickedDraftIndex(isClicked ? null : index),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isClicked
                    ? cs.primary.withValues(alpha: 0.08)
                    : isHovered
                    ? cs.surfaceContainerHighest.withValues(alpha: 0.5)
                    : cs.surfaceContainerHighest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isClicked
                      ? cs.primary.withValues(alpha: 0.4)
                      : isHovered
                      ? cs.outlineVariant.withValues(alpha: 0.5)
                      : cs.outlineVariant.withValues(alpha: 0.1),
                  width: isClicked ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTypeIcon(context, isClicked || isHovered),
                      const SizedBox(width: 16),
                      Expanded(
                        child: isOcclusion
                            ? _buildOcclusionContent(context)
                            : _buildTextContent(context),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            axisAlignment: -1,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                    child: isClicked
                        ? Column(
                            key: const ValueKey('controls'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              Divider(
                                height: 1,
                                color: cs.outlineVariant.withValues(alpha: 0.2),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () =>
                                        controller.removeDraftNote(index),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: Colors.redAccent,
                                    ),
                                    label: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: cs.primary,
                                      foregroundColor: cs.onPrimary,
                                      elevation: 0,
                                    ),
                                    icon: const Icon(Icons.check, size: 18),
                                    label: const Text("Finalize"),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(key: ValueKey('empty')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getDraftTitle() {
    switch (type) {
      case NoteType.basic:
      case NoteType.basicAndReversed:
        final val = draft.front.value;
        return (val == null || val.isEmpty) ? 'No front content' : val;
      case NoteType.cloze:
        final val = draft.content.value;
        return (val == null || val.isEmpty) ? 'No content' : val;
      case NoteType.imageOcclusion:
        return 'Image Occlusion';
      case NoteType.custom:
        return 'Custom Note';
    }
  }

  String _getDraftSubtitle() {
    switch (type) {
      case NoteType.basic:
      case NoteType.basicAndReversed:
        return draft.back.value ?? '';
      case NoteType.cloze:
      case NoteType.imageOcclusion:
        return '';
      case NoteType.custom:
        return 'Custom content';
    }
  }

  bool _hasSecondField() {
    return type == NoteType.basic || type == NoteType.basicAndReversed;
  }

  Widget _buildTypeIcon(BuildContext context, bool isActive) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(
          alpha: isActive ? 0.8 : 0.4,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Transform.scale(
          scale: 1.1,
          child: _NoteTypeIcon(type: type, isSelected: isActive),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (type == NoteType.cloze) {
      return Text(
        _getDraftTitle(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.8),
          height: 1.4,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _getDraftTitle(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (_hasSecondField()) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Divider(
              height: 1,
              color: cs.onSurface.withValues(alpha: 0.15),
            ),
          ),
          Text(
            _getDraftSubtitle(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildOcclusionContent(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 70,
          height: 46,
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Icon(
            Icons.image_outlined,
            size: 24,
            color: cs.onSurface.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Image Occlusion",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "Draft Note",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
