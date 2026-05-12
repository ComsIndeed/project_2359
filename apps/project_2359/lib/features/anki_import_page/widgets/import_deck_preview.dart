import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/models/note_type.dart';
import 'package:project_2359/features/anki_import_page/services/anki_import_service.dart';

class ImportDeckPreview extends StatefulWidget {
  final AnkiImportData data;

  const ImportDeckPreview({super.key, required this.data});

  @override
  State<ImportDeckPreview> createState() => _ImportDeckPreviewState();
}

class _ImportDeckPreviewState extends State<ImportDeckPreview> {
  String? _selectedDeckAnkiId;
  String? _selectedNoteAnkiId;

  // Build a fast lookup: deckAnkiId → list of noteAnkiIds
  late final Map<String, List<String>> _deckToNotes;
  // Note lookup
  late final Map<String, AnkiParsedNote> _noteMap;
  // Card count per note
  late final Map<String, int> _cardsPerNote;

  @override
  void initState() {
    super.initState();
    _noteMap = {for (final n in widget.data.notes) n.ankiId: n};
    // Build deck → notes from cards
    final noteToDeck = <String, String>{};
    for (final c in widget.data.cards) {
      noteToDeck.putIfAbsent(c.noteAnkiId, () => c.deckAnkiId);
    }
    _cardsPerNote = <String, int>{};
    for (final c in widget.data.cards) {
      _cardsPerNote[c.noteAnkiId] = (_cardsPerNote[c.noteAnkiId] ?? 0) + 1;
    }
    _deckToNotes = {};
    for (final n in widget.data.notes) {
      final deckId = noteToDeck[n.ankiId];
      if (deckId != null) {
        _deckToNotes.putIfAbsent(deckId, () => []).add(n.ankiId);
      }
    }
    if (widget.data.decks.isNotEmpty) {
      _selectedDeckAnkiId = widget.data.decks.first.ankiId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        // Deck list (left column)
        SizedBox(
          width: 220,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'DECKS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: widget.data.decks.length,
                    itemBuilder: (context, i) {
                      final deck = widget.data.decks[i];
                      final noteCount =
                          (_deckToNotes[deck.ankiId] ?? []).length;
                      final isSelected = deck.ankiId == _selectedDeckAnkiId;
                      return _DeckTile(
                        deck: deck,
                        noteCount: noteCount,
                        isSelected: isSelected,
                        onTap: () => setState(() {
                          _selectedDeckAnkiId = deck.ankiId;
                          _selectedNoteAnkiId = null;
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Note list + card preview
        Expanded(
          child: _selectedDeckAnkiId == null
              ? const SizedBox.shrink()
              : _NoteListAndPreview(
                  noteIds: _deckToNotes[_selectedDeckAnkiId!] ?? [],
                  noteMap: _noteMap,
                  cardsPerNote: _cardsPerNote,
                  selectedNoteId: _selectedNoteAnkiId,
                  onSelectNote: (id) =>
                      setState(() => _selectedNoteAnkiId = id),
                ),
        ),
      ],
    );
  }
}

// ── Deck tile ──────────────────────────────────────────────────────────────

class _DeckTile extends StatelessWidget {
  final AnkiParsedDeck deck;
  final int noteCount;
  final bool isSelected;
  final VoidCallback onTap;
  const _DeckTile({
    required this.deck,
    required this.noteCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Render :: hierarchy as indented display name
    final parts = deck.name.split('::');
    final displayName = parts.last;
    final indent = (parts.length - 1) * 12.0;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: EdgeInsets.only(left: 8 + indent, right: 8, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            FaIcon(
              isSelected
                  ? FontAwesomeIcons.solidFolder
                  : FontAwesomeIcons.folder,
              size: 13,
              color: isSelected
                  ? cs.primary
                  : cs.onSurface.withValues(alpha: 0.45),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                displayName,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? cs.primary
                      : cs.onSurface.withValues(alpha: 0.8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$noteCount',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Note list + card preview ───────────────────────────────────────────────

class _NoteListAndPreview extends StatelessWidget {
  final List<String> noteIds;
  final Map<String, AnkiParsedNote> noteMap;
  final Map<String, int> cardsPerNote;
  final String? selectedNoteId;
  final ValueChanged<String> onSelectNote;

  const _NoteListAndPreview({
    required this.noteIds,
    required this.noteMap,
    required this.cardsPerNote,
    required this.selectedNoteId,
    required this.onSelectNote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        // Note list
        SizedBox(
          width: 240,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: cs.onSurface.withValues(alpha: 0.06),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'NOTES (${noteIds.length})',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: noteIds.length,
                    itemBuilder: (context, i) {
                      final note = noteMap[noteIds[i]];
                      if (note == null) return const SizedBox.shrink();
                      final cardCount = cardsPerNote[note.ankiId] ?? 1;
                      final isSelected = note.ankiId == selectedNoteId;
                      return _NoteTile(
                        note: note,
                        cardCount: cardCount,
                        isSelected: isSelected,
                        onTap: () => onSelectNote(note.ankiId),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Card content preview
        Expanded(
          child: selectedNoteId == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.eye,
                        size: 32,
                        color: cs.onSurface.withValues(alpha: 0.12),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Select a note to preview',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                )
              : _CardPreview(note: noteMap[selectedNoteId]!),
        ),
      ],
    );
  }
}

// ── Note tile ──────────────────────────────────────────────────────────────

class _NoteTile extends StatelessWidget {
  final AnkiParsedNote note;
  final int cardCount;
  final bool isSelected;
  final VoidCallback onTap;
  const _NoteTile({
    required this.note,
    required this.cardCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final preview = (note.front ?? note.content ?? '—')
        .replaceAll(RegExp(r'<[^>]*>'), '') // strip HTML
        .trim();
    final short = preview.length > 60 ? '${preview.substring(0, 60)}…' : preview;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.primary.withValues(alpha: 0.09)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    short.isEmpty ? '(empty)' : short,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    note.noteType.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            if (cardCount > 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: cs.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '×$cardCount',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Card content preview ───────────────────────────────────────────────────

class _CardPreview extends StatelessWidget {
  final AnkiParsedNote note;
  const _CardPreview({required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type chip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  note.noteType.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                note.modelName,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (note.noteType == NoteType.cloze) ...[
            _FieldBlock(label: 'Text', content: note.content ?? ''),
          ] else if (note.noteType == NoteType.custom) ...[
            _FieldBlock(label: 'Front', content: note.front ?? ''),
            const SizedBox(height: 12),
            _FieldBlock(label: 'Back', content: note.back ?? ''),
            if (note.content != null) ...[
              const SizedBox(height: 12),
              _FieldBlock(label: 'Extra Fields', content: note.content!),
            ],
          ] else ...[
            _FieldBlock(label: 'Front', content: note.front ?? ''),
            const SizedBox(height: 12),
            _FieldBlock(label: 'Back', content: note.back ?? ''),
            if (note.content != null) ...[
              const SizedBox(height: 12),
              _FieldBlock(label: 'Extra', content: note.content!),
            ],
          ],

          if (note.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: note.tags
                  .map(
                    (t) => Chip(
                      label: Text(
                        t,
                        style: theme.textTheme.labelSmall,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      side: BorderSide(
                        color: cs.onSurface.withValues(alpha: 0.15),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      )
          .animate()
          .fadeIn(duration: 200.ms)
          .slideX(begin: 0.02, duration: 200.ms, curve: Curves.easeOut),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  final String label;
  final String content;
  const _FieldBlock({required this.label, required this.content});

  String _stripHtml(String html) =>
      html.replaceAll(RegExp(r'<[^>]*>'), '').trim();

  String _renderCloze(String text) {
    // Highlight cloze deletions visually as [c1: word]
    return text.replaceAllMapped(
      RegExp(r'\{\{c(\d+)::(.*?)(?:::.*?)?\}\}'),
      (m) => '[c${m[1]}: ${m[2]}]',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cleaned = _stripHtml(_renderCloze(content));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: cs.onSurface.withValues(alpha: 0.35),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.07)),
          ),
          child: Text(
            cleaned.isEmpty ? '(empty)' : cleaned,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
