---
user-invocable: false
description: Search past context, decisions, and sessions across ALIVE. Use when the user says "find X", "search for X", "recall X", "when did we X", "what did we decide about X", or "remember when we X".
plugin_version: "3.1.0"
---

# alive:recall

Quick context lookup. Find past decisions, sessions, insights, or files.

## UI Treatment

Uses the **ALIVE Shell** — Tier 3: Utility.

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · recall                         [search-query]    │
│  ──────────────────────────────────────────────────────── │
│  [Search results with sources]                            │
│  ──────────────────────────────────────────────────────── │
│  [Result count + search path]                             │
╰──────────────────────────────────────────────────────────╯
```

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## When to Invoke

Trigger on past-tense recall intent:
- "Remember when we..." / "What did we decide about..."
- "When did we discuss..." / "Where's that thing about..."
- "Find X" / "Search for X" / "Look up X"

**This is a quick lookup, not a research project.** Search, show results, move on.

## Search Order

Always search the **current unit first**. If no unit is loaded, ask which one.

Within the unit, check these locations in order:

| Priority | Location | What's There |
|----------|----------|--------------|
| 1 | `_brain/manifest.json` | File index, reference summaries, structure |
| 2 | `_brain/changelog.md` | Decisions, session history, what happened |
| 3 | `_references/**/*.md` | Summaries of emails, calls, articles (read YAML front matter, skip raw/) |
| 4 | `_brain/insights.md` | Domain knowledge |

**Stop as soon as you find what they're looking for.** Don't search everything just because you can.

### Searching _references/

Reference files have YAML front matter that acts as a quick index. When searching `_references/`, read the front matter of each `.md` file (NOT the raw/ files). The front matter contains:

```yaml
---
type: email | call | screenshot | document | article | message
date: 2026-02-06
summary: One-line description of what this reference contains
source: Where it came from (person name, tool, etc.)
participants: [Will, Ben, Jono]     # calls/meetings
from: sender@email.com              # emails
to: recipient                       # emails
subject: Email subject line         # emails
duration: ~27min                    # calls/meetings
tags: [keyword, keyword, keyword]
---
```

**Scan the `summary`, `tags`, `subject`, and `source` fields for matches.** These are designed to be searchable without reading the full file body. Only read below the front matter if the user asks to see more detail.

## Output

Show the ALIVE UI wrapper, the breadcrumb trail of where you looked, and the results:

```
╭──────────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                          │
│    ▄▀█ █░░ █ █░█ █▀▀                                                                     │
│    █▀█ █▄▄ █ ▀▄▀ ██▄            recall • "pricing"                                       │
│                                                                                          │
│  ──────────────────────────────────────────────────────────────────────────────────────  │
│                                                                                          │
│  ▸ searching 04_Ventures/acme/_brain/manifest.json                                       │
│    └─ no file matches                                                                    │
│  ▸ searching 04_Ventures/acme/_brain/changelog.md                                        │
│    └─ 2 matches                                                                          │
│                                                                                          │
│  FOUND                                                                                   │
│  ──────────────────────────────────────────────────────────────────────────────────────  │
│  [1] 2026-01-23 — Pricing model: Chose $97/mo. Rejected $47 (too cheap).                │
│  [2] 2026-01-20 — Pricing page: Show annual pricing first.                               │
│                                                                                          │
│  ──────────────────────────────────────────────────────────────────────────────────────  │
│  [#] View full entry    [w] Search wider    [d] /alive:work                              │
│                                                                                          │
│  ──────────────────────────────────────────────────────────────────────────────────────  │
│                                                                              ALIVE v3.1.0│
╰──────────────────────────────────────────────────────────────────────────────────────────╯
```

**Key rules:**
- Show each source you checked as a `▸` breadcrumb — even when it's a miss. This shows the system working.
- Number the results. Keep descriptions to one line each.
- **`[w]` Search wider** — offer to expand to all units if scoped to one.
- **`[d]` /alive:work** — offer to load the full context. Especially useful at conversation start when the user might want to keep working.

## No Unit Loaded

If the user asks a recall question with no unit context loaded:

1. Check if they mentioned a name → scope to that
2. If not → ask: "Which venture, experiment, or life area should I search? Or [a] search all?"
3. After showing results, **always offer `/alive:work`** — they likely want to get into it

## No Results

```
▸ searched manifest, changelog, references, insights
  └─ no matches for "quantum computing"

[w] Search all units    [a] Try different terms
```

## Wider Search

When user picks `[w]`, search `_brain/changelog.md` and `_brain/manifest.json` across all units in `04_Ventures/` and `05_Experiments/`. Show which ones had hits.

## Related Skills

- `/alive:work` — Load full context after finding what you need
