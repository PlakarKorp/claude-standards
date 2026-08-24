# Commits, pull requests, reviews

- One logical change per commit. If the message needs the word "and", split it.
- Commits in an order that reads: each one coherent on its own, none relying on
  a later fix — and none relying on a later commit for its tests.
- Branch names are `<username>/<slug>`, the slug saying what the change does.
  `poolpOrg/org-scoped-credentials`, not `fix`, `wip` or `feat/thing`. When you
  create the branch, use the developer's username, not your own.
- Subject line: imperative, lowercase after the area prefix, no trailing period,
  under ~72 characters. `storage/s3: retry on 503 instead of failing the run`
- Most commits need no body. The subject is the whole story: write it and stop.
- When a body is needed, it says why, in one or two sentences. Not what the diff
  already shows, not what you considered and dropped unless someone would
  otherwise redo it. Three or more paragraphs means the change should be split.
- A PR should not carry an excessive number of commits. A big topic is split
  into stacked PRs, each reviewable on its own.
- PR descriptions: two or three sentences. What changed and why, human readable,
  no smileys, no walkthrough, no restating the commits. A reviewer reads the
  diff, not a summary of it.
- Never comment on or reply to an issue, a PR comment, or a review on GitHub.
  Work at the commit level and leave the conversation to people. A hook denies
  this; opening a PR and reading threads stay allowed.
- Never amend, rebase, or force-push a branch that someone else may have pulled
  without being asked to.
- Do not commit or push unless asked. Leave the tree ready and say what you did.
- Ask before creating a branch and before opening a PR. Propose the name and the
  description, wait for the answer.
- Never merge. Not your own PR, not anyone else's, not with the merge button and
  not from the command line. The developer merges.
- After a PR is done, look over the affected code again and check the codebase is
  saner than before it. Say so if it is not.
