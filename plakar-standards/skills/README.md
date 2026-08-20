# Skills

Empty for now. Claude Code discovers skills here automatically once the plugin
is installed — one directory per skill, each with a `SKILL.md`.

```
skills/
└── some-skill/
    └── SKILL.md
```

A skill is for a job with steps: something where the order matters, or where
getting it right means knowing which command to run when. `rules/` covers the
other kind — standing constraints that apply to whatever is being edited.

The `description` in the frontmatter is what Claude matches against to decide
whether to load the skill, so write it for that: name the trigger, not the
implementation. It is the only part read before the skill is chosen.
