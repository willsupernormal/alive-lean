---
user-invocable: true
description: Bulk import existing content, transcripts, or documents into ALIVE structure. Use when the user says "migrate X", "import X", "bring in X", "bulk add", or "load from X".
plugin_version: "3.1.0"
---

# alive:migrate

Bulk import content into ALIVE. Extract and route existing files, transcripts, or documents.

## UI Treatment

Uses the **ALIVE Shell** — Tier 3: Utility.

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · migrate                        [source-type]     │
│  [N] items  ·  [N] categorised  ·  [N] remaining         │
│  ──────────────────────────────────────────────────────── │
│  [Progress + categorisation + routing]                    │
│  ──────────────────────────────────────────────────────── │
│  [ACTIONS]                                                │
│  [progress stats]                                         │
╰──────────────────────────────────────────────────────────╯
```

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## Version Check (Before Main Flow)

Compare your `plugin_version` (from frontmatter above) against the user's system:

1. Read `{alive-root}/.claude/alive.local.yaml` → get `system_version`
2. If `system_version` is missing or different from your `plugin_version`:
   ```
   [!] System update available (plugin: 3.1.0, system: X.X.X)
       └─ Run /alive:upgrade to sync before importing content
   ```
3. Continue with skill — this is non-blocking, just a notice

---

## When to Use

Invoke when the user:
- Has existing content to import into ALIVE
- Wants to bring in transcripts, notes, or documents
- Is migrating from another system
- Has a folder of files to process

## Flow

```
1. Identify source (file, folder, URL)
2. Create or select destination unit
3. Analyze content
4. Extract structured data
5. Route to appropriate locations
6. Update manifest
7. Confirm migration
```

## Step-by-Step

### Step 1: Identify Source

```
What are you migrating?

[1] A file (transcript, document, notes)
[2] A folder of files
[3] Paste content directly
```

### Step 2: Create or Select Destination

If unit doesn't exist:
```
This content needs a home.

[1] Create new venture, experiment, or life area
    └─ Venture (04_Ventures/), Experiment (05_Experiments/), or Life (02_Life/)
[2] Import to existing unit
```

If creating, invoke `/alive:new` first to scaffold properly.

### Step 3: Analyze Content

Read the source and identify:
- **Type:** Transcript, notes, documents, mixed
- **Contains:** People, decisions, tasks, insights, references
- **Structure:** How organized is it?

```
▸ analyzing source...

Source: call-transcript-2026-01-20.md
Type: Call transcript (~45 minutes)
Contains:
  - 3 people mentioned
  - 2 decisions discussed
  - 5 action items
  - Multiple topics
```

### Step 4: Extract Content

For transcripts, extract:

**People:**
```
Found 3 people:
- John Smith (client) — not in 02_Life/people/
- Sarah Chen (internal) — exists
- Mike Wilson (vendor) — not in 02_Life/people/

Create missing person files?
[1] Yes, create all
[2] Select which to create
[3] Skip person extraction
```

**Decisions:**
```
Found 2 decisions:
1. "Go with AWS over GCP for infrastructure"
2. "Launch date set for March 15"

Add to changelog?
[1] Yes
[2] Review first
```

**Tasks:**
```
Found 5 action items:
- [ ] Send proposal to John by Friday
- [ ] Schedule follow-up call
- [ ] Review AWS pricing
- [ ] Update timeline document
- [ ] Share access credentials

Add to tasks.md?
[1] Yes, add all
[2] Select which to add
```

**Insights (domain knowledge):**
```
Found insights:
- "Client prefers weekly updates over daily"
- "Budget is flexible if we can deliver faster"

Add to insights.md?
```

### Step 5: Route Content

```
▸ routing extracted content...

People:
  → 02_Life/people/john-smith.md (created)
  → 02_Life/people/mike-wilson.md (created)

Decisions:
  → 04_Ventures/acme/_brain/changelog.md (2 entries)

Tasks:
  → 04_Ventures/acme/_brain/tasks.md (5 items)

Insights (domain knowledge):
  → 04_Ventures/acme/_brain/insights.md (2 entries)

Source (reference):
  → 04_Ventures/acme/_references/call-john-smith-2026-01-20.md
```

**Reference routing:** When the source material is a reference type (email, call transcript, screenshot, article), route it to `_references/` with YAML front matter rather than a generic folder. See the capture-context skill for front matter format.

### Step 6: Update Manifest

Add imported files to the manifest. Reference materials go in the `references` array:

```json
{
  "references": [
    {
      "path": "_references/call-john-smith-2026-01-20.md",
      "type": "call",
      "description": "Call with John Smith about AWS migration, launch timeline",
      "date_created": "2026-01-20",
      "date_modified": "2026-01-20",
      "people": ["john-smith"],
      "session_ids": ["abc123"]
    }
  ]
}
```

Non-reference files go in the standard `files` or `areas` arrays as usual.

### Step 7: Confirm

```
✓ Migration complete

Imported:
- 2 person files created
- 2 decisions logged
- 5 tasks added
- 2 insights captured
- Source filed to meetings/

Manifest updated.
```

## Migration Types

### Transcript Migration

For call/meeting transcripts:
1. Identify speakers
2. Extract action items
3. Extract decisions
4. Extract insights (domain knowledge: strategy, product, process, market)
5. Update person files with "last contact"
6. Store source as reference in `_references/` with YAML front matter
7. Add to `manifest.json` `references` array

### Document Migration

For documents/PDFs:
1. Summarize content
2. Identify key information
3. Route to appropriate area
4. Add to manifest with summary

### Folder Migration

For folders of files:
1. Scan all files
2. Categorize by type
3. Process each file
4. Create area structure if needed
5. Bulk update manifest

### Notes Migration

For loose notes:
1. Parse structure
2. Extract actionable items
3. Route to state files
4. Archive or file source

## Using ICP Templates

When migrating to a new venture, offer templates:

```
Migrating to new venture: acme-corp

This looks like agency work (client, deliverables).

Use Agency template?
[1] Yes — creates clients/, templates/, operations/
[2] No — generic structure
```

## Edge Cases

**Large file:**
```
This transcript is 45,000 words.

Processing approach:
[1] Full extraction (may take time)
[2] Summary only
[3] Section by section
```

**Ambiguous content:**
```
This decision mentions multiple ventures:
- Pricing relates to acme
- Timeline relates to beta

Route to:
[1] Both units
[2] Just acme
[3] Just beta
[4] Let me specify
```

**Duplicate detection:**
```
[!] This looks similar to existing content:
    04_Ventures/acme/meetings/call-2026-01-15.md

[1] Import anyway (may duplicate)
[2] Skip (already imported)
[3] Show comparison
```

## After Migration

Once content is imported:
- Use `/alive:work` to work on the unit
- Use `/alive:digest` if items went to 03_Inputs/
- Use `/alive:sweep` to check for cleanup needs

## Related Skills

- `/alive:new` — Create unit first if needed
- `/alive:digest` — Process inputs
- `/alive:capture` — Single item capture (not bulk)
