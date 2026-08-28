# PlakarKorp engineering conventions

These apply to every PlakarKorp repository. They are the things we would
otherwise repeat in review.

- Be concise. Answer the question, say what you did, stop. Long explanations
  when none were asked for cost the reader time and bury what matters. Explain
  at length when asked to, or when a decision genuinely needs the reasoning.
- Prefer the smallest change to the code that solves the problem. A diff that
  touches unrelated lines costs a reviewer more than it saves you. Tests for
  code you wrote are not held to this.
- Nothing speculative. No abstraction for a single caller, no configurability
  nobody asked for, no error handling for cases that cannot happen. If it is
  200 lines and 50 would do, write the 50.
- Do not reformat, rename, or reorganise code you were not asked to change.
  Send it as its own commit if it needs doing.
- Clean up what your own change orphaned — imports, variables, helpers left
  unused by it. Dead code that was already there is not yours to delete: say you
  saw it.
- Match the surrounding code. If the file disagrees with these rules, the file
  wins locally — raise the inconsistency instead of fixing it in passing.
- Never leave commented-out code behind. Delete it; git remembers.
- No TODO without a name or an issue number attached.

## Dependencies

Two failure modes, opposite directions. Reinventing what a library already does
costs correctness; pulling in a library for a function costs us forever. We ship
a backup tool, so both matter.

- Before writing something non-trivial, check whether a package we already
  depend on does it. Reimplementing what is already in the tree is the common
  case, and the worst one.
- Use the packages we have properly. Read enough of the API to know what it
  gives you before hand-rolling around it.
- If nothing in the tree fits, a well-maintained third-party package usually
  beats our own version of the same thing. Say why in the commit message.
- Adding a dependency for something the standard library or the platform does is
  not a trade, it is just a cost.

## Prose

Applies to comments, commit messages, PR descriptions, and documents.

- Short sentences. Write for an engineer who knows the codebase.
- No word salad, no padding, no restating the point in different words.
- Do not over-explain. If one sentence carries it, stop at one.

## Comments

- Comment what is tricky, not what the code already says. A comment that
  restates the mechanism is noise a reader has to check against the code.
- Say why, briefly. The code says how.
