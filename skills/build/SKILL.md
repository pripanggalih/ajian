---
name: ajian-build
description: >-
  Use to execute an approved implementation plan. This is the build stage of the ajian pipeline: it
  runs the whole plan in ONE fresh subagent, tests and commits per task, and ticks the plan's
  committed checkboxes as its ledger — with the code review saved for the end (ajian-review), not
  run per task. Triggers include "/ajian-build NN", "build work order N", "execute the plan",
  "implement this". Assumes an approved plan at docs/plans/NN-<slug>.md (run /ajian-plan NN first).
  It resumes cleanly after interruption from the ticked checkboxes plus git log. It does not review
  or merge — that is ajian-review.
---

<!-- Original ajian wiring, distilled from superpowers `executing-plans`, `subagent-driven-
     development`, `using-git-worktrees`, `verification-before-completion`, and
     `test-driven-development` (all MIT, Jesse Vincent). The deliberate divergence — one executor
     for the whole plan, checkbox ledger, review-once-at-the-end — is explained in
     references/executor-and-ledger.md. See NOTICE.md. -->

# Ajian · Build

Execute one approved plan and leave a green, committed branch for review. The novelty is what this
skill does *not* do: no per-task review loop, no hidden scratch workspace. One fresh subagent runs
the whole plan; the plan's own committed checkboxes are the ledger; the single review comes after,
in `ajian-review`. Read [references/executor-and-ledger.md](references/executor-and-ledger.md) —
it is the heart of this skill.

**Announce at start:** "I'm using ajian-build to execute this plan."

## Preconditions

- **A committed plan at `docs/plans/NN-<slug>.md` with `- [ ]` task checkboxes.** No plan file, or
  a plan not in git → `/ajian-plan NN` owns that. The checkboxes are the ledger; a plan outside git
  cannot survive a compaction or an interruption, which is the whole reason it is committed.
- **The plan was approved at its gate.** Verify from git that the plan is committed, not from a
  recollection that the user said yes.
- **You are not on `main`/`master`.** Never start implementation on the default branch without the
  user's explicit consent. Say which branch you would create and ask.

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
0  Setup         isolated workspace · read plan · resume check (ticked boxes + git log)
1  Pre-flight    one-time conflict scan of the plan → one batched question, or proceed
2  Execute       dispatch ONE executor subagent for the whole plan (assets/executor-prompt.md)
                 it tests + commits + ticks checkboxes per task, continuously   [BLOCKED → stop]
3  Verify        controller confirms the branch is green — fresh evidence, no trust
4  Hand off      → review
```

---

## Step 0 — Setup and resume check

Ensure the work is isolated. Use [references/using-git-worktrees.md](references/using-git-worktrees.md)
to create or verify a workspace, or work on a feature branch if the user prefers; never build on
`main` without consent.

Then **check for resume**: read `docs/plans/NN-<slug>.md`. If some tasks are already ticked
(`- [x]`), a previous executor got partway. Trust the ledger and `git log` over any recollection —
the ticked tasks are done; work resumes at the first task with an unticked box. If every box is
unticked, this is a fresh build.

Read the plan once yourself, noting its Global Constraints and the resume point. Do not paste the
whole plan into your own context repeatedly — hand it to the executor as a file.

## Step 1 — Pre-flight conflict scan

Before dispatching, scan the plan once for internal contradictions and mandates a reviewer would
treat as defects (see the pre-flight section of `executor-and-ledger.md`). If the scan is clean,
proceed without comment. If it is not, stop for **one batched gate** — never one question per
finding. The build is not the place to discover the plan fights itself.

```
GATE — Plan conflicts
Done:     Scanned the plan for internal contradictions before dispatching the executor
Evidence: <each finding quoted beside the plan text that mandates it, with task numbers>
Decide:   For each: which one governs?
Risk:     The executor runs the whole plan continuously without checking in. A contradiction I
          resolve by guessing becomes committed code in whichever direction I guessed.
```

## Step 2 — Execute (one subagent, whole plan)

Dispatch **one** fresh executor subagent using
[assets/executor-prompt.md](assets/executor-prompt.md). Choose its model deliberately (see Model
Selection in `executor-and-ledger.md`) and **state the model explicitly**. Hand it: the plan file
path, the branch/worktree, the resume task, any interfaces from earlier work orders it cannot know,
your resolution of any ambiguity from the pre-flight scan, and the report-file path
(`docs/plans/reports/NN-<slug>.md` — the same number and slug as the plan; the reports folder keeps
`docs/plans/` holding plans only).

The executor runs every remaining task in order, TDD-shaped, committing per task and ticking each
task's checkboxes in the plan file as it goes (each tick its own commit). It executes
**continuously** — do not ask it to check in between tasks.

Handle its return status:

- **DONE / DONE_WITH_CONCERNS:** read the report; if concerns touch correctness or scope, resolve
  them before moving on. Proceed to verify.
- **NEEDS_CONTEXT:** provide the missing context and re-dispatch (same model).
- **BLOCKED:** assess. Context problem → re-dispatch with more context. Needs more reasoning →
  re-dispatch one model tier up. Plan is wrong → stop and escalate to the user as a gate. Never
  force the same model to retry unchanged.

  ```
  GATE — Build blocked
  Done:     Executor stopped at task <N> of <M>; tasks 1–<N-1> are committed and ticked
  Evidence: <the executor's BLOCKED reason verbatim> · <git log of what landed> · <the plan
            text at task N>
  Decide:   The plan is wrong at task <N>. Fix the plan (`/ajian-plan NN`), change the
            approach, or drop the task?
  Risk:     The branch is half-built and the ledger says so. Guessing a fix here writes code
            the plan never described, which the Spec axis will flag at review as something
            built that nobody asked for.
  ```

Never dispatch a second implementer subagent against the same tree in parallel — commits would
interleave. (Parallel is only ever across *independent* work orders, opt-in, each in its own
worktree — see `executor-and-ledger.md`.)

## Step 3 — Verify the branch is green

Before claiming the build complete, apply
[references/verification-before-completion.md](references/verification-before-completion.md): run
the full test suite and the build yourself, read the output, confirm 0 failures and exit 0. Do not
trust the executor's success report — check the git diff and re-run the suite. Then re-read the
plan's acceptance criteria and the work order's Definition of Done (`docs/QUALITY.md`) and confirm
each is met. If anything is red, it is not done: send the specifics back to the executor.

Confirm the plan file's checkboxes are all ticked and committed — the ledger should show the build
complete — and that the build report is committed at `docs/plans/reports/NN-<slug>.md`.

## Step 4 — Hand off

The branch is green and committed; the plan is fully ticked. Do **not** review or merge here — that
is `ajian-review`'s job (the 2-axis review, then finishing the branch).

**→ Next: `/ajian-review NN`** (or `/ajian-map` if unsure).
