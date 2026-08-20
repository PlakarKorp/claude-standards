# Commits and branches

- One logical change per commit. If the message needs the word "and", split it.
- Subject line: imperative, lowercase after the area prefix, no trailing period,
  under ~72 characters. `storage/s3: retry on 503 instead of failing the run`
- The body explains why, and what you decided against. Skip the body only when
  the subject is genuinely the whole story.
- Never amend, rebase, or force-push a branch that someone else may have pulled
  without being asked to.
- Do not commit or push unless asked. Leave the tree ready and say what you did.
