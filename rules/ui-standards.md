# UI Standards

Themes, symbols, and output formatting for ALIVE.

---

## Visual Identity System

**All ALIVE skills use a consistent visual wrapper** that distinguishes them from regular Claude responses. This creates a strong brand presence and makes it immediately clear when you're using ALIVE.

### Tier System

Every skill belongs to a tier that determines its visual treatment:

| Tier | Skills | Logo | Border | Footer |
|------|--------|------|--------|--------|
| **1: Entry Points** | `onboarding`, `daily` | Full (24-line) | Rounded shell | Community |
| **2: Core Workflow** | `work`, `save`, `help` | Compact (4-line) | Rounded shell | Community |
| **3: Utility** | All others | Compact (4-line) | Rounded shell | Version |

### The ALIVE Shell

Every skill output is wrapped in a single rounded box with three zones:

```
╭──────────────────────────────────────────────────────────╮
│  HEADER — skill name, date, aggregate stats               │
│  ──────────────────────────────────────────────────────── │
│  CONTENT — the main skill output                          │
│  ──────────────────────────────────────────────────────── │
│  FOOTER — actions, fine print, community/version          │
╰──────────────────────────────────────────────────────────╯
```

**Characters:**
- `╭╮╰╯` rounded corners — outer frame only
- `│` vertical sides
- `─` horizontal separators (thin lines between zones)
- NO double-line borders (`╔╗╚╝═║`) — these are **deprecated**
- NO internal boxes or nested borders

**Width:** Fits terminal naturally — no fixed 90-char target.

**Conventions inside the shell:**
- `*` on AI-generated content (explained in fine print)
- `)` on every selectable option (e.g. `1)`, `a)`)
- `·` as delimiter in stats
- `●○` five-day activity dots
- **!** attention indicator
- Lowercase section labels

---

## Logo & Mascot Assets

### Release: Unlimited Elephant

**Codename:** Unlimited Elephant — "Elephants never forget"
**Version:** 3.1.0

### Large Elephant (Tier 1 — Onboarding, Boot Screen, First Daily)

Used by: `onboarding` (boot screen), first-ever `/alive:daily`
Source: Beate Schwichtenberg

```
                     .. ..oooo.....ooo...
               .odSS4PYYYSSOOXXXXXXXXXOodbgooo.
              /SSYod$$SSOIIPXXXXXXXXXYYP.oo.*b.
             ($Yd$$SSSOII:XXXXXXXX:IIoSSS$$b.Y,
              \Yd$$SSSOII:XXXXXXXXXX:IIOOSSS$$b\
               d$$SSSOOI:XP"YXXXXXXXX:IIOOSSSS$$\
               Y$$SSSOOII:XbdXXXXXP"YX:IIOOOSS$$)
               'Y$$SSSOI:XXXXXXXXXbodX:IIOOSS$$$/
                "Y$$SSSOI(PoTXXXXXTo)XXIIOOOSS$$*'
                  ""*Y$S(((PXXXXXXXY))dIIOSSS$dP'
                     "*'()P;XXXXXXXXY)IIOSSS$P".oS,
                     (S'(P;XXXXXXXP;Y)XXYOP".oSSSSb
                    (S'(P;'XXXXXXX';Y).ooooSSSSSSSS)
                    (S'(P;'XXXXXXP';Y).oSSSSSSSSSSSP
                    (SS'Y);YXXXXX';(Y.oSSSSSSSSSSSSP
                     YSS'Y)'YXXX".(Y.oSSP.SSSSSSSSY
                      YSS'"" XXX""oooSSP.SSSSSSSSY
                      SSSSSS YXXX:SSSSP.SSSSSSSSY
                      SSSSSP  YXb:SSSP.S"SSSSSSP
                      S(OO)S   YXb:SY    )SSSSS
                      SSSSO    )YXb.I    ISSSSP
                      YSSSY    I."YXXb   Y(SS)I
                      )SSS(    dSSo.""*b  YSSSY
                      OooSb   dSSSSP      )SSS(
                              dSSSY       OooSS
                              OooSP
```

### ALIVE Wordmark (Roman FIGlet)

