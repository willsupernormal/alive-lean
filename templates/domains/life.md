# Life Domain Template

**Domain:** 02_Life/
**Purpose:** Personal responsibilities — life first, always

---

## Structure

```
02_Life/
├── people/           # Source of truth for all people
│   └── [name].md     # Person files
└── [area]/            # Life areas (health, finance, etc.)
    ├── .claude/
    │   └── CLAUDE.md
    ├── _brain/
    │   ├── status.md
    │   ├── tasks.md
    │   ├── insights.md
    │   ├── changelog.md
    │   └── manifest.json
    ├── _working/
    └── _references/
```

---

## people/ Directory

The `people/` folder is the source of truth for all people across ALIVE. Other domains reference people here, they don't duplicate them.

### Person File Template

```markdown
# [Name]

**Role:** [What they do]
**Company:** [Where they work]
**Relationship:** [How you know them]
**Last Contact:** [Date]

---

## Context

[How you met, key background]

---

## Notes

- [Relevant notes about this person]

---

## Links

- 04_Ventures/[venture]/clients/[company] — Client relationship
- 04_Ventures/[venture]/partners/[company] — Partnership
```

---

## Life Area Template

Life areas (health, finance, relationships, etc.) are full units — they have `_brain/`, `_working/`, and `_references/` just like ventures and experiments.

### CLAUDE.md

```markdown
# [Area Name]

**Type:** Life Area
**Created:** [DATE]

---

## What This Is

[One paragraph: What is this area about?]

---

## Key Practices

- [Regular activities]
- [Habits]
- [Routines]

---

## State

Everything current lives in `_brain/`:
- `status.md` — Current focus
- `tasks.md` — What needs doing
- `insights.md` — Domain knowledge
- `changelog.md` — History
```

### status.md

```markdown
# Status

**Goal:** [What does thriving look like in this area?]
**Phase:** [Starting | Building | Maintaining]
**Updated:** [DATE]

---

## Key People

## State of Play

## Priorities

## Blockers

## Next Milestone
```

---

## Common Life Areas

| Area | Purpose |
|--------|---------|
| health/ | Physical and mental health |
| finance/ | Money, investments, budgets |
| relationships/ | Family, friends, community |
| growth/ | Learning, skills, development |
| home/ | Living space, maintenance |

These are full units — each gets `_brain/`, `_working/`, and `_references/`.

---

## Notes

- Life areas are optional — create only what you need
- people/ is always present (source of truth for all people)
- Life first, always — this domain takes priority
