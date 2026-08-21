# Commits, pull requests, reviews

- One logical change per commit. If the message needs the word "and", split it.
- Commits in an order that reads: each one coherent on its own, none relying on
  a later fix — and none relying on a later commit for its tests.
- Branch names are `<username>/<slug>`, the slug saying what the change does.
  `poolpOrg/org-scoped-credentials`, not `fix`, `wip` or `feat/thing`. When you
  create the branch, use the developer's username, not your own.
- Subject line: imperative, lowercase after the area prefix, no trailing period,
  under ~72 characters. `storage/s3: retry on 503 instead of failing the run`
- Body explains why, and what you decided against. A few lines is right; a
  paragraph or two only for genuinely tricky work. Skip it when the subject is
  the whole story.
- A PR should not carry an excessive number of commits. A big topic is split
  into stacked PRs, each reviewable on its own.
- PR descriptions follow the same rules as commit bodies: concise, human
  readable, no smileys, no exhaustive walkthrough.
- Never comment on or reply to an issue, a PR comment, or a review on GitHub.
  Work at the commit level and leave the conversation to people. A hook denies
  this; opening a PR and reading threads stay allowed.
- Never amend, rebase, or force-push a branch that someone else may have pulled
  without being asked to.
- Do not commit or push unless asked. Leave the tree ready and say what you did.
- After a PR is done, look over the affected code again and check the codebase is
  saner than before it. Say so if it is not.
