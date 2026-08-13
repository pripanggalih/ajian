---
name: ajian-plan
description: >-
  Use to turn one detailed work order into a bite-sized implementation plan, before touching code.
  This is the plan stage of the ajian pipeline: it reads a `Depth: detailed` work order and the
  blueprint documents its anchors name, and writes the plan the executor follows. Triggers include
  "/ajian-plan NN", "plan work order N", "write the implementation plan". Assumes the work order is
  already detailed (run /ajian-grill NN first) and, if it has UI, designed (/ajian-design NN). The
  plan's checkboxes become the build ledger. It stops at the plan — ajian-build executes it.
---

<!-- Adapted from superpowers `writing-plans` (MIT, Jesse Vincent), copied nearly verbatim. The
     ajian seams: the input is a detailed work order (not a loose spec); plans are saved to
     docs/plans/NN-<slug>.md and committed (the checkboxes are ajian-build's ledger); the
     execution handoff points at ajian-build, not superpowers' subagent-driven-development; and a
     UI work order may arrive with its surface already built by impeccable, so the plan wires
     existing code up rather than planning it from zero (the "Existing surface" section below —
     original ajian, no upstream counterpart). See NOTICE.md for attribution. -->

# Ajian · Plan

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using ajian-plan (writing-plans) to create the implementation plan."

**Read first:** the detailed work order `docs/work-orders/NN-<slug>.md` — its flows, contracts,
acceptance criteria, and anchors are the spec — plus the blueprint documents its "Read first" list
names (`ARCHITECTURE.md`, `CONVENTIONS.md`, `QUALITY.md`, and any it points to). The plan owns the
*how*; the work order owns the *what*. Never restate the stack — link `ARCHITECTURE.md`.

**Context:** If the build will run in an isolated worktree (optional parallel work orders), it is
created by `ajian-build` at execution time — not here.

**Save plans to:** `docs/plans/NN-<slug>.md`, matching the work order number. **Commit the plan** —
its `- [ ]` checkboxes are the ledger `ajian-build` ticks as it goes, so it must be in git.

## Existing surface — plan the wiring, not the screens

If the work order has UI, `ajian-design` ran before you and impeccable **already built the
surface**. Read the work order's `## Built surface` section and `DESIGN.md` before writing a single
task, and open the files it lists. They are real code in the tree, on the branch the build will
extend.

Plan around them:

- **Never write a task that creates a screen the inventory already lists.** The executor will
  either overwrite impeccable's work or stall on a file the plan swears does not exist. Both are
  worse than no plan.
- **Plan what impeccable left stubbed** — the work order's "Wiring left to the build" line: data
  fetching, state, routing, validation, error paths, tests. That is the build's actual job on a UI
  work order.
- **Open the plan with an `## Existing surface` block** listing those paths verbatim under the
  heading *do not recreate*, so the executor reads it before its first task. Say which files it may
  modify to wire things up and which are impeccable's to leave alone.
- **Visual craft is not yours to re-specify.** Do not plan tokens, spacing, or layout changes — the
  direction passed impeccable's gate. If the surface is genuinely wrong for the work order, that is
  a `/ajian-design NN` problem, not a plan task.

**A UI work order is only plannable at `Status: recorded`.** Read the `## Built surface` Status
before anything else and treat it as a gate, not a hint:

- **`recorded`** — the inventory is real. Plan around it.
- **`not yet designed`** — the surface does not exist yet. Stop and send it to `/ajian-design NN`.
  Planning a surface that is about to be generated wastes both.
- **`handed to impeccable`** — `ajian-design` reached the handoff and never came back to record what
  was built. Something may well be in the tree, but nothing here knows what. **Do not infer the
  inventory from `git diff`** — the guess goes wrong precisely on the files both sides touch, which
  are the expensive ones. Stop and send it back to `/ajian-design NN`; it resumes at the recording
  step rather than rebuilding.

This is the one check that catches an interrupted design handoff. Skipping it is how a plan ends up
containing tasks to create screens that already exist.

## Scope Check

One work order is one build session — the roadmap already sized it (see the sizing rails in
`ajian-blueprint`). So the scope check here is a **size guard**, and it is the fix for the classic
"the plan got too big and the model stalled halfway" failure: if the plan is about to run past
roughly a dozen tasks, or gets too long to hold in one context, the **work order (or its roadmap
line) was mis-sized** — stop, say so, and send it back to `ajian-grill` / the roadmap to split
before you keep writing. Do not paper over a too-big line with a giant plan.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Task Right-Sizing

A task is the smallest unit that carries its own test cycle and is worth a
fresh reviewer's gate. When drawing task boundaries: fold setup,
configuration, scaffolding, and documentation steps into the task whose
deliverable needs them; split only where a reviewer could meaningfully
reject one task while approving its neighbor. Each task ends with an
independently testable deliverable.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `ajian-build` to implement this plan. It runs
> the whole plan in one fresh subagent, ticking these checkboxes as its ledger and committing per
> task. Steps use checkbox (`- [ ]`) syntax for tracking. Work order: `docs/work-orders/NN-<slug>.md`.

**Goal:** [One sentence describing what this builds — from the work order's Intent]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries — link ARCHITECTURE.md; do not transcribe versions]

## Global Constraints

[The project-wide requirements that bind every task — version floors, dependency limits,
naming and copy rules, platform requirements, and the Definition of Done — one line each,
with exact values copied verbatim from the work order, `ARCHITECTURE.md`, `CONVENTIONS.md`,
and `QUALITY.md`. Every task's requirements implicitly include this section.]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Interfaces:**
- Consumes: [what this task uses from earlier tasks — exact signatures]
- Produces: [what later tasks rely on — exact function names, parameter
  and return types. A task's implementer sees only their own task; this
  block is how they learn the names and types neighboring tasks use.]

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After writing the plan, **commit it** (`docs/plans/NN-<slug>.md`) — the checkboxes are the ledger,
so the plan lives in git before execution starts. Then stop for the plan gate:

> "Plan complete, committed to `docs/plans/NN-<slug>.md`. Review it before I build — this is the
> last stop before code. When you approve, `/ajian-build NN` runs the whole plan in one fresh
> subagent, ticking these checkboxes and committing per task, with the code review saved for the
> end."

Wait for approval; apply any changes and re-commit. There is one executor — `ajian-build` — by
design: one fresh subagent, the checkbox ledger, commit per task, and a single review at the end
(not a per-task review). See `ajian-build` for why.

**→ Next: `/ajian-build NN`** (or `/ajian-map` if unsure).
