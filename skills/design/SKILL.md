---
name: ajian-design
description: >-
  Use to build the visual world for a UI work order, by handing it to impeccable. This is the
  design stage of the ajian pipeline: it runs after ajian-grill has gathered the surface's design
  brief and before ajian-plan. It derives PRODUCT.md once, as a projection of the blueprint (not a
  fresh interview), then invokes impeccable's new-work flow to invent and build the surface and
  record DESIGN.md. Triggers include "/ajian-design NN", "design work order N", "build the UI for
  this feature", "seed the visual world". Only for work orders that have UI; skip straight to
  ajian-plan otherwise. Requires impeccable to be installed (`npx impeccable install`).
---

<!-- Original ajian wiring: this skill does NOT vendor impeccable — impeccable is a full CLI and
     skill, depended on and invoked via `/impeccable`, licensed Apache-2.0 (see NOTICE.md). What
     ajian adds is the seam: a PRODUCT.md derived from the blueprint instead of a fresh init
     interview, and the handoff of ajian-grill's design brief into impeccable's new-work. -->

# Ajian · Design

Give one UI work order its visual world. The interrogation already happened — `ajian-grill`
gathered the surface's design brief (mode, what-changes, key states, constraints). This skill's job
is to get impeccable the context it needs, let it do what it is best at, and come back with
`DESIGN.md` and a built surface the plan can name.

**This skill is a thin wrapper around impeccable, on purpose.** impeccable owns visual craft; ajian
does not second-guess it. The only things ajian supplies are the two seams below.

## Preconditions

- The work order `NN` is `Depth: detailed` and has UI (its "Screens & states" section is filled by
  `ajian-grill`). If it is still brief, run `/ajian-grill NN` first.
- impeccable is installed. If `node .claude/skills/impeccable/scripts/context.mjs` does not exist,
  tell the user to run `npx impeccable install`, and stop.

## Pipeline

```
0  Orient           read the work order's design brief + DESIGN-SYSTEM constraints
1  Derive PRODUCT    lazy projection of the blueprint → PRODUCT.md (once), gap-fill only
2  Invoke impeccable new-work for this surface, seeded with the design brief → DESIGN.md + UI
3  Record            ensure DESIGN.md reflects the built surface (/impeccable document if needed)
4  Hand off          commit · → plan
```

---

## Step 0 — Orient

Read the detailed work order `docs/work-orders/NN-<slug>.md` — specifically **Screens & states**
(the design brief) — and `docs/DESIGN-SYSTEM.md` (the thin constraints: accessibility baseline and
brand non-negotiables). These are the answers you will hand impeccable so it does not re-interview.

## Step 1 — Derive PRODUCT.md (lazy projection of the blueprint)

impeccable reads `PRODUCT.md` at the repo root for product truth. In ajian that truth already
exists — in the blueprint — so **do not run impeccable's interactive `init`**. Instead:

- **If `PRODUCT.md` is absent:** derive it once from the blueprint, following
  [references/product-projection.md](references/product-projection.md). It maps `PRD.md`,
  `ARCHITECTURE.md`, `GLOSSARY.md`, and `DESIGN-SYSTEM.md` onto PRODUCT.md's fields, and stamps a
  provenance header saying it is derived — **do not hand-edit; change the blueprint instead**. Then
  run one short gap-fill round for anything the blueprint genuinely does not carry (a brand asset,
  a platform confirmation), never re-asking what the blueprint already answers.
- **If `PRODUCT.md` exists:** trust it. Reconcile only if the blueprint has moved since it was
  derived (add durable missing facts; do not reopen confirmed fields without a reason).

Commit `PRODUCT.md` if it was created or changed.

## Step 2 — Invoke impeccable (new-work)

Hand the surface to impeccable. Run its setup and new-work flow, seeded with the design brief so
its interview collapses to a confirmation rather than a fresh interrogation:

1. `node .claude/skills/impeccable/scripts/context.mjs --target <the surface's route or file>` —
   once, as impeccable directs. It loads PRODUCT.md, DESIGN.md, and the matching surface brief.
2. Enter impeccable's **new-work** flow (`/impeccable` for a new surface or replacement world).
   Give it the work order's design brief up front: the **mode** (Persuade / Operate / Read /
   Experience), what changes the work, the key states (empty, loading, error, success), and the
   `DESIGN-SYSTEM.md` constraints. Let impeccable run its own concept and direction machinery — the
   world it invents is its call, not ajian's. Honor its gates (the direction decision is the
   user's).
3. Let impeccable build the surface and write/replace `DESIGN.md` as its flow dictates.

Do not reimplement any of impeccable's steps here. If impeccable asks for something the blueprint
already settled, answer from the blueprint; if it surfaces a genuine new decision, that is the
user's to make.

## Step 3 — Record the realised design

`DESIGN.md` is the realised visual source of truth. new-work normally writes or replaces it; if for
any reason the built surface is not reflected in `DESIGN.md`, run `/impeccable document` to record
the design system from the shipped artifact. Confirm `DESIGN.md` and the `.impeccable/` sidecar
exist and match what was built.

If the build revealed a durable constraint the blueprint should own (a brand commitment, an a11y
rule), fold it back into `docs/DESIGN-SYSTEM.md` — the thin constraints stay in the blueprint,
the realised system stays in `DESIGN.md`.

## Step 4 — Hand off

Commit the built surface, `DESIGN.md`, and `.impeccable/`. The surface now exists, so the plan can
name real screens and states.

**→ Next: `/ajian-plan NN`** (or `/ajian-map` if unsure).
