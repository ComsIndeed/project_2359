import 'dart:async';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/core/app_controller.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar.dart';
import 'package:provider/provider.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/settings/labs_settings.dart';
import 'package:project_2359/core/widgets/expandable_container.dart';
import 'package:project_2359/features/card_creation_page/smart_text_selection_handler.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/card_creation_pdf_view.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:project_2359/core/widgets/desktop_title_bar_controller.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uuid/uuid.dart';

class CardCreationPage extends StatefulWidget {
  final String collectionId;
  final String? deckId;

  /// Leave null for new
  final String? draftId;

  const CardCreationPage({
    super.key,
    required this.collectionId,
    this.deckId,
    this.draftId,
  });

  @override
  State<CardCreationPage> createState() => _CardCreationPageState();
}

class _CardCreationPageState extends State<CardCreationPage> {
  late String _targetDeckId;
  late String _currentDraftId;
  Uint8List? _pdfBytes;
  String? _pdfTitle;
  List<SourceItem>? _availableSources;
  StreamSubscription? _sourcesSub;
  PdfViewerController _controller = PdfViewerController();
  final SmartTextSelectionHandler _smartSelection =
      const SmartTextSelectionHandler();
  bool _isLoading = false;
  final ValueNotifier<dynamic> _selectionNotifier = ValueNotifier(null);
  final ValueNotifier<String?> _selectedTextNotifier = ValueNotifier(null);
  late final CardCreationToolbarController _toolbarController;
  late final ExpandableContainerController _containerController;

  /// Incremented on each document load to force a full PdfViewer remount,
  /// which clears all internal caches (image cache, text cache, layout, etc.).
  int _pdfKey = 0;
  String? _currentSourceId;

