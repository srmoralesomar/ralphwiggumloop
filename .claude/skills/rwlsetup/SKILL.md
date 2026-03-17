---
name: rwlsetup
description: >-
  Sets up a new Ralph Wiggum Loop project by gathering requirements, generating
  a PRD (prd.json), initializing progress.txt, and creating PROMPT.md. Invoke
  manually when bootstrapping a new RWL-driven project.
---

# Ralph Wiggum Loop — Project Setup

This skill walks the user through setting up a new project for the Ralph Wiggum Loop. It produces three files: `prd.json`, `progress.txt`, and `PROMPT.md`.

## Step 1: Gather Requirements

Use the **AskQuestion** tool to collect:

| Question | Purpose |
|----------|---------|
| Project name | Used in filenames, headers, and binary output |
| Short description | One-liner for PRD and PROMPT.md |
| Core features | Drives task breakdown in the PRD |
| Tech stack | Languages, frameworks, tools |

Example:

```
AskQuestion:
  Q1: "What is the name of your project?"
  Q2: "Describe the app or product in one or two sentences."
  Q3: "List the core features you want built."
  Q4: "What tech stack will you use? (e.g. Go, Python + Flask, TypeScript + React)"
```

If AskQuestion is unavailable, ask conversationally.

After gathering answers, confirm the full picture with the user before proceeding.

## Step 2: Create prd.json

Create `prd.json` in the project root using the template in [templates/prd.json](templates/prd.json).

Break the core features into granular, independently-completable tasks. Each task must have:

- A unique sequential `id` (starting at 1)
- A clear `title` and `description`
- Specific, testable `acceptance` criteria
- `"done": false`

**Order tasks by priority:**

1. Architectural decisions and core abstractions (scaffolding, storage, daemon core)
2. Integration points between modules (e.g. wiring daemon to storage)
3. Unknown unknowns and spike work
4. Standard features and implementation (individual commands)
5. Polish, cleanup, and quick wins (config, status, README, formatting)

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
| `{{BUILD_BINARY}}` | Binary output name (typically the lowercase project name) |

## Step 5: Initialize Git (if needed)

If the project directory is not already a git repository:

```bash
git init
git add -A
git commit -m "chore: initial project setup with PRD and prompt"
```

## Step 6: Confirm Setup

Tell the user that setup is complete and they can start the loop:

```bash
./ralph-loop.sh
```

List the files created:
- `prd.json` — product requirements with task breakdown
- `progress.txt` — append-only progress log
- `PROMPT.md` — iteration prompt for the agent
