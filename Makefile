.PHONY: check shellcheck test json

check: json shellcheck test

json:
	@for f in .claude-plugin/marketplace.json \
	          plakar-standards/.claude-plugin/plugin.json \
	          plakar-standards/hooks/hooks.json \
	          settings-snippet.json; do \
		python3 -c "import json,sys; json.load(open(sys.argv[1]))" $$f || exit 1; \
		echo "ok    $$f"; \
	done

shellcheck:
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck -x --source-path=SCRIPTDIR \
			plakar-standards/scripts/*.sh tests/run.sh && echo "ok    shellcheck"; \
	else \
		echo "skip  shellcheck not installed"; \
	fi

test:
	@./tests/run.sh
