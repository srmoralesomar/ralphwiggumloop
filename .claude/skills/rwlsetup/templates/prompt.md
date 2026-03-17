# {{PROJECT_NAME}} — Iteration Prompt

You are building **{{PROJECT_NAME}}**: {{PROJECT_DESCRIPTION}}.

## Before You Start

Gather context so you don't duplicate or break existing work:

```bash
git log --oneline -10
```

Skim relevant source files to understand the current state of the codebase.

## Pick a Task

Read `prd.json` and select **one** task where `"done"` is `false`.

Choose based on this priority order:

1. Architectural decisions and core abstractions (scaffolding, storage, daemon core)
2. Integration points between modules (e.g. wiring daemon to storage)
3. Unknown unknowns and spike work
4. Standard features and implementation (individual commands)
5. Polish, cleanup, and quick wins (config, status, README, formatting)

If multiple tasks share the same priority tier, prefer the one with the lowest `id`.

## Implement

- Implement the chosen task with tests where possible.
- Keep commits small and focused — one commit per logical subtask is encouraged.
- Follow the commit message format defined in `.claude/skills/rwlsetup/commitformat.md`.
- Use global git settings for author name and email (do not override).

### Feedback Loop — before every commit

Before each commit, **all** of the following must pass:

```bash
go test ./...
go build -o {{BUILD_BINARY}} .
```

Do not commit if either command fails. Fix the issue first.

## When the Task Is Done

Once all acceptance criteria are met and tests + build pass:

1. Set `"done": true` for the completed task in `prd.json`.
2. Append an entry to `progress.txt` (**do not overwrite existing content**) using the format defined in `.claude/skills/rwlsetup/templates/progressentry.txt`.
3. Make a final commit that includes the updated `prd.json` and `progress.txt`.

## If You Get Stuck

If tests keep failing after a few attempts or you hit a blocker:

1. **Do not** set `"done"` to `true` for the task.
2. Append to `progress.txt` documenting what you tried and why it didn't work.
3. Commit the updated `progress.txt`.
4. Exit.

## If All Tasks Are Complete

If there are no tasks with `"done"` set to `false`:

1. Run the full test suite: `go test ./...`
2. Run `go vet ./...`
3. Ensure `go build -o {{BUILD_BINARY}} .` succeeds.
4. Output exactly: `<promise>COMPLETE</promise>`
