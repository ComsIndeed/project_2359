import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:project_2359/app_database.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/app_controller.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:project_2359/features/study_page/flippable_card.dart';
import 'package:project_2359/core/tables/study_session_events.dart';
import 'package:project_2359/core/services/continuous_session_controller.dart';

class StudyPage extends StatefulWidget {
  final String deckId;
  final String deckName;
  final bool isNested;
  final StudySessionMode mode;

  const StudyPage({
    super.key,
    required this.deckId,
    required this.deckName,
    this.isNested = false,
    this.mode = StudySessionMode.spaced,
  });

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int _currentIndex = 0;
  bool _isFlipped = false;
  List<CardItem>? _cards;
  ContinuousSessionController? _continuousController;
  final FocusNode _focusNode = FocusNode();
  Map<fsrs.Rating, String> _previews = {};

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
    final appController = context.read<AppController>();
    final schedulingService = appController.schedulingService;

    if (widget.mode == StudySessionMode.spaced) {
      final cards = await schedulingService
          .watchDueCards(deckId: widget.deckId)
          .first;
      if (mounted) {
        setState(() {
          _cards = cards;
        });
        _updatePreviews();
      }
    } else {
      final cards = await schedulingService.getAllCardsForDeck(widget.deckId);
      if (mounted) {
        setState(() {
          _cards = cards;
          _continuousController = ContinuousSessionController(cards);
        });
      }
    }
  }

  CardItem? get _currentCard {
    if (widget.mode == StudySessionMode.continuous) {
      return _continuousController?.nextCard;
    }
    if (_cards == null || _currentIndex >= _cards!.length) return null;
    return _cards![_currentIndex];
  }

  Future<void> _updatePreviews() async {
    if (widget.mode != StudySessionMode.spaced || _currentCard == null) return;
    
    final schedulingService = context.read<AppController>().schedulingService;
    final Map<fsrs.Rating, String> newPreviews = {};
    
    for (final rating in fsrs.Rating.values) {
      final nextDue = await schedulingService.getPreviewNextDue(
        cardId: _currentCard!.id,
        rating: rating,
        mode: widget.mode,
      );
      newPreviews[rating] = _formatInterval(nextDue);
    }
    
    if (mounted) {
      setState(() => _previews = newPreviews);
    }
  }

  String _formatInterval(DateTime due) {
    final diff = due.difference(DateTime.now());
    if (diff.inDays >= 365) return '${(diff.inDays / 365).toStringAsFixed(1)}y';
    if (diff.inDays >= 30) return '${(diff.inDays / 30).round()}mo';
    if (diff.inDays >= 1) return '${diff.inDays}d';
    if (diff.inHours >= 1) return '${diff.inHours}h';
    return '${diff.inMinutes}m';
  }

  void _flipCard() {
    if (_currentCard == null) return;
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _rateCard(fsrs.Rating rating) async {
    final card = _currentCard;
    if (card == null) return;

    final appController = context.read<AppController>();

    await appController.schedulingService.reviewCard(
      cardId: card.id,
      rating: rating,
      mode: widget.mode,
    );

    if (widget.mode == StudySessionMode.spaced) {
      if (mounted) {
        if (_currentIndex < _cards!.length - 1) {
          setState(() {
            _currentIndex++;
            _isFlipped = false;
          });
          _updatePreviews();
        } else {
          Navigator.pop(context);
        }
      }
    } else {
      // Continuous Mode: still manage the local queue, but results are now saved to DB
      _continuousController!.submitRating(rating);
      if (mounted) {
        setState(() {
          _isFlipped = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = _currentCard;

    if (_cards == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (card == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                "Deck Finished!",
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back to Folder"),
              ),
            ],
          ),
        ),
      );
    }

    final content = KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            if (!_isFlipped) {
              _flipCard();
            }
          } else if (_isFlipped) {
            if (event.logicalKey == LogicalKeyboardKey.digit1) _rateCard(fsrs.Rating.again);
            if (event.logicalKey == LogicalKeyboardKey.digit2) _rateCard(fsrs.Rating.hard);
            if (event.logicalKey == LogicalKeyboardKey.digit3) _rateCard(fsrs.Rating.good);
            if (event.logicalKey == LogicalKeyboardKey.digit4) _rateCard(fsrs.Rating.easy);
          }
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const ProjectBackButton(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.deckName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.mode == StudySessionMode.spaced
                              ? "Scheduled Review"
                              : "Continuous Mode",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.mode == StudySessionMode.spaced 
                      ? "${_currentIndex + 1} / ${_cards!.length}"
                      : "Reviewed: ${_continuousController?.totalReviews}",
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            if (widget.mode == StudySessionMode.spaced)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _cards!.length,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: _SwipeableCardWrapper(
                    isFlipped: _isFlipped,
                    onSwipeLeft: () => _rateCard(fsrs.Rating.again),
                    onSwipeRight: () => _rateCard(fsrs.Rating.good),
                    onSwipeUp: () => _rateCard(fsrs.Rating.easy),
                    onSwipeDown: () => _rateCard(fsrs.Rating.hard),
                    child: FlippableCard(
                      isFlipped: _isFlipped,
                      frontText: card.frontText ?? '',
                      backText: card.backText ?? '',
                      onTap: _flipCard,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: !_isFlipped
                    ? _FlipButton(label: 'Show Answer', onPressed: _flipCard)
                    : Row(
                        children: [
                          _FsrsButton(
                            label: 'Again',
                            subtitle: _previews[fsrs.Rating.again],
                            color: Colors.red.shade400,
                            onPressed: () => _rateCard(fsrs.Rating.again),
                          ),
                          const SizedBox(width: 8),
                          _FsrsButton(
                            label: 'Hard',
                            subtitle: _previews[fsrs.Rating.hard],
                            color: Colors.orange.shade400,
                            onPressed: () => _rateCard(fsrs.Rating.hard),
                          ),
                          const SizedBox(width: 8),
                          _FsrsButton(
                            label: 'Good',
                            subtitle: _previews[fsrs.Rating.good],
                            color: Colors.green.shade400,
                            onPressed: () => _rateCard(fsrs.Rating.good),
                          ),
                          const SizedBox(width: 8),
                          _FsrsButton(
                            label: 'Easy',
                            subtitle: _previews[fsrs.Rating.easy],
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
  final String? subtitle;
  final Color color;
  final VoidCallback onPressed;

  const _FsrsButton({
    required this.label,
    this.subtitle,
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
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color.withValues(alpha: 0.7),
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
