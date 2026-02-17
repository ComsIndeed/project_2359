import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/ai_helpers.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ═══════════════════════════════════════════════════════════════════
// Background PDF parsing
// ═══════════════════════════════════════════════════════════════════

class _PdfInfo {
  final int pageCount;
  final String extractedText;
  const _PdfInfo(this.pageCount, this.extractedText);
}

_PdfInfo _parsePdf(Uint8List bytes) {
  final doc = PdfDocument(inputBytes: bytes);
  final pageCount = doc.pages.count;
  final text = PdfTextExtractor(doc).extractText();
  doc.dispose();
  return _PdfInfo(pageCount, text);
}

// ═══════════════════════════════════════════════════════════════════
// SourcePage
// ═══════════════════════════════════════════════════════════════════

class SourcePage extends StatefulWidget {
  const SourcePage({super.key, required this.fileBytes, this.title});

  final Uint8List fileBytes;
  final String? title;

  @override
  State<SourcePage> createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> with TickerProviderStateMixin {
  // Controllers
  final ScrollController _drawerScrollController = ScrollController();
  final PdfViewerController _pdfController = PdfViewerController();

  // State
  bool _isDrawerOpen = false;
  bool _isMenuOpen = false;
  String? _extractedText;
  String? _indexedText;
  bool _isIndexing = false;
  bool _isViewingIndexed = false;
  int _currentPage = 1;
  int _totalPages = 0;
  double _zoomLevel = 1.0;
  bool _pdfReady = false;

  // Constants

  static const _animDuration = Duration(milliseconds: 200);
  static const _animCurve = Curves.easeOutCubic;

  @override
  void initState() {
    super.initState();
    // Defer PDF viewer init until after the route transition's first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _pdfReady = true);
    });
    compute(_parsePdf, widget.fileBytes).then((info) {
      if (mounted) {
        setState(() {
          _totalPages = info.pageCount;
          _extractedText = info.extractedText;
        });
      }
    });
  }

  @override
  void dispose() {
    _pdfController.dispose();
    _drawerScrollController.dispose();
    super.dispose();
  }

  // ─── Toggles ──────────────────────────────────────────────────────

  void _toggleDrawer() {
    if (_isMenuOpen) setState(() => _isMenuOpen = false);
    setState(() => _isDrawerOpen = !_isDrawerOpen);
  }

  void _toggleMenu() {
    if (_isDrawerOpen) setState(() => _isDrawerOpen = false);
    setState(() => _isMenuOpen = !_isMenuOpen);
  }

  void _closeAll() {
    setState(() {
      _isDrawerOpen = false;
      _isMenuOpen = false;
    });
  }

  // ─── Zoom ─────────────────────────────────────────────────────────

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.25).clamp(0.75, 3.0);
      _pdfController.zoomLevel = _zoomLevel;
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.25).clamp(0.75, 3.0);
      _pdfController.zoomLevel = _zoomLevel;
    });
  }

  void _zoomReset() {
    setState(() {
      _zoomLevel = 1.0;
      _pdfController.zoomLevel = 1.0;
    });
  }

  // ─── Indexing ─────────────────────────────────────────────────────

  Future<void> _startIndexing() async {
    if (_extractedText == null || _extractedText!.isEmpty || _isIndexing) {
      return;
    }

    setState(() {
      _isIndexing = true;
      _indexedText = '';
      _isViewingIndexed = true; // Auto-switch to indexed view
    });

    try {
      final stream = AiHelpers.indexExtractedText(_extractedText!);
      await for (final chunk in stream) {
        if (!mounted) break;
        setState(() {
          _indexedText = (_indexedText ?? '') + chunk;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Indexing failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isIndexing = false);
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // Build
  // ═══════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // App bar
          _buildAppBar(context, cs, tt),

          // Menu (animated reveal — pushes PDF down)
          AnimatedSize(
            duration: _animDuration,
            curve: _animCurve,
            alignment: Alignment.topCenter,
            child: _isMenuOpen
                ? _buildMenuContent(cs, tt, isDark)
                : const SizedBox.shrink(),
          ),

          // PDF viewer area (slides up when text panel expands)
          Expanded(
            child: GestureDetector(
              onTap: (_isMenuOpen || _isDrawerOpen) ? _closeAll : null,
              behavior: HitTestBehavior.opaque,
              child: _buildPdfArea(cs, isDark),
            ),
          ),

          // Text panel (animated reveal from bottom)
          AnimatedSize(
            duration: _animDuration,
            curve: _animCurve,
            alignment: Alignment.bottomCenter,
            child: _isDrawerOpen
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: _buildTextPanel(cs, tt),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // App Bar
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildAppBar(BuildContext context, ColorScheme cs, TextTheme tt) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            _appBarButton(
              cs: cs,
              icon: FontAwesomeIcons.arrowLeft,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title ?? 'Document',
                    style: tt.headlineMedium?.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$_totalPages ${_totalPages == 1 ? 'page' : 'pages'}',
                    style: tt.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // Menu toggle (horizontal bars ↔ X)
            _appBarButton(
              cs: cs,
              icon: _isMenuOpen
                  ? FontAwesomeIcons.xmark
                  : FontAwesomeIcons.bars,
              onTap: _toggleMenu,
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBarButton({
    required ColorScheme cs,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: AppTheme.buttonShape as OutlinedBorder,
      child: InkWell(
        customBorder: AppTheme.buttonShape as OutlinedBorder,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: FaIcon(
              icon,
              key: ValueKey(icon),
              color: cs.onSurface,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Menu Content (revealed by pushing PDF down)
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildMenuContent(ColorScheme cs, TextTheme tt, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHighest.withValues(alpha: 0.4)
            : cs.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.06)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          _menuTile(
            cs: cs,
            icon: FontAwesomeIcons.shareNodes,
            label: 'Share document',
            onTap: () {},
          ),
          _menuTile(
            cs: cs,
            icon: FontAwesomeIcons.bookmark,
            label: 'Add bookmark',
            onTap: () {},
          ),
          _menuTile(
            cs: cs,
            icon: FontAwesomeIcons.print,
            label: 'Print',
            onTap: () {},
          ),
          _menuTile(
            cs: cs,
            icon: FontAwesomeIcons.circleInfo,
            label: 'Document info',
            onTap: () {},
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _menuTile({
    required ColorScheme cs,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              FaIcon(
                icon,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chevronRight,
                size: 14,
                color: cs.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // PDF Viewer Area
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildPdfArea(ColorScheme cs, bool isDark) {
    bool isAnyPanelOpen = _isMenuOpen || _isDrawerOpen;

    return Stack(
      children: [
        // PDF viewer with superellipse curves
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ), // Adjust if needed
          child: ClipPath(
            clipper: _SuperellipseClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade200,
              ),
              child: SfPdfViewerTheme(
                data: SfPdfViewerThemeData(
                  backgroundColor: isDark
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey.shade300,
                ),
                child: _pdfReady
                    ? SfPdfViewer.memory(
                        canShowPageLoadingIndicator: true,
                        widget.fileBytes,
                        controller: _pdfController,
                        onPageChanged: (details) {
                          setState(() => _currentPage = details.newPageNumber);
                        },
                        onZoomLevelChanged: (details) {
                          setState(() => _zoomLevel = details.newZoomLevel);
                        },
                        canShowScrollHead: false,
                        pageSpacing: 24,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
              ),
            ),
          ),
        ),

        // Transparent overlay to catch taps when a panel is open
        if (isAnyPanelOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeAll,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),

        // Bottom controls bar
        if (_totalPages > 0)
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: _buildBottomControls(cs),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Bottom Controls (page badge + zoom + extract text button)
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildBottomControls(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: ShapeDecoration(
        color: cs.surface.withValues(alpha: 0.94),
        shape: const StadiumBorder(),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicator badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: ShapeDecoration(
              color: cs.onSurface.withValues(alpha: 0.05),
              shape: const StadiumBorder(),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 120),
              child: Text(
                '$_currentPage / $_totalPages',
                key: ValueKey(_currentPage),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Zoom controls group
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: ShapeDecoration(
              color: cs.onSurface.withValues(alpha: 0.05),
              shape: const StadiumBorder(),
            ),
            child: Row(
              children: [
                _controlButton(cs, FontAwesomeIcons.minus, _zoomOut),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${(_zoomLevel * 100).round()}%',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                _controlButton(cs, FontAwesomeIcons.plus, _zoomIn),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Action buttons
          _controlButton(
            cs,
            FontAwesomeIcons.expand,
            _zoomReset,
            useBackground: true,
          ),
          const SizedBox(width: 8),
          _extractTextButton(cs),
        ],
      ),
    );
  }

  Material _extractTextButton(ColorScheme cs) {
    final bool active = _isDrawerOpen;
    return Material(
      color: active ? cs.primary : cs.onSurface.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _toggleDrawer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.fileLines,
                size: 16,
                color: active
                    ? cs.onPrimary
                    : cs.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'View Text',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: active
                      ? cs.onPrimary
                      : cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButton(
    ColorScheme cs,
    IconData icon,
    VoidCallback onTap, {
    bool useBackground = false,
  }) {
    return Material(
      color: useBackground
          ? cs.onSurface.withValues(alpha: 0.05)
          : Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FaIcon(
            icon,
            size: 16,
            color: cs.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Text Panel (right side, behind main unit)
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildTextPanel(ColorScheme cs, TextTheme tt) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle indicator
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header with Tabs and Index Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  // Extracted Text Tab
                  _buildTab(
                    cs: cs,
                    tt: tt,
                    label: 'Extracted Text',
                    icon: FontAwesomeIcons.fileLines,
                    isActive: !_isViewingIndexed,
                    onTap: () => setState(() => _isViewingIndexed = false),
                  ),

                  // Dotted Arrow + Index Button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [const _DottedArrow(), _buildIndexButton(cs)],
                      ),
                    ),
                  ),

                  // Indexed Text Tab
                  _buildTab(
                    cs: cs,
                    tt: tt,
                    label: 'Indexed Text',
                    icon: FontAwesomeIcons.brain,
                    isActive: _isViewingIndexed,
                    onTap: () => setState(() => _isViewingIndexed = true),
                  ),
                ],
              ),
            ),

            // Gradient divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withValues(alpha: 0.3),
                      cs.primary.withValues(alpha: 0.05),
                      cs.primary.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: _isViewingIndexed
                  ? _buildIndexedContent(cs, tt)
                  : _buildExtractedContent(cs, tt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required ColorScheme cs,
    required TextTheme tt,
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              color: isActive
                  ? cs.primary
                  : cs.onSurface.withValues(alpha: 0.4),
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: tt.headlineMedium?.copyWith(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? cs.onSurface
                    : cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexButton(ColorScheme cs) {
    return Material(
      color: _isIndexing
          ? cs.surface
          : cs.surfaceContainerHighest.withValues(alpha: 0.8),
      shape: StadiumBorder(
        side: BorderSide(color: cs.primary.withValues(alpha: 0.2), width: 0.5),
      ),
      child: InkWell(
        onTap: (_extractedText == null || _isIndexing) ? null : _startIndexing,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isIndexing)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 6),
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: cs.primary,
                  ),
                )
              else
                FaIcon(
                  FontAwesomeIcons.bolt,
                  size: 10,
                  color: cs.primary.withValues(alpha: 0.8),
                ),
              if (!_isIndexing) const SizedBox(width: 4),
              Text(
                _isIndexing ? 'Indexing...' : 'Index',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: cs.primary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExtractedContent(ColorScheme cs, TextTheme tt) {
    if (_extractedText == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Extracting…',
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    if (_extractedText!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.alignLeft,
              size: 32,
              color: cs.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 8),
            Text(
              'No text found.',
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      controller: _drawerScrollController,
      thumbVisibility: true,
      child: ListView(
        controller: _drawerScrollController,
        padding: const EdgeInsets.fromLTRB(16, 2, 12, 16),
        children: [
          SelectableText(
            _extractedText!,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.6,
              color: cs.onSurface.withValues(alpha: 0.85),
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndexedContent(ColorScheme cs, TextTheme tt) {
    if (_indexedText == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  FontAwesomeIcons.brain,
                  size: 32,
                  color: cs.primary.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Not Indexed Yet',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Index this document to enjoy better search and smarter AI interactions.',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _extractedText == null ? null : _startIndexing,
                icon: const FaIcon(FontAwesomeIcons.bolt, size: 14),
                label: const Text('Index Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 2, 12, 16),
        children: [
          SelectableText(
            _indexedText!,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.6,
              color: cs.onSurface.withValues(alpha: 0.85),
              letterSpacing: 0.1,
            ),
          ),
          if (_isIndexing)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cs.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI is thinking...',
                    style: tt.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Action Button (icon + label below)
  // ═══════════════════════════════════════════════════════════════════
}

// ═══════════════════════════════════════════════════════════════════════
// Custom clipper for superellipse corners on the PDF area
// ═══════════════════════════════════════════════════════════════════════

class _SuperellipseClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const r = 24.0;
    final path = Path()
      ..moveTo(0, r)
      // Top Left
      ..cubicTo(0, r * 0.2, r * 0.2, 0, r, 0)
      ..lineTo(size.width - r, 0)
      // Top Right
      ..cubicTo(size.width - r * 0.2, 0, size.width, r * 0.2, size.width, r)
      ..lineTo(size.width, size.height - r)
      // Bottom Right
      ..cubicTo(
        size.width,
        size.height - r * 0.2,
        size.width - r * 0.2,
        size.height,
        size.width - r,
        size.height,
      )
      ..lineTo(r, size.height)
      // Bottom Left
      ..cubicTo(
        r * 0.2,
        size.height,
        0,
        size.height - r * 0.2,
        0,
        size.height - r,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DottedArrow extends StatelessWidget {
  const _DottedArrow();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 20,
      width: double.infinity,
      child: CustomPaint(
        painter: _DottedArrowPainter(color: cs.primary.withValues(alpha: 0.2)),
      ),
    );
  }
}

class _DottedArrowPainter extends CustomPainter {
  final Color color;
  _DottedArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }

    // Draw arrow head
    final path = Path()
      ..moveTo(size.width - 6, y - 4)
      ..lineTo(size.width, y)
      ..lineTo(size.width - 6, y + 4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
