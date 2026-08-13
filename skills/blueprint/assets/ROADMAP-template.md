<!--
  ROADMAP.md — CHARTER: the ordered build plan at feature level. It maps each feature to its
  work order and records dependencies, order rationale, and depth status.
  MUST contain: ordered features, intent, dependencies, depth, work-order link, ticked status.
  MUST NOT contain: implementation detail, task breakdowns, or time estimates.
  Greenfield: the first row is the walking skeleton. On a resumed run this file is EXTENDED, never
  regenerated — the checkboxes are the only record of what has shipped.
  ROW ORDER IS BUILD ORDER. The `#` column is a permanent identity, not a position: it names the
  work order's files (work-orders/NN-*, plans/NN-*, plans/reports/NN-*) and must never be
  reassigned. Insert a feature by adding a ROW where it belongs and giving it the next free
  number — never by renumbering the rows below it.
-->

# <Project> — Roadmap

**Order rationale:** <one or two sentences: why this order — dependencies, riskiest-first,
thinnest-slice-first. Greenfield: why the walking skeleton comes first.>

**Granularity rule:** one row here = one work order = one build session. Anything finer is a
task, and tasks are the executing agent's to derive.

**Reading rule:** build order is **top to bottom**. The `#` column is each work order's permanent
identity — it names its files — so numbers may run out of sequence after an insertion. That is
expected, and it is why the order is read from the row, not the number.

| # | Done | Feature | Intent (why) | Depends on | Depth | Work order |
| - | ---- | ------- | ------------ | ---------- | ----- | ---------- |
| 1 | [ ] | <walking skeleton: setup + auth + one end-to-end slice> | <establish the structure end to end> | — | detailed | `work-orders/01-<slug>.md` |
| 2 | [ ] | <feature> | <one-line why> | 1 | brief | `work-orders/02-<slug>.md` |
| 3 | [ ] | <feature> | <one-line why> | 1 | brief | `work-orders/03-<slug>.md` |

<!-- Exactly one row may be at depth "detailed": the next unbuilt one.
     A row inserted later keeps its own number and simply sits where it belongs, e.g. a row
     numbered 9 placed between 2 and 3 because that is when it must be built. -->

## How to run this roadmap

1. Take the topmost unticked row.
2. Open its work order and read the documents its "read first" list names.
3. Build it to the Definition of Done in `QUALITY.md`.
4. Tick the line here, and record any changed project-wide decision as an ADR in `DECISIONS.md`.
5. Before starting the next line, deepen its work order from `brief` to `detailed` against the
   code that now exists — do not build from a brief.

## Deferred
<Features considered and consciously postponed, with the reason. Keeps them from being
re-proposed as if new. Anything permanently cut belongs in PRD.md non-goals instead.>

- <feature> — deferred because <reason>; revisit when <condition>
