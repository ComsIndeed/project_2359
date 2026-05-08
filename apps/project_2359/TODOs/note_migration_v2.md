# Note-to-Card Migration Plan (v2)

This document outlines the final plan for migrating from a "cards-first" model to a "notes-first" model. 

## Summary of Architectural Changes
- **No NoteType Tables**: Note types are defined in Dart code using Enums for simplicity.
- **Flat Fields**: `NoteItems` stores data in direct columns (`front`, `back`, `content`) instead of JSON.
- **FSRS Safety**: Cards are synchronized using `templateOrdinal` to preserve study history during note updates.

---

## Step-by-Step Implementation

1.  **Define Note Types**: Create `lib/core/models/note_type.dart` containing the `NoteType` enum (Basic, Basic+Reversed, Cloze). Add extensions to handle field names and template logic in code.
2.  **Database Schema Migration**:
    -   **NEW**: Create `lib/core/tables/note_items.dart` with columns: `id`, `noteType`, `deckId`, `front`, `back`, `content`, `citationId`, `draftId`, `createdAt`, `updatedAt`.
    -   **MODIFY**: Update `CardItems` table to add `noteId` (Foreign Key) and `templateOrdinal` (Integer).
    -   **BUMP**: Register new tables in `AppDatabase` and bump the database version (e.g., to `v10`) to trigger a clean regeneration.
3.  **Update DraftService**: Refactor `DraftService` to stage `NoteItemsCompanion` objects instead of cards. Update `syncDraft` to manage note-based draft persistence.
4.  **Update Toolbar Controller**: Modify `CardCreationToolbarController` to manage the selected `NoteType` and a list of `NoteItemsCompanion`.
5.  **Template Rendering Engine**: Implement `NoteTemplateRenderer` to handle `{{Field}}` string substitution for basic cards and regex-based parsing for Cloze cards.
6.  **Implement NoteService**: Create the central `NoteService` to handle the note lifecycle. Implement the **Ordinal Sync** logic: when updating a note, match existing cards by their ordinal to preserve FSRS data.
7.  **Rework Creation UI**: Overhaul `CardCreationModeContent` to include Note Type selection chips and dynamic input fields that change based on the selected type.
8.  **Update Menu UI**: Update `MenuModeContent` to display the list of staged Notes instead of raw Cards.
9.  **Refactor Seeders**: Update `DebugSeeder` and `BiologyCitationSeeder` to use `NoteService.createNote()`. Ensure FSRS data intended by seeders is applied to the generated cards post-creation.
10. **Global Wiring**: Finalize dependency injection in `AppController` and fix all remaining call sites to use the new Note-based services.
