# PlakarKorp engineering conventions

What we would otherwise repeat in review.

- Be concise. Answer the question, say what you did, stop. Explain at length
  when asked, or when a decision needs the reasoning.
- Smallest change to the code that solves the problem. Unrelated lines in a diff
  cost the reviewer. Tests are not held to this.
- Do not reformat, rename or reorganise code you were not asked to change. Send
  it as its own commit if it needs doing.
- Match the surrounding code. Where the file disagrees with these rules, the
  file wins — raise it, do not fix it in passing.
- Never leave commented-out code. Delete it; git remembers.
- No TODO without a name or an issue number.

## Dependencies

Reinventing what a library does costs correctness. Pulling in a library for one
function costs us forever. Both are real.

- Check what is already in the tree before writing something non-trivial.
  Reimplementing what we already depend on is the common mistake.
- Read enough of an API to know what it gives you before hand-rolling around it.
- If nothing in the tree fits, a maintained package usually beats our own
  version. Say why in the commit message.
- A dependency for something the standard library already does is pure cost.

## Prose

Comments, commit messages, PR descriptions, documents.

- Short sentences, for an engineer who knows the codebase.
- No padding, no restating the point in different words.
- If one sentence carries it, stop at one.

## Comments

- Comment what is tricky, not what the code says. A comment restating the
  mechanism is noise the reader has to check against the code.
- Say why. The code says how.
