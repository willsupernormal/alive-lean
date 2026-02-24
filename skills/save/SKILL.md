---
user-invocable: true
description: End a work session and preserve all context — changelog, status, tasks, insights, and manifest. Use when the user says "save", "wrap up", "end session", "done for now", "brb", "stepping away", or "checkpoint".
plugin_version: "3.1.0"
---

# alive:save

End session. Preserve context. Complete the loop by updating ALL state files.

## UI Treatment

This skill uses **Tier 2: Core Workflow** formatting.

**Header:** Small elephant + FIGlet `small` SAVE + version + unit path.
**Border:** Rounded shell (single rounded box, three zones).
**Footer:** Community footer.

See `rules/ui-standards.md` for the Tier 2/3 header layout, pre-rendered skill names, and border characters.

**Body conventions:**
- `*` on generated changelog entry (right-aligned) — marks AI-generated content
- `·` bullet points for changes
- `↳` thread status indicator
- `)` on selectable actions

---

## Version Check (Before Main Flow)

Compare your `plugin_version` (from frontmatter above) against the user's system:

1. Read `{alive-root}/.claude/alive.local.yaml` → get `system_version`
2. If `system_version` is missing or different from your `plugin_version`:
   ```
   [!] System update available (plugin: 3.1.0, system: X.X.X)
       └─ Run /alive:upgrade to sync
   ```
3. Continue with skill — this is non-blocking, just a notice

---

## Critical Principle

**VERIFY BEFORE CONFIRMING. Save is the chance to complete the loop.**

Save touches ALL state files, not just changelog:
1. Update what happened (changelog)
2. Update where we are (status)
3. Update what's done/next (tasks)
4. Capture domain knowledge (insights) — not Claude operational patterns (auto-memory handles those)
5. Handle working files (promote or keep)
6. Update structure map (manifest) — every file touched this session must be recorded
7. Log to session-index
8. VERIFY with checklist before confirming

---

## BRB Mode (Quick Save)

If user says "brb", "stepping away", or clearly wants a quick checkpoint — **skip the questions.** Auto-select: What's happening = Checkpoint, Quality = Routine. Jump straight to saving changelog + tasks + status + manifest + session-index.

```
▸ quick checkpoint

✓ Saved to [unit]/_brain/changelog.md
  └─ "Work in progress: [summary]"

Resume with /alive:work
```

---

## The Save Flow

Two questions asked together, with a conditional follow-up. Use `AskUserQuestion` to batch them.

```
Q1 + Q2 together ──► [If "Coming back later" → Q3] ──► [Handoff if needed] ──► [Complete the Loop]
```

### Ask Q1 + Q2 Together

Use `AskUserQuestion` with both questions in a single call:

**Question 1 — What's happening?**
- **Checkpoint** — Mid-session save, still going
- **Done** — Work is complete, closing this thread
- **Continuing** — Hit the token limit, need to pick up in a new session
- **Coming back later** — Switching context, will return to this

**Question 2 — How was the session?**
- **Routine** — just working
- **Productive** — got stuff done
- **Important** — worth remembering
- **Breakthrough** — this changes things

Quality drives escalating behavior (see Escalating Actions).

### Conditional Q3: Handoff for "Coming Back Later"

**Only ask this if Q1 = "Coming back later".** Use `AskUserQuestion` with one question:

**Do you want a handoff?**
- **Yes, create a handoff** — "The work is complex or in-flight. I'll need full context to pick up where I left off without re-reading everything."
- **No, just save** — "The normal save is enough. I can get back up to speed from the changelog and status next time."

### What Happens Based on Answers

| Q1 | Handoff? | One-liner shown | Thread status |
|----|----------|-----------------|---------------|
| **Checkpoint** | No | "Quick save — you're still in the flow." | ongoing |
| **Done** | No | "Wrapping up this thread." | closed |
| **Continuing** | Always | "Creating a handoff so you can drop straight back in without losing anything." | ongoing |
| **Coming back later + Yes** | Yes | "Creating a handoff — it'll surface next time you work on this." | ongoing |
| **Coming back later + No** | No | "Saved. This will surface next time you run /alive:work or /alive:daily." | paused |

