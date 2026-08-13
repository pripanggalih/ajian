# Changelog

All notable changes to `ajian` are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); this project uses
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial seven-skill pipeline: `ajian-map`, `ajian-blueprint`, `ajian-grill`,
  `ajian-design`, `ajian-plan`, `ajian-build`, `ajian-review`.
- Plugin manifest (`.claude-plugin/plugin.json`) and marketplace entry.
- Dual-language user docs (English default, Indonesian mirror).
- Honest attribution of the upstream sources in `NOTICE.md`.

- **The gate protocol** (locked decision 14). Every gate in every skill is one fixed
  block — `GATE / Done / Evidence / Decide / Risk` — and a stop that omits it is not
  a gate. `Evidence` requires real command output or a committed artifact path, which
  removes the agent's freedom to *assess* that a precondition holds; `Risk` is written
  for a user who cannot audit the work. The block is inlined and byte-identical in all
  seven skills, because the `skills` CLI installs one skill directory at a time and a
  shared reference file would resolve to a path absent on the user's machine.
  `CLAUDE.md` carries the identity check.

- **Per-skill precondition contracts** (locked decision 15). The six skills with real
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
  pipeline, and spreading them across seven overlapping descriptions would leave the
  router guessing.

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
