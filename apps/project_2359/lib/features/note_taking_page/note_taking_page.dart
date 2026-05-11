import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/desktop_title_bar_controller.dart';
import 'package:project_2359/core/widgets/adaptive_pane_layout.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/features/collection_page/widgets/shared_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/enums/media_type.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:shared_core/shared_core.dart';

enum NoteType { basic, basicReversed, cloze, imageOcclusion }

class NoteTakingPage extends StatefulWidget {
  final String collectionId;
  final String? deckId;
  final String? draftId;

  const NoteTakingPage({
    super.key,
    required this.collectionId,
    this.deckId,
    this.draftId,
  });

  @override
  State<NoteTakingPage> createState() => _NoteTakingPageState();
}

class _NoteTakingPageState extends State<NoteTakingPage> {
  int _selectedTabIndex = 0;
  late PageController _pageController;
  bool _isMaximized = false;
  List<SourceItem>? _sources;
  StreamSubscription? _sourcesSub;
  SourceItem? _selectedSource;
  Uint8List? _pdfBytes;
  bool _isLoadingPdf = false;
  bool _isInverted = false;
  late PdfViewerController _pdfController;
  NoteType _selectedNoteType = NoteType.basic;
  NoteType? _hoveredNoteType;

  // Hover highlighting state
  int? _hoveredPageNumber;
  int? _hoveredCharIndex;
  PdfPageText? _hoveredPageText;
  (int, int)? _hoveredSentenceBounds;
  (int, int)? _hoveredParagraphBounds;
  String? _selectedText;
  Timer? _quoteFadeTimer;
  bool _isQuoteExpanded = false;
  bool _isQuoteFaded = false;

