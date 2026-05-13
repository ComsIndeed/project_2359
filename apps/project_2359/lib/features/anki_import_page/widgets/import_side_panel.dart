import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/features/anki_import_page/services/anki_import_service.dart';
import 'package:project_2359/features/anki_import_page/widgets/import_summary_bar.dart';

/// Desktop side panel. Shows the file picker button and, once a file is
/// staged, its summary + import settings.
class ImportSidePanel extends StatelessWidget {
  final AnkiImportData? stagedData;
  final bool isLoading;
  final String? errorMessage;
  final bool preserveFsrsState;
  final String fsrsParams;
  final ValueChanged<bool> onPreserveFsrsChanged;
  final ValueChanged<String> onFsrsParamsChanged;
  final VoidCallback onPickFile;
  final VoidCallback? onImport;

  const ImportSidePanel({
    super.key,
    this.stagedData,
    this.isLoading = false,
    this.errorMessage,
    required this.preserveFsrsState,
    required this.fsrsParams,
    required this.onPreserveFsrsChanged,
    required this.onFsrsParamsChanged,
    required this.onPickFile,
    this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pick file button
          FilledButton.icon(
            onPressed: isLoading ? null : onPickFile,
            icon: isLoading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const FaIcon(FontAwesomeIcons.fileArrowUp, size: 14),
            label: Text(
              isLoading
                  ? 'Parsing…'
                  : stagedData == null
                      ? 'Select .apkg File'
                      : 'Change File',
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          // Error message
          if (errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.error.withValues(alpha: 0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleXmark,
                    size: 13,
                    color: cs.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Staged file summary
          if (stagedData != null) ...[
            const SizedBox(height: 16),
            ImportSummaryBar(data: stagedData!),
            const SizedBox(height: 20),
            Divider(color: cs.onSurface.withValues(alpha: 0.08)),
            const SizedBox(height: 12),

            // FSRS toggle
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preserve FSRS State',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Import stability & difficulty from Anki',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: preserveFsrsState,
                  onChanged: onPreserveFsrsChanged,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Advanced: FSRS params
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  'Custom FSRS Parameters',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Paste your 17 FSRS parameters from Anki (Settings → FSRS) '
                    'as a comma-separated string. Leave blank to use app defaults.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: fsrsParams,
                    onChanged: onFsrsParamsChanged,
                    maxLines: 3,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                    decoration: InputDecoration(
                      hintText: '0.40255, 1.18385, 3.1262, 15.4722, …',
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.3),
                        fontFamily: 'monospace',
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: cs.onSurface.withValues(alpha: 0.15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Import button
            FilledButton.icon(
              onPressed: onImport,
              icon: const FaIcon(FontAwesomeIcons.fileImport, size: 14),
              label: const Text('Import to App'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shows a deck picker dialog. Returns the selected (or newly created)
/// deck ID and name, or null if cancelled.
Future<({String id, String name})?> showDeckPickerDialog(
  BuildContext context,
  List<({String id, String name})> existingDecks,
) {
  return showDialog<({String id, String name})>(
    context: context,
    builder: (context) =>
        _DeckPickerDialog(existingDecks: existingDecks),
  );
}

class _DeckPickerDialog extends StatefulWidget {
  final List<({String id, String name})> existingDecks;
  const _DeckPickerDialog({required this.existingDecks});

  @override
  State<_DeckPickerDialog> createState() =>
      _DeckPickerDialogState();
}

class _DeckPickerDialogState extends State<_DeckPickerDialog> {
  final _newNameController = TextEditingController();
  bool _createNew = false;

  @override
  void dispose() {
    _newNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Parent Deck',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'The imported decks will be placed inside this deck.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 20),

              // Existing decks
              if (widget.existingDecks.isNotEmpty) ...[
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.existingDecks.length,
                    itemBuilder: (context, i) {
                      final c = widget.existingDecks[i];
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        leading: const FaIcon(
                          FontAwesomeIcons.solidFolder,
                          size: 16,
                        ),
                        title: Text(c.name),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () =>
                            Navigator.of(context).pop((id: c.id, name: c.name)),
                      );
                    },
                  ),
                ),
                Divider(
                  height: 24,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ],

              // Create new
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _createNew
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: OutlinedButton.icon(
                  onPressed: () => setState(() => _createNew = true),
                  icon: const FaIcon(FontAwesomeIcons.plus, size: 13),
                  label: const Text('Create New Deck'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                secondChild: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newNameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Deck name…',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onSubmitted: (_) => _submitNew(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => _submitNew(context),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(52, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const FaIcon(FontAwesomeIcons.check, size: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitNew(BuildContext context) {
    final name = _newNameController.text.trim();
    if (name.isEmpty) return;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    Navigator.of(context).pop((id: id, name: name));
  }
}
