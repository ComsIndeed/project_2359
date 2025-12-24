import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _frontController = TextEditingController();
  final TextEditingController _backController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  bool _isGenerating = false;
  String? _selectedFilePath;

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    _noteController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        setState(() {
          _selectedFilePath = result.files.single.name;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  void _handleGenerateDrafts() {
    setState(() {
      _isGenerating = true;
    });
    // TODO: Implement AI card generation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    });
  }

  void _handleAddManualCard() {
    // TODO: Add card to deck
    _frontController.clear();
    _backController.clear();
    _tagController.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Card added successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Cards',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF09090b),
        elevation: 0,
      ),
      body: _isGenerating
          ? _buildLoadingState()
          : Column(
              children: [
                // Tab selector
                Container(
                  color: const Color(0xFF1E1E1E),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      _buildTabButton(0, 'Manual'),
                      _buildTabButton(1, 'Auto'),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _selectedTabIndex == 0
                        ? _buildManualTab()
                        : _buildAutoTab(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF09090b)
                : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF00D9FF)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManualTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Front (Question)',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFEDEDED),
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _frontController,
          hintText: 'Enter the question...',
          maxLines: 4,
        ),
        const SizedBox(height: 20),
        Text(
          'Back (Answer)',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFEDEDED),
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _backController,
          hintText: 'Enter the answer...',
          maxLines: 4,
        ),
        const SizedBox(height: 20),
        Text(
          'Tags',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFEDEDED),
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _tagController,
          hintText: 'Add tags (comma separated)...',
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleAddManualCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9FF),
              foregroundColor: const Color(0xFF09090b),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Add Card',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAutoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File picker
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF2D2D2D),
                strokeAlign: BorderSide.strokeAlignInside,
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF1E1E1E),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: Color(0xFF9CA3AF),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap to upload PDF',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _selectedFilePath!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF00D9FF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Or paste notes',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFEDEDED),
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _noteController,
          hintText: 'Paste lecture notes or text content...',
          maxLines: 10,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleGenerateDrafts,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9FF),
              foregroundColor: const Color(0xFF09090b),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Generate Drafts',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D9FF)),
          ),
          const SizedBox(height: 24),
          Text(
            'Synthesizing...',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFEDEDED),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: const Color(0xFFEDEDED)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: const Color(0xFF6B7280)),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2D2D2D)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2D2D2D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF00D9FF)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}
