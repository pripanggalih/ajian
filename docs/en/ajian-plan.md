# ajian-plan

## What it does

Turns one detailed work order into a bite-sized **implementation plan** — the *how*. It reads the
work order and the blueprint documents its anchors name, then writes tasks with exact files,
interfaces (Consumes/Produces), and TDD-shaped steps (write the failing test, watch it fail, minimal
code, watch it pass, commit). The plan is saved to `docs/plans/NN-<slug>.md` and **committed** — its
`- [ ]` checkboxes become the ledger `ajian-build` ticks as it goes.

## When to reach for it

- After a work order is `detailed` (and, if it has UI, after `ajian-design`).
- Whenever `ajian-map` says the current line has no plan yet.

## Common questions

- **Isn't this what the work order already said?** No — the work order owns *what must be true*; the
  plan owns *how*, in code-level steps. Two layers, no overlap.
- **My plans keep getting too big and the model stalls halfway.** ajian-plan has a size guard: if the
  plan runs past ~a dozen tasks or gets too long to hold in one context, the **work order (or its
  roadmap line) was mis-sized** — it stops and sends it back to `ajian-grill` / the roadmap to split,
  instead of writing a giant plan that fails mid-run.
- **The UI is already built — what do I plan?** On a UI work order `ajian-design` left real screens
  in the tree. The plan reads the work order's `## Built surface` inventory and plans the *wiring*
  — data, state, routing, tests — opening with an `## Existing surface` block that tells the
  executor which files not to recreate. Re-specifying visual craft is out of bounds; if the surface
  is wrong, that's a `/ajian-design NN` problem.
- **No placeholders?** Right — every step carries the actual content; "add error handling" or "similar
  to Task N" are plan failures.

## It's working if

Every spec requirement maps to a task, types and signatures are consistent across tasks, there are no
placeholders, and the committed plan is small enough for one build session.
