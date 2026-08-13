---
name: ajian-review
description: >-
  Use to review a finished build and integrate the branch. This is the last stage of each ajian
  work order: a two-axis code review (Standards — repo conventions + Fowler smells; Spec — faithful
  to the work order) run in parallel sub-agents, then the discipline for responding to findings,
  then finishing the branch (tick the ROADMAP line, merge or PR). Triggers include "/ajian-review
  NN", "review this branch", "review work order N", "finish and merge". Assumes ajian-build left a
  green, committed branch. When the review is clean and merged, the roadmap line is ticked and the
  next work order begins.
---

<!-- Original ajian wiring around three vendored sources: mattpocock/skills `code-review` (the
     two-axis review, in references/two-axis-review.md), and superpowers `receiving-code-review`
     and `finishing-a-development-branch` (references/). All MIT. See NOTICE.md. -->

# Ajian · Review

Judge the build on two independent axes, respond to what they find like an engineer rather than a
people-pleaser, then integrate the branch and tick the roadmap. Nothing here re-runs the build; it
verifies, corrects, and finishes.

## Preconditions

- `ajian-build NN` left a green, committed branch (its plan's checkboxes all ticked).
- The detailed work order `docs/work-orders/NN-<slug>.md` exists — it is the Spec axis's source.

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
- **Standards axis:** does the diff follow `docs/CONVENTIONS.md` and `docs/QUALITY.md`, plus the
  Fowler smell baseline? (Documented repo standards override the baseline; smells are judgement
  calls; skip what tooling enforces.)
- **Spec axis:** does the diff faithfully implement the work order `docs/work-orders/NN-<slug>.md`
  — every acceptance criterion met, nothing built that wasn't asked for, nothing implemented wrong?

Spawn both as parallel sub-agents so they don't pollute each other's context. Present the two
reports under `## Standards` and `## Spec`, side by side — **do not merge or rerank** them; the
separation is the point (code can pass one axis and fail the other).

## Step 2 — Respond to the findings

Apply [references/receiving-code-review.md](references/receiving-code-review.md) — the findings are
input to evaluate, not orders to obey. Verify each against the codebase before acting; push back
with technical reasoning where a finding is wrong for this stack; apply YAGNI to "do it properly"
suggestions. No performative agreement, no gratitude — state the fix or the reasoned pushback.

For the findings that stand, dispatch **one fix wave** — a single subagent carrying the complete
list of confirmed findings, not one fixer per finding (per-finding fixers each rebuild context and
re-run suites; a real session's final-review fix wave cost more than all its tasks combined). Fix
in order — blocking/security first, then simple, then complex — testing each. Then **re-verify**:
apply the verification discipline (run the full suite and build, read the output, confirm green)
before calling it clean. Escalate to the user only a finding that is real, load-bearing, and
collides with the work order or plan.

## Step 3 — Tick the roadmap

Once the review is clean, mark this work order's line done in `docs/ROADMAP.md` (its checkbox is the
project-level record of what shipped). Record anything that changed a project-wide decision as a new
`docs/decisions/NNNN-*.md` with a ledger row — not buried in a commit message.

## Step 4 — Finish the branch

Run [references/finishing-a-development-branch.md](references/finishing-a-development-branch.md):
verify the full suite on the tree you're about to integrate, detect the environment, present the
merge / PR / keep options exactly as written, and execute the user's choice. Integration is the
user's decision — present the menu and wait. Clean up the worktree per that skill's rules.

## Step 5 — Hand off

The work order is merged and its roadmap line ticked. The next work order starts its own pass at
`ajian-grill`. `ajian-map` will confirm which line is next.

**→ Next: `/ajian-grill NN+1`** for the next roadmap line (or `/ajian-map` to confirm where you are).