### Handoff Execution

**If handoff is triggered (Continuing or Coming back later + Yes):**

Invoke `/alive:handoff` using the Skill tool. The handoff skill runs in the main context (it has full conversation access) and writes the document directly — no subagent needed.

**Action:** Call the Skill tool with `skill: "alive:handoff"` NOW, then proceed to completing the loop.

**If "Continuing" — after handoff completes, output the resume prompt:**

```
✓ Handoff created — ready for new session

Start your new session with:
────────────────────────────────────
/alive:work [unit-name]
────────────────────────────────────
The handoff will load automatically.
```

---

## The Closest Unit Rule

**Always save to the CLOSEST unit to where work happened.**

```
04_Ventures/agency/                 ← Parent venture
├── _brain/                         ← Save here for agency-level work
├── clients/                        ← Area (no _brain/)
│   └── acme/                       ← Project
│       └── _brain/                 ← Save HERE for acme-specific work
```

**How to identify:**
1. Look at which files were edited
2. Find the nearest parent folder with `_brain/`
3. That's where you save

**Examples:**
- Edited `04_Ventures/agency/clients/acme/proposal.md` → Save to `acme/_brain/`
- Edited `04_Ventures/agency/templates/invoice.md` → Save to `agency/_brain/`
- Edited files in both → Save to BOTH (see Multi-Unit Sessions)

## Cascade Logic

After saving to closest unit, check if parent needs update:

```
Changes to project (acme)?
    ↓
Save to acme/_brain/
    ↓
Does parent (agency) need to know?
    ├── New structure created? → Update parent manifest
    ├── Phase change? → Update parent status
    └── No impact on parent? → Done
```

---

## Escalating Actions

| Quality | Actions |
|---------|---------|
| **Routine** | Changelog, tasks, status, manifest, session-index |
| **Productive** | + Check `_working/` files, + Ensure all session-modified files are in manifest |
| **Important** | + Extract insights → `insights.md` |
| **Breakthrough** | + Create capture in `_brain/memories/`, can update `CLAUDE.md` |

---

## Session ID Source (IMPORTANT)

**Use the session ID from the ALIVE startup hook in the system-reminder.**

Look for this in the system context at the start of the conversation:
```
SessionStart:startup hook success: ALIVE session initialized. Session ID: xxxxxxxx
```

The 8-character ID after "Session ID:" is YOUR session ID for this save.

**DO NOT generate a new UUID.** The session ID comes from the startup hook, not from you.

---

## Changelog Entry Format

Prepend to `_brain/changelog.md` (most recent first):

```markdown
## 2026-01-30 — Session Summary
**Session:** [session-id from startup hook]
**Quality:** [routine/productive/important/breakthrough]
**Status:** [ongoing/paused/closed]

### Changes
- What was done (specific, not vague)

### Decisions
- **Decision name:** What was chosen. Rationale: why.

### Next
- Immediate next steps (if ongoing)
- Or: "Thread closed" (if closed)

---
```

## Status Update (Surgical — Not Full Overwrite)

**Re-read `_brain/status.md` before writing.** Get the current version, not the one loaded at session start. Use the Edit tool, not Write — only modify sections that actually changed.

### Section Rules

| Section | Rule |
|---------|------|
| **Goal** | Protected — only update if user explicitly discussed changing it |
| **Phase** | Update if user explicitly discussed changing it OR if work this session clearly moved the unit to a new phase (e.g. shipped a launch = "Building" → "Launching") |
| **Updated** | Always set to today's date (if any other section was edited) |
| **Key People** | Add if new person was introduced this session. Include pointer to `02_Life/people/` if the person file exists. |
| **State of Play** | Re-read current narrative. If session materially changed the picture, rewrite affected sentences. If routine, leave it alone. This is an EDIT, not an APPEND. |
| **Priorities** | Add/remove/reword if strategic focus shifted. Otherwise untouched. |
| **Blockers** | Merge — add new blockers, remove resolved ones, leave others untouched |
| **Next Milestone** | Protected — only update if user explicitly discussed changing it |

