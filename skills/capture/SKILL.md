---
user-invocable: true
description: Capture any context into ALIVE — notes, emails, transcripts, decisions, filepaths, or anything worth preserving. Auto-invoke when the user shares a filepath, pastes external content (emails, transcripts, articles), or says "capture this", "note this", "remember this", "FYI", "here's some context", "I decided", "I learned". If the user drops content without explicitly asking to capture, invoke this skill proactively.
plugin_version: "3.1.0"
---

# alive:capture

Capture context into ALIVE. User gives you content — you understand it, confirm intent, store it properly, and identify what action comes next.

## UI Treatment

Uses the **ALIVE Shell** — Tier 3: Utility. See `rules/ui-standards.md` for shell format and logo assets.

---

## Proactive Invocation

**This skill should fire automatically when external context arrives** — not just when the user explicitly says "capture this." If the user:

- Shares a filepath (`here's the transcript: /path/to/file.txt`)
- Pastes a wall of text (email, transcript, article, Slack thread)
- Drops content with context ("from my call with John...", "got this email...")
- Shares a screenshot or document

...invoke this skill without waiting to be asked. The two-question flow (confirm intent + confirm storage) gives the user control over what happens, so auto-invoking is safe.

**Don't auto-invoke for:** Quick decisions or thoughts that belong in `_brain/` directly ("let's go with option B"), single-line notes, or content the user is clearly just discussing rather than wanting to store.

---

## The Premise

The user has context they want in the system. It might be a quick thought, a pasted email, a meeting transcript, a screenshot, a filepath, an article — anything. Your job:

1. Receive it
2. Understand what it is and what unit it relates to
3. Confirm what the user wants to do with it (the action)
4. Confirm where to store it, and whether to extract to `_brain/`
5. Store the source material in `_references/` with YAML front matter
6. If user opted in, extract valuable parts (decisions, tasks, insights, people) to `_brain/`
7. Note the pending action — but don't execute it

**The skill captures and classifies. It does not execute the action.** If the user wants to write a response to an email, the skill stores the email and identifies "write response" as the action. The response gets written after the skill exits.

**One skill for all incoming context. No distinction between "your thoughts" and "external content."**

---

## Context Check (BEFORE Processing)

**You MUST load context before routing anything.** Without this, you're guessing.

| Check | Why |
|-------|-----|
| Active unit (from `/alive:work`) | Default routing destination |
| `{unit}/_brain/manifest.json` | Know what areas exist, existing references |
| `{unit}/_brain/status.md` | Unit summary — informs relevance |
| `02_Life/people/` listing | Check for existing person files before creating |

```
▸ loading context...
  └─ Active: 04_Ventures/acme
  └─ Areas: clients/, content/, partnerships/
  └─ References: 3 existing in _references/
  └─ Focus: "Closing Q1 deals"
  └─ People: 47 files in 02_Life/people/
```

If no unit is active, scan units for keyword matches to suggest routing.

---

## Flow

```
Content received
    ↓
Context check (unit, manifest, people)
    ↓
Identify (content type, unit match, people)
    ↓
Question 1: Confirm what it is +
what do you want to do with it?
    ↓
Question 2: Confirm where to store +
what to extract to _brain/
    ↓
Store source to _references/
(If opted in) Extract to _brain/
Handle people
    ↓
Confirm done + note pending action
```

**Every capture follows this flow.** Whether it's a one-line decision or a 50-message email thread, the same steps apply. The system adjusts depth based on content complexity, but the flow is always: identify → confirm intent → confirm storage → execute.

**Manifest is NOT updated here.** The `/alive:save` skill handles manifest updates at session end.

---

## Step 1: Identify

Detect content type, match to unit, identify people mentioned.

| Type | Signals |
|------|---------|
| Email | "From:", "To:", "Subject:", forwarded markers |
| Transcript | Speaker labels, timestamps, dialogue format |
| Slack/Chat | @mentions, emoji reactions, thread format |
| Article | Long-form prose, headings, no dialogue |
| Document | Structured content, sections |
| Screenshot | Image file shared |
| Quick thought | Short statement, decision, FYI, note |
| Unknown | Ask user to clarify |

```
▸ identifying...
  └─ Type: Email from Sarah Chen (Globex)
  └─ Unit match: 04_Ventures/acme (Globex in manifest)
  └─ Person: Sarah Chen — found in 02_Life/people/sarah-chen.md
```

For quick thoughts ("FYI the deadline moved to Friday"), identification is instant — type is obvious, unit is the active one.

---

## Step 2: Confirm Intent (Question 1)

**Use AskUserQuestion.** Confirm what the content is AND what the user wants to do with it. The system makes an assumption based on context and presents it as the first option.

