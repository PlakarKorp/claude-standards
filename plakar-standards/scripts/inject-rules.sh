#!/bin/sh
# SessionStart hook: load the PlakarKorp rule set into context.
#
# Plugins cannot ship CLAUDE.md or .claude/rules, but plain stdout from a
# SessionStart hook lands in Claude's context. That gives us always-on,
# git-managed conventions with no per-repository file and no MDM.
#
# Output is capped at 10,000 characters by Claude Code, so keep the rule files
# short. What does not fit here belongs in a skill or a lint rule.

set -u

unset CDPATH
ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd)"
# shellcheck source=./_lib.sh
. "$ROOT/scripts/_lib.sh"

opt_enabled INJECT_RULES || exit 0

RULES="$ROOT/rules"
[ -d "$RULES" ] || exit 0

emit() {
	[ -f "$1" ] || return 0
	cat "$1"
	printf '\n'
}

# Always applicable.
emit "$RULES/00-core.md"
emit "$RULES/05-process.md"
emit "$RULES/10-git.md"

# Language-specific rules, only when the tree actually uses that language.
# The session's cwd is where Claude was launched.
[ -f go.mod ] && emit "$RULES/20-go.md"
[ -f package.json ] && emit "$RULES/30-typescript.md"

exit 0