### Guiding Principle

Don't gate status updates on session quality — gate them on whether the picture actually changed. A routine session that surfaces a blocker should update status; a breakthrough that doesn't change the strategic picture shouldn't. Ask: "Does State of Play still accurately describe this unit?" If yes, update the date and move on. If no, edit the specific sentences that no longer reflect reality. Every addition is an opportunity to condense — new information replaces outdated information, not stacks on top of it.

## Tasks Update

In `_brain/tasks.md`:

- Mark completed tasks `[x]` with date
- Add new tasks to appropriate section
- Mark in-progress tasks `[~]`

```markdown
## Urgent
- [ ] Task @urgent

## Active
- [~] In-progress task

## Done (Recent)
- [x] Completed task (2026-01-30)
```

## Insights Entry (Important+ Only)

For Important or Breakthrough saves, consider domain knowledge worth preserving in `_brain/insights.md`:

```markdown
## 2026-01-30 — [Insight Title]

**Category:** [strategy | product | process | market]
**Learning:** The insight itself
**Evidence:** How we know this
**Applies to:** Where this matters going forward

---
```

Ask: "Any domain knowledge worth capturing from this session?"

**Boundary:** If the insight is about how Claude operates, an API quirk, or a technical workflow pattern — do NOT write to insights.md. Instead, offer to save it to the user's auto-memory (`~/.claude/projects/*/memory/MEMORY.md`). Say: "That's a useful technical pattern. Want me to save it to auto-memory so it persists across all sessions?"

## Working File Handling (Productive+ Only)

Check `_working/` for files that need decisions:

1. **List all files** in `_working/` with last-modified dates
2. **For each file**, ask: **[K]eep** (still WIP) / **[P]romote** (move to permanent location) / **[A]rchive** (move to `01_Archive/`)
3. **For promotions**, ask: destination folder, new name (optional), manifest description
4. **Execute all moves** after collecting all decisions
5. **Update manifest** — remove promoted files from `working_files`, add to appropriate area's `files[]`

**NEVER DELETE. ALWAYS ARCHIVE.** Files move to `01_Archive/`, never removed.

**Versioning:** `v0.x` = WIP in `_working/`, `v1-draft` = complete draft in destination, `v1` = final in destination.

---

## Manifest Update (MANDATORY — Every Save)

**Every file touched this session must be recorded in the manifest. No exceptions.**

In `_brain/manifest.json`:

```json
{
  "name": "ProjectName",
  "description": "One sentence purpose",
  "goal": "Single-sentence goal",
  "updated": "2026-01-30",
  "session_ids": ["prev123", "abc123"],
  "folders": ["_brain", "_working", "_references", "docs"],
  "areas": [
    {
      "path": "docs/",
      "description": "Reference documentation",
      "files": [
        {
          "path": "README.md",
          "description": "Index of documentation",
          "date_created": "2026-01-20",
          "date_modified": "2026-01-30",
          "session_ids": ["abc123"]
        }
      ]
    }
  ],
  "working_files": [
    {
      "path": "_working/draft-v0.md",
      "description": "Landing page draft",
      "date_created": "2026-01-28",
      "date_modified": "2026-01-30",
      "session_ids": ["abc123"]
    }
  ],
  "key_files": [
    {
      "path": "CLAUDE.md",
      "description": "Identity",
      "date_created": "2026-01-20",
      "date_modified": "2026-01-30"
    }
  ],
  "handoffs": []
}
```

**On every save:**
1. Append current session ID to root `session_ids`
2. Update `updated` date
3. For each file created or modified this session:
   - If already in manifest → update `date_modified` and append session ID
   - If NOT in manifest → add with `description`, `date_created`, `date_modified`, `session_ids`
   - If promoted from `_working/` → remove from `working_files`, add to appropriate area
4. For `_references/` files added this session → update `references` array following the three-tier pattern (see `rules/conventions.md`)

---

## Memories (Breakthrough Only)

