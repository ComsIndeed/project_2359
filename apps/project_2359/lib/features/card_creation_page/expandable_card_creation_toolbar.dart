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
    return Flex(
      direction: widget.useVerticalToolbar ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
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

                          return _buildSelectedTextButton(text);
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
    );
  }

  Widget _buildSelectedTextButton(String text) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
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
