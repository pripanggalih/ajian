<!-- Original ajian wiring, distilled from superpowers `executing-plans` and
     `subagent-driven-development` (MIT, Jesse Vincent). The divergence from SDD is deliberate and
     is the whole point of this skill: ONE executor subagent runs the WHOLE plan, the plan's
     committed checkboxes are the ledger, and there is NO per-task review — the single review is at
     the end, in ajian-review. See NOTICE.md and docs/ajian-blueprint.md decision #10. -->

# The executor, the ledger, and resume

## Why this diverges from subagent-driven-development

SDD dispatches a fresh subagent per task and reviews after every one, with a five-round fix loop
and a git-ignored `.superpowers/sdd/` workspace of ledgers, briefs, and review packages. It is
thorough — and slow and token-heavy: the per-task review keeps re-triggering the test suite, and
the workspace is a second bookkeeping system beside git.

ajian-build makes three cuts:

1. **One executor, whole plan.** A single fresh subagent runs every task in order, in its own
   context. No per-task dispatch overhead. The main session stays clean for coordination. This is
   safe because the roadmap already sized the plan to one build session (see the sizing rails in
   `ajian-blueprint`) — the executor is not asked to hold more than fits.
2. **The plan's checkboxes are the ledger.** No `.superpowers/sdd/progress.md`, no hidden runtime
   folder. The committed plan file (`docs/plans/NN-<slug>.md`) carries the `- [ ]` boxes; the
   executor ticks each task's boxes and commits the tick. Progress lives in git, in the open.
3. **Review once, at the end.** No per-task review loop. The whole-branch review is `ajian-review`,
   after the build. This is the token-and-time saving the whole pipeline was designed for.

What is kept from SDD, because it is load-bearing: never run two implementer subagents against the
same tree in parallel; hand artifacts (plan, report) over as files, not pasted into the prompt;
choose the model deliberately; and treat git + the ledger, not your own memory, as the truth after
compaction.

## The ledger = committed checkboxes

- A task's boxes are `- [ ]` while pending, `- [x]` once the executor has built, tested, and
  committed it. Each tick is its own commit (`chore(plan): tick task N`).
- **Resume after a dead or compacted executor:** read the plan file. The first task with an
  unticked box is where work resumes. Cross-check with `git log` — the commits the ticks refer to
  exist in git even if no context remembers creating them. Dispatch a fresh executor pointed at
  that resume task; never redo a ticked one.
- Because the ledger is the plan and the plan is committed, `git clean -fdx` cannot destroy it, and
  there is no sibling scratch directory to confuse with another plan's.

## The report ≠ the ledger

The executor also writes one build report — the verification evidence (commands and their output,
TDD RED/GREEN, files changed, concerns) the controller reads in Step 3 instead of trusting a
success claim, and the trail anyone auditing the work order later can follow. It is not an input to
`ajian-review`: that review judges the diff, not the executor's account of it. The report goes to
`docs/plans/reports/NN-<slug>.md`, in its own folder — the
ledger and the report are different artifacts with different lifetimes, and mixing them into
`docs/plans/` makes the plan folder ambiguous to read and to route on. One report per plan, same
number and slug, committed with the last task.

## Pre-flight conflict scan (before dispatching)

Before the executor starts, scan the plan once — this is the controller's job, cheap and one-time:

- tasks that contradict each other or the plan's Global Constraints;
- anything the plan mandates that a reviewer would treat as a defect (a test that asserts nothing,
  verbatim duplication of a logic block).

Present everything found as one batched question to the user — each finding beside the plan text
that mandates it, asking which governs — before execution begins, not one interrupt per discovery.
If the scan is clean, proceed without comment.

## Model selection

Use the least powerful model that can do the job; **always specify the model explicitly** when
dispatching — an omitted model inherits the session's most expensive one.

- **Plan is fully specified (code in the steps):** the executor is transcription plus testing — a
  fast, cheap model handles it.
- **Plan leans on judgment** (multi-file coordination, integration, prose-described steps): a
  standard mid-tier model, which is also the floor — the cheapest models take 2–3× the turns on
  multi-step work and cost more overall.
- **Resume on a stuck build:** dispatch the fresh executor one tier above the one that stalled.

**Reasoning effort is a separate dial from model.** Where the harness exposes one, dispatch the
executor on a low setting: ajian spent its reasoning in `ajian-grill` and `ajian-plan`, and by the
time a plan exists the decisions are made — this is execution work. Where the harness exposes no
such dial, the prompt carries it instead (`assets/executor-prompt.md` tells the executor not to
re-open the plan's choices), which is why that instruction is not optional decoration.

## Continuous execution

Do not pause to check in between tasks. The user asked for the plan to be built; build it. The only
stops are BLOCKED the executor cannot resolve, NEEDS_CONTEXT for information it was never given, or
all tasks complete. "Should I continue?" between tasks wastes the user's time — and so does weighing
whether to ask it, which is why the executor prompt tells the executor outright that the plan already
decided. The pre-flight conflict scan above is where ambiguity gets raised; nothing that survives it
is a mid-task deliberation.

## Optional parallel across independent work orders

Default is sequential — one work order at a time. Parallel is **opt-in** and only across
**independent work orders**, never across tasks within one (tasks in a plan are tightly coupled —
shared files, Consumes/Produces edges — so parallelizing them produces semantic conflicts, not
speed). When the user opts in:

- **Gate on the dependency edges.** Two work orders may run in parallel only if neither lists the
  other (directly or transitively) in its ROADMAP dependencies.
- **Gate on a conflict scan.** Before dispatching them together, check that their plans' `Files:`
  blocks do not overlap. Any shared file → they are not independent; run them in sequence.
- **Isolate each in its own worktree** (see [using-git-worktrees.md](using-git-worktrees.md)), one
  executor per worktree, so commits never interleave on one tree.
- Interactive phases (grill, design, plan) stay sequential regardless — only plan-approved builds
  fan out. Each still ends at its own `ajian-review`.
