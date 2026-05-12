import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/features/anki_import_page/services/anki_import_service.dart';

class ImportResultDialog extends StatelessWidget {
  final AnkiImportResult result;
  final VoidCallback? onViewCollection;

  const ImportResultDialog({
    super.key,
    required this.result,
    this.onViewCollection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasWarnings = result.warnings.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: (hasWarnings ? Colors.amber : cs.primary).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  hasWarnings
                      ? FontAwesomeIcons.triangleExclamation
                      : FontAwesomeIcons.circleCheck,
                  color: hasWarnings ? Colors.amber.shade700 : cs.primary,
                  size: 22,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                hasWarnings ? 'Import Complete (with warnings)' : 'Import Successful',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Added to "${result.collectionName}"',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 20),
              // Stats row
              _StatsRow(result: result),
              // Warnings
              if (hasWarnings) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${result.warnings.length} warning${result.warnings.length == 1 ? '' : 's'}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...result.warnings.take(5).map(
                        (w) => Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '• $w',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                        ),
                      ),
                      if (result.warnings.length > 5)
                        Text(
                          '…and ${result.warnings.length - 5} more',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  if (onViewCollection != null) ...[
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onViewCollection!();
                      },
                      icon: const FaIcon(FontAwesomeIcons.layerGroup, size: 13),
                      label: const Text('View Collection'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final AnkiImportResult result;
  const _StatsRow({required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          icon: FontAwesomeIcons.solidFolder,
          label: '${result.deckCount}',
          sublabel: 'decks',
        ),
        const SizedBox(width: 8),
        _StatChip(
          icon: FontAwesomeIcons.fileLines,
          label: '${result.noteCount}',
          sublabel: 'notes',
        ),
        const SizedBox(width: 8),
        _StatChip(
          icon: FontAwesomeIcons.clone,
          label: '${result.cardCount}',
          sublabel: 'cards',
        ),
        const SizedBox(width: 8),
        _StatChip(
          icon: FontAwesomeIcons.image,
          label: '${result.mediaCount}',
          sublabel: 'media',
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            FaIcon(icon, size: 13, color: cs.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              sublabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
