# UI Standards

Visual specs for ALIVE skill output. Loaded on demand by skills.

## Tier System

| Tier | Skills | Logo | Footer |
|------|--------|------|--------|
| **1: Entry Points** | `onboarding`, `daily` | Full (24-line elephant + wordmark) | Community |
| **2: Core Workflow** | `work`, `save`, `help` | Compact (4-line elephant) | Community |
| **3: Utility** | All others | Compact (4-line elephant) | Version |

## The ALIVE Shell

Every skill output wraps in a rounded box with three zones (header, content, footer):

```
╭──────────────────────────────────────────────────────────╮
│  HEADER — skill name, date, aggregate stats               │
│  ──────────────────────────────────────────────────────── │
│  CONTENT — the main skill output                          │
│  ──────────────────────────────────────────────────────── │
│  FOOTER — actions, fine print, community/version          │
╰──────────────────────────────────────────────────────────╯
```

- `╭╮╰╯` rounded corners (outer frame only), `│` vertical sides, `─` horizontal separators
- NO double-line borders (`╔╗╚╝═║`) — **deprecated**
- NO internal boxes or nested borders
- Width fits terminal naturally — no fixed char target

## Small Elephant (Tier 2 & 3)

```
   ______/ \-.   _
.-/     (    o\_//
 |  ___  \_/\---'
 |_||  |_||
```

### Tier 2/3 Header Layout

Elephant left, FIGlet skill name right (`small` font, 4 lines). Version + unit path below:

```
│    ______/ \-.   _     __      _____  ___ _  __              │
│ .-/     (    o\_//     \ \    / / _ \| _ \ |/ /              │
│  |  ___  \_/\---'       \ \/\/ / (_) |   / ' <              │
│  |_||  |_||              \_/\_/ \___/|_|_\_|\_\              │
│                          aliveOS [Unlimited Elephant 3.1.0]   │
│                          ventures/acme-agency                 │
```

## Footers

- **Community (Tier 1 & 2):** `Free: Join the ALIVE community → skool.com/aliveoperators`
- **Version (Tier 3):** `ALIVE v3.1.0` right-aligned

## Themes

User preference in `alive.local.yaml` (`theme: vibrant | minimal | loud`):

| Theme | Header | Retrieval Paths | Separators | Symbols |
|-------|--------|-----------------|------------|---------|
| **Vibrant** (default) | Full ASCII | Always shown | Full-width lines | Unicode (`✓ ✗ → •`) |
| **Minimal** | Simple text | Hidden unless error | Short `---` | Simple text |
| **Loud** | Emoji-enhanced | Shown with emojis | Emoji dividers | Emojis |

## Symbols

| Symbol | Meaning |
|--------|---------|
| `✓` | Success, done |
| `✗` | Failed, blocked |
| `→` | Next, leads to |
| `•` | Separator |
| `▸` | Actionable item |
| `[!]` | Attention needed, stale |
| `[OK]` | Current, fresh |
| `[?]` | Unknown, not loaded |

## Retrieval Paths

```
▸ reading path/to/file.md
  └─ Key finding
```

## Confirmations

```
✓ Saved to path/file.md                          # success
✗ Cannot find: [name]                             # error
  └─ Check ventures/ folder
[!] file.md is 3 weeks old                        # warning
    └─ May need refresh
```

## Date Format

Changelog: `## 2026-01-23 — Session Summary` (em dash). ISO dates everywhere else.
