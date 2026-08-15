---
name: ajian-review
description: >-
  Use to review a finished build and integrate the branch. Triggers include "/ajian-review NN",
  "review this branch", "review work order N", "finish and merge". Runs a two-axis code review
  (Standards — repo conventions + Fowler smells; Spec — faithful to the work order) in parallel
  sub-agents, responds to the findings, then finishes the branch: tick the ROADMAP line, merge or
  PR. Assumes ajian-build left a green, committed branch.
---

<!-- Original ajian wiring around three vendored sources: mattpocock/skills `code-review` (the
     two-axis review, in references/two-axis-review.md), and superpowers `receiving-code-review`
     and `finishing-a-development-branch` (references/). All MIT. See NOTICE.md. -->

# Ajian · Review

Judge the build on two independent axes, respond like an engineer rather than a people-pleaser, then
integrate the branch and tick the roadmap. Nothing here re-runs the build.

## Preconditions

One command answers all three. Run it once, then trust the output for the rest of the session:

```bash
grep -c '^- \[ \]' docs/plans/NN-*.md   # substitute the real NN; 0 means the build is finished
git status --short
ls docs/work-orders/NN-*.md
```

- Unticked boxes remain → the build is unfinished; `/ajian-build NN` resumes from the first one.
  Reviewing a half-built branch reports missing work as defects.
- The tree is dirty, or the suite has not been run on this branch → confirm green from a test run,
  never from the build's report.
- No work order → no Spec axis, only half a review.

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

## Pipeline

```
0  Pin            fixed point = the branch's merge-base with its base branch
1  Two-axis       parallel sub-agents: Standards + Spec → reported side by side, not reranked
2  Respond        receiving-code-review discipline → one fix wave (if needed) → re-verify
3  Tick           mark the ROADMAP line done
4  Finish         finishing-a-development-branch: verify tests, present merge options, integrate
5  Hand off       → next work order
```

---

## Step 1 — Two-axis review

Run the review per [references/two-axis-review.md](references/two-axis-review.md). In short:

- **Fixed point:** the commit the branch forked from — `git merge-base <base> HEAD`. Confirm it
  resolves and the diff is non-empty before spawning sub-agents.
- **Scope out the built surface:** on a UI work order, read the work order's `## Built surface`
  inventory. Those files came from impeccable in `ajian-design`, not from this build — exclude them
  from the Standards axis (review only the wiring added to them) and tell the Spec axis they
  already existed at the fixed point. Report which paths were scoped out.
- **Standards axis:** does the diff follow `docs/CONVENTIONS.md` and `docs/QUALITY.md`, plus the
  Fowler smell baseline? (Documented repo standards override the baseline; smells are judgement
  calls; skip what tooling enforces.)
- **Spec axis:** does the diff faithfully implement the work order `docs/work-orders/NN-<slug>.md`
  — every acceptance criterion met, nothing built that wasn't asked for, nothing implemented wrong?

Spawn both as parallel sub-agents so they don't pollute each other's context. Present the two
reports under `## Standards` and `## Spec`, side by side — **do not merge or rerank** them; the
separation is the point (code can pass one axis and fail the other). Close the presentation with
the gate:

**GATE — Review findings**

**Done**
- Ran both axes against the diff from <merge-base hash> to HEAD

**Evidence**
- <files and line count reviewed>
- <paths scoped out of Standards as impeccable's built surface>
- <N> Standards findings, <M> Spec findings, listed above

**Decide**
- Which findings should I fix, and which do you want to push back on?

**Risk**
- Findings are input to evaluate, not orders
- Fixing a wrong one changes working code for a reviewer's preference; ignoring a real one ships it
- I have marked which ones I think are which — tell me where I am wrong

## Step 2 — Respond to the findings

Apply [references/receiving-code-review.md](references/receiving-code-review.md) — the findings are
input to evaluate, not orders to obey. Verify each against the codebase before acting; push back
with technical reasoning where a finding is wrong for this stack; apply YAGNI to "do it properly"
suggestions. No performative agreement, no gratitude — state the fix or the reasoned pushback.

For the findings that stand, dispatch **one fix wave** — a single subagent carrying the complete
list of confirmed findings, never one fixer per finding (each would rebuild context and re-run the
suite). Fix in order — blocking/security first, then simple, then complex — testing each. Then
**re-verify**: run the full suite and build, read the output, confirm green. Escalate to the user
only a finding that is real, load-bearing, and collides with the work order or plan.

## Step 3 — Tick the roadmap

Once the review is clean, tick this work order's **row** in `docs/ROADMAP.md` — find it by its
number in the `#` column, not by its position, since rows get reordered and inserted (its checkbox
is the project-level record of what shipped). Record anything that changed a project-wide decision as a new
`docs/decisions/NNNN-*.md` with a ledger row — not buried in a commit message.

## Step 4 — Finish the branch

Run [references/finishing-a-development-branch.md](references/finishing-a-development-branch.md):
verify the full suite on the tree you're about to integrate, detect the environment, present the
merge / PR / keep options exactly as written, and execute the user's choice. Integration is the
user's decision — present the menu and wait. Clean up the worktree per that skill's rules.

## Step 5 — Hand off

The work order is merged and its roadmap row ticked. The next work order starts its own pass at
`ajian-grill`.

**The next work order is not `NN+1`.** Build order is row order; numbers are permanent identities
that run out of sequence after an insertion. Read the next number off the **topmost unticked row** of
`docs/ROADMAP.md` rather than incrementing.

**→ Next: `/ajian-grill <number of the topmost unticked row>`** (or `/ajian-map`, which reads it
for you).
