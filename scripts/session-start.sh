#!/bin/bash
# ALIVE v3 - Session Start Hook
# Logs session start, enumerates units, provides context

set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Extract session ID and working directory
SESSION_ID=$(echo "$input" | jq -r '.session_id // empty')
CWD=$(echo "$input" | jq -r '.cwd // empty')

# Fallback if no session ID
if [ -z "$SESSION_ID" ]; then
  SESSION_ID=$(uuidgen 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo "unknown-$(date +%s)")
fi

# Use CWD or CLAUDE_PROJECT_DIR
ALIVE_ROOT="${CWD:-${CLAUDE_PROJECT_DIR:-$(pwd)}}"
STATE_DIR="$ALIVE_ROOT/.claude/state"
SESSION_LOG="$STATE_DIR/session-log.jsonl"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Ensure state directory exists
mkdir -p "$STATE_DIR"

# Log session start
echo "{\"event\":\"session_start\",\"session_id\":\"$SESSION_ID\",\"timestamp\":\"$TIMESTAMP\",\"cwd\":\"$ALIVE_ROOT\"}" >> "$SESSION_LOG"

# Persist session ID to environment for other hooks
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export ALIVE_SESSION_ID=\"$SESSION_ID\"" >> "$CLAUDE_ENV_FILE"
  echo "export ALIVE_ROOT=\"$ALIVE_ROOT\"" >> "$CLAUDE_ENV_FILE"
fi

# Function to find units (folders with _brain/)
find_units() {
  local domain="$1"
  local domain_path="$ALIVE_ROOT/$domain"

  if [ -d "$domain_path" ]; then
    # Find directories that contain _brain/
    find "$domain_path" -maxdepth 2 -type d -name "_brain" 2>/dev/null | while read -r brain_dir; do
      unit_dir=$(dirname "$brain_dir")
      unit_name=$(basename "$unit_dir")

      # Check for status.md to get current state
      status_file="$brain_dir/status.md"
      if [ -f "$status_file" ]; then
        # Extract phase from status.md (look for **Phase:** line)
        phase=$(grep -m1 "^\*\*Phase:\*\*" "$status_file" 2>/dev/null | sed 's/\*\*Phase:\*\* *//' || echo "Unknown")
        echo "- $unit_name ($phase)"
      else
        echo "- $unit_name (no status)"
      fi
    done
  fi
}

# Build output
output="ALIVE session initialized. Session ID: ${SESSION_ID:0:8}\n\n"

# Enumerate ventures
ventures=$(find_units "ventures")
if [ -n "$ventures" ]; then
  output+="## Ventures\n$ventures\n\n"
fi

# Enumerate experiments
experiments=$(find_units "experiments")
if [ -n "$experiments" ]; then
  output+="## Experiments\n$experiments\n\n"
fi

# Enumerate life areas
life_areas=$(find_units "life")
if [ -n "$life_areas" ]; then
  output+="## Life\n$life_areas\n\n"
fi

# Check inputs
inputs_count=0
if [ -d "$ALIVE_ROOT/inputs" ]; then
  inputs_count=$(find "$ALIVE_ROOT/inputs" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
fi

if [ "$inputs_count" -gt 0 ]; then
  output+="## Inputs\n$inputs_count item(s) pending triage\n"
fi

# Output to stdout (shown to Claude)
echo -e "$output"

exit 0
