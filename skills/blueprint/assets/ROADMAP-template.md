<!--
  ROADMAP.md — CHARTER: the ordered build plan at feature level. It maps each feature to its
  work order and records dependencies, order rationale, and depth status.
  MUST contain: ordered features, intent, dependencies, depth, work-order link, ticked status.
  MUST NOT contain: implementation detail, task breakdowns, or time estimates.
  Greenfield: line #1 is the walking skeleton. On a resumed run this file is EXTENDED, never
  regenerated — the checkboxes are the only record of what has shipped.
-->

# <Project> — Roadmap

**Order rationale:** <one or two sentences: why this order — dependencies, riskiest-first,
thinnest-slice-first. Greenfield: why the walking skeleton comes first.>

**Granularity rule:** one line here = one work order = one build session. Anything finer is a
task, and tasks are the executing agent's to derive.

| # | Done | Feature | Intent (why) | Depends on | Depth | Work order |
| - | ---- | ------- | ------------ | ---------- | ----- | ---------- |
| 1 | [ ] | <walking skeleton: setup + auth + one end-to-end slice> | <establish the structure end to end> | — | detailed | `work-orders/01-<slug>.md` |
| 2 | [ ] | <feature> | <one-line why> | 1 | brief | `work-orders/02-<slug>.md` |
| 3 | [ ] | <feature> | <one-line why> | 1 | brief | `work-orders/03-<slug>.md` |

<!-- Exactly one line may be at depth "detailed": the next unbuilt one. -->

## How to run this roadmap

1. Take the lowest-numbered unticked line.
2. Open its work order and read the documents its "read first" list names.
3. Build it to the Definition of Done in `QUALITY.md`.
4. Tick the line here, and record any changed project-wide decision as an ADR in `DECISIONS.md`.
5. Before starting the next line, deepen its work order from `brief` to `detailed` against the
   code that now exists — do not build from a brief.

## Deferred
<Features considered and consciously postponed, with the reason. Keeps them from being
re-proposed as if new. Anything permanently cut belongs in PRD.md non-goals instead.>

- <feature> — deferred because <reason>; revisit when <condition>