**Allow variability.** The options below are examples — adapt them based on the content type and what the user likely wants. AskUserQuestion always includes "Other" for custom input. The user's intent may not fit neatly into predefined categories, so options should be suggestive, not exhaustive.

```
This is an email from Sarah Chen (Globex) about the pilot program pricing.

What do you want to do?
[1] Store email + extract key points to _brain/ (Recommended)
[2] Store email + write a response (I'll help draft after storing)
[3] Just store as reference (no extraction to _brain/)
[4] Dump to 03_Inputs/ for later
```

For simple content:
```
Quick note: "FYI the deadline moved to Friday"

What do you want to do?
[1] Store as reference + log to _brain/ (Recommended)
[2] Just store as reference
[3] Just log to _brain/ (no reference file)
[4] Dump to 03_Inputs/ for later
```

**The action is identified here but NOT executed.** If the user picks "Write a response", note it as the pending action for after the skill completes.

If dump → save raw content to `03_Inputs/[date]-[type]-[subject].md` and exit.

---

## Step 3: Confirm Storage + Extraction (Question 2)

**Use AskUserQuestion.** Show what the system will extract and where everything goes. The system recommends `_references/` by default for source material.

If user chose to extract to `_brain/` in Q1, show what will be extracted:
```
I'll store and extract:

SOURCE
- Summary  → _references/emails/2026-02-06-globex-pilot-pricing.md
- Raw      → _references/emails/raw/2026-02-06-globex-pilot-pricing.txt

EXTRACTIONS → _brain/ (you chose to extract)
- 2 tasks → tasks.md
- 1 decision → changelog.md
- Key context (budget $50k, Feb 15 start)

PEOPLE
- Sarah Chen — update existing file with new context

[1] Confirm
[2] Edit extractions
[3] Different storage location
[4] Skip _brain/ extraction, just store
```

If user chose "just store" in Q1:
```
I'll store:

SOURCE
- Summary  → _references/emails/2026-02-06-globex-pilot-pricing.md
- Raw      → _references/emails/raw/2026-02-06-globex-pilot-pricing.txt

PEOPLE
- Sarah Chen — update existing file with new context

[1] Confirm
[2] Actually, extract to _brain/ too
[3] Different storage location
```

For simpler content:
```
I'll capture:

SOURCE → _references/notes/2026-02-06-deadline-update.md

EXTRACTION → _brain/changelog.md (you chose to log)
- "Deadline moved to Friday"

[1] Confirm
[2] No reference needed, just log it
[3] Different destination
```

**The user controls what happens.** They can store without extracting, extract without storing a reference, or do both. The skill adapts to their choice from Q1.

---

## Step 4: Store Source to `_references/`

This is the authoritative guide for how reference files are structured.

### `_references/` Folder Structure

Each content TYPE gets a subfolder, created dynamically as content arrives. Inside each type folder, `.md` summary files sit at root level and a `raw/` subfolder holds the original source files.

```
_references/
├── meeting-transcripts/
│   ├── 2026-02-08-content-planning.md        ← YAML front matter + detailed AI summary + source pointer
│   ├── 2026-02-04-partner-sync.md
│   └── raw/
│       ├── 2026-02-08-content-planning.txt
│       └── 2026-02-04-partner-sync.txt
├── emails/
│   ├── 2026-02-06-globex-pilot-pricing.md
│   ├── 2026-02-03-investor-intro.md
│   └── raw/
│       ├── 2026-02-06-globex-pilot-pricing.txt
│       └── 2026-02-03-investor-intro.txt
├── notes/
│   └── 2026-02-06-deadline-update.md         ← short notes may not need a raw file
├── screenshots/
│   ├── 2026-02-06-competitor-landing.md       ← front matter + analysis + source pointer
│   └── raw/
│       └── 2026-02-06-competitor-landing.png
└── documents/
    ├── 2026-02-06-contract-scan.md
    └── raw/
        └── 2026-02-06-contract-scan.pdf
```

Common subfolder types: `emails/`, `calls/`, `meeting-transcripts/`, `messages/`, `screenshots/`, `articles/`, `notes/`, `documents/`. Any descriptive name works — the system creates what makes sense for the content.

### How It Works

Every reference follows the same pattern regardless of content type:

1. **Summary `.md` file** sits at the type folder root — contains YAML front matter, a detailed AI summary, and a `## Source` pointer to the raw file
2. **Raw file** lives in `raw/` subfolder — preserves the original content exactly as received
3. **Three-tier access** — manifest index (what exists) → summary .md (detailed understanding) → raw file (original content)

