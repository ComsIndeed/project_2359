import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/expandable_container.dart';

enum CardCreationToolbarMode { collapsed, cardCreation, imageOcclusion }

class ExpandableCardCreationToolbar extends StatefulWidget {
  ExpandableCardCreationToolbar({
    super.key,
    required this.context,
    required this.controller,
    required this.useVerticalToolbar,
    required this.selectionNotifier,
  });

  final BuildContext context;
  final ExpandableContainerController controller;
  final bool useVerticalToolbar;
  final ValueNotifier<dynamic> selectionNotifier;

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

    final cs = Theme.of(context).colorScheme;

    return Flex(
      direction: widget.useVerticalToolbar ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: ValueListenableBuilder(
            valueListenable: widget.selectionNotifier,
            builder: (context, selection, _) {
              return AnimatedSwitcher(
                duration: 300.ms,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.95,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: (selection == null)
                    ? const SizedBox.shrink()
                    : FutureBuilder<String?>(
                        key: ValueKey(selection.hashCode),
                        future: (selection as dynamic).getSelectedText(),
                        builder: (context, snapshot) {
                          final text = snapshot.data ?? "";
                          if (text.isEmpty) return const SizedBox.shrink();

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _mode = C
                                       ardCreationToolbarMode.cardCreation;
                                });
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: cs.outlineVariant.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildPrettyCardIcon(cs),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        text.replaceAll('\n', ' '),
                                        maxLines: 1,
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
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            // TODO: Implement menu functionality
          },
          icon: const FaIcon(FontAwesomeIcons.barsStaggered),
        ),
      ],
    );
  }

  Widget _buildPrettyCardIcon(ColorScheme cs) {
    return Container(
      width: 28,
      height: 28,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, cs.tertiary],
        ),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: FaIcon(FontAwesomeIcons.plus, size: 12, color: Colors.white),
      ),
    );
  }
}
