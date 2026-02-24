---
user-invocable: true
description: Process and route items from the 03_Inputs/ buffer to their correct locations across ALIVE. Use when the user says "process inputs", "digest", "triage", "handle inbox", "sort these", "what's in my inbox", or "anything to process".
plugin_version: "3.1.0"
---

# alive:digest

Process the 03_Inputs/ buffer. Survey items, triage with user, extract content, route to units.

## UI Treatment

Uses the **ALIVE Shell** — one rounded box, three zones.

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · digest                          [date]          │
│  [N] inputs  →  [N] extractions                      *   │
│  ──────────────────────────────────────────────────────  │
│  [Numbered extractions with icons and routing]           │
│  ──────────────────────────────────────────────────────  │
│  [ACTIONS]                                               │
│  [* extractions are generated — review before routing]   │
│  [routing distribution stats]                            │
╰──────────────────────────────────────────────────────────╯
```

**Skill-specific icons:** `◆` task, `◇` decision, `●` person, `◎` insight, `↳` plan, `→` routes to destination.

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## When to Use

Invoke when the user:
- Has items in `03_Inputs/` to process
- Wants to triage incoming content
- Needs to route captured content
- Says "process", "digest", "triage"

## Digest Principles

1. **User stays in control** — Never auto-process without confirmation
2. **Prioritize by importance** — Recent and urgent first
3. **Smart extraction** — Use appropriate agents for complex content
4. **Manifest-aware routing** — Route to existing areas when possible
5. **Never delete, always archive** — Processed files move to `01_Archive/{relevant unit}/{mirrored path}/...`, never deleted

## Flow (4 Steps)

```
STEP 1: Survey Inputs   → See what's there, prioritize
STEP 2: User Selection  → Pick what to digest now
STEP 3: Per-Item Triage → Decide how to handle each
STEP 4: Execute         → Route and extract
```

## Step 1: Survey Inputs

Scan `03_Inputs/` and present prioritized list:

```
╭──────────────────────────────────────────────────────────╮
│                                                          │
│  ALIVE · digest                           2026-02-09     │
│  5 inputs  →  scanning...                             *  │
│                                                          │
│  ──────────────────────────────────────────────────────  │
│                                                          │
│   1) client-email.md         Email       Today       !   │
│   2) call-transcript.md      Transcript  2 days ago      │
│   3) quick-note.md           Note        3 days ago      │
│   4) meeting-recording.m4a   Audio       1 week ago      │
│   5) random-thoughts.md      Note        1 week ago      │
│                                                          │
│  ──────────────────────────────────────────────────────  │
│                                                          │
│  a) digest all              #) select items              │
│  q) quit                                                 │
│                                                          │
╰──────────────────────────────────────────────────────────╯
```

### Priority Signals

| Signal | Priority |
|--------|----------|
| Today's date | 🔥 High |
| Client/business related | 🔥 High |
| Within 3 days | Medium |
| Over 1 week | Low |
| Audio/video (needs processing) | Flag |

## Step 2: User Selection

User picks which items to process:

```
> 1, 2

Selected:
[1] client-email-acme.md
[2] call-transcript-01-22.md

Proceed with these 2 items?
[1] Yes
[2] Add more
[3] Different selection
```

## Step 3: Per-Item Triage

Go through each selected item:

### Simple Item (Email/Note)

```
▸ [1/2] client-email-acme.md

Type: Email from client
Content: Request for project update + new feature ask
Detected:
  - 1 task (send update)
  - 1 reference (feature request)

Approach:
[1] Quick route — Add task, file email
[2] Extract details — Full breakdown
[3] Skip for now
```

### Complex Item (Transcript)

```
▸ [2/2] call-transcript-01-22.md

Type: Call transcript (~45 min)
Detected:
  - 3 people mentioned
  - Multiple topics discussed
  - Several action items

This needs deeper extraction.

Approach:
[1] Full extraction — Spawn transcript agent
[2] Summary only — Quick overview
[3] Manual — Review and route myself
[4] Skip for now
```

## Step 4: Execute

### Quick Route

For simple items:
```
▸ processing client-email-acme.md

Adding task to 04_Ventures/acme/_brain/tasks.md:
  - [ ] Send project update to client @urgent

