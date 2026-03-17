# Ralph Wiggum Loop

Set up the Ralph Wiggum Loop script and Claude skill in any project with one command.

## Install

Run this from the root of the project where you want the files installed:

```bash
cd your-project
curl -fsSL https://raw.githubusercontent.com/srmoralesomar/ralphwiggumloop/main/install.sh | bash
```

Ideally, run this in a new project for the cleanest setup.

## What gets installed

- `ralph-loop.sh`
- `.claude/settings.json`
- `.claude/skills/rwlsetup/SKILL.md`
- `.claude/skills/rwlsetup/commitformat.md`
- `.claude/skills/rwlsetup/templates/prd.json`
- `.claude/skills/rwlsetup/templates/prompt.md`
- `.claude/skills/rwlsetup/templates/progressentry.txt`

## Why `.claude/settings.json` is included

The installer places a project-level `.claude/settings.json` so Claude can run with the permissions expected by this workflow:

- `model: "sonnet"` keeps model selection explicit for reproducibility.
- `permissions.defaultMode: "bypassPermissions"` removes interactive approval prompts during loop iterations.
- `permissions.allow` includes:
  - `Bash(*)`
  - `Edit(./*)`
  - `Read(./*)`

These settings make repeated autonomous runs smoother, but they are intentionally permissive. For safety, run this project in an isolated environment (recommended: Docker sandbox).

If `.claude/settings.json` already exists, the installer creates a timestamped backup (for example, `.claude/settings.json.bak.20260317163000`) and then installs this repo's settings file.

## Instructions

1. After installation, open your target project in Claude Code.

2. Run the `/rwlsetup` skill in the Claude Code chat:

   ```
   /rwlsetup
   ```

   The skill will ask you for your project name, a short description, the core features you want built, and your tech stack. From your answers it generates three files:

   - `prd.json` — a prioritized task breakdown with acceptance criteria
   - `progress.txt` — an append-only log that tracks what was done each iteration
   - `PROMPT.md` — the iteration prompt the agent uses on every loop run

   Review the draft PRD when Claude presents it and request any changes before confirming.

3. Once setup is complete, run a single iteration to verify everything works:

   ```bash
   ./ralph-loop.sh 1
   ```

   After it finishes, check the new commit(s), review `progress.txt`, and confirm the first task is marked done in `prd.json`.

4. When you're satisfied, run the full loop:

   ```bash
   ./ralph-loop.sh 20
   ```

## Recommended: run in a Docker sandbox

A Docker sandbox is an isolated container where Claude and `ralph-loop.sh` run without full access to your host machine. This lowers risk when permissions are broad and commands are autonomous.