Create `_brain/memories/` folder if needed, then `[date]-[session-id].md`.

**Memories use YAML front matter** (same pattern as `_references/`):

```markdown
---
type: memory
date: 2026-01-30
session: abc123
unit: 04_Ventures/alive-llc
summary: One-line summary of what made this session a breakthrough
tags: [pricing, pivot, architecture]
---

## Key Quotes
> "Verbatim quote worth preserving"

## Decisions
- **Decision:** What. Rationale: Why.

## Insights
- What was learned
```

### YAML Front Matter Schema (Memories)

| Field | Required | Description |
|-------|----------|-------------|
| `type` | Yes | Always `memory` |
| `date` | Yes | Session date (ISO format: YYYY-MM-DD) |
| `session` | Yes | Session ID from startup hook |
| `unit` | Yes | Unit path (e.g. `04_Ventures/alive-llc`) |
| `summary` | Yes | One-line summary — what made this a breakthrough |
| `tags` | Yes | Array of tags for searchability |

Ask: "Any changes to this unit's identity or purpose?"
If yes, offer to update `CLAUDE.md`.

---

## Session Index Entry

**Append** a new line to the END of `.claude/state/session-index.jsonl`:

Use `echo '...' >> file` (double `>>`) to append, NOT overwrite. Each entry is one JSON object per line (JSONL format). Newest entries go at the bottom.

```json
{
  "ts": "2026-01-30T14:30:00Z",
  "session_id": "abc123",
  "unit": "04_Ventures/alive-llc",
  "save_type": "end_session",
  "status": "ongoing",
  "quality": "productive",
  "summary": "Brief description of session"
}
```

**Backwards compatibility:** Older entries may use `"project"` instead of `"unit"`. When reading session-index.jsonl, accept both field names (`entry.unit || entry.project`).

---

## Batch Execution (MANDATORY)

**After the 3-2-1 answers and any handoff, generate ALL proposed changes at once. Do NOT write files one at a time with processing between each.**

### Step 1: Re-read current state

Re-read `_brain/status.md`, `_brain/tasks.md`, and `_brain/manifest.json` to get current versions (another session may have updated them).

### Step 2: Generate all changes

Prepare everything in one pass:
- Changelog entry (draft the full entry)
- Status edits (which sections need surgical updates)
- Task updates (which tasks changed state, any new ones)
- Manifest updates (session ID, file entries, working file changes)
- Session-index entry
- Working file decisions (Productive+ only — list files, propose K/P/A)
- Insights extraction (Important+ only)

### Step 3: Present summary for approval

Show the user a single summary of ALL proposed changes:

```
▸ proposed save changes:

  changelog  · 4 changes, 2 decisions logged
  status     · State of Play updated (1 sentence edited)
  tasks      · 3 marked done, 1 new added
  manifest   · session ID appended, 2 files updated
  session-idx · entry appended

  Approve all? [y] yes  [e] edit something first
```

### Step 4: Execute all writes

On approval, write all files using parallel tool calls — changelog, tasks, status, manifest, and session-index have no dependencies on each other. Send them all in one response.

**If user wants to edit:** Let them specify which item to change, adjust, then re-present.

---

## Pre-Write Checklist (Internal)

**Verify internally before presenting the summary. Do not show this to the user — it's your quality check.**

- Changelog includes session ID and specific changes
- Status edits are surgical (Edit tool, not Write)
- Tasks reflect actual state changes
- Every file touched this session is in the manifest
- Saving to CLOSEST unit
- Working files checked (Productive+)

---

## Multi-Unit Sessions

If session touched multiple units:

```
This session touched:
[1] 04_Ventures/alive-llc — Plugin rebuild
[2] 04_Ventures/acme-agency — Client note

Save to both?
```

Write separate entries. Cross-reference if related.

---

## Edge Cases

**No active unit:**
Ask which venture, experiment, or life area work happened in.

**Nothing to save:**
Offer to log checkpoint anyway.

**Infrastructure work:**
Write to `.claude/state/changelog.md` for system-level changes.
