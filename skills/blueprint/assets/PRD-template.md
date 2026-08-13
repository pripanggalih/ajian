<!--
  PRD.md — CHARTER: the product layer. Why this exists, for whom, and the boundary of v1.
  MUST contain: vision, problem, users and jobs-to-be-done, v1 scope, non-goals, feature list,
  success metrics, constraints.
  MUST NOT contain: stack, schemas, API shapes, visual detail, implementation.
  The feature list here is the seed of ROADMAP.md — every line must end up on the roadmap or
  be explicitly cut. Fill every <...>; delete this comment and any section that does not apply.
-->

# <Project> — Product Requirements

**Last updated:** <YYYY-MM-DD>

## Vision
<One paragraph: what this product is, and the change it makes for its users.>

## Problem
<The core problem, concretely. What is broken or missing today, and what that costs. Avoid
restating the solution here.>

## Target users & jobs-to-be-done
- **<User type>** — needs to <job-to-be-done>, so that <outcome>.
- **<User type>** — needs to <job-to-be-done>, so that <outcome>.

## Scope (v1)
<The boundary of the first version — what IS included, at capability level.>

- <in-scope capability>
- <in-scope capability>

## Non-goals
<What is deliberately NOT being built, and why. The highest-leverage section in this file:
every line here is a conversation the executing agent will not have to have.>

- <not doing this — because <reason>>
- <not doing this — because <reason>>

## Feature list
<Product-level. One line per feature with the "why". This order seeds ROADMAP.md.>

| # | Feature | Why it matters | Touches data? | Has UI? |
| - | ------- | -------------- | ------------- | ------- |
| 1 | <feature> | <one-line why> | <y/n> | <y/n> |
| 2 | <feature> | <one-line why> | <y/n> | <y/n> |

## Success metrics
<Observable signals that v1 worked. Prefer outcomes you can measure over feature counts.>

- <metric — target>

## Constraints
<Business, compliance, budget, platform or integration constraints that shape the product.
Technical constraints that shape the system go in ARCHITECTURE.md instead.>

- <constraint>
