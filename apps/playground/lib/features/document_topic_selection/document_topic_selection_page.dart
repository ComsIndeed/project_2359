import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

enum TextDisplayMode { page, words, sentences, paragraphs }

class DocumentTopicSelectionPage extends StatefulWidget {
  const DocumentTopicSelectionPage({super.key});

  @override
  State<DocumentTopicSelectionPage> createState() =>
      _DocumentTopicSelectionPageState();
}

class _DocumentTopicSelectionPageState
    extends State<DocumentTopicSelectionPage> {
  String? _fileName;
  PdfDocument? _document;
  final Set<int> _selectedPageIndices = {};
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPageIndex = 0;
  final Map<int, PdfPageText> _pageTexts = {};
  bool _isExtracting = false;
  final ScrollController _contentsScrollController = ScrollController();
  TextDisplayMode _displayMode = TextDisplayMode.page;
  Map<int, List<PdfRect>> _highlightedRects = {};

  @override
  void dispose() {
    _document?.dispose();
    _pageController.dispose();
    _contentsScrollController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final doc = await PdfDocument.openFile(path);
      setState(() {
        _fileName = result.files.single.name;
        _document = doc;
        _selectedPageIndices.clear();
        _currentPageIndex = 0;
        _pageTexts.clear();
        _highlightedRects.clear();
      });
      _extractAllTexts();
    }
  }

  Future<void> _extractAllTexts() async {
    if (_document == null) return;
    setState(() => _isExtracting = true);
    try {
      for (int i = 0; i < _document!.pages.length; i++) {
        final pageText = await _document!.pages[i].loadStructuredText();
        if (mounted) {
          setState(() {
            _pageTexts[i] = pageText;
          });
        }
      }
    } finally {
      if (mounted) setState(() => _isExtracting = false);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  void _togglePageSelection(int index) {
    setState(() {
      if (_selectedPageIndices.contains(index)) {
        _selectedPageIndices.remove(index);
      } else {
        _selectedPageIndices.add(index);
      }
    });
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _highlightRects(int pageIndex, List<PdfRect> rects) {
    setState(() {
      _highlightedRects = {pageIndex: rects};
    });
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _clearHighlights() {
    if (_highlightedRects.isNotEmpty) {
      setState(() {
        _highlightedRects.clear();
      });
    }
  }

  void _handlePdfTap(int index, Offset localOffset, Size viewSize) {
    if (_document == null) return;
    final pageData = _pageTexts[index];
    if (pageData == null) return;

    final page = _document!.pages[index];
    final swapWH = (page.rotation.index & 1) == 1;
    final w = swapWH ? page.height : page.width;
    final h = swapWH ? page.width : page.height;

    // Convert Flutter local offset to rotated PDF space (0 to w, 0 to h)
    final rotatedX = (localOffset.dx / viewSize.width) * w;
    final rotatedY = h - (localOffset.dy / viewSize.height) * h;
    final rotatedPoint = PdfPoint(rotatedX, rotatedY);

    // Convert rotated point back to original PDF space
    final pdfPoint = rotatedPoint.rotateReverse(page.rotation.index, page);

    // Find fragment containing point
    PdfPageTextFragment? foundFragment;
    for (final f in pageData.fragments) {
      if (f.bounds.containsPoint(pdfPoint)) {
        foundFragment = f;
        break;
      }
    }

    if (foundFragment != null) {
      // Highlight in viewer
      setState(() {
        _highlightedRects = {
          index: [foundFragment!.bounds],
        };
      });

      // Scroll contents list if possible
      // This is an estimation since items in list are variable height
      // We'll try to scroll based on index * approximate height (100)
      _contentsScrollController.animateTo(
        index * 150.0, // Rough estimate, works okay for navigation
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _clearHighlights();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFileSelected = _document != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_fileName ?? "Document Topic Selection"),
        actions: [
          if (isFileSelected)
            IconButton(
              icon: const Icon(Icons.file_upload),
              onPressed: _pickFile,
              tooltip: "Change PDF",
            ),
        ],
      ),
      body: isFileSelected ? _buildMainLayout() : _buildInitialView(),
    );
  }

  Widget _buildMainLayout() {
    final mediaQuery = MediaQuery.of(context);
    final isHorizontal =
        mediaQuery.orientation == Orientation.landscape ||
        mediaQuery.size.width > mediaQuery.size.height;

    if (isHorizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 70% Left: PDF Viewer + Controls
          Expanded(
            flex: 7,
            child: Column(
              children: [
                Expanded(child: _buildPdfPageView()),
                _buildControls(),
              ],
            ),
          ),
          // 30% Right: Container thingy
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: _buildBottomTabs(),
            ),
          ),
        ],
      );
    }

    // Default Portrait Layout
    return Column(
      children: [
        // 60% PDF Viewer + Controls
        Expanded(
          flex: 6,
          child: Column(
            children: [
              Expanded(child: _buildPdfPageView()),
              _buildControls(),
            ],
          ),
        ),
        // 40% Bottom Tabs
        Expanded(flex: 4, child: _buildBottomTabs()),
      ],
    );
  }

  Widget _buildInitialView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.picture_as_pdf, size: 80, color: Colors.blueGrey),
          const SizedBox(height: 16),
          const Text(
            "Ready to select topics?",
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.upload_file),
            label: const Text("Import PDF"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfPageView() {
    final pageCount = _document!.pages.length;

    return PageView.builder(
      controller: _pageController,
      itemCount: pageCount,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final isSelected = _selectedPageIndices.contains(index);
        return AnimatedScale(
          scale: _currentPageIndex == index ? 1.0 : 0.9,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTapUp: (details) => _handlePdfTap(
                        index,
                        details.localPosition,
                        constraints.biggest,
                      ),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: PdfPageView(
                            document: _document!,
                            pageNumber: index + 1,
                            decorationBuilder:
                                (context, pageSize, page, pageImage) {
                                  return Stack(
                                    children: [
                                      if (pageImage != null)
                                        Container(
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black54,
                                                blurRadius: 15,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: pageImage,
                                        ),
                                      if (_highlightedRects.containsKey(index))
                                        ..._highlightedRects[index]!.map(
                                          (rect) => _buildHighlightRect(
                                            pageSize,
                                            page,
                                            rect,
                                          ),
                                        ),
                                    ],
                                  );
                                },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Selection Overlays
                if (isSelected)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue, width: 4),
                        ),
                      ),
                    ),
                  ),
                // Checkbox Top Right
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => _togglePageSelection(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.black45,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        isSelected ? Icons.check : Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                // Page Number
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Page ${index + 1}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls() {
    final pageCount = _document!.pages.length;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark.withOpacity(0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: _currentPageIndex > 0 ? _goToPreviousPage : null,
              ),
              const SizedBox(width: 8),
              Text(
                "${_currentPageIndex + 1} / $pageCount",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                onPressed: _currentPageIndex < pageCount - 1
                    ? _goToNextPage
                    : null,
              ),
            ],
          ),
          // Selection Stats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${_selectedPageIndices.length} Selected",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTabs() {
    return DefaultTabController(
      length: 2,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: "Contents"),
                Tab(text: "Prompt"),
              ],
              indicatorColor: Colors.blueAccent,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.white54,
            ),
            const Divider(height: 1, color: Colors.white10),
            Expanded(
              child: TabBarView(
                children: [
                  _buildContentsList(),
                  _buildTabPlaceholder("Generation Prompt", Icons.psychology),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPlaceholder(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white24, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildContentsList() {
    if (_document == null) return Container();

    return Column(
      children: [
        _buildModeToggle(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.separated(
              controller: _contentsScrollController,
              itemCount: _document!.pages.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.white10, height: 24),
              itemBuilder: (context, index) {
                final pageData = _pageTexts[index];
                if (pageData == null && _isExtracting) {
                  return _buildPageLoadingItem(index);
                }
                if (pageData == null) return Container();

                return switch (_displayMode) {
                  TextDisplayMode.page => _buildPageFullText(index, pageData),
                  TextDisplayMode.words => _buildPageWords(index, pageData),
                  TextDisplayMode.sentences => _buildPageSentences(
                    index,
                    pageData,
                  ),
                  TextDisplayMode.paragraphs => _buildPageParagraphs(
                    index,
                    pageData,
                  ),
                };
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _ToggleOption(
              title: "By Page",
              isSelected: _displayMode == TextDisplayMode.page,
              onTap: () => setState(() => _displayMode = TextDisplayMode.page),
            ),
            const SizedBox(width: 8),
            _ToggleOption(
              title: "By Words",
              isSelected: _displayMode == TextDisplayMode.words,
              onTap: () => setState(() => _displayMode = TextDisplayMode.words),
            ),
            const SizedBox(width: 8),
            _ToggleOption(
              title: "By Sentences",
              isSelected: _displayMode == TextDisplayMode.sentences,
              onTap: () =>
                  setState(() => _displayMode = TextDisplayMode.sentences),
            ),
            const SizedBox(width: 8),
            _ToggleOption(
              title: "By Paragraphs",
              isSelected: _displayMode == TextDisplayMode.paragraphs,
              onTap: () =>
                  setState(() => _displayMode = TextDisplayMode.paragraphs),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageLoadingItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageBadge(index),
        const SizedBox(height: 12),
        const LinearProgressIndicator(
          minHeight: 2,
          backgroundColor: Colors.white10,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
        ),
      ],
    );
  }

  Widget _buildPageBadge(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "PAGE ${index + 1}",
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildPageFullText(int index, PdfPageText pageData) {
    final text = pageData.fullText;
    final hasText = text.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageBadge(index),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            if (hasText) {
              final rect = pageData.charRects.boundingRect();
              _highlightRects(index, [rect]);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              hasText ? text.trim() : "No selectable text on this page.",
              style: TextStyle(
                color: hasText ? Colors.white70 : Colors.white24,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageWords(int index, PdfPageText pageData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageBadge(index),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: pageData.fragments.map((f) {
            final t = f.text.trim();
            if (t.isEmpty) return const SizedBox.shrink();
            return GestureDetector(
              onTap: () => _highlightRects(index, [f.bounds]),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white10),
                ),
                child: Text(
                  t,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPageSentences(int index, PdfPageText pageData) {
    final text = pageData.fullText;
    final matches = RegExp(r'[^.!?]+[.!?]?').allMatches(text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageBadge(index),
        const SizedBox(height: 12),
        ...matches.map((m) {
          final s = m.group(0)!;
          if (s.trim().isEmpty) return const SizedBox.shrink();

          return GestureDetector(
            onTap: () {
              try {
                final rect = pageData.charRects.boundingRect(
                  start: m.start,
                  end: m.end,
                );
                _highlightRects(index, [rect]);
              } catch (_) {}
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                s.trim(),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPageParagraphs(int index, PdfPageText pageData) {
    final text = pageData.fullText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPageBadge(index),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            final rect = pageData.charRects.boundingRect();
            _highlightRects(index, [rect]);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "[TODO] Paragraph detection to be implemented",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text.trim(),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightRect(Size pageSize, PdfPage page, PdfRect rect) {
    // Rotate the rect based on page rotation so it matches the rendering
    final rotatedRect = rect.rotate(page.rotation.index, page);
    final swapWH = (page.rotation.index & 1) == 1;
    final w = swapWH ? page.height : page.width;
    final h = swapWH ? page.width : page.height;

    // Map PDF coordinates (rotatedRect) to flutter coordinates based on pageSize
    // PDF origin: bottom-left.
    // Flutter origin: top-left.
    final left = (rotatedRect.left / w) * pageSize.width;
    final top = ((h - rotatedRect.top) / h) * pageSize.height;
    final width = (rotatedRect.width / w) * pageSize.width;
    final height = (rotatedRect.height / h) * pageSize.height;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow.withOpacity(0.35),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.white10,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
