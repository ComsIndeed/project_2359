import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/expandable_container.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:project_2359/features/card_creation_page/card_creation_mode_content.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/selected_text_button.dart';
import 'package:project_2359/core/widgets/icon_widgets/image_occlusion_icon.dart';
import 'package:project_2359/features/card_creation_page/widgets/image_occlusion_editor.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:project_2359/core/widgets/shortcut_widgets.dart';
import 'package:flutter/services.dart';

enum CardCreationToolbarMode { collapsed, menu, cardCreation, imageOcclusion }

class ExpandableCardCreationToolbar extends StatefulWidget {
  const ExpandableCardCreationToolbar({
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
  State<ExpandableCardCreationToolbar> createState() =>
      _ExpandableCardCreationToolbarState();
}

class _ExpandableCardCreationToolbarState
    extends State<ExpandableCardCreationToolbar> {
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
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 720,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  if (widget.toolbarController.mode !=
                      CardCreationToolbarMode.collapsed)
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
                      ).animate().scale().fadeIn(),
                    ),
                  Padding(
                    padding:
                        widget.toolbarController.mode !=
                            CardCreationToolbarMode.collapsed
                        ? const EdgeInsets.only(top: 32.0)
                        : EdgeInsets.zero,
                    child: _buildContent(context),
                  ),
                ],
              ),
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

    if (widget.toolbarController.mode == CardCreationToolbarMode.menu) {
      return const Text("Menu");
    }

    if (widget.toolbarController.mode == CardCreationToolbarMode.cardCreation) {
      return CardCreationModeContent(controller: widget.toolbarController);
    }

    return ClipRect(
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: _buildTextButtonContent()),
          IconButton(
            onPressed: () => widget.toolbarController.setMode(
              CardCreationToolbarMode.imageOcclusion,
            ),
            icon: const ImageOcclusionIcon(),
          ).animate().fadeIn().scale(delay: 100.ms),
          IconButton(
            onPressed: () =>
                widget.toolbarController.setMode(CardCreationToolbarMode.menu),
            icon: const FaIcon(FontAwesomeIcons.barsStaggered),
          ).animate().fadeIn().scale(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildTextButtonContent() {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.selectedTextNotifier,
      builder: (context, text, _) {
        return AnimatedSwitcher(
          duration: 400.ms,
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
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slideAnimation, child: child),
            );
          },
          child: (text == null || text.isEmpty)
              ? const SizedBox.shrink(key: ValueKey('empty_text'))
              : Theme(
                  // Ensure the button is constrained on desktop
                  data: Theme.of(context),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    child: ShortcutDisplay(
                      info: const ShortcutInfo(
                        label: 'Create Card',
                        key: LogicalKeyboardKey.enter,
                        modifiers: [ShortcutModifier.alt],
                      ),
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
      },
    );
  }
}
