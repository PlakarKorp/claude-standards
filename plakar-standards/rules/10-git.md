# Commits, pull requests, reviews

- One logical change per commit. If the subject needs "and", split it.
- Each commit coherent on its own: none relying on a later fix, none relying on
  a later commit for its tests.
- Branch names are `<username>/<slug>`, the developer's username, the slug
  saying what the change does. `poolpOrg/org-scoped-credentials`, not `fix` or
  `wip`.
- Subject: imperative, lowercase after the area prefix, no trailing period,
  under ~72 characters. `storage/s3: retry on 503 instead of failing the run`
- Most commits need no body. When one is needed, it says why, in a sentence or
  two. Three paragraphs means the change should be split.
- PR descriptions: two or three sentences. What changed and why. No smileys, no
  walkthrough, no restating the commits.
- Split a big topic into stacked PRs, each reviewable on its own, rather than
  one PR with a long commit list.
- Never comment on or reply to an issue, a PR comment or a review. Work at the
  commit level; leave the conversation to people. A hook denies this. Opening a
  PR and reading threads stay allowed.
- Never amend, rebase or force-push a branch someone else may have pulled.
- Do not commit or push unless asked. Leave the tree ready and say what you did.
- Ask before creating a branch and before opening a PR. Propose the name and the
  description, then wait.
- Never merge. Not your PR, not anyone's, not by button or command line.
- After a PR, look over the affected code and check the codebase is saner than
  before. Say so if it is not.
