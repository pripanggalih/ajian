---
name: code-review
description: Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes — Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/spec asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X".
---

<!-- Adapted from mattpocock/skills `code-review` (MIT, Matt Pocock), copied nearly verbatim. The
     ajian seam: the Spec axis's source is the detailed work order (docs/work-orders/NN-*.md) and
     its acceptance criteria, not an issue tracker; the Standards axis's documented sources are the
     blueprint's docs/CONVENTIONS.md and docs/QUALITY.md; and step 3b (scoping out the
     impeccable-built surface) is original ajian with no upstream counterpart — it exists because
     ajian-design can put generated UI in the tree before the build starts. See NOTICE.md. -->

Two-axis review of the diff between `HEAD` and a fixed point the user supplies:

- **Standards** — does the code conform to this repo's documented coding standards?
- **Spec** — does the code faithfully implement the originating work order / spec?

Both axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings.

In ajian the spec is the **work order** (`docs/work-orders/NN-<slug>.md`) and the documented
standards are the blueprint's `docs/CONVENTIONS.md` and `docs/QUALITY.md`. No issue tracker is
involved.

## Process

### 1. Pin the fixed point

Whatever the user said is the fixed point — a commit SHA, branch name, tag, `main`, `HEAD~5`, etc. If they didn't specify one, ask for it.

Capture the diff command once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base). Also note the list of commits via `git log <fixed-point>..HEAD --oneline`.

Before going further, confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. A bad ref or empty diff should fail here — not inside two parallel sub-agents.

### 2. Identify the spec source

In ajian the spec is fixed: the detailed work order for this build, `docs/work-orders/NN-<slug>.md`
— its acceptance criteria, flows, and contracts are what the Spec axis checks the diff against,
together with the Definition of Done in `docs/QUALITY.md`. If the build number `NN` was not passed,
infer it from the branch name or the plan file the commits reference, and confirm with the user.

### 3. Identify the standards sources

The blueprint's `docs/CONVENTIONS.md` (reuse inventory, naming, style, test-file conventions) and
`docs/QUALITY.md` (gates), plus anything else in the repo that documents how code should be written
(`CODING_STANDARDS.md`, `CONTRIBUTING.md`).

On top of whatever the repo documents, the Standards axis always carries the **smell baseline** below — a fixed set of Fowler code smells (_Refactoring_, ch.3) that applies even when a repo documents nothing. Two rules bind it:

- **The repo overrides.** A documented repo standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation — and, like any standard here, skip anything tooling already enforces.

Each smell reads *what it is* → *how to fix*; match it against the diff:

- **Mysterious Name** — a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code** — the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy** — a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps** — the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession** — a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches** — the same `switch`/`if`-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery** — one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change** — one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality** — abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains** — long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man** — a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest** — a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 3b. Scope out the impeccable-built surface

On a UI work order the screens were built by impeccable in `ajian-design`, before this build. Read
the work order's `## Built surface` section for the file inventory. If it is absent or says "Not
yet designed", skip this step — everything in the diff was written by the build.

Otherwise the inventory changes both briefs:

- **Standards:** exclude those paths. impeccable owns visual craft and passed its own direction
  gate with the user; auditing its generated markup against `CONVENTIONS.md` and the smell baseline
  produces findings nobody will act on and buries the ones about the build's own code. Review the
  *wiring* the build added to those files, not the surface it inherited.
- **Spec:** state plainly that these files already existed at the fixed point. Otherwise the axis
  sees acceptance criteria about screens with no matching code in the diff and reports the feature
  as unimplemented — a false finding produced by where the commits landed, not by the work.

Say in the final report which paths were scoped out, so the exclusion is visible rather than silent.

### 4. Spawn both sub-agents in parallel

**Standards sub-agent prompt** — include:

- The full diff command and commit list.
- The list of standards-source files you found in step 3, **plus the smell baseline from step 3** pasted in full — the sub-agent has no other access to it.
- Any paths scoped out in step 3b, with the instruction to review only the wiring added to them.
- The brief: "Report — per file/hunk where relevant — (a) every place the diff violates a documented standard: cite the standard (file + the rule); and (b) any baseline smell you spot: name it and quote the hunk. Distinguish hard violations from judgement calls — documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented repo standard overrides the baseline. Skip anything tooling enforces. Under 400 words."

**Spec sub-agent prompt** — include:

- The diff command and commit list.
- The path or fetched contents of the spec.
- Any paths from step 3b, noted as **already present at the fixed point** — the screens exist; only
  their wiring is in this diff.
- The brief: "Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words."

If the spec is missing, skip the Spec sub-agent and note this in the final report.

### 5. Aggregate

Present the two reports under `## Standards` and `## Spec` headings, verbatim or lightly cleaned. Do **not** merge or rerank findings — the two axes are deliberately separate (see _Why two axes_).

End with a one-line summary: total findings per axis, and the worst issue _within each axis_ (if any). Don't pick a single winner across axes — that's the reranking the separation exists to prevent.

## Why two axes

A change can pass one axis and fail the other:

- Code that follows every standard but implements the wrong thing → **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks the project's conventions → **Spec pass, Standards fail.**

Reporting them separately stops one axis from masking the other.
