<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# Levels of support for importing Anki .apkg decks to a Flutter app, and how hard it is to do and how worth it it is to do if I want to support a majority of academic users?

Look into my Github repository project_2359 for some context so that you know
what I've already done too

Now I have a comprehensive picture of your project and the Anki format. Here's a
full breakdown:

## What's Inside an `.apkg` File

An `.apkg` file is simply a **ZIP archive** containing:[^1_1]

- `collection.anki2` — an **SQLite database** with notes, cards, note models
  (templates), deck configs, and scheduling data
- `media` — a JSON mapping of numbered filenames to their original names (e.g.,
  `"1" → "image.png"`)
- The actual media files named as integers (`1`, `2`, `3`…)

The SQLite schema has key tables: `notes` (fields as `||`-separated text, tags,
model ID), `cards` (scheduling state, deck ID, note ID), `col` (deck/model
configs as JSON blobs), and `revlog` (review history) [^1_2][^1_3].

---

## Support Levels for Importing into project_2359

Based on your existing schema — which uses Drift with `NoteItems`, `CardItems`,
`DeckItems`, `AssetItems`, and a spaced repetition state model — here's a tiered
breakdown:

| Level                                     | What You Import                                                                  | Complexity  | Worth It?                                    |
| :---------------------------------------- | :------------------------------------------------------------------------------- | :---------- | :------------------------------------------- |
| **Level 1 — Basic text cards**            | Basic/Reversed note types, plain text front/back                                 | Low–Medium  | ✅ Covers ~70% of academic decks             |
| **Level 2 — HTML-formatted fields**       | Fields with `<b>`, `<img src="">`, LaTeX `[latex]...[/latex]`                    | Medium      | ✅ Essential for medical/nursing decks       |
| **Level 3 — Cloze deletions**             | `{{c1::text}}` markers across multiple cards per note                            | Medium      | ✅ Very common in medical school decks       |
| **Level 4 — Media assets**                | Images extracted from the numbered media files, mapped \& stored in `AssetItems` | Medium–High | ✅ For image occlusion decks (anatomy, etc.) |
| **Level 5 — Custom note types/templates** | Multi-field models (e.g., 4-field medical cards)                                 | High        | ⚠️ Diminishing returns                       |
| **Level 6 — Review history/scheduling**   | Importing FSRS/SM-2 state, `revlog` history                                      | High        | ❌ You use your own SRS; skip this           |

---

## How Hard Is Each Level, Given Your Stack

Your project uses **Drift** (SQLite), `AssetItems`, `NoteItems` with a
`noteType` enum, and a custom FSRS-based scheduling model in `CardItems`. Here's
the implementation picture:

**Unpacking the .apkg** is trivial — use the `archive` package (already common
in Flutter) to unzip it, extract `collection.anki2` and the numbered media
files.[^1_4]

**Reading the SQLite** is the core task. You'd open `collection.anki2` with
`sqflite` or `sqlite3` as a second in-memory database, query the `notes` and
`cards` tables, then map rows into your `NoteItemsCompanion` and
`CardItemsCompanion`. The `col` table stores models and decks as JSON blobs,
which you parse with `dart:convert`.[^1_3]

**Cloze parsing** (Level 3) means writing a regex like
`{{c(\d+)::(.*?)(?:::.*?)?}}` to split one Anki note into N cards in your
`CardItems` table — one per `c1`, `c2`, etc. This is maybe 50–100 lines of Dart.[^1_5]

**Media handling** (Level 4) means reading the `media` JSON map, iterating the
numbered files, and inserting them as blobs into your existing
`SourceItemBlobs`/`AssetItems` tables. This is the most I/O-intensive step but
your schema already has the tables for it .

**There is no existing Flutter pub.dev package for reading .apkg** — `ganki`
(the only Dart Anki package) only _generates_ `.apkg` files, not imports them.
`ankidroid_for_flutter` is an AnkiDroid API wrapper, not a parser. You'd write
this from scratch.[^1_6][^1_7][^1_8]

