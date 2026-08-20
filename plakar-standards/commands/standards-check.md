---
description: Run PlakarKorp checks across the whole working tree, not just edited files
---

Run the full standards sweep on this repository and report what needs fixing.

1. `gofmt -l .` — list unformatted files (excluding `vendor/`).
2. `go vet ./...`
3. `golangci-lint run ./...` if it is installed.
4. `go test -race ./...` if the user asks for it, or if the change touches
   concurrency.

Fix what is mechanical (formatting) directly. For everything else, report the
findings grouped by file with a one-line explanation each, then ask before
changing code.

If a command is not installed, say which one and move on. Do not install
anything.
