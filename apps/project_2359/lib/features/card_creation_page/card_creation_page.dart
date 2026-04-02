import 'dart:async';
import 'dart:typed_data';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/features/card_creation_page/expandable_card_creation_toolbar.dart';
import 'package:provider/provider.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/settings/labs_settings.dart';
import 'package:project_2359/core/widgets/expandable_container.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/features/card_creation_page/smart_text_selection_handler.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/widgets/pdf_occlusion_overlay.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:project_2359/core/widgets/shortcut_widgets.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CardCreationPage extends StatefulWidget {
  final String folderId;
  const CardCreationPage({super.key, required this.folderId});

  @override
  State<CardCreationPage> createState() => _CardCreationPageState();
}

class _CardCreationPageState extends State<CardCreationPage> {
  Uint8List? _pdfBytes;
  String? _pdfTitle;
  PdfDocument? _document;
  List<SourceItem>? _availableSources;
  StreamSubscription? _sourcesSub;
  PdfViewerController _controller = PdfViewerController();
  final SmartTextSelectionHandler _smartSelection =
      const SmartTextSelectionHandler();
  bool _isLoading = false;
  final ValueNotifier<dynamic> _selectionNotifier = ValueNotifier(null);
  final ValueNotifier<String?> _selectedTextNotifier = ValueNotifier(null);
  final CardCreationToolbarController _toolbarController =
      CardCreationToolbarController();
  late final ExpandableContainerController _containerController;

  /// Incremented on each document load to force a full PdfViewer remount,
  /// which clears all internal caches (image cache, text cache, layout, etc.).
  int _pdfKey = 0;
  String? _currentSourceId;

  @override
  void initState() {
    super.initState();
    _containerController = ExpandableContainerController(
      isVisible: _pdfBytes != null,
    );
    _initSources();
    _toolbarController.addListener(_onToolbarChanged);
  }

  void _initSources() {
    final service = context.read<SourceService>();
    _sourcesSub = service.watchSourcesByFolderId(widget.folderId).listen((
      sources,
    ) {
      if (mounted) {
        setState(() {
          _availableSources = sources;
        });
      }
    });

    _registerNumericShortcuts();
  }

  void _registerNumericShortcuts() {
    final keys = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
      LogicalKeyboardKey.digit9,
      LogicalKeyboardKey.digit0,
    ];

