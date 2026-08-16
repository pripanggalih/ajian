<!--
  INDEX.md — CHARTER: the front door and the routing table. It is what the repo's AGENTS.md /
  CLAUDE.md points at, and the first file any agent should open.
  MUST contain: what each document owns, a "read this for that" routing table, and how the
  work orders are run. MUST NOT contain any fact of its own — every statement here points at
  the file that owns it. A fact stated here is a second copy waiting to go stale.
-->

# <Project> — Development Blueprint

<One paragraph: what this project is and what this blueprint governs. Keep it to what a
newcomer needs before opening anything else.>

**Status:** active · **Last updated:** <YYYY-MM-DD> · **Mode:** <greenfield | brownfield>

## Read this for that

| If you need… | Open |
| --- | --- |
| Why this exists, who it is for, what is out of scope | `PRD.md` |
| The stack, project structure, module boundaries, NFRs | `ARCHITECTURE.md` |
| What to reuse, how to name things, where tests live | `CONVENTIONS.md` |
| Entities, relationships, invariants | `DATA-MODEL.md` <!-- drop if no data layer --> |
| Tokens, components, empty/loading/error states, a11y | `DESIGN-SYSTEM.md` <!-- drop if no UI --> |
| Why a decision was made — before proposing a change | `DECISIONS.md` (ledger → `decisions/NNNN-*.md`) |
| What "done" means and what must pass in CI | `QUALITY.md` |
| What a domain term precisely means | `GLOSSARY.md` <!-- drop if not written --> |
| What to build next, and in what order | `ROADMAP.md` |
| The brief for one feature | `work-orders/NN-<slug>.md` |
| How to find code here before reaching for grep | the **Discovery channel** section below |

## Discovery channel

<How an agent should find code in this repo before it reaches for grep — a symbol index, a code
graph, a language server, `ctags`, a generated map, or a script that produces one. Name the tool
and the exact command to query it. Write "none — use grep" if the repo has nothing; that is a real
answer and stops every subagent from re-deciding it.>

- **Channel:** <tool name, or "none">
- **Query it with:** <the exact command or tool call>
- **Refresh it with:** <the command that rebuilds the index, if it can go stale>

Every subagent ajian dispatches reads this section first. A repo with thousands of symbols pays for
layered grep on every dispatch; one line here is the cheapest fix in the blueprint.

## Ground rules for anyone building here

1. **Decisions in `DECISIONS.md` are settled.** Do not re-decide the stack, the structure, or
   the conventions. If one is genuinely wrong, raise a new ADR rather than diverging quietly.
2. **Reuse before you create.** Check the inventory in `CONVENTIONS.md` first; re-creating
   something that already exists is the most common failure here.
3. **The blueprint says what must be true, not how to do it.** Implementation choices are
   yours, as long as the acceptance criteria and the gates in `QUALITY.md` are met.
4. **Work one work order at a time**, in `ROADMAP.md` order.

## How to run a work order

1. Open the topmost unticked row in `ROADMAP.md` — row order is build order; the `#` column is
   each work order's permanent identity and may run out of sequence after an insertion.
2. Read its work order, plus the documents its "read first" list names.
3. Build it, meeting the Definition of Done in `QUALITY.md`.
4. Tick the roadmap line, and record anything that changed a project-wide decision as an ADR.

## Open questions

<Point at the open ADRs by id and title, or "none". Do not restate them.>

- `decisions/NNNN-<slug>.md` → ADR-NNNN: <title> — blocks roadmap line <N>
