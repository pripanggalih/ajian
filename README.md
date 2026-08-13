# Ajian

> **Status: design locked, skills implemented.** **[Bahasa Indonesia →](README.id.md)**

`ajian` (Javanese: an incantation of power — each skill is one *ajian*) is a skillset for AI coding
agents that turns a free-form idea into durable development documents, then builds the project one
work-order at a time through an explicit, gated sequence of skills. **No session hooks.** Greenfield
and brownfield. Framework- and harness-agnostic.

Its foundation-document machinery is the author's own work; on top of that it stands on the
shoulders of three excellent projects, whose text it vendors and adapts (or, for impeccable, depends
on). Full, honest attribution is in [`NOTICE.md`](NOTICE.md):

- **[obra/superpowers](https://github.com/obra/superpowers)** (MIT) — planning & execution
- **[mattpocock/skills](https://github.com/mattpocock/skills)** (MIT) — the grilling engine, 2-axis review, router
- **[impeccable](https://github.com/pbakaus/impeccable)** (Apache-2.0) — UI/UX craft

## The flow

```
idea  (or a project you inherited)
  → ajian-adopt             only if docs already exist in another shape — survey, map, migrate
  → ajian-blueprint         grill the idea (grill-1), write the foundation docs + roadmap
  → per roadmap row, top to bottom:
      ajian-grill           recon the real code (grill-2), sharpen the work order to buildable
      ajian-design          (UI only) hand the surface to impeccable → DESIGN.md
      ajian-plan            turn the work order into a bite-sized implementation plan
      ajian-build           run the whole plan in one subagent, commit per task, ledger = checkboxes
      ajian-review          2-axis review, then finish the branch
  → next row
```

`ajian-map` is the state-aware router: run it any time to find out where you are and what's next.

## Skills

| Skill | Role |
| --- | --- |
| `ajian-map` | state-aware router — reads the project, says where you are and what to run next |
| `ajian-adopt` | bring an inherited project onto the pipeline — survey its docs, map them in, repair drift |
| `ajian-blueprint` | interrogate the idea, write the foundation docs + roadmap + work-orders |
| `ajian-grill` | recon the real code before a work-order, sharpen it from brief to buildable |
| `ajian-design` | derive PRODUCT.md from the blueprint, invoke impeccable to build the UI |
| `ajian-plan` | turn a work-order into a bite-sized implementation plan (checkboxes = ledger) |
| `ajian-build` | execute the plan in one fresh subagent, commit per task, review saved for the end |
| `ajian-review` | 2-axis code review (Standards + Spec), then finish and merge the branch |

Per-skill pages (What it does / When to reach for it / Common questions / It's working if) live in
[`docs/en/`](docs/en/). The complete, locked design is in
[`docs/ajian-blueprint.md`](docs/ajian-blueprint.md).

## Install

Install from the [skills.sh](https://www.skills.sh) directory with the
[vercel-labs `skills`](https://www.skills.sh) CLI:

```bash
npx skills add pripanggalih/ajian
```

Install a single skill, update, or remove:

```bash
npx skills add pripanggalih/ajian --skill ajian-build
npx skills update
npx skills remove ajian-build
```

`ajian-design` needs impeccable, installed separately:

```bash
npx impeccable install
```

## What ajian does not do

- No session hooks. Chaining is explicit, via each skill's `→ Next` breadcrumb and `ajian-map`.
- No "ajian" branding in your work project. It writes generic `docs/`, `PRODUCT.md`, `DESIGN.md`.
- No per-task code review. The review runs once, at the end of each work order.

## License & attribution

MIT ([`LICENSE`](LICENSE)) for ajian's own work; vendored upstream text keeps its own notices in
[`NOTICE.md`](NOTICE.md).
