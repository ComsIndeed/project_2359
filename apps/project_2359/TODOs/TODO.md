# Project 2359 - Master Roadmap & Technical Specs

## 🚀 UI Roadmap (High Impact)

### 1. Core Shell & Navigation
- [x] Refactor `SpecialNavigationBar` for reuse.
- [x] Implement glassmorphism & premium aesthetics.
- [ ] Add "Glassmorphism" blur to the sliding `pageActions` pill (needs `BackdropFilter`).
- [ ] Implement Page routing (Navigator 2.0 or simple State-based switching).

### 2. Study Set (Pack) UI
- [ ] **Deck Gallery**: A beautiful grid of `StudySet` cards (using `RoundedSuperellipseBorder`).
- [ ] **Empty State**: "No study sets yet. Create one from a source or manual input."
- [ ] **Create Flow**: Quick-entry UI for a new Set name & description.

### 3. The Main Study Interface (The "Game")
- [ ] **Question Card**: Use high-quality shadows and smooth transitions between states.
- [ ] **MCQ View**: Interactive option buttons with "correct/incorrect" haptic/visual feedback.
- [ ] **Free-Text View**: Text input with a "Reveal Answer" comparison logic.
- [ ] **Animated Progress**: A thin, glowing progress bar at the top of the study session.

### 4. Source Management 📚
- [ ] **Source Grid**: Visual cards representing different types (PDF icons, Video thumbnails).
- [ ] **Upload Interface**: A drag-and-drop feeling picker (even on mobile, use nice bottom sheets).
- [ ] **Source Viewer**:
    - Simple PDF viewer integration.
    - Video player with custom controls.

### 5. The "Citations" Feature (Premium Feel)
- [ ] **"View Source" Button**: Inside a question card, a button that pops up the exact snippet from the source.
- [ ] **Snippet Highlight**: A mini-view of the text/image that the question was generated from.

### 6. Polish & Juice ✨
- [ ] Add `Animate` (from `flutter_animate`) for entry animations on every card.
- [ ] Implement a system-wide "Aurora" background gradient that subtly shifts.
- [ ] Add haptic feedback for button presses and correct answers.

---

## 🛠 Technical Specs & Guides (Architectural Reference)

### 1. Citation & Source Indexing Strategy
**Target File**: `lib/core/models/citation.dart`

```dart
enum CitationType { range, timestamp, coords }

abstract class Citation {
  final String sourceId;
  CitationType get type;
  Citation({required this.sourceId});

  Map<String, dynamic> toMap();
  static Citation fromMap(Map<String, dynamic> map) {
    final type = CitationType.values.byName(map['type'] as String);
    switch (type) {
      case CitationType.range: return RangeCitation.fromMap(map);
      case CitationType.timestamp: return TimestampCitation.fromMap(map);
      case CitationType.coords: return CoordsCitation.fromMap(map);
    }
  }
}

class RangeCitation extends Citation {
  @override CitationType get type => CitationType.range;
  final int start, end;
  RangeCitation({required super.sourceId, required this.start, required this.end});
  @override Map<String, dynamic> toMap() => {
    'sourceId': sourceId, 'type': type.name, 'start': start, 'end': end
  };
  factory RangeCitation.fromMap(Map<String, dynamic> map) => RangeCitation(
    sourceId: map['sourceId'] as String, start: map['start'] as int, end: map['end'] as int
  );
}
```

### 2. Database (Drift) Relational Mapping
Study Materials are stored in a flat table with a `packId` discriminator and a `citationJson` for citations.

**Table: `StudyMaterialItems`**
```dart
class StudyMaterialItems extends Table {
  TextColumn get id => text()();
  TextColumn get packId => text()(); 
  TextColumn get materialType => text()(); // Discriminator
  TextColumn get citationJson => text().nullable()(); // Serialized Citation
  
  // All content properties nullable to support polymorphism
  TextColumn get question => text().nullable()();
  TextColumn get answer => text().nullable()();
  TextColumn get optionsListJson => text().nullable()(); // JSON list for MCQ
}
```

### 3. DAO: Row to Model Conversion
How to hydrate the runtime models from the database rows:

```dart
StudyMaterial _rowToModel(StudyMaterialItem row) {
  final citation = row.citationJson != null 
      ? Citation.fromJson(row.citationJson!) 
      : null;

  switch (row.materialType) {
    case 'multipleChoiceQuestion':
      return StudyMaterialMultipleChoiceQuestion(
        id: row.id,
        question: row.question!,
        options: List<String>.from(json.decode(row.optionsListJson!)),
        answer: row.answer!,
        citation: citation,
      );
    // ... handle other types
  }
}
```

---

## 🏗 Organization & Conventions
- [ ] **Naming**: Prefer `StudySet` or `StudyDeck` over `StudyMaterialPack`.
- [ ] **Structure**: One table for metadata (`StudyMaterialPackItems`), one for data (`StudyMaterialItems`).
- [ ] **Files**: Follow `study_material_*.dart` pattern.
