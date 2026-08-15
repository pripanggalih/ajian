<!-- Adapted from mattpocock/skills `grilling` (the frontier/rounds mechanic, quoted nearly
     verbatim in "The mechanic"). This is the grill-2 (micro) tuning: fact-heavy, run against real
     code, only genuine decisions reach the user. See NOTICE.md for attribution. -->

# The grill engine (grill-2, micro)

The interrogation `ajian-grill` runs on. Same mechanic as grill-1, different character: here the
project already exists, most gaps are answered by the recon subagent, and only the questions with
two genuinely valid answers reach the user.

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

## The grill-2 tuning

Two things bend the raw mechanic for the micro pass.

1. **Recon runs underneath the rounds, never in front of them.** Dispatch it, then ask the frontier
   that does not depend on it. Holding the first round until recon reports turns a background fact-
   find into a silent wait, which is the opposite of what the mechanic above prescribes.

2. **A mechanical filter, not a judgement call.** A question reaches the user only if it is
   **(a)** listed under the work order's `Open questions`, or **(b)** a conflict recon found between
   two things already shipped. Everything else: take your own recommendation, record it as a resolved
   question naming its source, and move on. Apply (a)/(b) and move — do not re-derive the test per
   question.

   Nothing is silently assumed. Every recommendation you took is shown at the Gate under `Resolved`,
   where the user overrules any of them in one word. The upstream guarantee is met by the gate, not
   by the asking — which is why a grill-2 round is often two or three questions where grill-1 sweeps
   broad. Always a recommendation on every one.

For a UI feature the frontier also carries the design brief — mode, what-changes, key states,
constraints — but never CSS values or aesthetic lanes; those are impeccable's to invent.

## When the engine stops

The frontier is empty when every open question the work order listed is answered (by code or by
the user) and nothing recon surfaced is left hanging. That is the moment to promote brief →
detailed. Anything that genuinely cannot be answered yet becomes an open ADR
(`decisions/NNNN-*.md`, `Status: open`) naming what it blocks — never a placeholder in the work
order.
