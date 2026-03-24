import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfrx/pdfrx.dart';

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

  @override
  void dispose() {
    _document?.dispose();
    _pageController.dispose();
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
      });
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
                // PDF Page Rendering
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: PdfPageView(
                    document: _document!,
                    pageNumber: index + 1,
                  ),
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
                  _buildTabPlaceholder("Contents Overview", Icons.list_alt),
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
}
