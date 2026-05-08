## Anki UX Flow — Notes & Cards (Context for Coding Agent)

This description exists to give the coding agent working on project_2359 a
mental model of how Anki's note/card system works, since the app is migrating
from a cards-first design to this model.

**The core distinction:** In Anki, a _note_ is the raw knowledge unit authored
by the user. A _card_ is a derived, displayable study object produced
automatically from a note by applying a template. Users author notes; the app
generates cards.

**Note Types** define the schema of a note. Each note type has a named list of
_fields_ (e.g., a "Basic" note type has fields `Front` and `Back`). Note types
also contain one or more _card templates_, each of which describes how to render
a front and back face for a card using the note's field values. For example, a
"Basic" note type has one template: front = `{{Front}}`, back = `{{Back}}`. A
"Basic+Reversed" note type has two templates: the first renders front/back in
forward order, the second flips them. This means one "Basic+Reversed" note
automatically generates two cards.

**Cloze** is a special note type with a single field called `Text`. The user
writes a sentence with deletion markers like
`{{c1::Paris}} is the capital of {{c2::France}}`. The app parses out every
unique group number (c1, c2, etc.) and generates one card per group. For card 1,
group c1's text is replaced with `[...]` while all other groups show their
revealed text. The back shows the full sentence with all markers stripped. This
lets one note produce multiple fill-in-the-blank cards from a single authored
sentence.

**The authoring flow:** The user opens a creation session, selects a note type,
fills in the fields, and submits. The app stores the note (field values + note
type reference) and immediately generates and persists the corresponding card
rows. The user never directly touches card rows during creation — cards are
always a derived product.

**Drafts:** A creation session is a draft. During a draft, staged notes are
stored with a `draftId` reference. No cards exist yet for staged notes. When the
user commits the session (Save), the app iterates all staged notes, runs
template evaluation or cloze parsing for each, and inserts the resulting card
rows — then removes the draft markers from the notes.

**Updates:** If a user later edits a note's field values, the app deletes all
cards that were derived from that note and regenerates them using the same
templates. FSRS scheduling state on old cards (due date, stability, difficulty)
should be preserved by matching cards by template ordinal during regeneration.

**Deletion:** Deleting a note cascades to all cards derived from it.

**StudyPage is unchanged:** The study loop works entirely at the card level — it
reads card rows, schedules them, and updates FSRS state. It doesn't need to know
about notes at all.

---

## High-Level Migration Overview

The codebase currently treats cards as the atomic unit of authoring. The
`CardCreationToolbarController` accumulates `CardItemsCompanion` objects,
`DraftService.syncDraft()` saves them directly to `card_items` with a `draftId`,
and `saveDraft()` just clears that marker. There are no note tables, no note
types, no templates.

The migration adds four new database tables (`note_types`, `card_templates`,
`note_items`, and the supporting structures), introduces a `NoteService` that
handles template evaluation and cloze parsing, and rewires the entire creation
pipeline so that the user authors notes and cards are generated from them. The
draft flow becomes note-based — staged objects are notes, not cards. The
creation UI gains a note type selector and dynamic fields. The card list in the
creation toolbar becomes a note list. Seeders (`DebugSeeder`,
`BiologyCitationSeeder`) are updated to call `NoteService.createNote()` instead
of inserting raw cards. The study page, collection browsing, and FSRS scheduling
are untouched.

---

## Step-by-Step Migration Plan

---

### Step 1 — Add NoteTypes and CardTemplates Drift Tables

**What we're doing:**

We add two new Drift table classes: `NoteTypes` and `CardTemplates`. `NoteTypes`
has columns: `id` (text primary key), `name` (text), `isBuiltIn` (bool, default
false), `fieldNames` (text — a JSON-encoded `List<String>` storing the ordered
field names for this note type, e.g. `["Front", "Back"]`). `CardTemplates` has:
`id` (text PK), `noteTypeId` (text FK referencing NoteTypes.id), `name` (text —
the template's display name, e.g. "Card 1"), `frontTemplate` (text — the
template string for the front face), `backTemplate` (text nullable — the
template for the back face; null for cloze since cloze uses special rendering),
`isCloze` (bool, default false — marks that this template uses cloze rendering
logic instead of `{{FieldName}}` substitution), `ordinal` (integer — the sort
order of this template among all templates for its note type, used when matching
cards to templates during regeneration).

