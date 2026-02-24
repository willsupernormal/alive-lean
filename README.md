# ALIVE

> The operating system for your context.

You're not just chatting with AI — you're building with it. ALIVE gives Claude persistent memory across sessions. Your decisions, tasks, insights — they survive context resets.

## Quick Start

**1. Install the plugin**
```
claude plugin marketplace add SuperSystemsAdmin/alive-context
claude plugin install alive@alive-local
```

**2. Restart Claude Code** (plugins need a fresh session to load)

**3. Create your ALIVE folder**

Pick a spot that syncs across devices:
- **iCloud:** `~/Library/Mobile Documents/com~apple~CloudDocs/alive`
- **Dropbox:** `~/Dropbox/alive`
- **Local:** `~/alive` or `~/Documents/alive`

Create the folder however you like — Finder, terminal, whatever works.

**4. Open Claude Code in that folder**

Either:
- Right-click the folder → "New Terminal at Folder" → type `claude`
- Or in terminal: `cd /path/to/your/alive && claude`

**5. Run setup**
```
/alive:onboarding
```

**6. Start working**
```
/alive:work
```

That's it. Your AI now has persistent memory.

## The Framework

| Letter | Domain | Purpose |
|--------|--------|---------|
| **A** | 01_Archive/ | Inactive items, preserved |
| **L** | 02_Life/ | Personal — plans, people, patterns |
| **I** | 03_Inputs/ | Incoming context, triage |
| **V** | 04_Ventures/ | Businesses with revenue intent |
| **E** | 05_Experiments/ | Testing grounds |

**Life first, always.** Ventures and experiments are expressions of life.

## How It Works

Every venture, experiment, and life area has `_brain/`, `_working/`, and `_references/`:

```
04_Ventures/mycompany/
├── _brain/
│   ├── status.md      # Unit summary — state of play, key people, priorities
│   ├── tasks.md       # What needs doing
│   ├── changelog.md   # What happened + decisions
│   └── insights.md    # Unit-scoped domain knowledge
├── _working/           # Drafts in progress
└── _references/        # Reference materials and source documents
```

Claude reads these files to understand your context. Updates them as you work. Everything persists.

## Core Skills

| Skill | When to Use |
|-------|-------------|
| `/alive:daily` | "Start my day" — morning dashboard across everything |
| `/alive:work` | "Let's work on X" — loads context, starts session |
| `/alive:save` | "We're done" — logs progress, cleans up |
| `/alive:new` | "Create a venture/experiment" — scaffolds structure |
| `/alive:capture` | "Here's some context" — capture and route to ALIVE |
| `/alive:digest` | "Process my inputs" — triages incoming context |
| `/alive:recall` | "What did we decide about X?" — searches history |
| `/alive:archive` | "Done with X" — moves to archive |
| `/alive:sweep` | "Clean up" — audits for stale context |
| `/alive:migrate` | "Import these files" — bulk import into ALIVE |
| `/alive:revive` | "Pick up where I left off" — resume a past session |
| `/alive:upgrade` | "Update system" — sync to latest version |
| `/alive:onboarding` | "Get started" — first-time setup wizard |
| `/alive:help` | "How does X work?" — contextual guidance |

## Community

Join 500+ operators building with AI:
**skool.com/aliveoperators**

- Templates for every business type
- Live Q&A and support
- Courses on terminal mastery
- Case studies from real operators

## Philosophy

1. **Life first, always** — Life is the foundation, not a category
2. **File-based everything** — Portable, grep-able, yours
3. **Zero-context documentation** — Anyone can understand with no prior knowledge
4. **Don't confabulate** — Query before answering, read before assuming
5. **Show the work** — Make retrieval visible, build trust

## Support

- Community: skool.com/aliveoperators
- Issues: github.com/SuperSystemsAdmin/alive-context

---

MIT License
