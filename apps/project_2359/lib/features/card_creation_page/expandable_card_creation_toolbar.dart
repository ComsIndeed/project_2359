import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/expandable_container.dart';
import 'package:project_2359/features/card_creation_page/selected_text_button.dart';

enum CardCreationToolbarMode { collapsed, cardCreation, imageOcclusion }

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
  CardCreationToolbarMode _mode = CardCreationToolbarMode.collapsed;

  @override
  Widget build(BuildContext context) {
    if (_mode == CardCreationToolbarMode.cardCreation) {
      // TODO: Implement card creation UI
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
                          onTap: () {
                            setState(() {
                              _mode = CardCreationToolbarMode.cardCreation;
                            });
                          },
                        ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement menu functionality
            },
            icon: const FaIcon(FontAwesomeIcons.barsStaggered),
          ),
        ],
      ),
    );
  }
}
