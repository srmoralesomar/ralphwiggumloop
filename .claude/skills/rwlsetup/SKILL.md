---
name: rwlsetup
description: Sets up a new Ralph Wiggum Loop project by gathering requirements, generating a PRD (prd.json), initializing progress.txt, and creating PROMPT.md. Invoke manually when bootstrapping a new RWL-driven project.
disable-model-invocation: true
---

# Ralph Wiggum Loop — Project Setup

Ignore ralph-loop.sh. Don't read it.

This skill walks the user through setting up a new project for the Ralph Wiggum Loop. It produces three files: `prd.json`, `progress.txt`, and `PROMPT.md`.

## Step 1: Gather Requirements

Use the **AskUserQuestion** tool to collect:

| Question | Purpose |
|----------|---------|
| Project name | Used in filenames, headers, and binary output |
| Short description | One-liner for PRD and PROMPT.md |
| Core features | Drives task breakdown in the PRD |
| Tech stack | Languages, frameworks, tools |

Example:

```
AskUserQuestion:
  Q1: "What is the name of your project?"
  Q2: "Describe the app or product in one or two sentences."
  Q3: "List the core features you want built."
  Q4: "What tech stack will you use? (e.g. Go, Python + Flask, TypeScript + React)"
```

If AskUserQuestion is unavailable, ask conversationally.

After gathering answers, confirm the full picture with the user before proceeding.

## Step 2: Create prd.json

Create `prd.json` in the project root using the template in [templates/prd.json](templates/prd.json).

Break the core features into granular, independently-completable tasks. Each task must have:

- A unique sequential `id` (starting at 1)
- A clear `title` and `description`
- Specific, testable `acceptance` criteria
- `"done": false`

**Order tasks by priority:**

1. Architectural decisions and core abstractions
2. Integration points between modules
3. Unknown unknowns and spike work
4. Standard features and implementation 
5. Polish, cleanup, and quick wins (README, formatting)

Present the draft PRD to the user for review. Adjust if they request changes.

## Step 3: Create progress.txt

Create `progress.txt` in the project root:

```
# <project name> — Progress Log

```

Replace `<project name>` with the actual project name.

## Step 4: Create PROMPT.md

Create `PROMPT.md` in the project root using the template in [templates/prompt.md](templates/prompt.md).

Replace the following placeholders with actual values:

| Placeholder | Value |
|-------------|-------|
| `{{PROJECT_NAME}}` | The project name |
| `{{PROJECT_DESCRIPTION}}` | The short description |
| `{{TEST_CMD}}` | Command to run the test suite |
| `{{BUILD_CMD}}` | Command to build the project |
| `{{LINT_CMD}}` | Command to lint / vet the code |

Derive the commands from the tech stack chosen in Step 1. Examples:

| Tech stack | TEST_CMD | BUILD_CMD | LINT_CMD |
|------------|----------|-----------|----------|
| Go | `go test ./...` | `go build -o <binary> .` | `go vet ./...` |
| Node / TypeScript | `npm test` | `npm run build` | `npm run lint` |
| Python | `pytest` | *(omit or use a no-op like `echo "no build step"`)* | `ruff check .` |
| Rust | `cargo test` | `cargo build` | `cargo clippy` |

If the stack has no build step, replace `{{BUILD_CMD}}` with a comment explaining why (e.g. `# Python — no build step`). The agent will still gate commits on the remaining checks.

## Step 5: Initialize Git (if needed)

If the project directory is not already a git repository:

```bash
git init
git add -A
git commit -m "chore: initial project setup with PRD and prompt"
```

## Step 6: Confirm Setup

List the files created:
- `prd.json` — product requirements with task breakdown
- `progress.txt` — append-only progress log
- `PROMPT.md` — iteration prompt for the agent

Tell the user to start with a single iteration to make sure everything works:

```bash
./ralph-loop.sh 1
```

After that first run, they should review the commit(s), check `progress.txt`, and verify the task was marked done in `prd.json`. Once they're satisfied, they can let it rip:

```bash
./ralph-loop.sh 20
```
