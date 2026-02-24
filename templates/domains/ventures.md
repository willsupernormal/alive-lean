# Ventures Domain Template

**Domain:** 04_Ventures/
**Purpose:** Businesses with revenue intent

---

## Structure

```
04_Ventures/
└── [name]/           # Each venture is a unit
    ├── .claude/
    │   └── CLAUDE.md # Identity
    ├── _brain/
    │   ├── status.md
    │   ├── tasks.md
    │   ├── insights.md
    │   ├── changelog.md
    │   └── manifest.json
    ├── _working/     # Drafts
    ├── _references/  # Reference materials
    └── [areas]/      # Organizational folders
```

---

## Venture Types (ICP Templates)

### Agency

Client work, deliverables, retainers.

```
04_Ventures/[name]/
├── clients/          # Client projects
├── templates/        # Reusable deliverables
├── operations/       # SOPs, processes
└── pipeline/         # Leads, proposals
```

### Creator

Content, courses, community.

```
04_Ventures/[name]/
├── content/          # By platform (twitter/, youtube/, etc.)
├── products/         # Courses, digital products
├── community/        # Resources for community
└── funnel/           # Sales assets
```

### E-commerce

Products, inventory, fulfillment.

```
04_Ventures/[name]/
├── products/         # Inventory
├── suppliers/        # Vendor info
├── marketing/        # Campaigns
└── operations/       # Fulfillment
```

### Job

Employment brought into ALIVE.

```
04_Ventures/[name]/
├── projects/         # Work projects
├── docs/             # Documentation
├── meetings/         # Notes
└── growth/           # Career development
```

### Custom

Generic starting point.

```
04_Ventures/[name]/
├── .claude/
├── _brain/
├── _working/
└── _references/
```

---

## CLAUDE.md Template

```markdown
# [Venture Name]

**Type:** [Agency | Creator | E-commerce | Job | Custom]
**Phase:** [Starting | Building | Launching | Growing | Maintaining]
**Created:** [DATE]

---

## What This Is

[One paragraph: What is this venture? What does it do?]

---

## Goal

[Single sentence: What is this venture trying to achieve?]

---

## Stakeholders

- [Founder/Owner]
- [Team members]
- [Key partners]

---

## State

Everything current lives in `_brain/`:
- `status.md` — Phase and focus
- `tasks.md` — Work queue
- `insights.md` — Domain knowledge
- `changelog.md` — History
- `manifest.json` — Structure map

Drafts live in `_working/`.
```

---

## status.md Template

```markdown
# Status

**Goal:** [What are you building toward?]
**Phase:** Starting
**Updated:** [DATE]

---

## Key People

## State of Play

## Priorities

## Blockers

## Next Milestone
```

---

## tasks.md Template

```markdown
# Tasks

## Urgent
(none yet)

## Active
(none yet)

## To Do
- [ ] Define initial scope
- [ ] Set first milestone
- [ ] Identify key stakeholders

## Done (Recent)
- [x] Created venture ([DATE])
```

---

## manifest.json Template

```json
{
  "name": "[Venture Name]",
  "description": "[One sentence description]",
  "created": "[DATE]",
  "updated": "[DATE]",
  "session_ids": ["[current-session]"],
  "goal": "",
  "folders": ["_brain", "_working", "_references"],
  "areas": [],
  "working_files": [],
  "key_files": [],
  "handoffs": []
}
```

---

## Notes

- Every venture must have revenue intent (even if future)
- Reference people from 02_Life/people/, don't duplicate
- When complete, archive to 01_Archive/04_Ventures/[name]/
