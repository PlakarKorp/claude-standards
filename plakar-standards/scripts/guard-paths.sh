#!/bin/sh
# PreToolUse hook on Write|Edit: refuse writes to trees we never hand-edit.
#
# Generated files, vendored dependencies and lockfiles are produced by tools.
# A model editing them looks like it worked and silently diverges from the
# generator, so we deny instead of asking.

set -u

unset CDPATH
ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd)"
# shellcheck source=./_lib.sh
. "$ROOT/scripts/_lib.sh"

payload="$(cat)"
file="$(hook_field "$payload" '.tool_input.file_path')"
[ -n "$file" ] || exit 0

deny() {
	cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "$1"
  }
}
EOF
	exit 0
}

case "$file" in
*/vendor/* | vendor/*)
	deny "PlakarKorp policy: vendor/ is managed by 'go mod vendor'. Change the dependency or go.mod instead of editing vendored source."
	;;
*.pb.go | *.pb.gw.go | *_string.go | *_generated.go | */zz_generated*.go)
	deny "PlakarKorp policy: $file is generated. Edit the source (.proto, the //go:generate directive, or the generator) and re-run 'go generate ./...'."
	;;
*/go.sum | go.sum)
	deny "PlakarKorp policy: go.sum is maintained by the go tool. Run 'go mod tidy' instead of editing it."
	;;
*/package-lock.json | package-lock.json | */yarn.lock | yarn.lock)
	deny "PlakarKorp policy: lockfiles are maintained by the package manager. Run the install command instead of editing the lockfile."
	;;
esac

exit 0
