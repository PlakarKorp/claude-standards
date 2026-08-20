# TypeScript and web

- No `any`. Use `unknown` and narrow, or write the type.
- No new runtime dependency for something the platform already does.
- Keep components presentational; data fetching lives at the route boundary.
- Do not add a CSS framework or a state library to a repository that does not
  already have one.
