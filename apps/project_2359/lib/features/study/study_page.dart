import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';
import 'package:project_2359/core/widgets/card_button.dart';

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
      });
    } else {
      // Finished session
      _showFinishedDialog();
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFlipped = false;
      });
    }
  }

  void _showFinishedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Session Finished!",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        content: Text(
          "You've completed all the cards in this pack. Great job!",
          style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.7)),
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
      backgroundColor: Colors.black,
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
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _isFlipped = !_isFlipped),
                              child: _FlashcardView(
                                question: currentCard.question ?? "",
                                answer: currentCard.answer ?? "",
                                isFlipped: _isFlipped,
                                seed: currentCard.id,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          // Control Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ControlButton(
                                icon: FontAwesomeIcons.arrowLeft,
                                label: "Back",
                                onTap: _currentIndex > 0 ? _previousCard : null,
                              ),
                              _ControlButton(
                                icon: _isFlipped
                                    ? FontAwesomeIcons.check
                                    : FontAwesomeIcons.eye,
                                label: _isFlipped ? "Next" : "Reveal",
                                isPrimary: true,
                                onTap: () {
                                  if (!_isFlipped) {
                                    setState(() => _isFlipped = true);
                                  } else {
                                    _nextCard(total);
                                  }
                                },
                              ),
                              _ControlButton(
                                icon: FontAwesomeIcons.arrowRight,
                                label: "Skip",
                                onTap: _currentIndex < total - 1
                                    ? () => _nextCard(total)
                                    : null,
                              ),
                            ],
                          ),
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Add some cards to this pack to start studying.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
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

class _FlashcardView extends StatelessWidget {
  final String question;
  final String answer;
  final bool isFlipped;
  final String seed;

  const _FlashcardView({
    required this.question,
    required this.answer,
    required this.isFlipped,
    required this.seed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final rotate = Tween(begin: pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final isUnder = (ValueKey(isFlipped) != child!.key);
            var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
            tilt *= isUnder ? -1.0 : 1.0;
            final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
            return Transform(
              transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      child: isFlipped
          ? _CardContent(
              key: const ValueKey(true),
              text: answer,
              isBack: true,
              seed: seed,
            )
          : _CardContent(
              key: const ValueKey(false),
              text: question,
              isBack: false,
              seed: seed,
            ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final String text;
  final bool isBack;
  final String seed;

  const _CardContent({
    super.key,
    required this.text,
    required this.isBack,
    required this.seed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
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
        seed: GenerationSeed.fromString(seed + (isBack ? 'back' : 'front')),
        label: text,
        icon: isBack
            ? FontAwesomeIcons.lightbulb
            : FontAwesomeIcons.solidQuestionCircle,
        borderRadius: 32,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isBack ? "ANSWER" : "QUESTION",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                text,
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: text.length > 100 ? 18 : 24,
                ),
              ),
              const Spacer(),
              FaIcon(
                isBack
                    ? FontAwesomeIcons.checkDouble
                    : FontAwesomeIcons.fingerprint,
                color: Colors.white.withValues(alpha: 0.2),
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isPrimary = false,
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
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isPrimary ? 72 : 56,
              height: isPrimary ? 72 : 56,
              decoration: BoxDecoration(
                color: isPrimary
                    ? theme.colorScheme.primary
                    : Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPrimary
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: isPrimary
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.4,
                          ),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: isPrimary ? 24 : 18,
                  color: isEnabled
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isEnabled
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.2),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
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
      Colors.black.withValues(alpha: 0.0),
      Colors.black,
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
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 1.0),
              child: SpecialBackgroundGenerator(
                type: SpecialBackgroundType.geometricSquares,
                seed: GenerationSeed.fromString(materialName),
                label: materialName,
                icon: FontAwesomeIcons.graduationCap,
                showBorder: false,
                borderRadius: 0,
                child: const SizedBox.expand(),
              ),
            ),
          ),

          // Header Content
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
                      // Progress Text
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
                            // Progress Bar
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
