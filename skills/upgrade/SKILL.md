---
user-invocable: true
description: Update ALIVE system files to the latest plugin version — rules, CLAUDE.md, and configuration. Use when the user says "upgrade", "update system", or when a version mismatch is detected.
plugin_version: "3.1.0"
---

# alive:upgrade

Upgrade the user's ALIVE system to match the current plugin version. Detects what's out of date, applies changes with subagents, verifies with sweep.

## UI Treatment

Uses the **ALIVE Shell** — Tier 3: Utility.

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · upgrade                                          │
│  [current] → [target]                                     │
│  ──────────────────────────────────────────────────────── │
│  [Changes applied]                                        │
│  ──────────────────────────────────────────────────────── │
│  [✓ upgrade complete]                                     │
╰──────────────────────────────────────────────────────────╯
```

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## How Version Tracking Works

**Two version numbers:**

| Version | Location | Updated by |
|---------|----------|------------|
| `plugin_version` | Frontmatter of every skill file | Plugin auto-update |
| `system_version` | `{alive-root}/.claude/alive.local.yaml` | This upgrade skill (after success) |

When `plugin_version > system_version` → system needs upgrading.
When they match → system is current.

---

## Flow

```
1. Detect versions (plugin vs system)
2. If match → "You're up to date"
3. If mismatch → check Migration Registry for required migrations
4. If NO structural migrations → fast path (bump system_version only)
5. If structural migrations → show plan, get user approval
6. Session 1: Sync rules + CLAUDE.md → EXIT (Claude must reload)
7. Session 2: Structural changes via subagents
8. Run /alive:sweep to verify
9. Update system_version in alive.local.yaml
```

---

## Step 1: Version Detection

```
▸ checking versions...

Plugin version: 3.1.0 (from skill frontmatter)
System version: [read from alive.local.yaml]
```

**Read `{alive-root}/.claude/alive.local.yaml`** and extract `system_version`.

| Scenario | Action |
|----------|--------|
| `system_version` missing | Treat as `"unknown"` — run all migrations |
| `system_version` < `plugin_version` | Run migrations for each version gap |
| `system_version` == `plugin_version` | "You're up to date" → exit |

```
▸ versions detected
  └─ Plugin: 3.1.0 | System: unknown
  └─ Migrations needed: pre-2.1.1 → 3.1.0
```

---

## Step 1.5: Check Migration Registry (Standard vs Structural)

After detecting a version mismatch, check the Migration Registry (at the bottom of this skill) for entries covering the version gap.

**Every release updates version references in rules and CLAUDE.md.** So every upgrade needs at minimum a standard sync (rules + CLAUDE.md + config). Structural releases additionally need user file migrations (manifests, folders, etc.).

**Implementation:**
1. Read the Migration Registry section of this skill
2. Look for an entry covering the user's current `system_version` → `plugin_version` gap
3. Check which categories the entry includes:
   - **Only** Skills, Rules, CLAUDE.md, Config → **standard path** (no restart needed)
   - **Additional** categories (Manifests, Folders, References, Terminology, Status, Insights) → **structural path** (proceed to Step 2)
4. If no entry exists at all and `system_version` is `"unknown"` → proceed to Step 2 (full migration for fresh/unknown systems)

### Standard Path (Rules + CLAUDE.md + Config)

For releases where the only changes are skills (auto-delivered) plus version references in rules and CLAUDE.md. No restart needed — these are cosmetic version string updates, not behavioural changes.

**Standard path actions:**

1. **Sync rules from plugin cache to user's rules directory:**
   - Plugin rules: `~/.claude/plugins/cache/aliveskills/alive/{plugin_version}/rules/`
   - User rules: `{alive-root}/.claude/rules/`
   - For each rule file in plugin: overwrite user's copy (these are system files, not user content)

2. **Sync CLAUDE.md version reference:**
   - Read `{alive-root}/.claude/CLAUDE.md`
   - Find the `**Version:**` line and update to match `plugin_version`
   - Use Edit tool — do NOT overwrite the file (user may have custom content)

3. **Update config:**
   - Set `system_version` in `{alive-root}/.claude/alive.local.yaml` to match `plugin_version`

4. **Show summary:**
```
▸ standard upgrade: {old} → {new}
  └─ Rules synced (version references updated)
  └─ CLAUDE.md version updated
  └─ system_version set to {new}

