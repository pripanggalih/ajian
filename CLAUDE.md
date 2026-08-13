# Contributing to ajian

This repository is a **skillset**, not an application. It ships prose that shapes
how an AI coding agent behaves. Treat the words as the product.

## What lives here

```
.claude-plugin/   plugin + marketplace manifests
skills/           the seven skills — SKILL.md + references/ + assets/ each
docs/             ajian-blueprint.md (the design reference) + en/ + id/ user docs
README.md         English (default) · README.id.md  Indonesian
NOTICE.md         honest attribution of the four upstream sources
```

The complete, locked design is in [`docs/ajian-blueprint.md`](docs/ajian-blueprint.md).
Read it before changing any skill — the skills are an implementation of that
document, and a change that contradicts it is a bug in one of the two.

## The rules that keep this repo honest

1. **Fidelity to upstream.** Vendored text is copied nearly verbatim and only
   wired at the seams. If you rewrite a vendored passage, you are taking on its
   maintenance and weakening the attribution — do it only when the workflow
   genuinely diverges, and say so in the file.
2. **Every vendored file carries an `Adapted from <source>` line.** Keep it.
   `NOTICE.md` is the ledger; the per-file line is the point-of-use credit.
3. **Skills are English only.** They are agent-facing. User-facing docs
   (`README*`, `docs/en`, `docs/id`) are dual-language: English is the source of
   truth, Indonesian mirrors it.
4. **Frontmatter is load-bearing.** Every `SKILL.md` needs `name` (lowercase,
   hyphenated, `ajian-*`) and a `description` written as *when to reach for this*
   — that string is all the router and the harness see before loading the body.
5. **No hooks.** Chaining is explicit: each skill ends with a `→ Next` breadcrumb,
   and `ajian-map` reads project state to tell the user where they are.

## Before you push

- Confirm the change still matches `docs/ajian-blueprint.md`, or update both.
- Keep `NOTICE.md` accurate if you add, drop, or re-source any vendored block.
- The repository stays **private** until the `discussion-to-blueprint` license
  question in `NOTICE.md` is resolved.
