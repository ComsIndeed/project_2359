import 'dart:convert';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/models/note_type.dart';

class NoteTemplateRenderer {
  /// Renders the content of a card based on the note data and template ordinal.
  /// 
  /// The [side] is either 'front' or 'back'.
  static String render(NoteItem note, {required int ordinal, required String side}) {
    final type = note.noteType;
    final template = side == 'front' 
        ? type.getFrontTemplate(ordinal) 
        : type.getBackTemplate(ordinal);

    String? content = note.content;
    String? css;
    
    // Check if content is JSON (Anki import format)
    if (content != null && content.trim().startsWith('{')) {
      try {
        final data = jsonDecode(content) as Map<String, dynamic>;
        css = data['css'] as String?;
        if (type == NoteType.cloze) {
          content = data['text'] as String?;
        } else if (type == NoteType.custom) {
          // TODO: handle custom field mapping in template
          content = jsonEncode(data['fields'] ?? {});
        } else {
          content = data['extras'] != null ? jsonEncode(data['extras']) : null;
        }
      } catch (_) {
        // Fallback to raw content if not valid JSON
      }
    }

    if (type == NoteType.cloze) {
      final html = _renderCloze(content ?? '', ordinal, side);
      return css != null ? '<style>$css</style>$html' : html;
    }

    String result = template;
    result = result.replaceAll('{{front}}', note.front ?? '');
    result = result.replaceAll('{{back}}', note.back ?? '');
    result = result.replaceAll('{{content}}', content ?? '');
    
    return css != null ? '<style>$css</style>$result' : result;
  }

  static String _renderCloze(String content, int ordinal, String side) {
    final clozePattern = RegExp(r'\{\{c(\d+)::(.*?)\}\}');
    
    return content.replaceAllMapped(clozePattern, (match) {
      final matchOrdinal = int.tryParse(match.group(1) ?? '0') ?? 1;
      final text = match.group(2) ?? '';
      
      // Ordinals in {{cN::...}} are 1-indexed.
      if (matchOrdinal == (ordinal + 1)) {
        return side == 'front' ? '[...]' : text;
      }
      return text;
    });
  }
}
