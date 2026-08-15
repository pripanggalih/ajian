---
name: ajian-grill
description: >-
  Use before building a work order, to sharpen it from brief to buildable against the code that
  actually exists. Triggers include "/ajian-grill NN", "sharpen work order N", "grill the next
  feature", "recon before building". This is grill-2, the fact-heavy micro pass: it recons the real
  code, asks only the genuine decisions the work order left open, gathers the design brief for a UI
  feature, and promotes the work order from `Depth: brief` to `Depth: detailed` — deeper on WHAT
  must be true, never HOW. Stops there: it never writes code, plans, or implementation steps.
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

- **Facts, not decisions, dominate.** Previous work orders have shipped, so most gaps in the brief
  are answered by reading the code. Finding facts is your job, never the user's.
- **The user's time is scarce.** Only genuine decisions reach them, each with a recommendation.
  Everything a subagent can settle, a subagent settles.

## Preconditions

One command answers all three. Run it once, then trust the output for the rest of the session:

```bash
grep -m1 '^Depth:' docs/work-orders/NN-*.md   # substitute the real NN
ls docs/ROADMAP.md docs/INDEX.md
grep '^- \[' docs/ROADMAP.md                  # which dependency lines are ticked
```

- Already `detailed` → it has been grilled; refuse unless the user is deliberately re-opening it
  (two detailed work orders at once is the drift this pass exists to prevent).
- A roadmap line it depends on is unticked → grilling ahead of a dependency is planning against an
  imagined past.
- No `ROADMAP.md` / `INDEX.md` → no blueprint, no work order to sharpen.

### When a precondition fails

Check the files on disk, not what the conversation claims happened. When one fails, stop — do not
quietly fix it. Name the gap in plain language, name the one skill that owns it, offer that one step:

> "<what is missing, in a sentence a non-developer follows>. That is `<skill>`'s job — it <what it
> does, in plain words>. Run it now?"

Then wait. One step, never a chain, and never run the missing step without asking.

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

## Pipeline

```
0  Orient          which work order (NN) · read that one file — it is the agenda
1  Grill-2         dispatch recon, then open round 1 immediately; only the questions
                   downstream of recon wait for its report                    [only genuine asks]
2  Promote         brief → detailed: flows, edge cases, contracts, data effects, resolved Qs
                   project-wide changes → a new ADR                           [Gate: confirm]
3  Hand off        commit · → design (if UI) or → plan
```

---

## Step 0 — Orient

You are given a work order number (`NN`). If none was given, take the topmost unticked row of
`docs/ROADMAP.md` — position in the table is the build order, not the number in the `#` column.

**Read `docs/work-orders/NN-<slug>.md`, and only that.** Its intent, scope, anchors and **open
questions** are the agenda. Everything else it points at — `docs/INDEX.md`, its "Read first" list,
the shape of the code — goes to recon in step 1. The controller does not need any of it to write the
agenda, and reading it here delays the first question for nothing.

Refuse to promote a work order that is already `Depth: detailed` unless the user is deliberately
re-opening it; two detailed work orders at once is the drift this pass exists to prevent.

## Step 1 — Grill-2, with recon running underneath

**Dispatch recon first, then keep talking — do not wait for it.** A running exploration is an
unsettled prerequisite: only the questions downstream of it wait for the report; ask the rest of the
frontier now.

Recon's brief — the facts a brief cannot know until now:

- The modules, functions, and types that already exist where this feature will live.
- The reuse targets the work order's anchors name — do they exist, at what path, with what shape?
- The conventions the shipped code actually follows, and where they drift from `CONVENTIONS.md`
  (note the drift, do not silently obey it).
- What `docs/INDEX.md` and the work order's "Read first" list carry that binds this feature.
- For a UI feature: the components, tokens, and states already realised in `DESIGN.md` and code.

Run the interrogation on the grill engine — [references/grill-engine.md](references/grill-engine.md).
The agenda is narrow: the work order's open questions, plus whatever recon surfaces that changes what
must be true. Frontier in rounds, one tight round at a time, a recommendation on every question. The
engine's (a)/(b) filter decides what reaches the user — apply it, do not re-derive it per question.

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

## Step 2 — Promote brief → detailed

Rewrite the work order in place, from `Depth: brief` to `Depth: detailed`, adding on top of the
brief (never removing the brief's intent, scope, or acceptance criteria):

- **Flows** — the paths through the feature, happy and unhappy: trigger, what must happen,
  observable outcome, and which global error state applies when it goes wrong.
- **Edge cases** — case → required behaviour.
- **Contracts** — the interfaces this feature exposes or consumes, at the level of shape and
  meaning: takes what, returns what, fails when — not signatures, not code.
- **Data effects** — which entities are created, read, updated, invalidated, and which
  `DATA-MODEL.md` invariants it upholds.
- **Screens & states** (UI only) — the surface's design brief from step 1, by name.
- **Built surface** (UI only) — leave it at `Status: not yet designed`. The section exists so
  `ajian-design` has somewhere to stamp the handoff before it invokes impeccable; do not fill it
  in, and do not delete it from a work order that has UI.
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

**GATE — Work order NN detailed**

**Done**
- Promoted work order NN from brief to detailed against the code as it is

**Evidence**
- Recon: <paths and existing modules it found>
- Conventions: <what the shipped code follows, and where it drifts from CONVENTIONS.md>
- Flows: <the flows as written>
- Resolved: <the questions closed, and how>
- ADR: <any new ADR file path, or none>

**Decide**
- Do the flows and the resolved questions match what you want built?

**Risk**
- This work order is the Spec axis ajian-review judges the finished code against
- A flow that is wrong here produces code that passes review while being wrong, which is the most
  expensive kind of wrong in this pipeline

Apply changes, then commit the work order (and any new ADR / DESIGN-SYSTEM seed).

## Step 3 — Hand off

- **UI feature →** `ajian-design` builds the visual world before planning, so the plan can name
  real screens.
- **No UI →** `ajian-plan` turns the detailed work order into an implementation plan.

**→ Next: `/ajian-design NN`** if the feature has UI, otherwise **`/ajian-plan NN`**
(or `/ajian-map` if unsure).