Storing email:
  Summary → 04_Ventures/acme/_references/emails/2026-02-06-client-update-request.md
  Raw     → 04_Ventures/acme/_references/emails/raw/2026-02-06-client-update-request.txt

Archiving source: 03_Inputs/client-email-acme.md → 01_Archive/03_Inputs/

✓ Done
```

### Full Extraction (Complex Item Analyser)

For complex items, first determine the content type, then spawn a specialised agent with type-appropriate extraction instructions.

**Step 1: Identify the content type.** Read the file (or check extension for binary). Classify as one of:

| Type | Signals | Example |
|------|---------|---------|
| `transcript` | Long text, multiple speakers, timestamps | Meeting recordings, call notes |
| `email-thread` | Multiple replies, forwarded chains, headers | Long email conversations |
| `screenshot` | Image file (.png, .jpg, .webp) | UI captures, competitor pages, whiteboard photos |
| `document` | PDF, structured text, formal sections | Contracts, reports, specs |
| `voice-note` | Audio file or voice-to-text dump | Quick captures, rambling thoughts |
| `video` | Video file or video transcript | Loom recordings, screen captures |
| `mixed` | Multiple content types in one file | Email with attachments, doc with screenshots |

**Step 2: Build the agent prompt based on type.**

Each type needs different extraction priorities:

**Transcript / Call / Meeting:**
```
Focus on: decisions made, action items with owners, disagreements/tensions,
commitments with deadlines, who said what (attribute quotes), topics discussed
(in order), follow-up meetings mentioned, anything someone said they'd "send"
or "share" or "check on."
```

**Email Thread:**
```
Focus on: the latest request/question (not the full history), any decisions
confirmed via email, attachments mentioned (what are they, where should they
go), deadlines or dates mentioned, tone/urgency level, whether a reply is
expected and by when.
```

**Screenshot / Image:**
```
Focus on: what is shown (describe in detail), any text visible in the image,
UI state or data displayed, what the user likely wanted to capture and why,
competitive intelligence if it's a competitor screenshot, any numbers/metrics
visible.
```

**Document / PDF:**
```
Focus on: key terms and conditions, important dates/deadlines, financial
figures, obligations or commitments, who the parties are, what action is
required from the user, anything that contradicts or updates existing context.
```

**Voice Note:**
```
Focus on: the core idea (voice notes often ramble — find the signal), any
decisions or commitments stated, emotional tone (frustrated? excited? worried?),
tasks the speaker assigned to themselves ("I need to..." / "I should..."),
references to other projects or people.
```

**Video:**
```
Focus on: what was demonstrated or shown, key timestamps for important moments,
any spoken decisions or action items, screen content visible (URLs, data,
UI states), the purpose of the recording.
```

**Step 3: Launch the agent.** Include the type-specific extraction focus above PLUS the target unit path and standard ALIVE extraction categories (decisions, tasks, insights, people, key quotes, references).

**Step 4: Present results** in the ALIVE shell format (see `rules/ui-standards.md`). User confirms routing before any changes are made.

## Routing Logic

### Check Manifest First

Before routing, check if unit has an area for the content:

```
▸ checking 04_Ventures/acme/_brain/manifest.json

Areas found:
  - clients/ → for client content
  - _references/ → for source material

Route transcript to: 04_Ventures/acme/_references/calls/2026-01-22-partner-sync.md
```

### Routing Destinations

**Extracted content** routes to `_brain/`:

| Extraction | Destination |
|------------|-------------|
| Decision | `_brain/changelog.md` |
| Task | `_brain/tasks.md` |
| Insight (domain knowledge) | `_brain/insights.md` |
| Person info | `02_Life/people/[name].md` |

### Source File Routing

After extraction, the **source file** needs to be stored. Default is `_references/` — the same format used by `/alive:capture`.

Every reference creates two files: a **summary `.md`** at the type folder root, and the **original content** in a `raw/` subfolder. The summary should be detailed enough that you rarely need the raw file.

**Text-based source files** (emails, transcripts, notes, messages) → create a summary `.md` with YAML front matter + detailed AI summary + source pointer, and store the original text in `raw/`:

```markdown
---
type: email
date: 2026-02-06
description: Client requests project update and asks about new feature
source: John Smith (Acme Corp)
tags: [client, update-request, feature]
subject: Re: Project status
from: john@acme.com
to: team@company.com
---

