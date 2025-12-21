import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/features/study/presentation/widgets/card_display.dart';
import 'package:project_2359/features/study/presentation/widgets/grading_bar.dart';

class StudySession extends StatefulWidget {
  const StudySession({super.key});

  @override
  State<StudySession> createState() => _StudySessionState();
}

class _StudySessionState extends State<StudySession>
    with AutomaticKeepAliveClientMixin {
  bool _isAnswerShown = false;
  int _currentCardIndex = 0;

  // Mock data
  final List<Map<String, String>> _cards = [
    {
      'front': 'What is the capital of France?',
      'back': 'Paris is the capital and most populous city of France.',
      'sourceId': 'source_1',
    },
    {'front': 'What is 2 + 2?', 'back': '4'},
    {
      'front': 'What is photosynthesis?',
      'back':
          'Photosynthesis is the process by which plants use sunlight to synthesize foods from carbon dioxide and water.',
      'sourceId': 'source_2',
    },
    {'front': 'What is the chemical symbol for Gold?', 'back': 'Au'},
    {
      'front': 'What is the largest planet in our solar system?',
      'back': 'Jupiter is the largest planet in our solar system.',
    },
  ];

  @override
  bool get wantKeepAlive => true;

  void _handleShowAnswer() {
    setState(() {
      _isAnswerShown = true;
    });
  }

  void _handleGradeCard(String grade) {
    // TODO: Implement FSRS grading logic
    _moveToNextCard();
  }

  void _moveToNextCard() {
    setState(() {
      _isAnswerShown = false;
      if (_currentCardIndex < _cards.length - 1) {
        _currentCardIndex++;
      } else {
        // Session complete
        _showSessionComplete();
      }
    });
  }

  void _showSessionComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'Session Complete',
          style: GoogleFonts.inter(
            color: const Color(0xFFEDEDED),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Great job! You reviewed ${_cards.length} cards.',
          style: GoogleFonts.inter(color: const Color(0xFF9CA3AF)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentCardIndex = 0;
              });
            },
            child: Text(
              'Continue',
              style: GoogleFonts.inter(color: const Color(0xFF00D9FF)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final card = _cards[_currentCardIndex];
    final totalCards = _cards.length;
    final progress = (_currentCardIndex + 1) / totalCards;

    return Scaffold(
      body: Column(
        children: [
          // Top progress bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF09090b),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_currentCardIndex + 1}/$totalCards',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFEDEDED),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Exit session
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFF2D2D2D),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF00D9FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Card content
          Expanded(
            child: CardDisplay(
              frontText: card['front']!,
              backText: card['back']!,
              showBack: _isAnswerShown,
              sourceId: card['sourceId'],
              onViewSource: () {
                // TODO: Show source context
              },
            ),
          ),
          // Grading buttons
          GradingBar(
            isAnswerShown: _isAnswerShown,
            onShowAnswer: _handleShowAnswer,
            onAgain: () => _handleGradeCard('again'),
            onHard: () => _handleGradeCard('hard'),
            onGood: () => _handleGradeCard('good'),
            onEasy: () => _handleGradeCard('easy'),
          ),
        ],
      ),
    );
  }
}
