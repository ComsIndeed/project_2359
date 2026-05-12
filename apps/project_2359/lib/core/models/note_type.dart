enum NoteType {
  basic,
  basicAndReversed,
  cloze,
  imageOcclusion,
  // TODO: Handle rendering of custom notes in the study/card view.
  // Content is stored as JSON: {"fields": {"FieldName": "value", ...}, "modelName": "..."}
  custom,
}

extension NoteTypeExtension on NoteType {
  String get label {
    switch (this) {
      case NoteType.basic:
        return 'Basic';
      case NoteType.basicAndReversed:
        return 'Basic (and reversed card)';
      case NoteType.cloze:
        return 'Cloze';
      case NoteType.imageOcclusion:
        return 'Image Occlusion';
      case NoteType.custom:
        return 'Custom (Imported)';
    }
  }

  /// Field labels for the UI.
  List<String> get fieldLabels {
    switch (this) {
      case NoteType.basic:
      case NoteType.basicAndReversed:
        return ['Front', 'Back'];
      case NoteType.cloze:
        return ['Text'];
      case NoteType.imageOcclusion:
        return ['Image', 'Title'];
      case NoteType.custom:
        return ['Fields'];
    }
  }

  /// Corresponding column names in the `NoteItems` table.
  List<String> get fieldColumns {
    switch (this) {
      case NoteType.basic:
      case NoteType.basicAndReversed:
        return ['front', 'back'];
      case NoteType.cloze:
        return ['content'];
      case NoteType.imageOcclusion:
        return ['content'];
      case NoteType.custom:
        return ['content'];
    }
  }

  /// The number of templates defined for this note type.
  /// 
  /// - Basic: 1 (Front -> Back)
  /// - Basic + Reversed: 2 (Front -> Back, Back -> Front)
  /// - Cloze: 1 logical template that generates dynamic cards based on content deletions.
  int get templateCount {
    switch (this) {
      case NoteType.basic:
        return 1;
      case NoteType.basicAndReversed:
        return 2;
      case NoteType.cloze:
        return 1;
      case NoteType.imageOcclusion:
        return 1;
      case NoteType.custom:
        return 1;
    }
  }

  /// Returns the template for the front side of the card for a given ordinal.
  String getFrontTemplate(int ordinal) {
    switch (this) {
      case NoteType.basic:
        return '{{front}}';
      case NoteType.basicAndReversed:
        return ordinal == 0 ? '{{front}}' : '{{back}}';
      case NoteType.cloze:
        return '{{cloze:content}}';
      case NoteType.imageOcclusion:
        return '{{image}}';
      case NoteType.custom:
        return '{{content}}';
    }
  }

  /// Returns the template for the back side of the card for a given ordinal.
  String getBackTemplate(int ordinal) {
    switch (this) {
      case NoteType.basic:
        return '{{back}}';
      case NoteType.basicAndReversed:
        return ordinal == 0 ? '{{back}}' : '{{front}}';
      case NoteType.cloze:
        return '{{cloze:content}}';
      case NoteType.imageOcclusion:
        return '{{image}}';
      case NoteType.custom:
        return '{{content}}';
    }
  }

  /// Helper to get the field index from a column name.
  int? getFieldIndex(String column) {
    final columns = fieldColumns;
    final index = columns.indexOf(column);
    return index != -1 ? index : null;
  }
}
