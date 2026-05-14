# Spaced Repetition System Mechanics — Personal Reference

## Overview

FSRS is the scheduling algorithm that computes when a card should next be reviewed. It is not, by itself, a complete study system. An effective SRS wraps the scheduler with a workload governor, a learning-state machine, queue orchestration, sibling suppression, lapse handling, and deck-level configuration that keeps the study experience sustainable over months and years.

FSRS improves the timing of reviews, but by itself it does not decide how many new cards enter the system each day, how learning cards rehearse before graduation, how failed cards re-enter short-term practice, or how sibling cards are hidden to avoid artificial ease. These are the surrounding mechanics that make a spaced-repetition tool actually work at scale.

This document is a personal reference for the full set of mechanics that need to exist around FSRS for the study system to be effective, ranked from most critical to least critical.

---

## Ranked Mechanics

| Rank | Feature system | Why it is critical |
|---|---|---|
| 1 | Workload control: new cards/day and maximum reviews/day | Prevents overload and keeps the system sustainable long-term |
| 2 | Learning and relearning steps | Converts first exposure and failures into structured short-term reinforcement before long-term scheduling takes over |
| 3 | Queue orchestration and display order | Determines which cards are shown first, how new cards mix with reviews, and how large backlogs are handled |
| 4 | Sibling burying | Prevents same-note cards from making recall artificially easy in the same session |
| 5 | Lapse, leech, suspend, and bury controls | Handles problem cards without corrupting the rest of the workload |
| 6 | Deck presets and per-deck options | Lets different material use different mechanics while sharing reusable configuration |
| 7 | Daily boundaries, counts, and session accounting | Makes limits meaningful by resetting and enforcing them on a per-day basis |
| 8 | Review randomization and fuzz | Prevents cards from sticking together in predictable clumps |
| 9 | Forecasting, simulation, and retention tuning | Helps users choose sustainable settings instead of guessing |
| 10 | FSRS itself | Optimizes due timing once the rest of the study system has defined what enters and exits the queues |

---

## 1. Workload Control

The single most important non-FSRS mechanic is **intake limiting**. Without a hard cap on how many new cards enter each day, a large deck can snowball the review load to an unsustainable volume within weeks.

Introducing 20 new cards per day can translate to roughly 200 reviews per day once those cards have matured in the system. The new-card limit is therefore a future-workload throttle, not just a present-session preference.

A separate maximum reviews per day cap ensures the scheduler may know a card is due, but the workload layer can still defer it to keep the day manageable. Scheduling and presentation are intentionally separated here: optimizing the interval is one job, and deciding how many cards to surface in one sitting is a different job.

**Daily limits should also support:**
- Per-deck configuration (different decks can have different caps)
- A "today only" override that temporarily changes the limit without editing the permanent config
- A flag controlling whether new cards respect the same review cap or bypass it
- Hierarchical enforcement in parent/subdeck arrangements so subdeck limits and parent limits interact correctly

**Workload behavior on missed days:** When a user misses a day, the new card introduction counter should reset to the configured limit, not accumulate the missed quota. Missed new cards are not owed — only reviews of already-introduced cards pile up as a backlog.

---

## 2. Learning and Relearning Steps

FSRS alone does not cover first exposure. Before a card enters long-term scheduling, it needs to pass through a short-term learning pipeline to prove it was actually encoded, not just guessed correctly once.

### Learning steps

Learning steps are a sequence of short intervals, e.g., `1m 10m 1d`. A new card starts at the first step. Each `Good` rating advances it to the next. Each `Again` resets it to the first step. Once the card reaches `Good` on the final step, it graduates into the long-term review queue. An `Easy` rating at any point can force early graduation.

The configurable shape of these steps matters significantly. Very short steps (`1m 10m`) favor active reconstruction during the same session, while a day-crossing step (`1d`) introduces overnight consolidation before graduation. Different subject types may benefit from different step shapes.

### Relearning steps

When a mature review card is failed (`Again`), it becomes a **lapse** and enters a separate, shorter relearning path. This is distinct from the initial learning path. The relearning steps rehabilitate the card before it re-enters the long-term review queue at a penalized interval.

Relearning steps should also be configurable independently from learning steps. A single step of `10m` is a common relearning configuration, since the card was already known and only needs a quick correction rehearsal.

### Card states

The full set of card states needed to implement this correctly:
- **New** — not yet introduced to the user
- **Intraday learning** — in the learning pipeline, next step due within the same day
- **Interday learning** — in the learning pipeline, next step due on a future day
- **Review** — graduated into long-term scheduling via FSRS
- **Relearning** — failed a review and is in a corrective short-term loop

Intraday learning cards are time-critical and should be shown as soon as their next step delay has elapsed. Interday learning cards are handled more like reviews but should not necessarily count against the review cap in the same way.

---

## 3. Queue Orchestration and Display Order

