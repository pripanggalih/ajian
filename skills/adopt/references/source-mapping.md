<!-- Original ajian wiring. The destination charters are ajian-blueprint's
     (references/doc-charters.md); this file only says which incoming shapes tend to carry which
     charter's content. See NOTICE.md. -->

# Mapping foreign documents onto the blueprint

What turns up in real projects, and where its content belongs. This is a starting hypothesis for
Step 1, never a verdict — the user approves every move, document by document.

**The rule that overrides every row below:** map by **what a passage says**, not by the file it
sits in or the heading above it. A file called `ARCHITECTURE.md` that actually argues for a product
direction is `PRD.md` content. Titles are the least reliable signal in an inherited repo.

## The usual sources

| Source | What it usually carries | Where it goes |
| --- | --- | --- |
| `README.md` (long) | vision, users, stack, install, contribution rules, badges | split: vision/users → `PRD.md`; stack/structure → `ARCHITECTURE.md`; naming and style → `CONVENTIONS.md`; **install, badges, licence stay put** |
| `README.md` (short) | install and a one-liner | stays put; not a source |
| `PRD.md`, `product.md`, `vision.md` | why, users, scope, sometimes a feature list | `PRD.md`; a feature list is a roadmap **candidate**, not a roadmap |
| `ARCHITECTURE.md`, `design.md`, `tech-notes.md` | stack, structure, boundaries, NFRs | `ARCHITECTURE.md`; NFR budgets are its constraints section |
| `CONTRIBUTING.md` | naming, style, test layout, PR etiquette | naming/style/tests → `CONVENTIONS.md`; **etiquette and PR process stay put** |
| `docs/adr/*`, `decisions/*` in another format | one decision per file, usually MADR or Nygard | `docs/decisions/NNNN-<slug>.md` + a `DECISIONS.md` ledger row; keep the original text, restate only the header fields |
| `CHANGELOG.md` | what shipped | stays put. It is history, not durable truth, and no work order will open it |
| A checked-in wiki or `docs/` tree | anything | survey each page separately; a wiki is a source directory, not a source document |
| `TODO.md`, `BACKLOG.md`, issue exports | unordered wishes | **not** `ROADMAP.md`. Deferred items → the roadmap's `Deferred` section once a roadmap exists; the rest is raw material for `ajian-blueprint`'s roadmap gate |
| Test plan / QA doc | what must pass, how it is checked | `QUALITY.md` — Definition of Done and CI gates |
| Data dictionary, schema notes, ERD prose | entities, relationships, invariants | `DATA-MODEL.md`, restated in business language, not table DDL |
| Style guide, design tokens doc, Figma export notes | a11y baseline, brand non-negotiables | the thin constraints → `DESIGN-SYSTEM.md`; the realised visual system is impeccable's `DESIGN.md`, not yours to write |
| Domain glossary | terms and their meanings | `GLOSSARY.md`, adding the `_Avoid_` synonym discipline the template asks for |

## Spec Kit and similar frameworks

A project that ran GitHub Spec Kit leaves `.specify/`, a constitution, and per-feature specs. They
map cleanly, and the mapping is worth stating because the temptation is to treat them as already
correct:

| Spec Kit artifact | Where it goes |
| --- | --- |
| constitution | split across `PRD.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `QUALITY.md` by charter — a constitution is all four at once |
| a feature spec | `docs/work-orders/NN-<slug>.md` at `Depth: brief`. **Never at `detailed`** — detail belongs only to the next unbuilt feature, and only against real code |
| a plan / task list | **stays put, and does not migrate.** `ajian-plan` owns the *how*, written against a detailed work order. An inherited task list is a plan for code that may already exist |

The same reading applies to any framework's leftovers: its **what** is adoptable, its **how** is
not. A `Depth: detailed` work order inherited wholesale is the one migration that reliably makes
the project worse, because everything downstream trusts that depth.

## Content that belongs to nobody

Every long inherited document has a residue: paragraphs that are neither product truth nor
architecture nor convention — history, rationale for a change nobody remembers, notes to a person
who has left.

Do not force it into a document to make the survey tidy. Leave it where it is and say so in the
mapping. Blueprint rule 3 is the test: a document nobody will reopen during development should not
exist, and content nobody will reopen should not be migrated into one that will.
