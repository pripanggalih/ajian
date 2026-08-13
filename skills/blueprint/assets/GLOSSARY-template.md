<!--
  GLOSSARY.md — CHARTER: the ubiquitous domain language, so documents, work orders and code all
  use the same word for the same thing. CONDITIONAL: write it only when the domain genuinely has
  terms people use inconsistently. A glossary of obvious words is noise.
  FORMAT: mattpocock CONTEXT.md — each term is a bold heading, then a one-line business
  definition, then an `_Avoid_:` line naming the synonyms that must NOT be used and why.
  MUST NOT contain: implementation notes. It is a dictionary, not a design document.
  Delete this comment and every unused section before saving.
-->

# <Project> — Glossary

The ubiquitous language for this project. Use these exact terms in docs, work orders, and code.
Where a term has tempting synonyms, `_Avoid_` lists them so they never creep back in.

## Terms

**<Term>**:
<precise, business-level definition — what it is, not how it is stored or rendered>
_Avoid_: <the near-synonyms it gets confused with>

**<Term>**:
<precise, business-level definition>
_Avoid_: <synonyms to avoid, or delete this line if there are none>

## Relationships
<Only the relationships that matter for shared understanding. Delete if none.>

- A **<Term>** has many **<Term>**
- A **<Term>** belongs to exactly one **<Term>**

## Flagged ambiguities
<Terms that used to be used two ways, and how the ambiguity was resolved. Delete if none.>

- "<word>" was used to mean both <X> and <Y> — resolved: <X> is now **<Term>**; "<word>" is no
  longer used as a domain term.
