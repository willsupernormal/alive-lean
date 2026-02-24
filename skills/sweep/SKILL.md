---
user-invocable: true
description: Audit the system for stale content, orphan files, and cleanup opportunities. Use when the user says "sweep", "clean up", "audit", "check for stale", "maintenance", or "spring cleaning".
plugin_version: "3.1.0"
---

# alive:sweep

Audit the ALIVE system for structural compliance, stale content, and cleanup opportunities. Uses sub-agents for thorough analysis without overloading context.

## UI Treatment

Uses the **ALIVE Shell** — Tier 3: Utility.

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · sweep                          [date]            │
│  [N] stale  ·  [N] actionable                             │
│  ──────────────────────────────────────────────────────── │
│  [Stale items with recommendations]                       │
│  ──────────────────────────────────────────────────────── │
│  [ACTIONS]                                                │
╰──────────────────────────────────────────────────────────╯
```

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## When to Use

Invoke when the user:
- Wants to check system health
- Asks about stale content
- Needs to clean up or organize
- Says "sweep", "audit", "maintenance", "spring cleaning"

---

## Step 1: Scope the Sweep

**Use AskUserQuestion to determine scope.**

```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  sweep                                                                 │
╰────────────────────────────────────────────────────────────────────────╯

What do you want to sweep?
```

**AskUserQuestion:**

| Option | Description |
|--------|-------------|
| Everything | Full system audit — root, all domains, all units |
| One domain | Pick a domain (Ventures, Experiments, Life) |
| One unit | Pick a specific unit to deep-audit |
| Quick overview | Fast health summary, no cleanup actions |

If user picks "One domain" → follow up asking which domain.
If user picks "One unit" → follow up asking which unit.

---

## Step 2: Root-Level Audit (Always Runs)

**This runs in the main context (not a sub-agent) because it's fast.**

Check that the ALIVE root directory contains ONLY the allowed top-level items:

### Allowed Root Items

```
{alive-root}/
├── .claude/              ✓ System config
├── 01_Archive/           ✓ Inactive items
├── 02_Life/              ✓ Personal
├── 03_Inputs/            ✓ Incoming context
├── 04_Ventures/          ✓ Revenue-generating
├── 05_Experiments/       ✓ Testing grounds
├── alive.local.yaml      ✓ User preferences (optional)
├── .gitignore            ✓ Git config (optional)
├── .DS_Store             ✓ macOS (ignore)
├── Icon\r                ✓ macOS folder icon (ignore)
```

**Everything else at root is a violation.** Flag it.

### Common Pitfalls to Catch

These are things Claude or third-party skills frequently create in the wrong place:

| Pitfall | What It Looks Like | Why It's Wrong | Suggested Fix |
|---------|--------------------|----------------|---------------|
| **Plans folder at root** | `docs/plans/` or `plans/` at ALIVE root | Superpowers skill default — should be `{unit}/_working/plans/` | Move into relevant unit's `_working/plans/` |
| **Docs folder at root** | `docs/` at ALIVE root | Generic folder, not part of ALIVE structure | Move contents into relevant unit |
| **Inbox at root** | `inbox/` at ALIVE root | Old v1 naming — should be `03_Inputs/` | Rename or merge into `03_Inputs/` |
| **_state at root or in units** | `_state/` anywhere | Old v1 naming — should be `_brain/` | Run `/alive:upgrade` |
| **Random markdown files** | `TODO.md`, `NOTES.md`, `TASKS.md` at root | Loose files — should be in a unit's `_brain/` or `_working/` | Move to relevant unit |
| **FUTURE-TODO.md** | Anywhere | Claude sometimes creates this instead of using `tasks.md` | Merge contents into unit's `_brain/tasks.md`, archive file |
| **Numbered domain without underscore** | `01Archive/` or `04Ventures/` | Incorrect naming — needs underscore | Rename to `01_Archive/`, `04_Ventures/`, etc. |
| **Un-numbered domains** | `archive/`, `life/`, `ventures/` | Old v1 naming | Run `/alive:upgrade` or rename |
| **Tmp or scratchpad files** | `temp/`, `scratch/`, `test.md` | Doesn't belong in ALIVE | Move to unit's `_working/` or delete |
| **Git artifacts** | Unexpected `.git/` directories inside units | Nested git repos cause issues | Flag for user review |

### Root Audit Output

```
ROOT STRUCTURE
─────────────────────────────────────────────────────────────────────────
▸ scanning {alive-root}/

