import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardDisplay extends StatelessWidget {
  final String frontText;
  final String backText;
  final bool showBack;
  final String? sourceId;
  final VoidCallback? onViewSource;

  const CardDisplay({
    required this.frontText,
    required this.backText,
    required this.showBack,
    this.sourceId,
    this.onViewSource,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Front content
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    frontText,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFEDEDED),
                    ),
                  ),
                ],
              ),
            ),

            if (showBack) ...[
              const SizedBox(height: 20),
              Divider(color: const Color(0xFF2D2D2D), thickness: 1),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Answer',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      backText,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFEDEDED),
                      ),
                    ),
                  ],
                ),
              ),
              if (sourceId != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: onViewSource,
                  icon: const Icon(Icons.source),
                  label: const Text('View Source'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF00D9FF),
                    side: const BorderSide(color: Color(0xFF00D9FF)),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
