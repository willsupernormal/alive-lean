# Learning Loop

The core rhythm of ALIVE. This is how context compounds.

---

## The Loop

```
DAILY → WORK → SAVE → REPEAT
```

| Step | Skill | Purpose |
|------|-------|---------|
| **Daily** | `/alive:daily` | Morning check-in. See all units, goals, urgent tasks, inputs. |
| **Work** | `/alive:work` | Focus on ONE unit. Load context, start working. |
| **Save** | `/alive:save` | End session. Log changes, decisions, next steps. |
| **Repeat** | — | Come back tomorrow. Context compounds. |

---

## Daily: The Heartbeat

If you're not running `/alive:daily` regularly, you're not using the system.

**What it shows:**
- Goals across all units
- Ongoing threads (sessions marked "ongoing")
- Urgent tasks across units
- Working files that might be stale
- Items in `03_Inputs/` awaiting triage

**When to run:**
- Start of each work session
- Beginning of day
- After being away

---

## Work: Single Focus

`/alive:work` loads ONE unit's context. This is intentional.

**Why single focus:**
- Context window is finite
- Deep work requires focus
- Switching costs are real

**What it loads (mandatory):**
- `_brain/status.md` — Unit summary and state of play
- `_brain/tasks.md` — What needs doing
- `_brain/changelog.md` (first 200 lines) — Recent session history, decisions, context

**What it loads on demand:**
- `insights.md` — Domain knowledge, when making decisions that past learnings could inform, or when the user asks "what did we learn about X"
- `_references/` summaries — When deeper context on a specific reference is needed (Glob `_references/**/*.md` on demand)
- Other units — Ask before cross-loading

---

## Save: The Commit

`/alive:save` is how context gets preserved. Without it, work disappears.

**The 3-2-1 flow:**
1. **WHY** — Save type (ending, checkpoint, pre-compact)
2. **WHAT'S NEXT** — Thread status (ongoing, paused, closed)
3. **HOW** — Quality tier (routine, productive, important, breakthrough)

**Quality-based escalation:**

| Quality | Actions |
|---------|---------|
| Routine | Changelog, tasks, status, front matter |
| Productive | + Check `_working/` files, promote if ready |
| Important | + Extract domain knowledge to `insights.md` (not Claude operational patterns — those go to auto-memory) |
| Breakthrough | + Create memory in `_brain/memories/`, can update CLAUDE.md |

---

## Session Thread States

Every session has a thread state:

| State | Meaning | Next |
|-------|---------|------|
| **Ongoing** | Work continues | Resume with `/alive:work` |
| **Paused** | Intentionally on hold | Resurface when ready |
| **Closed** | This thread is done | Archive if unit complete |

**Ongoing threads** surface in `/alive:daily` so you don't lose track.
