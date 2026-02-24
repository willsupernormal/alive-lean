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

## Why This Matters

**AI forgets. ALIVE remembers.**

But only if you run the loop. Each cycle:
- Captures what happened (save)
- Surfaces what's stale (daily)
- Focuses attention (do)
- Compounds context (repeat)

Skip the loop → context leaks.
Run the loop → context compounds.

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
- `_brain/manifest.json` — What exists
- `_brain/changelog.md` (first 200 lines) — Recent session history, decisions, context

**What it loads on demand:**
- `insights.md` — Domain knowledge, when making decisions that past learnings could inform, or when the user asks "what did we learn about X"
- `_references/` raw files — When deeper context on a specific reference is needed (manifest index is always loaded for awareness)
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
| Routine | Changelog, tasks, status, manifest |
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

---

## The Compound Effect

Context compounds like interest:

```
Day 1: Start venture, save context
Day 2: Resume with full context, make progress, save
Day 3: Resume with 2 days of context, make more progress, save
...
Day 30: You have a month of compounded context
```

**Without the loop:**
```
Day 1: Start venture
Day 2: Where was I? Reconstruct context...
Day 3: Start over again...
```

---

## Breaking the Loop

Common failure modes:

| Failure | Impact | Fix |
|---------|--------|-----|
| Skip daily | Miss urgent tasks, stale context | Run daily every session |
| Skip save | Lose progress, decisions | Always save before leaving |
| Work on multiple units | Context overflow, shallow work | Use `/alive:work` for single focus |
| Never close threads | Endless "ongoing" list | Review threads weekly |

---

## Integration with Other Skills

The loop works with the full skill set:

| Skill | Role in Loop |
|-------|--------------|
| `/alive:capture` | Capture context → triggers during WORK |
| `/alive:digest` | Process 03_Inputs/ → part of DAILY |
| `/alive:revive` | Resume old session → alternative to DO |
| `/alive:sweep` | Clean stale context → periodic maintenance |

---

## Summary

```
DAILY → See everything, pick focus
WORK  → Load one unit, go deep
SAVE  → Preserve what happened
REPEAT → Context compounds

Skip the loop = context leaks
Run the loop = context compounds
```

The loop is the system. Everything else supports it.
