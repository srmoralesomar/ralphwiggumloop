Conventional Commits: `<type>(<scope>): <subject>`

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`, `ci`, `perf`, `style`

Rules:
- Subject is lowercase, imperative mood, no trailing period, max 72 chars.
- Scope is optional; use the module or package name when relevant.
- Body (optional) explains **why**, not what. Wrap at 72 chars.
- Footer (optional) for `BREAKING CHANGE:` or issue refs.

Examples:
```
feat(storage): add SQLite-backed snippet store
fix(daemon): prevent double-lock on concurrent writes
refactor(cli): extract flag parsing into separate module
test(storage): add edge-case tests for empty DB
chore: update go.mod dependencies
```
