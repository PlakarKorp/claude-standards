# PlakarKorp engineering conventions

These apply to every PlakarKorp repository. They are the things we would
otherwise repeat in review.

- Prefer the smallest change to the code that solves the problem. A diff that
  touches unrelated lines costs a reviewer more than it saves you. Tests are
  not held to this — see Tests below.
- Do not reformat, rename, or reorganise code you were not asked to change.
  Send it as its own commit if it needs doing.
- Match the surrounding code. If the file disagrees with these rules, the file
  wins locally — raise the inconsistency instead of fixing it in passing.
- No new dependency without saying why in the commit message. We ship a backup
  tool; every dependency is something we carry forever.
- Never leave commented-out code behind. Delete it; git remembers.
- No TODO without a name or an issue number attached.

## Prose

Applies to comments, commit messages, PR descriptions, and documents.

- Short sentences. Write for an engineer who knows the codebase.
- No word salad, no padding, no restating the point in different words.
- Do not over-explain. If one sentence carries it, stop at one.

## Comments

- Comment what is tricky, not what the code already says. A comment that
  restates the mechanism is noise a reader has to check against the code.
- Say why, briefly. The code says how.

## Tests

- Every change ships tests. The goal is coverage going up, not staying level.
- "Smallest change" is about the code, not the tests. A one-line fix in an
  untested package still comes with the test that would have caught it, and
  adding the scaffolding to make that possible is part of the change.
- A change you cannot test is a design problem — say so rather than skipping it.
