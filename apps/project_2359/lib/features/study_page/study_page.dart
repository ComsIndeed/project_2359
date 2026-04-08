import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/study_database_service.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:project_2359/features/study_page/flippable_card.dart';

class StudyPage extends StatefulWidget {
  final String deckId;
  final String deckName;

  const StudyPage({super.key, required this.deckId, required this.deckName});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int _currentIndex = 0;
  bool _isFlipped = false;
  List<CardItem>? _cards;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    final studyService = context.read<StudyDatabaseService>();
    final cards = await studyService.getCardsByDeckId(widget.deckId);
    if (mounted) {
      setState(() {
        _cards = cards;
      });
    }
  }

  void _nextCard() {
    if (_cards == null || _currentIndex >= _cards!.length - 1) return;
    setState(() {
      _currentIndex++;
      _isFlipped = false;
    });
  }

  void _previousCard() {
    if (_currentIndex <= 0) return;
    setState(() {
      _currentIndex--;
      _isFlipped = false;
    });
  }

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.space ||
                event.logicalKey == LogicalKeyboardKey.enter) {
              _flipCard();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _nextCard();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _previousCard();
            }
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    ProjectBackButton(onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.deckName,
                            style: theme.textTheme.displaySmall,
                          ),
                          if (_cards != null)
                            Text(
                              '${_currentIndex + 1} of ${_cards!.length} cards',
                              style: theme.textTheme.bodyMedium,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_cards != null && _cards!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / _cards!.length,
                      backgroundColor: theme.colorScheme.onSurface.withValues(
                        alpha: 0.05,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                      minHeight: 3,
                    ),
                  ),
                ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: _cards == null
                        ? const CircularProgressIndicator()
                        : _cards!.isEmpty
                        ? const Text('No cards in this deck')
                        : ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: FlippableCard(
                                frontText:
                                    _cards![_currentIndex].frontText ?? '',
                                backText: _cards![_currentIndex].backText ?? '',
                                isFlipped: _isFlipped,
                                onTap: _flipCard,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavButton(
                      icon: FontAwesomeIcons.chevronLeft,
                      onPressed: _currentIndex > 0 ? _previousCard : null,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: !_isFlipped
                            ? _FlipButton(
                                label: 'Show Answer',
                                onPressed: _flipCard,
                              )
                            : Row(
                                children: [
                                  _FsrsButton(
                                    label: 'Again',
                                    color: Colors.red.shade400,
                                    onPressed: () {}, // TODO: Implement
                                  ),
                                  const SizedBox(width: 8),
                                  _FsrsButton(
                                    label: 'Hard',
                                    color: Colors.orange.shade400,
                                    onPressed: () {}, // TODO: Implement
                                  ),
                                  const SizedBox(width: 8),
                                  _FsrsButton(
                                    label: 'Good',
                                    color: Colors.green.shade400,
                                    onPressed: () {}, // TODO: Implement
                                  ),
                                  const SizedBox(width: 8),
                                  _FsrsButton(
                                    label: 'Easy',
                                    color: Colors.blue.shade400,
                                    onPressed: () {}, // TODO: Implement
                                  ),
                                ],
                              ),
                      ),
                    ),
                    _NavButton(
                      icon: FontAwesomeIcons.chevronRight,
                      onPressed:
                          (_cards != null && _currentIndex < _cards!.length - 1)
                          ? _nextCard
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _NavButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;

    return Material(
      color: isDisabled
          ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
          : theme.colorScheme.surface,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: FaIcon(
            icon,
            size: 20,
            color: isDisabled
                ? theme.colorScheme.onSurface.withValues(alpha: 0.1)
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class _FlipButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _FlipButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primary,
      shape: AppTheme.buttonShape,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _FsrsButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _FsrsButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Material(
        color: color.withValues(alpha: 0.1),
        shape: AppTheme.buttonShape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