Used with: Large elephant (below it), boot screen
Font: `roman` via FIGlet — 64 chars wide

```
      .o.       ooooo        ooooo oooooo     oooo oooooooooooo
     .888.      `888'        `888'  `888.     .8'  `888'     `8
    .8"888.      888          888    `888.   .8'    888
   .8' `888.     888          888     `888. .8'     888oooo8
  .88ooo8888.    888          888      `888.8'      888    "
 .8'     `888.   888       o  888       `888'       888       o
o88o     o8888o o888ooooood8 o888o       `8'       o888ooooood8
──────────────────────────────────────────────────────────────────
                    O p e r a t o r   S y s t e m
──────────────────────────────────────────────────────────────────
```

### Small Elephant (Tier 2 & 3 — All Regular Skills)

Used by: All skill responses alongside the compact ALIVE text

```
   ______/ \-.   _
.-/     (    o\_//
 |  ___  \_/\---'
 |_||  |_||
```

### Large Elephant Pair (Help Screen)

Used by: `/alive:help` only

```
  {\{\       ,                                             /}/}
  { \ \.--.  \\                                 ,         / / }
  {  /` , "\_//                                 \\   .-=.( (   }
  {  \__\ ,--'                                   \'--"   `\\_.---,='
   {_/   _ ;-.                                    '-,  \__/       \___
    /  '.___/                                      .-'.-.'      \___.'
    |  __ /                                       / // /-..___,-`--'
  `=\    \`\                                      `" `"
     `/  / /
      '././
```

### Usage Guidelines

| Asset | When to use |
|-------|-------------|
| Large elephant + wordmark | Onboarding boot screen, first-ever `/alive:daily` |
| Small elephant + big skill name | All regular skill responses (Tier 2 & 3 headers) |
| Compact text only | Minimal theme, or when space is tight |
| Elephant pair | `/alive:help` only |
| Boot screen (full) | First run of onboarding only — see `branding/alive-os-boot-screen.txt` |

### Skill Name Font (FIGlet `small`)

Render skill names using FIGlet `small` font. 4 lines tall — matches elephant height. Pre-rendered for all skills:

```
WORK:
__      _____  ___ _  __
\ \    / / _ \| _ \ |/ /
 \ \/\/ / (_) |   / ' <
  \_/\_/ \___/|_|_\_|\_\

SAVE:
 ___   ___   _____
/ __| /_\ \ / / __|
\__ \/ _ \ V /| _|
|___/_/ \_\_/ |___|

DAILY:
 ___   _   ___ _ __   __
|   \ /_\ |_ _| |\ \ / /
| |) / _ \ | || |_\ V /
|___/_/ \_\___|____|_|

CAPTURE:
  ___   _   ___ _____ _   _ ___ ___
 / __| /_\ | _ \_   _| | | | _ \ __|
| (__ / _ \|  _/ | | | |_| |   / _|
 \___/_/ \_\_|   |_|  \___/|_|_\___|

RECALL:
 ___ ___ ___   _   _    _
| _ \ __/ __| /_\ | |  | |
|   / _| (__ / _ \| |__| |__
|_|_\___\___/_/ \_\____|____|

MIGRATE:
 __  __ ___ ___ ___    _ _____ ___
|  \/  |_ _/ __| _ \  /_\_   _| __|
| |\/| || | (_ |   / / _ \| | | _|
|_|  |_|___\___|_|_\/_/ \_\_| |___|

ARCHIVE:
   _   ___  ___ _  _ _____   _____
  /_\ | _ \/ __| || |_ _\ \ / / __|
 / _ \|   / (__| __ || | \ V /| _|
/_/ \_\_|_\\___|_||_|___| \_/ |___|

DIGEST:
 ___ ___ ___ ___ ___ _____
|   \_ _/ __| __/ __|_   _|
| |) | | (_ | _|\__ \ | |
|___/___\___|___|___/ |_|

SWEEP:
 _____      _____ ___ ___
/ __\ \    / / __| __| _ \
\__ \\ \/\/ /| _|| _||  _/
|___/ \_/\_/ |___|___|_|

HELP:
 _  _ ___ _    ___
| || | __| |  | _ \
| __ | _|| |__|  _/
|_||_|___|____|_|

NEW:
 _  _ _____      __
| \| | __\ \    / /
| .` | _| \ \/\/ /
|_|\_|___| \_/\_/

REVIVE:
 ___ _____   _______   _____
| _ \ __\ \ / /_ _\ \ / / __|
|   / _| \ V / | | \ V /| _|
|_|_\___| \_/ |___| \_/ |___|

SCAN:
 ___  ___   _   _  _
/ __|/ __| /_\ | \| |
\__ \ (__ / _ \| .` |
|___/\___/_/ \_\_|\_|

UPGRADE:
 _   _ ___  ___ ___    _   ___  ___
| | | | _ \/ __| _ \  /_\ |   \| __|
| |_| |  _/ (_ |   / / _ \| |) | _|
 \___/|_|  \___|_|_\/_/ \_\___/|___|

HANDOFF:
 _  _   _   _  _ ___   ___  ___ ___
| || | /_\ | \| |   \ / _ \| __| __|
| __ |/ _ \| .` | |) | (_) | _|| _|
|_||_/_/ \_\_|\_|___/ \___/|_| |_|
```

### Tier 2/3 Header Layout

Elephant (4 lines) sits left. FIGlet skill name (4 lines) sits right. Version and unit path below.

```
│    ______/ \-.   _     __      _____  ___ _  __              │
│ .-/     (    o\_//     \ \    / / _ \| _ \ |/ /              │
│  |  ___  \_/\---'       \ \/\/ / (_) |   / ' <              │
│  |_||  |_||              \_/\_/ \___/|_|_\_|\_\              │
│                          aliveOS [Unlimited Elephant 3.1.0]   │
│                          ventures/acme-agency                 │
```

Elephant on left, skill name big on right. Version and unit path below, aligned with skill name start column.

### Embellishment Characters

| Character | Usage |
|-----------|-------|
| `◊` (lozenge) | Section divider in boot screen / splash |
| `·` (middle dot) | Lighter separator within sections |

---

## Footer Variants

### Community Footer (Tier 1 & 2)

Used by: `onboarding`, `daily`, `work`, `save`, `help`

```
│  ──────────────────────────────────────────────────────────────────── │
│  Free: Join the ALIVE community → skool.com/aliveoperators            │
╰──────────────────────────────────────────────────────────────────────╯
```

### Version Footer (Tier 3)

Used by: All other skills

```
│  ──────────────────────────────────────────────────────────────────── │
│                                                        ALIVE v3.1.0   │
╰──────────────────────────────────────────────────────────────────────╯
```

---

## Column Layouts

Use columns where it improves information density. The vertical pipe `│` separates columns.

### Status + Tasks (for `/alive:work`)

```
│  STATUS                          │  TASKS                                │
│  ────────────────────────────────│────────────────────────────────────── │
│  Phase: Plugin Development       │  1) Test fresh install flow           │
│  Focus: v2 feedback complete     │  2) Create PR staging → main          │
│                                  │  3) Create alive:brainstorm skill     │
│  Blockers: None                  │  4) ALIVE for developers/codebases    │
│                                  │  5) Improve /alive:sweep              │
│  Next: PR to main                │  6) Review all rules in plugin        │
```

### Unit Grid (for `/alive:daily`)

```
│  ventures                        │  experiments                          │
│  ────────────────────────────────│────────────────────────────────────── │
│  1) acme-agency    Building      │  4) cricket-grid    Paused !          │
│  2) apex           Growing       │  5) new-idea        Starting          │
│  3) side-hustle     Ready         │                                       │
```

---

## Full Examples by Tier

### Tier 1 Example: `/alive:daily`

The elephant + ROMAN wordmark render as raw text ABOVE the shell (not inside borders):

```
                     .. ..oooo.....ooo...
               .odSS4PYYYSSOOXXXXXXXXXOodbgooo.
              /SSYod$$SSOIIPXXXXXXXXXYYP.oo.*b.
             ...
              OooSP

      .o.       ooooo        ooooo oooooo     oooo oooooooooooo
     .888.      `888'        `888'  `888.     .8'  `888'     `8
    ...