| Content | Summary File | Raw File |
|---------|-------------|----------|
| Email | `emails/2026-02-06-globex-pricing.md` | `emails/raw/2026-02-06-globex-pricing.txt` |
| Transcript | `meeting-transcripts/2026-02-08-sync.md` | `meeting-transcripts/raw/2026-02-08-sync.txt` |
| Screenshot | `screenshots/2026-02-06-competitor.md` | `screenshots/raw/2026-02-06-competitor.png` |
| PDF | `documents/2026-02-06-contract.md` | `documents/raw/2026-02-06-contract.pdf` |
| Quick note | `notes/2026-02-06-deadline-update.md` | _(may not need raw file)_ |

### Text Content Template

All text-based references (emails, transcripts, messages, articles) use this format. The summary should be **detailed enough that you rarely need to read the raw file** — include decisions, action items, key points, and notable quotes where relevant.

```markdown
---
type: email
date: 2026-02-06
description: Sarah Chen confirms Globex pilot pricing at $50k, starting Feb 15
source: Sarah Chen (Globex)
tags: [pricing, pilot, globex]
subject: Re: Pilot program pricing
from: sarah@globex.com
to: team@acme.com
---

## Summary

Sarah confirms the pilot program budget at $50k for a 3-month engagement
starting Feb 15. She needs the contract by Friday to get sign-off from
their board. John (CTO) will be the technical lead on their side.

### Key Points
- Budget: $50k approved
- Timeline: 3 months starting Feb 15
- Technical lead: John (CTO)

### Action Items
- Send contract by Friday (board sign-off deadline)
- Schedule kickoff call with John

### Decisions
- Globex going with the standard pilot package, not the extended option

## Source

`raw/2026-02-06-globex-pilot-pricing.txt`
```

### YAML Front Matter Schema

**Required fields:**

| Field | Description |
|-------|-------------|
| `type` | Content kind: email, call, screenshot, message, article, note, document |
| `date` | When created/received (ISO format: YYYY-MM-DD) |
| `description` | One-line description — this is what appears in the manifest index |

**Likely required:**

| Field | Description |
|-------|-------------|
| `source` | Who/where it came from (person name, website, app) |
| `tags` | Array of tags for searchability |

**Type-dependent (optional):**

| Field | Applies to | Description |
|-------|-----------|-------------|
| `from`, `to`, `subject` | email | Email metadata |
| `participants`, `duration` | call | Call metadata |
| `platform` | message | Source platform (Slack, iMessage, etc.) |
| `url` | article | Source URL |

### Non-Text Content Template

Non-text content (screenshots, videos, PDFs) follows the same pattern — summary `.md` at the type folder root, original file in `raw/`:

```
_references/screenshots/
├── 2026-02-06-competitor-landing.md          ← front matter + analysis + source pointer
└── raw/
    └── 2026-02-06-competitor-landing.png     ← original file
```

The summary `.md` uses the same structure with `## Analysis` instead of `## Summary`:

```markdown
---
type: screenshot
date: 2026-02-06
description: Competitor landing page showing new $49/mo pricing tier
source: competitor website
tags: [competitor, pricing]
---

## Analysis

[AI-generated detailed description of the visual content —
what's shown, key information, relevant observations.
Detailed enough that you rarely need to open the original file.]

## Source

`raw/2026-02-06-competitor-landing.png`
```

### File Naming Convention

Summary files and raw files share the same base name with different extensions:

| File | Pattern | Example |
|------|---------|---------|
| Summary | `YYYY-MM-DD-descriptive-name.md` | `emails/2026-02-06-globex-pilot-pricing.md` |
| Raw (text) | `YYYY-MM-DD-descriptive-name.txt` | `emails/raw/2026-02-06-globex-pilot-pricing.txt` |
| Raw (binary) | `YYYY-MM-DD-descriptive-name.ext` | `screenshots/raw/2026-02-06-competitor-landing.png` |

**Rename garbage filenames.** When source files have auto-generated or meaningless names (e.g. `CleanShot 2026-02-06 at 14.32.07@2x.png`, `IMG_4521.jpg`, `document (3).pdf`), rename them to the `YYYY-MM-DD-descriptive-name.ext` convention before storing. The summary `.md` and raw file should always share the same base name.

### Three-Tier Access

References are designed for efficient access without context bloat:

```
Tier 1: manifest.json        → "What references exist?" (always loaded)
Tier 2: Summary .md file      → "Tell me more about this one" (front matter + detailed AI summary)
Tier 3: raw/ file             → "Give me the original" (full text or binary, on demand)
```

The manifest holds a lightweight index. Summary `.md` files hold rich metadata and a detailed AI summary (usually sufficient). Raw files in `raw/` only load when the original content is specifically needed.

---

## Step 5: Extract to `_brain/` (If User Opted In)

**Only if the user chose extraction in Step 2.** Route extracted items to the appropriate `_brain/` files. Link back to the reference file where the extraction came from.

