---
name: ajian-design
description: >-
  Use to build the visual world for a UI work order, by handing it to impeccable. This is the
  design stage of the ajian pipeline: it runs after ajian-grill has gathered the surface's design
  brief and before ajian-plan. It derives PRODUCT.md once, as a projection of the blueprint (not a
  fresh interview), then invokes impeccable's new-work flow to invent and build the surface and
  record DESIGN.md. Triggers include "/ajian-design NN", "design work order N", "build the UI for
  this feature", "seed the visual world". Only for work orders that have UI; skip straight to
  ajian-plan otherwise. Requires impeccable to be installed (`npx impeccable install`) — if it is
  not, this skill stops at its gate and asks for it; it never designs or implements the surface
  itself.
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
- impeccable is **available** — installed project-local, user-global, or via a plugin. This is
  checked in Step 0, and it is a hard gate.

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
0  Gate              impeccable available? no → show the evidence, ask, STOP            [BLOCKING]
1  Orient            read the work order's design brief + DESIGN-SYSTEM constraints
                     Status already `handed to impeccable`? → this is a re-entry, resume at 5
2  Derive PRODUCT    lazy projection of the blueprint → PRODUCT.md (once), gap-fill only
3  Mark the handoff  Built surface → `handed to impeccable` + branch, commit    [before you leave]
4  Invoke impeccable new-work for this surface, seeded with the design brief → DESIGN.md + UI
5  Record            ensure DESIGN.md reflects the built surface (/impeccable document if needed)
6  Inventory         Built surface → files + Status `recorded`, commit · → plan
```

---

## Step 0 — Gate: is impeccable available?

**Do this first, before reading anything else.** What this skill needs is the **impeccable skill,
callable in this session** — not a file at one particular path. impeccable installs project-local
(`.claude/skills/`), user-global (`~/.claude/skills/`), or inside a plugin cache, and it resolves
its own base directory at runtime. A check that knows only one of those locations reports a missing
dependency that is sitting right there — and an agent told to stop for a reason it can disprove
learns that this skill's gates are negotiable. That lesson is expensive: it is not confined to this
gate.

So establish availability, and gather **evidence** rather than issuing a verdict:

1. Look in the canonical locations:

   ```bash
   ls -d .claude/skills/impeccable ~/.claude/skills/impeccable \
         ~/.claude/plugins/cache/*/*/skills/impeccable 2>/dev/null
   ```

2. Independently, note whether the harness lists an `impeccable` skill as loadable. A skill the
   runtime offers **is** available, even when none of those paths match.

- **Available by either signal** → continue to Step 1. Do not verify further, and do not go looking
  for its scripts; Step 3 never calls them.
- **Neither signal** → you have evidence of absence, not proof of it. Show what you ran, and ask:

  ```
  GATE — impeccable availability
  Done:     Looked for impeccable in the project, the user directory, and the plugin caches
  Evidence: <the exact command you ran and exactly what it returned> · harness skill list:
            <impeccable listed / not listed>
  Decide:   If it isn't installed, run `npx impeccable install` and re-run `/ajian-design NN`.
            If it is installed somewhere I didn't look, where?
  Risk:     I will not design this surface myself. Doing so produces an unreviewed surface
            outside the pipeline — no plan, no ledger, no two-axis review — and you would not
            find out until review. Skipping design for this work order is a valid choice, but
            it is yours to make, not mine.
  ```

  **Stop there and wait.** Do not continue to Step 1 on your own judgement.

**You may not stand in for impeccable.** Without it, this skill designs nothing, writes no UI code,
picks no colors or type, and does not touch `DESIGN.md` or `PRODUCT.md`. Doing the work yourself
looks helpful and is the failure this gate exists to prevent: it produces an unreviewed surface
outside the pipeline, skipping `ajian-plan` and `ajian-build` entirely, with no plan, no ledger,
and no two-axis review. A missing dependency is the user's call to resolve, not yours to route
around. Stopping here costs one install; continuing costs the work order's whole trail.

The only other honest exit is the user deciding to skip design for this work order — and that is
theirs to choose, not yours to offer as an equivalent.

## Step 1 — Orient

Read the detailed work order `docs/work-orders/NN-<slug>.md` — specifically **Screens & states**
(the design brief) — and `docs/DESIGN-SYSTEM.md` (the thin constraints: accessibility baseline and
brand non-negotiables). These are the answers you will hand impeccable so it does not re-interview.

**Read `## Built surface` first, and branch on its Status:**

