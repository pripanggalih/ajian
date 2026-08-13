<!-- Adapted from `discussion-to-blueprint` references/doc-charters.md. The only ajian change:
     DECISIONS is split into a thin ledger plus one file per ADR under decisions/, so a work
     order can attach a single ADR without loading the whole log. -->

# Document charters and the self-review

Every file owns one thing. Overlap is the slow failure of a blueprint: the same fact lands in
two files, one gets corrected, and from then on the blueprint contradicts itself and the reader
cannot tell which copy is current.

## Charters

| File | Owns | Must NOT contain |
| --- | --- | --- |
| `INDEX.md` | Routing: what each doc owns, what to read for what | Any fact of its own — it only points |
| `PRD.md` | Why, users, jobs-to-be-done, scope, non-goals, feature list, success metrics | Stack, schemas, UI detail, implementation |
| `ARCHITECTURE.md` | Stack + versions, module structure and boundaries, API style, state, errors, auth, config, NFRs | Entity attributes (→ DATA-MODEL), code-style minutiae (→ CONVENTIONS), rationale (→ DECISIONS) |
| `DATA-MODEL.md` | Entities, business attributes, relationships, invariants, lifecycles | Migration SQL, ORM code, index tuning, per-feature fields |
| `CONVENTIONS.md` | Reuse inventory, naming, code style, imports, commits, test-file naming and location | Testing philosophy, coverage, DoD, gates (→ QUALITY), architecture (→ ARCHITECTURE) |
| `DESIGN-SYSTEM.md` | Tokens, core components, global interaction states, layout rules, accessibility baseline | Per-screen specs, product rationale |
| `DECISIONS.md` | The ADR **ledger**: one row per decision — number, title, status, link to its file | The reasoning itself (→ `decisions/NNNN-*.md`) |
| `decisions/NNNN-*.md` | One decision's *why*: context, decision, alternatives, consequences (or, open, its options and what it blocks) | A decision restated without its tradeoff |
| `QUALITY.md` | Testing approach and levels, coverage expectations, Definition of Done, CI gates | Test-file naming (→ CONVENTIONS), per-feature test cases |
| `GLOSSARY.md` | Domain term → precise business definition (CONTEXT.md format, with `_Avoid_`) | Implementation notes; it is a dictionary |
| `ROADMAP.md` | Ordered features, intent, dependencies, depth status, order rationale | Implementation detail, tasks, estimates |
| `work-orders/NN-*.md` | One feature's intent, scope, acceptance criteria, anchors, open questions (+ detail once promoted) | Copies of blueprint content, the stack, implementation steps |

Every document **states** a decision; only `DECISIONS.md` **explains** it. When you find
yourself writing "we chose X because…" outside `DECISIONS.md`, split it: the choice stays, the
because moves.

## Self-review

Run all six after writing, and fix what they turn up before the gate. Do not report the review
to the user as a finding list — fix it inline, then gate.

**1. Placeholder scan.** Search every file for "TBD", "TODO", "to be determined", "etc.", and
any requirement that cannot be checked. Convert genuine unknowns to open ADRs; fix the rest.

**2. Charter check.** Read each file against its row above. Move anything that leaked.

**3. Cross-document consistency.**

- The stack table in `ARCHITECTURE.md` matches its ADR in `DECISIONS.md`, version for version.
- Every entity named in `PRD.md` or in a work order exists in `DATA-MODEL.md`.
- Every reuse target named in a work order exists in the `CONVENTIONS.md` inventory.
- Every screen or state named in a work order exists in `DESIGN-SYSTEM.md`.
- Test-file naming in `CONVENTIONS.md` does not contradict the gates in `QUALITY.md`.
- Terms used across files match `GLOSSARY.md` where it exists.

**4. Traceability.** Follow each chain end to end and fix any break:

```
PRD feature  →  ROADMAP line  →  work order  →  acceptance criteria
                                       ↓
                          anchors → entity / screen / reuse target
                                     that actually exists
```

An orphan in either direction is a defect: a PRD feature with no roadmap line was dropped
silently, and a roadmap line with no PRD feature was invented.

**5. Depth discipline.**

- No ordered implementation steps, function signatures, pseudocode, or file edit lists.
- No effort estimates or dates.
- Exactly one work order at `Depth: detailed`.
- No per-feature detail sitting in a project-level document.

**6. Stranger test.** Re-read `INDEX.md` and work order #1 as an agent that did not witness the
conversation. Could it start work without asking anything? Every question it would have to ask
is either a missing section or an open question you failed to record.

## Scope sanity

One more judgement, before the gate rather than as part of the review: is this one coherent
project? If the discussion has produced independent subsystems with separate users and separate
data, say so and propose splitting the blueprint rather than writing one that governs neither
half well.