✓ Upgrade complete. No restart needed.
```

**STOP here if standard path was taken. Do not proceed to Step 2.**

### Structural Path

If the migration registry entry has categories beyond Skills/Rules/CLAUDE.md/Config, proceed to Step 2 for the full migration plan.

---

## Step 2: Show Migration Plan

List all changes that will be applied. **Get user approval before proceeding.**

```
UPGRADE PLAN: [current] → [target]
════════════════════════════════════════════════════════════════════════════

This upgrade requires TWO sessions (Claude must restart to load new rules).

SESSION 1 (now):
  [A] Rules sync — update .claude/rules/ to match plugin
  [B] CLAUDE.md assimilation — merge new sections into your .claude/CLAUDE.md
  → Then EXIT and restart Claude

SESSION 2 (after restart):
  [C] Folder structure — add _references/, fix old folder names
  [D] Manifest schema — update all manifest.json files
  [E] References audit — restructure loose context into _references/ format
  [F] Terminology migration — scan _brain/ files for outdated terms
  [G] Config — set system_version in alive.local.yaml
  → Then /alive:sweep to verify

════════════════════════════════════════════════════════════════════════════

Proceed?
[1] Yes — start Session 1
[2] I already did Session 1 — skip to Session 2
[3] Cancel
```

---

## Why 2 Sessions?

Claude operates with its loaded rules. If you sync rules mid-session, Claude still has the old knowledge loaded. Only a fresh session loads the new rules. Session 1 updates the files, Session 2 uses the updated knowledge.

---

## Session 1: Knowledge Sync

### Step A: Rules Sync (Subagent)

**Launch a Task subagent with this prompt:**

```
You are upgrading ALIVE rules files. Compare the plugin's rules against the user's installed rules and sync them.

PLUGIN RULES: ~/.claude/plugins/cache/aliveos/aliveos/3.1.0/rules/
USER RULES: {alive-root}/.claude/rules/

For EACH rule file in the plugin directory:

1. If the file doesn't exist in the user's directory → COPY it from plugin
2. If the file exists but differs → READ both versions, then OVERWRITE the user's file with the plugin version

The rules files are system files owned by the plugin. They should match the plugin exactly. User customizations to rules are not expected — these are behavioral instructions, not user content.

After processing all files, report:
- Which files were copied (new)
- Which files were updated (changed)
- Which files were already current (skipped)
- Total files processed

Expected rule files: behaviors.md, conventions.md, intent.md, learning-loop.md, ui-standards.md, voice.md, working-folder-evolution.md
```

**Show results:**
```
▸ syncing rules...
  └─ behaviors.md — updated ✓
  └─ conventions.md — updated ✓
  └─ intent.md — current, skipped
  └─ learning-loop.md — updated ✓
  └─ ui-standards.md — current, skipped
  └─ voice.md — current, skipped
  └─ working-folder-evolution.md — current, skipped

✓ Rules synced (3 updated, 4 current)
```

### Step B: CLAUDE.md Assimilation (Subagent)

**CRITICAL: Do NOT overwrite the user's CLAUDE.md. Merge changes in.**

**Launch a Task subagent with this prompt:**

```
You are assimilating changes from the plugin's CLAUDE.md into the user's installed CLAUDE.md. The user may have added custom content to their CLAUDE.md — you MUST preserve it.

PLUGIN CLAUDE.MD: ~/.claude/plugins/cache/aliveos/aliveos/3.1.0/CLAUDE.md
USER CLAUDE.MD: {alive-root}/.claude/CLAUDE.md

