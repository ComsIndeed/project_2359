import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeckTile extends StatelessWidget {
  final String title;
  final int dueCount;
  final VoidCallback onTap;
  final Color backgroundColor;

  const DeckTile({
    required this.title,
    required this.dueCount,
    required this.onTap,
    this.backgroundColor = const Color(0xFF1E1E1E),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEDEDED),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: dueCount > 0
                    ? const Color(0xFF00D9FF).withOpacity(0.2)
                    : const Color(0xFF4ADE80).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                dueCount > 0 ? '$dueCount Due' : 'Done',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: dueCount > 0
                      ? const Color(0xFF00D9FF)
                      : const Color(0xFF4ADE80),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
