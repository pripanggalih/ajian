---
name: ajian-blueprint
description: >-
  Use when a discussion about a new project, a new feature, or a mid-project change should
  become a durable development blueprint: foundation documents, an ordered roadmap, and one
  paste-ready work order per feature. This is stage one of the ajian pipeline (grill-1, the
  macro interrogation). Run it at the START of a build, where it holds the design interrogation
  itself, or at the END of a discussion, where it distils what was settled. Triggers include
  "/ajian-blueprint", "turn this into a blueprint", "buat dokumen pengembangan", "jadikan patokan",
  "bikin PRD dan arsitekturnya", "lock the decisions", "buat roadmap dan urutan kerjanya",
  "siapkan dokumennya biar bisa dikerjakan agent". Handles greenfield (choose the stack),
  brownfield (scan the repo, extend it), and resumed runs (deepen the next feature). Framework-
  and executor-agnostic: the output is consumed by any AI coding agent or human. Stops at the
  blueprint — it never writes code or implementation steps.
---

<!-- The foundation-doc machinery (docs, roadmap, work orders) is the author's own prior work. The
     interrogation engine spliced into step 2 is adapted from mattpocock/skills `grilling` (the
     frontier/rounds mechanic). Wired into ajian: this is grill-1 (macro), and a downstream exists
     (ajian-plan owns the "how") — see references/depth-and-drift.md for why the depth discipline
     still holds. Foundation docs are written flat to `docs/`, level with impeccable's root
     PRODUCT.md / DESIGN.md. See NOTICE.md for attribution of vendored sources. -->

# Ajian · Blueprint

Turn a design conversation into a **development blueprint**: a small set of documents that stay
true across the whole project, an ordered roadmap, and one work order per feature that any AI
coding agent can pick up and execute.

**Two ways in, one process.** Called at the **start** of a build, this skill runs the design
conversation itself — step 2 is a full interrogation from the problem statement up. Called at
the **end** of one, step 2 opens from what that conversation settled and interrogates only the
gaps. Either way the run ends identically: `docs/` committed, one work order per roadmap line.

This skill sits at the head of the ajian pipeline. It **does** have a downstream — `ajian-grill`
sharpens each work order, `ajian-plan` writes the *how*, `ajian-build` executes — but nothing
downstream regenerates the foundation documents, so the blueprint remains the single source of
truth. The depth discipline is what keeps that boundary clean: the blueprint owns *what must be
true*, the plan owns *how to get there*, and the two never overlap. It is not optional — read
[references/depth-and-drift.md](references/depth-and-drift.md) before writing anything.

The interrogation in step 2 runs on the ajian grill engine — the frontier/rounds mechanic railed
by the six themes below. Read [references/grill-engine.md](references/grill-engine.md) before you
start asking.

## The three rules that keep a blueprint alive

A blueprint fails in one of three ways: it rots, it drowns the reader, or nobody opens it.
Each rule kills one failure mode.

1. **Depth follows need, never ambition.** Every feature gets a **brief**. Only the feature
   about to be built gets **detail**. Detail written for feature #7 today is wrong by the time
   feature #1 ships. Re-run this skill to deepen the next feature, reading the real code first.

2. **State what must be true when done, never how to get there.** The cut line is exact: the
   moment a document contains ordered implementation steps, function names, or code, it has
   crossed into work the executing agent owns. Acceptance criteria, contracts and invariants
   are in bounds. Task breakdowns are not.

3. **No document that will not be reopened during development.** Every file must earn its place
   by being consulted while coding. A document read once and archived should be folded into
   another or cut. This is the inclusion test for every conditional file.

## What this skill delivers

Written flat to `docs/`, level with impeccable's root `PRODUCT.md` / `DESIGN.md` — one home for
the whole project's durable truth. Nothing here is branded `ajian`; the work project stays generic.

| File | Role | Written when |
| --- | --- | --- |
| `INDEX.md` | Entry point: what each doc owns, what to read for what | always |
| `PRD.md` | Why, users, jobs-to-be-done, v1 scope, non-goals, feature list | always |
| `ARCHITECTURE.md` | Stack + versions, structure, boundaries, API style, NFRs | always |
| `CONVENTIONS.md` | Reuse inventory, naming, style, test-file naming | always |
| `DECISIONS.md` | ADR ledger — status line per decision, pointing at `decisions/NNNN-*.md` | always |
| `decisions/NNNN-<slug>.md` | One ADR per file — the *why*, attached one at a time | per decision |
| `QUALITY.md` | Testing approach, Definition of Done, CI gates | always |
| `ROADMAP.md` | Ordered features, dependencies, depth status per line | always |
| `work-orders/NN-<slug>.md` | Executable brief (or detail) for one feature | per feature |
| `DATA-MODEL.md` | Entities, relationships, invariants, lifecycles | the project has a data layer |
| `DESIGN-SYSTEM.md` | Tokens, components, states, accessibility baseline | the project has an interface |
| `GLOSSARY.md` | Domain term → definition (CONTEXT.md format, with `_Avoid_`) | the domain has ambiguous terms |

