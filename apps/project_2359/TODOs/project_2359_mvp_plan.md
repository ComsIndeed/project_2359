# Project 2359 — MVP Implementation Plan

---

## MVP 1 — Create & View Basic Text Cards
**Goal:** Create front/back text cards from the card creation page, save to a deck, open that deck and flip through them.

**What needs to exist:**
- The card creation flow needs to actually wire up — right now `_saveCard` in the creation mode builds a `CardItemsCompanion` but the toolbar's `addCard` just stores it in-memory. You need that to persist to the DB (it already calls `syncDraft`, so the draft saves — but you also need a "finish and save to deck" action that calls `saveDraft` from `DraftService`, which promotes the draft cards into real deck cards).
- A basic study/flip page. Just a `PageView` or a simple state toggle — show front, tap to reveal back, tap next card. No FSRS logic yet, just display.
- The deck navigation from `FolderPage` currently goes to `Center(child: Text("Study Page"))`. Replace that with your actual study page, passing the `deckId`.
- The card list in `MenuModeContent` is using placeholder data — wire it up to actually pull from the draft's cards via `DraftService.getCardsByDraftId`.

**Deadline suggestion:** 2–3 days.

---

## MVP 2 — FSRS Scheduling
**Goal:** Studying a deck uses FSRS. Homepage and folder pages show due counts. After studying, cards get rescheduled.

**What needs to exist:**
- The `reviewCard` method in `StudyDatabaseService` is a TODO. Fill it in — call the FSRS scheduler (the `fsrs` package is already in your pubspec), compute the next due date, update the card's `due` field, and insert a `StudySessionEvent` row for the history.
- The study page needs to show rating buttons (Again / Hard / Good / Easy) and call that review method.
- Query for due cards — filter `card_items` where `due <= now()` and `deckId = X`. The study page should only pull these.
- Homepage and folder page stats — the folder page already counts cards in its stream query. Add a secondary count for *due today* and show it as a badge or subtitle.

**Deadline suggestion:** 3–4 days.

---

## MVP 2.5 — Non-Spaced "Drill" Mode *(optional)*
**Goal:** A second study mode that just drills through cards in due-order without enforcing rest intervals.

**What needs to exist:**
- A separate set of FSRS state columns on cards (or a whole separate "drill" card state table) so you don't contaminate the real schedule. Separate table is cleaner — basically a shadow of the FSRS state but only written to during drill sessions.
- A toggle in the study session entry point: "Scheduled" vs "Drill". Drill mode pulls cards sorted by due date (soonest first, no filtering out future ones), and writes results to the shadow state.
- Study page is mostly the same UI, just a different data source and write target.

**Deadline suggestion:** 2 days.

---

## MVP 3 — Citations
**Goal:** Cards can have citations linking to a source + page/region. In the study page, you can tap a button to jump to the cited section.

**What needs to exist:**
- The `citation_items` table already exists. You just need to connect cards to citations — add a nullable `citationId` foreign key on the cards table (or a join table if a card can have multiple).
- In the card creation flow, after selecting text from the PDF, capture the source ID, page number, and the selected rect(s) from the PDF viewer and bundle that into a `CitationItem` when saving the card.
- In the study page, if a card has a citation, show a small "source" button. Tapping it opens the source PDF scrolled/jumped to that page (pdfrx supports jumping to a page number via the controller).

**Deadline suggestion:** 3–4 days.

---

## MVP 4 — Source Heatmap
**Goal:** Open a source document and see visual overlays showing which pages/regions have been cited in studied cards.

**What needs to exist:**
- A query that joins study session events → cards → citations → filters by the open source ID. Aggregate by page number (and optionally rect) to build a frequency map.
- In the source page's PDF viewer, overlay semi-transparent colored indicators per page — simplest version is just a colored side bar or page thumbnail tint based on study frequency. Fancier version uses the stored rects to draw actual highlight overlays on the page using a `CustomPaint` layer over the PDF viewer (similar to how the occlusion overlay already works).
- The heatmap should update as you study — just recompute on open.

**Deadline suggestion:** 2–3 days.

---

## MVP 5 — Image Attachments on Cards
**Goal:** Cards can have images on front/back. Settings storage section shows local images and allows deletion.

**What needs to exist:**
- The `asset_items` table already exists. You need a service wrapping it with basic CRUD (same pattern as `SourceService`).
- In card creation, add an image picker button. On pick, store the bytes as an `AssetItem`, save the returned ID to the card's `frontImageId` or `backImageId`.
- In the study page card display, if `frontImageId` or `backImageId` is set, load the asset bytes and render an `Image.memory` widget.
- In settings storage page, add a tab or section that lists `asset_items`, shows size, and lets you delete them (which should null out the corresponding card image references — either cascade or just orphan-clean).

**Deadline suggestion:** 2–3 days.

---

## MVP 6 — Image Occlusion Cards
**Goal:** Create cards where parts of an image are hidden with boxes, and you reveal them one at a time (or all at once) when studying.

**What needs to exist:**
- The occlusion editor UI (`ImageOcclusionEditor`, `PdfOcclusionOverlay`) is already partially built. Wire it up — when the user confirms their boxes, serialize the rect list into a `CardOcclusion` object (model already exists), create a card with `occlusionData` set and `frontImageId` pointing to the captured image asset.
- Decide on the card generation strategy — one card per box (each box is the "answer", all other boxes shown as context hints), or one card with all boxes. Let the user pick.
- In the study page, detect that a card has `occlusionData`. Render the image with all occlusion boxes drawn. On reveal, animate the boxes away (or just one at a time if multi-box). You can use a `CustomPaint` over `Image.memory` for this.

**Deadline suggestion:** 3–4 days.

---

> **Total rough timeline: ~3 weeks to MVP 6 if you keep scope tight and don't gold-plate each step.**
>
> The single most important thing — don't touch the UI beyond what's needed to verify each MVP works. Ship the logic, slap a temporary ugly button on it, move on.
