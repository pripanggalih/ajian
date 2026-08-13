<!--
  DECISIONS.md — CHARTER: the ADR **ledger**. One row per decision — number, title, status, and a
  link to its own file under decisions/. The reasoning does NOT live here; it lives in the linked
  file. This split keeps a work order able to attach a single ADR (decisions/NNNN-*.md) without
  pulling the whole log into context.
  RULES:
  - Numbers ascend and are never reused. A reversed decision is superseded, not deleted.
  - Every accepted, open, or superseded decision has BOTH a row here and a file in decisions/.
  - Open decisions (the only home for what is not yet decided) sit in this ledger with Status: open
    and a file stating the options and what they block — never as "TBD" scattered elsewhere.
  Delete this comment before saving.
-->

# <Project> — Decision Ledger

| ADR | Title | Status | Blocks / note |
| --- | ----- | ------ | ------------- |
| [0001](decisions/0001-<slug>.md) | <short title> | accepted | |
| [0002](decisions/0002-<slug>.md) | <short title> | accepted | |
| [0003](decisions/0003-<slug>.md) | <the open question> | open | roadmap line N |

<!--
  Status vocabulary: accepted | open | superseded by ADR-NNNN
  Seed the ledger with the foundational decisions: stack, architecture pattern, data store, auth.
  Add a row the moment a new ADR file is created; never let a file exist without its ledger row.
-->