o88o     o8888o o888ooooood8 o888o       `8'       o888ooooood8
──────────────────────────────────────────────────────────────────
                    O p e r a t o r   S y s t e m
──────────────────────────────────────────────────────────────────

╭──────────────────────────────────────────────────────────────────────╮
│  ALIVE · daily                                     tue 11 feb 2026   │
│  3 ventures · 2 experiments · 7 inputs                               │
│  ──────────────────────────────────────────────────────────────────── │
│                                                                       │
│  * Focus on skeyndor — 3 urgent tasks, highest revenue potential      │
│                                                                       │
│  ventures                        │  experiments                       │
│  ────────────────────────────────│─────────────────────────────────── │
│  1) acme-agency    Building      │  3) cricket-grid    Paused !       │
│  2) apex           Growing       │                                    │
│                                                                       │
│  inputs                                                               │
│  ! 2 items pending triage                                             │
│                                                                       │
│  ──────────────────────────────────────────────────────────────────── │
│  #) pick number    i) process inputs    n) new                        │
│  * generated recommendation — verify before acting                    │
│  Free: Join the ALIVE community → skool.com/aliveoperators            │
╰──────────────────────────────────────────────────────────────────────╯
```

### Tier 2 Example: `/alive:work`

```
╭──────────────────────────────────────────────────────────────────────╮
│    ______/ \-.   _     __      _____  ___ _  __                       │
│ .-/     (    o\_//     \ \    / / _ \| _ \ |/ /                       │
│  |  ___  \_/\---'       \ \/\/ / (_) |   / ' <                       │
│  |_||  |_||              \_/\_/ \___/|_|_\_|\_\                       │
│                          aliveOS [Unlimited Elephant 3.1.0]            │
│                          ventures/acme-agency                          │
│  ──────────────────────────────────────────────────────────────────── │
│                                                                       │
│  ▸ reading _brain/status.md                                           │
│    └─ Phase: Plugin Development (updated yesterday)                   │
│                                                                       │
│  ▸ reading _brain/tasks.md                                            │
│    └─ 33 tasks, ~26 open                                              │
│                                                                       │
│  STATUS                          │  TASKS                             │
│  ────────────────────────────────│─────────────────────────────────── │
│  Phase: Plugin Development       │  1) Test fresh install flow        │
│  Focus: v2 feedback complete     │  2) Create PR staging → main       │
│                                  │  3) Create alive:brainstorm skill  │
│  Blockers: None                  │  4) ALIVE for developers/codebases │
│                                  │  5) Improve /alive:sweep           │
│  Next: PR to main                │  6) Review all rules in plugin     │
│                                                                       │
│  ──────────────────────────────────────────────────────────────────── │
│  #) pick task    c) changelog    s) save                              │
│  Free: Join the ALIVE community → skool.com/aliveoperators            │
╰──────────────────────────────────────────────────────────────────────╯
```