The same due set can feel easy or crushing depending on how cards are ordered and mixed. Queue orchestration is the layer between the scheduler (which computes due dates) and the session (which presents cards to the user).

### Queue class ordering

Cards should be gathered and presented in a defined priority order:
1. Intraday learning cards (time-critical, shown as soon as due)
2. Interday learning cards
3. Review cards
4. New cards

This ordering prevents new-card overload when reviews are backed up, and ensures learning cards are not delayed by a long queue of reviews.

### Configurable options

The following should be configurable per deck or preset:
- **New card gather order:** Added order (oldest first) vs. random
- **New card sort order:** After gathering, how the new cards are sorted before being interleaved
- **New/review mixing:** Show new cards before reviews, after reviews, or interleaved
- **Interday learning/review order:** Whether interday cards show before or after reviews
- **Review sort order:** Due date, random, ascending difficulty, ascending retrievability (FSRS-native), or relative overdueness

### Why order matters for memory quality

Showing predictable card sequences creates **context effects** that inflate apparent recall quality. When card B always follows card A, the presence of A becomes an unintentional retrieval cue for B. Shuffling and randomizing card order prevents this.

---

## 4. Sibling Burying

When multiple cards are generated from the same note (e.g., front-to-back and back-to-front pairs, or multiple cloze deletions from the same sentence), seeing sibling cards in the same session makes the recall task artificially easy.

**The problem:** After answering the front-to-back card, the content is still active in working memory. Immediately seeing the back-to-front card is not a genuine test of retrieval — it is recall-while-primed.

### Burying behavior

When a card from a note is shown or studied, its siblings should be buried (hidden) until the next day. On the next day, buried cards become available again and can be shown normally.

Separate toggles are needed for:
- Bury new siblings (when a new card is introduced, bury other new cards from the same note)
- Bury review siblings (when a review is shown, bury other review siblings for the day)
- Bury interday learning siblings

### Implementation notes

Burying requires:
- A `noteId` field on each card to identify sibling relationships
- A `buriedUntil` field (or equivalent) so buried cards can be automatically restored on the next day boundary
- A distinction between **auto-buried** (system-triggered, expires next day) and **manually buried** (user-triggered, persists until manually unburied)
- Sibling detection across different decks, since two cards from the same note may live in different sub-decks

---

## 5. Lapses, Leeches, Suspension, and Manual Control

Long-term card collections accumulate pathological cards — items that are repeatedly failed, poorly written, or temporarily irrelevant. Effective SRS design has explicit handling for these cases rather than letting them disrupt the rest of the workload.

### Lapse mechanics

A **lapse** occurs when a mature review card receives an `Again` rating. The card:
1. Has its stability penalized
2. Enters the relearning step sequence
3. Returns to review after relearning, with a minimum interval floor applied

The minimum lapse interval prevents a penalized card from immediately becoming due again after the relearning step. A configurable floor (e.g., minimum 1 day, or 50% of pre-lapse interval) prevents abuse.

### Leech detection

A **leech** is a card that has been lapsed too many times (configurable threshold, commonly 8 lapses). Leeches are automatically suspended or tagged for review. Leeching is not the card's "fault" — it usually means the card is badly written, covers too much at once, or the underlying concept needs more work before the card is used.

Leech handling should include:
- A configurable lapse threshold
- An action on leech detection: suspend, tag, or both
- Visibility in the deck overview or stats so the user can address them

### Card suspension

A **suspended** card is removed from all queues until manually restored. Suspension is distinct from burying (which is temporary and automatic). Suspended cards do not expire back into due status.

Suspension should be operable at both the card level and the note level (suspend all cards from this note).

### Manual controls needed

Beyond automatic handling, users need manual card management:
- Suspend / unsuspend card or note
- Bury / unbury card or note
- Reset card (return to new state, wiping all scheduling history)
- Set custom due date (override the scheduler for a specific card)
- Edit card, mark card, add flag
- Mark as leech manually

---

## 6. Deck Presets and Configuration Architecture

Different subject domains need different scheduling behavior. Vocabulary, anatomy diagrams, formulae, and image occlusion cards may all benefit from different step lengths, review caps, or retention targets.

**The wrong architecture:** A global config object, or per-deck duplication of every setting. Both approaches either lose flexibility or create maintenance overhead as the collection grows.

**The right architecture:** Named presets that can be shared across decks. A preset stores the full scheduling policy. Any number of decks can reference the same preset. Editing the preset updates all linked decks. A deck can also have settings that override the preset at the deck level.

### What a preset should contain

- New cards per day
- Maximum reviews per day
- Learning steps (list of durations)
- Relearning steps (list of durations)
- Graduating interval
- Easy interval
- Minimum lapse interval
- Maximum interval
- Desired retention (FSRS parameter)
- Bury new siblings toggle
- Bury review siblings toggle
- New card gather order
- New card sort order
- New/review mix order
- Review sort order

### Preset inheritance and override

