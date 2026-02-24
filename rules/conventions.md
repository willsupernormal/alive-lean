# Conventions

File naming, _brain files, and manifest schema.

---

## Directory Structure

```
alive/
├── .claude/
│   ├── CLAUDE.md         # System identity
│   ├── state/            # System logs (session-log, file-changes)
│   ├── rules/            # Behavioral rules
│   ├── hooks/            # Hook scripts
│   └── templates/        # Scaffolding templates
├── 01_Archive/           # Inactive (mirrors structure)
├── 02_Life/              # Personal — always has people/
│   ├── people/           # All people (source of truth)
│   └── [name]/           # Life area
├── 03_Inputs/            # Incoming context, triage
├── 04_Ventures/          # Revenue-generating
│   └── [name]/           # Venture
└── 05_Experiments/       # Testing grounds
    └── [name]/           # Experiment
```

---

## Terminology

| Term | Where it lives | Has `_brain/`? | Example |
|------|---------------|---------------|---------|
| **Venture** | Top-level under `04_Ventures/` | Yes | `04_Ventures/acme/` |
| **Experiment** | Top-level under `05_Experiments/` | Yes | `05_Experiments/cricket-grid/` |
| **Life area** | Top-level under `02_Life/` | Yes | `02_Life/health/` |
| **Project** | Nested within any of the above (or within other projects) | Yes | `04_Ventures/acme/clients/bigco/` |
| **Area** | Organizational folder at any level | No | `04_Ventures/acme/clients/` |

**Ventures**, **experiments**, and **life areas** are top-level containers with their own state (`_brain/`, `_working/`, `_references/`). Every one MUST have a `CLAUDE.md` — ideally in `.claude/CLAUDE.md`, but root-level `CLAUDE.md` is also valid.

**Projects** are nested containers within a venture, experiment, or life area that have their own independent lifecycle. They also get `_brain/`, `_working/`, and `_references/`.

**Areas** are organizational folders. They get a `README.md`, nothing more. Areas can contain projects within them (e.g. `clients/` is an area, `clients/bigco/` is a project).

In dev/internal contexts, **unit** refers generically to anything with a `_brain/` (venture, experiment, life area, or project). In user-facing contexts, always use the specific term.

---

## Projects

Projects are containers within a venture, experiment, or life area that have their own lifecycle. They get their own `_brain/`, `_working/`, and `_references/`. Projects can nest within other projects too.

**The rule:** If it can be started, paused, or completed independently — it's a project and gets `_brain/`, `_working/`, and `_references/`.

| Container | Type | Gets _brain/? | Why |
|-----------|------|---------------|-----|
| `04_Ventures/agency/` | Venture | Yes | Top-level under Ventures |
| `04_Ventures/agency/clients/bigco/` | Project | Yes | Independent lifecycle (can be "done") |
| `04_Ventures/agency/clients/` | Area | No | Organizational folder |
| `04_Ventures/agency/brand/` | Area | No | Organizational folder |
| `04_Ventures/shop/campaigns/summer/` | Project | Yes | Independent lifecycle |
| `04_Ventures/shop/products/` | Area | No | Organizational folder |

**Project structure:**
```
04_Ventures/agency/clients/bigco/
├── _brain/           ← Project state
│   ├── status.md
│   ├── tasks.md
│   └── ...
├── _working/         ← Project drafts (NOT in parent's _working/)
│   └── proposal-v0.md
├── _references/      ← Project references (NOT in parent's _references/)
└── README.md
```

**WRONG:** `04_Ventures/agency/_working/clients/bigco/proposal.md`
**RIGHT:** `04_Ventures/agency/clients/bigco/_working/proposal.md`

**When creating projects:**
1. Create `_brain/` with status.md, tasks.md, insights.md, changelog.md, manifest.json
2. Create `_working/` for drafts (at project level, not parent)
3. Create `_references/` for reference material (at project level, not parent)
4. Log creation in parent's `_brain/changelog.md`
5. Update parent's `_brain/manifest.json`

Use `/alive:new` to create projects properly.

---

## _brain/ Files

Every venture, experiment, life area, and project has `_brain/` with these files:

| File | Purpose | Update frequency |
|------|---------|------------------|
| `status.md` | Unit summary and state of play | Refined incrementally |
| `tasks.md` | Work queue | Frequently |
| `insights.md` | Unit-scoped domain knowledge | When domain knowledge is gained |
| `changelog.md` | Session history + decisions | Every session |
| `manifest.json` | Structure map with file summaries | On file changes |

### status.md

