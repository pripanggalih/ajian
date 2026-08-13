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

- **Do I need impeccable installed?** Yes — `npx impeccable install`. Without it the skill stops at
  its first step and tells you. It will **not** design or implement the surface itself as a
  fallback: that would produce a surface outside the pipeline, skipping `ajian-plan` and
  `ajian-build` — no plan, no ledger, no review. Install it, or decide to skip design for this work
  order and go straight to `/ajian-plan NN`.
- **Why not use impeccable's `init` to write PRODUCT.md?** Because the product truth already lives in
  your blueprint. ajian projects it (with a "do not hand-edit — change the blueprint" header) and
  only asks a short gap-fill round for what the blueprint genuinely lacks.
- **Who decides the visual direction?** Impeccable's direction gate — it's yours. ajian doesn't
  second-guess the world impeccable invents.
- **Where does the visual truth live?** In `DESIGN.md` (realised) and `.impeccable/`. The blueprint's
  `DESIGN-SYSTEM.md` keeps only the thin constraints (a11y baseline, brand non-negotiables).

## It's working if

The surface is built, `DESIGN.md` reflects it, and the plan that follows can name real screens and
states — and impeccable's interview collapsed to a confirmation because the brief was already answered.
