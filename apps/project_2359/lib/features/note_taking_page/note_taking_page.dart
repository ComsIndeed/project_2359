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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTabIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitleBar();
    });

    final sourceService = SourceService(context.read<AppDatabase>());
    _sourcesSub = sourceService.watchSourcesByCollectionId(widget.collectionId).listen((sources) {
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
        masterWidth: masterWidth,
        master: (context, controller) => _buildSidePanel(context, controller, isCollapsed: false),
        masterCollapsed: (context, controller) => _buildSidePanel(context, controller, isCollapsed: true),
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

  Widget _buildSidePanel(BuildContext context, AdaptivePaneController controller, {required bool isCollapsed}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [
              if (!isCollapsed)
                Expanded(
                  child: _buildTabSwitcher(),
                ),
              if (!isCollapsed) const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isCollapsed)
                    IconButton(
                      onPressed: () => setState(() => _isMaximized = !_isMaximized),
                      icon: Icon(_isMaximized ? Icons.fullscreen_exit : Icons.fullscreen),
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
                onPageChanged: (index) => setState(() => _selectedTabIndex = index),
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
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
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
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
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
          child: ProjectCardTile(
            backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
              final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
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
    return Center(
      child: Text(
        placeholder,
        style: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
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

  Widget _buildMainContent(BuildContext context) {
    if (_selectedSource == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.filePdf,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            const SizedBox(height: 16),
            Text(
              "Select a source to view",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
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
          Positioned.fill(
            child: PdfViewer.data(
              _pdfBytes!,
              sourceName: _selectedSource!.label,
              params: PdfViewerParams(
                backgroundColor: Theme.of(context).colorScheme.surface,
                boundaryMargin: const EdgeInsets.only(top: 48, bottom: 16),
                textSelectionParams: const PdfTextSelectionParams(
                  enabled: true,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildPdfHeader(),
          ),
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              side: BorderSide(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
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
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
