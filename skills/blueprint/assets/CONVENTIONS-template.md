<!--
  CONVENTIONS.md — CHARTER: how code is written here. The reuse inventory plus concrete rules
  that keep code consistent across features.
  MUST contain: reuse inventory, naming, code style, imports, commit/branch conventions,
  test-file naming and location.
  MUST NOT contain: testing philosophy, coverage, DoD or gates (→ QUALITY.md); architecture
  (→ ARCHITECTURE.md).
  The reuse inventory is the highest-value part of this file: it is what stops an agent
  regenerating something the project already has. Brownfield: fill it from a real repo scan and
  cite real paths, then have the user correct it. Greenfield: leave it near-empty and fill it
  after the walking skeleton exists — an invented inventory is worse than none.
-->

# <Project> — Conventions

## Reuse inventory
<Existing things a new feature MUST build on rather than re-create. Every row cites a real path.>

| Kind | Name / path | Use it for | Do not |
| ---- | ----------- | ---------- | ------ |
| Auth | <path> | <what> | <what to avoid> |
| Component | <path> | <what> | |
| Service / client | <path> | <what> | |
| Hook / util | <path> | <what> | |
| Layout / primitive | <path> | <what> | |

## Naming
- **Files & folders:** <convention, with one example>
- **Variables & functions:** <convention>
- **Types / classes / components:** <convention>
- **API routes / endpoints:** <convention>
- **Database objects:** <convention> <!-- drop if no data layer -->

## Code style
- **Formatter:** <tool + config file>
- **Linter:** <tool + ruleset>
- **Language rules:** <e.g. no default exports; explicit return types; error-return over throw>

## Imports & module structure
<Path aliases, import ordering, barrel-file policy, which modules may import which.>

## Commits & branches
- **Branches:** <e.g. feature/<slug>>
- **Commits:** <e.g. Conventional Commits — feat/fix/chore(scope): summary>

## Test files
<Naming and location only. How much to test and what must pass live in QUALITY.md.>

- **Location:** <e.g. co-located `*.test.ts`, or a `tests/` mirror>
- **Naming:** <e.g. `<unit>.test.<ext>`>
- **Fixtures & factories:** <where they live, how they are named>