```markdown
# Status

**Goal:** [What are you building toward?]
**Phase:** [Starting | Building | Launching | Growing | Maintaining]
**Updated:** [DATE]

---

## Key People

## State of Play

## Priorities

## Blockers

## Next Milestone
```

Status is a living summary of the unit. If someone reads only this file, they understand the whole picture. It gets refined incrementally — new information replaces outdated information, not stacks on top of it. If the file is growing session over session, you're appending when you should be refining.

### tasks.md

```markdown
# Tasks

## Urgent
- [ ] Critical task @urgent

## Active
- [~] Currently working on this

## To Do
- [ ] Not yet started

## Done (Recent)
- [x] Completed task (2026-01-23)
```

**Markers:**
- `[ ]` — Not started
- `[~]` — In progress
- `[x]` — Done
- `@urgent` — Priority flag

### insights.md

```markdown
# Insights

Unit-scoped domain knowledge. Facts, principles, and learnings
that should influence future work on this unit.

NOT for: decisions (changelog), Claude patterns (auto-memory),
identity/rules (CLAUDE.md), people (status.md + 02_Life/people/).

---

## [DATE] — [Title]

**Category:** [strategy | product | process | market]
**Learning:** What was learned
**Evidence:** How we know this
**Applies to:** Where this matters

---
```

If the insight is about how Claude operates, an API quirk, or a technical workflow pattern — it belongs in auto-memory, not insights.md. Offer to save it to `~/.claude/projects/*/memory/MEMORY.md` instead.

### changelog.md

```markdown
# Changelog

## 2026-01-23 — Session Summary
**Session:** abc123-def456

### Changes
- What was done

### Decisions
- **Decision name:** What was decided. Why. What was rejected.

### Next
- What's coming

---
```

**Note:** decisions.md is removed. Decisions live in changelog with the `### Decisions` section.

---

## Manifest Schema

```json
{
  "name": "unit-name",
  "description": "One sentence description",
  "goal": "Single-sentence goal that filters all decisions",
  "created": "2026-01-20",
  "updated": "2026-01-23",
  "session_ids": ["abc12345", "def67890"],

  "folders": ["_brain", "_working", "_references", "clients", "content"],

  "areas": [
    {
      "path": "clients/",
      "description": "Active client work",
      "has_projects": false,
      "files": [
        {
          "path": "README.md",
          "description": "Client area overview",
          "date_created": "2026-01-20",
          "date_modified": "2026-01-23",
          "session_ids": ["abc12345"]
        }
      ]
    },
    {
      "path": "content/",
      "description": "Marketing and brand content",
      "files": [
        {
          "path": "landing-page.md",
          "description": "Main landing page copy",
          "date_created": "2026-01-22",
          "date_modified": "2026-01-23",
          "session_ids": ["xyz789", "abc12345"]
        }
      ]
    }
  ],

  "working_files": [
    {
      "path": "_working/landing-v0.html",
      "description": "Draft landing page with hero and features",
      "date_created": "2026-01-20",
      "date_modified": "2026-01-23",
      "session_ids": ["abc123"]
    }
  ],

  "key_files": [
    {
      "path": "CLAUDE.md",
      "description": "Identity and navigation",
      "date_created": "2026-01-20",
      "date_modified": "2026-01-23"
    }
  ],

  "handoffs": [],

  "references": [
    {
      "path": "_references/emails/2026-02-06-supplier-quote.md",
      "type": "email",
      "description": "Supplier confirms 15% price increase, bulk order before Feb 28",
      "date_created": "2026-02-06",
      "date_modified": "2026-02-06",
      "session_ids": ["xyz789"]
    }
  ]
}
```

**Key fields:**

| Field | Location | Description |
|-------|----------|-------------|
| `goal` | Manifest root | Single-sentence goal — filters decisions, enables alignment advice |
| `session_ids` | Manifest root + file entries | Array of session IDs that have touched this unit/file. Append new sessions, don't overwrite. |
| `description` | All file entries | AI-generated one-liner describing the file. Standardised everywhere (not `summary`). |
| `date_created` | File entries | ISO date when the file was first added to the manifest |
| `date_modified` | File entries | ISO date when the file was last modified |
| `key_files` | Manifest root | Important reference files at root or cross-cutting |
| `handoffs` | Manifest root | Pending session handoffs for `/alive:work` to detect on load. Uses singular `session_id` (one handoff = one session). |
| `areas[].has_projects` | Area entries | True if area contains projects (e.g. clients/) |
| `references` | Manifest root | Lightweight index of `_references/` files. Each entry has `path`, `type`, `description`, `date_created`, `date_modified`, `session_ids`. Three-tier access: manifest index → summary .md → raw/ file. |