  @override
  void initState() {
    super.initState();

    // IDs
    final uuid = const Uuid();
    _targetDeckId = widget.deckId ?? uuid.v4();
    _currentDraftId = widget.draftId ?? uuid.v4();

    // Toolbar Controller
    _toolbarController =
        CardCreationToolbarController(
          draftService: context.read<AppController>().draftService,
        )..setDraftDetails(
          draftId: _currentDraftId,
          targetDeckId: _targetDeckId,
          collectionId: widget.collectionId,
        );

    // Container Controller
    _containerController = ExpandableContainerController(
      isVisible: true, // Always visible to show the toolbar initially
    );

    // Initial Deck Name
    if (widget.deckId != null) {
      context
          .read<AppController>()
          .studyDatabaseService
          .getDeckById(widget.deckId!)
          .then((deck) {
            if (deck != null && mounted) {
              _toolbarController.deckNameController.text = deck.name;
            }
          });
    }

    // Sources
    _initSources();
    _toolbarController.addListener(_onToolbarChanged);

    // Set initial mode to pdfList
    _toolbarController.setMode(CardCreationToolbarMode.sourcesList);

    // If we're resuming a draft, load the session data
    if (widget.draftId != null) {
      _loadDraft();
    }

    AppLogger.info(
      'CardCreationPage: opened draft $_currentDraftId of deck $_targetDeckId as ${widget.draftId != null ? 'RESUMING' : 'NEW'}',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitleBar();
    });
  }

  void _updateTitleBar() {
    if (!mounted) return;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    if (!isDesktop) return;

    final titleBar = context.read<DesktopTitleBarController>();
    titleBar.setCenteredTitle(_pdfTitle ?? 'Card Creation');
    
    // "no top bar" look - make it transparent
    titleBar.setIsTransparent(true);
    
    // Always show back button so user can exit list
    titleBar.setHideBack(false);
    titleBar.setOnBack(_handleBack);
  }

  void _handleBack() {
    if (_pdfBytes != null) {
      setState(() {
        _controller = PdfViewerController();
        _pdfBytes = null;
        _pdfTitle = null;
        _currentSourceId = null;
        _selectionNotifier.value = null;
        _selectedTextNotifier.value = null;
        _containerController.setVisible(true);
        _toolbarController.setMode(CardCreationToolbarMode.sourcesList);
      });
      _updateTitleBar();
    } else {
      context.read<DesktopTitleBarController>().reset();
      Navigator.pop(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    if (isDesktop) {
      _containerController.setAlignment(Alignment.centerRight);
      _containerController.setFillHeight(true);
    } else {
      _containerController.setAlignment(Alignment.bottomCenter);
      _containerController.setFillHeight(false);
    }
  }

  void _initSources() {
    final service = context.read<SourceService>();
    _sourcesSub = service
        .watchSourcesByCollectionId(widget.collectionId)
        .listen((sources) {
          if (mounted) {
            setState(() {
              _availableSources = sources;
            });
          }
        });

    _registerNumericShortcuts();
  }

  Future<void> _loadDraft() async {
    final controller = context.read<AppController>();
    final draft = await controller.draftService.getDraftById(_currentDraftId);

    if (draft != null) {
      if (mounted) {
        setState(() {
          _targetDeckId = draft.deckId;
          // If there was a source opened, try to reload it
          if (draft.lastOpenedSourceId != null) {
            final source = _availableSources?.firstWhere(
              (s) => s.id == draft.lastOpenedSourceId,
            );
            if (source != null) {
              _loadSource(source);
            }
          }

          // Also reload deck name if possible
          controller.studyDatabaseService.getDeckById(draft.deckId).then((
            deck,
          ) {
            if (deck != null && mounted) {
              _toolbarController.deckNameController.text = deck.name;
            }
          });
        });
      }
    }
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
    // Use addPostFrameCallback or a microtask to reset title bar because dispose is called during build/navigation
    Future.microtask(() {
      if (mounted) {
        final titleBar = context.read<DesktopTitleBarController>();
        titleBar.reset();
      }
    });
    super.dispose();
  }

  void _onToolbarChanged() async {
    final requestedId = _toolbarController.requestedSourceId;
    if (requestedId != null) {
      // Find source in cache or fetch from DB
      SourceItem? source;
      final results =
          _availableSources?.where((s) => s.id == requestedId).toList() ?? [];
      if (results.isNotEmpty) {
        source = results.first;
      }

      if (source == null) {
        final service = context.read<SourceService>();
        source = await service.getSourceById(requestedId);
      }

      if (source != null && mounted) {
        _loadSource(source);
        if (!ResponsiveBreakpoints.of(context).largerThan(MOBILE)) {
          _toolbarController.setMode(CardCreationToolbarMode.collapsed);
        }
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
          _selectionNotifier.value = null;
          _selectedTextNotifier.value = null;
          _pdfBytes = blob.bytes;
          _pdfTitle = source.label;
          _currentSourceId = source.id;
          _containerController.setVisible(true);
        });
        _updateTitleBar();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListenableBuilder(
        listenable: labsSettings,
        builder: (context, _) {
          final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
          return ExpandableContainer(
            initialAlignment: Alignment.bottomCenter,
            boundaryMargins: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 12,
              top: isDesktop ? 80 : 12,
            ),
            initialBorder: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
              width: 1,
            ),
            controller: _containerController,
            builder: (context, controller) => CardCreationToolbar(
              context: context,
              containerController: controller,
              toolbarController: _toolbarController,
              selectionNotifier: _selectionNotifier,
              selectedTextNotifier: _selectedTextNotifier,
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: isDesktop
                  ? null
                  : AppBar(
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
                      leadingWidth: ProjectShortcutManager.isShortcutsEnabled
                          ? 120
                          : 56, // accommodate 'Back' text + shortcut only on desktop
                      leading: ProjectBackButton(
                        color: Colors.white,
                        forceShowOnDesktop: true,
                        onPressed: _handleBack,
                      ),
                    ),
              body: CardCreationPdfView(
                pdfBytes: _pdfBytes,
                pdfKey: _pdfKey,
                currentSourceId: _currentSourceId,
                controller: _controller,
                toolbarController: _toolbarController,
                selectionNotifier: _selectionNotifier,
                selectedTextNotifier: _selectedTextNotifier,
                smartSelection: _smartSelection,
              ),
            ),
          );
        },
      ),
    );
  }
}
