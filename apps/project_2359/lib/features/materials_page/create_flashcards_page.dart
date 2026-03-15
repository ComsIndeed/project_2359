import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/core/tables/study_card.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/// A card in the flashcard editor — front (question) and back (answer).
class _FlashcardEntry {
  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();
  final FocusNode frontFocus = FocusNode();
  final FocusNode backFocus = FocusNode();
  final String id = const Uuid().v4();

  void dispose() {
    frontController.dispose();
    backController.dispose();
    frontFocus.dispose();
    backFocus.dispose();
  }
}

class CreateFlashcardsPage extends StatefulWidget {
  final String folderId;

  const CreateFlashcardsPage({super.key, required this.folderId});

  @override
  State<CreateFlashcardsPage> createState() => _CreateFlashcardsPageState();
}

class _CreateFlashcardsPageState extends State<CreateFlashcardsPage> {
  final TextEditingController _materialNameController = TextEditingController();
  final FocusNode _materialNameFocus = FocusNode();
  final List<_FlashcardEntry> _cards = [];
  bool _isSaving = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Start with one empty card
    _addCard(autoFocus: false);
  }

  @override
  void dispose() {
    _materialNameController.dispose();
    _materialNameFocus.dispose();
    _scrollController.dispose();
    for (final card in _cards) {
      card.dispose();
    }
    super.dispose();
  }

  void _addCard({bool autoFocus = true}) {
    final entry = _FlashcardEntry();
    setState(() {
      _cards.add(entry);
    });

    if (autoFocus) {
      // Scroll to bottom and focus the new card's front field
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
        entry.frontFocus.requestFocus();
      });
    }
  }

  void _removeCard(int index) {
    setState(() {
      _cards[index].dispose();
      _cards.removeAt(index);
    });
  }

  Future<void> _saveCards() async {
    // Validate
    final materialName = _materialNameController.text.trim();
    if (materialName.isEmpty) {
      _materialNameFocus.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Give your study material a name first',
            style: GoogleFonts.outfit(),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Filter out empty cards
    final validCards = _cards.where((c) {
      return c.frontController.text.trim().isNotEmpty &&
          c.backController.text.trim().isNotEmpty;
    }).toList();

    if (validCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Add at least one card with content on both sides',
            style: GoogleFonts.outfit(),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final service = context.read<StudyMaterialService>();
      final materialId = const Uuid().v4();

      final material = StudyMaterialItemsCompanion(
        id: Value(materialId),
        folderId: Value(widget.folderId),
        name: Value(materialName),
      );

      final cards = validCards.map((c) {
        return StudyCardItemsCompanion(
          id: Value(const Uuid().v4()),
          materialId: Value(materialId),
          type: Value(StudyCardType.flashcard.name),
          question: Value(c.frontController.text.trim()),
          answer: Value(c.backController.text.trim()),
        );
      }).toList();

      await service.createMaterialWithCards(material: material, cards: cards);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${validCards.length} cards created!',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: $e', style: GoogleFonts.outfit()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 14),
                    label: const Text("Back"),
                    style: TextButton.styleFrom(
                      foregroundColor: cs.onSurface,
                      backgroundColor: cs.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Create Cards",
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  // Card count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_cards.length}',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Content ---
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Deck (Material) name
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: cs.onSurface.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Material Name",
                            style: tt.labelMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: cs.onSurface.withValues(alpha: 0.5),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _materialNameController,
                            focusNode: _materialNameFocus,
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. Biology Chapter 5',
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface.withValues(alpha: 0.2),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) =>
                                _cards.firstOrNull?.frontFocus.requestFocus(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Cards",
                            style: tt.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _addCard,
                            icon: const FaIcon(FontAwesomeIcons.plus, size: 12),
                            label: const Text("Add card"),
                            style: TextButton.styleFrom(
                              foregroundColor: cs.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Card list
                    ...List.generate(_cards.length, (index) {
                      return _buildCardEntry(index, cs, tt);
                    }),

                    // Add card button at bottom
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CardButton(
                        icon: FontAwesomeIcons.plus,
                        label: "Add another card",
                        subLabel: "Tap to add",
                        isCompact: true,
                        layoutDirection: CardLayoutDirection.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        accentColor: cs.primary,
                        onTap: _addCard,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // --- Bottom Save Bar ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveCards,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      disabledBackgroundColor: cs.primary.withValues(
                        alpha: 0.5,
                      ),
                      shape: AppTheme.buttonShape as OutlinedBorder,
                      elevation: 8,
                      shadowColor: cs.primary.withValues(alpha: 0.4),
                    ),
                    child: _isSaving
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(cs.onPrimary),
                            ),
                          )
                        : Text(
                            "Save Material",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardEntry(int index, ColorScheme cs, TextTheme tt) {
    final card = _cards[index];

    return Dismissible(
      key: ValueKey(card.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removeCard(index),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cs.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FaIcon(FontAwesomeIcons.trash, size: 18, color: cs.error),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            // Card number badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _removeCard(index),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FaIcon(
                          FontAwesomeIcons.xmark,
                          size: 14,
                          color: cs.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Front field
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Front",
                    style: tt.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface.withValues(alpha: 0.4),
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextField(
                    controller: card.frontController,
                    focusNode: card.frontFocus,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Question or term...',
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withValues(alpha: 0.2),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      isDense: true,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => card.backFocus.requestFocus(),
                  ),
                ],
              ),
            ),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                color: cs.onSurface.withValues(alpha: 0.06),
              ),
            ),
            // Back field
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Back",
                    style: tt.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface.withValues(alpha: 0.4),
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextField(
                    controller: card.backController,
                    focusNode: card.backFocus,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface.withValues(alpha: 0.8),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Answer or definition...',
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface.withValues(alpha: 0.2),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      isDense: true,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      // Auto-add next card when pressing done on the back field
                      if (index == _cards.length - 1) {
                        _addCard();
                      } else {
                        _cards[index + 1].frontFocus.requestFocus();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
