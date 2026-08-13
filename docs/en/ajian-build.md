# ajian-build

## What it does

Executes one approved plan and leaves a green, committed branch for review. It dispatches **one**
fresh subagent to run the *whole* plan, task by task — TDD-shaped, committing per task, and ticking
the plan's committed checkboxes as it goes (each tick its own commit). The controller does a one-time
pre-flight conflict scan before dispatch and a fresh verification after. There is **no per-task
review** — the single review is saved for `ajian-review`.

## When to reach for it

- After you've approved the plan for a work order.
- To resume an interrupted build — it picks up from the first unticked checkbox plus `git log`.

## Common questions

- **Why one subagent for the whole plan, not one per task?** Fewer dispatches, no per-task review
  churn, and the plan is already sized to one build session by the roadmap. This is the deliberate
  divergence from superpowers' subagent-driven-development (see `references/executor-and-ledger.md`).
- **Where's the ledger?** It *is* the committed plan file's checkboxes — no hidden `.superpowers/sdd/`
  folder. Progress lives in git, in the open, and survives compaction.
- **Where does the build report go?** `docs/plans/reports/NN-<slug>.md`, one per plan, committed. It
  holds the verification evidence — commands and their output, TDD RED/GREEN, files changed,
  concerns — the controller reads instead of trusting a success claim, and the trail anyone
  auditing the work order later can follow. It sits in its own folder so `docs/plans/` stays plans
  only. `ajian-review` doesn't read it: that review judges the diff, not the executor's account.
- **Can it run builds in parallel?** Only across *independent* work orders, opt-in, each in its own
  worktree, gated by dependency edges and a file-overlap scan. Never across tasks within a plan.
- **Does it review or merge?** No — that's `ajian-review`.

## It's working if

The full suite and build pass on fresh evidence (not the subagent's say-so), every plan checkbox is
ticked and committed, and the branch is ready to hand to review.
