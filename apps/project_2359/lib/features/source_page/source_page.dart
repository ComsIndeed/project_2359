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

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 12, 0),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.fileLines,
                    color: cs.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Extracted Text',
                      style: tt.headlineMedium?.copyWith(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Gradient divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withValues(alpha: 0.3),
                      cs.primary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: _extractedText == null
                  ? Center(
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
                    )
                  : _extractedText!.isEmpty
                  ? Center(
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
                    )
                  : Scrollbar(
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
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Action Button (icon + label below)
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildActionButton({
    required ColorScheme cs,
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final shape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: cs.primary.withValues(alpha: 0.12)),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            width: 40,
            height: 40,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primary.withValues(alpha: 0.15),
                  cs.primary.withValues(alpha: 0.06),
                ],
              ),
              shape: shape,
            ),
            child: InkWell(
              customBorder: shape,
              onTap: onTap,
              child: Center(child: icon),
            ),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: cs.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
      ],
    );
  }
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
