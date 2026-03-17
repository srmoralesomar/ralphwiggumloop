#!/usr/bin/env bash
set -euo pipefail

# Ralph Wiggum Loop installer
# Usage:
#   curl -fsSL <raw-install-url> | bash

RAW_BASE="https://raw.githubusercontent.com/srmoralesomar/ralphwiggumloop/main"

PROJECT_DIR="${PWD}"
CLAUDE_DIR="${PROJECT_DIR}/.claude"
SKILL_DIR="${PROJECT_DIR}/.claude/skills/rwlsetup"
TEMPLATES_DIR="${SKILL_DIR}/templates"

FILES=(
  "ralph-loop.sh"
  ".claude/settings.json"
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
  local tmp_file

  mkdir -p "$(dirname "$destination")"

  if [[ -f "$destination" ]]; then
    if [[ "$relative_path" == ".claude/settings.json" ]]; then
      local backup_file="${destination}.bak.$(date +%Y%m%d%H%M%S)"
      cp "$destination" "$backup_file"
      echo "Backed up existing file: ${relative_path} -> ${backup_file}"
    else
    echo "Skipping existing file: ${relative_path}"
    return 0
    fi
  fi

  echo "Downloading ${relative_path}"
  tmp_file="$(mktemp)"
  if ! curl -fsSL "$source_url" -o "$tmp_file"; then
    rm -f "$tmp_file"
    return 1
  fi
  mv "$tmp_file" "$destination"
}

echo "Installing Ralph Wiggum Loop into: ${PROJECT_DIR}"
echo "Source: srmoralesomar/ralphwiggumloop@main"

mkdir -p "$CLAUDE_DIR" "$SKILL_DIR" "$TEMPLATES_DIR"

for file in "${FILES[@]}"; do
  download_file "$file"
done

chmod +x "${PROJECT_DIR}/ralph-loop.sh"

echo ""
echo "Install complete."
echo "Installed:"
echo "  - ${PROJECT_DIR}/ralph-loop.sh"
echo "  - ${CLAUDE_DIR}/settings.json"
echo "  - ${SKILL_DIR}/SKILL.md"
echo ""
echo "Next steps:"
echo "  1) Open this project in Claude Code"
echo "  2) Run: ./ralph-loop.sh --help"
