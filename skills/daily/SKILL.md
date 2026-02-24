---
user-invocable: true
description: Morning dashboard showing all ventures, experiments, life areas — goals, urgent tasks, ongoing threads, and pending inputs. Use when the user says "daily", "dashboard", "morning", "what's happening", "what should I work on", "start my day", or "show me everything".
plugin_version: "3.1.0"
---

# alive:daily

Morning entry point. Surface what matters across ALL ventures, experiments, and life areas. The heartbeat of the learning loop.

## UI Treatment

Uses the **ALIVE Shell** — one rounded box, three zones (header / content / footer).

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · daily                            [date]         │
│  [aggregate stats]                                       │
│  ──────────────────────────────────────────────────────  │
│  [THE ANSWER — AI-recommended focus with * marker]       │
│  [THE MAP — venture/experiment/life grid]                 │
│  ──────────────────────────────────────────────────────  │
│  [ACTIONS — paired with context stats]                   │
│  [FINE PRINT — * explanation, sparkline]                 │
╰──────────────────────────────────────────────────────────╯
```

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## Version Check (Before Main Flow)

Compare your `plugin_version` (from frontmatter above) against the user's system:

1. Read `{alive-root}/.claude/alive.local.yaml` → get `system_version`
2. If `system_version` is missing or different from your `plugin_version`:
   ```
   [!] System update available (plugin: 3.1.0, system: X.X.X)
       └─ Run /alive:upgrade to sync
   ```
3. Continue with skill — this is non-blocking, just a notice

---

## Overview

Daily aggregates context from every venture, experiment, and life area (plus the session index) to show:
- Goals from each unit's status.md
- Ongoing threads from session-index.jsonl (with quality ratings)
- Urgent tasks across all units
- Working files in progress
- Inputs pending triage
- Stale units needing attention

**Different from `/alive:work`:** Daily shows EVERYTHING. Work focuses on ONE venture, experiment, or life area.

## V1 Detection (REQUIRED FIRST STEP)

Before anything else, check for v1 structure:

```
Check: Does inbox/ exist? (should be 03_Inputs/)
Check: Does any _state/ exist? (should be _brain/)
```

If v1 detected:
```
[!] Detected ALIVE v1 structure

Your system uses the older v1 format. Upgrade to v2?
[1] Yes, upgrade now
[2] No, continue with v1
```

If yes → invoke `/alive:upgrade` then restart daily.

## Data Sources

| Source | Extract |
|--------|---------|
| `alive.local.yaml` | Sync script configuration (optional) |
| `.claude/state/session-index.jsonl` | Ongoing threads with quality tags |
| `{unit}/_brain/status.md` | Goal line, phase, focus |
| `{unit}/_brain/tasks.md` | @urgent tagged items |
| `{unit}/_brain/manifest.json` | working_files array |
| `03_Inputs/` | Count of pending items |

## Flow

```dot
digraph daily_flow {
    "Start" -> "Check v1 structure";
    "Check v1 structure" -> "Offer upgrade" [label="v1 found"];
    "Check v1 structure" -> "Check sync config" [label="v2 OK"];
    "Offer upgrade" -> "Run /alive:upgrade" [label="yes"];
    "Offer upgrade" -> "Check sync config" [label="no"];
    "Run /alive:upgrade" -> "Check sync config";
    "Check sync config" -> "Run sync scripts" [label="scripts found"];
    "Check sync config" -> "Scan units" [label="no scripts"];
    "Run sync scripts" -> "Scan units";
    "Scan units" -> "Read session-index";
    "Read session-index" -> "Aggregate data";
    "Aggregate data" -> "Display dashboard";
    "Display dashboard" -> "Wait for selection";
}
```

## External Sync (Optional)

**Power users can configure sync scripts** via `/alive:scan` or manually.

Check for `alive.local.yaml` at ALIVE root:

```yaml
# alive.local.yaml
sync:
  slack: .claude/scripts/slack-sync.mjs
  gmail: .claude/scripts/gmail-sync.mjs
```

**If sync sources are configured:**

```
▸ checking alive.local.yaml for sync scripts...
  └─ Found: slack, gmail

▸ running sync scripts...
  └─ slack-sync.mjs... ✓ 3 new items
  └─ gmail-sync.mjs... ✓ 1 new item

4 new items added to 03_Inputs/
```

**If no config or no sync section:**
```
▸ checking alive.local.yaml...
  └─ No sync scripts configured