**Tasks → tasks.md**
```markdown
## To Do
- [ ] Send contract by Friday (from email 2026-02-06)
- [ ] Schedule kickoff call (from email 2026-02-06)
```

**Decisions → changelog.md**
```markdown
## 2026-02-06 — Context Captured

### Decisions
- **Globex pilot:** Moving forward with Feb 15 start. Budget $50k approved.

### Source
Email from Sarah Chen (Globex) → _references/emails/2026-02-06-globex-pilot-pricing.md
```

**Insights → insights.md**
```markdown
## 2026-02-06 — [Insight Title]

**Category:** [strategy | product | process | market]
**Learning:** The insight itself
**Evidence:** How we know this
**Applies to:** Where this matters
```

**Note:** If the insight is about how Claude operates or a technical pattern, offer to save to auto-memory instead of insights.md.

---

## Step 6: Handle People

For every person mentioned:

1. Check `02_Life/people/` for existing file
2. If found → update with new context, update "Last contact"
3. If not found → offer to create

**New person file:**
```markdown
# Sarah Chen

**Role:** CEO
**Company:** Globex
**Met:** 2026-02-06 (email)

---

## Context
- Discussing pilot program with acme
- Budget holder, approved $50k

## References
- 04_Ventures/acme (potential client)
```

**Existing person:**
```
Sarah Chen mentioned in this content.
Found: 02_Life/people/sarah-chen.md

Update with this context?
[1] Yes, update    [2] Skip
```

---

## Step 7: Confirm Done + Note Action

```
✓ Captured and routed to 04_Ventures/acme

Stored:
- Summary → _references/emails/2026-02-06-globex-pilot-pricing.md
- Raw     → _references/emails/raw/2026-02-06-globex-pilot-pricing.txt

Extracted:
- 2 tasks → _brain/tasks.md
- 1 decision → _brain/changelog.md
- 1 person → 02_Life/people/sarah-chen.md (updated)

─────────────────────────────────────────────────────────────────────────
Pending action: Write response to Sarah's email
```

If user chose "just store" (no extraction):
```
✓ Stored to 04_Ventures/acme

Stored:
- Summary → _references/emails/2026-02-06-globex-pilot-pricing.md
- Raw     → _references/emails/raw/2026-02-06-globex-pilot-pricing.txt
- 1 person → 02_Life/people/sarah-chen.md (updated)

─────────────────────────────────────────────────────────────────────────
Pending action: Write response to Sarah's email
```

**The pending action line only appears if the user selected an action in Step 2.** After the skill exits, proceed with the action.

**Manifest is updated later by `/alive:save`**, not by this skill. The save skill will detect new files in `_references/` and add them to the manifest's `references` array.

---

## Finished Artifacts vs Reference Material

Not everything goes to `_references/`. The distinction:

| Content | Where | Why |
|---------|-------|-----|
| Email, transcript, message | `_references/[type]/` (summary .md + raw/ original) | Source material — may need to re-read |
| Screenshot, video, PDF | `_references/[type]/` (analysis .md + raw/ original) | Visual/binary evidence with companion analysis |
| Quick thought, FYI, decision | `_brain/` only (or `_references/notes/` if substantial) | Often no source worth preserving separately |
| Spreadsheet, contract, final doc | Folder in unit | Finished artifact — belongs with its unit |

**The test:** Is this source material you might reference later? → `_references/`. Is this a finished file that belongs in the unit? → Folder. Is the meaning enough without the source? → `_brain/` only.

---

## No Active Unit

If no unit has been loaded with `/alive:work`:

```
[?] No active unit.

▸ scanning units for matches...
  └─ 04_Ventures/acme — "Globex" mentioned in status.md
  └─ 04_Ventures/beta — no match

Where does this belong?
[1] 04_Ventures/acme (suggested)
[2] 04_Ventures/beta
[3] 02_Life/[area]
[4] 03_Inputs/ (triage later)
```

---

## Ambiguous Content

When it's unclear what type something is or what the user wants:

```
"John mentioned we should reconsider the pricing"

This could be:
[1] Task — "Reconsider pricing"
[2] Insight — "Pricing concern raised by John"
[3] Decision context — Log for future decision

Which fits best?
```

---

## Fallbacks

**No manifest.json:**
```
▸ no manifest found, scanning folders...
  └─ Found: clients/, content/, _working/, _references/
```
Use actual folder structure for routing suggestions.

**No _references/ folder:**
```
▸ _references/ not found — creating it
  └─ Created _references/
```

**No 02_Life/people/ folder:**
```
▸ 02_Life/people/ not found
  └─ Offer to create with first person file
```

---

## Related Skills

- `/alive:save` — End full session (not mid-session capture)
- `/alive:digest` — Process items already IN `03_Inputs/`
- `/alive:work` — Load unit context first