The cleanest approach is:
1. Preset defines all defaults
2. Deck can override specific fields (with null meaning "inherit from preset")
3. Session can apply a "today only" override that expires at day boundary

---

## 7. Daily Boundaries, Counts, and Session Accounting

Limits are only meaningful if the system can enforce them reliably. That requires per-deck, per-day accounting that resets at a defined daily boundary.

### What needs to be tracked per deck per day

- How many new cards have been introduced today
- How many reviews have been completed today
- Whether the daily limits have been reached
- How many cards are still in the queue (new and review) for the day
- When the current day boundary is (configurable rollover time, defaulting to midnight)

### Interday learning and review caps

Interday learning cards (those crossing a day boundary) typically count toward the review cap, not the new card cap. The accounting layer needs to distinguish card types when computing cap usage.

### UI implications

A well-implemented accounting layer enables a reliable **session counter** on the deck overview screen: "N new, N learning, N review due today." This counter is updated continuously as cards are studied and as buried/suspended card state changes.

---

## 8. Randomization and Fuzz

Even with a perfect scheduler, if cards introduced together are always reviewed together, they create structural memory bias. **Fuzz** is a small random perturbation added to computed review intervals to prevent synchronized card clumps from forming.

### How fuzz works

A card computed to be due in 10 days might actually be scheduled for 9–11 days instead. The fuzz range scales with the interval — larger intervals receive larger absolute fuzz. This spreading effect compounds over time so that a deck of 1000 cards studied over a year does not cluster into synchronized waves.

### Fuzz in learning steps

Intraday learning cards can also receive small fuzz (e.g., up to 5 extra minutes) so that cards introduced in rapid succession do not all return at the exact same moment.

### Implementation note

Fuzz should be applied after the scheduler computes the base interval, before the due date is written to storage. The stored due date should reflect the fuzzed interval, not the raw interval, so the fuzz is stable and does not shift on each load.

---

## 9. Forecasting, Simulation, and Retention Tuning

Once the rest of the study system works, users still need help choosing sustainable settings. The relationship between desired retention and daily workload is non-obvious and counterintuitive.

### The retention-workload trade-off

Higher desired retention requires shorter review intervals, which means more frequent reviews for the same number of cards. The marginal workload increase is steep near high retention values — going from 90% to 95% desired retention can nearly double daily reviews while only achieving a 5-point improvement in retention.

### What a forecasting feature should show

- Estimated reviews per day N days into the future, given current settings and backlog
- How the forecast changes if new card introduction rate changes
- How the forecast changes if desired retention changes
- Estimated daily minutes based on a configurable per-card time assumption

### FSRS parameter optimization

FSRS exposes a set of model parameters (the `w` weights) that can be optimized from the user's own review history. This optimization makes the scheduler more accurate for that specific user's memory curve. The optimization process requires a minimum amount of review history to produce reliable results.

---

## 10. FSRS — Where the Scheduler Fits

FSRS is the algorithm that answers the question: given this card's stability, difficulty, and time since last review, when should it next be shown to achieve the desired retention probability?

FSRS is powerful and more accurate than older algorithms like SM-2. But it is scoped to interval computation for cards already in the review state. All the surrounding mechanics described above determine:
- Which cards enter the review state (learning pipeline)
- How many cards enter per day (workload control)
- What happens when cards fail (lapse + relearning)
- Which cards are eligible to appear in a given session (queue orchestration, sibling burying, daily accounting)
- Which cards are excluded entirely (suspension, leeches)

FSRS should be understood as the last optimization layer, not the first. A system with perfect FSRS but no workload control, no learning steps, and no sibling burying will still feel broken to an experienced user.

---

## Data Model Requirements Summary

Three clearly separated layers are needed:

### Layer 1 — Card memory state (per card)
Fields: due date, stability, difficulty, state, step index, last review, lapse count, repetition count, buried status, buried until, suspended status, note ID (for sibling detection)

### Layer 2 — Deck policy (per deck / preset)
Fields: new per day, max reviews per day, learning steps, relearning steps, graduating interval, easy interval, min lapse interval, max interval, desired retention, bury toggles, gather order, sort order, new/review order, leech threshold, leech action

### Layer 3 — Daily accounting (per deck per day)
Fields: new cards introduced today, reviews completed today, day boundary timestamp, "today only" overrides

### Session orchestration layer
Responsible for: building the queue from due cards, applying daily limits, applying bury rules, applying sibling detection, ordering by queue class (intraday learning → interday learning → review → new), applying fuzz to new due dates before write

---

## Implementation Order

1. Deck policy model — daily limits, learning steps, relearning steps, queue order, bury toggles
2. Daily accounting and rollover enforcement — makes the limits actually function
3. Sibling burying — using note ID for sibling detection, plus buried-until state on cards
4. Lapse count, suspension, leech handling, and minimum-interval logic
5. Full queue orchestration by queue class, not just a flat "cards due now" list
6. Forecasting and workload simulation once the core behavior is stable
