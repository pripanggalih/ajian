# Ajian

> **Work in progress — design locked, not yet implemented.**

`ajian` (Javanese: an incantation of power — each skill is one *ajian*) is a
skillset for AI coding agents that turns a free-form idea into durable
development documents, then builds the project one work-order at a time through
an explicit, gated sequence of skills. No session hooks. Greenfield and
brownfield. Harness-agnostic.

It stands on the shoulders of four excellent projects, whose text it vendors and
adapts (or, for impeccable, depends on):

- [discussion-to-blueprint](https://github.com/) — foundation documents
- [obra/superpowers](https://github.com/obra/superpowers) — planning & execution
- [mattpocock/skills](https://github.com/mattpocock/skills) — the grilling engine & 2-axis review
- [impeccable](https://impeccable.style) — UI/UX craft

Full attribution in [`NOTICE.md`](NOTICE.md).

## The flow

```
idea → blueprint docs → per work-order: grill → design → plan → build → review
```

## Skills

| Skill | Role |
| --- | --- |
| `ajian-map` | state-aware router — where am I, what's next |
| `ajian-blueprint` | interrogate the idea, write the foundation docs + roadmap + work-orders |
| `ajian-grill` | recon the real code before a work-order, sharpen it to buildable |
| `ajian-design` | invoke impeccable to build the UI world |
| `ajian-plan` | turn a work-order into a bite-sized implementation plan |
| `ajian-build` | execute the plan in an isolated subagent with recovery |
| `ajian-review` | 2-axis code review, then finish the branch |

## Install

```bash
npx skills add pripanggalih/ajian
npx impeccable install   # UI dependency
```

Update with `npx skills update`.

## Design reference

The complete, locked design lives in
[`docs/ajian-blueprint.md`](docs/ajian-blueprint.md).
