---
user-invocable: true
description: Scaffold a new venture, experiment, life area, project, or area with full structure — _brain/, _working/, CLAUDE.md, and all required files. Use when the user says "create X", "new venture", "new experiment", "new project", "set up X", or "start something new".
plugin_version: "3.1.0"
---

# alive:new

Create a new venture, experiment, life area, project, or area. Scaffold the v2 structure with proper templates.

## UI Treatment

Uses the **ALIVE Shell** — one rounded box, three zones.

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · new                             [date]          │
│  ──────────────────────────────────────────────────────  │
│  [Type selection prompt]                                 │
│  [Summary after creation]                                │
│  ──────────────────────────────────────────────────────  │
│  [ACTIONS]                                               │
│  [✓ file creation confirmations]                         │
╰──────────────────────────────────────────────────────────╯
```

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## When to Use

Invoke when the user wants to:
- Create a new venture, experiment, or life area (top-level unit)
- Create a project nested within an existing venture, experiment, or life area
- Create an area folder within an existing unit
- Set up structure from scratch

## Venture / Experiment / Life Area vs Project vs Area

| Type | Has _brain/ | Has .claude/ | Has _working/ | Has _references/ | Identity | Location |
|------|-------------|--------------|---------------|------------------|----------|----------|
| **Venture** | Yes | Yes | Yes | Yes | `.claude/CLAUDE.md` | Top-level in `04_Ventures/` |
| **Experiment** | Yes | Yes | Yes | Yes | `.claude/CLAUDE.md` | Top-level in `05_Experiments/` |
| **Life Area** | Yes | Yes | Yes | Yes | `.claude/CLAUDE.md` | Top-level in `02_Life/` |
| **Project** | Yes | No | Yes | Yes | `README.md` | Nested within a venture, experiment, or life area |
| **Area** | No | No | No | No | `README.md` | Organizational folder within any unit |

**Ventures, experiments, and life areas** are top-level units with their own state and identity.
**Projects** are nested containers within a venture, experiment, or life area that have their own lifecycle and `_brain/`.
**Areas** are organizational folders within any unit.

## Flow

```
1. Ask: What type? (venture / experiment / life area / project / area)
2. If venture/experiment/life area: Ask for name and details
3. If project: Ask which parent unit and name
4. If area: Ask which parent unit and area name
5. If venture: Offer ICP template
6. Create structure
7. Initialize files
8. Confirm creation
```

## Creating a Venture, Experiment, or Life Area

### Step 1: Gather Information

```
╭──────────────────────────────────────────────────────────╮
│                                                          │
│  ALIVE · new                              2026-02-09     │
│                                                          │
│  ──────────────────────────────────────────────────────  │
│                                                          │
│  What are you creating?                                  │
│                                                          │
│   1) Venture         Revenue intent, business model      │
│   2) Experiment      Testing ground, no model yet        │
│   3) Life area       Personal domain                     │
│   4) Project         Nested within existing unit         │
│   5) Area folder     Organizational only                 │
│                                                          │
╰──────────────────────────────────────────────────────────╯
```

Then:
```
Name? (lowercase, no spaces)
> acme-corp
```

### Step 2: Offer ICP Template (Ventures)

For ventures, offer relevant templates:

```
What type of venture?
 1) Agency — Client work, deliverables
 2) E-commerce — Products, inventory
 3) Creator — Content, courses, community
 4) Job — Employment, bringing work into ALIVE
 5) Custom — Start with generic template
```

### Step 3: Create Structure

**Venture/experiment/life area structure:**
```
04_Ventures/acme-corp/
├── .claude/
│   └── CLAUDE.md          # Identity
├── _brain/
│   ├── status.md          # Current phase
│   ├── tasks.md           # Work queue
│   ├── insights.md        # Domain knowledge
│   ├── changelog.md       # History
│   └── manifest.json      # Structure map
├── _working/              # Drafts
└── _references/           # Reference material (summary .md files + raw/ subfolders)
    ├── emails/
    │   ├── 2026-02-06-client-update.md   # YAML front matter + AI summary + source pointer
    │   └── raw/
    │       └── 2026-02-06-client-update.txt
    └── screenshots/
        ├── 2026-02-06-competitor.md
        └── raw/
            └── 2026-02-06-competitor.png
```

### Step 4: Initialize Files

Use templates from `.claude/templates/brain/` as the starting point for _brain/ files. Fill in the placeholders with user-provided information.

**CLAUDE.md:**
```markdown
# [Name]