✓ .claude/
✓ 01_Archive/
✓ 02_Life/
✓ 03_Inputs/
✓ 04_Ventures/
✓ 05_Experiments/

VIOLATIONS:
[1] ✗ docs/plans/feature-spec.md — Plans folder at root
      → Move to relevant unit's _working/plans/
[2] ✗ TODO.md — Loose file at root
      → Move to relevant unit's _brain/tasks.md
[3] ✗ inbox/ — Old v1 naming
      → Merge into 03_Inputs/ and archive
```

If no violations: `✓ Root structure clean`

---

## Step 3: Domain Scan

**Scan each domain in scope to discover units.**

```
▸ scanning 04_Ventures/
  └─ acme/ (venture)
  └─ side-hustle/ (venture)

▸ scanning 05_Experiments/
  └─ new-idea/ (experiment)

▸ scanning 02_Life/
  └─ people/ (area — always expected)
  └─ fitness/ (area or life area — check for _brain/)
```

Build the list of units to audit. Each unit gets a sub-agent.

---

## Step 4: Dispatch Sub-Agents (One Per Unit)

**For each unit in scope, dispatch a sub-agent using the Task tool.**

Sub-agents run in parallel where possible. Each sub-agent receives:
1. The unit path
2. The full audit checklist (below)
3. Instructions to return structured findings

### Sub-Agent Prompt Template

```
You are auditing an ALIVE unit for structural compliance and health.

UNIT: {unit_path}

Run ALL of the following checks and return your findings as a structured report.
Be thorough — read actual files, check actual timestamps, compare actual disk contents against manifest.

---

AUDIT CHECKLIST:

## A. Required Structure

Check that these exist:
- [ ] .claude/CLAUDE.md (unit identity file)
- [ ] _brain/status.md
- [ ] _brain/tasks.md
- [ ] _brain/insights.md
- [ ] _brain/changelog.md
- [ ] _brain/manifest.json
- [ ] _working/ folder exists
- [ ] _references/ folder exists

For each missing item, report: MISSING: {path} — {what it should contain}

## B. Status.md Structure Validation

Read _brain/status.md and check for the 7-section structure:

Required sections (in order):
1. **Goal:** — One sentence defining the unit's purpose
2. **Phase:** — [Starting | Building | Launching | Growing | Maintaining | Paused]
3. **Updated:** — ISO date (YYYY-MM-DD)
4. **Key People:** — People involved (with links to `02_Life/people/` where applicable)
5. **State of Play:** — Current situation and what's happening now
6. **Priorities:** — What matters most right now
7. **Blockers:** — What's stopping progress ("None" if clear)
8. **Next Milestone:** — What "done" looks like for this phase

Check for:
- Missing sections → MISSING_STATUS_SECTION: {section name}
- Old format using "Current Focus" instead of "State of Play" → LEGACY_STATUS_FORMAT: Uses "Current Focus" (should be "State of Play")
- Missing **Goal:** field → MISSING_GOAL: status.md has no Goal statement
- Key People section with full person details instead of links → PEOPLE_IN_STATUS: Person details should be in `02_Life/people/`, status.md should only link

Report: STATUS_STRUCTURE: {finding}

## C. Manifest Reconciliation (Safety Net for Missed Saves)

**This is critical.** If a save was forgotten or interrupted, files may exist on disk but not in the manifest. The manifest must reflect reality.

Read _brain/manifest.json and do a FULL reconciliation against what actually exists on disk.

1. **Ghost entries:** Files listed in manifest that DON'T exist on disk
   - Check every path in areas[].files[], working_files[], key_files[]
   - Report: GHOST: {path} listed in manifest but missing from disk

