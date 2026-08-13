# NOTICE — attribution

`ajian` is a combination skillset. Part of its value is **not original**: it vendors (copies and
lightly adapts) prose from two projects and **depends on** a third. This file credits them honestly
and reproduces the licenses that require reproduction.

The foundation-document machinery (the `PRD` / `ARCHITECTURE` / `CONVENTIONS` / `QUALITY` /
`ROADMAP` / work-order set and its depth discipline) is the author's own prior work and needs no
third-party attribution.

Every vendored file also carries an `Adapted from <source>` line near its top, so provenance is
visible at the point of use, not only here.

---

## What was taken from where

| Block in `ajian` | Upstream project | License | Relationship |
| --- | --- | --- | --- |
| interrogation engine (grill), 2-axis review, router | [mattpocock/skills](https://github.com/mattpocock/skills) — `grilling`, `ask-matt`, `code-review` | MIT | **vendored** (adapted) |
| implementation plan | [obra/superpowers](https://github.com/obra/superpowers) — `writing-plans` | MIT | **vendored** (adapted) |
| execution & branch discipline | [obra/superpowers](https://github.com/obra/superpowers) — `executing-plans`, `using-git-worktrees`, `finishing-a-development-branch`, `test-driven-development`, `verification-before-completion`, `receiving-code-review` | MIT | **vendored** (adapted) |
| UI/UX craft | [impeccable](https://github.com/pbakaus/impeccable) | Apache-2.0 | **depended** (invoked via `npx impeccable` / `/impeccable`, not copied) |

`ajian` wires these together with the author's own foundation-document work and adds its own seams
(the `ajian-map` router, the two-stage grill split, the checkbox-ledger executor, and the
dual-language docs). Where the workflow diverges from an upstream, the divergence is called out in
the adapted file.

---

## Reproduced licenses

### obra/superpowers — MIT

```
MIT License

Copyright (c) 2025 Jesse Vincent

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
```

### mattpocock/skills — MIT

```
MIT License

Copyright (c) 2026 Matt Pocock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
```

### impeccable — Apache-2.0 (dependency, not vendored)

impeccable is not copied into this repository; it is installed separately with
`npx impeccable install` and invoked at runtime. It is licensed under the
Apache License 2.0 (authors: Paul Bakaus, ehmo). See
<https://github.com/pbakaus/impeccable> for the full license text.
