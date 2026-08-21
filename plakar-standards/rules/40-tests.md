# Tests

This is about your own output, not a bar you hold the developer to. Do not
withhold work or argue for tests on a change someone else wrote.

- Code you write ships with tests. Coverage should go up, not stay level.
- Tests live in the same commit as the code they cover, and cover what that
  commit changed. No trailing "add tests" commit at the end of a branch: each
  commit stands on its own, tests included.
- Test the behaviour the specification asks for, not the implementation in front
  of you. A test written by reading the code asserts what it already does, passes
  for as long as the bug lives, and has to be rewritten by anyone who touches
  the internals.
- Assert through the exported surface, on inputs and outputs. Reaching for an
  unexported helper or an internal field is a sign the test is aimed at the
  mechanism.
- If there is no specification for what the code should do, that is the thing to
  settle first. Say so instead of inferring the contract from the code.
- "Smallest change" is about the code, not the tests. A one-line fix in an
  untested package still comes with the test that would have caught it, and
  adding the scaffolding to make that possible is part of the change.
- A change you cannot test is a design problem — say so rather than skipping it.
