# Changelog

All notable changes to `ajian` are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); this project uses
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2026-08-15

The interrogations were slow, and the cost was not in the questions — it was in the
waiting before them. `ajian-grill` numbered its recon subagent as a pipeline stage ahead
of the grill, so the first round did not go out until a full codebase sweep came back.
`grilling`, the vendored mechanic both grill passes run on, says the opposite in as many
words: *"Don't block on it... ask the rest of the frontier now."* That instruction lived
in `references/grill-engine.md`, which is read at the grill step — by which time the
recon had already blocked. Fixing it makes ajian more faithful to upstream, not less.

### Changed
- **Recon runs underneath the rounds, not in front of them.** `ajian-grill`'s `1 Recon`
  stage is gone; step 1 dispatches recon and opens the first round immediately, and only
  the questions downstream of its findings wait for the report. The non-blocking rule now
  sits in `SKILL.md` where it governs the dispatch, instead of in a reference read after
  it.
- **The brownfield repo scan is a background subagent.** `ajian-blueprint` said *scan the
  repo before step 2*. It now dispatches the scan and starts step 2 anyway: themes 1 and 2
  (problem, users & scope) do not depend on it, so they are asked while it works, and only
  *the stack* and *conventions & quality* wait.
- **Which questions reach the user is a mechanical filter, not a judgement call.** grill-2
  used to admit a question when "two valid answers would change what gets built" — a test
  the model can only settle by simulating each candidate's consequences, on every
  candidate. It is now: the work order listed it as open **(a)**, or recon found two
  shipped things in conflict **(b)**. Everything else is answered with the recommendation
  and shown at the Gate under `Resolved`, where one word overrules it. The upstream
  guarantee that nothing is silently assumed is met by the gate rather than by the asking.
- **Read phases are shorter and parallel where they can be.** `ajian-grill` step 0 reads
  the work order and nothing else — `INDEX.md`, the "Read first" list and the shape of the
  code all move into recon's brief. `ajian-blueprint` reads its `assets/` templates in one
  batch at the top of step 3 instead of one immediately before each file. `ajian-adopt`
  delegates its whole-repo document survey to a subagent rather than pulling every README
  and wiki page through the controller's context.
- **Second-order rationale is cut across all eight skills.** Every rule kept its
  imperative and lost the paragraph defending it; the prohibition density that made the
  model re-audit each step drops with it. The three shared blocks shrink and stay
  byte-identical, and `CLAUDE.md`'s `dup()` sentinels move with them.
- User docs for `ajian-grill` and `ajian-blueprint` say, in both languages, that questions
  start before recon finishes and which ones wait.

### Fixed
- Nothing vendored was touched. `## The mechanic` in both `grill-engine.md` copies is
  byte-identical to `mattpocock/skills` `grilling`, the four superpowers references
  (`using-git-worktrees`, `verification-before-completion`, `receiving-code-review`,
  `finishing-a-development-branch`) and `two-axis-review.md`, `roadmap-sizing.md` and
  `executor-prompt.md` are unchanged, and the 142 lines `ajian-plan` copies from
  `writing-plans` are untouched — only ajian's own additions around them were trimmed.

## [0.2.0] - 2026-08-15

Every skill got shorter without losing a gate. `ajian-plan` had grown to 2.2x its
upstream, and the weight was not the plan-writing prose — that is copied verbatim from
`writing-plans` and still is — but ajian's own additions around it, which asked the model
to *judge* things a shell command answers. Planning was slow and token-hungry compared
with running `writing-plans` directly, which is the comparison that matters: ajian is
supposed to add pipeline seams, not overhead.

### Changed
- **Preconditions are one shell command, not a paragraph of judgement.** Seven skills
  stated their prerequisites as prose and told the model to verify each one from disk
  rather than from the conversation — `ajian-plan` went as far as "the conversation is
  the least reliable record in this pipeline". Read literally, and it was, that forbids
  the model from trusting its own context, so it re-read the work order, the `Depth:`
  field and the `Status:` field on every turn it felt uncertain. Each skill now opens
  with one command whose output answers every precondition at once, followed by one
  line per failure naming the skill that owns it, and the instruction is to run it
  **once** and trust the output for the session. `ajian-map` already read exactly these
  signals, so the prose was duplicating a router that exists.
- **`ajian-plan`'s reads are lazy.** It used to open `ARCHITECTURE.md`, `CONVENTIONS.md`,
  `QUALITY.md` and anything they pointed at before writing a single task, then copy
  Global Constraints verbatim out of all four. The work order is the spec; a blueprint
  document is opened only when a task actually needs it, and `CONVENTIONS.md` /
  `QUALITY.md` only for a constraint the work order references without spelling out.