Both files go in `lib/core/tables/`. They follow the exact same pattern as
existing table files like `deck_items.dart` and `study_collection_items.dart`.

We then register both new table classes in `AppDatabase`'s
`@DriftDatabase(tables: [...])` decorator in `lib/app_database.dart`. We do NOT
bump the DB name or run code generation yet — that happens in Step 2 after we
also add the notes table.

---

### Step 2 — Add NoteItems Table, Add noteId to CardItems, Bump DB + Codegen

**What we're doing:**

We add the `NoteItems` Drift table and modify `CardItems`. `NoteItems` has: `id`
(text PK), `noteTypeId` (text FK → NoteTypes.id), `deckId` (text FK →
DeckItems.id), `fieldsJson` (text — a JSON-encoded `Map<String, String>` of
field name to field value, e.g. `{"Front": "What is...", "Back": "Paris"}`),
`citationId` (text, nullable, FK → CitationItems.id), `draftId` (text, nullable,
FK → CardCreationDraftItems.id — used when the note is part of a pending draft
session, null for committed notes), `createdAt` (DateTimeColumn, default
currentDateAndTime), `updatedAt` (DateTimeColumn, default currentDateAndTime).

We also add one column to `CardItems`: `noteId` (TextColumn, nullable,
referencing NoteItems.id). This links each card back to the note that generated
it. Legacy cards (those that already existed before this migration) and any
cards not produced through the note system will have `noteId` as null.

After both table changes, we register `NoteItems` in `AppDatabase`'s
`@DriftDatabase` annotation, add the import, and then **bump the database name
string** to `project_2359_database_v9_<today's date>` (or similar) to wipe
existing data cleanly. Then run
`dart run build_runner build --delete-conflicting-outputs` to regenerate all
Drift code.

---

### Step 3 — Built-in Note Type Seeder

**What we're doing:**

We create a `NoteTypeSeeder` class in `lib/core/services/note_type_seeder.dart`
with a single static async method `seed(AppDatabase db)`. This method checks
whether built-in note types already exist (by querying `note_types` for rows
where `isBuiltIn == true`) and if not, inserts them. This makes it idempotent —
safe to call on every app startup.

The three built-in types to seed:

**Basic** (`id: "builtin_basic"`, `name: "Basic"`,
`fieldNames: ["Front", "Back"]`): one template (`id: "builtin_basic_t1"`,
`name: "Card 1"`, `frontTemplate: "{{Front}}"`, `backTemplate: "{{Back}}"`,
`isCloze: false`, `ordinal: 0`).

**Basic+Reversed** (`id: "builtin_basic_reversed"`, `name: "Basic+Reversed"`,
`fieldNames: ["Front", "Back"]`): two templates — template 1
(`id: "builtin_br_t1"`, `frontTemplate: "{{Front}}"`,
`backTemplate: "{{Back}}"`, `ordinal: 0`), template 2 (`id: "builtin_br_t2"`,
`frontTemplate: "{{Back}}"`, `backTemplate: "{{Front}}"`, `ordinal: 1`).

**Cloze** (`id: "builtin_cloze"`, `name: "Cloze"`, `fieldNames: ["Text"]`): one
template (`id: "builtin_cloze_t1"`, `name: "Cloze"`,
`frontTemplate: "{{cloze:Text}}"`, `backTemplate: null`, `isCloze: true`,
`ordinal: 0`). The `frontTemplate` value here is a convention marker — the
actual rendering logic does not use string substitution; it uses the cloze
parser.

The seeder uses `insertOnConflictUpdate` (or equivalent Drift upsert) so that
re-running is always safe.

We also call this seeder in `AppDatabase`'s `migration.beforeOpen` callback,
right after the existing log statement.

---

### Step 4 — Note Template Renderer (Mustache + Cloze Parser)

**What we're doing:**

We create `lib/core/services/note_template_renderer.dart` containing a class
`NoteTemplateRenderer`. This is a pure logic class (no DB access) with two
public methods:

**`String render(String template, Map<String, String> fields)`** — iterates the
fields map and replaces all occurrences of `{{FieldName}}` in the template
string with the corresponding value. Unknown field names in the template are
replaced with an empty string. This handles Basic and Basic+Reversed rendering.

**`List<ClozeCardRenderResult> renderCloze(String clozeText)`** — parses and
generates all cards from a cloze text string. The algorithm: use a regex to find
all `{{cN::content}}` patterns where N is a positive integer. Collect all unique
group numbers. For each unique group number N, produce one
`ClozeCardRenderResult` with:

