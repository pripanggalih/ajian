# ajian-adopt

## What it does

Brings a project ajian cannot read yet to the point where it can. It surveys **every** document in
the repo — not just the ones in `docs/` — classifies each one, works out what ajian needs that
nothing covers, and proposes a **per-document mapping**: what moves, where, and what stays put. You
approve document by document; it migrates only what you approved, leaves a pointer where content
came from, and **never deletes**. It also repairs an older ajian layout whose files are missing
fields the current skills expect. The finish line is exact: `/ajian-map` runs and resolves to a real
next step.

## When to reach for it

- **You inherited a project with real documents** — a long README, a PRD, an `ARCHITECTURE.md`, a
  checked-in wiki, leftover Spec Kit or other framework artifacts — and you want to build with ajian
  from here.
- **You used ajian before, updated the skills, and something downstream now refuses** on a field
  your files do not contain.
- **`ajian-map` says there is no blueprint, but you can see documents right there.** That is the
  signal this skill exists for.
- **Not** for a project with code and no documents. There is nothing to reconcile — that is
  `/ajian-blueprint` in brownfield mode, which scans the code and writes the foundation fresh.

## Common questions

- **Will it rewrite my README?** Only if you approve that specific move, and only the parts that
  belong elsewhere. Install instructions, licence, badges and contribution etiquette are classified
  as *stays where it is* — moving them into a blueprint makes the repo worse. Whatever does move
  leaves a pointer behind saying where it went.
- **Why not just link my existing docs instead of moving anything?** Because that produces exactly
  the two-sources-of-truth problem the skill exists to end. Linking a README whose vision,
  architecture and contribution rules are interleaved means the agent must read all of it to find
  one fact — which is what the document charters are there to prevent.
- **Can I undo it?** Yes. One document, one commit, so a mapping you regret is one `git revert`
  away. Nothing is deleted, so nothing has to be reconstructed.
- **How does it know my docs were written by an older ajian?** It doesn't ask, and it doesn't read a
  version stamp — there isn't one, deliberately. It reads the **shape** of each artifact against a
  catalogue of what the current skills expect. A version field is only as good as the discipline
  that increments it, and a stale one is worse than none because the reader trusts it.
- **Does it build the roadmap?** No. It hands off to `ajian-blueprint` in resumed mode, which owns
  the roadmap and its sizing gate. A feature list invented without that gate is a set of lines
  nobody sized.
- **What about a task list or plan I inherited?** It stays put. A framework's *what* is adoptable;
  its *how* is not. An inherited `Depth: detailed` work order is the one migration that reliably
  makes the project worse, because everything downstream trusts that depth.

## It's working if

Every document in the repo has been accounted for — moved, kept, or explicitly left as residue —
your existing writing survives in the place ajian will actually open it, and `/ajian-map` names a
concrete next step instead of "there is no blueprint".
