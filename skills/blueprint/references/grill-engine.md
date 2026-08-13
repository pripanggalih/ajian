<!-- Adapted from mattpocock/skills `grilling` (the frontier/rounds mechanic, quoted nearly
     verbatim in "The mechanic" below), railed by the author's own six foundation themes. The ajian
     seam: the frontier is bounded to one theme at a time, and every question carries a recommended
     answer. See NOTICE.md for attribution of the vendored `grilling` text. -->

# The grill engine (grill-1, macro)

This is the interrogation that step 2 runs on. It fuses two things: the **frontier/rounds
mechanic** that guarantees you never ask a question whose answer you haven't heard yet, and the
**six blueprint themes** that guarantee you never silently skip a decision an agent will later
inherit.

grill-1 is the **macro** pass. It is decision-heavy: the answers are the user's to make, the
stack is still open, non-goals are still soft. (Its sibling, `ajian-grill`, is the **micro** pass
— fact-heavy, run against real code, one work order at a time.)

## The mechanic

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Each question should be formatted like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it — don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report — ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

## The two rails ajian adds

The raw mechanic can sprawl and can overwhelm. Two rails keep it usable without losing coverage:

1. **Themes, as guaranteed coverage.** The design tree is not free-form — its top-level branches
   are the six themes below, worked in dependency order. A theme is not done until it is decided
   enough to govern every later feature. This is what stops a fluent conversation from skipping
   non-goals or the accessibility baseline.

2. **One theme at a time, as a bound.** Do not open the entire frontier across all six themes at
   once — that is the message no one reads. Compute the frontier **within the current theme**,
   ask that round, settle it, then move to the next theme. A user who is tired and answering
   "sure, sounds good" is a user you are overwhelming; a bounded round of two-to-four questions,
   each with a recommendation, is one they can actually weigh.

And, always: **a recommended answer on every question** (the `➡️` line). The user is choosing
between your options, not staring at a blank prompt. A recommendation the user overrules costs one
word; a blank question costs a paragraph and often a worse answer.

## The six themes (the rails)

Work them in this order; each governs the ones after it:

1. **Problem & product** — what is broken today, who has it, what changes for them.
2. **Users & scope** — primary users, top jobs-to-be-done, the v1 boundary, and **project-level
   non-goals**. Push hard here: non-goals are the most skipped and highest-leverage section.
3. **The stack** — *greenfield:* propose 2–3 defensible options with tradeoffs and let the user
   choose; never assume silently. *brownfield:* confirm what the scan found, fill the gaps it
   could not answer.
4. **Domain entities** — in business language ("a booking belongs to one customer and has many
   rooms"), not tables or columns. Skip the theme entirely if there is no data layer.
5. **Conventions & quality** — reuse targets, naming, what "done" means, what must pass in CI.
6. **Interface direction** — only if there is a UI: tone and density, the key screens, the states
   that always get forgotten (empty, loading, error, success), the accessibility baseline.

## When the engine stops

The session is done when the frontier is empty across every theme: every branch of the design
tree visited, nothing left silently assumed. A question you skip here becomes an assumption the
agent inherits. When a question genuinely cannot be answered yet, do not soften it into a
placeholder — record it as an open ADR (`decisions/NNNN-*.md`, `Status: open`) with what it
blocks. Do not act on the design until the user confirms you have reached a shared understanding.
