#!/usr/bin/env bash
# Three prose blocks are duplicated verbatim across the skills on purpose: `npx skills add
# --skill ajian-build` installs a single skill directory, so a shared reference file would
# resolve to a path that does not exist on the user's machine. Duplication is the design;
# silent divergence is the bug. This script catches the divergence.
#
# `## Language` and `## The gate protocol` must be byte-identical in all eight skills.
# `### When a precondition fails` in the seven that have preconditions (ajian-map has none).
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
check() {
  local label="$1" range="$2" expected="$3" count
  count=$(for f in skills/*/SKILL.md; do
            sed -n "$range" "$f" | shasum | cut -c1-12
          done | grep -v da39a3ee5e6b | sort -u | wc -l | tr -d ' ')
  local present
  present=$(for f in skills/*/SKILL.md; do
              sed -n "$range" "$f" | shasum | cut -c1-12
            done | grep -cv da39a3ee5e6b || true)
  if [ "$count" != "1" ]; then
    echo "FAIL  $label — $count distinct versions across skills (must be 1)"
    fail=1
  elif [ "$present" != "$expected" ]; then
    echo "FAIL  $label — found in $present skills, expected $expected"
    fail=1
  else
    echo "ok    $label — identical in $present skills"
  fi
}

check "## Language"                     '/^## Language$/,/^a gate they rubber-stamp\.$/p'                                8
check "## The gate protocol"            '/^## The gate protocol$/,/^This block is identical in every ajian skill\.$/p'   8
check "### When a precondition fails"   '/^### When a precondition fails$/,/never run the missing step without asking\.$/p' 7

exit $fail
