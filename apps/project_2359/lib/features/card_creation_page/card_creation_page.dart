import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/core/widgets/expandable_container.dart';
import 'package:project_2359/features/card_creation_page/smart_text_selection_handler.dart';
import 'package:provider/provider.dart';

import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';
import 'package:project_2359/features/sources_page/source_service.dart';

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
  final PdfViewerController _controller = PdfViewerController();
  final SmartTextSelectionHandler _smartSelection =
      const SmartTextSelectionHandler();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initSources();
  }

  @override
  void dispose() {
    _sourcesSub?.cancel();
    super.dispose();
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
  }

  Future<void> _loadSource(SourceItem source) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final service = context.read<SourceService>();
      final blob = await service.getSourceBlobBySourceId(source.id);
      if (blob != null && mounted) {
        setState(() {
          _pdfBytes = blob.bytes;
          _pdfTitle = source.label;
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
    return ExpandableContainer(
      boundaryMargins: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      builder: (context, controller) {
        return Row(
          children: [
            Spacer(),
            IconButton(
              onPressed: () {
                // TODO: Non-functional button
              },
              icon: FaIcon(FontAwesomeIcons.barsStaggered),
            ),
          ],
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(_pdfTitle ?? 'Create Card'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_pdfBytes != null) {
                setState(() {
                  _pdfBytes = null;
                  _pdfTitle = null;
                  _document = null;
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
  }

  Widget _buildPdfView() {
    if (_pdfBytes == null) {
      return _buildPdfList(context);
    }

    return PdfViewer.data(
      _pdfBytes!,
      sourceName: _pdfTitle ?? 'pdf',
      controller: _controller,
      useProgressiveLoading: true,
      params: PdfViewerParams(
        onViewerReady: (doc, controller) {
          if (mounted) {
            setState(() {
              _document = doc;
            });
          }
        },
        backgroundColor: Colors.black,
        textSelectionParams: const PdfTextSelectionParams(enabled: true),
        onGeneralTap: _smartSelection.handleTap,
      ),
    );
  }

  Widget _buildPdfList(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, topPadding + 64, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                  style: TextStyle(color: cs.onSurface.withValues(alpha: 0.3)),
                ),
              ),
            )
          else
            Column(
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
                              title: Text(_availableSources![i].label),
                              subtitle: Text(
                                "${_availableSources![i].type.toUpperCase()} | ${_availableSources![i].extractedContent?.length ?? 0} chars",
                              ),
                              leading: const WizardSourcePagePreview(),
                              onTap: () => _loadSource(_availableSources![i]),
                            )
                            .animate()
                            .fadeIn(delay: (i * 100).ms)
                            .slideY(begin: 0.1, curve: Curves.easeOutQuad),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