**Type:** [Agency | E-com | Creator | Job | Custom]
**Created:** [DATE]

---

## What This Is

[One paragraph: What is this venture? What does it do?]

---

## Stakeholders

[Key people - founders, partners, team]

---

## State

Everything current lives in `_brain/`:
- `status.md` — Phase and focus
- `tasks.md` — Work queue
- `insights.md` — Domain knowledge
- `changelog.md` — History
- `manifest.json` — Structure map

Drafts live in `_working/`.
Reference material lives in `_references/` (summary .md files with raw originals in `raw/` subfolders).
```

**status.md:**
```markdown
# Status

**Goal:** [Single-sentence goal for this venture]
**Phase:** Starting
**Updated:** [DATE]

---

## Key People

## State of Play

## Priorities

## Blockers

## Next Milestone
```

**tasks.md:**
```markdown
# Tasks

## Urgent
(none yet)

## To Do
- [ ] Define initial scope
- [ ] Set first milestone
- [ ] Identify key stakeholders

## Done (Recent)
- [x] Created venture ([DATE])
```

**manifest.json:**
```json
{
  "name": "[Name]",
  "description": "[One sentence]",
  "goal": "[Single-sentence goal]",
  "created": "[DATE]",
  "updated": "[DATE]",
  "session_ids": ["[current-session]"],
  "folders": ["_brain", "_working", "_references"],
  "areas": [],
  "working_files": [],
  "references": [],
  "key_files": [],
  "handoffs": []
}
```

### Step 5: Confirm Creation

```
╭──────────────────────────────────────────────────────────╮
│                                                          │
│  ALIVE · new                              2026-02-09     │
│                                                          │
│  ──────────────────────────────────────────────────────  │
│                                                          │
│  acme-corp                                               │
│  Client services agency for digital transformation       │
│                                                          │
│  type    Venture (Agency)                                │
│  phase   Starting                                        │
│  goal    Ship client portal by end of quarter            │
│  path    04_Ventures/acme-corp/                          │
│                                                          │
│  ──────────────────────────────────────────────────────  │
│                                                          │
│  1) start working on it    2) add initial context        │
│  3) add initial tasks                                    │
│                                                          │
│  ✓ _brain/ · _working/ · CLAUDE.md · manifest            │
│                                                          │
╰──────────────────────────────────────────────────────────╯
```

## Creating an Area

### Step 1: Identify Parent

```
Creating an area (folder).

Where?
[1] 04_Ventures/acme-corp
[2] 04_Ventures/beta
[3] Other (specify)
```

### Step 2: Get Area Details

```
Area name? (lowercase)
> clients

Purpose?
> Active client projects
```

### Step 3: Create Area

**Area structure:**
```
04_Ventures/acme-corp/clients/
└── README.md
```

**README.md:**
```markdown
# Clients

Active client projects.

---

## Contents

Each client gets a subfolder with their project files.

---

## Notes

- Completed clients move to 01_Archive/
- Key contacts should exist in 02_Life/people/
```

### Step 4: Update Parent Manifest

Add to `04_Ventures/acme-corp/_brain/manifest.json`:
```json
{
  "areas": [
    {
      "path": "clients/",
      "description": "Active client projects",
      "has_projects": false
    }
  ]
}
```

### Step 5: Confirm

```
✓ Created 04_Ventures/acme-corp/clients/

Added to manifest.json as area.
```

## ICP Templates

When creating ventures, offer relevant templates:

### Agency Template
```
04_Ventures/[name]/
├── clients/           # Client projects
├── templates/         # Reusable deliverables
├── operations/        # SOPs, processes
└── pipeline/          # Leads, proposals
```

### Creator Template
```
04_Ventures/[name]/
├── content/           # By platform
├── products/          # Courses, digital
├── community/         # Resources
└── funnel/            # Sales assets
```

### E-commerce Template
```
04_Ventures/[name]/
├── products/          # Inventory
├── suppliers/         # Vendor info
├── marketing/         # Campaigns
└── operations/        # Fulfillment
```

### Job Template
```
04_Ventures/[name]/
├── projects/          # Work projects
├── docs/              # Documentation
├── meetings/          # Notes
└── growth/            # Career development
```

## Edge Cases

**Name already exists:**
```
✗ 04_Ventures/acme already exists

[1] Open existing venture
[2] Choose different name
```

**Invalid name:**
```
✗ Invalid name: "Acme Corp!"

Names must be:
- Lowercase
- No spaces (use hyphens)
- Alphanumeric + hyphens only

