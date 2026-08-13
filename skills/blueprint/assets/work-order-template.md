<!--
  work-order-template.md — one file per roadmap line, saved as
  docs/work-orders/NN-<slug>.md. This is the unit a coding agent is handed.

  RULES:
  - Set `Depth:` honestly. Everything starts at `brief`. Only the next unbuilt feature is
    promoted to `detailed`, and only against code that actually exists.
  - The "Read first" list names ONLY the documents relevant to THIS feature. Delete the rest.
  - LINK blueprint documents; never copy their content, and never restate the stack.
  - Anchors name entities, screens, states and reuse targets BY NAME, from the blueprint.
  - Acceptance criteria must be observable — something you can demonstrate or assert.
  - Open questions are the point of a brief. Leave them open; do not invent answers.
  - Never write ordered implementation steps, function names, or code. Not even at `detailed`.
  - Delete this comment block and every unused section before saving.
-->

# <NN> — <Feature>

**Depth:** brief <!-- brief | detailed | superseded by NN -->
**Roadmap row:** <this work order's number> · **Depends on:** <numbers, or none> · **Interface:** <yes | no>

<!-- `superseded by NN` is set only on a resumed run, when an inserted feature covers
     substantially all of this one. The file stays — it may already carry a plan, a report, or
     commits — and its ROADMAP row is struck through rather than removed. Never delete a work
     order; `superseded` is revertible and deletion is not. -->


## Read first
<Only what this feature needs. An agent that reads five irrelevant documents anchors on the
wrong things.>

- `../ARCHITECTURE.md` — stack, structure, boundaries
- `../CONVENTIONS.md` — reuse inventory and naming
- `../QUALITY.md` — Definition of Done and gates
- `../DATA-MODEL.md` — <!-- keep only if this feature touches data -->
- `../DESIGN-SYSTEM.md` — <!-- keep only if this feature has UI -->
- `../decisions/<NNNN>-<slug>.md` — <!-- keep only if a specific ADR governs this feature; attach the one file, not the whole ledger -->

## Intent
<1–3 sentences from the PRD feature list: the problem this solves and who benefits. Why, not
what.>

## In scope
- <capability this feature delivers>

## Non-goals
- <what this feature deliberately does not do — and, where useful, which line covers it later>

## Acceptance criteria
<Observable and checkable. Each one is something you can demonstrate or assert. These are what
"done" is measured against, together with QUALITY.md.>

- [ ] <criterion>
- [ ] <criterion>

## Anchors
<By name, from the blueprint. Never re-described here.>

- **Entities:** <names from DATA-MODEL.md this feature reads or writes> <!-- drop if none -->
- **Screens & states:** <screens, and which global states from DESIGN-SYSTEM.md apply> <!-- drop if no UI -->
- **Reuse:** <inventory entries from CONVENTIONS.md to build on rather than re-create>
- **Constraints:** <the NFR budgets from ARCHITECTURE.md that apply here>

## Built surface
<!-- drop if no UI. Born at `Status: not yet designed`. ajian-design stamps `handed to impeccable`
     BEFORE it invokes impeccable, and `recorded` once the inventory below is real.

     The Status line is what makes an interrupted handoff visible. Control passes to impeccable and
     may not come back to ajian-design, so a section written only afterwards is a section that
     silently stays empty — and an empty inventory is how ajian-plan ends up planning screens that
     already exist. ajian-plan refuses a UI work order unless Status is `recorded`; ajian-review
     reads the file list so it does not audit impeccable's craft as if ajian had written it. -->

- **Status:** <not yet designed | handed to impeccable | recorded>
- **Branch:** <the branch the surface is committed on — the same one ajian-build will extend>
- **Files:** <paths, one per line>
- **Wiring left to the build:** <what is still stubbed: data, state, routing, tests>

## Open questions
<The gaps left on purpose. Resolve them when this work order is promoted to `detailed`, not
before. Anything that turns out to be project-wide becomes an ADR instead.>

- <known-unknown>
- <known-unknown>

<!-- ======================================================================
     EVERYTHING BELOW EXISTS ONLY AT `Depth: detailed`.
     Delete the whole block while this work order is still a brief.
     ====================================================================== -->

## Flows
<The paths through this feature, happy and unhappy. What the user or caller does, and what must
result. Behaviour, not implementation.>

### <Flow name>
1. <trigger / input>
2. <what must happen>
3. <observable outcome>

**When it goes wrong:** <what the system must do — which of the global error states applies.>

## Edge cases
- <case> → <required behaviour>
- <case> → <required behaviour>

## Contracts
<The interfaces this feature exposes or consumes, at the level of shape and meaning — inputs,
outputs, failure modes. Not signatures, not code.>

- **<interface>** — takes <what>, returns <what>, fails when <condition> with <which error shape>

## Data effects
<Which entities are created, read, updated or invalidated, and which invariants from
DATA-MODEL.md this feature must uphold. Drop if the feature touches no data.>

- **<Entity>:** <created | read | updated | deleted> — <under what condition>
- **Upholds:** <invariant from DATA-MODEL.md>

## Resolved questions
<Each open question above, with its answer and where the answer lives now. Anything that
changed a project-wide decision must also appear as an ADR in DECISIONS.md.>

- <question> → <answer> <!-- → DECISIONS.md ADR-NNN, if it was project-wide -->
