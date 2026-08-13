<!-- Original ajian wiring. The catalogue of artifact shapes the current skills expect, and the
     older shapes still found in projects. Detection is by shape, never by a version stamp — see
     locked decision 15 in docs/ajian-blueprint.md for why. -->

# Shape drift — what the current skills expect, and what older projects have

A project carries no record of which version of these skills wrote its documents, and deliberately
so: a version field is only as good as the discipline that increments it, and a stale one is worse
than none because the reader believes it. So drift is found by **reading the artifact**.

## How to use this

For each ajian artifact present in the project, check it against its row. A missing element is a
repair for Step 4 — **add the element, do not rewrite the document.** An old work order that still
says the right thing is not a defect, and rewriting it discards the wording someone approved at a
gate.

Every repair below is additive and safe to apply without asking. Anything that would change what a
document *says*, rather than what shape it is in, goes to the Step 3 gate instead.

## The catalogue

### `docs/work-orders/NN-<slug>.md`

| Element | Expected | If missing |
| --- | --- | --- |
| `Depth:` field | `brief` or `detailed` | Infer from content: flows, edge cases, contracts present → `detailed`; otherwise `brief`. Say which you chose and why. |
| `## Built surface` (UI work orders only) | present, with a `Status:` line reading `not yet designed`, `handed to impeccable`, or `recorded` | **The most consequential drift.** Add the section. Set `Status: recorded` **only** if the surface demonstrably exists and the file list can be filled from the tree; otherwise `not yet designed`. Guessing `recorded` makes `ajian-plan` wire up screens that were never built. |
| `## Built surface` present but no `Status:` line | — | Written before Status existed. Add the line, inferring from whether the file list is filled. |
| `Interface: yes\|no` on the header line | present | Infer from whether the work order names screens, and record it. |

### `docs/ROADMAP.md`

| Element | Expected | If missing |
| --- | --- | --- |
| Table with `#`, `Done`, `Feature`, `Depends on`, `Depth`, `Work order` | present | Add the missing columns; never renumber the `#` column. |
| Build order read from **row position** | rows in build order | Older roadmaps encoded order in the number, which agrees with row order until something is inserted. Nothing to repair — the two rules coincide while numbers run in sequence. |
| One work order file per row | every row's `Work order` path resolves | A row with no file is a gap for Step 4. A file with no row is the more dangerous direction: it will never be built. Report both. |

### `docs/DECISIONS.md` and `docs/decisions/`

| Element | Expected | If missing |
| --- | --- | --- |
| Split ADRs — one file per decision under `decisions/`, plus a thin ledger | both present | A single monolithic `DECISIONS.md` holding full ADR bodies predates the split. Extract each decision to its own file and reduce the ledger to status rows. This is a move, not a rewrite: keep each ADR's text. |
| `Status:` per ADR, including `open` | present | Add it. An ADR with no status is read as settled, which is how a real open question gets built over. |

### `docs/plans/` and `docs/plans/reports/`

| Element | Expected | If missing |
| --- | --- | --- |
| Plans at `docs/plans/NN-<slug>.md`, committed | present in git | An uncommitted plan has no ledger. If checkboxes are ticked but the plan is untracked, say so — the build's record of itself is missing. |
| Build reports at `docs/plans/reports/NN-<slug>.md` | reports in the `reports/` subfolder | Older builds wrote reports beside the plans. Move them; the folder split exists so `docs/plans/` holds plans only. |

### `docs/INDEX.md`

| Element | Expected | If missing |
| --- | --- | --- |
| Routing table covering every document that exists | rows match reality | Rebuild the table from what is actually present. An INDEX that routes to a deleted file is worse than no INDEX. |
| Pointer block in `AGENTS.md` / `CLAUDE.md` / `.cursor/rules/` / README | present | Add it, matching whichever entry point the repo already uses. |

### Root-level

| Element | Expected | If missing |
| --- | --- | --- |
| `PRODUCT.md` provenance header | says it is derived and must not be hand-edited | Add the header. If the file has clearly been hand-edited since derivation, do **not** silently re-derive — report it at the Step 3 gate. |
| `DESIGN.md` and `.impeccable/` | both present, or both absent | One without the other means an interrupted impeccable run. Report it; do not reconstruct either. |

## What this file does not cover

Content correctness. A `DATA-MODEL.md` describing entities the code no longer has is stale, not
misshapen, and this skill only reports it — correcting it is `ajian-blueprint`'s resumed mode,
which reconciles documents against the code that shipped.
