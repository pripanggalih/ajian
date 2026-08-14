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

- **Every checkbox in `docs/plans/NN-<slug>.md` is ticked.** Unticked boxes mean the build is
  unfinished; `/ajian-build NN` resumes from the first one. Reviewing a half-built branch reports
  missing work as defects.
- **The branch is committed and green.** Confirm from `git status` and a test run, not from the
  build's report — Step 4 of `ajian-build` exists because that report is not evidence.
- **The detailed work order `docs/work-orders/NN-<slug>.md` exists** — it is the Spec axis's source.
  Without it there is no Spec axis, only half a review.

### When a precondition fails

**Verify every precondition from the artifacts on disk, never from what the conversation seems to
say happened.** The conversation is the least reliable record in this pipeline; a file, a `Depth:`
field, a checkbox, and `git log` are not.

When one fails, do not proceed and do not quietly fix it. Say where the user actually is in plain
language, name the one skill that owns the gap, and offer to run **that one step**:

> "<what is missing, in a sentence a non-developer follows>. That is `<skill>`'s job — it <what it
> does, in plain words>. Run it now?"

Then wait. **One step, never a chain.** Offering to run the next four skills is how a gate gets
skipped while sounding helpful: it trades the user's whole pipeline for a single yes. Running the
missing step without asking is the same failure with the asking removed.

## Language

Write to the user in the user's own language. This file is English because it is agent-facing —
that is not an instruction to answer in English, and a user who wrote to you in Indonesian, Spanish,
or Japanese gets their gates in that language.

Every quoted line here — gate text, refusal, offer — is **meaning to convey, not a string to copy**.
Translate it. Keep the `GATE / Done / Evidence / Decide / Risk` field labels as they are, so the
shape stays recognisable in any language. A gate the user has to decode is a gate they rubber-stamp,
which is the same as not having one.

## The gate protocol

A gate is a full stop that waits for the user. Every gate in this skill carries these five fields,
in this order, and a stop that omits them is not a gate:

```
GATE — <name of the gate>

**Done**
- <what you actually did>

**Evidence**
- <one checkable fact per bullet — real command output, or the path of a committed artifact,
  never your own assessment>

**Decide**
- <what the user has to decide, phrased as a question they can answer>

**Risk**
- <what breaks if this is wrong and you proceed anyway>
```

The fence above only delimits the template. **What you emit is plain markdown, never a code
block** — one fact per bullet, short lines, no wrapped paragraph. A gate the user cannot scan in
one pass is a gate the user approves without reading, which is the failure this protocol exists
to prevent.

Then **stop and wait for a reply.** Never continue on your own reading of what the user probably
wants.

`Evidence` is the load-bearing line. A gate is cleared on facts a reader can check, never on your
judgement that things look fine — if you cannot produce evidence, you have not reached the gate.
`Risk` is written for a user who cannot audit your work; it is what lets them decide anyway.

This block is identical in every ajian skill. If its shape changes, it changes in all of them.

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

```
GATE — Review findings

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
```

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

**The next work order is not `NN+1`.** Build order is row order, and numbers are permanent
identities that may run out of sequence after an insertion — so read the next number off the
**topmost unticked row** of `docs/ROADMAP.md` rather than incrementing. Guessing `NN+1` sends the
next pass at whatever feature happens to hold that number, which after any insertion is the wrong
one.

**→ Next: `/ajian-grill <number of the topmost unticked row>`** (or `/ajian-map`, which reads it
for you).
