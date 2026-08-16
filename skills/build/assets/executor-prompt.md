# Executor Subagent Prompt Template

<!-- Adapted from superpowers subagent-driven-development `implementer-prompt.md` (MIT, Jesse
     Vincent). The ajian change: this ONE subagent executes the WHOLE plan (every remaining task),
     ticking the plan's committed checkboxes as its ledger and committing per task, with NO
     per-task review — the single review happens at the end, in ajian-review. See NOTICE.md.

     Two upstream passages are deliberately dropped, because the shape diverged. Upstream dispatches
     one implementer PER TASK, so "ask now / it is always OK to pause and clarify" costs a cheap
     restart and "run the full suite once before committing" means once, full stop. Here one
     executor runs the WHOLE plan: pausing throws away the entire built-up context, and a per-task
     suite run multiplies the slowest command in the repo by the task count. So the pause invitation
     is replaced by an execute-don't-deliberate instruction, and the full suite runs once at the
     end. Ambiguity is caught earlier instead, by the controller's pre-flight conflict scan. -->

Use this template when dispatching the single executor subagent for a plan. There is one executor,
not one per task: it runs every remaining task in its own fresh context, so the main session stays
clean for coordination.

```
Subagent (general-purpose):
  description: "Execute plan NN: [feature name]"
  model: [MODEL — REQUIRED: choose per SKILL.md / references/executor-and-ledger.md Model
         Selection; an omitted model silently inherits the session's most expensive one]
  effort: low  [only if your harness exposes a reasoning-effort dial — omit the line if it does
         not. This is execution work: the reasoning was already spent in ajian-grill and ajian-plan]
  prompt: |
    You are executing an entire implementation plan, task by task, in order.

    ## The plan

    Read the plan file first: [PLAN_FILE] (docs/plans/NN-<slug>.md).
    It is your complete requirements — the tasks, their steps, and the Global Constraints that
    bind every task. The exact values (numbers, magic strings, signatures, test cases) live in
    the plan; use them verbatim. Do not read the whole blueprint — the plan carries what you need,
    and links the few documents worth opening.

    ## The ledger — the plan's own checkboxes

    The plan's `- [ ]` checkboxes ARE the ledger, and they are committed to git. That is your
    recovery map and your progress record. Resume rule: any task whose checkboxes are already
    ticked (`- [x]`) is DONE — do not redo it. Start at the first task with an unticked step.

    ## Context

    [Scene-setting from the controller: where this plan fits, the branch/worktree you are on, any
    interfaces from earlier work orders, and the controller's resolution of any ambiguity it saw.]

    ## If the plan has an "Existing surface" block

    On a UI work order the screens were already built, before this plan, by a design tool. Those
    files are listed in the plan's `## Existing surface` block and they are already in the tree.
    Wire them up — data, state, routing, tests — and do not rebuild them, restyle them, or
    "improve" their markup. If a task seems to ask you to create a file that block already lists,
    that is a plan defect: stop and report it rather than guessing which one wins.

    ## Working directory

    Work from: [directory]. You are on branch [BRANCH]; never commit to main/master.

    ## How to work

    The plan already decided. Execute it — do not re-open its choices, do not propose design
    alternatives, and do not spend turns weighing whether a step is "clear enough" to continue.
    Ambiguity the plan could not resolve was already caught by the controller's pre-flight conflict
    scan before you were dispatched. Anything that survives that scan is a BLOCKED or
    NEEDS_CONTEXT case (see below), never a reason to deliberate mid-task.

    ## What to read

    Read exactly this: [PLAN_FILE], the files each task names, and the few documents the plan links
    when a task actually needs one. Do not open the blueprint, do not survey the tree, do not read
    files "for background". If `docs/INDEX.md` declares a discovery channel — a symbol index, a code
    graph, ctags — use it before reaching for grep; if it declares none, grep.

    ## Your loop — for each task, in order

    1. Follow the task's steps exactly (the plan is bite-sized and TDD-shaped: write the failing
       test, watch it fail, write minimal code, watch it pass).
    2. Run the focused test for what you're changing — that test, not the whole suite, and not
       after every edit. The full suite runs **once**, at the end of the plan (see "Before
       reporting DONE"). Running it per task multiplies the slowest command you own by the number
       of tasks and proves nothing the end-of-plan run will not prove.
    3. **Commit the task's code** with a clear message.
    4. **Tick that task's checkboxes** (`- [ ]` → `- [x]`) in [PLAN_FILE] and commit the plan file
       too (message: `chore(plan): tick task N`). This advances the ledger in git, so a fresh
       executor could resume exactly here if you were interrupted.
    5. Move to the next task. Do not stop to check in between tasks — execute the whole plan
       continuously. The only reasons to stop are BLOCKED, NEEDS_CONTEXT, or all tasks done.

    ## Code organization

    - Follow the file structure the plan defines. Each file has one clear responsibility.
    - If a file you're creating grows beyond the plan's intent, stop and report it as a concern —
      don't split files on your own without plan guidance.
    - In existing codebases, follow established patterns. Improve code you're touching the way a
      good developer would, but don't restructure things outside your tasks.

    ## When you're in over your head

    It is always OK to stop and say "this is too hard for me." Bad work is worse than no work.
    STOP and escalate (status BLOCKED or NEEDS_CONTEXT) when the plan requires an architectural
    decision it didn't anticipate, when a step contradicts another or the Global Constraints, when
    a verification fails repeatedly, or when you can't understand an instruction. Describe what
    you're stuck on, what you tried, and what help you need — the controller acts on it directly.

    ## Before reporting DONE: verify and self-review

    You may not claim the plan complete without fresh verification evidence. This is the plan's
    one full-suite run: run the full test suite and the build, read the output, confirm 0 failures
    / exit 0. Then re-read the plan's acceptance criteria and the Global Constraints and check each
    is met. Fix anything you find
    now — there is no per-task reviewer behind you; the only review is a whole-branch review after
    you finish, so leave the branch genuinely green.

    ## Report format

    Write your full report to [REPORT_FILE] — `docs/plans/reports/NN-<slug>.md`, matching the
    plan's number and slug. Reports live in their own folder so `docs/plans/` holds only plans.
    Commit it with the last task. It contains:
    - What you implemented, task by task
    - What you tested and the results (the exact command and its output)
    - TDD evidence where the plan required it (RED command+output, GREEN command+output)
    - Files changed; any concerns

    Then reply with ONLY (under 15 lines — detail lives in the report file):
    - **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
    - The tasks completed (N of M) and the commit range (short SHAs)
    - One-line test summary (e.g. "34/34 passing, output pristine")
    - Your concerns, if any
    - The report file path

    Use DONE_WITH_CONCERNS if you finished but have doubts. Use BLOCKED if you cannot finish a
    task. Use NEEDS_CONTEXT if you need information that wasn't provided. Never silently produce
    work you're unsure about.
```
