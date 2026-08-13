<!-- Adapted from mattpocock/skills `grilling` (the frontier/rounds mechanic, quoted nearly
     verbatim in "The mechanic"). This is the grill-2 (micro) tuning: fact-heavy, run against real
     code, only genuine decisions reach the user. See NOTICE.md for attribution. -->

# The grill engine (grill-2, micro)

The interrogation `ajian-grill` runs on. Same mechanic as grill-1, different character: here the
project already exists, most gaps are answered by the recon subagent, and only the questions with
two genuinely valid answers reach the user.

## The mechanic

Interview the user relentlessly until you reach a shared understanding. Map this as a **design
tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already
settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask a
frontier as one round: number each question and give your recommended answer. Then wait for the
user's answers before the next round.

Each question is formatted like so:

```
❓ **Q1** — **<question title>**: <question body, may include options>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree — settled decisions push the frontier outward and
unblock questions that depended on them. Recompute the frontier and ask the next round. A question
whose answer depends on another question still open belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the
environment (filesystem, tools, the shipped code), dispatch a sub-agent to find it — don't ask the
user for anything you could look up yourself. Don't block on it: a running exploration is an
unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report —
ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

## The grill-2 tuning

Two things bend the raw mechanic for the micro pass:

1. **Read before you ask.** The agenda is the work order's open questions plus whatever the recon
   surfaced. Before any question reaches the frontier, check whether the code already answers it. A
   question the shipped code settles is not a question — it is a fact to record. Most of a brief's
   open questions die this way, silently and correctly.

2. **Only genuine decisions reach the user.** A question earns a place in a round only when two
   valid answers would change what gets built and the code does not pick between them. Everything
   else a subagent settles. The user in grill-2 should see a short, sharp round — often two or
   three questions — not the broad sweep of grill-1. Always a recommendation on every one.

For a UI feature the frontier also carries the design brief — mode, what-changes, key states,
constraints — but never CSS values or aesthetic lanes; those are impeccable's to invent.

## When the engine stops

The frontier is empty when every open question the work order listed is answered (by code or by
the user) and nothing recon surfaced is left hanging. That is the moment to promote brief →
detailed. Anything that genuinely cannot be answered yet becomes an open ADR
(`decisions/NNNN-*.md`, `Status: open`) naming what it blocks — never a placeholder in the work
order.
