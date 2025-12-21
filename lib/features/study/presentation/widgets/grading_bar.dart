import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradingBar extends StatelessWidget {
  final bool isAnswerShown;
  final VoidCallback onShowAnswer;
  final VoidCallback onAgain;
  final VoidCallback onHard;
  final VoidCallback onGood;
  final VoidCallback onEasy;

  const GradingBar({
    required this.isAnswerShown,
    required this.onShowAnswer,
    required this.onAgain,
    required this.onHard,
    required this.onGood,
    required this.onEasy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAnswerShown) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: onShowAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D9FF),
            foregroundColor: const Color(0xFF09090b),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Show Answer',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _GradingButton(
            label: 'Again',
            interval: '< 1m',
            color: const Color(0xFFEF4444),
            onPressed: onAgain,
          ),
          const SizedBox(width: 8),
          _GradingButton(
            label: 'Hard',
            interval: '2d',
            color: const Color(0xFFF97316),
            onPressed: onHard,
          ),
          const SizedBox(width: 8),
          _GradingButton(
            label: 'Good',
            interval: '5d',
            color: const Color(0xFF00D9FF),
            onPressed: onGood,
          ),
          const SizedBox(width: 8),
          _GradingButton(
            label: 'Easy',
            interval: '10d',
            color: const Color(0xFF4ADE80),
            onPressed: onEasy,
          ),
        ],
      ),
    );
  }
}

class _GradingButton extends StatelessWidget {
  final String label;
  final String interval;
  final Color color;
  final VoidCallback onPressed;

  const _GradingButton({
    required this.label,
    required this.interval,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.15),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: color.withOpacity(0.3)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              interval,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