### Tier 3 Example: `/alive:capture`

```
╭──────────────────────────────────────────────────────────────────────╮
│    ______/ \-.   _       ___   _   ___ _____ _   _ ___ ___            │
│ .-/     (    o\_//      / __| /_\ | _ \_   _| | | | _ \ __|           │
│  |  ___  \_/\---'      | (__ / _ \|  _/ | | | |_| |   / _|           │
│  |_||  |_||             \___/_/ \_\_|   |_|  \___/|_|_\___|           │
│                         aliveOS [Unlimited Elephant 3.1.0]             │
│                         ventures/acme-agency                           │
│  ──────────────────────────────────────────────────────────────────── │
│                                                                       │
│  ▸ capturing to ventures/acme-agency/_brain/changelog.md              │
│                                                                       │
│  ✓ Captured: "Decided to use rounded borders for all skill outputs"   │
│                                                                       │
│  ──────────────────────────────────────────────────────────────────── │
│                                                        ALIVE v3.1.0   │
╰──────────────────────────────────────────────────────────────────────╯
```

---

## Themes

The Visual Identity System works **alongside** themes. Themes control styling within the border:

User preference stored in `alive.local.yaml`:

```yaml
theme: vibrant  # vibrant | minimal | loud
```

Read this file at session start to determine output style.