2. **Untracked files (the big one):** Files on disk NOT listed in manifest
   - List ALL files in the unit recursively (excluding .claude/, _brain/, .DS_Store, Icon files)
   - Compare against ALL manifest entries (areas[].files[], working_files[], key_files[])
   - For each untracked file:
     a. Read the file to understand its contents
     b. Determine where it belongs in the manifest:
        - In _working/ → should be in working_files[]
        - In an folder → should be in that area's files[]
        - At unit root → should be in key_files[] or flagged as orphan
     c. Generate a proposed manifest entry with description, date_created, date_modified, session_ids
   - Report: UNTRACKED: {path} — proposed entry: {"path": "{path}", "description": "{generated description}", "date_created": "{date}", "date_modified": "{date}", "session_ids": []}

3. **Stale descriptions:** Files where the manifest description seems wrong
   - Read the file, compare to manifest description
   - Report: STALE_DESC: {path} — manifest says "{old}" but file is about "{actual}"

4. **Folder list accuracy:** Does manifest.folders[] match actual folders on disk?
   - Folders on disk not in manifest.folders[] → MISSING_FOLDER
   - Folders in manifest.folders[] not on disk → GHOST_FOLDER

5. **Area accuracy:** Do manifest.areas[] match actual area folders?
   - Area folders on disk not in manifest.areas[] → MISSING_AREA
   - Areas in manifest.areas[] not on disk → GHOST_AREA

6. **Missing file metadata:** Check all file entries in manifest for required fields
   - Every file entry (in areas[].files[], working_files[], key_files[]) must have: `date_created`, `date_modified`, `session_ids` (array)
   - Report: MISSING_METADATA: {path} — missing {field(s)} (e.g. "missing date_created, date_modified")
   - Also check unit root manifest fields: must have `goal`, `session_ids` (array, not singular `session_id`)
   - Report: LEGACY_FIELD: manifest root has `session_id` (singular) — should be `session_ids` (array)
   - Report: MISSING_GOAL: manifest root is missing `goal` field

## D. _brain/ Freshness

For each _brain/ file, check the last updated date:

| Age | Flag |
|-----|------|
| < 14 days | OK |
| 14-28 days | STALE |
| > 28 days | VERY_STALE |

Check:
- status.md — look for **Updated:** date
- tasks.md — look for most recent [x] done date
- changelog.md — look for most recent ## date header
- manifest.json — check "updated" field

Report: {file}: {age} days — {OK|STALE|VERY_STALE}

## E. Tasks Health

Read _brain/tasks.md and check:
- Tasks marked [~] (in-progress) for more than 7 days → STUCK
- Tasks marked @urgent that are not [~] → URGENT_IDLE
- Empty urgent section with items in To Do → OK
- Extremely long task list (>30 items) → BLOATED

## F. Insights Boundary Check

Read _brain/insights.md and scan entries for misplaced content:

| Pattern | Flag | Suggestion |
|---------|------|------------|
| Entries with `technical` category | "Auto-memory territory" | Archive entry, offer to save pattern to `~/.claude/projects/*/memory/MEMORY.md` |
| Entries with `people` category | "People belong in status.md Key People or `02_Life/people/`" | Re-categorise the domain knowledge under strategy/product/process/market with person as Evidence source |
| Entries that read like decisions (rationale, alternatives rejected) | "Decision territory" | Should be in changelog, not insights |
| Entries older than 6 months with no `Applies to` reference | "Potentially stale insight" | Ask user if still relevant |

Valid categories for insights are: `[strategy | product | process | market]`

Report format:
- INSIGHT_BOUNDARY: {entry title} — {flag} — {suggestion}

## G. _working/ Folder Audit

List all files in _working/ and check:

1. **File naming:** Do files follow [unit]_[context]_[name].ext pattern?
   - Report: BAD_NAME: {filename} — missing unit prefix or context

2. **File age:** Check modification dates
   - > 14 days old → STALE_DRAFT
   - > 28 days old → VERY_STALE_DRAFT

3. **Evolution candidates:** Are there 3+ files with a shared prefix?
   - Report: EVOLVE: {prefix} — {count} related files, consider promoting to folder

