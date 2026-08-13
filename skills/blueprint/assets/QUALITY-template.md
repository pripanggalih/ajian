<!--
  QUALITY.md — CHARTER: the quality bar. How much and what kind of testing, what "done" means,
  and what must pass before a change lands. Named QUALITY rather than TEST-STRATEGY because the
  Definition of Done and the gates are what an executing agent actually opens.
  MUST contain: testing approach, levels, coverage expectations, Definition of Done, CI gates,
  non-functional checks if relevant.
  MUST NOT contain: test-file naming or location (→ CONVENTIONS.md), or individual feature test
  cases (those are written while building that feature).
-->

# <Project> — Quality & Definition of Done

## Testing approach
<How testing is approached here, in a few sentences. Tests-first or not, what is worth a test
and what is not, and how flakiness is handled.>

## Levels
- **Unit:** <what belongs here; what to fake and what to use for real>
- **Integration:** <which boundaries are covered; real dependencies vs. doubles>
- **End-to-end:** <which flows only — name them; e2e everything is a trap>

## Coverage expectations
<Realistic targets and, just as importantly, what is explicitly not worth covering.>

## Definition of Done
<A change is done when all of these hold. Every line must be checkable, not aspirational.>

- [ ] Acceptance criteria in the work order are met and demonstrated
- [ ] <tests at the required levels pass>
- [ ] <lint and type-check clean>
- [ ] <no reuse-inventory item was re-created>
- [ ] <relevant NFR budget in ARCHITECTURE.md is met>
- [ ] <docs updated where the change invalidates them>
- [ ] <roadmap line ticked; any changed project-wide decision recorded as an ADR>

## CI gates
<What must pass before a change lands. These are enforced, not advisory.>

| Gate | Command | Blocking |
| ---- | ------- | -------- |
| <full test suite> | <command> | yes |
| <lint / type-check> | <command> | yes |
| <build> | <command> | yes |

## Non-functional checks
<Only if relevant: performance, security, accessibility, load — what is checked, when, and
against which target in ARCHITECTURE.md.>