- **The `Existing surface` branch table replaces three prose branches.** Same three
  outcomes for `recorded` / `not yet designed` / `handed to impeccable`, same refusal to
  infer the inventory from `git diff`, in a third of the words.
- **Gates are emitted as plain markdown, no code fence.** The five stacked fields are
  unchanged and stay stacked — the fence was the problem, not the layout. It made every
  gate in the skills read as a template to be reproduced rather than the shape of what to
  emit, and cost a paragraph in each skill explaining that the fence "only delimits the
  template". The header is now `**GATE — <name>**`; both user READMEs show the same.
- **Skill `description` frontmatter is trigger phrases plus one sentence of scope.** The
  router only ever sees that string, and `ajian-blueprint`'s ran to seventeen lines.
  Every trigger phrase, Indonesian included, is preserved.
- **The three shared blocks are shorter and still byte-identical across all eight
  skills.** `CLAUDE.md`'s `dup()` sentinels move with them.
- Indonesian docs address the reader as **kau** throughout, not `kamu`. The two had
  been mixed by accident; `kau` is the register the author writes in, and the clitic
  `-mu` the docs already used everywhere pairs with it.

### Fixed
- Nothing vendored was touched. The six sections `ajian-plan` copies from `writing-plans`
  — `File Structure`, `Task Right-Sizing`, `Bite-Sized Task Granularity`,
  `Task Structure`, `No Placeholders`, `Self-Review` — are byte-identical to upstream
  before and after, as is `plan-document-reviewer-prompt.md`, and no file under any
  skill's `references/` or `assets/` changed.

## [0.1.0] - 2026-08-14

First tagged release. The eight skills, the locked blueprint they implement, and
the dual-language docs are all in it; everything below was written before this
tag existed, so it is the whole history rather than a delta.

### Added
- Initial eight-skill pipeline: `ajian-map`, `ajian-adopt`, `ajian-blueprint`,
  `ajian-grill`, `ajian-design`, `ajian-plan`, `ajian-build`, `ajian-review`.
- Plugin manifest (`.claude-plugin/plugin.json`) and marketplace entry.
- Dual-language user docs (English default, Indonesian mirror).
- Honest attribution of the upstream sources in `NOTICE.md`.

- **The gate protocol** (locked decision 14). Every gate in every skill is one fixed
  block — `GATE / Done / Evidence / Decide / Risk` — and a stop that omits it is not
  a gate. `Evidence` requires real command output or a committed artifact path, which
  removes the agent's freedom to *assess* that a precondition holds; `Risk` is written
  for a user who cannot audit the work. The block is inlined and byte-identical in all
  eight skills, because the `skills` CLI installs one skill directory at a time and a
  shared reference file would resolve to a path absent on the user's machine.
  `CLAUDE.md` carries the identity check.

- **`ajian-adopt`** (locked decision 16), the eighth skill: bring an inherited
  project onto the pipeline. `ajian-map`'s blueprint signal is a presence check on two
  filenames, so a project whose documents are real but shaped differently read
  identically to one that had none — and `ajian-blueprint` answered by writing a second
  set beside the first. Adopt surveys every document in the repo, proposes a
  per-document mapping, and migrates only what is approved; it leaves a pointer where
  content came from and never deletes, so every move is one `git revert` away. It also
  repairs an older ajian layout by reading artifact **shape** rather than a version
  stamp — a stamp is only as good as the discipline that increments it, and a stale one
  is worse than none. It refuses a project with code and no documents (that is
  `blueprint` brownfield), refuses one already adopted (that is `map`), and never
  invents a roadmap, since the roadmap's sizing gate belongs to `blueprint`.
- **Inserting or changing a feature mid-roadmap**, in `ajian-blueprint`'s resumed mode
  (locked decision 16). Resumed mode already said "add or reorder lines", but only as a
  footnote, and it did the one easy part — writing the row. What was missing is the part
  that makes an insertion different from an extension: a feature arriving mid-project
  almost always touches something already decided or already built. Resumed mode is now
  a full stage with its own gate, and it names the merged work orders the change
  touches, resolves every overlapping unbuilt work order as `superseded by NN` or
  narrowed (the user's choice per overlap — never deleted, since one may already carry a
  plan, a report, or commits), and raises a superseding ADR for every decision the change
  falsifies rather than editing the original. The new row passes the same three sizing
  tests as any Gate 2 row: an insertion arrives as a wish, which is exactly why it is the
  row most likely to be oversized. It stays in `blueprint` rather than becoming a skill
  because the roadmap has one owner; two skills able to reorder its rows is drift that
  stays invisible until it is expensive.