4. **Sessions cleanup:** Check _working/sessions/ for old handoff files
   - Any file here that is NOT referenced in manifest.handoffs[] is orphaned
   - Report: ORPHAN_HANDOFF: {filename}

## H. Orphaned & Misplaced Files

Check for files that shouldn't be where they are:

1. **Files in unit root** (should be in an area or _working/)
   - Allowed in root: CLAUDE.md (if no .claude/ folder), README.md
   - Everything else is orphaned
   - Report: ORPHAN: {filename} in unit root

2. **Common pitfalls inside units:**
   - plans/ folder → should be _working/plans/
   - docs/plans/ → should be _working/plans/
   - inbox/ → old naming, should be in 03_Inputs/ at ALIVE root
   - _state/ → old naming, should be _brain/
   - FUTURE-TODO.md → should be in _brain/tasks.md
   - TODO.md, NOTES.md → should be in _brain/
   - decisions/ without being listed as an area → flag for review

3. **Areas without README.md**
   - Every folder should have a README.md
   - Report: NO_README: {area_path}

## I. Nested Project Check

For any area with has_projects: true in manifest:
- Check that each nested project has its own _brain/, _working/, and _references/
- Check that nested projects DON'T use the parent's _working/

## J. _references/ Folder Audit

Each type subfolder (emails/, calls/, meeting-transcripts/, etc.) should have summary `.md` files at root and a `raw/` subfolder for originals.

1. **Structure validation:** Each type subfolder must have a `raw/` subfolder
   - Report: MISSING_RAW: {type-folder}/ has no raw/ subfolder

2. **Summary-raw pairing:** Every summary `.md` should have a corresponding file in `raw/` (and vice versa)
   - Report: ORPHAN_SUMMARY: {filename}.md has no matching file in raw/
   - Report: ORPHAN_RAW: raw/{filename} has no matching summary .md
   - Exception: `notes/` type may not always need raw files

3. **Front matter validation:** Every summary `.md` must have valid YAML front matter
   - Required: `type`, `date`, `summary`
   - Must have `## Source` section pointing to raw file
   - Report: BAD_FRONTMATTER: {filename} — missing {field}
   - Report: NO_FRONTMATTER: {filename} — no YAML front matter found
   - Report: NO_SOURCE: {filename} — missing ## Source pointer to raw file

4. **Orphaned references:** Summary .md files not tracked in manifest's `references` array
   - Compare disk contents against manifest.references[].path
   - Report: ORPHAN_REF: {filename} exists in _references/ but not in manifest references[]

5. **Missing references:** Entries in manifest's `references` array where the file doesn't exist on disk
   - Report: GHOST_REF: {path} listed in manifest references[] but missing from disk

6. **Stale references:** References older than 90 days (based on `date` front matter field)
   - Low priority — INFO level only
   - Report: OLD_REF: {filename} — {age} days old, may no longer be relevant

7. **Raw files at wrong level:** Raw content files (.txt, .pdf, .png) sitting at type folder root instead of in `raw/`
   - Report: MISPLACED_RAW: {filename} should be in raw/ subfolder

## K. Archive References

Check if any files reference archived paths that no longer exist.

---

OUTPUT FORMAT:

Return findings grouped by severity:

### CRITICAL (structural violations)
- {finding}

### WARNING (stale content, naming issues)
- {finding}

### INFO (suggestions, evolution candidates)
- {finding}

### CLEAN (checks that passed)
- {check}: OK

If everything passes: "Unit {name} is fully compliant. No issues found."
```

### Dispatch Pattern

```python
# Parallel dispatch — one sub-agent per unit
for unit in units_to_audit:
    Task(
        subagent_type="general-purpose",
        prompt=sub_agent_prompt.format(unit_path=unit),
        description=f"Audit {unit}"
    )
```

**For "Quick overview" scope:** Skip sub-agents. Just read each unit's `_brain/status.md` and `_brain/manifest.json` updated dates, count `_working/` files, count tasks. Present summary table only.

---

## Step 5: Inputs Check (Always Runs)

Check `03_Inputs/` in the main context:

```
▸ scanning 03_Inputs/...
```

- Count items
- Check age of oldest item
- Flag if > 7 days old: `[!] 03_Inputs/ has {n} items, oldest {age} days`
- Suggest `/alive:digest` if items exist

---

## Step 6: Aggregate & Present Report

Collect all sub-agent findings. Present unified report.

```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  sweep — results                                                       │
╰────────────────────────────────────────────────────────────────────────╯

