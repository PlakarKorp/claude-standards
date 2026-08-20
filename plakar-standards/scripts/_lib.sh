#!/bin/sh
# Shared helpers for PlakarKorp standards hooks.
#
# Hooks receive a JSON payload on stdin. We avoid a hard dependency on jq by
# falling back to python3, and giving up quietly if neither is available: a
# broken hook must never wedge someone's session.

# hook_field <json> <dotted.path>
# Prints the value, or nothing if absent.
hook_field() {
	_json="$1"
	_path="$2"

	if command -v jq >/dev/null 2>&1; then
		printf '%s' "$_json" | jq -r "$_path // empty" 2>/dev/null
		return
	fi

	if command -v python3 >/dev/null 2>&1; then
		printf '%s' "$_json" | python3 -c '
import json, sys
path = sys.argv[1].lstrip(".").split(".")
try:
    cur = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for key in path:
    if not isinstance(cur, dict) or key not in cur:
        sys.exit(0)
    cur = cur[key]
if cur is not None:
    print(cur)
' "$_path" 2>/dev/null
		return
	fi

	# No JSON parser available. Callers treat empty as "nothing to do".
	return
}

# Plugin options arrive as CLAUDE_PLUGIN_OPTION_<KEY>. Unset means default.
opt_enabled() {
	_val=""
	eval "_val=\${CLAUDE_PLUGIN_OPTION_$1-}"
	case "$_val" in
	false | 0 | no | off) return 1 ;;
	*) return 0 ;;
	esac
}
