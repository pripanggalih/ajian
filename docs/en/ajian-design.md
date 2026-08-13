# ajian-design

## What it does

Gives one UI work order its visual world by handing it to **impeccable**. It derives `PRODUCT.md`
once, as a projection of the blueprint (not a fresh interview), then invokes impeccable's new-work
flow — seeded with the design brief `ajian-grill` gathered — to invent and build the surface and
record `DESIGN.md`. It is a thin wrapper on purpose: impeccable owns visual craft; ajian only
supplies the two seams (PRODUCT.md from the blueprint, and the design brief handoff).

## When to reach for it

- After `ajian-grill` has marked a **UI** work order detailed, before `ajian-plan`.
- Skip it entirely for work orders with no UI — go straight from grill to plan.

## Common questions

- **Do I need impeccable installed?** Yes — `npx impeccable install`. Project-local, user-global
  (`~/.claude/skills/`) and plugin installs all count; the skill looks in all of them and also
  accepts an `impeccable` your harness already offers. Without it the skill stops at its first step,
  shows you what it checked, and asks — so if it *is* installed somewhere unusual, you can just say
  where. It will **not** design or implement the surface itself as a fallback: that would produce a
  surface outside the pipeline, skipping `ajian-plan` and `ajian-build` — no plan, no ledger, no
  review. Install it, or decide to skip design for this work order and go straight to
  `/ajian-plan NN`.
- **Why not use impeccable's `init` to write PRODUCT.md?** Because the product truth already lives in
  your blueprint. ajian projects it (with a "do not hand-edit — change the blueprint" header) and
  only asks a short gap-fill round for what the blueprint genuinely lacks.
- **Who decides the visual direction?** Impeccable's direction gate — it's yours. ajian doesn't
  second-guess the world impeccable invents.
- **If design already builds the UI, what's left for build?** The wiring. impeccable leaves real
  screens in the tree; the build connects them to data, state, routing, and tests. To keep the two
  from colliding, design records the file inventory in the work order's `## Built surface` section —
  `ajian-plan` reads it and plans around those files instead of recreating them, `ajian-build`'s
  executor is told they exist, and `ajian-review` leaves impeccable's craft out of the Standards
  axis. Design also commits on the branch the build will extend, so the surface doesn't go missing.
- **The session ended inside impeccable — did I lose the design?** No. Before handing over,
  `ajian-design` stamps the work order's `## Built surface` with `Status: handed to impeccable` and
  the target branch, and commits it. So the interruption is visible: `ajian-plan` refuses the work
  order until the inventory is real, and re-running `/ajian-design NN` resumes at the recording step
  rather than building the surface twice.
- **Where does the visual truth live?** In `DESIGN.md` (realised) and `.impeccable/`. The blueprint's
  `DESIGN-SYSTEM.md` keeps only the thin constraints (a11y baseline, brand non-negotiables).

## It's working if

The surface is built, `DESIGN.md` reflects it, and the plan that follows can name real screens and
states — and impeccable's interview collapsed to a confirmation because the brief was already answered.
