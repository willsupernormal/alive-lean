#!/bin/bash
# ALIVE v3 - Post File Change Hook
# Logs all file edits/writes to audit trail

set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Extract tool info
TOOL_NAME=$(echo "$input" | jq -r '.tool_name // "unknown"')
SESSION_ID=$(echo "$input" | jq -r '.session_id // empty')

# Try environment variable if not in input
if [ -z "$SESSION_ID" ]; then
  SESSION_ID="${ALIVE_SESSION_ID:-unknown}"
fi

# Extract file path based on tool type
FILE_PATH=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.path // "unknown"')

# Get ALIVE root from environment or input
ALIVE_ROOT="${ALIVE_ROOT:-$(echo "$input" | jq -r '.cwd // empty')}"
if [ -z "$ALIVE_ROOT" ]; then
  ALIVE_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
fi

STATE_DIR="$ALIVE_ROOT/.claude/state"
CHANGES_LOG="$STATE_DIR/file-changes.jsonl"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Ensure state directory exists
mkdir -p "$STATE_DIR"

# Make file path relative to ALIVE_ROOT if possible
REL_PATH="$FILE_PATH"
if [[ "$FILE_PATH" == "$ALIVE_ROOT"* ]]; then
  REL_PATH="${FILE_PATH#$ALIVE_ROOT/}"
fi

# Log the file change
echo "{\"event\":\"file_change\",\"tool\":\"$TOOL_NAME\",\"file\":\"$REL_PATH\",\"session_id\":\"$SESSION_ID\",\"timestamp\":\"$TIMESTAMP\"}" >> "$CHANGES_LOG"

# Silent success - no output needed for file tracking
exit 0