- `groupNumber: N`
- `front`: the full cloze text where every `{{cN::content}}` occurrence is
  replaced with `[...]` (hiding), and every `{{cM::content}}` where M ≠ N is
  replaced with just `content` (revealed). Strip the `{{...}}` wrapper entirely
  from non-target groups.
- `back`: the full cloze text with all `{{cN::content}}` markers stripped (just
  `content` remains for every group).

We also define a simple data class `ClozeCardRenderResult` in the same file with
fields `groupNumber` (int), `front` (String), `back` (String).

---

### Step 5 — Create NoteService

**What we're doing:**

This is the central service that bridges the note model to the card model.
Create `lib/core/services/note_service.dart`. It takes `AppDatabase` and
`NoteTemplateRenderer` as constructor dependencies.

The key methods:

**`Future<List<CardItem>> createNote({required String noteTypeId, required String deckId, required Map<String, String> fields, String? citationId, String? existingNoteId})`**
— generates a UUID for the note (or uses `existingNoteId` when committing from a
draft), inserts a `NoteItems` row with `draftId` left null (committed note),
then loads all `CardTemplates` for the given `noteTypeId` ordered by `ordinal`.
For each template: if `isCloze` is false, call
`renderer.render(template.frontTemplate, fields)` and
`renderer.render(template.backTemplate!, fields)` to get card text, then insert
a `CardItem` with `noteId` set, `deckId` set, `frontText`/`backText` set,
`spacedDue` = now, `spacedState` = 0. If `isCloze` is true, call
`renderer.renderCloze(fields["Text"] ?? "")`, and for each
`ClozeCardRenderResult` insert one `CardItem` with `frontText = result.front`,
`backText = result.back`. All cards get `citationId` from the note. Return the
list of inserted cards.

**`Future<List<CardItem>> updateNote({required String noteId, required Map<String, String> updatedFields})`**
— load the existing note, load its current derived cards keyed by their template
ordinal (or cloze group number), delete all `card_items` where
`noteId == noteId`, re-run the same creation logic as `createNote` but copy FSRS
scheduling columns (`spacedDue`, `spacedStability`, `spacedDifficulty`,
`spacedState`, `spacedStep`, `spacedLastReview`) from the old card at the
matching ordinal/group if one exists, update the note's `fieldsJson` and
`updatedAt`, return the new cards.

**`Future<void> deleteNote(String noteId)`** — delete all `card_items` where
`noteId == noteId`, then delete the `note_items` row.

**`Future<void> commitDraftNote(String draftNoteId, String targetDeckId)`** —
used during `saveDraft`: loads the draft note by its id, calls `createNote` with
its data, then deletes the draft note row. (This is a helper called by
DraftService.)

**`Stream<List<NoteItem>> watchNotesByDeckId(String deckId)`** — straightforward
Drift watch query.

**`Future<List<NoteType>> getAllNoteTypes()`** and
**`Future<NoteType?> getNoteTypeById(String id)`** — basic lookups.

**`Future<List<CardTemplate>> getTemplatesForNoteType(String noteTypeId)`** —
returns templates ordered by ordinal.

**`Future<int> countCardsForNoteType(String noteTypeId, String fieldsJson)`** —
a preview helper: loads templates for the type, and for cloze, also parses the
fields json to count cloze groups. Returns the total number of cards that would
be generated. Used by the UI to show "will generate N cards" before submission.

---

### Step 6 — Update DraftService to Be Note-Based

**What we're doing:**

`DraftService` currently in `lib/core/services/draft_service.dart` stages
`List<CardItemsCompanion>` objects. We rework it to stage
`List<NoteItemsCompanion>` objects instead.

`syncDraft({required String draftId, required String collectionId, required String targetDeckId, required List<NoteItemsCompanion> notes})`
— same session upsert logic for `CardCreationDraftItems`, but instead of
wiping/reinserting `card_items`, it wipes `note_items` where
`draftId == draftId` and reinserts from the list (each note companion already
has `draftId` value set in it).

`saveDraft({required String draftId, required String deckId, String? deckName, String? collectionId})`
— load all `note_items` where `draftId == draftId`. For each, decode
`fieldsJson` back to `Map<String, String>`, call
`NoteService.createNote(noteTypeId, deckId, fields, citationId)`. After all
notes are committed, delete the draft note rows, ensure/create the deck (same
logic as current), delete the `CardCreationDraftItems` row.

