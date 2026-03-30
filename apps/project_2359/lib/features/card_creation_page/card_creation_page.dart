import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdfrx/pdfrx.dart';
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
  PdfDocument? _document;
  List<SourceItem>? _availableSources;
  StreamSubscription? _sourcesSub;
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
        final doc = await PdfDocument.openData(blob.bytes);
        setState(() {
          _document = doc;
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
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildPdfView(),
          if (_isLoading) const Center(child: CircularProgressIndicator()),

          // Back Button
          Positioned(
            top: topPadding,
            left: 4,
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 20),
              onPressed: () {
                if (_document != null) {
                  setState(() => _document = null);
                } else {
                  Navigator.pop(context);
                }
              },
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfView() {
    if (_document == null) {
      final theme = Theme.of(context);
      final cs = theme.colorScheme;

      return _buildPdfList(cs, theme);
    }

    return PageView.builder(
      itemCount: _document!.pages.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return _buildPdfSlide(index);
      },
    );
  }

  Widget _buildPdfSlide(int index) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: PdfPageView(document: _document!, pageNumber: index + 1),
    ),
  );

  SingleChildScrollView _buildPdfList(ColorScheme cs, ThemeData theme) {
    final topPadding = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, topPadding + 64, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Simplified Header
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.03),
                    shape: BoxShape.circle,
                  ),
                  child:
                      FaIcon(
                            FontAwesomeIcons.filePdf,
                            size: 28,
                            color: cs.onSurface.withValues(alpha: 0.1),
                          )
                          .animate(onPlay: (c) => c.repeat())
                          .shimmer(
                            duration: 2.seconds,
                            color: cs.primary.withValues(alpha: 0.1),
                          ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Create from Source",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: cs.onSurface.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose a document from this folder",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

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
