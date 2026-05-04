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
  bool _isTransitioning = false;
  List<CardItem>? _cards;
  ContinuousSessionController? _continuousController;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<_SwipeableCardStackState> _swipeKey = GlobalKey();
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

  CardItem? get _nextCard {
    if (widget.mode == StudySessionMode.continuous) {
      return _continuousController?.peekNextCard;
    }
    if (_cards == null || _currentIndex + 1 >= _cards!.length) return null;
    return _cards![_currentIndex + 1];
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
    if (_isTransitioning) return;
    final card = _currentCard;
    if (card == null) return;

    setState(() => _isTransitioning = true);

    // Determine throw direction based on screen size to ensure it clears
    final size = MediaQuery.of(context).size;
    Offset direction;
    switch (rating) {
      case fsrs.Rating.again:
        direction = Offset(-size.width * 1.5, 0);
        break;
      case fsrs.Rating.good:
        direction = Offset(size.width * 1.5, 0);
        break;
      case fsrs.Rating.easy:
        direction = Offset(0, -size.height * 1.5);
        break;
      case fsrs.Rating.hard:
        direction = Offset(0, size.height * 1.5);
        break;
    }

    // Start animation and DB update in parallel
    final throwFuture = _swipeKey.currentState?.throwOut(direction);
    final appController = context.read<AppController>();
    final dbFuture = appController.schedulingService.reviewCard(
      cardId: card.id,
      rating: rating,
      mode: widget.mode,
    );

    // Wait for the animation to finish before switching cards
    await throwFuture;

    if (widget.mode == StudySessionMode.spaced) {
      if (mounted) {
        if (_currentIndex < _cards!.length - 1) {
          setState(() {
            _currentIndex++;
            _isFlipped = false;
            _isTransitioning = false;
          });
          _swipeKey.currentState?.resetImmediate();
          _updatePreviews();
        } else {
          Navigator.pop(context);
        }
      }
    } else {
      _continuousController!.submitRating(rating);
      if (mounted) {
        setState(() {
          _isFlipped = false;
          _isTransitioning = false;
        });
        _swipeKey.currentState?.resetImmediate();
      }
    }

    // Ensure DB update is also finished eventually
    await dbFuture;
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
              const Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text("Deck Finished!", style: theme.textTheme.headlineSmall),
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
            if (event.logicalKey == LogicalKeyboardKey.digit1)
              _rateCard(fsrs.Rating.again);
            if (event.logicalKey == LogicalKeyboardKey.digit2)
              _rateCard(fsrs.Rating.hard);
            if (event.logicalKey == LogicalKeyboardKey.digit3)
              _rateCard(fsrs.Rating.good);
            if (event.logicalKey == LogicalKeyboardKey.digit4)
              _rateCard(fsrs.Rating.easy);
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
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
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
              child: _SwipeableCardStack(
                key: _swipeKey,
                isFlipped: _isFlipped,
                isTransitioning: _isTransitioning,
                onSwipeLeft: () => _rateCard(fsrs.Rating.again),
                onSwipeRight: () => _rateCard(fsrs.Rating.good),
                onSwipeUp: () => _rateCard(fsrs.Rating.easy),
                onSwipeDown: () => _rateCard(fsrs.Rating.hard),
                backgroundCard: _nextCard == null
                    ? null
                    : FlippableCard(
                        key: ValueKey('bg_${_nextCard!.id}'),
                        isFlipped: false,
                        frontText: _nextCard!.frontText ?? '',
                        backText: _nextCard!.backText ?? '',
                        onTap: () {},
                      ),
                child: FlippableCard(
                  key: ValueKey('top_${card.id}'),
                  isFlipped: _isFlipped,
                  frontText: card.frontText ?? '',
                  backText: card.backText ?? '',
                  onTap: _flipCard,
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

class _SwipeableCardStack extends StatefulWidget {
  final Widget child;
  final Widget? backgroundCard;
  final bool isFlipped;
  final bool isTransitioning;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeDown;

  const _SwipeableCardStack({
    super.key,
    required this.child,
    this.backgroundCard,
    required this.isFlipped,
    required this.isTransitioning,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onSwipeUp,
    required this.onSwipeDown,
  });

  @override
  State<_SwipeableCardStack> createState() => _SwipeableCardStackState();
}

class _SwipeableCardStackState extends State<_SwipeableCardStack>
    with TickerProviderStateMixin {
  Offset _offset = Offset.zero;
  Offset _anchor = Offset.zero;
  double _rotation = 0.0;
  bool _isDragging = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.isFlipped || widget.isTransitioning) return;
    setState(() {
      _isDragging = true;
      _anchor = details.localPosition;
    });
    _controller.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isFlipped || widget.isTransitioning) return;
    setState(() {
      _offset += details.delta;
      final center = const Offset(150, 200);
      final distFromCenter = _anchor - center;
      _rotation = (_offset.dx / 300) * (distFromCenter.dy / 200).clamp(-1, 1);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isFlipped || widget.isTransitioning) return;
    final threshold = 120.0;

    if (_offset.dx < -threshold) {
      widget.onSwipeLeft();
    } else if (_offset.dx > threshold) {
      widget.onSwipeRight();
    } else if (_offset.dy < -threshold) {
      widget.onSwipeUp();
    } else if (_offset.dy > threshold) {
      widget.onSwipeDown();
    } else {
      _resetPosition();
    }
  }

  Future<void> throwOut(Offset direction) async {
    final animation = Tween<Offset>(
      begin: _offset,
      end: direction,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.reset();
    void listener() {
      setState(() {
        _offset = animation.value;
        _rotation = (_offset.dx / 300) * 0.2;
      });
    }

    _controller.addListener(listener);
    try {
      await _controller.forward().orCancel;
    } catch (e) {
    } finally {
      _controller.removeListener(listener);
    }
  }

  void resetImmediate() {
    setState(() {
      _offset = Offset.zero;
      _rotation = 0.0;
      _isDragging = false;
    });
    _controller.reset();
  }

  void _resetPosition() {
    final beginOffset = _offset;
    final beginRotation = _rotation;
    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.reset();
    void listener() {
      setState(() {
        _offset = Offset.lerp(beginOffset, Offset.zero, animation.value)!;
        _rotation = beginRotation * (1 - animation.value);
      });
    }

    _controller.addListener(listener);
    _controller.forward().then((_) {
      _controller.removeListener(listener);
      setState(() => _isDragging = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final threshold = 100.0;
    final leftIntensity = (-_offset.dx / threshold).clamp(0.0, 1.0);
    final rightIntensity = (_offset.dx / threshold).clamp(0.0, 1.0);
    final upIntensity = (-_offset.dy / threshold).clamp(0.0, 1.0);
    final downIntensity = (_offset.dy / threshold).clamp(0.0, 1.0);

    fsrs.Rating? activeRating;
    if (leftIntensity >= 1.0) activeRating = fsrs.Rating.again;
    else if (rightIntensity >= 1.0) activeRating = fsrs.Rating.good;
    else if (upIntensity >= 1.0) activeRating = fsrs.Rating.easy;
    else if (downIntensity >= 1.0) activeRating = fsrs.Rating.hard;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Edge Gradients
        _EdgeGradient(
          direction: Alignment.centerLeft,
          color: Colors.red.shade400,
          intensity: leftIntensity,
          isVisible: _isDragging,
        ),
        _EdgeGradient(
          direction: Alignment.centerRight,
          color: Colors.green.shade400,
          intensity: rightIntensity,
          isVisible: _isDragging,
        ),
        _EdgeGradient(
          direction: Alignment.topCenter,
          color: Colors.blue.shade400,
          intensity: upIntensity,
          isVisible: _isDragging,
        ),
        _EdgeGradient(
          direction: Alignment.bottomCenter,
          color: Colors.orange.shade400,
          intensity: downIntensity,
          isVisible: _isDragging,
        ),

        // Background Card Area
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.backgroundCard != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.identity()
                      ..translate(0.0, widget.isTransitioning ? 0.0 : 12.0),
                    child: AnimatedScale(
                      scale: widget.isTransitioning ? 1.0 : 0.94,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        opacity: widget.isTransitioning ? 1.0 : 0.4,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        child: widget.backgroundCard!,
                      ),
                    ),
                  ),
                
                // Top Card (Draggable)
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Transform.translate(
                    offset: _offset,
                    child: Transform.rotate(
                      angle: _rotation,
                      alignment: Alignment(
                        (_anchor.dx / 150) - 1,
                        (_anchor.dy / 200) - 1,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Top Selection Indicator
        if (_isDragging && activeRating != null)
          _TopSelectionOverlay(rating: activeRating),
      ],
    );
  }
}

class _EdgeGradient extends StatelessWidget {
  final Alignment direction;
  final Color color;
  final double intensity;
  final bool isVisible;

  const _EdgeGradient({
    required this.direction,
    required this.color,
    required this.intensity,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: isVisible ? (intensity * 0.3).clamp(0.0, 0.3) : 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: direction,
                end: Alignment.center,
                colors: [
                  color.withValues(alpha: 0.8),
                  color.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopSelectionOverlay extends StatelessWidget {
  final fsrs.Rating rating;

  const _TopSelectionOverlay({required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String label = '';
    Color color = Colors.grey;

    switch (rating) {
      case fsrs.Rating.again: label = 'AGAIN'; color = Colors.red.shade400; break;
      case fsrs.Rating.hard: label = 'HARD'; color = Colors.orange.shade400; break;
      case fsrs.Rating.good: label = 'GOOD'; color = Colors.green.shade400; break;
      case fsrs.Rating.easy: label = 'EASY'; color = Colors.blue.shade400; break;
    }

    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: IgnorePointer(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

