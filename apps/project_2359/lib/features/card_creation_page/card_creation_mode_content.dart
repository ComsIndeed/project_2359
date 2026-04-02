import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/core/models/citation.dart';
import 'package:project_2359/core/study_material_service.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/expandable_card_creation_toolbar.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:project_2359/core/widgets/shortcut_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

class CardCreationModeContent extends StatefulWidget {
  final CardCreationToolbarController controller;
  final String folderId;
  final String? sourceId;

  const CardCreationModeContent({
    super.key,
    required this.controller,
    required this.folderId,
    this.sourceId,
  });

  @override
  State<CardCreationModeContent> createState() =>
      _CardCreationModeContentState();
}

class _CardCreationModeContentState extends State<CardCreationModeContent> {
  late final TextEditingController _frontController;
  late final TextEditingController _backController;
  final FocusNode _frontFocusNode = FocusNode();
  final FocusNode _backFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _frontController = TextEditingController(text: widget.controller.frontText);
    _backController = TextEditingController(text: widget.controller.backText);

    _frontController.addListener(() {
      widget.controller.setFrontText(_frontController.text);
    });
    _backController.addListener(() {
      widget.controller.setBackText(_backController.text);
    });

    _registerShortcuts();
  }

  void _registerShortcuts() {
    ProjectShortcutManager.registerShortcut(
      const ShortcutInfo(
        label: 'Focus Front',
        key: LogicalKeyboardKey.keyF,
        modifiers: [ShortcutModifier.alt],
      ),
      () => _frontFocusNode.requestFocus(),
    );
    ProjectShortcutManager.registerShortcut(
      const ShortcutInfo(
        label: 'Focus Back',
        key: LogicalKeyboardKey.keyB,
        modifiers: [ShortcutModifier.alt],
      ),
      () => _backFocusNode.requestFocus(),
    );
    ProjectShortcutManager.registerShortcut(
      const ShortcutInfo(
        label: 'Save Card',
        key: LogicalKeyboardKey.keyS,
        modifiers: [ShortcutModifier.alt],
      ),
      _saveCard,
    );
    ProjectShortcutManager.registerShortcut(
      const ShortcutInfo(
        label: 'Cancel',
        key: LogicalKeyboardKey.keyC,
        modifiers: [ShortcutModifier.alt],
      ),
      _cancel,
    );
  }

  Future<void> _saveCard() async {
    final front = _frontController.text.trim();
    final back = _backController.text.trim();

    if (front.isEmpty || back.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Front and back cannot be empty")),
      );
      return;
    }

    final cardService = context.read<StudyMaterialService>();
    final sourceService = context.read<SourceService>();
    final uuid = const Uuid();

    try {
      String? citationId;
      if (widget.controller.selectedText != null && widget.sourceId != null) {
        citationId = uuid.v4();
        final citation = TextCitation(
          sourceItemId: widget.sourceId!,
          text: widget.controller.selectedText!,
        );
        await sourceService.insertCitation(
          CitationItemsCompanion(
            id: drift.Value(citationId),
            sourceId: drift.Value(widget.sourceId!),
            type: const drift.Value("text"),
            citation: drift.Value(citation),
          ),
        );
      } else if (widget.controller.capturedOcclusionImage != null &&
          widget.sourceId != null) {
        // Handle image occlusion or just image citation
        citationId = uuid.v4();
        // For now, let's assume it's an image citation
        // We'll need pageNumber from the controller eventually
        final citation = ImageCitation(
          sourceItemId: widget.sourceId!,
          rect: widget.controller.occlusionRect ?? Rect.zero,
          pageNumber: 1, // Defaulting to 1 for now
        );
        await sourceService.insertCitation(
          CitationItemsCompanion(
            id: drift.Value(citationId),
            sourceId: drift.Value(widget.sourceId!),
            type: const drift.Value("image"),
            citation: drift.Value(citation),
          ),
        );

        await sourceService.insertCitationBlob(
          CitationBlobsCompanion(
            id: drift.Value(uuid.v4()),
            citationId: drift.Value(citationId),
            bytes: drift.Value(widget.controller.capturedOcclusionImage!),
          ),
        );
      }

      final cardId = widget.controller.editingCardId ?? uuid.v4();
      final card = StudyCardItemsCompanion(
        id: drift.Value(cardId),
        folderId: drift.Value(widget.folderId),
        type: const drift.Value("flashcard"),
        question: drift.Value(front),
        answer: drift.Value(back),
        citationIds: drift.Value(citationId != null ? [citationId] : null),
      );

      if (widget.controller.isEditing) {
        await cardService.updateCard(card);
      } else {
        await cardService.insertCard(card);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.controller.isEditing ? "Card Updated!" : "Card Added!",
            ),
          ),
        );
        widget.controller.resetCardFields();
        widget.controller.setMode(CardCreationToolbarMode.collapsed);
        if (widget.controller.isEditing) widget.controller.stopEditing();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to save card: $e")));
      }
    }
  }

  void _cancel() {
    widget.controller.setMode(CardCreationToolbarMode.collapsed);
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    _frontFocusNode.dispose();
    _backFocusNode.dispose();
    _unregisterShortcuts();
    super.dispose();
  }

  void _unregisterShortcuts() {
    // Ideally ShortcutManager should have a way to unregister by label or key
    // For now, I'll just leave it or improve ShortcutManager
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Source Header
        Row(
          children: [
            Icon(Icons.format_quote, size: 12, color: cs.primary),
            const SizedBox(width: 4),
            Text(
              "Source Text",
              style: textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),

        const SizedBox(height: 8),

        // Source Container
        Builder(
              builder: (context) {
                final selection = widget.controller.selectedText;
                final isPlaceholder = selection == null || selection.isEmpty;
                final text = isPlaceholder ? "No text selected" : selection;

                return Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                        ),
                        border: Border(
                          left: BorderSide(
                            color: cs.primary.withValues(alpha: 0.6),
                            width: 5,
                          ),
                        ),
                      ),
                      child: Text(
                        text,
                        style: textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                          letterSpacing: 0.3,
                          color: isPlaceholder
                              ? cs.onSurfaceVariant.withValues(alpha: 0.4)
                              : cs.onSurfaceVariant,
                        ),
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 8,
                      child: Icon(
                        Icons.format_quote,
                        color: cs.primary.withValues(alpha: 0.1),
                        size: 32,
                      ),
                    ),
                  ],
                );
              },
            )
            .animate()
            .fadeIn(delay: 100.ms)
            .scale(begin: const Offset(0.98, 0.98)),

        const SizedBox(height: 20),

        // Front Field
        _buildTextField(
          controller: _frontController,
          focusNode: _frontFocusNode,
          label: "Front",
          cs: cs,
          shortcut: const ShortcutInfo(
            label: 'Focus Front',
            key: LogicalKeyboardKey.keyF,
            modifiers: [ShortcutModifier.alt],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

        const SizedBox(height: 4),

        // Back Field
        _buildTextField(
          controller: _backController,
          focusNode: _backFocusNode,
          label: "Back",
          cs: cs,
          shortcut: const ShortcutInfo(
            label: 'Focus Back',
            key: LogicalKeyboardKey.keyB,
            modifiers: [ShortcutModifier.alt],
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

        const SizedBox(height: 8),

        // Bottom Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ShortcutDisplay(
              hoverOnly: true,
              info: const ShortcutInfo(
                label: 'Image',
                key: LogicalKeyboardKey.keyI,
                modifiers: [ShortcutModifier.alt],
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.image_outlined),
              ),
            ),
            ShortcutDisplay(
              hoverOnly: true,
              info: const ShortcutInfo(
                label: 'Tags',
                key: LogicalKeyboardKey.keyT,
                modifiers: [ShortcutModifier.alt],
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.tag_outlined),
              ),
            ),
            const Spacer(),
            ShortcutDisplay(
              info: const ShortcutInfo(
                label: 'Cancel',
                key: LogicalKeyboardKey.keyC,
                modifiers: [ShortcutModifier.alt],
              ),
              child: TextButton(
                onPressed: _cancel,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: cs.onSurfaceVariant.withValues(alpha: 0.8),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ShortcutDisplay(
              info: const ShortcutInfo(
                label: 'Add Card',
                key: LogicalKeyboardKey.keyS,
                modifiers: [ShortcutModifier.alt],
              ),
              child: FilledButton.icon(
                onPressed: _saveCard,
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary.withAlpha(50),
                ),
                icon: const Icon(Icons.add_rounded, size: 22),
                label: const Text("Add Card"),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required ColorScheme cs,
    required ShortcutInfo shortcut,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          minLines: 2,
          maxLines: null,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: cs.surface.withAlpha(100),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShortcutCombinationWidget(info: shortcut, isSmall: true),
            ),
          ),
        ),
      ],
    );
  }
}