Instructions:
1. Read BOTH files completely
2. Identify sections/content in the PLUGIN version that are MISSING from the USER version
3. Identify sections in the USER version that have OUTDATED content compared to the PLUGIN version
4. For each difference, apply this logic:

   MISSING SECTION in user file:
   → Add the section from plugin at the appropriate location (match the plugin's ordering)

   OUTDATED SECTION (same heading, different content):
   → Replace the section content with the plugin version
   → BUT: If the user has added custom lines BELOW a section (like personal notes, extra context), preserve those custom additions

   SECTION EXISTS ONLY IN USER FILE (not in plugin):
   → KEEP IT. This is user customization. Do not remove.

5. After making changes, report:
   - Sections added (new from plugin)
   - Sections updated (content refreshed)
   - User sections preserved (not in plugin, kept)
   - No changes needed (already current)

IMPORTANT: Use the Edit tool for each change, not Write. Make surgical edits.
```

**Show results:**
```
▸ assimilating CLAUDE.md changes...
  └─ Added: _references/ to Structure section
  └─ Updated: Session Protocol (delegates to /alive:save)
  └─ Preserved: [any user-custom sections]

✓ CLAUDE.md assimilated (1 added, 1 updated, 0 user sections preserved)
```

### Session 1 Exit

```
╭─ RESTART REQUIRED ─────────────────────────────────────────────────────╮
│                                                                        │
│  Rules and CLAUDE.md have been updated.                                │
│                                                                        │
│  Claude must RESTART to load the new knowledge.                        │
│                                                                        │
│  1. Exit this session (Ctrl+C or close terminal)                       │
│  2. Start a new Claude Code session                                    │
│  3. Run /alive:upgrade again                                           │
│                                                                        │
│  Next run will detect Session 1 is done and proceed to                 │
│  structural migration.                                                 │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯
```

**STOP. Do not proceed to Session 2 steps.**

---

## Session 2: Structural Migration

**Only run if user selected [2] in Step 2, or if rules check confirms they are current.**

### Step C: Folder Structure (Subagent)

**Launch a Task subagent with this prompt:**

```
You are upgrading the ALIVE folder structure. Scan the user's ALIVE directory and fix any structural issues.

ALIVE ROOT: {alive-root}

TASK 1 — Find all units:
Units are folders that contain a _brain/ subdirectory (ventures, experiments, life areas, and nested projects). Search:
- {alive-root}/04_Ventures/*/          (depth 1)
- {alive-root}/04_Ventures/*/*/        (depth 2, nested projects)
- {alive-root}/05_Experiments/*/       (depth 1)
- {alive-root}/05_Experiments/*/*/     (depth 2)
- {alive-root}/02_Life/*/              (depth 1, if any are life areas)

List every unit found.

TASK 2 — For each unit, check:
a) Does _references/ folder exist? If not → create it
b) Does _state/ exist instead of _brain/? If so → rename _state/ to _brain/

TASK 3 — Check root-level folders:
a) Does inbox/ exist? If so → rename to 03_Inputs/
b) Does archive/ exist without 01_ prefix? → rename to 01_Archive/
c) Does life/ exist without 02_ prefix? → rename to 02_Life/
d) Does ventures/ exist without 04_ prefix? → rename to 04_Ventures/
e) Does experiments/ exist without 05_ prefix? → rename to 05_Experiments/

TASK 4 — Check system directories:
a) Does {alive-root}/.claude/state/ exist? If not → create it
b) Does {alive-root}/.claude/state/session-index.jsonl exist? If not → create empty file

IMPORTANT:
- Do NOT touch anything in 01_Archive/
- Do NOT rename folders inside templates/
- ASK before renaming if unsure
- Report every action taken

Report format:
- Units found: [count]
- _references/ created: [list]
- Folders renamed: [list]
- System files created: [list]
- Already current: [list]
- Skipped: [list with reason]
```

**Show results:**
```
▸ checking folder structure...
  └─ 5 units found
  └─ _references/ created in: 04_Ventures/acme, 05_Experiments/beta
  └─ No old folder names detected
  └─ System directories present

✓ Folder structure current (2 folders created)
```

### Step D: Manifest Schema (Subagent)

**Launch a Task subagent with this prompt:**

```
You are upgrading ALIVE manifest.json files to the v2 schema. Check every unit's manifest and update if needed.

ALIVE ROOT: {alive-root}

TASK 1 — Find all manifest files:
Search for _brain/manifest.json in all units (same unit paths as folder structure task).

TASK 2 — For each manifest.json, read it and check against the TARGET SCHEMA below. Fix any deviations.

TARGET SCHEMA (v2):

{
  "name": "unit-name",
  "description": "One sentence description",
  "goal": "Single-sentence goal that filters all decisions",
  "created": "2026-01-20",
  "updated": "2026-01-23",
  "session_ids": ["abc12345", "def67890"],

  "folders": ["_brain", "_working", "_references", "...other folders"],

  "areas": [
    {
      "path": "clients/",
      "description": "Active client projects",
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
      "description": "Unit identity and navigation",
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

MIGRATION CHECKS — compare each manifest against the target schema:

a) ROOT FIELDS:
   - "goal" missing → add "goal": "" (empty, user will fill in)
   - "session_id" (string) exists → convert to "session_ids" (array): ["old-value"]
   - "session_ids" missing entirely → add "session_ids": []

b) FOLDERS ARRAY:
   - "_references" not in "folders" → add it

c) REQUIRED TOP-LEVEL ARRAYS:
   - "references" missing → add "references": []
   - "key_files" missing → add "key_files": [{"path": "CLAUDE.md", "description": "Unit identity"}]
   - "handoffs" missing → add "handoffs": []

d) DEPRECATED FIELDS — remove if found:
   - "type" (top-level)
   - "sessions" (top-level array)
   - Top-level "files" array with old "summary"/"modified"/"key" fields

e) FILE ENTRY FORMAT — check ALL entries in areas[].files[], working_files[], key_files[], references[]:
   - "summary" field → rename to "description"
   - "session_id" (string) → convert to "session_ids" (array)
   - "date_created" missing → add with today's date
   - "date_modified" missing → add with today's date

f) REFERENCES ENTRIES — each must have "type" field (email, call, screenshot, etc.)

g) Update "updated" field to today's date and append current session ID to "session_ids".

IMPORTANT:
- Use Edit tool, not Write — preserve existing data
- Do NOT remove areas, working_files, or other valid content
- Only add missing fields and remove deprecated ones
- Report every change made per manifest

Report format per unit:
- Unit: [path]
- Fields added: [list]
- Fields removed: [list]
- Fields renamed: [list]
- Already current: true/false
```

**Show results:**
```
▸ updating manifest schemas...
  └─ 04_Ventures/acme — added goal, references[], converted session_id → session_ids
  └─ 04_Ventures/beta — already current
  └─ 05_Experiments/test — added handoffs[], key_files[], date fields on 3 entries

✓ Manifests updated (2 changed, 1 current)
```

### Step E: References Content Audit (Subagent)

**This step audits each unit's `_references/` folder and restructures any loose or non-conforming context files into the correct format.**

Step C creates the `_references/` folder. This step ensures what's INSIDE it is correct — and finds context files elsewhere in the unit that should be moved into `_references/`.

**Launch a Task subagent with this prompt:**

```
You are auditing and restructuring _references/ content across all ALIVE units. Your job is to ensure every unit's reference material follows the correct structure.

ALIVE ROOT: {alive-root}

WHAT _references/ SHOULD LOOK LIKE:

_references/
├── meeting-transcripts/
│   ├── 2026-02-08-content-planning.md        ← YAML front matter + AI summary
│   └── raw/
│       └── 2026-02-08-content-planning.txt   ← Original source file
├── emails/
│   ├── 2026-02-06-supplier-quote.md
│   └── raw/
│       └── 2026-02-06-supplier-quote.txt
├── screenshots/
│   ├── 2026-02-06-competitor-landing.md
│   └── raw/
│       └── 2026-02-06-competitor-landing.png
└── documents/
    ├── 2026-02-06-contract-scan.md
    └── raw/
        └── 2026-02-06-contract-scan.pdf

REQUIRED YAML FRONT MATTER on every summary .md file:

---
type: email | call | screenshot | document | article | message
date: 2026-02-06
description: One-line description of what this reference contains
source: Where it came from (person name, tool, etc.)
tags: [keyword, keyword, keyword]
# Additional fields by type:
# emails: from, to, subject
# calls/meetings: participants, duration
# messages: platform
---

FIND ALL UNITS:
Search for _brain/ folders in:
- {alive-root}/04_Ventures/*/
- {alive-root}/04_Ventures/*/*/
- {alive-root}/05_Experiments/*/
- {alive-root}/05_Experiments/*/*/
- {alive-root}/02_Life/*/

FOR EACH UNIT, run these 6 audits:

AUDIT 1 — Find loose context files that should be in _references/:
Search the entire unit (excluding _brain/, _working/, .claude/, 01_Archive/) for files that look like reference material:
- Transcript files (.txt files with meeting/call content)
- Email exports
- Screenshot images with no summary .md
- PDFs, documents that are source material (not working drafts)
- Files in folders named "context/", "notes/", "research/", "docs/" that are external source material
- Any file that is clearly captured external content, not something the user created

For each found: report the file path and what type of reference it appears to be.
Do NOT move anything — just report. The user will approve moves.

AUDIT 2 — Check _references/ subfolder structure:
For each subfolder in _references/:
a) Does a raw/ subfolder exist? If not → flag as needing one
b) Are there files directly in _references/ root that should be in a type subfolder? → flag

AUDIT 3 — Validate YAML front matter on all summary .md files in _references/:
For each .md file (NOT in raw/ subfolders):
a) Does it have YAML front matter (--- delimiters)? If not → flag as MISSING FRONT MATTER
b) Does front matter have ALL required fields?
   Required always: type, date, description, source, tags
   Required for emails: from, to, subject
   Required for calls/meetings: participants, duration (if known)
c) Does "description" use the correct field name? (not "summary") → flag if wrong
d) Is the front matter well-formed YAML? → flag if malformed

For each issue: report the file, what's missing/wrong, and suggest the fix.

AUDIT 4 — Check raw/ file pairing:
For each summary .md in _references/:
a) Does a corresponding raw file exist in the raw/ subfolder? → flag if missing
b) Does the summary .md have a ## Source section pointing to the raw file? → flag if missing
c) Do the summary .md and raw file share the same base name? → flag if mismatched

For each found raw file:
a) Does a corresponding summary .md exist? → flag orphaned raw files that have no summary

AUDIT 5 — Check file naming convention:
For all files in _references/ (both summary and raw):
a) Does the filename follow YYYY-MM-DD-descriptive-name pattern? → flag if not
b) Are there garbage filenames (CleanShot, IMG_xxxx, document (3), etc.)? → flag with suggested rename

AUDIT 6 — Check manifest references[] entries:
Read _brain/manifest.json and compare against actual _references/ contents:
a) Files in _references/ that have NO manifest entry → flag as untracked
b) Manifest entries that point to files that DON'T EXIST → flag as stale
c) Manifest entries missing required fields (type, description, date_created, date_modified, session_ids) → flag

AFTER ALL AUDITS, produce a structured report:

UNIT: [path]
  Loose context files found: [count]
    - [path] → suggest move to _references/[type]/
  Missing raw/ subfolders: [count]
    - [subfolder]
  Front matter issues: [count]
    - [file]: missing [fields]
  Orphaned raw files: [count]
    - [file]: no summary .md
  Naming issues: [count]
    - [file] → suggested rename: [new name]
  Manifest sync issues: [count]
    - [file]: untracked / stale / missing fields

THEN: For each issue category, ask the user:
  "Fix [category] issues? [y/n]"

When fixing:
- Create missing raw/ subfolders
- Add missing YAML front matter fields to existing .md files (use Edit, not Write)
- Rename garbage filenames
- Add ## Source sections pointing to raw files
- Add missing manifest references[] entries
- Remove stale manifest entries
- Do NOT move loose context files without explicit user approval per file

IMPORTANT:
- Use Edit tool for all file modifications — never Write (which overwrites)
- Do NOT touch files in 01_Archive/
- Do NOT modify raw/ file contents — only rename if naming convention is wrong
- Report everything before fixing — user approves each category
- If a unit's _references/ is empty, just report "No references yet" and move on
```

**Show results:**
```
▸ auditing _references/ content...
  └─ 04_Ventures/acme — 3 front matter issues, 1 orphaned raw file
  └─ 04_Ventures/beta — clean ✓
  └─ 05_Experiments/test — 2 loose context files found, 1 naming issue

Fix front matter issues in acme? [y/n]
Fix loose files in test? [y/n]
```

### Step F: Terminology Migration (Subagent)

**Scan all user-created _brain/ files and CLAUDE.md files for outdated terminology and update them.**

This step only applies when the Migration Registry entry includes terminology changes (e.g. 2.1.1 → 3.0.1: "entity" → context-specific term). Skip this step if the registry entry has no terminology changes.

**Launch a Task subagent with this prompt:**

```
You are migrating outdated terminology across all ALIVE user content files. The plugin's rules and skills have already been updated — this step updates the USER'S own files (manifests, _brain/ files, CLAUDE.md files inside units).

ALIVE ROOT: {alive-root}

CURRENT TERMINOLOGY (target state):
  - Top-level under 04_Ventures/ = "venture"
  - Top-level under 05_Experiments/ = "experiment"
  - Top-level under 02_Life/ = "life area"
  - Nested with _brain/ = "project"
  - Organizational folder = "area"
  - Generic for "anything with _brain/" in user-facing text = "venture, experiment, or life area"
  - Generic for "anything with _brain/" in dev/internal text = "unit"

TERMINOLOGY CHANGES (from Migration Registry):
  "entity" → context-specific: "venture", "experiment", "life area", "project", or "unit"
  "entities" → context-specific: "ventures", "experiments", "life areas", "projects", or "units"
  "sub-entity" → "project"
  "sub-entities" → "projects"
  "subdomain" → context-specific term
  "has_entities" → "has_projects" (in manifest.json files)

IMPORTANT EXCEPTIONS — do NOT rename:
  - Filenames or folder names — only rename content inside files
  - Anything in 01_Archive/ — leave archived content as-is

FILES TO SCAN:
1. All _brain/manifest.json files — look for "has_entities" field, rename to "has_projects"
2. All _brain/status.md, tasks.md, insights.md, changelog.md — look for terminology in prose
3. All .claude/CLAUDE.md files inside units (NOT the root .claude/CLAUDE.md, which is handled by Step B)
4. All README.md files inside units

FOR EACH FILE:
- Read the file
- Check for any of the terminology terms above
- If found, use Edit tool to replace (use replace_all: true for each term)
- Choose the correct replacement based on context (venture/experiment/life area/project/unit)
- Report what was changed

Report format:
- Files scanned: [count]
- Files with changes: [list with what was replaced]
- Files already current: [count]
- Skipped (archive): [count]
```

**Show results:**
```
▸ migrating terminology...
  └─ Scanned 23 files across 5 units
  └─ 04_Ventures/acme/_brain/manifest.json — "has_entities" → "has_projects"
  └─ 04_Ventures/acme/.claude/CLAUDE.md — 3 replacements
  └─ 05_Experiments/beta/_brain/changelog.md — 1 replacement
  └─ 18 files already current

✓ Terminology migrated (3 files updated)
```

---

### Step G: Config Update

**Update `{alive-root}/.claude/alive.local.yaml`:**

Read the current file. Add or update `system_version` field:

```yaml
theme: vibrant
onboarding_complete: true
system_version: "3.1.0"
```

Use Edit if the file exists (preserve other fields). Use Write only if the file doesn't exist.

```
▸ updating config...
  └─ alive.local.yaml — set system_version: "3.1.0"

✓ Config updated
```

---

## Step 3: Post-Upgrade Sweep

**Invoke `/alive:sweep` using the Skill tool** to verify everything is aligned.

```
▸ running post-upgrade sweep...
```

The sweep will catch any issues the subagents missed. If sweep finds problems, fix them before marking upgrade complete.

---

## Step 4: Final Verification

```
╭──────────────────────────────────────────────────────────────────────────╮
│                                                                        │
│    ▄▀█ █░░ █ █░█ █▀▀                                                   │
│    █▀█ █▄▄ █ ▀▄▀ ██▄            upgrade complete                      │
│                                                                        │
│  ──────────────────────────────────────────────────────────────────    │
│                                                                        │
│  UPGRADE SUMMARY                                                       │
│  ──────────────────────────────────────────────────────────────────    │
│  Plugin: 3.1.0 → System: 3.1.0 ✓                                      │
│                                                                        │
│  [A] Rules: X updated, Y current                                       │
│  [B] CLAUDE.md: X sections added, Y updated                            │
│  [C] Folders: X _references/ created, Y renames                        │
│  [D] Manifests: X updated, Y current                                   │
│  [E] References: X issues fixed, Y projects clean                      │
│  [F] Terminology: X files updated, Y current                           │
│  [G] Config: system_version set to 3.1.0                               │
│  [H] Sweep: ✓ passed                                                   │
│                                                                        │
│  ──────────────────────────────────────────────────────────────────    │
│                                                            ALIVE v3.1.0│
╰──────────────────────────────────────────────────────────────────────────╯
```

---

## Edge Cases

**Already up to date:**
```
✓ System is current (3.1.0)
  └─ No upgrade needed.
```

**No alive.local.yaml:**
```
[!] No alive.local.yaml found at {alive-root}/.claude/

This file tracks your system version. Creating it now.
```
Create the file with `system_version: "3.1.0"` and `onboarding_complete: true`.

**Single unit upgrade (from /alive:work):**
```
This skill upgrades the ENTIRE system, not individual units.
Proceeding with full system upgrade.
```

**Partial upgrade (Session 1 done, Session 2 pending):**
Detect by checking: rules are current but `system_version` < `plugin_version`.
Skip directly to Session 2 steps.

---

## Migration Registry

### pre-2.1.1 → 2.1.1

| Category | Changes |
|----------|---------|
| **Folders** | Add `_references/` to all projects. Rename `inbox/`→`03_Inputs/`, `archive/`→`01_Archive/`, `life/`→`02_Life/`, `ventures/`→`04_Ventures/`, `experiments/`→`05_Experiments/`, `_state/`→`_brain/`. |
| **Rules** | Sync all 7 rule files. Key changes: `_references/` system in conventions.md and behaviors.md, folder renames in all files, visual identity system in ui-standards.md. |
| **CLAUDE.md** | Add `_references/` to structure, update session protocol to delegate to `/alive:save`, remove duplicated sections (Capture Triggers, Context Freshness, etc.), condense Life First. |
| **Manifests** | Add `references[]`, `key_files[]`, `handoffs[]`, `goal`. Add `_references` to folders. Convert `session_id` (string) → `session_ids` (array). Add `date_created`, `date_modified`, `session_ids` to file entries. Rename `summary` → `description`. Remove deprecated `type`, old `files[]` format. |
| **References** | Audit all `_references/` content: validate YAML front matter, ensure `raw/` subfolders exist, check summary/raw file pairing, fix garbage filenames, sync manifest `references[]` entries, find loose context files that should be in `_references/`. |
| **Config** | Add `system_version: "2.1.1"` to alive.local.yaml. |
| **Statusline** | Update statusline-command.sh if configured (numbered folder detection, ALIVE root indicator). |

### 2.1.0 → 2.1.1

| Category | Changes |
|----------|---------|
| **Skills** | Onboarding rewritten as two-session flow (system setup → restart → content setup). Upgrade skill gains standard path for version syncing. All 16 skills bumped to 2.1.1. |
| **Onboarding** | `alive.local.yaml` now comprehensive: includes `alive_root`, `timezone`, `theme`, `working_style`, `onboarding_part` tracking. Two-session flow with forced restart between system and content setup. Added AI conversation history import prompt (Step 20). |
| **Versioning** | `alive.local.yaml` now always includes `system_version` from initial onboarding. Migration Registry categorises releases as standard (rules+CLAUDE.md+config) or structural (additional user file changes). |
| **Rules** | Sync rules from plugin (version references updated). |
| **CLAUDE.md** | Sync CLAUDE.md from plugin (version reference updated). |
| **Config** | Update `system_version: "2.1.1"` in alive.local.yaml. |

### 2.1.1 → 3.0.1

| Category | Changes |
|----------|---------|
| **Product** | Rebranded to aliveOS Unlimited Elephant. Version jump from 2.1.1 to 3.0.1. |
| **Terminology** | "entity" → context-specific (venture/experiment/life area/project/unit), "sub-entity" → "project", "has_entities" → "has_projects" across all rules, templates, skills, and CLAUDE.md. Dead terms: entity, sub-entity, sub-project, subdomain. |
| **Skills** | `do` renamed to `work`. `capture-context` renamed to `capture`. `power-user-install` renamed to `scan`. Skill descriptions rewritten (what-it-does first, triggers second). |
| **Rules** | New `anti-patterns.md` (9 rules). `capture` skill now proactively invokes on external content. All rules updated for terminology changes. |
| **UI** | Elephant mascot (Beate Schwichtenberg large, jrei small). Roman FIGlet "ALIVE" wordmark. Boot screen with manifesto. |
| **Config** | Update `system_version: "3.0.1"` in alive.local.yaml. |

### 3.0.1 → 3.1.0

**What changed:** Insights redesigned (4 domain knowledge categories) and status redesigned (7-section unit summary).

| Category | Changes |
|----------|---------|
| **Status** | Restructure all `_brain/status.md` files to new 7-section template (Goal, Phase, Key People, State of Play, Priorities, Blockers, Next Milestone). Use subagent to migrate content from old format. |
| **Insights** | Update all `_brain/insights.md` to new definition (unit-scoped domain knowledge). Use subagent to re-categorise entries, archive technical insights, handle people category, add header note. |
| **Rules** | Sync conventions.md, learning-loop.md, anti-patterns.md from plugin cache (new definitions, templates, condensing principle, auto-memory boundary, rule #10). |
| **Templates** | Updated status.md (7 sections), insights.md (4 categories + header note). Copy from plugin cache templates. |
| **Config** | Update `system_version` in alive.local.yaml to `3.1.0`. |

**Session 2 additional steps:**

After Step F (Terminology Migration), run these additional migration steps:

**Step G: Status Restructure (Subagent)**

Launch a Task subagent with this prompt:

```
You are migrating all status.md files to the new 7-section template. The new template focuses on unit-scoped summary, not session-level updates.

ALIVE ROOT: {alive-root}
NEW TEMPLATE: ~/.claude/plugins/cache/aliveskills/templates/brain/status.md

FIND ALL UNITS:
Search for _brain/ folders in:
- {alive-root}/04_Ventures/*/
- {alive-root}/04_Ventures/*/*/
- {alive-root}/05_Experiments/*/
- {alive-root}/05_Experiments/*/*/
- {alive-root}/02_Life/*/

FOR EACH _brain/status.md file:

1. Read the current file
2. Read the new template for reference
3. Show the user what's currently there (especially any custom sections)
4. Map content to new 7-section structure:

   NEW SECTION: **Goal:**
   - Extract from current file if exists, or leave blank for user to fill

   KEEP: **Phase:**
   - Preserve existing phase value

   NEW SECTION: ## Key People
   - Extract from unit's .claude/CLAUDE.md if exists (look for team, collaborators, contacts)
   - Or leave blank for user to fill

   MIGRATE: ## Current Focus → ## State of Play
   - Rewrite "Current Focus" as a narrative paragraph
   - This should describe what's happening NOW, not a task list

   NEW SECTION: ## Priorities
   - Extract from "Current Focus" if it has priority language
   - Or leave blank for user to fill

   KEEP: ## Blockers
   - Preserve existing blockers

   KEEP: ## Next Milestone
   - Preserve existing milestone

   REMOVE: **Recent work:** section
   - This belongs in changelog, not status
   - Archive content to _working/status-archive-[date].md if user wants to keep it

5. Ask user to confirm the migration for this unit before writing
6. Use Edit tool to update the file (not Write)

Report format per unit:
- Unit: [path]
- Sections migrated: [list]
- Content archived: [yes/no, where]
- User confirmation: [pending/approved]

IMPORTANT:
- Do NOT proceed to next unit until user confirms current unit
- Preserve all user content — archive rather than delete
- Show before/after for each unit
```

Show results:
```
▸ restructuring status.md files...
  └─ 04_Ventures/acme — Goal added, Current Focus → State of Play, Recent work archived
  └─ 04_Ventures/beta — already matches new template ✓
  └─ 05_Experiments/test — 4 sections migrated, user confirmation pending

✓ Status files restructured (2 migrated, 1 current)
```

**Step H: Insights Cleanup (Subagent)**

Launch a Task subagent with this prompt:

```
You are migrating all insights.md files to the new definition: unit-scoped domain knowledge only (not technical learnings, not people profiles).

ALIVE ROOT: {alive-root}
NEW TEMPLATE: ~/.claude/plugins/cache/aliveskills/templates/brain/status.md
NEW CATEGORIES: strategy, product, process, market

FIND ALL UNITS:
Search for _brain/insights.md files in same unit paths as status migration.

FOR EACH _brain/insights.md file:

1. Read the current file
2. Add header note at top (from template):
   "Domain knowledge specific to this unit. Technical learnings → auto-memory. People context → 02_Life/people/."

3. For EACH insight entry, categorise it:

   CATEGORY: strategy/product/process/market
   - Keep in insights.md
   - Update header to new format if needed
   - Ensure all required fields present: Category, Learning, Evidence, Applies to

   CATEGORY: technical
   - This is auto-memory territory now
   - Ask user: "This technical insight should move to auto-memory. Archive it?"
   - If yes → move to _working/insights-pruned-[date].md
   - If no → keep but warn it's outside new scope

   CATEGORY: people
   - This is person context, not domain knowledge
   - Ask user: "This is about [person]. Re-categorise the domain knowledge they shared?"
   - Show the insight, ask which new category (strategy/product/process/market)
   - Update category, add person to Evidence field: "Source: [person name], [context]"
   - Check if {alive-root}/02_Life/people/[person-name].md exists
   - If not → ask "Create person file for [person]?" → create basic person file if yes

4. Archive all pruned entries to _working/insights-pruned-[date].md with note about why

5. Ask user to confirm changes for this unit before writing

6. Use Edit tool to update insights.md (not Write)

Report format per unit:
- Unit: [path]
- Header note added: [yes/no]
- Entries kept: [count by category]
- Technical entries archived: [count]
- People entries re-categorised: [count]
- Person files created: [list]
- User confirmation: [pending/approved]

IMPORTANT:
- Do NOT proceed to next unit until user confirms
- Show each entry being re-categorised/archived
- Create person files with basic template (name, role, contact if known)
- Preserve all content — archive, don't delete
```

Show results:
```
▸ cleaning up insights.md files...
  └─ 04_Ventures/acme — 2 technical archived, 1 people re-categorised (John Smith)
  └─ 04_Ventures/beta — header note added, all entries valid ✓
  └─ 05_Experiments/test — 3 entries re-categorised, person file created

✓ Insights cleaned (2 units updated, 1 current, 1 person file created)
```

**Then continue to original Step G (Config Update) and rename it to Step I.**

---

**Future migrations will be added as new sections here.**

---

## Related Skills

- `/alive:daily` — Checks version mismatch, suggests upgrade
- `/alive:work` — Checks version mismatch, suggests upgrade
- `/alive:save` — Checks version mismatch, suggests upgrade
- `/alive:sweep` — Called post-upgrade for verification
- `/alive:onboarding` — Fresh setup (no migration needed)