SYSTEM HEALTH SUMMARY
─────────────────────────────────────────────────────────────────────────
Root structure:     ✓ Clean
03_Inputs/:         [!] 5 items (oldest 2 weeks) → /alive:digest
Units scanned:      4

UNIT RESULTS
─────────────────────────────────────────────────────────────────────────
[Unit Name]             Critical  Warnings  Info
─────────────────────────────────────────────────────────────────────────
acme/webapp               0        3        2
side-hustle               1        1        0
new-idea                  0        0        1
fitness                   0        2        0
─────────────────────────────────────────────────────────────────────────
TOTAL                     1        6        3
```

Then expand each unit's findings:

```
SIDE-HUSTLE — 1 critical, 1 warning
─────────────────────────────────────────────────────────────────────────

CRITICAL:
[1] ✗ Missing _brain/insights.md
      → Create with template from conventions

WARNINGS:
[2] [!] _brain/status.md is 18 days stale
      → Update status or mark as intentionally dormant

─────────────────────────────────────────────────────────────────────────

ACME/WEBAPP — 0 critical, 3 warnings, 2 info
─────────────────────────────────────────────────────────────────────────

WARNINGS:
[3] [!] _working/ has 12 files, 3 are > 14 days old
[4] [!] Manifest lists docs/OLD-FILE.md but file doesn't exist on disk
[5] [!] Task "Fix login" in-progress for 12 days

INFO:
[6] 💡 _working/ has 4 files with prefix "alive_ecosystem-*" — evolution candidate
[7] 💡 Area marketing/ has no README.md

