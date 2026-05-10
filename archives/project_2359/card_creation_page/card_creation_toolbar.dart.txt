import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/expandable_container.dart';
import 'package:project_2359/features/card_creation_page/menu_mode_content.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:project_2359/features/card_creation_page/card_creation_mode_content.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/selected_text_button.dart';
import 'package:project_2359/core/widgets/icon_widgets/image_occlusion_icon.dart';
import 'package:project_2359/features/card_creation_page/image_occlusion_editor.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:project_2359/core/widgets/shortcut_widgets.dart';
import 'package:flutter/services.dart';
import 'package:project_2359/core/widgets/widget_stage.dart';

enum CardCreationToolbarMode {
  collapsed,
  menu,
  cardCreation,
  imageOcclusion,
  cardsList,
  sourcesList,
}

class CardCreationToolbar extends StatefulWidget {
  const CardCreationToolbar({
    super.key,
    required this.context,
    required this.containerController,
    required this.toolbarController,
    required this.selectionNotifier,
    required this.selectedTextNotifier,
  });

  final BuildContext context;
  final ExpandableContainerController containerController;
  final ValueNotifier<dynamic> selectionNotifier;
  final ValueNotifier<String?> selectedTextNotifier;
  final CardCreationToolbarController toolbarController;

  @override
  State<CardCreationToolbar> createState() => _CardCreationToolbarState();
}

class _CardCreationToolbarState extends State<CardCreationToolbar> {
  @override
  void initState() {
    super.initState();
    widget.selectedTextNotifier.addListener(_onSelectedTextChanged);
    // Sync initial value
    _onSelectedTextChanged();
    _registerShortcuts();
  }

  void _registerShortcuts() {
    ProjectShortcutManager.registerShortcut(
      const ShortcutInfo(
        label: 'Create Card',
        key: LogicalKeyboardKey.enter,
        modifiers: [ShortcutModifier.alt],
      ),
      () {
        if (widget.selectedTextNotifier.value?.isNotEmpty == true &&
            widget.toolbarController.mode ==
                CardCreationToolbarMode.collapsed) {
          widget.toolbarController.setMode(
            CardCreationToolbarMode.cardCreation,
          );
        }
      },
    );
    ProjectShortcutManager.registerShortcut(
      const ShortcutInfo(
        label: 'Close Toolbar',
        key: LogicalKeyboardKey.keyX,
        modifiers: [ShortcutModifier.alt],
      ),
      () {
        if (widget.toolbarController.mode !=
            CardCreationToolbarMode.collapsed) {
          widget.toolbarController.setMode(CardCreationToolbarMode.collapsed);
        }
      },
    );
  }

  @override
  void dispose() {
    widget.selectedTextNotifier.removeListener(_onSelectedTextChanged);
    super.dispose();
  }