- **`not yet designed`** — the normal path. Continue to Step 2.
- **`handed to impeccable`** — a previous run reached the handoff and never came back (see Step 3).
  The surface may already exist. **Do not re-invoke impeccable.** Skip to Step 5 and record what is
  actually in the tree on the branch the stamp names. If the tree holds nothing, say so and ask
  whether to restart the handoff.
- **`recorded`** — this surface is already designed and inventoried. Say so and stop; re-designing
  it is a `/ajian-design NN` the user must ask for deliberately, not one you decide on.

## Step 2 — Derive PRODUCT.md (lazy projection of the blueprint)

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

## Step 3 — Mark the handoff before you make it

You are about to hand control to another skill. It has its own flow, its own gates, and its own
closing breadcrumb — and it does not owe you a return. Steps 5 and 6 below may simply never run.

So write the record of the handoff **now**, while you still hold the turn. In the work order's
`## Built surface`:

- **Status:** `handed to impeccable`
- **Branch:** the branch impeccable's output must land on — the one `ajian-build` will extend

Commit that. It costs one commit and it converts the failure mode from silent to loud: if control
never returns, the stamp is on disk, `ajian-plan` refuses the work order until the inventory is
real, and re-running `/ajian-design NN` resumes at Step 5 instead of building the surface twice.
Without it, an interrupted handoff looks exactly like a work order that was never designed — and
the next skill down cheerfully plans screens that already exist.

## Step 4 — Invoke impeccable (new-work)

Hand the surface to impeccable and let it run its own flow, seeded with the design brief so its
interview collapses to a confirmation rather than a fresh interrogation:

1. Enter impeccable's **new-work** flow (`/impeccable` for a new surface or replacement world).
   Give it the work order's design brief up front: the **mode** (Persuade / Operate / Read /
   Experience), what changes the work, the key states (empty, loading, error, success), and the
   `DESIGN-SYSTEM.md` constraints. Let impeccable run its own concept and direction machinery — the
   world it invents is its call, not ajian's. Honor its gates (the direction decision is the
   user's).
2. Let impeccable build the surface and write/replace `DESIGN.md` as its flow dictates.

**Its setup is its own — never run impeccable's scripts for it.** Loading product and design context
is impeccable's own Setup step, and its instructions already tell it how to locate its base
directory on any install layout. Reproducing that step here is exactly how this skill acquired a
hardcoded path that broke on every layout it had not anticipated. impeccable knows where it lives;
ajian does not need to.

Do not reimplement any of impeccable's steps here. If impeccable asks for something the blueprint
already settled, answer from the blueprint; if it surfaces a genuine new decision, that is the
user's to make.

## Step 5 — Record the realised design

`DESIGN.md` is the realised visual source of truth. new-work normally writes or replaces it; if for
any reason the built surface is not reflected in `DESIGN.md`, run `/impeccable document` to record
the design system from the shipped artifact. Confirm `DESIGN.md` and the `.impeccable/` sidecar
exist and match what was built.

If the build revealed a durable constraint the blueprint should own (a brand commitment, an a11y
rule), fold it back into `docs/DESIGN-SYSTEM.md` — the thin constraints stay in the blueprint,
the realised system stays in `DESIGN.md`.

## Step 6 — Record the inventory, then hand off

The surface now exists as real code in the tree. Everything downstream has to know that, or it will
build it a second time. Two things make the handoff survive:

**Commit it where the build will find it.** Commit the built surface, `DESIGN.md`, and
`.impeccable/` **on the branch `ajian-build` will extend** — the branch Step 3 stamped. A surface
committed on a branch the build never sees is a surface the build rebuilds.

**Complete the work order's `## Built surface` section** in `docs/work-orders/NN-<slug>.md`. Step 3
already stamped the Status and the branch; now fill in the files impeccable created or replaced and
what it left stubbed for the build (data, state, routing, tests), and move the Status from
`handed to impeccable` to **`recorded`**. That flip is what releases the work order: `ajian-plan`
refuses to plan a UI work order at any other Status. Commit the work order with it.

Be exact about the file list; `ajian-review` scopes its Standards axis by it, so a path missing here
gets audited against `CONVENTIONS.md` as if ajian had written it.

**→ Next: `/ajian-plan NN`** (or `/ajian-map` if unsure).