  final TextEditingController _frontController = TextEditingController();
  final TextEditingController _backController = TextEditingController();
  final TextEditingController _clozeTextController = TextEditingController();
  final TextEditingController _clozeExtraController = TextEditingController();
  final TextEditingController _occlusionTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _pageController = PageController(initialPage: _selectedTabIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitleBar();
    });

    final sourceService = SourceService(context.read<AppDatabase>());
    _sourcesSub = sourceService
        .watchSourcesByCollectionId(widget.collectionId)
        .listen((sources) {
          if (mounted) setState(() => _sources = sources);
        });
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
    _pageController.dispose();
    _sourcesSub?.cancel();
    _quoteFadeTimer?.cancel();
    _frontController.dispose();
    _backController.dispose();
    _clozeTextController.dispose();
    _clozeExtraController.dispose();
    _occlusionTitleController.dispose();
    // Reset title bar when leaving the page
    Future.microtask(() {
      if (mounted) {
        context.read<DesktopTitleBarController>().reset();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    if (isDesktop) {
      return _buildDesktopLayout(context);
    }

    return _buildMobileLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final masterWidth = _isMaximized ? screenWidth * 0.8 : screenWidth * 0.25;

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
                      onPressed: () =>
                          setState(() => _isMaximized = !_isMaximized),
                      icon: Icon(
                        _isMaximized ? Icons.fullscreen_exit : Icons.fullscreen,
                      ),
                      tooltip: _isMaximized ? 'Restore' : 'Maximize',
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
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) =>
                    setState(() => _selectedTabIndex = index),
                children: [
                  _buildTabContent('Notes Content'),
                  _buildSourcesTab(),
                  _buildTabContent('Draft Content'),
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
            alignment: Alignment(-1.0 + (_selectedTabIndex * 1.0), 0),
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
              final isSelected = _selectedTabIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedTabIndex = index);
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuart,
                    );
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
              "No sources in this collection",
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

  Widget _buildTabContent(String placeholder) {
    if (placeholder == 'Notes Content') {
      return _buildNotesTab();
    }
    return Center(
      child: Text(
        placeholder,
        style: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
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
      ],
    );
  }

  Widget _buildQuoteWidget() {
    if (_selectedText == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isQuoteExpanded = !_isQuoteExpanded;
          if (_isQuoteExpanded) {
            _isQuoteFaded = false;
            _quoteFadeTimer?.cancel();
          } else {
            _quoteFadeTimer?.cancel();
            _quoteFadeTimer = Timer(const Duration(seconds: 5), () {
              if (mounted) setState(() => _isQuoteFaded = true);
            });
          }
        });
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _isQuoteFaded ? 0.3 : 1.0,
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
                  if (_isQuoteExpanded)
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
                  _selectedText!,
                  maxLines: _isQuoteExpanded ? null : 2,
                  overflow: _isQuoteExpanded ? null : TextOverflow.ellipsis,
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
    switch (_selectedNoteType) {
      case NoteType.basic:
      case NoteType.basicReversed:
        return _buildBasicFields();
      case NoteType.cloze:
        return _buildClozeFields();
      case NoteType.imageOcclusion:
        return _buildImageOcclusionFields();
    }
  }

  Widget _buildBasicFields() {
    return Column(
      children: [
        _buildTextField(
          label: 'Front',
          hint: 'Enter question...',
          minLines: 3,
          controller: _frontController,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Back',
          hint: 'Enter answer...',
          minLines: 3,
          controller: _backController,
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
          controller: _clozeTextController,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Back Extra',
          hint: 'Extra information (optional)',
          minLines: 2,
          controller: _clozeExtraController,
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
          controller: _occlusionTitleController,
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
              onTap: _selectedText == null
                  ? null
                  : () {
                      final text = controller.text;
                      final selection = controller.selection;
                      final cited = _selectedText!;
                      
                      if (selection.isValid) {
                        final newText = text.replaceRange(
                          selection.start,
                          selection.end,
                          cited,
                        );
                        controller.value = TextEditingValue(
                          text: newText,
                          selection: TextSelection.collapsed(
                            offset: selection.start + cited.length,
                          ),
                        );
                      } else {
                        controller.text = text + cited;
                      }
                    },
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
                  -1.0 + (_selectedNoteType.index * (2.0 / (types.length - 1))),
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
                  final isSelected = _selectedNoteType == type;
                  final isHovered = _hoveredNoteType == type;

                  return Expanded(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _hoveredNoteType = type),
                      onExit: (_) => setState(() => _hoveredNoteType = null),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => setState(() => _selectedNoteType = type),
                          borderRadius: BorderRadius.circular(12),
                          hoverColor: cs.primary.withValues(alpha: 0.04),
                          splashColor: cs.primary.withValues(alpha: 0.08),
                          highlightColor: Colors.transparent,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 72,
                            padding: EdgeInsets.symmetric(
                              horizontal: _isMaximized ? 12 : 0,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: _isMaximized
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
                                          child: _isMaximized
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
                                      child: !_isMaximized
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
      case NoteType.basicReversed:
        return "Reversed";
      case NoteType.cloze:
        return "Cloze";
      case NoteType.imageOcclusion:
        return "Occlusion";
    }
  }

  String _getNoteTypeDescription(NoteType type) {
    switch (type) {
      case NoteType.basic:
        return "Standard front/back card";
      case NoteType.basicReversed:
        return "Two-way front/back card";
      case NoteType.cloze:
        return "Fill-in-the-blanks card";
      case NoteType.imageOcclusion:
        return "Hide parts of an image";
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
        _clearHover();
      });
    }
  }

  void _onHover(PointerEvent event) async {
    if (_pdfBytes == null) return;

    final result = _pdfController.getPdfPageHitTestResult(
      event.localPosition,
      useDocumentLayoutCoordinates: false,
    );

    if (result != null) {
      final page = result.page;
      final point = result.offset; // PDF coordinates

      // Load text for the page
      final pageText = await page.loadStructuredText();

      // Find character index (even between gaps)
      final charIndex = PdfTextBoundaryDetector.findNearestCharIndex(
        pageText,
        point,
      );

      if (charIndex != null) {
        if (_hoveredPageNumber != page.pageNumber ||
            _hoveredCharIndex != charIndex) {
          final sentenceBounds = PdfTextBoundaryDetector.findSentenceBounds(
            pageText,
            charIndex,
          );
          final paragraphBounds = PdfTextBoundaryDetector.findParagraphBounds(
            pageText,
            charIndex,
          );

          if (mounted) {
            setState(() {
              _hoveredPageNumber = page.pageNumber;
              _hoveredCharIndex = charIndex;
              _hoveredPageText = pageText;
              _hoveredSentenceBounds = sentenceBounds;
              _hoveredParagraphBounds = paragraphBounds;
            });
          }
        }
      } else {
        _clearHover();
      }
    } else {
      _clearHover();
    }
  }

  void _clearHover() {
    if (_hoveredCharIndex != null) {
      setState(() {
        _hoveredPageNumber = null;
        _hoveredCharIndex = null;
        _hoveredPageText = null;
        _hoveredSentenceBounds = null;
        _hoveredParagraphBounds = null;
      });
    }
  }

  void _paintHoverHighlight(Canvas canvas, Rect pageRect, PdfPage page) {
    if (_hoveredPageNumber != page.pageNumber || _hoveredPageText == null) {
      return;
    }

    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // 1. Draw Paragraph (Subtle)
    if (_hoveredParagraphBounds != null) {
      final (start, end) = _hoveredParagraphBounds!;
      final range = _hoveredPageText!.getRangeFromAB(start, end - 1);
      final paint =
          Paint()
            ..color = primaryColor.withValues(alpha: 0.08)
            ..style = PaintingStyle.fill;

      for (final rect in range.enumerateFragmentBoundingRects()) {
        final flutterRect = rect.bounds.toRectInDocument(
          page: page,
          pageRect: pageRect,
        );
        canvas.drawRect(flutterRect, paint);
      }
    }

    // 2. Draw Sentence (More Visible)
    if (_hoveredSentenceBounds != null) {
      final (start, end) = _hoveredSentenceBounds!;
      final range = _hoveredPageText!.getRangeFromAB(start, end - 1);
      final paint =
          Paint()
            ..color = primaryColor.withValues(alpha: 0.2)
            ..style = PaintingStyle.fill;

      for (final rect in range.enumerateFragmentBoundingRects()) {
        final flutterRect = rect.bounds.toRectInDocument(
          page: page,
          pageRect: pageRect,
        );
        canvas.drawRect(flutterRect, paint);
      }
    }
  }

  bool _onGeneralTap(
    BuildContext context,
    PdfViewerController controller,
    PdfViewerGeneralTapHandlerDetails details,
  ) {
    if (details.type == PdfViewerGeneralTapType.tap ||
        details.type == PdfViewerGeneralTapType.doubleTap) {
      final result = _pdfController.getPdfPageHitTestResult(
        details.documentPosition,
        useDocumentLayoutCoordinates: true,
      );

      if (result != null) {
        _selectSmartly(result.page, result.offset, details.type);
        return true;
      }
    }
    return false;
  }

  Future<void> _selectSmartly(
    PdfPage page,
    PdfPoint point,
    PdfViewerGeneralTapType tapType,
  ) async {
    final pageText = await page.loadStructuredText();
    final charIndex = PdfTextBoundaryDetector.findNearestCharIndex(
      pageText,
      point,
    );
    if (charIndex == null) return;

    final bounds =
        (tapType == PdfViewerGeneralTapType.doubleTap)
            ? PdfTextBoundaryDetector.findParagraphBounds(pageText, charIndex)
            : PdfTextBoundaryDetector.findSentenceBounds(pageText, charIndex);

    final range = PdfTextSelectionRange.fromPoints(
      PdfTextSelectionPoint(pageText, bounds.$1),
      PdfTextSelectionPoint(pageText, bounds.$2 - 1),
    );

    _pdfController.textSelectionDelegate.setTextSelectionPointRange(range);
  }

  Future<void> _onSelectionChanged(PdfTextSelection selection) async {
    _quoteFadeTimer?.cancel();
    if (selection.hasSelectedText) {
      final text = await selection.getSelectedText();
      if (mounted) {
        setState(() {
          _selectedText = text;
          _isQuoteFaded = false;
          _isQuoteExpanded = false;
        });
        _quoteFadeTimer = Timer(const Duration(seconds: 5), () {
          if (mounted) setState(() => _isQuoteFaded = true);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedText = null;
          _isQuoteFaded = false;
          _isQuoteExpanded = false;
        });
      }
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
                onPressed: () => setState(() => _isInverted = !_isInverted),
                icon: Icon(
                  _isInverted ? Icons.light_mode : Icons.dark_mode,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                tooltip: _isInverted ? "Light Mode" : "Dark Mode (Invert)",
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => setState(() {
                  _selectedSource = null;
                  _pdfBytes = null;
                  _isInverted = false;
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
    // If inverted, we pre-invert the background color so the global ColorFiltered
    // inverts it back to its original state.
    final backgroundColor = _isInverted
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
      controller: _pdfController,
      params: PdfViewerParams(
        backgroundColor: backgroundColor,
        boundaryMargin: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 128,
        ),
        textSelectionParams: PdfTextSelectionParams(
          enabled: true,
          onTextSelectionChange: _onSelectionChanged,
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
        onGeneralTap: _onGeneralTap,
        pageBackgroundPaintCallbacks: [
          (canvas, pageRect, page) {
            final shadowColor = _isInverted
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1);

            final paint = Paint()
              ..color = shadowColor
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

            // Draw a subtle shadow behind the page
            canvas.drawRect(pageRect.shift(const Offset(2, 4)), paint);
          },
        ],
      ),
    );

    viewer = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        final result = _pdfController.getPdfPageHitTestResult(
          details.localPosition,
          useDocumentLayoutCoordinates: false,
        );
        if (result != null) {
          _selectSmartly(
            result.page,
            result.offset,
            PdfViewerGeneralTapType.tap,
          );
        }
      },
      child: viewer,
    );

    viewer = MouseRegion(
      onHover: _onHover,
      onExit: (_) => _clearHover(),
      child: viewer,
    );

    if (_isInverted) {
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
      child: Stack(
        children: [
          Positioned.fill(child: _buildPdfViewer()),
          Positioned(top: 0, left: 0, right: 0, child: _buildPdfHeader()),
        ],
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
    final color = isSelected ? cs.primary : cs.onSurface.withValues(alpha: 0.2);

    switch (type) {
      case NoteType.basic:
        return _BasicIcon(color: color);
      case NoteType.basicReversed:
        return _ReversedIcon(color: color);
      case NoteType.cloze:
        return _ClozeIcon(color: color);
      case NoteType.imageOcclusion:
        return _ImageOcclusionIcon(color: color);
    }
  }
}

class _BasicIcon extends StatelessWidget {
  final Color color;
  const _BasicIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 2,
            width: 16,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 12,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReversedIcon extends StatelessWidget {
  final Color color;
  const _ReversedIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: [
          Positioned(
            left: 2,
            top: 2,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withValues(alpha: 0.1)),
              ),
            ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.rightLeft,
                  size: 10,
                  color: color.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClozeIcon extends StatelessWidget {
  final Color color;
  const _ClozeIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "[...]",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
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
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.image,
            size: 14,
            color: color.withValues(alpha: 0.2),
          ),
          Positioned(
            top: 10,
            left: 8,
            child: Container(
              width: 10,
              height: 6,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