---

## Theme: Vibrant (Default)

Full visual experience. ASCII art, box drawing, retrieval paths.

**Dashboard header:** Full ASCII logo
**Skill headers:** Box-drawn `╭─ ALIVE ───╮` style
**Retrieval paths:** Always shown (`▸ scanning...`)
**Separators:** Full-width lines
**Symbols:** Unicode (✓ ✗ → •)

---

## Theme: Minimal

Clean output. No ASCII art, shorter lines. Saves context window.

**Dashboard header:** Simple `ALIVE v3.1.0`
**Skill headers:** Markdown `## Ventures`
**Retrieval paths:** Hidden unless error
**Separators:** Short `---`
**Symbols:** Simple text

---

## Theme: Loud

ADHD-friendly. Emojis, emphasis, maximum clarity.

**Dashboard header:** Emoji-enhanced
**Skill headers:** Emoji prefix
**Retrieval paths:** Shown with emojis
**Separators:** Emoji dividers
**Symbols:** Emojis (see glossary)

---

## Emoji Glossary (Loud Theme)

| Emoji | Meaning |
|-------|---------|
| ✅ | Done, success |
| ❌ | Failed |
| 🚫 | Blocked |
| 🔥 | Urgent, priority |
| 👀 | Attention needed |
| 🎯 | Current focus |
| 💡 | Insight |
| 📝 | Task |
| 🤝 | Decision |
| 👤 | Person |
| 📅 | Event, date |

---

## Symbols (Vibrant/Minimal)

| Symbol | Meaning |
|--------|---------|
| `✓` | Success, done |
| `✗` | Failed, blocked |
| `→` | Next, leads to |
| `•` | Separator |
| `▸` | Actionable item |
| `┃` | Vertical connector |
| `[!]` | Attention needed, stale |
| `[OK]` | Current, fresh |
| `[?]` | Unknown, not loaded |

---

## Chinese Menu

**Everything actionable gets a number.** Not just footer — every item on screen.

```
VENTURES
─────────────────────────────────────────────────────────────────────────
[1] acme                Building                 7 tasks
[2] beta                Paused                   [!] stale
[3] gamma               Starting                 0 tasks

─────────────────────────────────────────────────────────────────────────
[n] new venture    [s] search    [b] back

Pick a number or command:
```

User can say `1` or `acme` or `new` or `n`.

---

## Retrieval Paths

Show what you're accessing. Make the system visible.

```
▸ scanning ventures/
  └─ acme/_brain/status.md      Building
  └─ beta/_brain/status.md      Paused [!]

▸ reading ventures/acme/_brain/tasks.md
  └─ 7 tasks, 2 @urgent
```

When searching:
```
▸ searching "contract"...
  └─ ventures/acme/clients/globex/contract.md    ✓ match
  └─ _brain/changelog.md                         2 mentions
```

---

## Status Lines

Fixed-width columns for alignment (vibrant theme):

```
[#] [Name 20ch]         [Status 24ch]           [Flag]
```

**Example:**
```
[1] acme                Building                 7 tasks
[2] beta                Paused                   [!] stale
```

---

## Box Drawing

Characters for the ALIVE Shell (vibrant theme):

```
╭─────────────────────────────────────────────────────────────╮
│  Content here                                               │
├─────────────────────────────────────────────────────────────┤
│  Section two                                                │
╰─────────────────────────────────────────────────────────────╯
```

Characters: `╭ ╮ ╰ ╯ │ ─ ├ ┤ ┬ ┴ ┼`

---

## Confirmations

**Success:**
```
✓ Saved to ventures/acme/_brain/changelog.md
```

**Error:**
```
✗ Cannot find venture: [name]
  └─ Check ventures/ folder
```

**Warning:**
```
[!] ventures/beta/_brain/status.md is 3 weeks old
    └─ May need refresh
```

---

## Date Format

Use em dash separator in changelog:

```markdown
## 2026-01-23 — Session Summary
```

ISO dates everywhere else: `2026-01-23`
