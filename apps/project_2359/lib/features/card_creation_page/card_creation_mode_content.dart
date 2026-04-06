import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/tables/card_items.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:project_2359/core/widgets/shortcut_widgets.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class CardCreationModeContent extends StatefulWidget {
  final CardCreationToolbarController toolbarController;
  const CardCreationModeContent({super.key, required this.toolbarController});

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
    _frontController = TextEditingController(
      text: widget.toolbarController.frontText,
    );
    _backController = TextEditingController(
      text: widget.toolbarController.backText,
    );

    _frontController.addListener(() {
      widget.toolbarController.setFrontText(_frontController.text);
    });
    _backController.addListener(() {
      widget.toolbarController.setBackText(_backController.text);
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

  void _saveCard() {
    final frontText = _frontController.text;
    final backText = _backController.text;

    if (frontText.isEmpty || backText.isEmpty) return;

    widget.toolbarController.addCard(
      CardItemsCompanion.insert(
        id: const Uuid().v4(),
        question: drift.Value(frontText),
        answer: drift.Value(backText),
      ),
    );
  }

  void _cancel() {
    widget.toolbarController.setMode(CardCreationToolbarMode.collapsed);
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
                final selection = widget.toolbarController.selectedText;
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
                  shape: RoundedSuperellipseBorder(
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
