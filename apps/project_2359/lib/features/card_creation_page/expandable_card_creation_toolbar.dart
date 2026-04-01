import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/expandable_container.dart';
import 'package:project_2359/features/card_creation_page/card_creation_mode_content.dart';
import 'package:project_2359/features/card_creation_page/card_creation_toolbar_controller.dart';
import 'package:project_2359/features/card_creation_page/selected_text_button.dart';

enum CardCreationToolbarMode { collapsed, menu, cardCreation, imageOcclusion }

class ExpandableCardCreationToolbar extends StatefulWidget {
  const ExpandableCardCreationToolbar({
    super.key,
    required this.context,
    required this.controller,
    required this.useVerticalToolbar,
    required this.selectionNotifier,
    required this.selectedTextNotifier,
  });

  final BuildContext context;
  final ExpandableContainerController controller;
  final bool useVerticalToolbar;
  final ValueNotifier<dynamic> selectionNotifier;
  final ValueNotifier<String?> selectedTextNotifier;

  @override
  State<ExpandableCardCreationToolbar> createState() =>
      _ExpandableCardCreationToolbarState();
}

class _ExpandableCardCreationToolbarState
    extends State<ExpandableCardCreationToolbar> {
  final _toolbarController = CardCreationToolbarController();

  @override
  void initState() {
    super.initState();
    widget.selectedTextNotifier.addListener(_onSelectedTextChanged);
    // Sync initial value
    _onSelectedTextChanged();
  }

  @override
  void dispose() {
    widget.selectedTextNotifier.removeListener(_onSelectedTextChanged);
    _toolbarController.dispose();
    super.dispose();
  }

  void _onSelectedTextChanged() {
    _toolbarController.updateSelectedText(widget.selectedTextNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _toolbarController,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                if (_toolbarController.mode !=
                    CardCreationToolbarMode.collapsed)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => _toolbarController.setMode(
                        CardCreationToolbarMode.collapsed,
                      ),
                      icon: const Icon(Icons.close),
                    ).animate().scale().fadeIn(),
                  ),
                Padding(
                  padding:
                      _toolbarController.mode !=
                          CardCreationToolbarMode.collapsed
                      ? const EdgeInsets.only(top: 32.0)
                      : EdgeInsets.zero,
                  child: _buildContent(context),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_toolbarController.mode == CardCreationToolbarMode.imageOcclusion) {
      return const Text("Image Occlusion");
    }

    if (_toolbarController.mode == CardCreationToolbarMode.menu) {
      return const Text("Menu");
    }

    if (_toolbarController.mode == CardCreationToolbarMode.cardCreation) {
      return CardCreationModeContent(controller: _toolbarController);
    }

    return ClipRect(
      child: Flex(
        direction: widget.useVerticalToolbar ? Axis.vertical : Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ValueListenableBuilder<String?>(
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
                      child: SlideTransition(
                        position: slideAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: (text == null || text.isEmpty)
                      ? const SizedBox.shrink(key: ValueKey('empty_text'))
                      : SelectedTextButton(
                          key: ValueKey(text),
                          text: text,
                          onTap: () => _toolbarController.setMode(
                            CardCreationToolbarMode.cardCreation,
                          ),
                        ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () =>
                _toolbarController.setMode(CardCreationToolbarMode.menu),
            icon: const FaIcon(FontAwesomeIcons.barsStaggered),
          ).animate().fadeIn().scale(delay: 200.ms),
        ],
      ),
    );
  }
}
