#!/bin/sh
# PostToolUse hook on Write|Edit: keep Go files honest.
#
# Split by nature of the problem:
#   - formatting is mechanical, so we fix it in place and say nothing;
#   - vet and lint findings are judgement calls, so we hand them back to Claude
#     on stderr with exit 2, which puts them in the conversation and gets them
#     fixed in the same turn instead of in review.
#
# This is early feedback, not a gate. CI remains the authority.

set -u

unset CDPATH
ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd)"
# shellcheck source=./_lib.sh
. "$ROOT/scripts/_lib.sh"

payload="$(cat)"
file="$(hook_field "$payload" '.tool_input.file_path')"

case "$file" in
*.go) ;;
*) exit 0 ;;
esac

[ -f "$file" ] || exit 0

case "$file" in
*/vendor/* | vendor/*) exit 0 ;;
esac

dir="$(dirname -- "$file")"
findings=""

add() {
	findings="$findings$1
"
}

# 1. Formatting: fix in place, no noise.
if command -v gofmt >/dev/null 2>&1; then
	if [ -n "$(gofmt -l -- "$file" 2>/dev/null)" ]; then
		gofmt -w -- "$file" 2>/dev/null
	fi
fi

# 2. go vet on the enclosing package. Catches the mistakes that compile.
if command -v go >/dev/null 2>&1; then
	vet="$(cd "$dir" 2>/dev/null && go vet . 2>&1)"
	if [ -n "$vet" ]; then
		add "go vet:
$vet"
	fi
fi

# 3. golangci-lint, restricted to findings in the file just touched.
#
# No output flags here on purpose: --out-format is v1-only and --output.text.*
# is v2-only, so anything explicit breaks on half the team's machines. The
# default text format is file:line:col in both. NO_COLOR keeps the escape
# sequences out; the sed is for the versions that ignore it.
if opt_enabled STRICT_LINT && command -v golangci-lint >/dev/null 2>&1; then
	base="$(basename -- "$file")"
	esc="$(printf '\033')"
	raw="$( (cd "$dir" && NO_COLOR=1 golangci-lint run .) 2>/dev/null )"
	lint="$(printf '%s\n' "$raw" |
		sed "s/${esc}\[[0-9;]*m//g" |
		grep -F "$base:")" || lint=""
	if [ -n "$lint" ]; then
		add "golangci-lint:
$lint"
	fi
fi

if [ -n "$findings" ]; then
	printf 'PlakarKorp standards — %s needs attention before you move on:\n\n%s\n' \
		"$file" "$findings" >&2
	exit 2
fi

exit 0