**File entry schema** (applies to `areas[].files[]`, `working_files[]`, `key_files[]`, `references[]`):

```json
{
  "path": "relative/path/to/file.md",
  "description": "What this file is/contains",
  "date_created": "2026-01-20",
  "date_modified": "2026-01-23",
  "session_ids": ["abc12345"]
}
```

- `date_created` and `date_modified` — ISO date format (YYYY-MM-DD)
- `session_ids` — Array. Append the current session ID when modifying. Optional for files not created/tracked by sessions (e.g. `CLAUDE.md`).
- `references[]` additionally has `type` (email, call, screenshot, etc.)

---

## _references/ Structure

**ALL external context put into the ALIVE system.** Emails, messages, call transcripts, screenshots, articles, documents — any source material worth preserving.

Each content TYPE gets a subfolder. Inside each type folder, `.md` summary files sit at root level and a `raw/` subfolder holds the original source files.

```
_references/
├── meeting-transcripts/
│   ├── 2026-02-08-content-planning.md        ← YAML front matter + detailed AI summary + source pointer
│   ├── 2026-02-04-partner-sync.md
│   └── raw/
│       ├── 2026-02-08-content-planning.txt
│       └── 2026-02-04-partner-sync.txt
├── emails/
│   ├── 2026-02-06-supplier-quote.md
│   └── raw/
│       └── 2026-02-06-supplier-quote.txt
├── screenshots/
│   ├── 2026-02-06-competitor-landing.md       ← front matter + analysis + source pointer
│   └── raw/
│       └── 2026-02-06-competitor-landing.png
└── documents/
    ├── 2026-02-06-contract-scan.md
    └── raw/
        └── 2026-02-06-contract-scan.pdf
```

### Access Pattern

```
Tier 1: manifest.json        → Quick index (always loaded)
Tier 2: Summary .md file      → Detailed AI summary + rich metadata (on demand)
Tier 3: raw/ file             → Original content — full text or binary (on demand)
```

The summary `.md` should be detailed enough that you rarely need the raw file.

### Subfolders

Dynamic — created by content type, not prescribed. Examples: `emails/`, `calls/`, `meeting-transcripts/`, `screenshots/`, `messages/`, `articles/`, `documents/`. Each type folder contains a `raw/` subfolder for original files.

### File Naming

Summary files and raw files share the same base name with different extensions:

| File | Pattern | Example |
|------|---------|---------|
| Summary | `YYYY-MM-DD-descriptive-name.md` | `emails/2026-02-06-supplier-quote.md` |
| Raw (text) | `YYYY-MM-DD-descriptive-name.txt` | `emails/raw/2026-02-06-supplier-quote.txt` |
| Raw (binary) | `YYYY-MM-DD-descriptive-name.ext` | `screenshots/raw/2026-02-06-competitor-landing.png` |

**Raw file renaming:** When incoming files have garbage names (e.g. `CleanShot 2026-02-06 at 14.32.07@2x.png`, `IMG_4521.jpg`, `document (3).pdf`), rename them to the `YYYY-MM-DD-descriptive-name.ext` convention before storing. The summary `.md` and raw file should share the same base name.

### Text Content (emails, transcripts, messages)

Summary `.md` with YAML front matter + `## Summary` (with subheaders for key points, action items, decisions as appropriate) + `## Source` pointer to raw file:

```markdown
---
type: email
date: 2026-02-06
description: Supplier confirms 15% price increase on fabric starting March
source: John Smith
tags: [pricing, supplier]
subject: Q1 pricing update
from: john@supplier.com
to: team@company.com
---

## Summary

John confirms a 15% price increase on all fabric orders starting March 1.
Recommends placing a bulk order before Feb 28 to lock in current pricing.

### Key Points
- 15% increase effective March 1
- Bulk order before Feb 28 locks current rate
- Minimum order: 500 units for bulk pricing

### Action Items
- Decide on bulk order quantity by Feb 20
- Confirm shipping timeline with warehouse

## Source

`raw/2026-02-06-supplier-quote.txt`
```

### Non-Text Content (screenshots, videos, PDFs)

Same pattern — summary `.md` at type root, original in `raw/`:

```
_references/screenshots/
├── 2026-02-06-competitor-landing.md
└── raw/
    └── 2026-02-06-competitor-landing.png
```

Summary `.md` uses `## Analysis` instead of `## Summary`:

```markdown
---
type: screenshot
date: 2026-02-06
description: Competitor landing page showing new $49/mo pricing tier
source: competitor website
tags: [competitor, pricing]
---

## Analysis

[AI-generated detailed description — what's shown, key information,
relevant observations. Detailed enough that you rarely need the original.]

## Source

`raw/2026-02-06-competitor-landing.png`
```