---

## Worthiness Assessment for Academic Users

Anki is the dominant flashcard tool for medical, nursing, and pharmacy students
globally — **Anki dominates the academic SRS space**, with massive pre-built
decks like AnKing, Lightyear, and Zanki for medicine. For a Filipino nursing
student audience specifically, decks for NCLEX, pharmacology, and anatomy are
widely circulated as `.apkg` files.

**Implementing Levels 1–4 would realistically cover ~85–90% of academic use
cases.** Levels 5–6 give marginal gains and significant complexity. The biggest
win is **not losing user data and study momentum** — if a student has been
studying a 3,000-card AnKing deck in Anki, being able to import it into
project_2359 is the difference between adoption and abandonment.

The total effort for a solid Level 1–3 importer is roughly **2–4 days of focused
Dart work**, given that your Drift schema maps very naturally: Anki's
`notes.flds` → your `NoteItems.front`/`back`/`content`, Anki's deck JSON → your
`DeckItems`, and the cards table maps directly to `CardItems` (just initialize
SRS state fresh since you're using your own algorithm) .

**Recommended minimal viable scope:** unzip → parse notes + cards + decks →
handle cloze → skip media initially → fresh SRS state. That's a compelling v1
import feature that serves the majority of academic users.
<span style="display:none">[^1_10][^1_11][^1_12][^1_13][^1_14][^1_15][^1_9]</span>

<div align="center">⁂</div>

[^1_1]: https://github.com/SergioFacchini/anki-cards-web-browser/blob/master/documentation/Processing
    Anki's .apkg files.md

[^1_2]: https://eggrain.blog/anki-schema

[^1_3]: https://juliensobczak.com/write/2016/12/26/anki-scripting/

[^1_4]: https://implicit.computer/blog/anki-apkg/

[^1_5]: https://github.com/nornagon/mkanki

[^1_6]: https://pub.dev/packages/ganki/example

[^1_7]: https://pub.dev/packages/ganki/versions

[^1_8]: https://pub.dev/packages/ankidroid_for_flutter

[^1_9]: https://www.reddit.com/r/Anki/comments/14nuank/how_to_access_cards_of_a_deck_apkg_file/

[^1_10]: https://forums.ankiweb.net/t/creating-an-anki-card-deck-apkg-sqlite/32146

[^1_11]: https://brandur.org/fragments/apkg

[^1_12]: https://docs.fileformat.com/web/apkg/

[^1_13]: https://pub.dev/packages/anki_connect_ios/example

[^1_14]: https://forums.ankiweb.net/t/making-an-entire-field-a-type-in-cloze-field-itself/30775

[^1_15]: https://docs.ankiweb.net/templates/fields.html

---

# Btw on custom note types like 4 fields and whatever, couldnt I just have like a 'custom' note type where the user can choose to add more fields or take from a preset and just follow that? How complicated can custom templates get anyway and could I just delay that and do it later on instead?

Also, why not with importing FSRS states? My app uses FSRS too anyway

Great, I have everything I need. Here's a thorough answer:

## Custom Note Types: Yes, Defer Them

Your instinct is exactly right. A `NoteType.custom` variant is the clean
solution, and your existing schema already supports it cleanly. Looking at your
`NoteType` enum , you just add a `custom` case and store extra fields in
`content` as JSON (e.g.
`{"fields": {"Word": "...", "Definition": "...", "Example": "..."}, "templateFront": "{{Word}}", "templateBack": "{{Definition}}<br>{{Example}}"}`).
Your `NoteItems.content` column is already nullable text, so no schema migration
needed.

**How complicated can Anki templates actually get?** Anki templates are HTML +
Mustache-style `{{FieldName}}` syntax with some special directives:[^2_1][^2_2]

- Simple: `{{Front}}` / `{{Back}}` — trivial
- Conditional: `{{#FieldName}}...{{/FieldName}}` — show block only if field is
  non-empty
- Negation: `{{^FieldName}}...{{/FieldName}}` — show if field _is_ empty
- Hint fields: `{{hint:FieldName}}` — collapsed by default
- Type-in fields: `{{type:FieldName}}` — input box for typed answers
- Audio: `[sound:file.mp3]` inline in field content
- LaTeX: `[$]...[/$]` or `[$]...[/$]` blocks
- Per-card CSS in the `styling` section of the template

The first two (conditionals/negation) are by far the most common in real
academic decks. The rest are niche. So for import purposes, your **realistic
scope** is: extract raw field values → store them → render `{{FieldName}}`
substitution at display time. You don't need to faithfully execute the full
template engine on import — just preserve the data and do a best-effort render
in your card study view. Deferring full template fidelity is totally reasonable.

---

## On Importing FSRS State — You Should Do It

I undersold this. Since project_2359 uses FSRS too, it's actually worth
importing. Here's why I initially hesitated and why it's still manageable:

**Where Anki stores FSRS state:** In `collection.anki2`, the `cards` table has a
`data` column containing a JSON blob like `{"s": 12.5, "d": 6.2}` — that's
stability (S) and difficulty (D). The `due` column gives the next due date, and
`reps` + `lapses` give review counts.[^2_3][^2_4]

**The catch:** Anki's FSRS uses its own 17-parameter model that gets _optimized
per user_ via their review history. The S and D values your app imports were
computed under those Anki-specific parameters, not yours. If your app uses
different default FSRS parameters (which it almost certainly does unless you
also let users optimize theirs), the imported stability/difficulty values will
be _directionally correct_ but not perfectly calibrated.[^2_5]

**What to do practically:** Import S and D directly into your `spacedStability`
and `spacedDifficulty` columns , set `spacedState` based on Anki's card queue
type (0=new, 1=learning, 2=review, 3=relearning), and compute `spacedDue` from
Anki's `due` value. This gives the user a continuity of their memory state —
cards they know well stay far out, hard ones come up soon. The slight parameter
mismatch self-corrects within a few review cycles anyway as FSRS re-estimates
from actual performance.

**The only real complexity** is Anki's `due` column format: for review cards
it's a Unix day offset from a collection creation timestamp stored in `col.crt`,
so you need
`DateTime.fromMillisecondsSinceEpoch(col_crt * 1000).add(Duration(days: due))`
to recover the actual due date. That's about 5 lines of Dart.

**Bottom line:** FSRS import adds maybe half a day of work on top of the basic
import and meaningfully preserves user study momentum — definitely worth it for
academic users migrating from Anki who've already invested months into a deck.
<span style="display:none">[^2_10][^2_11][^2_12][^2_13][^2_14][^2_15][^2_6][^2_7][^2_8][^2_9]</span>

<div align="center">⁂</div>

[^2_1]: https://www.polyglossic.com/anki-custom-note-types-complex-cards/

[^2_2]: https://www.memo.cards/blog/how-to-create-and-use-anki-templates

[^2_3]: https://www.reddit.com/r/Anki/comments/1bntk50/how_has_ankis_database_structure_changed_with_fsrs/

[^2_4]: https://cran.r-project.org/web/packages/ankiR/ankiR.pdf

[^2_5]: https://github.com/open-spaced-repetition/fsrs4anki/blob/main/docs/tutorial.md

[^2_6]: https://ankiweb.net/shared/info/759844606

[^2_7]: https://forums.ankiweb.net/t/any-way-to-display-card-properties-within-the-card/50339

[^2_8]: https://cran.r-project.org/web/packages/ankiR/refman/ankiR.html

[^2_9]: https://faqs.ankiweb.net/what-spaced-repetition-algorithm

[^2_10]: https://help.remnote.com/en/articles/9124137-the-fsrs-spaced-repetition-algorithm

[^2_11]: https://crihak.wordpress.com/2020/05/21/how-to-create-a-simple-but-serviceable-anki-template-from-scratch/

[^2_12]: https://forums.ankiweb.net/t/custom-configuration-options-by-deck-or-by-note-type/69607

[^2_13]: https://anki-decks.com/blog/post/anki-fsrs-explained/

[^2_14]: https://github.com/pranavdeshai/anki-prettify

[^2_15]: https://www.reddit.com/r/Anki/comments/1pg9u9t/how_to_create_a_custom_note_type/

---

```
# <q>The catch: Anki's FSRS uses its own 17-parameter model that gets optimized per user via their review history. The S and D values your app imports were computed under those Anki-specific parameters, not yours. If your app uses different default FSRS parameters (which it almost certainly does unless you also let users optimize theirs), the imported stability/difficulty values will be directionally correct but not perfectly calibrate</q> Its just hard to provide an optimizer for my users since theres not really an easy way to do it, where the only option is to use something to do with Rust, and I just aint doing that. Its either that or I open up a server that I'll be paying for -- not happening.
```

I wonder, though, could the users just easily import their parameters, or is
there like an online service for optimizing?

Good finds. Here's the full picture:

## The Default Parameters Are Already Pretty Good

The most important thing to know: Anki's default FSRS parameters were trained on
**millions of reviews** from diverse users, so they're a solid baseline right
out of the box. The practical improvement from personalized optimization is
often marginal — one user found their RMSE only improved from 1.61% to 1.60%
after optimization. For most of your users, importing S/D values from Anki with
your default parameters will behave just fine within a week or two of reviews.[^3_1][^3_2]

## The Optimization Situation

There are a few paths, none of which require you to spin up a server:

**1. Users copy-paste their Anki parameters (easiest, most practical)** Anki
already shows the user's optimized 17 parameters as a comma-separated string in
Settings → FSRS. You just expose a settings field in project_2359 where users
paste that string. This takes you maybe an hour to implement — a
`TextFormField`, parse into a `List<double>`, and store in
SharedPreferences/Drift. Users who've optimized in Anki can then bring those
exact weights over, and everything works perfectly.[^3_3]

**2. `fsrs-browser` — client-side WASM optimizer** The open-spaced-repetition
org actually already built this —
[`fsrs-browser`](https://github.com/open-spaced-repetition/fsrs-browser) runs
`fsrs-rs` (the Rust optimizer) compiled to **WASM, fully in the browser**. This
means you could theoretically ship it as a Flutter Web companion page or embed a
WebView in your mobile app that loads it, feeds it your app's exported `revlog`,
and reads back the optimized parameters — no server, no Rust toolchain on your
end. It's already compiled. The integration complexity is moderate but the Rust
work is already done for you.[^3_4][^3_5]

**3. `ts-fsrs` — TypeScript scheduler only (no optimizer)** There's a full
TypeScript FSRS v6 scheduler
[`ts-fsrs`](https://github.com/open-spaced-repetition/ts-fsrs), but it only
handles scheduling, not optimization. Not useful here.[^3_6]

**4. Python optimizer as a user-run local tool** The
[`fsrs-optimizer`](https://github.com/open-spaced-repetition/fsrs-optimizer)
Python package can optimize from a CSV revlog. You'd just document an export
format and tell power users to run it locally. Niche but zero cost to you.[^3_7]

## What You Should Actually Do

The practical move for v1 is just **option 1 — let users paste their Anki FSRS
parameters**. It's a 1-hour feature, it covers the motivated academic users
(who've already optimized in Anki), and it's genuinely useful. For users who
haven't optimized, your defaults will be directionally fine and self-correct
with reviews anyway.

`fsrs-browser` (option 2) is worth bookmarking as a future v2 "smart
optimization" feature — it's the only zero-server on-device optimizer that
exists — but it's non-trivial to wire up in Flutter and overkill until you have
a large enough user base generating enough reviews to optimize from.
<span style="display:none">[^3_10][^3_11][^3_12][^3_13][^3_14][^3_15][^3_8][^3_9]</span>

<div align="center">⁂</div>

[^3_1]: https://help.remnote.com/en/articles/9124137-the-fsrs-spaced-repetition-algorithm

[^3_2]: https://forums.ankiweb.net/t/fsrs-parameters/54130

[^3_3]: https://community.ankihub.net/t/how-can-i-manage-fsrs-or-the-review-schedule-i-m-having-trouble-getting-it-to-work/584099

[^3_4]: https://github.com/open-spaced-repetition/fsrs-rs/issues/99

[^3_5]: https://github.com/open-spaced-repetition/fsrs-browser

[^3_6]: https://github.com/open-spaced-repetition/awesome-fsrs

[^3_7]: https://github.com/open-spaced-repetition/fsrs-optimizer

[^3_8]: https://forums.ankiweb.net/t/optimizing-fsrs-parameters-and-interpreting-true-retention/66225

[^3_9]: https://www.reddit.com/r/Anki/comments/1fc8bgn/fsrs_optimizing_parameters_and_computing_optimal/

[^3_10]: https://github.com/ankitects/anki/issues/3616

[^3_11]: https://www.cliffsnotes.com/study-notes/27522971

[^3_12]: https://open-spaced-repetition.github.io/awesome-fsrs/

[^3_13]: https://www.reddit.com/r/Anki/comments/1o5uafu/if_you_would_like_automatic_optimization_of_fsrs/

[^3_14]: https://pypi.org/project/fsrs/

[^3_15]: https://community.ankihub.net/t/my-first-fsrs-optimize-all-presets-led-to-a-75-reduction-in-reviews-per-day/484853

---

# What are all the higher-level technical must-knows for implementing up until level 4? Like, say I am giving our entire conversation onto an AI Coding Assistant within an AI-IDE but maybe it doesnt normally do web-browsing but instead just does what its told, what context would you give it?

The AI in Antigravity is already very much smart enough to infer from non-exact
instructions, so do not dictate every little coding changes or variables or
jargons that it must do. Just legit, say stuff like create a page where it has
an import button where the button opens up the file explorer and then takes
.apkg files and when one is received it opens it up via archive and etc etc

See how I didnt specify every single variable names? Yeah, like that, unless it
is crucial (since the Anki export files has different fields than in my app, its
nice to knows)

Here's the context brief you'd hand to Antigravity:

---

## project_2359 — Anki `.apkg` Import Feature (Levels 1–4)

### What an `.apkg` file is

An `.apkg` is just a ZIP archive. Unzip it and you get:

- `collection.anki2` — a SQLite database (the actual deck data)
- `media` — a JSON file mapping integer keys to original filenames, e.g.
  `{"0": "image.png", "1": "audio.mp3"}`
- The actual media files sitting in the root, named as plain integers (`0`, `1`,
  `2`…)

Use the `archive` package to unzip. Extract `collection.anki2` as bytes to a
temp file, then open it with `sqlite3` (not Drift — this is a second, temporary,
read-only DB).

---

### The Anki SQLite schema (what you're reading FROM)

**`col` table** — single row, contains:

- `crt` — Unix timestamp (seconds) of collection creation date. Needed to decode
  due dates.
- `models` — JSON blob. A map of model IDs to model objects. Each model has:
  - `name` — note type name (e.g. "Basic", "Cloze", "AnKing")
  - `flds` — ordered list of field objects, each with a `name` key (e.g.
    "Front", "Back", "Extra", "Lecture Notes")
  - `type` — `0` = standard, `1` = cloze
- `decks` — JSON blob. Map of deck IDs to deck objects, each with a `name` key.
  Deck names use `::` as hierarchy separator (e.g. `"Medicine::Cardiology"`).

**`notes` table** — one row per note (the source content):

- `id` — note ID
- `mid` — model ID, foreign key into `col.models`
- `flds` — all field values concatenated, separated by the `\x1f` character
  (ASCII unit separator, decimal 31). Split on this to get individual field
  values in order matching `col.models[mid].flds`.
- `tags` — space-separated tag string

**`cards` table** — one row per card (the schedulable unit, can be multiple per
note):

- `id` — card ID
- `nid` — note ID, foreign key into `notes`
- `did` — deck ID, foreign key into `col.decks`
- `ord` — template ordinal (0-based), which template of the note type generated
  this card
- `due` — for review cards, this is an integer number of days since `col.crt`.
  Convert:
  `DateTime.fromMillisecondsSinceEpoch(crt * 1000).add(Duration(days: due))`.
  For new/learning cards, interpret differently (just default to due now).
- `queue` — card state: `-1`=suspended, `0`=new, `1`=learning, `2`=review,
  `3`=day-learning/relearning

```
- `data` — JSON blob (may be empty string `""`). When FSRS is active, contains `{"s": <stability>, "d": <difficulty>}`. Parse defensively — it might be empty or missing keys for new cards.
```

---

### Mapping Anki → project_2359

**Decks:** `col.decks` → `DeckItems`. Each Anki deck becomes one deck. Strip the
`::` hierarchy for now or flatten — up to you. Skip the virtual "Default" deck
(id `1`) if it's empty.

**Notes:** `notes` table → `NoteItems`. The mapping depends on the Anki model
type:

- If model `type == 0` (standard): map field 0 → `front`, field 1 → `back`.
  Extra fields beyond index 1 get serialized as JSON into `content`. Set
  `noteType` to `basic` or `basicAndReversed` based on whether the model has 2
  templates.
- If model `type == 1` (cloze): field 0 → `content`. Set `noteType` to `cloze`.
- If the model has more than 2 fields and isn't cloze: set `noteType` to
  `custom` (add this to your enum if not already there), and serialize all
  fields as a JSON map keyed by field name into `content`.

**Cards:** `cards` table → `CardItems`. For each card:

- Link to the note you just created via `noteId` and set `templateOrdinal` from
  `ord`.
- Set `deckId` from the mapped deck.
- For FSRS state: parse `data` JSON. If `s` and `d` exist, write them into
  `spacedStability` and `spacedDifficulty`. Set `spacedState` from `queue` (0→0
  new, 1→1 learning, 2→2 review, 3→3 relearning). Compute `spacedDue` from `due`
  using the `crt`-based formula above. If `data` is empty or FSRS fields are
  absent, initialize state fresh (state=0, due=now).

**Media:** Iterate the `media` JSON map. For each entry, the file is sitting in
the unzipped archive as a file named by its integer key. Store the bytes into
`SourceItemBlobs` and create an `AssetItems` row, using the original filename
from the map value as the asset name. When saving note field text, replace
references like `<img src="1">` with the mapped original filename or your
internal asset ID so they resolve correctly later.

---

### Cloze card generation

Anki stores only **one note row** for a cloze note, even if it has
`{{c1::...}}`, `{{c2::...}}`, `{{c3::...}}`. You need to scan the `content`
field with a regex for all unique cloze indices and generate one `CardItems` row
per index, setting `templateOrdinal` to the cloze number minus one. This mirrors
what your app already does natively for cloze notes.

---

### UX flow

Create a new import screen accessible from the sources or decks area. It has a
single "Import Anki Deck" button that opens the file picker filtered to `.apkg`.
On file selection, run the whole import pipeline in an isolate (it can be slow
for large decks). Show a progress indicator and a summary dialog at the end (X
decks, Y notes, Z cards, W media files imported). Handle errors gracefully —
malformed archives, unsupported media types, duplicate IDs — with user-friendly
messages rather than crashes.

---

### FSRS parameters (optional but recommended)

Add a field in settings where users can paste their 17 FSRS parameters as a
comma-separated string (copied directly from Anki's FSRS settings screen). Parse
and store these as the app's active FSRS weights. This ensures imported S/D
values are interpreted under the same parameters they were trained on.

---

### Packages you'll need

- `archive` — unzipping the `.apkg`
- `sqlite3` (or `sqlite3_flutter_libs`) — reading `collection.anki2` as a raw
  SQLite file outside of Drift
- `file_picker` — opening the file explorer filtered to `.apkg`
- `path_provider` — writing the extracted SQLite file to a temp directory before
  opening it

---

# What about handling different anki versions and different anki exports

Good thing to cover before you build. Here's what actually varies across Anki
versions:

---

## The Two Database Formats

**`collection.anki2`** — the classic format, used by all Anki versions up
through recent ones. Single SQLite file, always present in every `.apkg`.

**`collection.anki21`** — introduced in Anki 2.1.x as an optional newer format.
Some exports include _both_ files in the same `.apkg`. If `collection.anki21` is
present, prefer it over `collection.anki2` — it's the same schema but with some
internal improvements. Your unzip logic should just check for the newer file
first and fall back.

There is also a **`collection.anki21b`** format appearing in very recent Anki
versions that uses zstd compression on the SQLite file internally. This is rare
in the wild right now and extremely annoying to handle — safe to explicitly
reject it with a "this deck was exported from a very new version of Anki, please
re-export with compatibility mode enabled" message.

---

## Schema Differences Across Versions

The `notes` and `cards` tables are stable across all versions — `flds`, `mid`,
`did`, `ord`, `due`, `queue`, `data` have been consistent for years. The things
that actually changed:

**`col.models` and `col.decks`** moved in newer Anki versions. In older exports
they're JSON blobs in the `col` table columns. In newer Anki (2.1.50+), they may
instead be in separate `notetypes` and `decks` tables. Check for the existence
of these tables first; if they exist, read from them directly. If they don't,
fall back to parsing the JSON blobs from `col`. The data shape is the same
either way.

**`cards.data` FSRS field** only exists in Anki 23.10+ when the user has FSRS
enabled. Older exports will have an empty string `""` here, or older SM-2 fields
(`factor`, `ivl`, `reps`, `lapses`) in the main card columns instead. Those SM-2
fields are: `ivl` (interval in days), `factor` (ease factor as integer, 2500 =
250%), `reps`, `lapses`. If `data` is empty and `ivl > 0`, you can do a rough
FSRS S/D approximation from SM-2 fields — but honestly just initializing fresh
SRS state is fine for these older cards.

---

## Shared Deck Exports vs. Personal Collection Exports

**Shared decks** (downloaded from AnkiWeb or shared between users) will have
`cards.queue = 0` for everything (new cards, never reviewed). The `data` field
will be empty. This is the most common import scenario for academic users
getting premade decks — no SRS state to import, just content. Handle this
gracefully as the default happy path.

**Personal collection exports** from a user's own Anki will have real scheduling
data, FSRS state in `data`, and a meaningful `col.crt` for due date math. This
is the migration scenario.

When exporting from Anki, users also have a checkbox: **"Include scheduling
information"**. If they uncheck it, all cards come in as new with empty `data`.
If they check it, full state is preserved. You can't detect this flag from the
file itself — just handle both cases by checking whether `data` is populated.

---

## Media Edge Cases

The `media` JSON map is sometimes an empty object `{}` even when media files are
present (bug in older Anki exports). Also some decks embed media as
`[sound:filename.mp3]` inside field text rather than `<img>` tags — parse both
patterns when scanning fields for media references.

Some older exports name the media file map just `media` with no extension, and
some very old ones skip it entirely. Treat a missing `media` file as an empty
map rather than an error.

---

## What to Actually Do

In order of priority:

1. Check for `collection.anki21` first, fall back to `collection.anki2`, reject
   `collection.anki21b` with a clear message
2. Check if `notetypes` and `decks` tables exist before falling back to JSON
   blobs in `col`
3. Parse `cards.data` defensively — empty string, missing keys, or `null` should
   all initialize fresh SRS state
4. Treat missing or empty `media` JSON as an empty map, not an error
5. Scan field text for both `<img src="...">` and `[sound:...]` patterns for
   media resolution

Everything else (obscure note type variants, legacy SM-2 state, etc.) is safe to
ignore or handle with a graceful fallback for v1.
