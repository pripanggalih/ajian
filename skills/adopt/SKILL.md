---
name: ajian-adopt
description: >-
  Use to bring an existing project onto the ajian pipeline when ajian cannot read it yet. Two
  cases. The project already holds real documents in another shape — a long README, a PRD, an
  ARCHITECTURE.md, leftover Spec Kit or other framework artifacts — which must be mapped into the
  blueprint layout rather than duplicated beside it. Or the project already used ajian, but its
  documents are partial, misplaced, or written by an older version of these skills, so a later
  skill now refuses on a field its files do not contain. It surveys what exists, proposes a
  per-document mapping, and migrates only what you approve — it never deletes. Triggers include
  "/ajian-adopt", "adopt this project", "pakai ajian di project ini", "rekonsiliasi dokumen",
  "align the docs", "migrate to ajian", "ajian-map says there is no blueprint but there are docs".
  Not for a project with code and no documents — that is ajian-blueprint in brownfield mode.
---

<!-- Original ajian wiring. No upstream counterpart: the vendored sources all assume a project that
     starts with them. This skill exists because ajian-map's blueprint signal is a presence check,
     so a project whose documents are real but shaped differently reads as having none — and
     ajian-blueprint would then write a second set beside the first. See NOTICE.md. -->

# Ajian · Adopt

Bring a project that ajian cannot read yet to the point where it can. The finish line is exact:
`/ajian-map` runs and resolves to a real next step.

This skill does not decide anything about the product. It finds what is already written, works out
what ajian needs that nothing covers, and asks you — document by document — what should move where.

## Preconditions

- **The project has documents, or a partial ajian layout, or both.** Code with no documents at all
  is not adoption; there is nothing to reconcile, only something to write. That is
  `/ajian-blueprint` in brownfield mode.
- **`docs/INDEX.md` and `docs/ROADMAP.md` are not both present and healthy.** If they are, the
  project is already adopted — run `/ajian-map`. The exception is drift: present but stale,
  misplaced, or written to an older shape (Step 2 detects this, and it is the whole of case **c**).
- **You are in a git repository.** Every move this skill makes is committed, so each one can be
  undone with `git revert` rather than reconstructed from memory.

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

Find every document in the repo, not just the ones in `docs/`. Product truth hides in READMEs,
wikis checked into the tree, `CONTRIBUTING.md`, design notes, and the leftovers of whichever
framework was tried before this one.

For each file record three things: its **path**, **what it claims to own** (in your words, not its
title's), and **how stale it looks** against the code — a document describing modules that no
longer exist is evidence, not truth.

Read the code too, but only enough to judge staleness and to fill gaps later. This is not
`ajian-grill`'s recon; you are surveying documents, not designing a feature.

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

**What is already ajian's, but the wrong shape?** These skills change their artifacts over time,
and nothing in a project records which version wrote it. So detect the **shape**, not a version
stamp: read [references/shape-drift.md](references/shape-drift.md), which lists the artifact
shapes the current skills expect and the older shapes that still turn up. Shape detection cannot
lie the way a version field that nobody remembered to increment can.

The reason this matters is concrete rather than theoretical: a skill downstream will refuse a work
order over a field its file does not contain, and the refusal will name a field the user has never
seen. Fixing that here is the difference between an afternoon and a dead end.

## Step 3 — Propose the mapping

One round, the whole survey at once — this is a mapping, not an interrogation, and splitting it
across rounds makes the shape impossible to see.

Present it as a table: **source path → destination → what moves → what stays behind**. Then gate:

```
GATE — Adoption mapping
Done:     Surveyed <N> documents, classified them, and diagnosed <M> gaps and <K> shape drifts
Evidence: <the mapping table> · <the gap list> · <the drift list, each naming the file and the
          field or section that is missing>
Decide:   Which of these moves do you approve? Anything I have put in the wrong bucket?
Risk:     I move content and leave a pointer; I never delete, so every move is revertible. But a
          document I classify as "stays where it is" stays a second source of truth, and a
          document I move that you needed in place will surprise the next reader of that path.
```

Approval is **per document**, not for the table as a whole. A user who approves nine of eleven
moves has told you something useful about the two.

## Step 4 — Migrate what was approved

Rules, in order of how easy they are to violate:

1. **Never delete.** Move content out, leave a pointer in its place — a line saying what moved and
   where it went. Deleting is the user's call, in their own commit, once they can see the result.
2. **Move meaning, not prose.** Each ajian document has a charter
   (`ajian-blueprint/references/doc-charters.md`); content arrives in that document's shape, not
   the source's. Read the destination's template in `ajian-blueprint/assets/` immediately before
   writing it.
3. **Fill gaps honestly.** From the code where the code answers. From the user where it does not.
   An unknown becomes an **open ADR** — `docs/decisions/NNNN-<slug>.md` with `Status: open`, plus a
   ledger row — never a placeholder. A placeholder is a lie the next agent reads as fact.
4. **Repair drift in place.** Add the missing field to the shape that lacks it; do not rewrite a
   work order that is merely old. An old document that still says the right thing is not a defect.
5. **Commit per document.** One document, one commit. A mapping decision the user regrets is then
   one `git revert` away, and the git history reads as a record of what moved.

Write `docs/INDEX.md` last, from its template — it is the routing table, and it can only be honest
once everything it routes to exists. Then wire the pointer block into whichever of `AGENTS.md`,
`CLAUDE.md`, `.cursor/rules/` or the README the repo already uses, exactly as `ajian-blueprint`
does.

**A roadmap is not invented here.** If the project has no `ROADMAP.md`, adoption ends without one
and hands off to `ajian-blueprint` in resumed mode, which owns the roadmap and its sizing gate.
Inventing an ordered feature list without that gate produces lines nobody sized.

## Step 5 — Verify against the router, not against yourself

Adoption succeeded if `ajian-map` can locate the project. So run its signals — the ones in
`ajian-map/SKILL.md`, in order — and read what they resolve to. This is the verification, and it is
not the same as believing the migration went well:

```
GATE — Adoption complete
Done:     Migrated <N> documents, filled <M> gaps, repaired <K> shape drifts
Evidence: <the commits, one per document> · <ajian-map's signals, run in order, and what each
          returned> · <the next step they resolve to>
Decide:   Anything that landed in the wrong place, or that should not have moved?
Risk:     Documents I left in place still hold their original text. If one of them contradicts
          what I wrote into the blueprint, the agent reading this project will believe both.
```

If the signals do not resolve — a work order with no `Depth:`, a roadmap with no rows — say so
plainly and fix it. A project that adoption declares finished and the router cannot read is worse
than one that was never adopted, because the next skill will trust it.

## Step 6 — Hand off

Point at whatever Step 5's signals resolved to. Usually one of:

- **No `ROADMAP.md`** → `/ajian-blueprint` in resumed mode, to build and gate the roadmap on top of
  the foundation that now exists.
- **A roadmap with unticked rows** → `/ajian-grill <number of the topmost unticked row>`.

**→ Next: whatever `ajian-map`'s signals resolved to in Step 5** (or `/ajian-map` to hear it again).
