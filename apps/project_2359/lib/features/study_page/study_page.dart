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
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/study_page/widgets/source_preview_sheet.dart';
import 'package:provider/provider.dart';

class StudyPage extends StatefulWidget {
  final String? deckId;
  final String? collectionId;
  final String title;
  final bool isNested;
  final StudySessionMode mode;

  const StudyPage({
    super.key,
    this.deckId,
    this.collectionId,
    required this.title,
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

    List<CardItem> cards;

    if (widget.mode == StudySessionMode.spaced) {
      if (widget.deckId != null) {
        cards = await schedulingService
            .watchDueCards(deckId: widget.deckId!)
            .first;
      } else if (widget.collectionId != null) {
        cards = await schedulingService
            .watchDueCardItemsForCollection(collectionId: widget.collectionId!)
            .first;
      } else {
        cards = await schedulingService.watchTotalDueCardItems().first;
      }
    } else {
      // Continuous mode currently only supports single decks in this implementation
      // but we could extend it if needed.
      if (widget.deckId != null) {
        cards = await schedulingService.getAllCardsForDeck(widget.deckId!);
      } else {
        cards = [];
      }
    }

    if (mounted) {
      setState(() {
        _cards = cards;
        if (widget.mode == StudySessionMode.continuous) {
          _continuousController = ContinuousSessionController(cards);
        }
      });
      _updatePreviews();
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

  void _onViewSourcePressed() async {
    final card = _currentCard;
    if (card == null || card.citationId == null) return;

    final appController = context.read<AppController>();
    final sourceService = context.read<SourceService>();

    final citation = await appController.studyDatabaseService.getCitationById(
      card.citationId!,
    );
    if (citation == null || citation.sourceIds?.isEmpty == true) return;

    final sourceId = citation.sourceIds!.first;
    final sourceBlob = await sourceService.getSourceBlobBySourceId(sourceId);
    if (sourceBlob == null) return;

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SourcePreviewSheet(
            pdfBytes: sourceBlob.bytes,
            citation: citation,
          ),
    );
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
                child: const Text("Back to Collection"),
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
            if (event.logicalKey == LogicalKeyboardKey.digit1) {
              _rateCard(fsrs.Rating.again);
            }
            if (event.logicalKey == LogicalKeyboardKey.digit2) {
              _rateCard(fsrs.Rating.hard);
            }
            if (event.logicalKey == LogicalKeyboardKey.digit3) {
              _rateCard(fsrs.Rating.good);
            }
            if (event.logicalKey == LogicalKeyboardKey.digit4) {
              _rateCard(fsrs.Rating.easy);
            }
          }
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            // Header and Progress Bar (Now in the background of the stack)
            Column(
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
                              widget.title,
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
              ],
            ),

            // Immersive Card Stack (Now at the very top of the Z-order)
            _SwipeableCardStack(
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
                      onViewSource:
                          _nextCard!.citationId != null
                              ? _onViewSourcePressed
                              : null,
                    ),
              overlay: Padding(
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
              child: FlippableCard(
                key: ValueKey('top_${card.id}'),
                isFlipped: _isFlipped,
                frontText: card.frontText ?? '',
                backText: card.backText ?? '',
                onTap: _flipCard,
                onViewSource:
                    card.citationId != null ? _onViewSourcePressed : null,
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
  final Widget? overlay;
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
    this.overlay,
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
  Offset? _currentPosition;
  Offset _globalCenter = Offset.zero;
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

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      _globalCenter = box.localToGlobal(box.size.center(Offset.zero));
    }

    setState(() {
      _isDragging = true;
      _anchor = details.localPosition;
      _currentPosition = details.globalPosition;
    });
    _controller.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isFlipped || widget.isTransitioning) return;
    setState(() {
      _offset += details.delta;
      _currentPosition = details.globalPosition;
      final center = const Offset(150, 200);
      final distFromCenter = _anchor - center;
      _rotation = (_offset.dx / 300) * (distFromCenter.dy / 200).clamp(-1, 1);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isFlipped || widget.isTransitioning) return;

    final velocity = details.velocity.pixelsPerSecond;

    final pos = _currentPosition ?? _globalCenter;
    final dragX = pos.dx - _globalCenter.dx;
    final dragY = pos.dy - _globalCenter.dy;

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final thresholdX = box.size.width * 0.2;
    final thresholdY = box.size.height * 0.15;
    final thresholdUp = box.size.height * 0.08;

    // Check flick first
    const flickVelocity = 800.0;

    if (velocity.dx < -flickVelocity) {
      widget.onSwipeLeft();
    } else if (velocity.dx > flickVelocity) {
      widget.onSwipeRight();
    } else if (velocity.dy < -flickVelocity) {
      widget.onSwipeUp();
    } else if (velocity.dy > flickVelocity) {
      widget.onSwipeDown();
    }
    // Then check position threshold
    else if (dragX < -thresholdX) {
      widget.onSwipeLeft();
    } else if (dragX > thresholdX) {
      widget.onSwipeRight();
    } else if (dragY < -thresholdUp) {
      widget.onSwipeUp();
    } else if (dragY > thresholdY) {
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
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final pos = _currentPosition ?? _globalCenter;
        final dragX = pos.dx - _globalCenter.dx;
        final dragY = pos.dy - _globalCenter.dy;

        final thresholdX = constraints.maxWidth * 0.2;
        final thresholdY = constraints.maxHeight * 0.15;
        final thresholdUp = constraints.maxHeight * 0.08;

        final leftIntensity = (-dragX / thresholdX).clamp(0.0, 1.0);
        final rightIntensity = (dragX / thresholdX).clamp(0.0, 1.0);
        final upIntensity = (-dragY / thresholdUp).clamp(0.0, 1.0);
        final downIntensity = (dragY / thresholdY).clamp(0.0, 1.0);

        fsrs.Rating? activeRating;
        if (leftIntensity >= 1.0) {
          activeRating = fsrs.Rating.again;
        } else if (rightIntensity >= 1.0) {
          activeRating = fsrs.Rating.good;
        } else if (upIntensity >= 1.0) {
          activeRating = fsrs.Rating.easy;
        } else if (downIntensity >= 1.0) {
          activeRating = fsrs.Rating.hard;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Radial Edge Gradients
            _RadialGradientOverlay(
              direction: Alignment.centerLeft,
              color: Colors.red.shade400,
              intensity: leftIntensity,
              isVisible: _isDragging,
            ),
            _RadialGradientOverlay(
              direction: Alignment.centerRight,
              color: Colors.green.shade400,
              intensity: rightIntensity,
              isVisible: _isDragging,
            ),
            _RadialGradientOverlay(
              direction: Alignment.topCenter,
              color: Colors.blue.shade400,
              intensity: upIntensity,
              isVisible: _isDragging,
            ),
            _RadialGradientOverlay(
              direction: Alignment.bottomCenter,
              color: Colors.orange.shade400,
              intensity: downIntensity,
              isVisible: _isDragging,
            ),

            // Bottom Overlay (Buttons) - Moved before the card in the Z-order
            if (widget.overlay != null)
              Positioned(bottom: 0, left: 0, right: 0, child: widget.overlay!),

            // Background Card Area
            Align(
              alignment: const Alignment(0, -0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 520,
                  ),
                  child: AspectRatio(
                    aspectRatio: 0.72,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (widget.backgroundCard != null)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            transform: Matrix4.identity()
                              ..setTranslationRaw(
                                0.0,
                                widget.isTransitioning ? 0.0 : 12.0,
                                0.0,
                              ),
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
              ),
            ),

            // Top Selection Indicator
            if (_isDragging && activeRating != null)
              _TopSelectionOverlay(rating: activeRating),
          ],
        );
      },
    );
  }
}

class _RadialGradientOverlay extends StatelessWidget {
  final Alignment direction;
  final Color color;
  final double intensity;
  final bool isVisible;

  const _RadialGradientOverlay({
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
          opacity: isVisible ? (intensity * 0.7).clamp(0.0, 0.7) : 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: direction,
                radius: 0.5 + (intensity * 1.5), // Expands with drag
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
    String label = '';
    Color color = Colors.grey;

    switch (rating) {
      case fsrs.Rating.again:
        label = 'AGAIN';
        color = Colors.red.shade400;
        break;
      case fsrs.Rating.hard:
        label = 'HARD';
        color = Colors.orange.shade400;
        break;
      case fsrs.Rating.good:
        label = 'GOOD';
        color = Colors.green.shade400;
        break;
      case fsrs.Rating.easy:
        label = 'EASY';
        color = Colors.blue.shade400;
        break;
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