`getNotesByDraftId(String? draftId)` — replaces `getCardsByDraftId`. Returns
`List<NoteItem>` by querying `note_items` where `draftId == draftId`.

Keep `getCardsByDraftId()` as is (don't delete it) since it may still be
referenced elsewhere, but it will no longer be used by the creation flow going
forward.

`insertCitation()` stays unchanged.

`watchDraftsByCollectionId()` and `watchAllDrafts()` are unchanged — they still
watch `CardCreationDraftItems` which is still the session record.

`deleteDraft()` must now delete `note_items` where `draftId == draftId` (in
addition to, or instead of, `card_items` where `draftId == draftId`).

Add `NoteService` as a constructor dependency (passed in) so `DraftService` can
call `NoteService.createNote()` during `saveDraft`.

---

### Step 7 — Update CardCreationToolbarController to Be Note-Based

**What we're doing:**

`CardCreationToolbarController` in
`lib/features/card_creation_page/card_creation_toolbar_controller.dart`
currently holds `List<CardItemsCompanion> _cards`. This becomes
`List<NoteItemsCompanion> _notes`.

Add state for the selected note type ID:
`String _selectedNoteTypeId = "builtin_basic"` with a public getter and a
`setSelectedNoteType(String id)` method that calls `notifyListeners()`.

`addCard(CardItemsCompanion card)` becomes `addNote(NoteItemsCompanion note)`:
adds to `_notes`, calls `syncDraft(_notes)` (now passing notes), flashes the
stage controller, sets feedback text.

`syncDraft` call now passes `_notes` instead of `_cards`.

The `cards` getter becomes `notes` getter returning `List.unmodifiable(_notes)`.

`setInitialCards` (if it exists) becomes
`setInitialNotes(List<NoteItemsCompanion> initialNotes)`.

The citation metadata building in `addNote` stays: if `_sourceId != null`, a
citation is inserted and its id is put into the note companion's `citationId`
field before adding to the list.

Remove the `_frontText`, `_backText`, `setFrontText`, `setBackText` fields and
their getters — these are now managed locally in the creation UI widget (each
note type has its own field set).

Keep `selectedNoteTypeId`, `draftId`, `targetDeckId`, `collectionId`,
`deckNameController`, `stageController`, and all mode/selection/source-related
state.

---

### Step 8 — Rework CardCreationModeContent UI

**What we're doing:**

`lib/features/card_creation_page/card_creation_mode_content.dart` is entirely
reworked. The current front/back text controllers become note-type-aware. The
widget now has a note type selector, dynamic field inputs, and an "Add Note"
action.

**Note type selector:** A row of tappable chips (three options: "Basic",
"Basic+Reversed", "Cloze") at the top of the content area. Tapping one calls
`toolbarController.setSelectedNoteType(id)` and rebuilds the widget. The active
chip is visually highlighted.

**Dynamic fields:** Below the selector:

- For Basic and Basic+Reversed: two text fields, labeled "Front" and "Back"
  (same as today visually). These are local state with `TextEditingController`s.
- For Cloze: one text area labeled "Text". Add a small row of helper buttons
  below it: "Wrap c1", "Wrap c2", etc. — these buttons insert a cloze marker
  around the current cursor selection. The button label auto-detects the next
  unused group number by scanning the current text for existing `{{cN::...}}`
  markers. Show a live counter below the text: "Will generate N cards" by
  calling `NoteService.countCardsForNoteType()` on each text change (debounced
  slightly).

**`_addNote()` method:** Reads the current field values based on selected note
type (for Basic/Basic+Reversed:
`{"Front": frontController.text, "Back": backController.text}`; for Cloze:
`{"Text": textController.text}`). Builds a `NoteItemsCompanion` with
`noteTypeId`, `deckId = Value(toolbarController.targetDeckId!)`,
`fieldsJson = Value(jsonEncode(fields))`,
`draftId = Value(toolbarController.draftId!)`. Calls
`toolbarController.addNote(noteCompanion)`. Clears the controllers.

**Shortcuts:** Update the keyboard shortcut registrations — "Save Card" / "Add
Card" become "Add Note". "Focus Front" and "Focus Back" shortcuts stay but only
apply when Basic/Reversed is selected.

The source text quote block at the top remains unchanged.

---

### Step 9 — Update MenuModeContent: Card List → Note List

**What we're doing:**

`lib/features/card_creation_page/menu_mode_content.dart` has a
`_buildCardList()` method that calls `DraftService.getCardsByDraftId()` and
shows raw `CardItem` rows. We change this to call
`DraftService.getNotesByDraftId()` and show `NoteItem` rows instead.

Each note list tile shows:

- **Title**: the primary display field derived from the note. For
  Basic/Basic+Reversed, this is the "Front" field value from `fieldsJson`. For
  Cloze, this is the "Text" field truncated to ~80 chars. Parse `fieldsJson` as
  `Map<String, dynamic>` to extract values.
- **Subtitle**: the note type name (load it from the note's `noteTypeId`). Also
  show "Will generate N cards" by computing it (for non-cloze, it's the template
  count which you can hardcode per known built-in type id; for cloze, parse the
  text). Or just show the note type name since card count preview is
  nice-to-have.
- **Leading widget**: keep `WizardFlashcardPreview` as-is.

The mode toggle button (PDFs ↔ Cards) label for Cards side should be renamed to
"Notes".

No other changes to `MenuModeContent`.

---

### Step 10 — Update the Seeders

**What we're doing:**

Both `DebugSeeder` (`lib/core/services/debug_seeder.dart`) and
`BiologyCitationSeeder` (`lib/core/services/biology_citation_seeder.dart`)
currently insert raw `CardItemsCompanion` objects. We update them to call
`NoteService.createNote()` instead.

In `DebugSeeder`: every place that builds a `CardItemsCompanion` and inserts it
via `batch.insertAll(db.cardItems, cards)` needs to become a call to
`noteService.createNote(noteTypeId: "builtin_basic", deckId: deckId, fields: {"Front": frontText, "Back": backText})`.
The batch at the end is replaced with a sequential loop of `createNote` calls.
The `_isSeeding` logic and collection/deck creation code stay unchanged.

In `BiologyCitationSeeder`: every
`{frontText, backText, citationId, spacedState, ...}` block that calls
`db.into(db.cardItems).insert(...)` becomes a call to
`noteService.createNote(noteTypeId: "builtin_basic", deckId: deckId, fields: {"Front": citationItem.frontText, "Back": citationItem.backText}, citationId: citationId)`.
The FSRS scheduling columns (spacedState, spacedStability, spacedDifficulty,
spacedDue) that were previously set on the card companion during seeding now
need to be set via a direct update after card creation (since `createNote` sets
cards to fresh/unreviewed state). After calling `createNote()`, do a select to
find the generated card by `noteId`, then update its FSRS columns with the
desired seed values using a targeted Drift update query. This preserves the seed
data's intent of having varied scheduling states.

Both seeders need `NoteService` injected — add it as a parameter to their static
`seed()` methods.

`AppController` currently calls the seeders indirectly through
`DebugSeeder.seed(context.read<AppDatabase>())` — update those call sites to
also pass `appController.noteService`.

---

### Step 11 — Wire AppController, NoteService, and Fix All Call Sites

**What we're doing:**

This final step connects everything and fixes all the places that instantiate
these services.

In `lib/core/app_controller.dart`: instantiate `NoteService` and
`NoteTemplateRenderer` in the constructor, pass `NoteTemplateRenderer` into
`NoteService`, pass `NoteService` into `DraftService`. Expose `noteService` as a
public field. The constructor currently builds `DraftService(appDatabase)` —
change to `DraftService(appDatabase, noteService)`.

In `lib/main.dart`: the `DebugSeeder.seed(context.read<AppDatabase>())` call
sites (if any exist directly in main or in `home_page.dart`) need to become
`DebugSeeder.seed(db, appController.noteService)`. Same for wherever
`BiologyCitationSeeder.seed(db)` is called.

In `home_page.dart`'s `_DevInjectionTile`, the
`DebugSeeder.seed(context.read<AppDatabase>())` call needs to become
`DebugSeeder.seed(context.read<AppDatabase>(), context.read<AppController>().noteService)`.

In `settings_page.dart`, the same `DebugSeeder.seed(...)` call in the "Inject
Mock Data" tile needs the same update.

After all this, do a project-wide compile check. The most likely remaining
issues will be: lingering references to `toolbarController.frontText`/`backText`
in other widgets, `getCardsByDraftId` call in any widget that hasn't been
updated, and any place that passes old `DraftService` constructor arguments.
