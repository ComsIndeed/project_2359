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

    if (type == NoteType.cloze) {
      return _renderCloze(note.content ?? '', ordinal, side);
    }

    String result = template;
    result = result.replaceAll('{{front}}', note.front ?? '');
    result = result.replaceAll('{{back}}', note.back ?? '');
    result = result.replaceAll('{{content}}', note.content ?? '');
    
    return result;
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
