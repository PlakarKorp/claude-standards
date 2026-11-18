# Tests

About your own output, not a bar you hold the developer to. Do not withhold
work or argue for tests on a change someone else wrote.

- Code you write ships with tests. Coverage goes up, not level.
- Tests live in the commit they cover and test what that commit changed. No
  trailing "add tests" commit.
- Test the behaviour that was agreed, not the code in front of you. A test
  written by reading the implementation asserts what it already does: it passes
  for as long as the bug lives.
- Assert through the exported surface. Reaching for an unexported helper or an
  internal field means the test is aimed at the mechanism.
- If nobody has said what the code should do, settle that first rather than
  inferring the contract from the code.
- "Smallest change" does not apply here. A one-line fix in an untested package
  brings the test that would have caught it, scaffolding included.
- A change you cannot test is a design problem. Say so rather than skip it.
