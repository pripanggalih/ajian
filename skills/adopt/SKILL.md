---
name: ajian-adopt
description: >-
  Use to bring an existing project onto the ajian pipeline when ajian cannot read it yet. Triggers
  include "/ajian-adopt", "adopt this project", "pakai ajian di project ini", "rekonsiliasi
  dokumen", "align the docs", "migrate to ajian", "ajian-map says there is no blueprint but there
  are docs". Two cases: the project holds real documents in another shape (a long README, a PRD, an
  ARCHITECTURE.md, leftover Spec Kit artifacts) that must be mapped into the blueprint layout rather
  than duplicated beside it; or it already used ajian but its documents are partial, misplaced, or
  written to an older shape, so a later skill refuses on a field its files lack. It surveys, proposes
  a per-document mapping, and migrates only what you approve — it never deletes. Not for a project
  with code and no documents — that is ajian-blueprint in brownfield mode.
---

<!-- Original ajian wiring. No upstream counterpart: the vendored sources all assume a project that
     starts with them. This skill exists because ajian-map's blueprint signal is a presence check,
     so a project whose documents are real but shaped differently reads as having none — and
     ajian-blueprint would then write a second set beside the first. See NOTICE.md. -->

# Ajian · Adopt

Bring a project that ajian cannot read yet to the point where it can. The finish line is exact:
`/ajian-map` runs and resolves to a real next step.

It decides nothing about the product: it finds what is already written, works out what ajian needs
that nothing covers, and asks you — document by document — what should move where.

## Preconditions

```bash
ls docs/INDEX.md docs/ROADMAP.md 2>/dev/null; git rev-parse --git-dir 2>/dev/null
```

- No documents at all, only code → nothing to reconcile, only something to write. That is
  `/ajian-blueprint` in brownfield mode.
- Both `INDEX.md` and `ROADMAP.md` present and healthy → the project is already adopted; run
  `/ajian-map`. The exception is drift — present but stale, misplaced, or written to an older shape
  (Step 2 detects this, and it is the whole of case **c**).
- No git repository → every move this skill makes is committed so it can be undone with
  `git revert`. Say so and offer to `git init`.

### When a precondition fails

Check the files on disk, not what the conversation claims happened. When one fails, stop — do not
quietly fix it. Name the gap in plain language, name the one skill that owns it, offer that one step:

> "<what is missing, in a sentence a non-developer follows>. That is `<skill>`'s job — it <what it
> does, in plain words>. Run it now?"

Then wait. One step, never a chain, and never run the missing step without asking.

## Language

Reply in the user's language — this file is English because it is agent-facing, not because the
answer must be. Quoted lines here are meaning to convey, not strings to copy: translate them, but
keep the labels `GATE / Done / Evidence / Decide / Risk` verbatim. A gate the user has to decode is
a gate they rubber-stamp.

## The gate protocol

A gate is a full stop that waits for the user. Emit it as plain markdown — never inside a code
block — carrying these five fields, in this order:

**GATE — <name of the gate>**

**Done**
- <what you actually did>

**Evidence**
- <one checkable fact per bullet — real command output, or the path of a committed artifact, never
  your own assessment>

**Decide**
- <what the user has to decide, phrased as a question they can answer>

**Risk**
- <what breaks if this is wrong and you proceed anyway>

Then stop and wait. Never continue on your own reading of what the user probably wants. `Evidence`
is load-bearing: if you cannot produce it, you have not reached the gate. `Risk` is what lets a user
who cannot audit your work decide anyway.

This block is identical in every ajian skill.


## Pipeline

```
0  Survey       inventory every document in the repo — path, what it claims to own, how stale
1  Classify     each file → maps whole / maps partly / stays where it is / is ajian's already
2  Diagnose     what ajian needs that nothing covers · what ajian has that drifted   [shape check]
3  Propose      the per-document mapping, in one round                                     [GATE]
4  Migrate      move approved content, leave a pointer, never delete · commit per document
5  Verify       run ajian-map's own signals; the project must resolve to a next step
6  Hand off     → whatever that resolution names
```

---

## Step 0 — Survey what is actually there

**Dispatch a subagent to survey.** It is a read-heavy sweep over files you will mostly not migrate,
and it does not belong in the controller's context.

