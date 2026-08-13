<!-- Original ajian wiring. Describes how PRODUCT.md (read by impeccable's context.mjs) is derived
     from the ajian blueprint instead of by impeccable's interactive init. The PRODUCT.md field set
     follows impeccable's init charter; the sources are the blueprint documents. See NOTICE.md. -->

# Deriving PRODUCT.md from the blueprint

impeccable expects `PRODUCT.md` at the repo root, holding durable product truth. In ajian that
truth is already decided and recorded in the blueprint, so PRODUCT.md is a **projection**, not a
fresh interview. Generate it once, at the first `ajian-design` call, then treat it as derived.

## Provenance header (always first)

Stamp the file so no one hand-edits a projection:

```markdown
<!-- DERIVED FILE — do not hand-edit.
     Projected from the ajian blueprint (docs/PRD.md, docs/ARCHITECTURE.md, docs/GLOSSARY.md,
     docs/DESIGN-SYSTEM.md) by ajian-design. To change product truth, change the blueprint and
     re-derive. Gap-fill answers captured interactively are marked (gap-fill) inline. -->
```

## Field mapping

Fill PRODUCT.md's fields from the blueprint. Copy meaning, not prose — keep it in impeccable's
shape:

| PRODUCT.md field | Source in the blueprint |
| --- | --- |
| Primary user, situation, job-to-be-done | `PRD.md` — users and jobs-to-be-done |
| Purpose, what the product makes possible, positioning / mechanism | `PRD.md` — why this exists, the differentiator |
| Capabilities | `PRD.md` — the v1 feature list (as capabilities, not tasks) |
| Constraints, durable product facts to preserve | `PRD.md` non-goals + `ARCHITECTURE.md` NFRs |
| Terminology | `GLOSSARY.md` — the domain terms (keep the `_Avoid_` discipline) |
| Platform (`web` / `ios` / `android` / `adaptive`) | `ARCHITECTURE.md` — the stack and target |
| `## Stack` | `ARCHITECTURE.md` — stack and versions (or "delegated" if the blueprint left it to the builder) |
| Accessibility baseline | `DESIGN-SYSTEM.md` — the a11y constraints |
| Brand commitments, confirmed assets, voice | `DESIGN-SYSTEM.md` — brand non-negotiables |

## The gap-fill round

The blueprint may not carry everything impeccable's init would (a logo file, a proof asset, a
platform nuance). After projecting, ask **one short round** — at most three focused questions — only
for material gaps the blueprint genuinely does not answer. Mark each captured answer `(gap-fill)`
inline. Never re-ask what the blueprint already settled; never ask for aesthetic direction, colors,
or typography here — that is impeccable's to invent in new-work.

## What NOT to put in PRODUCT.md

- No visual world, tokens, or DESIGN.md content — that is impeccable's, invented in new-work.
- No implementation detail or per-feature specifics — those live in work orders and plans.
- No decisions the blueprint has not made — record an undecided fact rather than inventing one.
