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
3. **Skill bodies are English; skill *output* follows the user.** The prose in
   `SKILL.md` is English because it is agent-facing — that is not a rule about what
   language the agent answers in. Every skill carries a `## Language` section saying
   so, because without it the quoted gate texts read as strings to copy verbatim and
   an Indonesian user gets their six most important decisions in English. User-facing
   docs (`README*`, `docs/en`, `docs/id`) are dual-language; keep the two in sync.
4. **Frontmatter is load-bearing.** Every `SKILL.md` needs `name` (lowercase,
   hyphenated, `ajian-*`) and a `description` written as *when to reach for this*
   — that string is all the router and the harness see before loading the body.
5. **No hooks.** Chaining is explicit: each skill ends with a `→ Next` breadcrumb,
   and `ajian-map` reads project state to tell the user where they are.
6. **Three shared texts are duplicated, not factored out.** `## Language` and
   `## The gate protocol` appear inline and byte-identical in all **seven** skills;
   `### When a precondition fails` in the **six** that have preconditions (`ajian-map` has none — it is the
   skill you run *because* the state is unclear, so a precondition would give a dead
   end to the one skill whose job is to open one). They are duplicated because
   `npx skills add --skill ajian-build` installs a single skill directory: a shared
   reference file would resolve to a path absent on the user's machine — the same
   class of bug as the hardcoded impeccable path. Change each in all its copies or
   in none:

   ```bash
   dup() { for f in skills/*/SKILL.md; do sed -n "$1" "$f" | shasum | cut -c1-12; done \
             | grep -v da39a3ee5e6b | sort -u | wc -l; }   # must print 1 for each
   dup '/^## Language$/,/^which is the same as not having one\.$/p'
   dup '/^## The gate protocol$/,/^This block is identical in every ajian skill\./p'
   dup '/^### When a precondition fails$/,/^missing step without asking is the same failure/p'
   ```

## Before you push

- Confirm the change still matches `docs/ajian-blueprint.md`, or update both.
- Keep `NOTICE.md` accurate if you add, drop, or re-source any vendored block.
- Run the gate-protocol identity check above.