- **Per-skill precondition contracts** (locked decision 15). The seven skills with real
  prerequisites verify them from the artifacts on disk — a file, a `Depth:` field, a
  `Status:` field, a checkbox, `git log` — never from what the conversation appears to
  say happened. On a failure they refuse, then offer **one** step in plain language:
  where you are, which skill owns the gap, run it? One mechanism for both problems —
  downstream it contains a gate that leaked upstream, and upstream it is the
  "you are here, this is next" a user who does not know the pipeline needs.
  `ajian-map` is exempt: it is the skill you run *because* the state is unclear.

- **A language contract in every skill.** Nothing in the skillset had ever said what
  language to *answer* in, so the quoted gate texts — English string literals — read
  as text to copy verbatim. An Indonesian user received their six most consequential
  decisions in English, at precisely the moments comprehension matters most. Each
  skill now carries a `## Language` section: the body stays English because it is
  agent-facing, output follows the user, and quoted gate text is meaning to convey
  rather than a string to copy. Field labels stay fixed so the shape survives
  translation.
- **`ajian-map` now answers to confusion, not just vocabulary.** Its `description`
  triggers on "I'm lost", "where do I start", and the Indonesian a stuck user
  actually types ("saya bingung", "mulai dari mana", "ini lanjut apa"). Only
  `ajian-map` gets these: it is the one skill reached for without knowing the
  pipeline, and spreading them across eight overlapping descriptions would leave the
  router guessing.

### Changed
- **The gate block is bulleted markdown, not wrapped prose.** The five fields are
  unchanged — `GATE / Done / Evidence / Decide / Risk` still define the shape — but every
  gate rendered as five long lines inside a code fence, and each one wrapped. What
  reached the user was a paragraph they had to parse before they could decide, at the
  six moments in the pipeline where a decision is most expensive to get wrong. A gate the
  user cannot scan in one pass is a gate the user approves without reading, which is the
  same walked-through failure the block was written to stop — emphasis had already been
  tried and had already failed. Each field is now a label line with one checkable fact
  per bullet, and the protocol says explicitly that what the agent emits is plain
  markdown, never a code block; the fence in `SKILL.md` only delimits the template. The
  shared block stays byte-identical across all eight skills, the twelve worked examples
  follow it, and both user READMEs and locked decision 14 record the rendering rule.
- **Roadmap row order is build order; the `#` column is a permanent identity.** One
  number used to carry both jobs — naming a work order's files and fixing its place
  in the queue — so inserting a feature mid-build forced a choice between
  renumbering (breaking `work-orders/NN-*`, `plans/NN-*`, `plans/reports/NN-*`, ADR
  references and commit messages) and appending (breaking the order). Splitting them
  retires the choice: rows move, numbers never do, and the column is expected to run
  out of sequence after the first insertion. "Lowest-numbered unticked line" becomes
  "topmost unticked row" in `ajian-map`, `ajian-grill`, `ROADMAP-template` and
  `INDEX-template`; `ajian-review` no longer hands off to `NN+1`, which after any
  insertion points at whichever feature happens to hold that number. Existing
  roadmaps are unaffected — while numbers still run in sequence both rules give the
  same answer.

### Fixed
- `ajian-map`'s UI signal read `DESIGN.md` to decide whether a surface was built. The
  record is the work order's `## Built surface` Status, so an interrupted design
  handoff routed as if design had never run. It now reads the Status and routes
  `handed to impeccable` back to `ajian-design` for recording rather than rebuilding.
- `ajian-build`'s executor report had an undefined destination (`[REPORT_FILE]` was
  never resolved anywhere), so reports landed next to the plans and mixed up
  `docs/plans/`. Reports now go to `docs/plans/reports/NN-<slug>.md`.
- `ajian-design` kept its "impeccable must be installed" check in prose under
  Preconditions while its Pipeline started at Orient, so the check never became a
  step. With impeccable absent, the skill designed and implemented the surface
  itself — landing UI outside the pipeline, with no plan, ledger, or review. The
  check is now a blocking Step 0 that stops, and standing in for impeccable is
  explicitly forbidden.
- Nothing downstream of `ajian-design` knew impeccable had already built the
  surface — `plan`, `build`, and `review` mentioned neither `DESIGN.md` nor the
  built files. Plans could specify screens that already existed, the surface
  could land on a branch the build never saw, the Standards axis audited
  impeccable's generated markup, and the Spec axis reported UI as unimplemented
  when it sat outside the diff. `ajian-design` now records a `## Built surface`
  inventory in the work order and commits on the build's branch; `ajian-plan`
  plans the wiring and forbids recreating those files; the executor is told they
  exist; `ajian-review` scopes them out of Standards and flags them to Spec.

[Unreleased]: https://github.com/pripanggalih/ajian/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/pripanggalih/ajian/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/pripanggalih/ajian/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/pripanggalih/ajian/releases/tag/v0.1.0