```

Skip to scanning.

**Script requirements:**
- Scripts should output to `03_Inputs/`
- Scripts should be idempotent (safe to run multiple times)
- Scripts should return exit code 0 on success
- Output format: one line per item added (for counting)

## Reference Output

The full daily output in vibrant format:

```
╭──────────────────────────────────────────────────────────╮
│                                                          │
│  ALIVE · daily                            2026-02-09     │
│                                                          │
│  ──────────────────────────────────────────────────────  │
│                                                          │
│  acme-agency — Client portal deployment due Wednesday *  │
│  Also requiring attention: side-project, health          │
│                                                          │
│                                      5 days  tasks       │
│  ventures                                                │
│   1) acme-agency        Building     ○●●●○     9    !    │
│   2) freelance-dev      Growing      ○○○●○     2         │
│   3) side-project       Pre-Launch   ○○○○○     4    !    │
│                                                          │
│  experiments                                             │
│   4) newsletter         Building     ○○●●○     6    !    │
│   5) saas-idea          Starting     ○●○●○     3         │
│   6) course-platform    Planning     ○○○○○     1         │
│                                                          │
│  life                                                    │
│   7) health             Active       ○○●○○     3    !    │
│   8) finance            Active       ○○○○○     1         │
│                                                          │
│  ──────────────────────────────────────────────────────  │
│                                                          │
│  #) pick a number          d) digest 3 inputs             │
│  s) sweep 2 stale          r) search across system       │
│                                                          │
│  * suggested focus                                       │
│  ▁▂▃▅▇█▇▅▃▁▁▂▅▇█▇▅▃▂▁                   4-day streak   │
│                                                          │
╰──────────────────────────────────────────────────────────╯
```

## Numbered Actions (REQUIRED)

Every actionable item gets `)` to indicate selectability. User picks a number to focus.

When user picks:
- Number → `/alive:work` with that venture, experiment, or life area
- `d)` → `/alive:digest`
- `s)` → `/alive:sweep`
- `r)` → `/alive:recall`
- `#)` → pick by number

## Section: Goals

Extract from each _brain/status.md:
- Look for the **Goal:** line (primary — this is the dashboard label per unit)
- Fallback: first sentence after the "State of Play" heading

Show name + goal. Max 5, sorted by recency.

Goals appear as part of each row in the grid — extracted from status.md goal line. The Answer zone surfaces the most urgent one as the AI-recommended focus.

## Section: Ongoing Threads

Read .claude/state/session-index.jsonl:
- Filter: status "ongoing" only
- Sort: Most recent first
- Show: Name, summary, quality tag, relative time
- Max 5

Quality tags: [routine] [productive] [important] [breakthrough]

Ongoing threads inform the AI-recommended focus in The Answer zone. If a thread is ongoing from yesterday, it becomes the suggested focus. If no ongoing threads, the recommendation falls back to the unit with the most urgent tasks or open work.

## Section: Urgent Tasks

Use the Glob tool to find all _brain/tasks.md files across 02_Life, 04_Ventures, and 05_Experiments. Then use the Read tool on each one.

- Filter: Lines containing @urgent
- Prefix with unit name
- Max 5

Urgent tasks trigger the **!** attention indicator on their row in the grid. The most urgent surfaces in The Answer zone.

## Section: Working Files

Use the Glob tool to find all _brain/manifest.json files. Then use the Read tool to extract the working_files array from each.

- Show path + age
- Max 5

Working files count appears in the fine print stats. Individual working files are surfaced in /alive:work when focused on a single unit.

## Section: Inputs

Use Glob to check the 03_Inputs/ folder:
- Count files/folders (not counting .DS_Store)
- Flag if count > 0
- Flag if no captures in 3+ days

Input count appears in the action bar as the **d)** digest option. If zero inputs, that action line disappears.

## Section: Stale Units

Check each unit's _brain/manifest.json for the "updated" date:
- Flag if > 7 days (configurable)
- Show as numbered option

Stale units get the **!** attention indicator in the grid. Count appears in the action bar as the **s)** sweep option. If zero stale, that action line disappears.

## Freshness Flags

| Age | Flag | Meaning |
|-----|------|---------|
| < 7 days | (none) | Fresh |
| 7-14 days | `[!]` | Getting stale |
| > 14 days | `[!!]` | Needs attention |

## Edge Cases

**No ALIVE structure:**
```
[?] No ALIVE structure detected.
Run /alive:onboarding to set up.
```

**Empty system (structure exists but no ventures or experiments):**
```
Your ALIVE system is empty. Let's get started.
[1] Create first venture
[2] Create first experiment
[3] Capture some context
```

## The Learning Loop

Daily is the START:

```
DAILY ────► WORK ────► SAVE ────► (repeat)
```

After showing dashboard, remind:
- Pick a number to focus → loads it via `/alive:work`
- When done → `/alive:save` to preserve context
- Tomorrow → back to `/alive:daily`

## Related Skills

- `/alive:work` — Focus on one venture, experiment, or life area
- `/alive:revive` — Resume past session
- `/alive:digest` — Process inputs
- `/alive:save` — End session

