import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/core/tables/study_card_items.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';

class StudyPage extends StatefulWidget {
  final String materialId;
  final String materialName;

  const StudyPage({
    super.key,
    required this.materialId,
    required this.materialName,
  });

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int _currentIndex = 0;
  bool _isFlipped = false;
  String? _selectedMcqChoice;
  late Stream<List<StudyCardItem>> _cardsStream;

  @override
  void initState() {
    super.initState();
    _cardsStream = context.read<StudyMaterialService>().watchCardsByMaterialId(
      widget.materialId,
    );
  }

  void _nextCard(int total) {
    if (_currentIndex < total - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
        _selectedMcqChoice = null;
      });
    } else {
      _showFinishedDialog();
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFlipped = false;
        _selectedMcqChoice = null;
      });
    }
  }

  Future<void> _handleReview(int rating, int total) async {
    // rating: 1-Again, 2-Hard, 3-Good, 4-Easy
    _nextCard(total);
  }

  void _showFinishedDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Session Finished!",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          "You've completed all the cards in this pack. Great job!",
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              "Finish",
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: StreamBuilder<List<StudyCardItem>>(
        stream: _cardsStream,
        builder: (context, snapshot) {
          final cards = snapshot.data ?? [];
          final total = cards.length;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cards.isEmpty) {
            return _buildEmptyState(context, topPadding);
          }

          final currentCard = cards[_currentIndex];

          return Stack(
            children: [
              CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StudyHeaderDelegate(
                      materialName: widget.materialName,
                      topPadding: topPadding,
                      progress: (total > 0) ? (_currentIndex + 1) / total : 0,
                      current: _currentIndex + 1,
                      total: total,
                      onBack: () => Navigator.pop(context),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _CardEntryAnimation(
                              index: _currentIndex,
                              child: _StudyCardContainer(
                                card: currentCard,
                                isFlipped: _isFlipped,
                                onFlip: () =>
                                    setState(() => _isFlipped = !_isFlipped),
                                selectedChoice: _selectedMcqChoice,
                                onChoiceSelected: (choice) {
                                  setState(() {
                                    _selectedMcqChoice = choice;
                                    _isFlipped = true;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          _buildControlPanel(context, total),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context, int total) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: !_isFlipped
          ? _buildRevealPanel(context, total)
          : _buildFsrsPanel(context, total),
    );
  }

  Widget _buildRevealPanel(BuildContext context, int total) {
    return Row(
      key: const ValueKey('reveal_panel'),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ControlButton(
          icon: FontAwesomeIcons.arrowLeft,
          label: "Back",
          btnSize: 64,
          onTap: _currentIndex > 0 ? _previousCard : null,
        ),
        _ControlButton(
          icon: FontAwesomeIcons.eye,
          label: "Reveal",
          isPrimary: true,
          btnSize: 84,
          onTap: () => setState(() => _isFlipped = true),
        ),
        _ControlButton(
          icon: FontAwesomeIcons.arrowRight,
          label: "Skip",
          btnSize: 64,
          onTap: _currentIndex < total - 1 ? () => _nextCard(total) : null,
        ),
      ],
    );
  }

  Widget _buildFsrsPanel(BuildContext context, int total) {
    return Row(
      key: const ValueKey('fsrs_panel'),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _FSRSButton(
          label: "Again",
          color: Colors.red,
          onTap: () => _handleReview(1, total),
        ),
        _FSRSButton(
          label: "Hard",
          color: Colors.orange,
          onTap: () => _handleReview(2, total),
        ),
        _FSRSButton(
          label: "Good",
          color: Colors.lightBlue,
          onTap: () => _handleReview(3, total),
        ),
        _FSRSButton(
          label: "Easy",
          color: Colors.green,
          onTap: () => _handleReview(4, total),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, double topPadding) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _StudyHeaderDelegate(
            materialName: widget.materialName,
            topPadding: topPadding,
            progress: 0,
            current: 0,
            total: 0,
            onBack: () => Navigator.pop(context),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.inbox,
                  size: 64,
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 24),
                Text(
                  "No Cards Found",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Add some cards to this pack to start studying.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FSRSButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FSRSButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  label[0].toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            color: color.withValues(alpha: 0.7),
            fontWeight: FontWeight.w900,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _CardEntryAnimation extends StatelessWidget {
  final int index;
  final Widget child;

  const _CardEntryAnimation({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(1.0, 0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        final rotationAnimation = Tween<double>(begin: 0.05, end: 0.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        final exitOffsetAnimation =
            Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInCubic),
            );

        if (child.key == ValueKey(index)) {
          return SlideTransition(
            position: offsetAnimation,
            child: RotationTransition(
              turns: rotationAnimation,
              child: FadeTransition(opacity: animation, child: child),
            ),
          );
        } else {
          return SlideTransition(
            position: exitOffsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        }
      },
      child: Container(key: ValueKey(index), child: child),
    );
  }
}

class _StudyCardContainer extends StatelessWidget {
  final StudyCardItem card;
  final bool isFlipped;
  final VoidCallback onFlip;
  final String? selectedChoice;
  final Function(String) onChoiceSelected;

  const _StudyCardContainer({
    required this.card,
    required this.isFlipped,
    required this.onFlip,
    this.selectedChoice,
    required this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMcq = card.type == StudyCardType.multipleChoiceQuestion.name;

    return _FlipTransition(
      isFlipped: isFlipped,
      front: _CardContent(
        card: card,
        isBack: false,
        onFlip: onFlip,
        isMcq: isMcq,
        selectedChoice: selectedChoice,
        onChoiceSelected: onChoiceSelected,
      ),
      back: _CardContent(
        card: card,
        isBack: true,
        onFlip: onFlip,
        isMcq: isMcq,
        selectedChoice: selectedChoice,
        onChoiceSelected: onChoiceSelected,
      ),
    );
  }
}

class _FlipTransition extends StatelessWidget {
  final bool isFlipped;
  final Widget front;
  final Widget back;

  const _FlipTransition({
    required this.isFlipped,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      tween: Tween(begin: 0.0, end: isFlipped ? pi : 0.0),
      builder: (context, value, child) {
        final bool isBack = value >= pi / 2;
        final Widget visibleChild = isBack ? back : front;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(value),
          alignment: Alignment.center,
          child: isBack
              ? Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: visibleChild,
                )
              : visibleChild,
        );
      },
    );
  }
}

class _CardContent extends StatelessWidget {
  final StudyCardItem card;
  final bool isBack;
  final VoidCallback onFlip;
  final bool isMcq;
  final String? selectedChoice;
  final Function(String)? onChoiceSelected;

  const _CardContent({
    required this.card,
    required this.isBack,
    required this.onFlip,
    required this.isMcq,
    this.selectedChoice,
    this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String text = isBack ? (card.answer ?? "") : (card.question ?? "");
    final String labelStr = isBack
        ? "ANSWER"
        : (isMcq ? "QUESTION (MCQ)" : "QUESTION");

    return GestureDetector(
      onTap: isMcq && !isBack ? null : onFlip,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: (isBack ? Colors.purple : theme.colorScheme.primary)
                  .withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SpecialBackgroundGenerator(
          type: SpecialBackgroundType.vibrantGradients,
          seed: GenerationSeed.fromString(
            card.id + (isBack ? 'back' : 'front'),
          ),
          label: text,
          icon: isBack
              ? FontAwesomeIcons.lightbulb
              : FontAwesomeIcons.solidCircleQuestion,
          borderRadius: 36,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      labelStr,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (isMcq && !isBack) ...[
                  _buildMcqFront(context, text, theme),
                ] else ...[
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: text.length > 100 ? 18 : 24,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
                const Spacer(),
                FaIcon(
                  isBack
                      ? FontAwesomeIcons.checkDouble
                      : FontAwesomeIcons.fingerprint,
                  color: Colors.white.withValues(alpha: 0.1),
                  size: 44,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMcqFront(
    BuildContext context,
    String question,
    ThemeData theme,
  ) {
    List<String> options = [];
    try {
      if (card.optionsListJson != null) {
        options = List<String>.from(jsonDecode(card.optionsListJson!));
      }
    } catch (_) {}

    return Column(
      children: [
        Text(
          question,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 32),
        ...options.map((option) {
          final isSelected = selectedChoice == option;
          final isCorrect = option == card.answer;

          Color bgColor = theme.colorScheme.onSurface.withValues(alpha: 0.08);
          if (selectedChoice != null) {
            if (isCorrect) {
              bgColor = Colors.green.withValues(alpha: 0.25);
            } else if (isSelected) {
              bgColor = Colors.red.withValues(alpha: 0.25);
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: selectedChoice == null
                    ? () => onChoiceSelected!(option)
                    : null,
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.4)
                          : Colors.white.withValues(alpha: 0.05),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Center(
                          child: selectedChoice != null && isCorrect
                              ? const FaIcon(
                                  FontAwesomeIcons.check,
                                  size: 10,
                                  color: Colors.green,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final double btnSize;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isPrimary = false,
    required this.btnSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: btnSize,
              height: btnSize,
              decoration: BoxDecoration(
                color: isPrimary
                    ? theme.colorScheme.primary
                    : Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPrimary
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                  width: 1.5,
                ),
                boxShadow: isPrimary
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.4,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: isPrimary ? 28 : 22,
                  color: isEnabled
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isEnabled
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.2),
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _StudyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String materialName;
  final double topPadding;
  final double progress;
  final int current;
  final int total;
  final VoidCallback onBack;

  _StudyHeaderDelegate({
    required this.materialName,
    required this.topPadding,
    required this.progress,
    required this.current,
    required this.total,
    required this.onBack,
  });

  static const double _collapsedBarHeight = 64.0;

  @override
  double get maxExtent => 180 + topPadding;

  @override
  double get minExtent => _collapsedBarHeight + topPadding;

  @override
  bool shouldRebuild(covariant _StudyHeaderDelegate oldDelegate) =>
      oldDelegate.materialName != materialName ||
      oldDelegate.progress != progress ||
      oldDelegate.current != current ||
      oldDelegate.total != total;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    final bgColor = Color.lerp(
      theme.scaffoldBackgroundColor.withValues(alpha: 0.0),
      theme.scaffoldBackgroundColor,
      (t * 1.5).clamp(0.0, 1.0),
    )!;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.08 * t),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 1.0),
              child: SpecialBackgroundGenerator(
                type: SpecialBackgroundType.geometricSquares,
                seed: GenerationSeed.fromString(materialName),
                label: materialName,
                icon: FontAwesomeIcons.graduationCap,
                showBorder: false,
                showShadow: false,
                borderRadius: 0,
                backgroundColor: theme.scaffoldBackgroundColor,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(
                  height: _collapsedBarHeight,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          size: 20,
                        ),
                        onPressed: onBack,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          t > 0.5 ? materialName : "STUDY SESSION",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: t > 0.5 ? 0 : 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          "$current / $total",
                          style: GoogleFonts.outfit(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (t < 0.5)
                  Expanded(
                    child: Opacity(
                      opacity: (1.0 - t * 2).clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              materialName,
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Stack(
                              children: [
                                Container(
                                  height: 6,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      height: 6,
                                      width: constraints.maxWidth * progress,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary,
                                            theme.colorScheme.primary
                                                .withValues(alpha: 0.5),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.colorScheme.primary
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
