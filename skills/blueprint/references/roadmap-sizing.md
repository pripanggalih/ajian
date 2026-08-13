<!-- Adapted from mattpocock/skills `to-tickets` — the vertical-slice rules and the expand–contract
     treatment of wide refactors are quoted nearly verbatim. In ajian this is NOT a downstream
     ticketing layer; its sizing wisdom lives here, at the roadmap gate, as rails. One roadmap line
     is one work order is one build session. See NOTICE.md for attribution. -->

# Roadmap sizing (the rails for Gate 2)

The roadmap is the backbone: every work order, plan, and build session is one line of it. A line
sized wrong poisons every stage downstream — too big and `ajian-build` stalls mid-plan, too small
and the pipeline thrashes. So Gate 2 is a **mini-interrogation**, and these are its rails. Put
every proposed line through all three tests, out loud, and split or merge before you present.

## Test 1 — Sizing: one build session

**One roadmap line is one work order is one build session** — it must fit in a single fresh
context window, from the executing agent's first read to a merged, reviewed branch. If a line
would need two sittings, or a plan so long the executor loses the thread halfway (the classic
`writing-plans` failure), it is too big. Split it.

Rough tells that a line is too big:

- Its plan would run past roughly a dozen tasks, or the plan file would be too long to hold in
  one context.
- It touches three or more unrelated areas that could each ship on their own.
- You cannot state its single demoable outcome in one sentence.

Tells that lines are too small (merge them):

- A line delivers nothing demoable alone and only makes sense bundled with the next.
- Two adjacent lines always ship together and share the same acceptance surface.

## Test 2 — Slice: vertical and demoable

Each line is a **tracer bullet** — a narrow but COMPLETE path through every layer it needs
(schema, API, UI, tests), not a horizontal slice of one layer.

- A completed line is **demoable or verifiable on its own**. "Build the database" and "build the
  API" are horizontal layers, not lines; "a guest can book a room and see it confirmed" is a line.
- Greenfield opens with the **walking skeleton**: project setup, auth if the product has any, and
  one thin end-to-end slice that proves the stack holds together.

## Test 3 — Order: dependencies, risk, thinnest-first

Sequence the lines so each can actually start when its turn comes:

- **Dependencies respected.** A line lists the lines that must complete before it. Order the
  roadmap so blockers come first; for a purely linear chain that is simply top to bottom. Record
  the reason for each ordering choice (dependency, risk-first, thinnest-slice-first).
- **Risk first.** Pull the line that could invalidate the whole design earlier rather than later —
  a failed assumption is cheapest to discover before the work built on it.
- **Thinnest slice first.** Between two orderings that both respect dependencies, prefer the one
  that ships a demoable slice soonest.

## The exception: wide refactors

A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose
**blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at
once and no vertical slice can land green. Don't force it into a tracer-bullet line; sequence it as
**expand–contract** across several roadmap lines:

1. **Expand** — add the new form beside the old so nothing breaks (one line).
2. **Migrate** — move the call sites over in batches sized by blast radius (per package, per
   directory), each batch its own line blocked by the expand, CI green batch to batch because the
   old form still exists.
3. **Contract** — delete the old form once no caller remains, in a line blocked by every migrate
   batch.

When even the batches cannot stay green alone, keep the sequence but let them share an integration
branch that all block a final integrate-and-verify line — green is promised only there.

## After the tests

Only once every line passes all three do you present the list and wait for approval (Gate 2). Then
write `ROADMAP.md` from its template, one line per work order, in dependency order.
