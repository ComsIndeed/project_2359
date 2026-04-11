import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectionActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClose;
  final VoidCallback onPin;
  final VoidCallback onUnpin;
  final VoidCallback onDelete;
  final bool isUnpin;
  final bool isPinDisabled;

  const SelectionActionBar({
    super.key,
    required this.selectedCount,
    required this.onClose,
    required this.onPin,
    required this.onUnpin,
    required this.onDelete,
    this.isUnpin = false,
    this.isPinDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onClose,
            icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
            visualDensity: VisualDensity.compact,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 8),
          Text(
            "$selectedCount Selected",
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 16),
          BarAction(
            icon: FontAwesomeIcons.thumbtack,
            label: isUnpin ? "Unpin" : "Pin",
            onTap: isUnpin ? onUnpin : onPin,
            isDisabled: isPinDisabled,
          ),
          const SizedBox(width: 8),
          BarAction(
            icon: FontAwesomeIcons.trashCan,
            label: "Delete",
            onTap: onDelete,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}

class BarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isDisabled;

  const BarAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDisabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.2)
        : isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 14, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