Try again:
```

## Creating a Project

Projects are containers within a venture, experiment, or life area (or within another project) that have their own lifecycle (and therefore their own `_brain/`).

### When to Create a Project

| Parent Type | Project Examples |
|-------------|-----------------|
| Agency venture | Clients, retainers |
| E-commerce venture | Campaigns, product lines |
| Creator venture | Courses, launches |
| Experiment | Iterations, sprints |

**Rule:** If it can be started, paused, or completed independently — it gets `_brain/`.

### Step 1: Identify Context

```
Creating a project.

You're working in: 04_Ventures/acme-agency/

What are you creating?
[1] Client (for agency ventures)
[2] Campaign (for ecommerce/marketing)
[3] Project (generic)
[4] Custom
```

### Step 2: Get Details

```
Name? (lowercase, hyphens)
> bigco

One-line description?
> Enterprise client, $10k/mo retainer
```

### Step 3: Create Structure

**Project structure:**
```
04_Ventures/acme-agency/clients/bigco/
├── _brain/
│   ├── status.md
│   ├── tasks.md
│   ├── insights.md
│   ├── changelog.md
│   └── manifest.json
├── _working/         ← Project gets its OWN _working/
├── _references/      ← Project gets its OWN _references/
└── README.md
```

**IMPORTANT:** Each project gets its own `_working/` and `_references/` folders. Working files for this project go here, NOT in the parent's folders.

```
# WRONG - using parent's _working/
04_Ventures/acme-agency/_working/clients/bigco/proposal.md

# RIGHT - project has its own _working/
04_Ventures/acme-agency/clients/bigco/_working/proposal.md
```

### Step 4: Initialize Files

**status.md:**
```markdown
# Status

**Goal:** [Single-sentence goal for this project]
**Phase:** Starting
**Updated:** [DATE]

---

## Key People

## State of Play

## Priorities

## Blockers

## Next Milestone
```

**tasks.md:**
```markdown
# Tasks

## Urgent
(none yet)

## To Do
- [ ] Define scope and deliverables
- [ ] Set up communication cadence
- [ ] Identify key contacts

## Done (Recent)
- [x] Created project ([DATE])
```

**changelog.md:**
```markdown
# Changelog

## [DATE] — Created

Project created within 04_Ventures/acme-agency/clients/.

**Type:** Client
**Description:** Enterprise client, $10k/mo retainer

---
```

**manifest.json:**
```json
{
  "name": "bigco",
  "description": "Enterprise client, $10k/mo retainer",
  "goal": "[Single-sentence goal]",
  "created": "[DATE]",
  "updated": "[DATE]",
  "session_ids": ["[current-session]"],
  "folders": ["_brain", "_working", "_references"],
  "areas": [],
  "working_files": [],
  "references": [],
  "key_files": [],
  "handoffs": []
}
```

### Step 5: Update Parent

Add to `04_Ventures/acme-agency/_brain/manifest.json`:
```json
{
  "areas": [
    {
      "path": "clients/",
      "has_projects": true,
      "projects": ["bigco"]
    }
  ]
}
```

Add to `04_Ventures/acme-agency/_brain/changelog.md`:
```markdown
## [DATE] — Created client: bigco

Added new client project: bigco (Enterprise client, $10k/mo retainer)
```

### Step 6: Confirm

```
✓ Created 04_Ventures/acme-agency/clients/bigco/

Structure:
├── _brain/
│   ├── status.md
│   ├── tasks.md
│   ├── insights.md
│   ├── changelog.md
│   └── manifest.json
├── _working/
├── _references/
└── README.md

Parent changelog updated.
Parent manifest updated.

Next: /alive:work bigco to start working.
```

## Project vs Area

| Question | Project | Area |
|----------|---------|------|
| Has its own lifecycle? | Yes | No |
| Can be "done"? | Yes | No |
| Needs status tracking? | Yes | No |
| Gets `_brain/`? | Yes | No |
| Gets `_working/`? | Yes | No |
| Gets `_references/`? | Yes | No |

**Examples:**
- `clients/bigco/` → Project (has lifecycle)
- `templates/` → Area (organizational only)
- `campaigns/summer-sale/` → Project (has lifecycle)
- `brand/` → Area (organizational only)

## Related Skills

- `/alive:work` — Start working on the new venture, experiment, life area, or project
- `/alive:onboarding` — Full system setup (not just one unit)
- `/alive:daily` — See all ventures and experiments after creating
