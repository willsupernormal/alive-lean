#!/bin/bash

# aliveOS 3.1 Status Line
# Root:  🐘 aliveOS 3.1 | 📥 N | 🔥 N urgent | ctx:N% | $cost
# Unit:  🧠 unit-name > 📝 N tasks > 🔥 N urgent | ctx:N% | $cost
# >80%:  ... | 💾 /alive:save

input=$(cat)

# ANSI colors
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
CYAN="\033[36m"
YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
ORANGE="\033[38;5;208m"
AMBER="\033[38;5;214m"

# Extract from JSON
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
usage=$(echo "$input" | jq -r '.context_window.current_usage // null')

# Shorten model name
model_short=$(echo "$model" | sed 's/Claude //' | sed 's/ (new)//')

# Context usage %
percent=0
if [ "$usage" != "null" ]; then
  input_tokens=$(echo "$usage" | jq -r '.input_tokens // 0')
  cache_creation=$(echo "$usage" | jq -r '.cache_creation_input_tokens // 0')
  cache_read=$(echo "$usage" | jq -r '.cache_read_input_tokens // 0')
  total_tokens=$((input_tokens + cache_creation + cache_read))
  percent=$((total_tokens * 100 / context_size))
fi

if [ "$percent" -ge 80 ]; then
  ctx_color="$RED"
elif [ "$percent" -ge 60 ]; then
  ctx_color="$ORANGE"
elif [ "$percent" -ge 40 ]; then
  ctx_color="$YELLOW"
else
  ctx_color="$GREEN"
fi

# Format cost
cost_str=""
if [ "$(echo "$cost > 0" | bc -l 2>/dev/null)" = "1" ]; then
  cost_str="${DIM}\$$(printf "%.2f" "$cost")${RESET}"
fi

# ALIVE root detection
if [ -n "$ALIVE_ROOT" ]; then
  : # use env var
elif [ -d "$HOME/Desktop/alive" ]; then
  ALIVE_ROOT="$HOME/Desktop/alive"
elif [ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs/alive" ]; then
  ALIVE_ROOT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/alive"
else
  ALIVE_ROOT="$HOME/alive"
fi

# --- Determine mode: not-alive, root, or unit ---

mode="not-alive"
unit_name=""
unit_path=""

if [[ "$dir" == *"/alive/"* ]] || [[ "$dir" == */alive ]]; then
  mode="root"

  # Check if inside a specific unit
  if [[ "$dir" == *"/alive/04_Ventures/"* ]]; then
    unit_name=$(echo "$dir" | sed 's|.*/04_Ventures/||' | cut -d'/' -f1)
    unit_path="$ALIVE_ROOT/04_Ventures/$unit_name"
    mode="unit"
  elif [[ "$dir" == *"/alive/05_Experiments/"* ]]; then
    unit_name=$(echo "$dir" | sed 's|.*/05_Experiments/||' | cut -d'/' -f1)
    unit_path="$ALIVE_ROOT/05_Experiments/$unit_name"
    mode="unit"
  elif [[ "$dir" == *"/alive/02_Life/"* ]]; then
    unit_name=$(echo "$dir" | sed 's|.*/02_Life/||' | cut -d'/' -f1)
    unit_path="$ALIVE_ROOT/02_Life/$unit_name"
    mode="unit"
  fi
fi

# --- Helper: join array with separator ---
join_parts() {
  local sep="$1"
  shift
  local out=""
  for part in "$@"; do
    [ -z "$part" ] && continue
    if [ -z "$out" ]; then
      out="$part"
    else
      out="$out${sep}$part"
    fi
  done
  echo "$out"
}

# --- Build output ---

if [ "$mode" = "not-alive" ]; then
  # Not in ALIVE — just technical info
  parts=()
  parts+=("${BOLD}${model_short}${RESET}")
  parts+=("${ctx_color}ctx:${percent}%${RESET}")
  [ -n "$cost_str" ] && parts+=("$cost_str")
  printf "%b" "$(join_parts " ${DIM}|${RESET} " "${parts[@]}")"

elif [ "$mode" = "root" ]; then
  # System-wide view: 🐘 aliveOS 3.1 | 📥 N | 🔥 N urgent | ctx:N% | $cost [| 💾 /alive:save]

  # Count inputs
  inputs_count=0
  if [ -d "$ALIVE_ROOT/03_Inputs" ]; then
    inputs_count=$(find "$ALIVE_ROOT/03_Inputs" -type f -not -name ".*" -not -name "Icon*" 2>/dev/null | wc -l | tr -d ' ')
  fi

  # Count urgent across all units
  urgent_count=0
  shopt -s nullglob
  for tasks_file in "$ALIVE_ROOT"/04_Ventures/*/_brain/tasks.md "$ALIVE_ROOT"/05_Experiments/*/_brain/tasks.md "$ALIVE_ROOT"/02_Life/*/_brain/tasks.md; do
    if [ -f "$tasks_file" ]; then
      u=$(grep -c -E "^\- \[ \].*@urgent" "$tasks_file" 2>/dev/null || true)
      urgent_count=$((urgent_count + u))
    fi
  done
  shopt -u nullglob

  # Build parts
  parts=()
  parts+=("🐘 ${AMBER}${BOLD}aliveOS 3.1${RESET}")
  [ "$inputs_count" -gt 0 ] && parts+=("📥 ${YELLOW}${inputs_count}${RESET}")
  [ "$urgent_count" -gt 0 ] && parts+=("🔥 ${RED}${urgent_count} urgent${RESET}")
  parts+=("${ctx_color}ctx:${percent}%${RESET}")
  [ -n "$cost_str" ] && parts+=("$cost_str")
  [ "$percent" -ge 80 ] && parts+=("💾 ${RED}/alive:save${RESET}")

  printf "%b" "$(join_parts " ${DIM}|${RESET} " "${parts[@]}")"

elif [ "$mode" = "unit" ]; then
  # Unit view: 🧠 unit > 📝 N tasks > 🔥 N urgent | ctx:N% | $cost [| 💾 /alive:save]

  # Count tasks and urgent for this unit
  task_count=0
  urgent_count=0
  unit_tasks="$unit_path/_brain/tasks.md"
  if [ -f "$unit_tasks" ]; then
    task_count=$(grep -c -E "^\- \[ \]|^\- \[~\]" "$unit_tasks" 2>/dev/null || true)
    urgent_count=$(grep -c -E "^\- \[ \].*@urgent" "$unit_tasks" 2>/dev/null || true)
  fi

  # Unit chain with arrows
  unit_parts=()
  unit_parts+=("🧠 ${CYAN}${BOLD}${unit_name}${RESET}")
  [ "$task_count" -gt 0 ] && unit_parts+=("📝 ${task_count} tasks")
  [ "$urgent_count" -gt 0 ] && unit_parts+=("🔥 ${RED}${urgent_count} urgent${RESET}")

  unit_chain="$(join_parts " ${DIM}>${RESET} " "${unit_parts[@]}")"

  # Technical parts with pipes
  tech_parts=()
  tech_parts+=("${ctx_color}ctx:${percent}%${RESET}")
  [ -n "$cost_str" ] && tech_parts+=("$cost_str")
  [ "$percent" -ge 80 ] && tech_parts+=("💾 ${RED}/alive:save${RESET}")

  tech_chain="$(join_parts " ${DIM}|${RESET} " "${tech_parts[@]}")"

  printf "%b" "${unit_chain} ${DIM}|${RESET} ${tech_chain}"
fi
