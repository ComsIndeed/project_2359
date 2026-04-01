import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/expandable_container.dart';
import 'package:project_2359/core/widgets/icon_widgets/card_icon.dart';

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
            child: ValueListenableBuilder(
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
                      : _buildSelectedTextButton(text, key: ValueKey(text)),
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

  Widget _buildSelectedTextButton(String text, {Key? key}) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      key: key,
      onTap: () {
        setState(() {
          _mode = CardCreationToolbarMode.cardCreation;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            const CardIcon(),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text.replaceAll('\n', ' '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
