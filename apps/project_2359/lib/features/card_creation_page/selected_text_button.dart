import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:project_2359/core/widgets/icon_widgets/card_icon.dart';
import 'package:project_2359/core/widgets/shortcut_widgets.dart';

class SelectedTextButton extends StatelessWidget {
  const SelectedTextButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            const CardIcon(),
            const SizedBox(width: 8),
            Flexible(
              child: ShortcutDisplay(
                showInline: true,
                info: ShortcutInfo(
                  label: 'Add Card',
                  key: LogicalKeyboardKey.enter,
                  modifiers: [ShortcutModifier.alt],
                ),
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
            ),
            // const Spacer(),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.close_rounded, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
