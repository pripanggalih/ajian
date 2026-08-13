---
name: ajian-grill
description: >-
  Use before building a work order, to sharpen it from brief to buildable against the code that
  actually exists. This is grill-2, the micro pass of the ajian pipeline — fact-heavy, run one
  work order at a time. It recons the real code (previous work orders have shipped), asks only the
  genuine decisions the work order left open, and, for a UI feature, gathers the design brief the
  design pass will need. It promotes the work order from `Depth: brief` to `Depth: detailed` —
  deeper on WHAT must be true, never HOW. Triggers include "/ajian-grill NN", "sharpen work order
  N", "grill the next feature", "recon before building". Stops at the detailed work order — it
  never writes code, plans, or implementation steps.
---

<!-- Adapted from mattpocock/skills `grilling` (the frontier/rounds mechanic, grill-2 flavour in
     references/grill-engine.md); the brief→detailed promotion discipline is the author's own.
     Wired into ajian: grill-1 lives in ajian-blueprint (macro, decision-heavy); this is grill-2
     (micro, fact-heavy). See NOTICE.md for attribution of the vendored `grilling` text. -->

# Ajian · Grill

Take one work order from `Depth: brief` to `Depth: detailed`, against the code as it actually is.
The blueprint's grill-1 decided the shape of the whole project; this pass decides the exact shape
of the **next feature** — and only that one. It is the last stop before `ajian-plan` writes the
*how*.

Two things make grill-2 different from grill-1:

- **Facts, not decisions, dominate.** Previous work orders have shipped. Most gaps in the brief
  are answered by reading the code, not by asking the user. Read first; ask only what the code
  cannot answer. Finding facts is your job, never the user's.
- **The user's time is scarce.** Only genuine decisions — where two valid answers change what gets
  built — reach them, each with a recommendation. Everything a subagent can settle, a subagent
  settles.

## Pipeline

```
0  Orient          which work order (NN) · read it, ROADMAP, INDEX, its "read first" docs
1  Recon           dispatch a subagent to read the real code the work order will touch
2  Grill-2         frontier/rounds over the work order's open questions + what recon surfaced
                   (design questions too, if the feature has UI)              [only genuine asks]
3  Promote         brief → detailed: flows, edge cases, contracts, data effects, resolved Qs
                   project-wide changes → a new ADR                           [Gate: confirm]
4  Hand off        commit · → design (if UI) or → plan
```

---

## Step 0 — Orient

You are given a work order number (`NN`). If none was given, open `docs/ROADMAP.md` and take the
lowest-numbered unticked line. Then:

- Read `docs/work-orders/NN-<slug>.md` in full — its intent, scope, anchors, and **open questions**
  are the agenda for this pass.
- Read the documents its "Read first" list names, and `docs/INDEX.md` for anything it points to.
- Confirm this is the right work order and that its dependencies (the lines it lists) have shipped.
  If a blocker is unbuilt, say so and stop — grilling ahead of a dependency is planning against
  an imagined past.

Refuse to promote a work order that is already `Depth: detailed` unless the user is deliberately
re-opening it; two detailed work orders at once is the drift this pass exists to prevent.

## Step 1 — Recon the real code

**Dispatch a subagent** to read the code the work order will touch and report back the facts a
brief cannot know until now:

- The modules, functions, and types that already exist where this feature will live.
- The reuse targets the work order's anchors name — do they exist, at what path, with what shape?
- The conventions the shipped code actually follows (which may have drifted from `CONVENTIONS.md`;
  note the drift, do not silently obey it).
- For a UI feature: the components, tokens, and states already realised in `DESIGN.md` and code.

A running recon is an unsettled prerequisite: the questions that depend on it wait for the report;
everything else in the frontier proceeds. Do not ask the user anything a recon could find.

## Step 2 — Grill-2 (micro)

Run the interrogation on the grill engine — read
[references/grill-engine.md](references/grill-engine.md). The agenda is narrow and concrete: the
work order's own open questions, plus whatever recon surfaced that changes what must be true. Work
the frontier in rounds, one tight round at a time, a recommendation on every question, and **ask
only genuine decisions** — anything the code already answers is not a question.

**If the feature has UI**, this pass also gathers the design brief, so `ajian-design` can hand
impeccable answers instead of re-interviewing. Cover, for this surface only:

- **Mode** — is the surface Persuade, Operate, Read, or Experience? (What does success look like
  for the person on it?)
- **What changes the work** — the task or offer, the information shown, the key states that always
  get forgotten (empty, loading, error, success), and what must remain untouched.
- **Constraints** — the accessibility baseline and any brand non-negotiables from
  `DESIGN-SYSTEM.md`.

Do not ask for CSS values or aesthetic lanes — that is impeccable's craft, invented downstream.
Capture the answers as the surface's design brief inside the work order's detailed UI sections.

## Step 3 — Promote brief → detailed

Rewrite the work order in place, from `Depth: brief` to `Depth: detailed`, adding on top of the
brief (never removing the brief's intent, scope, or acceptance criteria):

- **Flows** — the paths through the feature, happy and unhappy: trigger, what must happen,
  observable outcome, and which global error state applies when it goes wrong.
- **Edge cases** — case → required behaviour.
- **Contracts** — the interfaces this feature exposes or consumes, at the level of shape and
  meaning: takes what, returns what, fails when — not signatures, not code.
- **Data effects** — which entities are created, read, updated, invalidated, and which
  `DATA-MODEL.md` invariants it upholds.
- **Screens & states** (UI only) — the surface's design brief from step 2, by name.
- **Resolved questions** — each open question, with its answer and where the answer now lives.

**Still no implementation steps, function names, or code.** `detailed` deepens *what must be true*;
`ajian-plan` owns *how*. Anything that changed a **project-wide** decision is promoted into a new
`docs/decisions/NNNN-<slug>.md` (with a ledger row in `DECISIONS.md`), not buried in the work order.

If this is the first UI feature, seed `docs/DESIGN-SYSTEM.md` with the thin constraints only — the
accessibility baseline and brand non-negotiables — leaving the realised visual system to
`ajian-design`.

### Gate

Show the user the promoted work order — specifically the flows, the resolved questions, and any
new ADR — and wait:

> "Work order NN is now detailed: <one line on what the recon changed and what you decided>.
> Review the flows and the resolved questions before I hand it on. Tell me what to change."

Apply changes, then commit the work order (and any new ADR / DESIGN-SYSTEM seed).

## Step 4 — Hand off

- **UI feature →** `ajian-design` builds the visual world before planning, so the plan can name
  real screens.
- **No UI →** `ajian-plan` turns the detailed work order into an implementation plan.

**→ Next: `/ajian-design NN`** if the feature has UI, otherwise **`/ajian-plan NN`**
(or `/ajian-map` if unsure).