Every file has a template in `assets/`. **Read the template immediately before writing its
file** — not earlier, not from memory.

**ADRs are split** (an ajian seam): one file per decision under `decisions/`, plus a thin
`DECISIONS.md` ledger that lists each ADR's number, title, and status. This keeps a work order
able to attach a single ADR without pulling the whole log into context. Both have templates in
`assets/` (`adr-template.md` and `DECISIONS-ledger-template.md`).

`QUALITY.md` carries the Definition of Done and the CI gates rather than a separate
test-strategy file, because DoD and gates are what an executing agent actually opens; testing
philosophy alone is not.

## The gate protocol

A gate is a full stop that waits for the user. Every gate in this skill is written as this block —
the shape is fixed, and a stop that omits it is not a gate:

```
GATE — <name of the gate>
Done:     <what you actually did, one line>
Evidence: <real command output, or the path of a committed artifact — not your own assessment>
Decide:   <what the user has to decide, phrased as a question they can answer>
Risk:     <what breaks if this is wrong and you proceed anyway>
```

Then **stop and wait for a reply.** Never continue on your own reading of what the user probably
wants.

`Evidence` is the load-bearing line. A gate is cleared on facts a reader can check, never on your
judgement that things look fine — if you cannot produce evidence, you have not reached the gate.
`Risk` is written for a user who cannot audit your work; it is what lets them decide anyway.

This block is identical in every ajian skill. If its shape changes, it changes in all of them.

## Pipeline

```
0  Preflight & modes         entry: cold start / distil / resumed
                             codebase: greenfield / brownfield
1  Orient                    shape of the run, the two gates, the modes → wait for go-ahead
2  Interrogate               grill engine, theme by theme, until nothing open would change a doc
3  Write & wire              all applicable docs + INDEX + agent entry point
                             → self-review → GATE 1 → commit
4  Roadmap                   ordered feature list → GATE 2 → write ROADMAP.md
5  Work orders               every feature at brief depth; promote #1 to detail
6  Hand off                  how to run it, and how to deepen the next feature
```

---

## Step 0 — Preflight & modes

Two independent questions. Answer both before step 1; infer from context where you can, and ask
one short question where you cannot.

### Entry mode — what the conversation has already produced

- **Cold start** — the conversation above holds no design material. There is nothing to distil,
  so step 2 is the whole interrogation, from the problem statement up. **This is the normal way
  in, not a degraded one** — being invoked as the first message of a session is expected.
- **Distil** — a design discussion already ran above. Step 2 opens by replaying what it settled
  and interrogates only what it left open.
