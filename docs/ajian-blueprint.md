# Ajian — Skillset Blueprint

> Status: **design locked, skills implemented.** This document is the design
> reference behind the `ajian` skillset. The seven skills, references, assets,
> and dual-language docs now exist under `skills/` and `docs/`.

`ajian` (Javanese: an incantation of power — each skill is one *ajian*) turns a
free-form idea into durable development documents, then builds the project one
work-order at a time through an explicit, gated sequence of skills. No session
hooks. Greenfield and brownfield. Framework- and harness-agnostic.

The output artifacts deliberately **feel identical** to the source skills: their
text is vendored nearly verbatim and only wired together at the seams.

---

## 1. Essence

```
wild idea
  → durable blueprint docs (the reference every agent obeys)
  → per work-order:  grill facts → design UI → plan → build → review
  → repeat down the roadmap
```

Each altitude is owned by a different layer, so nothing collides:

| Layer | Owns | Source |
| --- | --- | --- |
| grill (interrogation) | *is the idea right?* | mattpocock `grilling` mechanic |
| blueprint | *what must be true when done* | author's own foundation-doc work |
| plan | *how to get there* (steps + code) | superpowers `writing-plans` |
| build | *do it, with recovery* | superpowers `executing-plans` + SDD ledger |
| design | *the visual world* | impeccable |
| review | *is it correct & faithful* | mattpocock 2-axis + superpowers receiving |

---

## 2. Provenance (vendored vs depended)

| Block | Source | Use |
| --- | --- | --- |
| interrogation engine | mattpocock `grilling` | **vendored** |
| foundation docs + roadmap + work-orders | author's own foundation-doc work | **own** |
| implementation plan | superpowers `writing-plans` | **vendored** |
| execution | superpowers `executing-plans` + SDD ledger/commit-per-task + `using-git-worktrees` + `finishing-a-development-branch` + `tdd` + `verification-before-completion` | **vendored** |
| code review | mattpocock `code-review` (2-axis) + superpowers `receiving-code-review` | **vendored** |
| UI/UX | impeccable | **depended** (invoked via `/impeccable`, not copied) |
| router | mattpocock `ask-matt` structure | **vendored** |

impeccable is a full CLI + skill (npx, scripts, subagents); it is too large to
vendor and is installed separately. Everything else is prose we copy and adapt.
`NOTICE.md` credits the upstream sources honestly; every copied file carries an
`Adapted from <source>` header line.

---

## 3. The seven skills

Installed and named `ajian-<name>` (hyphen prefix = collision guard, and it is
what the `skills` CLI uses for identity). Invoked e.g. `/ajian-build 03`.

| Skill | Role | Output | → Next |
| --- | --- | --- | --- |
| **`ajian-map`** | state-aware router; reads artifacts (blueprint exists? work-order Depth? plan file? git state?) → "you are at WO-03, next: build" | — | points to a skill |
| **`ajian-blueprint`** | grill-1 (hybrid, per-theme, one continuous session) → foundation docs flat in `docs/` + ROADMAP + work-orders (all brief) | foundation docs | `grill 01` |
| **`ajian-grill`** | grill-2 per work-order: recon the real code (subagent), promote brief→detailed, cover design questions if UI, write surface brief | detailed WO + surface brief | UI? `design` : `plan` |
| **`ajian-design`** | derive `PRODUCT.md` lazily → invoke impeccable (surface brief → new-work → `/document`) → record the file inventory in the work order's `## Built surface` | `DESIGN.md` + UI | `plan` |
| **`ajian-plan`** | writing-plans reads detailed WO + anchored blueprint docs → bite-sized plan | plan file | `build` |
| **`ajian-build`** | execute the plan in **one fresh subagent**, commit-per-task + ledger, **no per-task review** | code + commits | `review` |
| **`ajian-review`** | code-review 2-axis (mattpocock) + receiving-code-review discipline → finishing branch | verdict + merge | tick ROADMAP, `grill NN+1` |

---

## 4. Pipeline

```
IDEA
 └ ajian-blueprint   grill-1 → docs/ (foundation) + roadmap + work-orders (brief)
                     [Gate: foundation]  [Gate: roadmap — sizing is CRITICAL]

 per work-order (in order, or optional parallel):
   ├ ajian-grill     grill-2 recon real code → promote to detailed
   │                 (+ design questions if UI)                 [Gate]
   ├ ajian-design    (UI only) impeccable new-work → DESIGN.md
   ├ ajian-plan      writing-plans → plan            [Gate: approve plan]
   ├ ajian-build     one subagent + ledger + commit-per-task (no inline review)
   └ ajian-review    2-axis review + finishing branch [Gate: handle findings]
   → ajian-map tells you the next work-order
```

