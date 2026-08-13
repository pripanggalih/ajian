<!-- The author's own foundation-doc discipline. One section is rewritten for ajian: the earlier
     form leaned on "this skill has no downstream"; in ajian a downstream DOES exist (ajian-plan),
     so the justification is restated on the what/how boundary instead. -->

# Depth, drift, and where the blueprint stops

Read this before writing any file. It is the discipline that keeps the blueprint and its
downstream from drifting into each other.

## Why the blueprint holds the line at *what*, and the plan owns *how*

In ajian the blueprint **does** have a downstream: `ajian-plan` turns each detailed work order
into an implementation plan (the *how*), and `ajian-build` executes it. That is exactly why the
blueprint must not pre-write the *how* — if it did, two derivations of the same steps (the
blueprint's and the plan's) would drift apart and contradict, and the executing agent would not
know which to trust.

So the rule is not "write less" for its own sake. It is **write only what will still be true when
someone reads it, and only the layer this skill owns**: the blueprint states *what must be true
when the work is done*; the plan, downstream, states *how to get there*. Keep the two apart and
neither can rot the other.

## The two axes

Every candidate sentence sits somewhere on two axes. Both have a hard boundary.

### Axis 1 — durability: is this still true in three features' time?

| Durable → write it now | Volatile → leave it for the feature that needs it |
| --- | --- |
| The stack and its versions | Which library call this endpoint uses |
| Entities and their relationships | One screen's exact field list |
| Naming and file conventions | One module's internal helper names |
| Definition of Done, CI gates | One feature's specific test cases |
| Design tokens and global states | One screen's particular layout |
| A decision and its tradeoff | The order in which files get edited |

### Axis 2 — the what/how cut line

The blueprint states **what must be true when the work is done**. It never states **how to get
there**.

**In bounds:** goals, scope, non-goals, acceptance criteria, invariants, contracts (shape and
meaning of an interface), states and transitions, constraints, quality gates.

**Out of bounds:** ordered implementation steps, task breakdowns, function and variable names,
code and pseudocode, file-by-file edit lists, effort estimates and timelines.

The reliable tell: if a sentence would need rewriting because the agent chose a different but
equally valid implementation, it is out of bounds.

## Just-in-time depth

Every work order carries an explicit `Depth:` field.

### `Depth: brief` — every feature, from the moment the roadmap is approved

- Intent (why this exists, who benefits)
- In scope / non-goals
- Observable acceptance criteria
- Anchors — entities, screens, states, reuse targets, **by name**
- Dependencies on other roadmap lines
- Open questions, listed deliberately and left unanswered

A brief is short on purpose. It is enough to judge order, dependency and scope, and nothing
more — because nothing more is knowable yet.

### `Depth: detailed` — only the feature about to be built

Adds, on top of the brief:

- Flows and scenarios, including the unhappy paths
- Edge cases and error behaviour
- Contracts the feature touches — interfaces at the level of shape and meaning
- Data effects: which entities are read, written, or invalidated
- The open questions, now resolved — with anything that changed a project-wide decision
  promoted into `DECISIONS.md` as an ADR

Still no implementation steps. `detailed` deepens *what must be true*, never *how*.

### Promotion, not planning

Detail is added by **`ajian-grill`**, run against a single work order after the previous feature
ships, reading the code as it actually is. (Blueprint promotes only line #1, at the end of its
own run.) This is the whole mechanism: detail written against real code is right; detail written
against an imagined future is a guess that has to be unlearned. Note that promotion is still
*deepening the what*, never planning the how — the how is `ajian-plan`'s to write.

Only one work order should sit at `Depth: detailed` at a time. Two means someone is planning
ahead, which is exactly the failure this prevents.

## The inclusion test for documents

**Will this file be reopened while writing code?**

- Yes, regularly → it earns a file of its own.
- Yes, but rarely, and it is small → fold it into the nearest file whose charter covers it.
- No → cut it. A document that is written, read once, and archived is a cost with no return.

This is why conditional files are born lazily: `DATA-MODEL.md` only when there is data,
`DESIGN-SYSTEM.md` only when there is an interface, `GLOSSARY.md` only when the domain has
terms people genuinely use inconsistently.

## Placeholders are forbidden

"TBD" in a blueprint is worse than an omission, because an agent reads a document as settled
fact and a human skims past the marker. An unknown gets recorded in `DECISIONS.md` as an ADR
with `Status: open`, stating what is not known, the options on the table, and which roadmap
line it blocks. That form is honest, searchable, and impossible to mistake for a decision.

## Stack handling

The stack is decided once and recorded in exactly two places: the table in `ARCHITECTURE.md`
and its ADR in `DECISIONS.md`. Never transcribe it into a work order — a work order links to
`ARCHITECTURE.md` instead. Each copy is a place a version number can go stale independently.

- **Greenfield** — help the user choose from options you named with their tradeoffs.
  `ARCHITECTURE.md` instructs the executing agent to scaffold it, and roadmap line #1 is a
  walking skeleton.
- **Brownfield** — record what the repo has, verbatim, from the manifest and config files.
  `ARCHITECTURE.md` instructs the agent to extend the existing codebase and not to scaffold.

Never hardcode a stack that was not chosen by the user or found in the repo.