─────────────────────────────────────────────────────────────────────────
```

---

## Step 7: Offer Cleanup Actions

Every finding gets a number. User picks what to address.

```
─────────────────────────────────────────────────────────────────────────
[#] Address specific issue
[a] Address all critical + warnings
[c] Address critical only
[i] Ignore all — just wanted the report
[e] Export findings to _working/sweep-report.md

What to address?
```

### Cleanup Actions by Finding Type

| Finding | Action Options |
|---------|---------------|
| **MISSING file** | Create from template |
| **GHOST manifest entry** | Remove from manifest |
| **UNTRACKED file** | Add to manifest (with generated description, date_created, date_modified, session_ids) / Move to correct location / Archive |
| **Manifest reconciliation** (batch) | Add ALL untracked files to manifest at once — uses sub-agent generated descriptions and metadata |
| **MISSING_METADATA** | Add missing `date_created`, `date_modified`, `session_ids` fields to manifest file entries |
| **LEGACY_FIELD** | Convert manifest root `session_id` (singular) to `session_ids` (array) |
| **MISSING_GOAL** | Prompt user for unit goal, add `goal` field to manifest root |
| **STATUS_STRUCTURE** | Update status.md to use 7-section format (Goal, Phase, Updated, Key People, State of Play, Priorities, Blockers, Next Milestone) |
| **LEGACY_STATUS_FORMAT** | Replace "Current Focus" section with "State of Play" |
| **PEOPLE_IN_STATUS** | Move person details to `02_Life/people/`, replace with link in status.md Key People |
| **INSIGHT_BOUNDARY** | Archive insight entry / Move to appropriate location (changelog, auto-memory, etc.) / Re-categorise |
| **STALE _brain/** | Open unit with `/alive:work` to refresh |
| **STUCK task** | Mark done / Reset to To Do / Update |
| **STALE_DRAFT** | Archive / Promote / Keep |
| **EVOLVE candidate** | Run working folder evolution (create folder + README, move files) |
| **ORPHAN file** | Move to `_working/` / Move to area / Archive |
| **Common pitfall** (plans/, inbox/, etc.) | Move to correct ALIVE location |
| **NO_README** | Create README.md from template |
| **ORPHAN_HANDOFF** | Archive to `01_Archive/{unit}/sessions/` |
| **BAD_NAME** | Suggest rename following `[unit]_[context]_[name].ext` |
| **BAD_FRONTMATTER / NO_FRONTMATTER** | Add or fix YAML front matter with required fields (`type`, `date`, `summary`) |
| **ORPHAN_REF** | Add to manifest references[] / Archive |
| **GHOST_REF** | Remove from manifest references[] |
| **OLD_REF** | Review relevance / Archive / Keep |
| **Inputs backlog** | Run `/alive:digest` |

**IMPORTANT: Never delete. Always archive.** All cleanup actions that remove files must move them to `01_Archive/`, mirroring the original path.

---

## Step 8: Execute Cleanups

For each selected action:

```
▸ executing cleanups...

[1] ✓ Created _brain/insights.md from template
[3] ✓ Archived 3 stale drafts to 01_Archive/
[4] ✓ Removed ghost entry from manifest.json
[6] ✓ Evolved 4 ecosystem files into ecosystem-map/ folder

4 issues resolved.
```

After execution, update the unit's `_brain/manifest.json` if any files were moved/created/removed.

---

## Step 9: Post-Sweep

```
✓ Sweep complete

Resolved: 4 issues
Remaining: 6 issues (not addressed)
System health: [!] Needs attention (6 open items)

─────────────────────────────────────────────────────────────────────────
Tip: Run /alive:sweep regularly to keep your system healthy.
```

Update `alive.local.yaml` if it exists:
```yaml
last_sweep: 2026-02-06
```

---

## Quick Sweep (Fast Path)

When user says "quick sweep" or selects "Quick overview" in Step 1:

**Skip sub-agents entirely.** Just scan top-level structure and read dates.

```
▸ quick system scan...

HEALTH SUMMARY
─────────────────────────────────────────────────────────────────────────
Root:        ✓ Clean (6 allowed folders, 0 violations)
Inputs:      3 items (oldest 5 days)

Units:
  acme/webapp          Building    Updated 2 days ago     7 _working/ files
  side-hustle          Growing     Updated 18 days ago    3 _working/ files  [!]
  new-idea             Starting    Updated 1 day ago      0 _working/ files

Status: [!] 1 unit stale

─────────────────────────────────────────────────────────────────────────
[1] Full sweep (deep audit)
[2] Sweep side-hustle only
[3] Done
```

---

## Sweep by Domain

When user picks "One domain":

```
Which domain?
[1] 04_Ventures/
[2] 05_Experiments/
[3] 02_Life/
```

Then run root audit + sub-agents for units in that domain only.

---

## Sweep Thresholds

| Check | Default Threshold |
|-------|-------------------|
| Stale _brain/ | 14 days |
| Stuck in-progress task | 7 days |
| Large _working/ | 5+ files |
| Old drafts in _working/ | 14 days |
| Very old drafts | 28 days |
| Inputs backlog | 7 days oldest item |
| Evolution trigger | 3+ files with shared prefix |
| Old references | 90 days (INFO only) |

---

## Edge Cases

**Everything clean:**
```
✓ No issues found

System is healthy:
- Root structure compliant
- All units have complete _brain/
- Manifests accurate
- No stale content
- Inputs clear
- _working/ folders tidy
- _references/ valid and tracked
```

**Massive cleanup needed (>20 issues):**
```
Found 47 issues across 5 units.

This is a big cleanup. How to proceed?
[1] Critical only (12 items)
[2] One unit at a time
[3] All at once (will take time)
[4] Export report to _working/sweep-report.md for manual review
```

**Unit has no _brain/ at all:**
```
[!] 04_Ventures/mystery-project/ has no _brain/ folder

This doesn't look like a properly initialised unit.

Options:
[1] Initialise _brain/ now (create all 5 files from template)
[2] Archive — move to 01_Archive/
[3] Skip
```

---

## Related Skills

- `/alive:archive` — Move items to archive
- `/alive:digest` — Process inputs backlog
- `/alive:work` — Refresh stale unit
- `/alive:new` — Create missing structure
- `/alive:upgrade` — Fix v1 → v2 naming issues