Its brief: every document in the repo, not just `docs/` — product truth hides in READMEs, wikis
checked into the tree, `CONTRIBUTING.md`, design notes, and the leftovers of whichever framework was
tried before. Per file, three things: **path**, **what it claims to own** (in words, not its
title's), and **how stale it looks** against the code. Read the code only enough to judge staleness —
this is not `ajian-grill`'s recon.

## Step 1 — Classify each document

Four buckets, and the boundaries matter more than the labels:

- **Maps whole** — the file is one ajian document under a different name. A real `ARCHITECTURE.md`
  is `docs/ARCHITECTURE.md`.
- **Maps partly** — the common case. A 4,000-word README carrying vision, stack, and contribution
  rules is three ajian documents plus a residue that belongs to nobody.
- **Stays where it is** — install instructions, licence, badges, contribution etiquette, anything
  a reader outside the project needs. Moving these into the blueprint makes the repo worse.
- **Already ajian's** — an existing `docs/PRD.md` or `work-orders/`, whether healthy or drifted.

[references/source-mapping.md](references/source-mapping.md) has the mapping table for the shapes
that turn up most — README, PRD, Spec Kit, foreign ADR formats, wikis. Read it before classifying.

## Step 2 — Diagnose the gaps and the drift

Two questions, and both are answered by reading files, never by asking:

**What does ajian need that nothing covers?** Compare against the blueprint's document set. A gap
is not a failure of this skill — it is something to fill in Step 4, from the code where the code
knows, and from the user where it does not.

**What is already ajian's, but the wrong shape?** Nothing in a project records which version wrote
its artifacts, so detect the **shape**, not a version stamp: read
[references/shape-drift.md](references/shape-drift.md) for the shapes the current skills expect and
the older ones that still turn up. Left unfixed, a skill downstream refuses a work order over a field
its file does not contain, naming a field the user has never seen.

## Step 3 — Propose the mapping

One round, the whole survey at once — this is a mapping, not an interrogation.

Present it as a table: **source path → destination → what moves → what stays behind**. Then gate:

**GATE — Adoption mapping**

**Done**
- Surveyed <N> documents, classified them, and diagnosed <M> gaps and <K> shape drifts

**Evidence**
- <the mapping table>
- <the gap list>
- <the drift list, each naming the file and the field or section that is missing>

**Decide**
- Which of these moves do you approve? Anything I have put in the wrong bucket?

**Risk**
- I move content and leave a pointer; I never delete, so every move is revertible
- A document I classify as "stays where it is" stays a second source of truth
- A document I move that you needed in place will surprise the next reader of that path

Approval is **per document**, not for the table as a whole.

## Step 4 — Migrate what was approved

Rules, in order of how easy they are to violate:

1. **Never delete.** Move content out, leave a pointer saying what moved and where. Deleting is the
   user's call, in their own commit, once they can see the result.
2. **Move meaning, not prose.** Each ajian document has a charter
   (`ajian-blueprint/references/doc-charters.md`); content arrives in that document's shape, not
   the source's. Read the destination's template in `ajian-blueprint/assets/` immediately before
   writing it.
3. **Fill gaps honestly.** From the code where it answers, from the user where it does not. An
   unknown becomes an **open ADR** — `docs/decisions/NNNN-<slug>.md`, `Status: open`, plus a ledger
   row — never a placeholder.
4. **Repair drift in place.** Add the missing field to the shape that lacks it; do not rewrite a work
   order that is merely old.
5. **Commit per document.** One document, one commit, so a regretted move is one `git revert` away.

Write `docs/INDEX.md` last, from its template — it is the routing table, and it can only be honest
once everything it routes to exists. Then wire the pointer block into whichever of `AGENTS.md`,
`CLAUDE.md`, `.cursor/rules/` or the README the repo already uses, exactly as `ajian-blueprint`
does.

**A roadmap is not invented here.** No `ROADMAP.md` → adoption ends without one and hands off to
`ajian-blueprint` in resumed mode, which owns the roadmap and its sizing gate.

## Step 5 — Verify against the router, not against yourself

Adoption succeeded if `ajian-map` can locate the project. Run its signals in order and read what they
resolve to — that is the verification, not your sense that the migration went well:

**GATE — Adoption complete**

**Done**
- Migrated <N> documents, filled <M> gaps, repaired <K> shape drifts

**Evidence**
- <the commits, one per document>
- <ajian-map's signals, run in order, and what each returned>
- <the next step they resolve to>

**Decide**
- Anything that landed in the wrong place, or that should not have moved?

**Risk**
- Documents I left in place still hold their original text
- If one of them contradicts what I wrote into the blueprint, the agent reading this project will
  believe both

If the signals do not resolve — a work order with no `Depth:`, a roadmap with no rows — say so and
fix it. A project adoption declares finished but the router cannot read is worse than one never
adopted: the next skill will trust it.

## Step 6 — Hand off

Point at whatever Step 5's signals resolved to. Usually one of:

- **No `ROADMAP.md`** → `/ajian-blueprint` in resumed mode, to build and gate the roadmap on top of
  the foundation that now exists.
- **A roadmap with unticked rows** → `/ajian-grill <number of the topmost unticked row>`.

**→ Next: whatever `ajian-map`'s signals resolved to in Step 5** (or `/ajian-map` to hear it again).
