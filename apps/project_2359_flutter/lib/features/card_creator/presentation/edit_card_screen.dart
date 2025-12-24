import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditCardScreen extends StatefulWidget {
  final Map<String, String>? initialCard;
  final String? sourceContext;

  const EditCardScreen({this.initialCard, this.sourceContext, super.key});

  @override
  State<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  late TextEditingController _frontController;
  late TextEditingController _backController;
  String _cardType = 'Basic';

  final List<String> _cardTypes = ['Basic', 'MCQ', 'Cloze'];

  @override
  void initState() {
    super.initState();
    _frontController = TextEditingController(
      text: widget.initialCard?['front'] ?? '',
    );
    _backController = TextEditingController(
      text: widget.initialCard?['back'] ?? '',
    );
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // TODO: Save card changes
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Card saved successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Card',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF09090b),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: GestureDetector(
                onTap: _handleSave,
                child: Icon(Icons.check, color: const Color(0xFF00D9FF)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card type dropdown
            Text(
              'Card Type',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEDEDED),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2D2D2D)),
              ),
              child: DropdownButton<String>(
                value: _cardType,
                isExpanded: true,
                underline: const SizedBox(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                dropdownColor: const Color(0xFF1E1E1E),
                style: GoogleFonts.inter(
                  color: const Color(0xFFEDEDED),
                  fontSize: 14,
                ),
                items: _cardTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _cardType = value);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            // Front field
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
              hintText: 'Edit the question...',
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            // Back field
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
              hintText: 'Edit the answer...',
              maxLines: 4,
            ),
            // Source context (if available)
            if (widget.sourceContext != null) ...[
              const SizedBox(height: 24),
              Text(
                'Source Context',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEDEDED),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2D2D2D)),
                ),
                child: Text(
                  widget.sourceContext!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'This text was extracted from your source. It helps verify the accuracy of the card.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
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
