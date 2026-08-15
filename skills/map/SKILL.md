---
name: ajian-map
description: >-
  Use to find out where you are in the ajian pipeline and which skill comes next. Triggers include
  "/ajian-map", "where am I", "what's next", "which ajian skill now", "I'm lost", "where do I
  start", and the Indonesian a confused user actually types: "saya bingung", "aku bingung", "mulai
  dari mana", "ini lanjut apa", "sekarang ngapain", "lanjutnya gimana". A state-aware router: it
  reads the project's artifacts (blueprint? work order Depth? plan? git?) and answers "you are at
  work order NN, next: <skill>". The only ajian skill with no preconditions, so it is always safe to
  run — reach for it after a compaction or when the user does not know the pipeline's vocabulary. It
  routes; it does not do the work.
---

<!-- Adapted from mattpocock/skills `ask-matt` (the router structure, MIT, Matt Pocock). The ajian
     seam: ajian-map is state-aware — it inspects the repo to locate you on the pipeline rather than
     only describing the flow. This is what replaces a session hook (ajian has none by design). See
     NOTICE.md. -->

# Ajian · Map

You don't remember every skill or where you left off — especially after a compaction. This skill
reads the project and tells you which of the eight to run next.

## Language

Reply in the user's language — this file is English because it is agent-facing, not because the
answer must be. Quoted lines here are meaning to convey, not strings to copy: translate them, but
keep the labels `GATE / Done / Evidence / Decide / Risk` verbatim. A gate the user has to decode is
a gate they rubber-stamp.

## The gate protocol

A gate is a full stop that waits for the user. Emit it as plain markdown — never inside a code
block — carrying these five fields, in this order:

**GATE — <name of the gate>**

**Done**
- <what you actually did>

**Evidence**
- <one checkable fact per bullet — real command output, or the path of a committed artifact, never
  your own assessment>

**Decide**
- <what the user has to decide, phrased as a question they can answer>

**Risk**
- <what breaks if this is wrong and you proceed anyway>

Then stop and wait. Never continue on your own reading of what the user probably wants. `Evidence`
is load-bearing: if you cannot produce it, you have not reached the gate. `Risk` is what lets a user
who cannot audit your work decide anyway.

This block is identical in every ajian skill.

## The pipeline (idea → shipped)

```
(ajian-adopt, if the project already has documents in another shape)
  →  ajian-blueprint  →  per roadmap row, top to bottom:
                           ajian-grill  →  (ajian-design, if UI)  →  ajian-plan  →  ajian-build  →  ajian-review
                         →  next row
```

Each skill ends with a `→ Next` breadcrumb; ajian-map is the way to recover that breadcrumb from
project state when you've lost the thread. Chaining is explicit — there are no hooks.

## How it locates you

Read these signals, cheapest first, and stop at the first that tells you the answer:

1. **Is there a blueprint?** Look for `docs/INDEX.md` and `docs/ROADMAP.md`.
   - **Both present** → continue to signal 2.
   - **Neither, and the repo has no documents worth keeping** → you are before the pipeline.
     **Next: `ajian-blueprint`** (grill-1 → foundation docs).
   - **Neither, but the repo does hold real documents** — a substantial README, a PRD, an
     `ARCHITECTURE.md`, a checked-in wiki, leftover Spec Kit or other framework artifacts →
     **Next: `ajian-adopt`**. Not `ajian-blueprint` — it would write a second set of documents beside
     the first, leaving two sources of truth. **Look before you route:** this signal is a presence
     check on two filenames, so real documents in another shape read identically to nothing.
   - **One present, or present but incomplete** (a roadmap with no work orders, work orders with no
     `Depth:`, an INDEX routing to files that do not exist) → the layout is partial or was written
     by an older version of these skills. **Next: `ajian-adopt`**, which repairs shape without
     rewriting content.
2. **Which work order is current?** In `docs/ROADMAP.md`, the current line is the **topmost unticked
   row** of the table — position in the table is the build order, not the number in the `#` column.
   A work order's number is its permanent identity (it names its files); rows get reordered and
   inserted, numbers never move. Take that row's number and call it `NN`. (All ticked → the roadmap
   is done; offer to extend it via `ajian-blueprint` in resumed mode.)
3. **What Depth is work order `NN`?** Open `docs/work-orders/NN-<slug>.md`, read its `Depth:` field.
   - **`brief`** → it hasn't been sharpened against real code. **Next: `ajian-grill NN`**.
   - **`detailed`** → continue.
4. **Does it have UI, and is the UI built?** If the work order's "Screens & states" section is
   filled, it has UI — then read its `## Built surface` **Status**, which is the record, not
   `DESIGN.md`:
   - **`not yet designed`** → **Next: `ajian-design NN`** (it needs impeccable available, and stops
     and asks if it cannot find it rather than designing the surface itself).
   - **`handed to impeccable`** → a previous design run never came back to record what was built.
     **Next: `ajian-design NN`** — it resumes at the recording step. Say plainly that the surface
     may already exist and nothing has inventoried it yet.
   - **`recorded`** → the surface is built and inventoried. Continue.
   No UI → continue.
5. **Is there a plan?** Look for `docs/plans/NN-<slug>.md`.
   - **No** → **Next: `ajian-plan NN`**.
   - **Yes** → read its checkboxes.
6. **What do the plan's checkboxes and git say?**
   - **Some or all boxes unticked** → the build is unstarted or mid-flight. **Next: `ajian-build NN`**
     (it resumes from the first unticked box; cross-check with `git log`).
   - **All boxes ticked, branch not yet merged** → **Next: `ajian-review NN`**.
   - **All boxes ticked and the branch merged / roadmap line ticked** → this work order is done.
     Go back to signal 2 for the next line.

Report as a gate block. Routing is yours to inform, the user's to make, and `Evidence` is what stops
a confident guess from passing as a reading of the project:

**GATE — Where you are**

**Done**
- Read ROADMAP.md, work order 03, and docs/plans/03-booking-form.md

**Evidence**
- ROADMAP: lines 01–02 ticked, 03 unticked
- WO 03: `Depth: detailed`, no UI
- docs/plans/03-booking-form.md: 4 of 7 task boxes ticked
- git log: 4 task commits

**Decide**
- You are mid-build on work order 03. Run `/ajian-build 03` to resume at task 5?

**Risk**
- If those 4 commits are not actually on this branch, the build restarts work that exists and you
  get duplicate commits. Say so and I will check before resuming

**One step, never a chain.** Name the single next skill and ask. Do not offer the rest of the
pipeline, and do not run even that one until they say so.

## When the signals conflict

Trust git and the committed artifacts over any recollection. If a plan's boxes are ticked but the
code isn't committed, or a roadmap line is ticked but the branch never merged, say so and recommend
the safe next step rather than guessing.

## What ajian-map does not do

It routes; it does not run the work. It never edits code, promotes a work order, or writes a plan.
If the user wants that skill run, they invoke it.

**→ Next: whichever skill the signals above resolved to.**
