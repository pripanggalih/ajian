# ajian-review

## What it does

Reviews a finished build on **two independent axes** and integrates the branch. **Standards** —
does the diff follow `CONVENTIONS.md`, `QUALITY.md`, and the Fowler smell baseline? **Spec** — does
it faithfully implement the work order? The two run as parallel sub-agents and are reported side by
side, never reranked. You respond to findings with the receiving-code-review discipline (verify
before implementing, no performative agreement, push back with reasoning), fix in one wave, tick the
`ROADMAP` line, then finish the branch (merge / PR / keep — your choice).

## When to reach for it

- After `ajian-build` leaves a green, committed branch.
- Any time you want a two-axis review of a branch against a fixed point.

## Common questions

- **Why two separate axes?** Code can pass one and fail the other — follow every convention but build
  the wrong thing, or build the right thing but break conventions. Separating them stops one from
  masking the other.
- **How are findings fixed?** One fix wave (a single subagent with the full confirmed list), in order
  — blocking/security first — then a fresh re-verification. Not one fixer per finding.
- **Does it decide the merge?** No. It presents the merge / PR / keep menu and waits — integration is
  your call. Discarding work happens only if you explicitly ask.
- **What gets ticked?** The `ROADMAP` line, once the review is clean — that's the project-level record
  of what shipped.

## It's working if

The two axes are reported cleanly and separately, confirmed findings are fixed and re-verified, the
roadmap line is ticked, and the branch is integrated the way you chose — after which `ajian-grill`
starts the next line.
