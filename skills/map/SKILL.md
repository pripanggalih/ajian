---
name: ajian-map
description: >-
  Use to find out where you are in the ajian pipeline and which skill comes next. A state-aware
  router: it reads the project's artifacts (is there a blueprint? what Depth is the work order? is
  there a plan? what does git show?) and answers "you are at work order NN, next: <skill>". Reach
  for it at the start of a session, after a compaction, or any time you are unsure what to run.
  Triggers include "/ajian-map", "where am I", "what's next", "which ajian skill now". It routes; it
  does not do the work.
---

<!-- Adapted from mattpocock/skills `ask-matt` (the router structure, MIT, Matt Pocock). The ajian
     seam: ajian-map is state-aware — it inspects the repo to locate you on the pipeline rather than
     only describing the flow. This is what replaces a session hook (ajian has none by design). See
     NOTICE.md. -->

# Ajian · Map

You don't remember every skill or where you left off — especially after a compaction. So ask. This
skill reads the project and tells you which of the seven skills to run next.

## The pipeline (idea → shipped)

```
ajian-blueprint  →  per roadmap line, in order:
                      ajian-grill  →  (ajian-design, if UI)  →  ajian-plan  →  ajian-build  →  ajian-review
                    →  next line
```

Each skill ends with a `→ Next` breadcrumb; ajian-map is the way to recover that breadcrumb from
project state when you've lost the thread. Chaining is explicit — there are no hooks.

## How it locates you

Read these signals, cheapest first, and stop at the first that tells you the answer:

1. **Is there a blueprint?** Look for `docs/INDEX.md` and `docs/ROADMAP.md`.
   - **No** → you are before the pipeline. **Next: `ajian-blueprint`** (grill-1 → foundation docs).
2. **Which work order is current?** In `docs/ROADMAP.md`, the current line is the lowest-numbered
   **unticked** line. Call it `NN`. (All ticked → the roadmap is done; offer to extend it via
   `ajian-blueprint` in resumed mode.)
3. **What Depth is work order `NN`?** Open `docs/work-orders/NN-<slug>.md`, read its `Depth:` field.
   - **`brief`** → it hasn't been sharpened against real code. **Next: `ajian-grill NN`**.
   - **`detailed`** → continue.
4. **Does it have UI, and is the UI built?** If the work order's "Screens & states" section is
   filled (it has UI) and `DESIGN.md` does not yet cover this surface → **Next: `ajian-design NN`**
   (which needs impeccable installed — it stops and asks if it is missing, rather than designing the
   surface itself). No UI, or the surface is already in `DESIGN.md` → continue.
5. **Is there a plan?** Look for `docs/plans/NN-<slug>.md`.
   - **No** → **Next: `ajian-plan NN`**.
   - **Yes** → read its checkboxes.
6. **What do the plan's checkboxes and git say?**
   - **Some or all boxes unticked** → the build is unstarted or mid-flight. **Next: `ajian-build NN`**
     (it resumes from the first unticked box; cross-check with `git log`).
   - **All boxes ticked, branch not yet merged** → **Next: `ajian-review NN`**.
   - **All boxes ticked and the branch merged / roadmap line ticked** → this work order is done.
     Go back to signal 2 for the next line.

Report the finding in one line, e.g.:

> "Blueprint present. Work order 03 is `detailed`, no UI, plan exists with 4/7 tasks ticked. You are
> mid-build. **Next: `/ajian-build 03`** — it resumes at task 5."

## When the signals conflict

Trust git and the committed artifacts over any recollection — the checkboxes and `git log` are the
ledger. If a plan's boxes are ticked but the code isn't committed, or a roadmap line is ticked but
the branch never merged, say so plainly and recommend the safe next step (usually re-verifying with
`ajian-build`'s verification, or `ajian-review`) rather than guessing.

## What ajian-map does not do

It routes; it does not run the work. It never edits code, promotes a work order, or writes a plan —
it points at the one skill that should. If the user wants that skill run, they invoke it.

**→ Next: whichever skill the signals above resolved to.**
