extension DeckNameCleaning on String {
  /// Cleans an Anki-style deck name (e.g. "Biology::Anatomy" -> "Anatomy")
  String get cleanDeckName {
    if (!contains('::')) return this;
    final parts = split('::');
    return parts.last.trim();
  }

  /// Returns the breadcrumbs or parent parts of an Anki deck name
  String? get deckParentName {
    if (!contains('::')) return null;
    final parts = split('::');
    return parts.sublist(0, parts.length - 1).join(' › ');
  }

  /// Returns the root deck name (e.g. "Biology::Anatomy" -> "Biology")
  String get rootDeckName {
    if (!contains('::')) return this;
    return split('::').first.trim();
  }
}