### Front Matter Fields

| Field | Required | Notes |
|-------|----------|-------|
| `type` | Yes | email, call, screenshot, message, article, document, etc. |
| `date` | Yes | ISO format |
| `description` | Yes | One-line (mirrors manifest entry) |
| `source` | Usually | Who/where it came from |
| `tags` | Usually | Array for searchability |
| `from`, `to`, `subject` | email | Email metadata |
| `participants`, `duration` | call | Call metadata |
| `platform` | message | Slack, iMessage, etc. |

### Manifest Entry

```json
"references": [
  {
    "path": "_references/emails/2026-02-06-supplier-quote.md",
    "type": "email",
    "description": "Supplier confirms 15% price increase, bulk order before Feb 28",
    "date_created": "2026-02-06",
    "date_modified": "2026-02-06",
    "session_ids": ["abc12345"]
  }
]
```

---

## File Naming

### _working/ Files

Pattern: `[unit]_[context]_[name].ext`

```
04_Ventures/acme/_working/
├── acme_landing-page-draft.md        ✓
├── acme_client_proposal-v1.md        ✓
├── landing-page-draft.md             ✗ (no context)
```

**Rule:** Anyone reading the filename should know where it belongs.

### Versioning

| Stage | Location | Example |
|-------|----------|---------|
| v0.x | `_working/` | `acme_landing-v0.html` |
| v1-draft | Folder | `content/landing-v1-draft.html` |
| v1 | Folder | `content/landing-v1.html` |

Promote from _working/ when draft is complete.

---

## System Logs

System-wide logs live in `.claude/state/`:

| File | Purpose |
|------|---------|
| `session-log.jsonl` | Session start/end events |
| `file-changes.jsonl` | Audit trail of all file edits |
| `commit-log.jsonl` | Explicit context saves |

Format: JSON Lines (one JSON object per line, append-friendly).

---

## Archive

**NEVER DELETE. ALWAYS ARCHIVE.**

Files should never be deleted from ALIVE. Always move to archive instead. This preserves history and allows recovery.

When something is done, move to `01_Archive/[original-path]`:

```
Active:   04_Ventures/acme/clients/globex/
Archived: 01_Archive/04_Ventures/acme/clients/globex/
```

Archive mirrors the working structure.

**When cleaning up processed files:**
```bash
# Wrong
rm -rf 03_Inputs/old-files/

# Right
mv 03_Inputs/old-files/ 01_Archive/03_Inputs/2026-02-04-cleanup/
```

**Protected files:** Never delete or archive these special files:

| File | Location | Purpose |
|------|----------|---------|
| `Icon` or `Icon\r` | Domain root folders (`01_Archive/`, `02_Life/`, etc.) | macOS folder icons |
| `.DS_Store` | Any folder | macOS folder metadata |

These are system files that should be ignored, not processed or moved.

---

## People

Source of truth for people is `02_Life/people/`.

Other ventures, experiments, and life areas reference — don't duplicate:

```markdown
# In 04_Ventures/acme/clients/globex/README.md

Key Contact: John Smith
See: 02_Life/people/john-smith.md
```

---

## Third-Party Skill Overrides

When using third-party skills, ALIVE conventions take precedence.

### Plan File Locations

| Skill Default | ALIVE Override |
|---------------|----------------|
| `{root}/docs/plans/` | `{venture}/_working/plans/` |

**Why:** Plans are work-in-progress until approved. WIP files belong in `_working/`, not permanent documentation folders.

```
# Wrong
~/alive/docs/plans/feature-plan.md

# Right
~/alive/04_Ventures/acme/_working/plans/feature-plan.md
```

**When brainstorming/planning:**
1. Create plans in `{current-unit}/_working/plans/`
2. Once approved and implemented, promote to appropriate location or archive
3. Never create `docs/plans/` at the ALIVE root

### General Override Principle

**Before ANY skill creates files, ALWAYS check:**

1. **Am I in an ALIVE unit?** — Check for `_brain/` folder
2. **Does this content fit somewhere in ALIVE structure?**
   - Plans/specs/designs → `{unit}/_working/plans/`
   - Drafts → `{unit}/_working/`
   - Completed docs → appropriate area within the unit
   - Session artifacts → `{unit}/_working/sessions/`
3. **Use ALIVE folder conventions** — Numbered domains, `_brain/`, etc.

**Never create orphan files at:**
- ALIVE root (`~/alive/`)
- Random `docs/` folders outside ventures/experiments
- `/tmp/` or scratchpad (unless truly temporary)

**The question to ask:** "Where in this venture, experiment, or life area does this file belong?"
