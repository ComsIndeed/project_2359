import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/expandable_card_creation_toolbar.dart';

class CardCreationModeContent extends StatefulWidget {
  final CardCreationToolbarController controller;
  const CardCreationModeContent({super.key, required this.controller});

  @override
  State<CardCreationModeContent> createState() =>
      _CardCreationModeContentState();
}

class _CardCreationModeContentState extends State<CardCreationModeContent> {
  late final TextEditingController _frontController;
  late final TextEditingController _backController;

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
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: cs.surfaceContainerHigh.withValues(alpha: 0.8),
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Source Header
          Row(
            children: [
              Icon(Icons.format_quote, size: 16, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                "SOURCE TEXT",
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
          StreamBuilder<String?>(
                stream: widget.controller.selectedTextStream,
                builder: (context, snapshot) {
                  final text = snapshot.data ?? "No text selected";
                  return Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      text,
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
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
            label: "FRONT",
            hint: "Question or term...",
            cs: cs,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

          const SizedBox(height: 12),

          // Back Field
          _buildTextField(
            controller: _backController,
            label: "BACK",
            hint: "Answer or definition...",
            cs: cs,
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

          const SizedBox(height: 24),

          // Bottom Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    widget.controller.setMode(
                      CardCreationToolbarMode.collapsed,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Implement card saving logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Card Saved! (Simulated)")),
                    );
                    widget.controller.resetCardFields();
                    widget.controller.setMode(
                      CardCreationToolbarMode.collapsed,
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Card"),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

          const SizedBox(height: 12),

          // Nice to have options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildOptionChip(Icons.auto_awesome, "AI Polish", cs),
                const SizedBox(width: 8),
                _buildOptionChip(Icons.image_outlined, "Add Image", cs),
                const SizedBox(width: 8),
                _buildOptionChip(Icons.tag_outlined, "Tags", cs),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required ColorScheme cs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: cs.onSurfaceVariant.withValues(alpha: 0.7),
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: cs.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionChip(IconData icon, String label, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
