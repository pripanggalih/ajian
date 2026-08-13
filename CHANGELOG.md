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

### Fixed
- `ajian-build`'s executor report had an undefined destination (`[REPORT_FILE]` was
  never resolved anywhere), so reports landed next to the plans and mixed up
  `docs/plans/`. Reports now go to `docs/plans/reports/NN-<slug>.md`.
- `ajian-design` kept its "impeccable must be installed" check in prose under
  Preconditions while its Pipeline started at Orient, so the check never became a
  step. With impeccable absent, the skill designed and implemented the surface
  itself — landing UI outside the pipeline, with no plan, ledger, or review. The
  check is now a blocking Step 0 that stops, and standing in for impeccable is
  explicitly forbidden.