  void _onSelectedTextChanged() {
    widget.toolbarController.updateSelectedText(
      widget.selectedTextNotifier.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.toolbarController,
      builder: (context, _) {
        final isMobile = ResponsiveBreakpoints.of(context).isMobile;
        final isDesktop = !isMobile;
        final isExpanded =
            widget.toolbarController.mode !=
            CardCreationToolbarMode.collapsed;
        final fillHeight = isDesktop && isExpanded;
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 450,
          ),
          child: Column(
            mainAxisSize: fillHeight ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  if (widget.toolbarController.mode !=
                          CardCreationToolbarMode.collapsed &&
                      !ResponsiveBreakpoints.of(context).largerThan(MOBILE))
                    Align(
                      alignment: Alignment.topRight,
                      child: ShortcutDisplay(
                        hoverOnly: true,
                        info: const ShortcutInfo(
                          label: 'Close',
                          key: LogicalKeyboardKey.keyX,
                          modifiers: [ShortcutModifier.alt],
                        ),
                        child: IconButton(
                          onPressed: () => widget.toolbarController.setMode(
                            CardCreationToolbarMode.collapsed,
                          ),
                          icon: const Icon(Icons.close),
                        ),
                      ).animate().scale(duration: 100.ms).fadeIn(duration: 100.ms),
                    ),
                  Padding(
                    padding:
                        widget.toolbarController.mode !=
                            CardCreationToolbarMode.collapsed
                        ? const EdgeInsets.only(top: 12.0)
                        : EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.toolbarController.mode !=
                            CardCreationToolbarMode.collapsed)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16.0,
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: _buildTabBar(context),
                          ).animate().fadeIn(duration: 100.ms).slideY(begin: -0.05, duration: 100.ms),
                      ],
                    ),
                  ),
                ],
              ),
              if (fillHeight)
                Expanded(child: _buildContent(context))
              else
                _buildContent(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.toolbarController.mode ==
        CardCreationToolbarMode.imageOcclusion) {
      return ImageOcclusionEditor(controller: widget.toolbarController);
    }

    if (widget.toolbarController.mode == CardCreationToolbarMode.menu ||
        widget.toolbarController.mode == CardCreationToolbarMode.cardsList ||
        widget.toolbarController.mode == CardCreationToolbarMode.sourcesList) {
      final isDesktop =
          !ResponsiveBreakpoints.of(context).isMobile;
      return MenuModeContent(
        toolbarController: widget.toolbarController,
        fillHeight: isDesktop,
      );
    }

    if (widget.toolbarController.mode == CardCreationToolbarMode.cardCreation) {
      return CardCreationModeContent(
        toolbarController: widget.toolbarController,
      );
    }

    final hasSelection =
        widget.toolbarController.selectedText?.isNotEmpty == true;

    return ClipRect(
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!hasSelection)
            IconButton(
              onPressed: () => widget.toolbarController.setMode(
                CardCreationToolbarMode.imageOcclusion,
              ),
              icon: const ImageOcclusionIcon(),
            ).animate().fadeIn().scale(delay: 50.ms),
          if (hasSelection ||
              widget.toolbarController.stageController.isActive('card_action'))
            Expanded(child: _buildTextButtonContent())
          else
            const Spacer(),

          IconButton(
            onPressed: () {
              if (widget.toolbarController.mode ==
                      CardCreationToolbarMode.cardsList ||
                  widget.toolbarController.mode ==
                      CardCreationToolbarMode.sourcesList) {
                widget.toolbarController.setMode(
                  CardCreationToolbarMode.collapsed,
                );
              } else {
                widget.toolbarController.setMode(
                  CardCreationToolbarMode.cardsList,
                );
              }
            },
            icon: const FaIcon(FontAwesomeIcons.barsStaggered),
          ).animate().fadeIn().scale(delay: 100.ms),
        ],
      ),
    );
  }

  Widget _buildTextButtonContent() {
    final text = widget.toolbarController.selectedText;
    final cs = Theme.of(context).colorScheme;

    return WidgetStageSlot(
      controller: widget.toolbarController.stageController,
      id: 'card_action',
      alternate: _buildFeedbackWidget(cs),
      child: AnimatedSwitcher(
        duration: 200.ms,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final key = child.key;
          final isEntering =
              (text != null && key is ValueKey && key.value == text);

          final slideAnimation =
              Tween<Offset>(
                begin: isEntering
                    ? const Offset(0, 0.45)
                    : const Offset(0, -0.45),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slideAnimation, child: child),
          );
        },
        child: (text == null || text.isEmpty)
            ? const SizedBox.shrink(key: ValueKey('empty_text'))
            : Theme(
                data: Theme.of(context),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  child: SelectedTextButton(
                    key: ValueKey(text),
                    text: text,
                    onTap: () => widget.toolbarController.setMode(
                      CardCreationToolbarMode.cardCreation,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final mode = widget.toolbarController.mode;
    final cs = Theme.of(context).colorScheme;

    int currentIndex = 0;
    if (mode == CardCreationToolbarMode.sourcesList) {
      currentIndex = 1;
    } else if (mode == CardCreationToolbarMode.cardsList) {
      currentIndex = 2;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      height: 44,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Sliding Highlight
          AnimatedAlign(
            duration: 200.ms,
            curve: Curves.easeOutCubic,
            alignment: Alignment(
              currentIndex == 0
                  ? -1.0
                  : currentIndex == 1
                  ? 0.0
                  : 1.0,
              0.0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildTabButton(
                  context,
                  icon: Icons.edit_note_rounded,
                  label: 'Draft',
                  isActive: currentIndex == 0,
                  onTap: () => widget.toolbarController.setMode(
                    CardCreationToolbarMode.cardCreation,
                  ),
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  context,
                  icon: Icons.description_rounded,
                  label: 'Sources',
                  isActive: currentIndex == 1,
                  onTap: () => widget.toolbarController.setMode(
                    CardCreationToolbarMode.sourcesList,
                  ),
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  context,
                  icon: Icons.style_rounded,
                  label: 'Cards',
                  isActive: currentIndex == 2,
                  onTap: () => widget.toolbarController.setMode(
                    CardCreationToolbarMode.cardsList,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? cs.primary
                    : cs.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? cs.primary
                      : cs.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackWidget(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 16, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            widget.toolbarController.feedbackText ?? "Processing...",
            style: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
