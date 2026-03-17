#!/usr/bin/env bash
set -euo pipefail

# Ralph Wiggum Loop installer
# Usage:
#   curl -fsSL <raw-install-url> | bash
#
# Optional env vars:
#   RWL_REF=main            # branch/tag/commit to install from
#   RWL_REPO=owner/repo     # GitHub repo to install from
#   RWL_FORCE=1             # overwrite existing files

RWL_REF="${RWL_REF:-main}"
RWL_REPO="${RWL_REPO:-srmoralesomar/ralphwiggumloop}"
RWL_FORCE="${RWL_FORCE:-0}"

RAW_BASE="https://raw.githubusercontent.com/${RWL_REPO}/${RWL_REF}"

PROJECT_DIR="${PWD}"
SKILL_DIR="${PROJECT_DIR}/.claude/skills/rwlsetup"
TEMPLATES_DIR="${SKILL_DIR}/templates"

FILES=(
  "ralph-loop.sh"
  ".claude/skills/rwlsetup/SKILL.md"
  ".claude/skills/rwlsetup/commitformat.md"
  ".claude/skills/rwlsetup/templates/prd.json"
  ".claude/skills/rwlsetup/templates/prompt.md"
  ".claude/skills/rwlsetup/templates/progressentry.txt"
)

download_file() {
  local relative_path="$1"
  local destination="${PROJECT_DIR}/${relative_path}"
  local source_url="${RAW_BASE}/${relative_path}"

  mkdir -p "$(dirname "$destination")"

  if [[ -f "$destination" && "$RWL_FORCE" != "1" ]]; then
    echo "Skipping existing file: ${relative_path} (set RWL_FORCE=1 to overwrite)"
    return 0
  fi

  echo "Downloading ${relative_path}"
  curl -fsSL "$source_url" -o "$destination"
}

echo "Installing Ralph Wiggum Loop into: ${PROJECT_DIR}"
echo "Source: ${RWL_REPO}@${RWL_REF}"

mkdir -p "$SKILL_DIR" "$TEMPLATES_DIR"

for file in "${FILES[@]}"; do
  download_file "$file"
done

chmod +x "${PROJECT_DIR}/ralph-loop.sh"

echo ""
echo "Install complete."
echo "Installed:"
echo "  - ${PROJECT_DIR}/ralph-loop.sh"
echo "  - ${SKILL_DIR}/SKILL.md"
echo ""
echo "Next steps:"
echo "  1) Open this project in Claude Code"
echo "  2) Run: ./ralph-loop.sh --help"
