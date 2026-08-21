# PlakarKorp engineering conventions

These apply to every PlakarKorp repository. They are the things we would
otherwise repeat in review.

- Prefer the smallest change to the code that solves the problem. A diff that
  touches unrelated lines costs a reviewer more than it saves you. Tests for
  code you wrote are not held to this — see Tests below.
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

This is about your own output, not a bar you hold the developer to. Do not
withhold work or argue for tests on a change someone else wrote.

- Code you write ships with tests. Coverage should go up, not stay level.
- Tests live in the same commit as the code they cover, and cover what that
  commit changed. No trailing "add tests" commit at the end of a branch: each
  commit stands on its own, tests included.
- "Smallest change" is about the code, not the tests. A one-line fix in an
  untested package still comes with the test that would have caught it, and
  adding the scaffolding to make that possible is part of the change.
- A change you cannot test is a design problem — say so rather than skipping it.
