# ajian-map

## What it does

Reads your project's artifacts — is there a blueprint? which roadmap line is current? what `Depth`
is the work order? is there a plan, and are its checkboxes ticked? what does git show? — and tells
you, in one line, where you are on the pipeline and which skill to run next. It is the router that
replaces a session hook (ajian has none by design).

## When to reach for it

- At the start of a session, or right after a `/compact` or `/clear`, when you've lost the thread.
- Any time a skill's `→ Next` breadcrumb isn't in front of you and you're unsure what to run.
- To sanity-check state when the committed artifacts and your memory seem to disagree.
- **When you don't know ajian's vocabulary at all.** You don't have to remember its name: "I'm
  lost", "where do I start", "saya bingung", "mulai dari mana", "ini lanjut apa" all reach it. It is
  the only ajian skill with no preconditions, so it is always safe to run.

## Common questions

- **Does it do the work?** No. It only points at the next skill; you invoke that skill yourself.
- **Will it offer to run everything for me?** It offers exactly one step and waits. Not four, and
  not silently — a router that launches the pipeline is the thing this skill exists instead of.
- **What if the signals conflict** (plan ticked but nothing committed, roadmap ticked but never
  merged)? It trusts git and the committed artifacts over recollection, says the conflict plainly,
  and recommends the safe next step rather than guessing.
- **Greenfield with nothing yet?** It sends you to `ajian-blueprint`.

## It's working if

You can run it after any interruption and get a correct, specific answer like "Work order 03 is
detailed, plan has 4/7 tasks ticked — you are mid-build; next: `/ajian-build 03`, resuming at task 5."
