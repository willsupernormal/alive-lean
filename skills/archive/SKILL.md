---
user-invocable: true
description: Move completed or inactive items to the archive. Use when the user says "archive X", "shelve X", "close X", "deactivate X", "done with X", "X is complete", or "finished with X".
plugin_version: "3.1.0"
---

# alive:archive

Move completed or inactive items to archive. Preserve full path structure.

## UI Treatment

Uses the **ALIVE Shell** — Tier 3: Utility.

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · archive                          [unit-name]    │
│  ──────────────────────────────────────────────────────── │
│  [Confirmation of what was archived + destination]        │
│  ──────────────────────────────────────────────────────── │
│  [✓ files moved + manifest updated]                       │
╰──────────────────────────────────────────────────────────╯
```

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## When to Use

Invoke when the user:
- Has completed a venture, experiment, life area, or project
- Wants to shelve something inactive
- Needs to clean up active areas
- Is closing out work

## Archive Principles

1. **Preserve paths** — Archive mirrors active structure
2. **Nothing is deleted** — Archive is permanent storage
3. **Searchable** — Archived content can still be found
4. **Reversible** — Can restore if needed

## Path Preservation

```
Active:   04_Ventures/acme/clients/globex/
Archived: 01_Archive/04_Ventures/acme/clients/globex/
```

The archive mirrors the working structure exactly.

## Flow

```
1. Identify what to archive
2. Confirm it's ready (no pending tasks)
3. Create archive path
4. Move content
5. Update manifests
6. Confirm archive
```

## Step-by-Step

### Step 1: Identify Target

```
What are you archiving?

[1] A venture (04_Ventures/acme)
[2] An area (04_Ventures/acme/clients/globex)
[3] A file (specific document)
```

### Step 2: Check Readiness

Before archiving, verify:

```
▸ checking 04_Ventures/acme/clients/globex/

Status: No _brain/ (this is an area)
Files: 5 documents
Related tasks: 2 found in parent unit

─────────────────────────────────────────────────────────────────────────
[!] Found 2 related tasks in 04_Ventures/acme/_brain/tasks.md:
    - [ ] Send final invoice to Globex
    - [ ] Archive Globex files

Complete these first?
[1] Yes, show me the tasks
[2] No, archive anyway
[3] Cancel
```

### Step 3: Archive

```
▸ archiving 04_Ventures/acme/clients/globex/

Creating: 01_Archive/04_Ventures/acme/clients/globex/
Moving: 5 files

[1] Confirm archive
[2] Cancel
```

### Step 4: Execute

```
▸ moving to archive...

01_Archive/04_Ventures/acme/clients/globex/
├── contract.pdf
├── deliverables/
│   ├── report-v1.pdf
│   ├── report-v2.pdf
│   └── presentation.pptx
└── README.md
```

### Step 5: Update Manifests

**Parent manifest (04_Ventures/acme/_brain/manifest.json):**
- Remove archived area from `areas[]`
- Update `folders[]` if needed

**Archive note:**
Add to archived content:
```markdown
<!-- Archived: 2026-01-23 from 04_Ventures/acme/clients/globex/ -->
```

### Step 6: Confirm

```
✓ Archived to 01_Archive/04_Ventures/acme/clients/globex/

5 files moved.
Parent manifest updated.

This content is preserved and searchable via /alive:recall.
```

## Archiving Units

When archiving a full unit (with _brain/):

```
▸ archiving 04_Ventures/old-project/

This is a full unit with state.

Current status: Completed
Last updated: 2026-01-15 (8 days ago)
Open tasks: 0

Archive everything including _brain/?
[1] Yes, archive full unit
[2] No, just archive specific areas
[3] Cancel
```

Result:
```
01_Archive/04_Ventures/old-project/
├── .claude/
│   └── CLAUDE.md
├── _brain/
│   ├── status.md
│   ├── tasks.md
│   ├── insights.md
│   ├── changelog.md
│   └── manifest.json
├── _working/
├── _references/
└── [all areas and files]
```

## Archiving Experiments

Experiments that didn't work out:

```
▸ archiving 05_Experiments/failed-idea/

Experiment status: Abandoned
Reason: Market validation failed

Archive with learnings?
[1] Yes, preserve everything
[2] Extract insights first, then archive
[3] Just delete (not recommended)
```

If extracting insights (domain knowledge):
```
Found in 05_Experiments/failed-idea/_brain/insights.md:
- "Target market too small for subscription model" [market]
- "Customer acquisition cost exceeded LTV" [strategy]

Copy these to another project before archiving?
[1] Yes, copy to 04_Ventures/main/_brain/insights.md
[2] No, keep only in archive
```

## Restoring from Archive

If something needs to come back:

```
User: "Restore the Globex project"

▸ checking 01_Archive/04_Ventures/acme/clients/globex/

Found archived content from 2026-01-23.

Restore to original location?
[1] Yes, restore to 04_Ventures/acme/clients/globex/
[2] Restore to different location
[3] Just view archived content
```

## Archive vs Delete

**Never delete.** Archive instead.

| Action | When to use |
|--------|-------------|
| Archive | Venture complete, client done, experiment concluded |
| Delete | Never (use archive) |

Exception: Temporary files in `_working/` can be deleted after promotion.

## Edge Cases

**Already archived:**
```
✗ 04_Ventures/acme/clients/globex/ not found

Check archive?
[1] Yes, search archive
[2] No
```

**Nested archive:**
```
[!] 04_Ventures/acme/ contains 3 areas that are already archived.

Archive parent anyway?
[1] Yes (will nest archives)
[2] No, archive only active content
```

**Partial archive:**
```
Archive specific items from 04_Ventures/acme/clients/?

[1] globex/ (completed)
[2] initech/ (completed)
[ ] techcorp (still active)

Select which to archive:
```

## Finding Archived Content

Use `/alive:recall` to search archives:

```
User: "Find the Globex contract"

▸ searching all locations including archive...

Found: 01_Archive/04_Ventures/acme/clients/globex/contract.pdf
Archived: 2026-01-23

[1] View content
[2] Restore from archive
```

## Related Skills

- `/alive:recall` — Find archived content
- `/alive:sweep` — Identify archive candidates
- `/alive:new` — Create new venture, experiment, life area, or project (opposite of archive)

