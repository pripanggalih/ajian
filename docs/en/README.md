# Ajian — usage guide (English)

**[Bahasa Indonesia →](../id/README.md)**

Ajian is eight skills that take a project from a wild idea to shipped code, one work-order at a time,
with a human gate at every decision that is expensive to undo. This guide is the map; each skill has
its own page below.

## Getting started

1. Install the skillset (see the root [README](../../README.md)). `ajian-design` also needs
   `npx impeccable install`.
2. Open your project (empty for greenfield, or an existing repo for brownfield) in your coding agent.
3. **Inherited a project that already has docs?** Run **`/ajian-adopt`** first. It surveys what is
   written, proposes where each document should go, and migrates only what you approve — so ajian
   builds on your existing docs instead of writing a rival set beside them.
4. Run **`/ajian-blueprint`** — or just start talking about the idea and invoke it when you're ready.
   It interrogates the idea and writes the foundation docs and roadmap.
5. From there, follow each skill's `→ Next` breadcrumb. Lost? Run **`/ajian-map`**.

**You don't have to get the order right.** Run a skill too early and it won't refuse and leave you
stuck, and it won't quietly do the missing work either. It checks the project's actual files, tells
you in plain language where you are, names the one skill that fills the gap, and asks whether to run
it. Always one step — never "shall I run the next four?", because that is a whole pipeline traded
for a single yes.

## The pipeline

```
(ajian-adopt, only if the project already has docs in another shape)
  →  ajian-blueprint  →  per roadmap row, top to bottom:
                           ajian-grill  →  (ajian-design, if UI)  →  ajian-plan  →  ajian-build  →  ajian-review
                         →  next row
```

- **ajian-adopt** runs at most once, on a project you inherited. Skip it for a fresh start.
- **ajian-blueprint** runs once at the start (and again in "resumed" mode to extend the roadmap or
  insert a feature mid-build).
- The five per-row skills repeat for every roadmap row, top to bottom.
- **ajian-map** is not in the line — run it any time to locate yourself.
- Build order is the **row order** in `ROADMAP.md`. The number in the `#` column is each work
  order's permanent name, so after an insertion it can run out of sequence — that is expected.

## The gates (where you decide)

Ajian never makes an expensive-to-undo decision for you. Every stop is written in the same shape,
so a skipped gate is visible by its absence:

```
GATE — <name of the gate>
Done:     <what the agent actually did>
Evidence: <real command output, or a committed file path — not "looks good to me">
Decide:   <the question you answer>
Risk:     <what breaks if this is wrong and it proceeds anyway>
```

`Risk` is the line written for you specifically. If you can't read the code, that line is how you
still decide well — it says what it costs to be wrong. If a gate arrives without `Evidence`, the
agent is asking you to trust its impression; ask it to show you.

It stops and waits at:

- **Foundation** — after the docs are written, before the roadmap (in `ajian-blueprint`).
- **Roadmap** — the sizing mini-interrogation, before work orders exist (in `ajian-blueprint`).
- **Work order** — after grill-2 promotes it to detailed (in `ajian-grill`).
- **Design direction** — impeccable's own direction gate (in `ajian-design`).
- **Plan** — after the plan is written, before any code (in `ajian-plan`).
- **Review & merge** — after the 2-axis review, before integrating (in `ajian-review`).

## What ends up in your project

Nothing branded "ajian". The skills write generic artifacts an agent discovers on its own:

```
PRODUCT.md  DESIGN.md          (root, owned by impeccable)
docs/
  INDEX.md  PRD.md  ARCHITECTURE.md  CONVENTIONS.md  QUALITY.md  ROADMAP.md
  GLOSSARY.md  DATA-MODEL.md  DESIGN-SYSTEM.md
  DECISIONS.md  decisions/NNNN-*.md
  work-orders/NN-*.md
  plans/NN-<slug>.md            (committed; its checkboxes are the build ledger)
  plans/reports/NN-<slug>.md    (one build report per plan — the executor's verification evidence)
```

## Per-skill pages

| Skill | Page |
| --- | --- |
| `ajian-map` | [ajian-map.md](ajian-map.md) |
| `ajian-adopt` | [ajian-adopt.md](ajian-adopt.md) |
| `ajian-blueprint` | [ajian-blueprint.md](ajian-blueprint.md) |
| `ajian-grill` | [ajian-grill.md](ajian-grill.md) |
| `ajian-design` | [ajian-design.md](ajian-design.md) |
| `ajian-plan` | [ajian-plan.md](ajian-plan.md) |
| `ajian-build` | [ajian-build.md](ajian-build.md) |
| `ajian-review` | [ajian-review.md](ajian-review.md) |

## Design reference & attribution

The complete design rationale is in [`docs/ajian-blueprint.md`](../ajian-blueprint.md). Honest
attribution of the four upstream sources is in [`NOTICE.md`](../../NOTICE.md).
