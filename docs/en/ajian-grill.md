# ajian-grill

## What it does

Takes one work order from `Depth: brief` to `Depth: detailed`, against the code that actually exists.
It runs **grill-2** — the micro interrogation: it dispatches a subagent to recon the real code and
starts asking straight away rather than waiting for it, answers most of the brief's open questions
from what recon finds, and puts to you only the genuine decisions (each with a recommendation). It fills in flows, edge cases, contracts, and data effects —
deeper on *what must be true*, never *how*. For a UI feature it also gathers the surface's design
brief (mode, key states, constraints) for `ajian-design`.

## When to reach for it

- Right before building a roadmap line, once its dependencies have shipped.
- Whenever `ajian-map` says the current work order is still `brief`.

## Common questions

- **Why grill again after the blueprint?** The blueprint decided the project's shape against an
  imagined future; grill-2 decides this feature's exact shape against real, shipped code. Detail
  written against real code is right; detail written ahead of it has to be unlearned.
- **Will it pester me?** A question reaches you only if the work order listed it as open, or recon
  found two shipped things that conflict. Everything else it answers itself and shows you at the
  gate under `Resolved`, where you overrule any of it in one word.
- **Why does it start asking before recon finishes?** Recon runs underneath the rounds. Only the
  questions that depend on its findings wait for it; the rest go out immediately.
- **Does it plan or write code?** No — it stops at the detailed work order. `ajian-plan` is next.
- **Two work orders detailed at once?** It refuses; only one is detailed at a time, by design.

## It's working if

The promoted work order has concrete flows and resolved questions grounded in real paths and types,
the user was asked only a short, sharp round, and anything project-wide that changed became a new ADR.
