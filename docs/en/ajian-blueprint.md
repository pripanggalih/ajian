# ajian-blueprint

## What it does

Turns a free-form idea into a durable **blueprint**: the foundation documents (`PRD`,
`ARCHITECTURE`, `CONVENTIONS`, `QUALITY`, and conditionally `DATA-MODEL`, `DESIGN-SYSTEM`,
`GLOSSARY`), an ordered `ROADMAP`, and one work order per roadmap line. It runs **grill-1** — the
macro interrogation, on the frontier/rounds engine railed by six themes, bounded to one theme at a
time, with a recommendation on every question. It writes what must be true, never how to build it.

## When to reach for it

- At the **start** of a build, greenfield or brownfield — it holds the whole design conversation.
- At the **end** of a design discussion — it distils what you already settled and interrogates the gaps.
- In **resumed** mode, when a `ROADMAP.md` already exists and you want to extend it or reconcile it
  with shipped code.
- **Mid-project, to insert or change a feature.** This is resumed mode too, and it is the only place
  a roadmap already being built gets changed — the roadmap has one owner.

## Common questions

- **Does it write code or plans?** No. It stops at the blueprint. `ajian-plan` owns the *how*.
- **Greenfield stack?** It proposes 2–3 defensible options with tradeoffs and lets you choose;
  roadmap line #1 is a walking skeleton. Brownfield: it scans the repo in the background — the first
  themes are asked while the scan runs — and records the stack verbatim.
- **Why so much interrogation up front?** A question skipped here becomes an assumption every later
  work order inherits. The two gates (foundation, roadmap) are hard stops that wait for you.
- **Roadmap sizing?** Gate 2 is a mini-interrogation: every row must pass sizing (one build session),
  slice (vertical, demoable), and order (dependency, risk, thinnest-first).
- **I want to add a feature halfway through — what happens?** Run it in resumed mode. The new feature
  goes through the same three sizing tests as any Gate 2 row, then takes the **next free number** and
  sits in the **row** where it must be built — so it may be numbered 09 and sit between rows 2 and 3.
  That is correct: numbers are permanent names, and renumbering would break every `plans/NN-*`,
  report, ADR reference and commit message that used the old one.
- **What about work I already planned that the new feature overlaps?** It checks. Merged work orders
  it touches are named so the new scope accounts for them; unbuilt work orders that overlap are
  either marked `superseded by NN` or narrowed — **your choice per overlap**, since where the line
  falls is a product judgement. Nothing is deleted; a superseded work order may already carry a plan,
  a report, or commits. Decisions in `DECISIONS.md` the change contradicts get a superseding ADR
  rather than a silent edit.

## It's working if

A competent agent that never saw your conversation could open `docs/INDEX.md` and start work order
#1 without asking you a question — and there are no placeholders, only open ADRs where something is
genuinely undecided.
