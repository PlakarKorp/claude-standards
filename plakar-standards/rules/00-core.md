# PlakarKorp engineering conventions

These apply to every PlakarKorp repository. They are the things we would
otherwise repeat in review.

- Prefer the smallest change that solves the problem. A diff that touches
  unrelated lines costs a reviewer more than it saves you.
- Do not reformat, rename, or reorganise code you were not asked to change.
  Send it as its own commit if it needs doing.
- Match the surrounding code. If the file disagrees with these rules, the file
  wins locally — raise the inconsistency instead of fixing it in passing.
- No new dependency without saying why in the commit message. We ship a backup
  tool; every dependency is something we carry forever.
- Do not add comments that restate the code. Comment the reason, not the
  mechanism.
- Never leave commented-out code behind. Delete it; git remembers.
- No TODO without a name or an issue number attached.
