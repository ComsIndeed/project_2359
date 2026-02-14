import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_theme.dart';
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
  late final AnimationController _drawerAnimController;
  late final AnimationController _menuAnimController;
  final ScrollController _drawerScrollController = ScrollController();
  final PdfViewerController _pdfController = PdfViewerController();

  // State
  bool _isDrawerOpen = false;
  bool _isMenuOpen = false;
  String? _extractedText;
  int _currentPage = 1;
  int _totalPages = 0;
  double _zoomLevel = 1.0;

  // Constants
  static const _revealFraction = 0.85;
  static const _menuSlide = 0.12; // fraction of height the PDF slides down
  static const _animDuration = Duration(milliseconds: 200);
  static const _animCurve = Curves.easeOutCubic;

  @override
  void initState() {
    super.initState();

    _drawerAnimController = AnimationController(
      vsync: this,
      duration: _animDuration,
    );
    _menuAnimController = AnimationController(
      vsync: this,
      duration: _animDuration,
    );

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
    _drawerAnimController.dispose();
    _menuAnimController.dispose();
    _pdfController.dispose();
    _drawerScrollController.dispose();
    super.dispose();
  }

  // ─── Toggles ──────────────────────────────────────────────────────

  void _toggleDrawer() {
    // Close menu first if open
    if (_isMenuOpen) _closeMenu();
    setState(() => _isDrawerOpen = !_isDrawerOpen);
    _isDrawerOpen
        ? _drawerAnimController.forward()
        : _drawerAnimController.reverse();
  }

  void _toggleMenu() {
    // Close drawer first if open
    if (_isDrawerOpen) _closeDrawer();
    setState(() => _isMenuOpen = !_isMenuOpen);
    _isMenuOpen ? _menuAnimController.forward() : _menuAnimController.reverse();
  }

  void _closeDrawer() {
    if (!_isDrawerOpen) return;
    setState(() => _isDrawerOpen = false);
    _drawerAnimController.reverse();
  }

  void _closeMenu() {
    if (!_isMenuOpen) return;
    setState(() => _isMenuOpen = false);
    _menuAnimController.reverse();
  }

  void _closeAll() {
    _closeDrawer();
    _closeMenu();
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // ── Menu row (sits behind PDF, top area) ─────────────────
          _buildMenuRow(cs, tt, isDark),

          // ── Extracted text (right 85%) ───────────────────────────
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: screenWidth * _revealFraction,
            child: _buildTextPanel(cs, tt, isDark),
          ),

          // ── PDF layer ───────────────────────────────────────────
          AnimatedSlide(
            duration: _animDuration,
            curve: _animCurve,
            offset: Offset(
              _isDrawerOpen ? -_revealFraction : 0,
              _isMenuOpen ? _menuSlide : 0,
            ),
            child: GestureDetector(
              onTap: (_isDrawerOpen || _isMenuOpen) ? _closeAll : null,
              child: Container(
                width: screenWidth,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    _buildAppBar(context, cs, tt, isDark),
                    Expanded(child: _buildPdfArea(cs, isDark)),
                  ],
                ),
              ),
            ),
          ),

          // ── FAB (center-right) ──────────────────────────────────
          _buildFab(cs, isDark, screenWidth),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // App Bar
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildAppBar(
    BuildContext context,
    ColorScheme cs,
    TextTheme tt,
    bool isDark,
  ) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            // Back button
            _appBarButton(
              cs: cs,
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),

            // Title
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

            // Menu toggle button (horizontal bars ↔ X)
            _appBarButton(
              cs: cs,
              icon: _isMenuOpen
                  ? Icons.close_rounded
                  : Icons.drag_handle_rounded,
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
            child: Icon(
              icon,
              key: ValueKey(icon),
              color: cs.onSurface,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Menu Row (sits behind PDF, revealed by sliding PDF down)
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildMenuRow(ColorScheme cs, TextTheme tt, bool isDark) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text('Options', style: tt.headlineMedium?.copyWith(fontSize: 15)),
              const SizedBox(height: 12),

              // Action row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _menuItem(cs, Icons.share_rounded, 'Share', () {}),
                  _menuItem(cs, Icons.bookmark_add_rounded, 'Bookmark', () {}),
                  _menuItem(cs, Icons.print_rounded, 'Print', () {}),
                  _menuItem(cs, Icons.info_outline_rounded, 'Info', () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    ColorScheme cs,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              shape: AppTheme.buttonShape,
            ),
            child: Icon(icon, size: 22, color: cs.primary),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // PDF Viewer Area
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildPdfArea(ColorScheme cs, bool isDark) {
    return Stack(
      children: [
        // PDF viewer
        ClipPath(
          clipper: _SuperellipseTopClipper(),
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
              child: SfPdfViewer.memory(
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
              ),
            ),
          ),
        ),

        // ── Bottom controls bar ───────────────────────────────────
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

  Widget _buildBottomControls(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: ShapeDecoration(
        color: cs.surface.withValues(alpha: 0.88),
        shape: AppTheme.cardShape as OutlinedBorder,
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Page indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 120),
              child: Text(
                '$_currentPage / $_totalPages',
                key: ValueKey(_currentPage),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Zoom controls
          _zoomButton(cs, Icons.remove_rounded, _zoomOut),
          Container(
            constraints: const BoxConstraints(minWidth: 44),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: _zoomReset,
              child: Text(
                '${(_zoomLevel * 100).round()}%',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ),
          ),
          _zoomButton(cs, Icons.add_rounded, _zoomIn),
        ],
      ),
    );
  }

  Widget _zoomButton(ColorScheme cs, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Text Panel
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildTextPanel(ColorScheme cs, TextTheme tt, bool isDark) {
    return Container(
      color: cs.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
              child: Row(
                children: [
                  Icon(Icons.article_rounded, color: cs.primary, size: 18),
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
                          Icon(
                            Icons.text_snippet_outlined,
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
  // Floating Action Button (Custom, center-right)
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildFab(ColorScheme cs, bool isDark, double screenWidth) {
    // Position follows the PDF edge when drawer is open
    final fabRight = _isDrawerOpen ? screenWidth * _revealFraction - 22 : -2.0;

    return AnimatedPositioned(
      duration: _animDuration,
      curve: _animCurve,
      right: fabRight,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onTap: _toggleDrawer,
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! < -100 && !_isDrawerOpen) {
                _toggleDrawer();
              } else if (details.primaryVelocity! > 100 && _isDrawerOpen) {
                _toggleDrawer();
              }
            }
          },
          child: AnimatedBuilder(
            animation: _drawerAnimController,
            builder: (context, child) {
              final glow = _drawerAnimController.value;
              return Container(
                width: 44,
                height: 44,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
                  ),
                  shape: RoundedSuperellipseBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadows: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.25 + glow * 0.15),
                      blurRadius: 16 + glow * 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedRotation(
                  duration: _animDuration,
                  turns: _isDrawerOpen ? 0.5 : 0,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Custom clipper for superellipse-shaped top corners on the PDF area
// ═══════════════════════════════════════════════════════════════════════

class _SuperellipseTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const r = 24.0;
    final path = Path()
      ..moveTo(0, r)
      ..cubicTo(0, r * 0.2, r * 0.2, 0, r, 0)
      ..lineTo(size.width - r, 0)
      ..cubicTo(size.width - r * 0.2, 0, size.width, r * 0.2, size.width, r)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
