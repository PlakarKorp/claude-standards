# Skills

Skills live in `plakar-standards/skills/`, one directory per skill, each with a
`SKILL.md`:

```
plakar-standards/skills/
└── some-skill/
    └── SKILL.md
```

Nothing else goes in that directory: every entry is a skill directory, which is
how every plugin in the official marketplace is laid out. That is why this note
lives here rather than in `skills/README.md`, and why the directory does not
exist until there is a skill to put in it.

A skill is for a job with steps: something where the order matters, or where
getting it right means knowing which command to run when. `rules/` covers the
other kind — standing constraints that apply to whatever is being edited.

The `description` in the frontmatter is what Claude matches against to decide
whether to load the skill, so write it for that: name the trigger, not the
implementation. It is the only part read before the skill is chosen.