## Summary

John is requesting a project status update by end of week. He also
raises a new feature request for bulk export functionality. He mentions
the board meeting is next Tuesday and needs numbers to present.

### Key Points
- Status update needed by Friday
- New feature request: bulk export
- Board meeting Tuesday — needs metrics

### Action Items
- Send project update by Friday
- Respond to bulk export feature request

## Source

`raw/2026-02-06-client-update-request.txt`
```

File naming: summary `.md` and raw file share the same base name, using `YYYY-MM-DD-descriptive-name` convention.
Subfolder: dynamic based on content type (`emails/`, `calls/`, `meeting-transcripts/`, `messages/`, `notes/`, `articles/`)

**Rename garbage filenames.** When source files have auto-generated or meaningless names (e.g. `CleanShot 2026-02-06 at 14.32.07@2x.png`, `IMG_4521.jpg`, `document (3).pdf`), rename them to the `YYYY-MM-DD-descriptive-name.ext` convention before storing.

```
_references/emails/2026-02-06-client-update-request.md        ← summary
_references/emails/raw/2026-02-06-client-update-request.txt   ← raw original
_references/calls/2026-01-22-partner-sync.md                  ← summary
_references/calls/raw/2026-01-22-partner-sync.txt             ← raw original
```

**Non-text source files** (screenshots, PDFs, audio) → same pattern. Summary `.md` at type root, original in `raw/`:

```
_references/documents/2026-02-06-contract-scan.md             ← summary with analysis
_references/documents/raw/2026-02-06-contract-scan.pdf        ← original file
```

The summary `.md` uses `## Analysis` instead of `## Summary` and points to the raw file:

```markdown
---
type: document
date: 2026-02-06
description: Scanned contract with Globex, 12-month term, $50k value
source: Legal team
tags: [contract, globex]
---

## Analysis

[AI-generated description of the document contents,
key terms, important clauses, relevant observations.
Detailed enough that you rarely need to open the original.]

## Source

`raw/2026-02-06-contract-scan.pdf`
```

**Finished artifacts** (spreadsheets, contracts, final documents) → these aren't references, they're unit files. Route to the appropriate folder in the unit:

```
04_Ventures/acme/clients/globex/contract-v1.pdf
04_Ventures/acme/financials/q1-budget.xlsx
```

**The test:** Is this source material you might reference later? → `_references/`. Is this a finished file that belongs in a unit? → Folder.

**After routing, archive the original from inputs:**
```
mv 03_Inputs/client-email-acme.md → 01_Archive/03_Inputs/client-email-acme.md
```

## Multimodal Support

### Audio Files

```
[!] meeting-recording.m4a is an audio file.

This needs transcription before processing.

[1] Transcribe and process (may take time)
[2] Skip for now
[3] Just file without extraction
```

### Images/PDFs

```
[!] contract-scan.pdf detected.

[1] Extract text and summarize
[2] Just file with description
[3] Skip
```

## Extraction Agents

For complex items, use specialized prompts:

### Transcript Agent

Extracts:
- People mentioned (with roles)
- Decisions made
- Action items
- Insights (domain knowledge)
- Key topics discussed

### Email Agent

Extracts:
- Sender/recipients
- Action items
- Commitments made
- Follow-up needed

### Document Agent

Extracts:
- Summary
- Key points
- Related topics
- Routing suggestion

## Edge Cases

**Empty inputs:**
```
▸ scanning 03_Inputs/

Inputs is empty. Nothing to process.

[c] Capture something new
[b] Back
```

**Ambiguous routing:**
```
This transcript mentions both acme and beta projects.

Route extractions to:
[1] Both units
[2] Just acme
[3] Just beta
[4] Let me specify for each item
```

**Large batch:**
```
Inputs has 23 items.

Process:
[1] All items (may take time)
[2] Today's items only (3)
[3] Select specific items
[4] Oldest first (clear backlog)
```

## After Digest

```
✓ Digest complete

Processed: 2 items
Created: 1 person file
Added: 6 tasks
Logged: 2 decisions
Filed: 2 source files

03_Inputs remaining: 3 items
```

## Related Skills

- `/alive:capture` — Capture and route content into ALIVE
- `/alive:work` — Work on unit after digest
- `/alive:daily` — Shows inputs count, links here
