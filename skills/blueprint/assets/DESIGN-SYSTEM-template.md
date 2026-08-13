<!--
  DESIGN-SYSTEM.md — CHARTER: visual and interaction consistency. The durable UI foundation.
  CONDITIONAL: write it only if the project has an interface.
  MUST contain: principles, tokens, core components, global interaction states, layout rules,
  accessibility baseline.
  MUST NOT contain: per-screen specifications (those belong to a feature's work order) or
  product rationale (→ PRD.md). Describe how things look and behave in general.
-->

# <Project> — Design System

## Principles
<2–4 principles that steer every screen: density, voice, motion, personality.>

- <principle — and what it rules out>

## Tokens
| Group | Values |
| ----- | ------ |
| Colour | <primary, surface, text, muted, success, warning, danger — names + values> |
| Typography | <families, scale, weights, line-heights> |
| Spacing | <base unit + scale> |
| Radius | <values> |
| Elevation | <values> |
| Breakpoints | <named widths> |
| Motion | <durations, easing> |

## Core components
<The shared components every feature reuses. Behaviour and purpose, not implementation.>

- **<Component>** — variants: <>; use for <>; do not use for <>.
- **<Component>** — variants: <>; use for <>.

## Global interaction states
<Defined once so no feature has to invent them — and so none get forgotten.>

- **Empty:** <what an empty collection looks like, and what action it offers>
- **Loading:** <skeleton vs spinner policy, and the threshold>
- **Error:** <inline vs toast, copy tone, retry affordance>
- **Success:** <confirmation style, persistence>
- **Disabled / read-only:** <appearance, and whether reason is shown>
- **Destructive:** <confirmation policy>

## Layout & responsive
<Grid, container widths, mobile-first or not, which breakpoints actually change layout.>

## Accessibility baseline
<Contrast target, keyboard navigation, focus visibility, labelling, reduced motion. Each item
stated so it can be checked.>
