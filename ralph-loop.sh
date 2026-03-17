#!/bin/bash
# ralph-loop.sh — Ralph Wiggum loop
# Usage: ./ralph-loop.sh [max_iterations]

set -euo pipefail
IFS=$'\n\t'

usage() {
    echo "Usage: ./ralph-loop.sh [max_iterations]"
    echo ""
    echo "Arguments:"
    echo "  max_iterations   Positive integer (default: 20)"
    echo ""
    echo "Environment:"
    echo "  SLEEP_SECONDS    Pause between iterations (default: 5)"
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
fi

MAX_ITERATIONS=${1:-20}
COUNT=0
PROMPT_FILE="PROMPT.md"
PRD_FILE="prd.json"
PROGRESS_FILE="progress.txt"
SLEEP_SECONDS=${SLEEP_SECONDS:-5}
OUTPUT_FILE=""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

cleanup() {
    if [ -n "${OUTPUT_FILE:-}" ] && [ -f "$OUTPUT_FILE" ]; then
        rm -f "$OUTPUT_FILE"
    fi
}
trap cleanup EXIT

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  🔁 Ralph Wiggum Loop"
echo -e "${CYAN}  Max iterations: ${MAX_ITERATIONS}${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if ! [[ "$MAX_ITERATIONS" =~ ^[1-9][0-9]*$ ]]; then
    echo -e "${RED}Error: max_iterations must be a positive integer.${NC}"
    usage
    exit 1
fi

if ! [[ "$SLEEP_SECONDS" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Error: SLEEP_SECONDS must be a non-negative integer.${NC}"
    exit 1
fi

# Check prerequisites
if ! command -v claude &> /dev/null; then
    # Try common alternatives
    if command -v opencode &> /dev/null; then
        AGENT_CMD="opencode"
    else
        echo -e "${RED}Error: No AI coding agent found (claude, opencode).${NC}"
        echo "Install Claude Code: npm install -g @anthropic-ai/claude-code"
        exit 1
    fi
else
    AGENT_CMD="claude"
fi

if [ ! -f "$PROMPT_FILE" ]; then
    echo -e "${RED}Error: $PROMPT_FILE not found.${NC}"
    exit 1
fi

if [ ! -f "$PRD_FILE" ]; then
    echo -e "${RED}Error: $PRD_FILE not found.${NC}"
    exit 1
fi

# Initialize progress file if missing
if [ ! -f "$PROGRESS_FILE" ]; then
    echo "# Ralph Wiggum Loop Progress Log" > "$PROGRESS_FILE"
    echo "" >> "$PROGRESS_FILE"
fi

# Initialize git if needed
if [ ! -d ".git" ]; then
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}Warning: git not found; skipping repo initialization.${NC}"
    else
        echo -e "${YELLOW}Initializing git repo...${NC}"
        git init
        git add -A
        if git config user.name > /dev/null 2>&1 && git config user.email > /dev/null 2>&1; then
            git commit -m "Initial Ralph loop setup"
        else
            echo -e "${YELLOW}Warning: git user.name/user.email not configured; skipping initial commit.${NC}"
        fi
    fi
fi

while [ $COUNT -lt $MAX_ITERATIONS ]; do
    COUNT=$((COUNT + 1))
    TIMESTAMP=$(date '+%H:%M:%S')

    echo ""
    echo -e "${GREEN}━━━ Iteration ${COUNT}/${MAX_ITERATIONS} ━━━ ${TIMESTAMP} ━━━${NC}"

    # Check for remaining work without requiring python3/jq.
    if grep -Eq '"done"[[:space:]]*:[[:space:]]*false' "$PRD_FILE" 2>/dev/null; then
        NEXT_TASK="Tasks remaining in ${PRD_FILE}"
    else
        NEXT_TASK="ALL TASKS COMPLETE"
    fi

    echo -e "${YELLOW}  → ${NEXT_TASK}${NC}"

    if [ "$NEXT_TASK" = "ALL TASKS COMPLETE" ]; then
        echo -e "${GREEN}All tasks marked done. Exiting.${NC}"
        exit 0
    fi

    # Run the agent with the prompt
    # Capture output to check for completion signal
    OUTPUT_FILE=$(mktemp)
    echo -e "${CYAN}  ⏳ Running ${AGENT_CMD} (may take 1–2 min before you see output)...${NC}"
    echo ""

    if [ "$AGENT_CMD" = "claude" ]; then
        claude -p --output-format text < "$PROMPT_FILE" 2>&1 | tee "$OUTPUT_FILE"
    else
        $AGENT_CMD < "$PROMPT_FILE" 2>&1 | tee "$OUTPUT_FILE"
    fi

    echo ""
    echo -e "${CYAN}  ✓ Agent finished iteration ${COUNT}.${NC}"

    # Check for completion signal
    if grep -q "<promise>COMPLETE</promise>" "$OUTPUT_FILE" 2>/dev/null; then
        echo ""
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}  ✅ Ralph says: COMPLETE${NC}"
        echo -e "${GREEN}  Finished in ${COUNT} iteration(s)${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        OUTPUT_FILE=""
        exit 0
    fi

    OUTPUT_FILE=""

    # Brief pause between iterations to avoid rate limits
    echo -e "${CYAN}  Pausing ${SLEEP_SECONDS}s before next iteration...${NC}"
    sleep "$SLEEP_SECONDS"
done

echo ""
echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}  ⚠️  Max iterations (${MAX_ITERATIONS}) reached.${NC}"
echo -e "${RED}  Check ${PROGRESS_FILE} and ${PRD_FILE} for status.${NC}"
echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
exit 1
