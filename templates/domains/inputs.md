# Inputs Domain Template

**Domain:** 03_Inputs/
**Purpose:** Universal input, triage point

---

## Structure

```
03_Inputs/
├── [file.md]         # Raw captures, notes, dumps
├── [transcript.md]   # Call/meeting transcripts
├── [document.pdf]    # Documents to process
└── ...               # Anything to be triaged
```

---

## What Goes in Inputs

**Everything that needs processing.**

- Quick notes dumped for later
- Transcripts from calls/meetings
- Documents to review
- Ideas captured on the go
- Forwarded content
- Anything you don't have time to sort now

---

## Inputs Principles

1. **Zero friction** — Dump anything here, sort later
2. **Temporary** — Items move out, inputs stays clear
3. **Process regularly** — Use `/alive:digest` to triage
4. **Nothing permanent** — Inputs is a buffer, not storage

---

## Processing Flow

```
CAPTURE  →  INPUTS  →  DIGEST  →  DESTINATION
   ↓          ↓          ↓           ↓
 Quick      Buffer    Extract    _brain/ or
 grab       zone      & route    folder
```

---

## Using /alive:digest

Process inputs with the digest skill:

```
/alive:digest
```

This will:
1. Survey inputs items (prioritized)
2. Let you select what to process
3. Triage each item (quick route vs full extraction)
4. Route content to destinations
5. Archive or delete source files

---

## Item Types

| Type | Processing | Destination |
|------|------------|-------------|
| Quick note | Extract action items | tasks.md, _working/ |
| Transcript | Full extraction (agent) | changelog.md, tasks.md, people/ |
| Document | Summarize, file | Folder, manifest |
| Email | Extract tasks, file | tasks.md, folder |
| Idea | Capture as domain knowledge | insights.md, _working/ |

---

## Naming Convention

No strict naming required — this is a dump zone.

Helpful patterns:
- `YYYY-MM-DD-topic.md` — Dated items
- `call-with-[name].md` — Call transcripts
- `quick-note.md` — Temporary notes

---

## Best Practices

### Daily Triage

Process inputs daily or every few days. Don't let it become a graveyard.

### Zero Inputs Goal

Aim for empty inputs. Everything should move to:
- A unit's `_brain/` or area
- `01_Archive/03_Inputs/` if ephemeral
- Deleted if worthless

### Quick Capture

When capturing, don't overthink:
```
"Just dump it in inputs, sort later."
```

Better to capture imperfectly than to lose context.

---

## After Processing

Processed items go to:
- **Relevant area** — If content belongs somewhere specific
- **01_Archive/03_Inputs/** — If ephemeral but worth keeping
- **Deleted** — If temporary and worthless

---

## Notes

- Inputs is for triage, not storage
- Process regularly to avoid overwhelm
- Use `/alive:digest` for guided processing
- When in doubt, capture to inputs and sort later
