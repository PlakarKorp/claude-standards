#!/bin/sh
# Smoke tests for the standards hooks. Feeds each hook the JSON payload shape
# Claude Code actually sends and checks the decision it comes back with.

set -u

unset CDPATH
ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd)"
SCRIPTS="$ROOT/plakar-standards/scripts"
CLAUDE_PLUGIN_ROOT="$ROOT/plakar-standards"
export CLAUDE_PLUGIN_ROOT

fail=0
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

report() {
	if [ "$1" = ok ]; then
		echo "ok    $2"
	else
		echo "FAIL  $2"
		[ -n "${3-}" ] && printf '        %s\n' "$3"
		fail=1
	fi
}

payload() {
	printf '{"hook_event_name":"%s","cwd":"%s","tool_name":"Write","tool_input":{"file_path":"%s","content":""}}' \
		"$1" "$tmp" "$2"
}

# --- guard-paths: denies ---------------------------------------------------
for p in \
	"$tmp/vendor/github.com/foo/bar.go" \
	"$tmp/api/service.pb.go" \
	"$tmp/go.sum" \
	"$tmp/web/package-lock.json"; do
	out="$(payload PreToolUse "$p" | "$SCRIPTS/guard-paths.sh")"
	case "$out" in
	*'"deny"'*) report ok "guard-paths denies $(basename "$p")" ;;
	*) report no "guard-paths denies $(basename "$p")" "got: $out" ;;
	esac
done

# --- guard-paths: allows --------------------------------------------------
for p in "$tmp/snapshot/backup.go" "$tmp/cmd/plakar/main.go" "$tmp/README.md"; do
	out="$(payload PreToolUse "$p" | "$SCRIPTS/guard-paths.sh")"
	if [ -z "$out" ]; then
		report ok "guard-paths allows $(basename "$p")"
	else
		report no "guard-paths allows $(basename "$p")" "got: $out"
	fi
done

# --- go-check: ignores non-Go --------------------------------------------
echo "hello" >"$tmp/notes.md"
if payload PostToolUse "$tmp/notes.md" | "$SCRIPTS/go-check.sh" 2>/dev/null; then
	report ok "go-check ignores non-Go files"
else
	report no "go-check ignores non-Go files"
fi

# --- go-check: reformats in place, stays quiet ---------------------------
mkdir -p "$tmp/mod"
cat >"$tmp/mod/go.mod" <<'EOF'
module example.com/mod

go 1.22
EOF
# Deliberately mis-indented, but valid and vet-clean.
printf 'package mod\n\nfunc Add(a, b int) int {\n                return a + b\n}\n' \
	>"$tmp/mod/add.go"

err="$(payload PostToolUse "$tmp/mod/add.go" | "$SCRIPTS/go-check.sh" 2>&1)"
rc=$?
if command -v gofmt >/dev/null 2>&1; then
	if [ -z "$(gofmt -l "$tmp/mod/add.go")" ]; then
		report ok "go-check reformats in place"
	else
		report no "go-check reformats in place" "still unformatted"
	fi
else
	echo "skip  gofmt not installed"
fi
if [ "$rc" -eq 0 ]; then
	report ok "go-check silent on a clean file"
else
	report no "go-check silent on a clean file" "rc=$rc out=$err"
fi

# --- go-check: reports vet findings back to Claude -----------------------
if command -v go >/dev/null 2>&1; then
	mkdir -p "$tmp/bad"
	cat >"$tmp/bad/go.mod" <<'EOF'
module example.com/bad

go 1.22
EOF
	# Printf verb/argument mismatch: compiles, vet catches it.
	cat >"$tmp/bad/bad.go" <<'EOF'
package bad

import "fmt"

func Report(name string) string {
	return fmt.Sprintf("%d", name)
}
EOF
	err="$(payload PostToolUse "$tmp/bad/bad.go" | "$SCRIPTS/go-check.sh" 2>&1 >/dev/null)"
	rc=$?
	if [ "$rc" -eq 2 ] && [ -n "$err" ]; then
		report ok "go-check exits 2 and reports vet findings"
	else
		report no "go-check exits 2 and reports vet findings" "rc=$rc out=$err"
	fi
else
	echo "skip  go not installed"
fi

# --- go-check: reports golangci-lint findings for the edited file only ---
if command -v golangci-lint >/dev/null 2>&1; then
	mkdir -p "$tmp/lint"
	cat >"$tmp/lint/go.mod" <<'EOF'
module example.com/lint

go 1.22
EOF
	# Unchecked error: vet lets it through, golangci-lint (errcheck) does not.
	cat >"$tmp/lint/lint.go" <<'EOF'
package lint

import "os"

func Touch(path string) {
	f, _ := os.Create(path)
	f.Close()
}
EOF
	err="$(payload PostToolUse "$tmp/lint/lint.go" | "$SCRIPTS/go-check.sh" 2>&1 >/dev/null)"
	rc=$?
	case "$rc:$err" in
	2:*lint.go*) report ok "go-check surfaces golangci-lint findings" ;;
	*) report no "go-check surfaces golangci-lint findings" "rc=$rc out=$err" ;;
	esac

	# A finding in a sibling file must not be attributed to the edited one.
	cat >"$tmp/lint/other.go" <<'EOF'
package lint

import "os"

func Other(path string) {
	f, _ := os.Create(path)
	f.Close()
}
EOF
	err="$(payload PostToolUse "$tmp/lint/lint.go" | "$SCRIPTS/go-check.sh" 2>&1 >/dev/null)"
	case "$err" in
	*other.go*) report no "go-check ignores findings in sibling files" "leaked: $err" ;;
	*) report ok "go-check ignores findings in sibling files" ;;
	esac
else
	echo "skip  golangci-lint not installed"
fi

# --- inject-rules --------------------------------------------------------
out="$(cd "$tmp/mod" 2>/dev/null && "$SCRIPTS/inject-rules.sh")"
case "$out" in
*"PlakarKorp engineering conventions"*)
	case "$out" in
	*"# Go"*) report ok "inject-rules includes Go rules in a Go module" ;;
	*) report no "inject-rules includes Go rules in a Go module" "no Go section" ;;
	esac
	;;
*) report no "inject-rules emits core rules" "got: $out" ;;
esac

out="$(cd "$tmp" && "$SCRIPTS/inject-rules.sh")"
case "$out" in
*"# Go"*) report no "inject-rules skips Go rules outside a module" "Go section leaked" ;;
*) report ok "inject-rules skips Go rules outside a module" ;;
esac

chars=$(cd "$tmp/mod" && "$SCRIPTS/inject-rules.sh" | wc -c | tr -d ' ')
if [ "$chars" -lt 10000 ]; then
	report ok "injected rules fit the 10000-char hook budget ($chars)"
else
	report no "injected rules fit the 10000-char hook budget" "$chars chars"
fi

exit "$fail"
