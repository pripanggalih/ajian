<!--
  adr-template.md — ONE decision per file, saved as docs/decisions/NNNN-<slug>.md, numbered to
  match its row in the DECISIONS.md ledger. This is what a work order attaches when a specific
  decision governs it — one file, not the whole log.
  RULES:
  - The number here equals the ledger row. Numbers ascend and are never reused.
  - A reversed decision is superseded (set Status, keep the file), never deleted.
  - An unknown lives here as Status: open — never as "TBD" in another document.
  Use the accepted OR the open shape below; delete the other and this comment before saving.
-->

# ADR-<NNNN>: <short title>

- **Status:** accepted <!-- accepted | open | superseded by ADR-NNNN -->
- **Date:** <YYYY-MM-DD>
- **Context:** <the forces at play: constraints, requirements, what made this a decision>
- **Decision:** <what was chosen, stated plainly>
- **Alternatives considered:** <option — why not>; <option — why not>
- **Consequences:** <what this makes easy, what it makes harder, what it commits us to>

<!-- ===== OPEN shape — use instead of the above when the decision is not yet made =====

# ADR-<NNNN>: <the open question>

- **Status:** open
- **Date raised:** <YYYY-MM-DD>
- **Context:** <what is not known, and why it matters>
- **Options on the table:** <option — tradeoff>; <option — tradeoff>
- **Blocks:** <roadmap line N, or "nothing yet">
- **Decide by:** <the point at which this must be resolved>
-->