Two grill stages, two characters:

- **grill-1 (macro / foundation):** decision-heavy, you decide. Per-theme, paced,
  a recommendation on every question. Greenfield: help choose the stack, roadmap
  #1 is a walking skeleton. Brownfield: scan the repo first, record the stack
  verbatim.
- **grill-2 (micro / per work-order):** fact-heavy, the agent reads the real code
  (previous work-orders have shipped). Only genuine decisions reach you. Promotes
  the work-order brief→detailed and, for UI, gathers the design brief.

---

## 5. Locked decisions (13)

1. **Hybrid grill engine.** mattpocock frontier/rounds mechanic, **railed by the
   six blueprint themes** (guarantees coverage of non-goals, stack, entities,
   quality), **bounded per-theme** to avoid overwhelm, **a recommendation on
   every question**.
2. **Two grill stages.** grill-1 macro (in `blueprint`); grill-2 micro (in
   `grill`), reading real code.
3. **Just-in-time depth.** Work-orders are born brief; grill-2 promotes the
   current one to detailed; only one detailed at a time. `plan` owns the *how*,
   the work-order owns the *what* — two layers, no conflict.
4. **Work-order → plan directly.** No to-tickets layer. Decomposition already
   happens at the roadmap and inside writing-plans.
5. **Roadmap is the backbone.** Its gate is a mini-interrogation; each line must
   pass sizing (one build session) / slice (vertical, demoable) / order
   (dependency, risk, thinnest-first). The value of `to-tickets` sizing lives
   here, as rails — not as a layer.
6. **Glossary.** `docs/GLOSSARY.md`, in mattpocock `CONTEXT.md` format (with the
   `_Avoid_:` synonym discipline).
7. **ADRs.** One file per ADR at `decisions/NNNN-*.md` (context-thrifty, attach
   one at a time) + a thin ledger `DECISIONS.md` (status + open ADRs).
8. **PRODUCT.md** is a lazy derived projection of the blueprint, generated at the
   first impeccable call; a mini-interview only fills the gaps; a provenance
   header says "do not hand-edit".
9. **Design split.** `DESIGN-SYSTEM.md` = thin *constraints* (a11y baseline +
   brand non-negotiables). `DESIGN.md` (impeccable) = the *realized* visual
   system, invented by new-work. Skeleton UI stays unstyled until the first UI
   feature.