    for (int i = 0; i < 10; i++) {
      ProjectShortcutManager.registerShortcut(
        ShortcutInfo(
          label: 'Select Source ${i + 1}',
          key: keys[i],
          modifiers: [ShortcutModifier.alt],
        ),
        () {
          if (_pdfBytes == null &&
              _availableSources != null &&
              _availableSources!.length > i) {
            _loadSource(_availableSources![i]);
          }
        },
      );
    }
  }

  void _unregisterNumericShortcuts() {
    final keys = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
      LogicalKeyboardKey.digit9,
      LogicalKeyboardKey.digit0,
    ];
    for (int i = 0; i < 10; i++) {
      ProjectShortcutManager.unregisterShortcut(
        ShortcutInfo(
          label: 'Select Source ${i + 1}',
          key: keys[i],
          modifiers: [ShortcutModifier.alt],
        ),
      );
    }
  }

  @override
  void dispose() {
    _sourcesSub?.cancel();
    _unregisterNumericShortcuts();
    _selectionNotifier.dispose();
    _selectedTextNotifier.dispose();
    _toolbarController.dispose();
    super.dispose();
  }

  void _onToolbarChanged() {
    final requestedId = _toolbarController.requestedSourceId;
    if (requestedId != null) {
      final source = _availableSources?.firstWhere((s) => s.id == requestedId);
      if (source != null) {
        _loadSource(source);
        _toolbarController.setMode(CardCreationToolbarMode.collapsed);
      }
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    // Hot reload invalidates the native render context.
    // Force a full PdfViewer remount so it rebuilds cleanly.
    if (_pdfBytes != null) {
      setState(() {
        // _controller.dispose(); // Does not exist apparently
        _controller = PdfViewerController();
        _pdfKey++;
        _document = null;
      });
    }
  }

  Future<void> _loadSource(SourceItem source) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final service = context.read<SourceService>();
      final blob = await service.getSourceBlobBySourceId(source.id);
      if (blob != null && mounted) {
        setState(() {
          // Create a fresh controller so the new PdfViewer has clean state.
          _controller = PdfViewerController();
          _pdfKey++;
          _document = null;
          _selectionNotifier.value = null;
          _selectedTextNotifier.value = null;
          _pdfBytes = blob.bytes;
          _pdfTitle = source.label;
          _currentSourceId = source.id;
          _containerController.setVisible(true);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load PDF: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: labsSettings,
      builder: (context, _) {
        return ExpandableContainer(
          initialAlignment: Alignment.bottomCenter,
          boundaryMargins: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 2,
          ),
          initialBorder: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
            width: 1,
          ),
          controller: _containerController,
          builder: (context, controller) => ExpandableCardCreationToolbar(
            context: context,
            containerController: controller,
            toolbarController: _toolbarController,
            selectionNotifier: _selectionNotifier,
            selectedTextNotifier: _selectedTextNotifier,
          ),
          child: Scaffold(
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                _pdfTitle ?? 'Create Card',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      color: Colors.black.withValues(alpha: 0.6),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              leadingWidth: 120, // accommodate 'Back' text + shortcut
              leading: ProjectBackButton(
                color: Colors.white,
                onPressed: () {
                  if (_pdfBytes != null) {
                    setState(() {
                      _controller = PdfViewerController();
                      _pdfBytes = null;
                      _pdfTitle = null;
                      _document = null;
                      _currentSourceId = null;
                      _selectionNotifier.value = null;
                      _selectedTextNotifier.value = null;
                      _containerController.setVisible(false);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: _buildPdfView(),
          ),
        );
      },
    );
  }

  Widget _buildPdfView() {
    if (_pdfBytes == null) {
      return _buildPdfList(context);
    }

    return KeyedSubtree(
      key: ValueKey(_pdfKey),
      child: ListenableBuilder(
        listenable: _toolbarController,
        builder: (context, _) {
          return Stack(
            children: [
              PdfViewer.data(
                _pdfBytes!,
                sourceName: 'pdf_$_currentSourceId',
                controller: _controller,
                useProgressiveLoading: true,
                params: PdfViewerParams(
                  boundaryMargin: const EdgeInsets.symmetric(horizontal: 256),
                  margin: 8,
                  onViewerReady: (doc, controller) {
                    if (mounted) {
                      setState(() {
                        _document = doc;
                      });
                    }
                  },
                  backgroundColor: Colors.black,
                  textSelectionParams: PdfTextSelectionParams(
                    enabled: true,
                    onTextSelectionChange: (pdfTextSelection) {
                      _selectionNotifier.value = pdfTextSelection;
                      pdfTextSelection.getSelectedText().then((text) {
                        if (_selectionNotifier.value == pdfTextSelection) {
                          _selectedTextNotifier.value = text;
                        }
                      });
                    },
                  ),
                  onGeneralTap: labsSettings.smartSelectionEnabled
                      ? _smartSelection.handleTap
                      : null,
                ),
              ),
              if (_toolbarController.mode ==
                  CardCreationToolbarMode.imageOcclusion)
                PdfOcclusionOverlay(
                  controller: _controller,
                  toolbarController: _toolbarController,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPdfList(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 720,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: topPadding + kToolbarHeight + 24),
              const SectionLabel(title: "Select Document"),
              const SizedBox(height: 16),

              if (_availableSources == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_availableSources!.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      "No sources in this folder",
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TODO: Make this use a list view
                    for (var i = 0; i < _availableSources!.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child:
                            ProjectCardTile(
                                  backgroundColor: cs.surfaceContainerHighest
                                      .withValues(alpha: 0.5),
                                  minHeight: 100,
                                  title: ShortcutDisplay(
                                    showInline: true,
                                    info: i < 10
                                        ? ShortcutInfo(
                                            label: 'Select',
                                            key: [
                                              LogicalKeyboardKey.digit1,
                                              LogicalKeyboardKey.digit2,
                                              LogicalKeyboardKey.digit3,
                                              LogicalKeyboardKey.digit4,
                                              LogicalKeyboardKey.digit5,
                                              LogicalKeyboardKey.digit6,
                                              LogicalKeyboardKey.digit7,
                                              LogicalKeyboardKey.digit8,
                                              LogicalKeyboardKey.digit9,
                                              LogicalKeyboardKey.digit0,
                                            ][i],
                                            modifiers: [ShortcutModifier.alt],
                                          )
                                        : null,
                                    child: Text(_availableSources![i].label),
                                  ),
                                  subtitle: Text(
                                    "${_availableSources![i].type.toUpperCase()} | ${_availableSources![i].extractedContent?.length ?? 0} chars",
                                  ),
                                  leading: const WizardSourcePagePreview(),
                                  onTap: () =>
                                      _loadSource(_availableSources![i]),
                                )
                                .animate()
                                .fadeIn(delay: (i * 100).ms)
                                .slideY(begin: 0.1, curve: Curves.easeOutQuad),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