- **Resumed** — `docs/ROADMAP.md` exists. Skip to [Resumed runs](#resumed-runs).

Do not force a run into *distil* because a few requirements were mentioned in passing. Material
counts as settled only if the user actually decided it, not if it merely came up.

### Codebase mode — what the repository already contains

- **Greenfield** — no code. You help the user *choose* the stack. `ARCHITECTURE.md` says
  *scaffold using this stack*, and roadmap item #1 is a **walking skeleton**: project setup,
  auth if the product has any, and one thin end-to-end slice. `CONVENTIONS.md` gets only its
  naming and DoD sections up front; the reuse inventory is filled in after the skeleton exists,
  because inventing one before there is code produces conventions the agent will follow into a
  shape nobody chose.
- **Brownfield** — an existing stack. **Scan the repo before step 2**: the build and lint
  config, the test setup, and the two or three largest modules the roadmap will touch. Scan
  until every reuse-inventory row cites a real path. Record the stack **verbatim** — versions
  from the manifest, not from memory. `ARCHITECTURE.md` says *extend the existing codebase, do
  not scaffold.* Then have the user correct your draft: an inferred convention is worse than a
  missing one, because the agent will obey it.

## Step 1 — Orient

Say three things once, then stop and wait for a go-ahead:

1. **The shape of the run** — the steps above, and where it ends: `docs/` committed,
   one work order per roadmap line. Say plainly what it does **not** do: write code, write
   implementation steps, or estimate timelines.
2. **Where they decide** — twice, and both are hard stops: on the written foundation before the
   roadmap is built, and on the roadmap order before the work orders are written.
3. **Which modes** this run is in — entry and codebase — and what each changes. On a *cold
   start*, say plainly that the next step is an extended interrogation and roughly how many
   themes it covers, so the user knows what they are agreeing to.

A user who actually wanted a single feature spec, or who is not yet sure of the direction,
finds out here for the price of one message instead of after a long interrogation.

## Step 2 — Interrogate the foundation

This is the highest-leverage part of the run, and the only part that cannot be recovered later.

**Run it on the grill engine** — read [references/grill-engine.md](references/grill-engine.md).
In short: the interrogation is the frontier/rounds mechanic **railed by the six themes below**,
so nothing is silently skipped, **bounded to one theme at a time** so the user is never
overwhelmed, with **a recommended answer on every question**. Work one theme to a close, ask its
open frontier as a single numbered round, wait, then move to the next theme. This is grill-1 —
the macro pass, where the decisions are the user's to make.

**On a distil run, open by replaying.** Before asking anything, put back what the conversation
above already settled, theme by theme, and have the user confirm it. What survives that pass is
answered; interrogate only the rest. Restating a decision the user made twenty messages ago
costs one message; inheriting a misremembered one costs the whole blueprint.

Work the themes in dependency order — they are the rails the grill engine runs on — and move on
only when a theme is decided enough to govern every later feature:

- **Problem & product** — what is broken today, who has it, what changes for them.
- **Users & scope** — primary users, top jobs-to-be-done, the v1 boundary, and **project-level
  non-goals**. Push hard here: non-goals are the most skipped and highest-leverage section.
- **The stack** — *greenfield:* propose 2–3 defensible options with tradeoffs and let the user
  choose; never assume silently. *brownfield:* confirm what the scan found, and fill the gaps
  the scan could not answer.
- **Domain entities** — in business language ("a booking belongs to one customer and has many
  rooms"), not tables or column types. Skip the theme entirely if there is no data layer.
- **Conventions & quality** — reuse targets, naming, what "done" means, what must pass in CI.
- **Interface direction** — only if there is a UI: tone and density, the key screens, the states
  that always get forgotten (empty, loading, error, success), the accessibility baseline.

**Stopping rule:** stop when you have no open questions left that would change a document —
not when you have enough to start writing. A question you skip here becomes an assumption the
agent inherits.

When a question genuinely cannot be answered yet, do not soften it into a placeholder. Record
it as an **open ADR** — a `decisions/NNNN-<slug>.md` file with `Status: open` and a row in the
`DECISIONS.md` ledger — stating what it blocks.

## Step 3 — Write the blueprint, then wire it in

Write every applicable document at once, each from its `assets/` template, skipping the
conditional files that fail the inclusion test in rule 3.

**Never leave a placeholder.** No "TBD", no "to be determined", no vague requirement. An
unknown is an open ADR; a placeholder is a lie the agent will read as fact.

### Wire the entry point

A blueprint nothing loads is worth nothing, and this skill has no session hook to lean on.
So make it discoverable by the tools that will actually read it:

- Write `INDEX.md` from its template — it is the front door and the routing table.
- Add a pointer block to whichever of `AGENTS.md`, `CLAUDE.md`, `.cursor/rules/` or the
  project README the repo already uses (create `AGENTS.md` if none exists):

  ```markdown
  ## Project blueprint

  Before writing code, read `docs/INDEX.md`. It routes to the stack and structure
  (`ARCHITECTURE.md`), the reuse inventory and naming rules (`CONVENTIONS.md`), and the
  Definition of Done and CI gates (`QUALITY.md`). Decisions recorded in `DECISIONS.md` are
  settled — raise a new ADR rather than re-deciding them.
  ```

### Self-review — run it yourself, fix inline

1. **Placeholder scan** — any "TBD", "TODO", or requirement too vague to check? Fix or convert
   to an open ADR.
2. **Charter check** — each document stays inside its charter in
   [references/doc-charters.md](references/doc-charters.md). Move leaked content to its home.
3. **Cross-document consistency** — the stack in `ARCHITECTURE.md` matches its ADR in
   `DECISIONS.md`; entities named in `PRD.md` exist in `DATA-MODEL.md`; test-file naming
   (`CONVENTIONS.md`) does not contradict the gates (`QUALITY.md`).
4. **Traceability** — every feature in the `PRD.md` list appears in `ROADMAP.md`; every entity,
   screen or reuse target an anchor names exists in the document that owns it.
5. **Depth discipline** — no ordered implementation steps, function signatures, or code
   anywhere; no feature detailed except the next one.
6. **Stranger test** — could a competent agent that did not witness this conversation start
   work from these files without asking a question? If not, name what is missing and fix it.

### Gate 1

Commit first — the `Evidence` line has to point at something that exists in git — then stop:

```
GATE — Foundation
Done:     Wrote and committed the foundation documents; wired the pointer into <AGENTS.md|CLAUDE.md>
Evidence: <git commit hash and the file list it touched, from `git show --stat`>
Decide:   Review the stack in ARCHITECTURE, the entities in DATA-MODEL, and the non-goals in
          PRD — those are the hardest to correct later. What should change before I build
          the roadmap?
Risk:     Every work order, plan, and build downstream is written against these files. A wrong
          stack or a missing non-goal here is not a document defect — it is code that gets
          written and later thrown away.
```

Wait. Apply the changes, re-run the self-review, and only then continue.

## Step 4 — Order the roadmap

**The roadmap is the backbone of everything downstream** — every work order, plan, and build
session is one roadmap line. Get the sizing wrong here and every later stage inherits the error,
so this step earns its own rails: read [references/roadmap-sizing.md](references/roadmap-sizing.md)
before proposing the list.

Propose an ordered feature list. Each item must be a slice that produces working, verifiable
software on its own — not a layer ("build the database", "build the API") but a capability.
Greenfield opens with the walking skeleton.

Keep the granularity coarse: **one roadmap line is one work order is one build session.** Record
build order, dependencies, and the reason for the order (dependency, risk-first, thinnest slice
first).

**Gate 2 is a mini-interrogation, not a rubber stamp.** Put every line through the three sizing
tests from `roadmap-sizing.md` — *sizing* (one build session), *slice* (vertical and demoable),
*order* (dependencies respected, risk and the thinnest slice first) — and split or merge any line
that fails, out loud, before you present it. Then present the list as a gate and wait:

```
GATE — Roadmap
Done:     Ordered <N> feature lines and ran each through the sizing / slice / order tests
Evidence: <the ordered list, and for each line the test result — including every line you
          split or merged, and why>
Decide:   Is this the order you want built, and is any line still too big for one session?
Risk:     One roadmap line is one work order is one build session. A line that is too big
          produces a plan that stalls halfway through the build; a wrong order means building
          against a dependency that does not exist yet. Both are found late and cost the line.
```

Once approved, write `ROADMAP.md` from its template.

## Step 5 — Write the work orders

One `docs/work-orders/NN-<slug>.md` per roadmap line, from
`assets/work-order-template.md`.

Every work order starts at **`Depth: brief`**: intent, in-scope, non-goals, observable
acceptance criteria, anchors, dependencies, and open questions. Then promote **only feature #1**
to `Depth: detailed`, which adds flows and scenarios, edge cases and error behaviour, and the
contracts the feature touches — and still no implementation steps.

Anchors name the entities, screens, states and reuse targets that apply, **by name, from the
blueprint**. Link the documents; never copy their content — every copy is where drift starts.
That is also why a work order never restates the stack.

Commit the roadmap and the work orders.

## Step 6 — Hand off

The foundation is set. From here the ajian pipeline takes each roadmap line, in order, through:
`grill → (design if UI) → plan → build → review`. Tell the user plainly:

1. The blueprint is committed; roadmap line #1 is already at `Depth: detailed`.
2. The next move is **`/ajian-grill 01`** — it recons the real code (little exists yet on a
   greenfield first line) and sharpens the work order to buildable.
3. When a work order merges, its line in `ROADMAP.md` gets ticked (`ajian-review` does this).
4. `/ajian-map` reads project state at any time and says which skill comes next.

Do not deepen later features here — that is `ajian-grill`'s job, done against real code one line
at a time.

**→ Next: `/ajian-grill 01`** (or `/ajian-map` if unsure).

## Resumed runs

`docs/ROADMAP.md` exists. The job is to keep the blueprint true and prepare the next
feature — not to regenerate anything.

1. **Reconcile with reality.** Read the code that shipped since the last run. Update the reuse
   inventory in `CONVENTIONS.md` from what now exists, and correct any document the code has
   overtaken. Record what changed as a new ADR when a decision actually changed.
2. **Extend, never regenerate, `ROADMAP.md`.** Existing checkboxes are the only record of what
   shipped. Add or reorder lines; do not rewrite the file.
3. **Promote the next feature** from `Depth: brief` to `Depth: detailed`, interrogating only the open
   questions that work order already lists.
4. Re-run the self-review over everything you touched, then commit.

---

## Delivery checklist

- `docs/` committed; conditional files correctly born or correctly skipped.
- `INDEX.md` written and referenced from the repo's agent entry point.
- No placeholders anywhere; unknowns are open ADRs.
- No implementation steps, task breakdowns, code, or time estimates in any file.
- Stack recorded once, in `ARCHITECTURE.md` plus its ADR — never transcribed into a work order.
- Roadmap ordered and rationalised; greenfield opens with a walking skeleton.
- Exactly one work order per roadmap line; exactly one at `Depth: detailed`.
- Both gates were real stops that waited for the user.
