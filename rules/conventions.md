# Conventions

File naming, _brain files, and YAML front matter.

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
1. Create `_brain/` with status.md, tasks.md, insights.md, changelog.md
2. Create `_working/` for drafts (at project level, not parent)
3. Create `_references/` for reference material (at project level, not parent)
4. Log creation in parent's `_brain/changelog.md`

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

Full templates: `templates/brain/`

### insights.md Gate

An insight belongs in insights.md **only if** all three conditions are met:

1. **Domain knowledge that influences future decisions** — not a one-off fact, status update, or production spec
2. **Not already captured in CLAUDE.md** or another always-loaded file — if it's identity, rules, or terminology, it belongs there
3. **Not a one-off fact or status update** — "Express shipping = 3 days" is a fact for a tech pack or status.md, not an insight

**Format rules:**
- **Evidence** = session ID only (e.g. `abc12345`). Full context is recoverable from `_references/` transcripts or `_brain/changelog.md`.
- **No Action: field** — actions belong in tasks.md
- **Learning** = one paragraph max. No filler.

---

## Unit-Level README

Every unit (venture, experiment, life area, project) has a `README.md` at its root providing a structural overview — a curated map of what exists.

### Format

```markdown
# [Unit Name]

## Structure
- `folder-name/` — What this folder contains (N items)
- `_working/` — Drafts in progress (N files)
- `_references/` — Captured external content (N files)

## Key Files
- `path/to/important.md` — One-line description
```

### Rules
- Curated guide, NOT exhaustive inventory — only notable folders and files
- Updated by the save skill on structural changes (new folders, promoted files)
- Do not list _brain/ internals (those are state files accessed separately)

---

## YAML Front Matter

`_working/` and `_references/` files carry metadata via YAML front matter. The save skill enforces this on modified files.

**`_brain/` files do NOT get front matter.** They are internal state files with dates already embedded in content (`**Updated:**` lines, `## YYYY-MM-DD` entries). Adding front matter would be redundant.

### _working/ files

```yaml
---
description: What this draft is
created: 2026-02-24
modified: 2026-02-24
session_ids: [abc12345]
---
```

### _references/ summary files

```yaml
---
type: email
date: 2026-02-24
description: One-line summary
source: Who/where from
tags: [tag1, tag2]
---
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
