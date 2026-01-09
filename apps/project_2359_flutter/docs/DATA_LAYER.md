# Project 2359 - Data Layer Architecture

This document explains the data layer architecture, how to switch between test and production modes, and how to use the data sources in your code.

## Overview

The data layer follows a **repository pattern** with pluggable datasources:

```
┌─────────────────────────────────────────────────────────┐
│                      Features (UI)                       │
│         (home, sources, materials, settings)             │
└────────────────────────┬────────────────────────────────┘
                         │ uses
                         ▼
┌─────────────────────────────────────────────────────────┐
│                  Riverpod Providers                      │
│           (datasource_providers.dart)                    │
└────────────────────────┬────────────────────────────────┘
                         │ provides
        ┌────────────────┴────────────────┐
        ▼                                 ▼
┌───────────────────┐           ┌───────────────────┐
│  Mock Datasources │           │  Drift Datasources │
│   (test mode)     │           │  (production mode) │
└───────────────────┘           └───────────────────┘
        │                                 │
        └────────────┬────────────────────┘
                     ▼
        ┌────────────────────────┐
        │   Domain Models        │
        │ (lib/core/models/)     │
        └────────────────────────┘
```

## Folder Structure

```
lib/
├── core/
│   ├── core.dart                    # Barrel export
│   ├── data/
│   │   ├── config/
│   │   │   └── app_config.dart      # Test mode toggle
│   │   ├── datasources/
│   │   │   ├── interfaces/          # Abstract interfaces
│   │   │   └── mock/                # In-memory implementations
│   │   └── providers/
│   │       └── datasource_providers.dart
│   └── models/                      # Domain models
│       ├── flashcard.dart
│       ├── quiz_question.dart
│       ├── source.dart
│       └── ...
└── features/                        # UI features
```

## Switching Between Test and Production Mode

Open `lib/core/data/config/app_config.dart`:

```dart
/// Set to `true` for test mode, `false` for production mode
const bool kTestMode = true;
```

**Test Mode (`kTestMode = true`):**
- Uses in-memory mock data from `mock_data.dart`
- Data can be modified during runtime
- Data **resets to predefined values** on app restart
- No database required

**Production Mode (`kTestMode = false`):**
- Uses Drift (SQLite) for persistent local storage
- Data persists across app restarts
- Ready for Supabase cloud sync integration

## Domain Models

All domain models are in `lib/core/models/`:

| Model | Description |
|-------|-------------|
| `Source` | Study material sources (PDFs, links, notes, etc.) |
| `Flashcard` | Two-sided flashcards with spaced repetition |
| `QuizQuestion` | Multiple choice questions |
| `FreeFormQuestion` | Open-ended Socratic questions |
| `ImageOcclusion` | Images with hidden regions |
| `MatchingSet` | Matching pair exercises |
| `SourceReference` | Links content back to source locations |
| `User` | User profile and study statistics |

## Using Datasources with Riverpod

### 1. Import the core module

```dart
import 'package:project_2359_flutter/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

### 2. Access datasources in widgets

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourcesDatasource = ref.watch(sourcesDatasourceProvider);
    
    return FutureBuilder<List<Source>>(
      future: sourcesDatasource.getSources(),
      builder: (context, snapshot) {
        // ... build UI
      },
    );
  }
}
```

### 3. Available providers

```dart
// Sources (PDFs, links, notes, etc.)
final sourcesDatasource = ref.watch(sourcesDatasourceProvider);

// Study content (flashcards, quizzes, etc.)
final studyDatasource = ref.watch(studyDatasourceProvider);

// User profile and stats
final userDatasource = ref.watch(userDatasourceProvider);
```

## Datasource Interfaces

### SourcesDatasource

```dart
abstract class SourcesDatasource {
  Future<List<Source>> getSources({SourceType? type});
  Future<Source?> getSourceById(String id);
  Future<List<Source>> getRecentSources({int limit = 10});
  Future<void> addSource(Source source);
  Future<void> updateSource(Source source);
  Future<void> deleteSource(String id);
  Future<List<Source>> searchSources(String query);
  Stream<List<Source>> watchSources({SourceType? type});
  Future<void> markSourceAccessed(String id);
}
```

### StudyDatasource

```dart
abstract class StudyDatasource {
  // Flashcards
  Future<List<Flashcard>> getFlashcards({String? sourceId});
  Future<List<Flashcard>> getFlashcardsDueForReview();
  Future<void> addFlashcard(Flashcard flashcard);
  // ... and more for quizzes, free-form, image occlusions, matching
}
```

### UserDatasource

```dart
abstract class UserDatasource {
  Future<User?> getCurrentUser();
  Future<void> saveUser(User user);
  Future<void> updateStats({...});
  Future<void> addCredits(int amount);
  Future<bool> deductCredits(int amount);
  Stream<User?> watchCurrentUser();
}
```

## Modifying Mock Data

Edit `lib/core/data/datasources/mock/mock_data.dart` to change the predefined test data.

The mock data includes:
- 6 sample sources (PDFs, notes, links)
- 5 flashcards
- 3 quiz questions
- 2 free-form questions
- 2 matching sets
- 1 default user profile

## Adding Drift (Production Mode)

When ready to implement production mode:

1. Create Drift tables in `lib/core/data/datasources/drift/tables/`
2. Create the main database in `lib/core/data/datasources/drift/database.dart`
3. Implement `DriftSourcesDatasource`, `DriftStudyDatasource`, `DriftUserDatasource`
4. Update providers in `datasource_providers.dart` to use Drift implementations when `kTestMode = false`
5. Run `dart run build_runner build` to generate Drift code

## Source References

The `SourceReference` model enables "view source" functionality:

- **Text sources**: Page number, character offsets, matched text
- **Audio/Video**: Start and end timestamps
- **Images**: Region coordinates (x, y, width, height as percentages)
- **Web links**: URL anchor/fragment

Example:
```dart
final reference = SourceReference.text(
  id: 'ref_001',
  sourceId: 'src_001',
  pageNumber: 5,
  startOffset: 1234,
  endOffset: 1300,
  matchedText: 'The GDP formula...',
);
```
