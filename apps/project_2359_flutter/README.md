# Project 2359

**Flexible & Effective Active Recall.**

Project 2359 is an offline-first active recall application built with Flutter. It is designed to address common pain points in study tools by focusing on cognitive nuances, zero-latency performance, and AI-driven content generation.

## Philosophy

The core goal of 2359 is to fix the actual pain points of studying. Instead of just reviewing cards, the system is designed to:

- **Scour and Condense:** Use AI to digest raw sources and condense them into efficient, high-signal active recall materials.
- **Respect Cognitive Nuances:** The flow is engineered to match how the human brain actually learns, rather than just forcing rote memorization.
- **Zero Friction:** A distraction-free experience with zero latency performance.

## Key Features

- **Multi-Mode Study Engine**
  - **Flashcards:** Standard active recall.
  - **Free-Text Questions:** Type your answer and get graded on semantic similarity (using embeddings or Levenshtein distance).
  - **Multiple-Choice Questions:** Quick-fire testing.

- **Advanced Scheduling:** Built on the **FSRS (Free Spaced Repetition Scheduler)** algorithm for optimal review timing.

- **Smart Library**
  - **File Indexer:** Condenses raw files (PDF/Text) to reduce input tokens without losing information.
  - **Source Linking:** Links generated content back to snippets in the raw source material.

- **Generative Media:** **Text2Image** capabilities to generate visual aids for study materials.

- **High Performance:** Optimized for high refresh rate displays.

## Architecture & Project Structure

The project follows a modular architecture, separating the core application logic from specific features like the library and study sessions.

```
lib/
├── main.dart                      # App entry point (DisplayMode & Theme init)
├── core/                          # Global shared code
│   ├── theme/
│   │   └── app_theme.dart         # "Minimal Black" UI config
│   ├── database/
│   │   ├── local_db.dart          # Local DB setup (Isar/Drift)
│   │   └── schema/                # Card, Deck, and ReviewLog entities
│   └── utils/
│       ├── date_utils.dart        # FSRS time calculations
│       └── exporters.dart         # DB -> CSV/JSON logic
├── features/
│   ├── library/                   # Managing Decks & Files
│   │   ├── data/file_importer.dart
│   │   └── presentation/          # Library screens & export widgets
│   ├── card_creator/              # Content Generation Module
│   │   ├── domain/generation_service.dart
│   │   └── presentation/          # Creation & Editing screens
│   └── study/                     # The "Engine" (Active Study Session)
│       ├── logic/
│       │   ├── scheduler.dart     # FSRS Wrapper
│       │   └── auto_grader.dart   # Offline string comparison
│       └── presentation/
│           └── widgets/           # CardDisplay, MCQGrid, TextBox, GradingBar
```

## Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.10.1)
- **Language:** Dart
- **Packages:**
  - `flutter_animate`: For UI transitions.
  - `flutter_displaymode`: For high refresh rate support on compatible devices.
  - `llm_json_stream`: For handling streaming LLM responses.
  - `google_fonts` & `lucide_icons`: Typography and iconography.
  - `flutter_heatmap_calendar`: For visualizing study streaks.

## Roadmap & Challenges

We are currently tackling several engineering challenges to improve the "offline-first" experience:

1. **Cheap Indexing:** Finding cost-effective ways to index raw sources containing millions of tokens.
2. **On-Device Embeddings:** Implementing a small, quantized model (like ONNX Runtime) or a lightweight API to handle "fuzzy" grading for free-text answers cheaply and fast.
3. **Sync:** Implementing a robust sync mechanism that supports our offline-first architecture.

## Getting Started

1. **Prerequisites:** Ensure you have Flutter installed (`sdk: ^3.10.1`).
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the App:**
   ```bash
   flutter run
   ```

## License

This project is licensed under the **AGPL-3.0-or-later** license.
