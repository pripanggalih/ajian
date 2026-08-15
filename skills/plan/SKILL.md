---
name: ajian-plan
description: >-
  Use to turn one detailed work order into a bite-sized implementation plan, before touching code.
  Triggers include "/ajian-plan NN", "plan work order N", "write the implementation plan". Reads a
  `Depth: detailed` work order and writes the plan the executor follows; its checkboxes become the
  build ledger. Stops at the plan — ajian-build executes it.
---

<!-- Adapted from superpowers `writing-plans` (MIT, Jesse Vincent), copied nearly verbatim. ajian
     seams: the input is a detailed work order; plans live at docs/plans/NN-<slug>.md and are
     committed (the checkboxes are ajian-build's ledger); the handoff points at ajian-build; and
     "Existing surface" is original ajian, no upstream counterpart. See NOTICE.md. -->

# Ajian · Plan

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using ajian-plan (writing-plans) to create the implementation plan."

**Read first:** the work order `docs/work-orders/NN-<slug>.md` — its flows, contracts, acceptance
criteria, and anchors are the spec. Open a blueprint document it names only when a task actually needs
one. The plan owns the *how*; the work order owns the *what*. Never restate the stack — link
`ARCHITECTURE.md`.

**Context:** If the build will run in an isolated worktree (optional parallel work orders), it is
created by `ajian-build` at execution time — not here.

**Save plans to:** `docs/plans/NN-<slug>.md`, matching the work order number. **Commit the plan** —
its `- [ ]` checkboxes are the ledger `ajian-build` ticks as it goes, so it must be in git.

## Preconditions

One command answers all three. Run it once, then trust the output for the rest of the session:

```bash
WO=$(ls docs/work-orders/NN-*.md)          # substitute the real NN
grep -m1 '^Depth:' "$WO"
sed -n '/^## Built surface/,+4p' "$WO" | grep -m1 'Status:'   # blank on a non-UI work order
ls docs/plans/NN-* 2>/dev/null
```

- `Depth:` is not `detailed` → `/ajian-grill NN` owns that; a plan written from a brief plans the
  wrong thing.
- A UI work order whose `Status:` is not `recorded` → see the next section.
- A plan already exists → read it before writing anything; overwriting one mid-build discards the
  ledger `ajian-build` is executing against.

### When a precondition fails

Check the files on disk, not what the conversation claims happened. When one fails, stop — do not
quietly fix it. Name the gap in plain language, name the one skill that owns it, offer that one step:

> "<what is missing, in a sentence a non-developer follows>. That is `<skill>`'s job — it <what it
> does, in plain words>. Run it now?"

Then wait. One step, never a chain, and never run the missing step without asking.

## Language

Reply in the user's language — this file is English because it is agent-facing, not because the
answer must be. Quoted lines here are meaning to convey, not strings to copy: translate them, but
keep the labels `GATE / Done / Evidence / Decide / Risk` verbatim. A gate the user has to decode is
a gate they rubber-stamp.

## The gate protocol

A gate is a full stop that waits for the user. Emit it as plain markdown — never inside a code
block — carrying these five fields, in this order:

**GATE — <name of the gate>**

**Done**
- <what you actually did>

**Evidence**
- <one checkable fact per bullet — real command output, or the path of a committed artifact, never
  your own assessment>

**Decide**
- <what the user has to decide, phrased as a question they can answer>

**Risk**
- <what breaks if this is wrong and you proceed anyway>

Then stop and wait. Never continue on your own reading of what the user probably wants. `Evidence`
is load-bearing: if you cannot produce it, you have not reached the gate. `Risk` is what lets a user
who cannot audit your work decide anyway.

This block is identical in every ajian skill.

## Existing surface — plan the wiring, not the screens

On a UI work order impeccable already built the surface. The `Status:` line from the precondition
command decides what happens next:

| `Status:` | Do |
| --- | --- |
| `recorded` | Plan around the inventory — rules below |
| `not yet designed` | Stop. `/ajian-design NN` |
| `handed to impeccable` | Stop. `/ajian-design NN` resumes at the recording step. Never infer the inventory from `git diff` — the guess goes wrong on exactly the files both sides touch |

At `recorded`, read the work order's `## Built surface` and `DESIGN.md`, then:

- **Open the plan with an `## Existing surface` block** listing those paths verbatim under *do not
  recreate*, and say which files the build may modify to wire things up. Never write a task that
  creates a screen the inventory already lists.
- **Plan only what impeccable left stubbed** — the "Wiring left to the build" line: data fetching,
  state, routing, validation, error paths, tests.
- **Do not plan tokens, spacing, or layout.** A surface that is genuinely wrong for the work order is
  an `/ajian-design NN` problem, not a plan task.

## Scope Check

One work order is one build session; the roadmap already sized it. Past roughly a dozen tasks the
**work order was mis-sized** — stop, say so, send it back to `ajian-grill` to split.

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
with exact values copied verbatim from the work order. Open `CONVENTIONS.md` or `QUALITY.md`
only for a constraint the work order references but does not spell out. Every task's
requirements implicitly include this section.]

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

Commit the plan (`docs/plans/NN-<slug>.md`) — the checkboxes are the ledger, so it lives in git
before execution starts. Then emit the gate:

**GATE — Plan**

**Done**
- Wrote and committed the implementation plan for work order NN

**Evidence**
- `docs/plans/NN-<slug>.md` @ <commit hash>, <N> tasks
- Self-review — spec coverage: <what it turned up>
- Self-review — placeholder scan: <what it turned up>
- Self-review — type consistency: <what it turned up>

**Decide**
- This is the last stop before code. What should change before I build?

**Risk**
- `/ajian-build NN` runs this whole plan in one fresh subagent, committing per task without
  checking in
- Anything wrong here becomes committed code before you see it again, and the review that would
  catch it does not run until the build is finished

Wait for approval; apply changes and re-commit. There is one executor by design — `ajian-build`: one
fresh subagent, the checkbox ledger, commit per task, a single review at the end.

**→ Next: `/ajian-build NN`** (or `/ajian-map` if unsure).