9b. **The built surface is handed over, not rebuilt.** On a UI work order,
    `ajian-design` leaves real code in the tree before the plan exists. It records
    the file inventory in the work order's `## Built surface` (branch, files, what
    is still stubbed) — the work order is the channel because `ajian-plan` reads it
    first. `ajian-plan` then plans the *wiring* and forbids recreating those files;
    `ajian-build`'s executor is told they exist; `ajian-review` excludes them from
    the Standards axis (impeccable's craft already passed its own direction gate)
    and tells the Spec axis they predate the fixed point, so UI acceptance criteria
    are not reported as unimplemented.
10. **Executor.** Custom executing-plans = one fresh subagent, **the plan file's
    `- [ ]` checkboxes are the ledger** (committed, survives compaction),
    commit-per-task, **review once at the end** (not SDD's slow/expensive
    per-task review). Resume = read ticked checkboxes + `git log`. No hidden
    runtime folder.
11. **Code review.** mattpocock 2-axis (Standards = Fowler smells + repo
    standards; Spec = faithful to the work-order) + receiving-code-review for how
    to respond to findings.
12. **No hooks.** Chaining via `→ Next` breadcrumbs at the end of each skill +
    the state-aware `ajian-map`.
13. **Parallelism.** Default sequential. **Intra-task parallel is rejected**
    (tight coupling → semantic bugs). Parallel only across **independent
    work-orders** (opt-in, git worktrees, gated by dependency edges + a conflict
    scan); interactive phases (grill/design) stay sequential — only plan+build
    fan out.

---

## 6. Artifact map (inside the target project)

Nothing here is branded `ajian` — the work project stays generic. Foundation
docs sit flat in `docs/` (no `blueprint/` nesting), level with impeccable's
root-fixed `PRODUCT.md`/`DESIGN.md`.

```
<project root>
  PRODUCT.md               (lazy derived, owned by impeccable — root, fixed)
  DESIGN.md                (owned by impeccable, visual source of truth — root, fixed)
  .impeccable/             (impeccable sidecar)
  docs/
    INDEX.md               (front door + routing table; AGENTS.md points here)
    PRD.md  ARCHITECTURE.md  CONVENTIONS.md  QUALITY.md  ROADMAP.md
    GLOSSARY.md            (CONTEXT.md format, with _Avoid_)
    DATA-MODEL.md          (only if there is data)
    DESIGN-SYSTEM.md       (thin constraints, only if there is UI)
    DECISIONS.md           (ADR ledger)
    decisions/NNNN-*.md    (one ADR per file)
    work-orders/NN-*.md    (brief → detailed when its turn comes)
    plans/NN-<slug>.md     (committed; the plan's checkboxes are the build ledger)
    plans/reports/NN-<slug>.md  (one build report per plan — the executor's verification evidence)
```

`PRODUCT.md`/`DESIGN.md` cannot move into `docs/` — impeccable's `context.mjs`
reads them from the repo root, and impeccable is depended on, not vendored.

A pointer block is wired into the target project's `AGENTS.md`/`CLAUDE.md` by
`ajian-blueprint` (pointing at `docs/INDEX.md`), so any agent opening the project
discovers the docs.

---

## 7. Repository layout (the deliverable)

```
ajian/
├── .claude-plugin/
│   ├── plugin.json              manifest (name: ajian, declared skills)
│   └── marketplace.json         (optional)
├── skills/
│   ├── map/SKILL.md
│   ├── blueprint/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   │   ├── grill-engine.md        grilling + hybrid theme rails + rounds
│   │   │   ├── depth-and-drift.md     (vendored, EDITED: a downstream now exists)
│   │   │   ├── doc-charters.md        (vendored)
│   │   │   └── roadmap-sizing.md      (NEW: sizing tests, when to split)
│   │   └── assets/                    document templates
│   │       ├── INDEX / PRD / ARCHITECTURE / CONVENTIONS / QUALITY / ROADMAP
│   │       ├── GLOSSARY (CONTEXT.md format)  DATA-MODEL  DESIGN-SYSTEM
│   │       ├── DECISIONS-ledger  adr  work-order
│   ├── grill/   SKILL.md + references/   (real-code recon + design-question coverage)
│   ├── design/  SKILL.md + references/   (impeccable handoff: derive PRODUCT, seed DESIGN)
│   ├── plan/    SKILL.md + assets/       (writing-plans + plan template)
│   ├── build/   SKILL.md + references/   (custom executing-plans + ledger format + resume)
│   └── review/  SKILL.md + references/   (2-axis + receiving discipline)
├── docs/
│   ├── ajian-blueprint.md       (this file)
│   ├── en/                      usage guide + per-skill pages (default)
│   └── id/                      Indonesian mirror
├── README.md                    English (default)
├── README.id.md                 Indonesian
├── LICENSE
├── NOTICE.md                    honest attribution of the four sources
├── CHANGELOG.md
└── AGENTS.md → CLAUDE.md         contributor guidance
```

Dual-language rule: **skills (agent-facing) are English only**; **user-facing
docs (README, docs/) are dual EN + ID**. Per-skill doc pages follow the
four-section format: What it does / When to reach for it / Common questions /
It's working if.

Agent-ease is provided by four mechanics, so "complete" never means "heavy
context": `ajian-map` as the runtime entry, SDO-optimized `description`
frontmatter (when-to-use only), progressive disclosure (references/assets loaded
just-in-time), and the `AGENTS.md` pointer in the target project.

---

## 8. Install & update (via skills.sh / vercel-labs `skills` CLI)

No custom installer. The public `skills` CLI reads any public GitHub repo whose
skills sit at `skills/<name>/SKILL.md` with `name` + `description` frontmatter —
which this repo satisfies.

```bash
npx skills add pripanggalih/ajian                    # install all ajian skills
npx skills add pripanggalih/ajian --skill ajian-build # one skill
npx skills update                                     # update to latest
npx skills remove ajian-build
npx skills list
```

- Symlink by default (single canonical copy + per-agent links); `--copy` fallback.
- Auto-detects harnesses (Claude Code, Cursor, Codex, …). Scope: project default,
  `-g` global.
- impeccable is a separate dependency: `npx impeccable install`.
- Being a public GitHub repo is enough to appear in the skills.sh directory.

---

## 9. Before implementation (checklist)

- Vet each source's LICENSE before vendoring its text; write `NOTICE.md`.
- Fill the grill-1 theme rails + round format (splice grilling text into
  blueprint step 2).
- Write `roadmap-sizing.md` (task/plan caps, when to split a line).
- Specify `ajian-map` state detection (Depth field, plan file, git state).
- Specify the `ajian-build` ledger format + resume behavior.
- Specify the conflict-scan gate for optional parallel work-orders.
- Author `plugin.json` + repo scaffolding (README ×2, LICENSE, NOTICE).
```
