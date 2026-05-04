import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/tables/study_session_events.dart';
import 'package:project_2359/core/widgets/project_card_tile.dart';

class StudySessionSetupSheet extends StatelessWidget {
  final String deckName;
  final int dueCount;
  final int totalCount;
  final Function(StudySessionMode mode) onStart;

  const StudySessionSetupSheet({
    super.key,
    required this.deckName,
    required this.dueCount,
    required this.totalCount,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: ShapeDecoration(
        color: cs.surface,
        shape: AppTheme.cardShape,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            deckName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'How would you like to study today?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Scheduled Review Option
          ProjectCardTile(
            title: const Text('Scheduled Review'),
            subtitle: Text('$dueCount cards due for review'),
            leading: Icon(Icons.history_rounded, color: cs.primary),
            trailing: dueCount > 0 
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    dueCount.toString(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
            onTap: () {
              Navigator.pop(context);
              onStart(StudySessionMode.spaced);
            },
          ),
          const SizedBox(height: 12),
          
          // Continuous Mode Option
          ProjectCardTile(
            title: const Text('Continuous Mode'),
            subtitle: Text('Study all $totalCount cards (ranked by retention)'),
            leading: Icon(Icons.loop_rounded, color: cs.secondary),
            backgroundColor: cs.secondaryContainer.withValues(alpha: 0.1),
            onTap: () {
              Navigator.pop(context);
              onStart(StudySessionMode.continuous);
            },
          ),
          const SizedBox(height: 24),
          
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.4)),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String deckName,
    required int dueCount,
    required int totalCount,
    required Function(StudySessionMode mode) onStart,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StudySessionSetupSheet(
        deckName: deckName,
        dueCount: dueCount,
        totalCount: totalCount,
        onStart: onStart,
      ),
    );
  }
}
