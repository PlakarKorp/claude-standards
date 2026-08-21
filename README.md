# claude-standards

Claude Code conventions and enforcement for PlakarKorp repositories, kept in one
place so a rule is changed once rather than in forty repositories.

This repository is a **plugin marketplace**. Claude Code pulls it in the
background, so a push here reaches every developer without anyone editing a
config file.

## What it does

| Layer | Mechanism | Enforced? |
| --- | --- | --- |
| Conventions in context, every session | `SessionStart` hook prints `rules/*.md` to stdout | No — guidance |
| Formatting | `PostToolUse` runs `gofmt -w` on every Go file written | Yes, silently |
| `go vet` and `golangci-lint` findings | `PostToolUse` exits 2, findings go back to Claude | Yes, in-loop |
| Generated, vendored and lock files | `PreToolUse` denies the write | Yes, hard |
| Pre-PR review | `plakar-reviewer` subagent | No — advisory |

The split matters. Prose in `rules/` is context: Claude tries to follow it and
mostly does. Only the hooks actually stop anything. Anything that can be a lint
rule belongs in `.golangci.yml`, not in `rules/`.

CI stays the authority. These hooks make Claude fix its own work inside the
turn; they do not replace `golangci-lint` in GitHub Actions.

## Layout

```
claude-standards/
├── .claude-plugin/marketplace.json   # the catalog
└── plakar-standards/                 # the plugin
    ├── .claude-plugin/plugin.json
    ├── hooks/hooks.json
    ├── rules/                        # injected at session start
    │   ├── 00-core.md
    │   ├── 05-process.md
    │   ├── 10-git.md
    │   ├── 20-go.md                  # only when the tree has a go.mod
    │   └── 30-typescript.md          # only when the tree has a package.json
    ├── scripts/
    │   ├── inject-rules.sh           # SessionStart
    │   ├── guard-paths.sh            # PreToolUse  Write|Edit
    │   ├── go-check.sh               # PostToolUse Write|Edit
    │   └── _lib.sh
    ├── agents/plakar-reviewer.md
    ├── commands/standards-check.md
    └── skills/                       # one directory per skill
```

## Installing

### Per developer, once

```
/plugin marketplace add PlakarKorp/claude-standards
/plugin install plakar-standards@plakar
```

### Per repository (recommended)

Commit `.claude/settings.json` to each repo. Claude Code adds the marketplace
and enables the plugin once the developer trusts the folder — no prompt, no
manual step. Copy it from [`settings-snippet.json`](settings-snippet.json).

### Organisation-wide

On a Team or Enterprise plan, distribute this marketplace from
**Organization settings → Plugins** on claude.ai. Org sync reads the repository
through the Claude GitHub App and pushes the plugin to every member, so nothing
needs committing per repository and nothing needs MDM.

For a hard lock — nobody swaps in their own hooks — put this in
`managed-settings.json` (`/Library/Application Support/ClaudeCode/` on macOS,
`/etc/claude-code/` on Linux):

```json
{
  "extraKnownMarketplaces": {
    "plakar": { "source": { "source": "github", "repo": "PlakarKorp/claude-standards" } }
  },
  "enabledPlugins": { "plakar-standards@plakar": true },
  "allowManagedHooksOnly": true,
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "PlakarKorp/claude-standards" },
    { "source": "github", "repo": "anthropics/claude-plugins-official" }
  ],
  "disableSideloadFlags": true
}
```

## Changing the rules

Keep `rules/` tight. Claude Code caps hook output at 10,000 characters, and
long instruction sets measurably reduce how well they are followed. A rule earns
its place if a reviewer has had to say it twice.

- A rule a tool can check → `.golangci.yml` in the target repo.
- A rule about *how* to do a multi-step job → a skill, not a rule file.
- A rule that must never be violated → a hook in `scripts/`.
- Everything else → `rules/`.

Test a hook before pushing:

```
make check                    # shellcheck + payload smoke tests
```

Developers pick up the change on their next session.
