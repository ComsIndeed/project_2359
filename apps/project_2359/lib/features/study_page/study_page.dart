import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:project_2359/app_database.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/app_controller.dart';
import 'package:project_2359/core/settings/labs_settings.dart';
import 'package:project_2359/core/study_database_service.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:project_2359/features/study_page/flippable_card.dart';

class StudyPage extends StatefulWidget {
  final String deckId;
  final String deckName;
  final bool isNested;

  const StudyPage({
    super.key,
    required this.deckId,
    required this.deckName,
    this.isNested = false,
  });

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

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _rateCard(fsrs.Rating rating) async {
    final appController = context.read<AppController>();
    final cardId = _cards![_currentIndex].id;

    // Await the update
    await appController.schedulingService.reviewCard(
      cardId: cardId,
      rating: rating,
    );

    if (mounted) {
      if (_currentIndex < _cards!.length - 1) {
        setState(() {
          _currentIndex++;
          _isFlipped = false;
        });
      } else {
        // Deck finished
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            _flipCard();
          }
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  if (!widget.isNested) ...[
                    ProjectBackButton(onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 16),
                  ],
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
                      : ListenableBuilder(
                          listenable: labsSettings,
                          builder: (context, _) {
                            final cardContent = ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: FlippableCard(
                                  frontText:
                                      _cards![_currentIndex].frontText ?? '',
                                  backText:
                                      _cards![_currentIndex].backText ?? '',
                                  isFlipped: _isFlipped,
                                  onTap: _flipCard,
                                ),
                              ),
                            );

                            if (!labsSettings.swipeToRateEnabled) {
                              return cardContent;
                            }

                            return _SwipeableCardWrapper(
                              isFlipped: _isFlipped,
                              onSwipeLeft: () {}, // TODO
                              onSwipeRight: () {}, // TODO
                              onSwipeUp: () {}, // TODO
                              onSwipeDown: () {}, // TODO
                              child: cardContent,
                            );
                          },
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: !_isFlipped
                    ? _FlipButton(label: 'Show Answer', onPressed: _flipCard)
                    : Row(
                        children: [
                          _FsrsButton(
                            label: 'Again',
                            color: Colors.red.shade400,
                            onPressed: () => _rateCard(fsrs.Rating.again),
                          ),
                          const SizedBox(width: 8),
                          _FsrsButton(
                            label: 'Hard',
                            color: Colors.orange.shade400,
                            onPressed: () => _rateCard(fsrs.Rating.hard),
                          ),
                          const SizedBox(width: 8),
                          _FsrsButton(
                            label: 'Good',
                            color: Colors.green.shade400,
                            onPressed: () => _rateCard(fsrs.Rating.good),
                          ),
                          const SizedBox(width: 8),
                          _FsrsButton(
                            label: 'Easy',
                            color: Colors.blue.shade400,
                            onPressed: () => _rateCard(fsrs.Rating.easy),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.isNested) return content;
    return Scaffold(body: content);
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
      child: Container(
        height: 48,
        decoration: ShapeDecoration(
          color: color.withAlpha(10),
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwipeableCardWrapper extends StatefulWidget {
  final Widget child;
  final bool isFlipped;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeDown;

  const _SwipeableCardWrapper({
    required this.child,
    required this.isFlipped,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onSwipeUp,
    required this.onSwipeDown,
  });

  @override
  State<_SwipeableCardWrapper> createState() => _SwipeableCardWrapperState();
}

class _SwipeableCardWrapperState extends State<_SwipeableCardWrapper>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  Offset _anchor = Offset.zero;
  double _rotation = 0.0;
  bool _isDragging = false;
  late AnimationController _controller;
  late Animation<Offset> _backAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.isFlipped) return;
    setState(() {
      _isDragging = true;
      _anchor = details.localPosition;
    });
    _controller.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isFlipped) return;
    setState(() {
      _offset += details.delta;
      // Realistic swing: rotate more if dragging further from the center
      // 300x400 normalized card size
      final center = const Offset(150, 200);
      final distFromCenter = _anchor - center;
      _rotation = (_offset.dx / 300) * (distFromCenter.dy / 200).clamp(-1, 1);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isFlipped) return;
    final threshold = 120.0;

    if (_offset.dx < -threshold) {
      widget.onSwipeLeft();
    } else if (_offset.dx > threshold) {
      widget.onSwipeRight();
    } else if (_offset.dy < -threshold) {
      widget.onSwipeUp();
    } else if (_offset.dy > threshold) {
      widget.onSwipeDown();
    }

    _resetPosition();
  }

  void _resetPosition() {
    _backAnimation = Tween<Offset>(
      begin: _offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.reset();
    _controller.forward();

    _controller.addListener(() {
      setState(() {
        _offset = _backAnimation.value;
        _rotation = _rotation * (1 - _controller.value);
        if (_controller.isCompleted) _isDragging = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final opacity = (_offset.distance / 100).clamp(0.0, 1.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Rating Overlays (only visible while dragging)
        _RatingOverlay(
          label: 'Again',
          direction: Alignment.centerLeft,
          color: Colors.red.shade400,
          isActive: _offset.dx < -100,
          opacity: _isDragging ? opacity : 0,
        ),
        _RatingOverlay(
          label: 'Good',
          direction: Alignment.centerRight,
          color: Colors.green.shade400,
          isActive: _offset.dx > 100,
          opacity: _isDragging ? opacity : 0,
        ),
        _RatingOverlay(
          label: 'Easy',
          direction: Alignment.topCenter,
          color: Colors.blue.shade400,
          isActive: _offset.dy < -100,
          opacity: _isDragging ? opacity : 0,
        ),
        _RatingOverlay(
          label: 'Hard',
          direction: Alignment.bottomCenter,
          color: Colors.orange.shade400,
          isActive: _offset.dy > 100,
          opacity: _isDragging ? opacity : 0,
        ),

        // The Card
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Transform.translate(
            offset: _offset,
            child: Transform.rotate(
              angle: _rotation,
              alignment: Alignment(
                (_anchor.dx / 150) - 1, // Normalized anchor
                (_anchor.dy / 200) - 1,
              ),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingOverlay extends StatelessWidget {
  final String label;
  final Alignment direction;
  final Color color;
  final bool isActive;
  final double opacity;

  const _RatingOverlay({
    required this.label,
    required this.direction,
    required this.color,
    required this.isActive,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: opacity * 0.8,
          child: Align(
            alignment: direction,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isActive ? 1.5 : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isActive ? 0.9 : 0.4),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      if (isActive)
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                    ],
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
