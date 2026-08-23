#!/bin/sh
# PreToolUse hook on Bash: refuse to speak in GitHub conversations.
#
# We work at the commit level. Review threads, PR comments and issue replies are
# where people talk to each other, and a model posting there is noise in someone
# else's discussion — worse, it reads as if a person wrote it.
#
# Creating a PR is fine, that is how work is handed over. Reading is fine.
# Posting into a conversation is not.

set -u

unset CDPATH
ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd)"
# shellcheck source=./_lib.sh
. "$ROOT/scripts/_lib.sh"

payload="$(cat)"
cmd="$(hook_field "$payload" '.tool_input.command')"
[ -n "$cmd" ] || exit 0

deny() {
	# permissionDecisionReason is JSON: no raw quotes or newlines.
	_msg="$(printf '%s' "$1" | tr '\n' ' ' | sed 's/"/\\"/g')"
	cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "$_msg"
  }
}
EOF
	exit 0
}

merging="PlakarKorp policy: do not merge. Opening a PR hands the work over; merging it is for the developer to decide. Say the branch is ready and stop."

conversation="PlakarKorp policy: do not post into GitHub conversations. Comments, reviews and replies are for people; work at the commit level and let the developer speak. Report what you would have said instead."

# Normalise to a single space-separated line, then look at the token after each
# occurrence of gh. Matching the raw string would fire on a path that merely
# contains the words -- ~/gh/pr-comments-backup is not an invocation.
flat="$(printf '%s' "$cmd" | tr '\n\t' '  ')"

# gh_verbs prints "<noun> <verb>" for every gh invocation in the command,
# skipping global flags so `gh -R o/r pr comment` is seen the same as
# `gh pr comment`.
gh_verbs() {
	printf '%s\n' "$flat" | awk '{
		for (i = 1; i <= NF; i++) {
			w = $i
			sub(/^.*\//, "", w)          # strip a leading path
			if (w != "gh") continue
			noun = ""; verb = ""
			for (j = i + 1; j <= NF; j++) {
				t = $j
				if (t ~ /^-/) { j++; continue }   # flag, skip it and its value
				if (noun == "") { noun = t; continue }
				verb = t; break
			}
			if (noun != "") print noun, verb
		}
	}'
}

verbs="$(gh_verbs)"

# Posting into a conversation.
case "
$verbs" in
*"
pr comment"* | *"
issue comment"* | *"
pr review"*) deny "$conversation" ;;
esac

case "
$verbs" in
*"
pr merge"*) deny "$merging" ;;
esac

# gh api against a comment or review endpoint with a writing method.
case "
$verbs" in
*"
api"*)
	case "$flat" in
	*comments* | *reviews*)
		case "$flat" in
		*-X?POST* | *-X?PATCH* | *-X?PUT* | *--method?POST* | *--method?PATCH* | *--method?PUT* | *-f* | *--input*)
			deny "$conversation"
			;;
		esac
		;;
	esac
	;;
esac

# The REST and GraphQL merge routes.
case "$flat" in
*/merge* | *mergePullRequest* | *enablePullRequestAutoMerge*)
	case "
$verbs" in
	*"
api"*) deny "$merging" ;;
	esac
	;;
esac

# The GraphQL API reaches the same conversations by another door.
case "$flat" in
*addComment* | *addPullRequestReview* | *addDiscussionComment*)
	deny "$conversation"
	;;
esac

exit 0
