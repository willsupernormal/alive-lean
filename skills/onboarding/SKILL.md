---
user-invocable: true
description: First-time setup wizard for new ALIVE users. Creates the full system from scratch — folders, rules, configuration, and first ventures, experiments, and life areas. Use when the user says "set up ALIVE", "get started", "initialize", or when no ALIVE structure exists.
plugin_version: "3.1.0"
---

# alive:onboarding

First-time setup wizard for aliveOS. Guides new users through complete configuration in two sessions: system setup first, then content setup after Claude reloads rules.

**Different from `/alive:upgrade`:** Onboarding is fresh setup. Upgrade migrates v1 → v2.

## When to Use

Invoke when:
- User is new to ALIVE
- User asks how to get started
- `alive.local.yaml` doesn't exist (new user)
- `onboarding_part: 1` in `alive.local.yaml` (resume Part 2)
- User explicitly requests setup

---

## UI Treatment

This skill uses **Tier 1: Entry Point** formatting.

**IMPORTANT:** Since rules aren't installed until Session 1, this skill must contain the full UI assets inline. Do not reference `rules/ui-standards.md` — use the assets below.

### Shell Format

Use the ALIVE Shell — one rounded box, three zones (header / content / footer):

- `╭╮╰╯` rounded corners — outer frame only
- `│` vertical sides
- `─` horizontal separators between zones
- NO double-line borders (`╔╗╚╝═║`) — these are deprecated

### Full Boot Screen

Render this exactly on the first onboarding screen. The elephant and ROMAN wordmark sit OUTSIDE the shell — they are the splash, not boxed content.

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

After the splash, content goes in the shell:

### Screen Template

```
╭──────────────────────────────────────────────────────────────────────╮
│                                                                       │
│    onboarding — [session name]                                        │
│  ──────────────────────────────────────────────────────────────────── │
│                                                                       │
│  [CONTENT HERE]                                                       │
│                                                                       │
│  ──────────────────────────────────────────────────────────────────── │
│  Free: Join the ALIVE community → skool.com/aliveoperators            │
╰──────────────────────────────────────────────────────────────────────╯
```

**Key rule:** The elephant + ROMAN wordmark render as raw text ABOVE the shell on the boot screen only. On subsequent screens, just use the shell with the `onboarding` label. Do NOT put the elephant or wordmark inside `│` borders.

---

## Interaction Style

**MANDATORY: Use the `AskUserQuestion` tool for all multiple-choice questions.**

Do NOT just print `[1] [2] [3]` options as text. You MUST invoke the AskUserQuestion tool so users get clickable buttons.

**When to use AskUserQuestion:**
- All `[1] [2] [3]` choices in this skill
- Life area selection (use `multiSelect: true`)
- Timezone, theme, working style preferences
- Any yes/no or multiple choice question

**When NOT to use it (just ask in conversation):**
- Venture/experiment names
- Goals and descriptions
- People names
- Any freeform text input

---

## Stay On Track (Enforced)

**Onboarding MUST be completed in full. Do not let the user stray.**

If the user tries to:
- Ask unrelated questions
- Start working on something else
- Skip ahead without completing steps
- Get distracted by other topics

**Respond with:**
> "Let's finish setting up ALIVE first — it only takes a few more minutes and ensures everything works properly. We can dive into that right after."

Then immediately return to the current onboarding step.

**The only valid exits from onboarding are:**
1. User explicitly selects "Skip to end" option
2. User explicitly says "cancel onboarding" or "stop setup"
3. Session 1 completes (forced restart)
4. Session 2 completes successfully

**Do NOT:**
- Answer unrelated questions mid-onboarding
- Let the user "just quickly" do something else
- Abandon onboarding without explicit cancellation

---

## Onboarding Principles

**Discovery-based. Experience before explanation.**

### Philosophy
1. **Experience before explanation** — They feel it work before they understand how
2. **Create the impasse** — "Will it remember?" is the question they carry into Session 2
3. **Socratic, not didactic** — Ask about their life, don't lecture about ALIVE
4. **Build alongside them** — Their real venture or experiment, populated from their real words
5. **Let them discover readability** — When they see _brain/ files, the structure clicks
6. **The save-and-return proof** — Session 2 opens by proving persistence
7. **Explain mechanism AFTER experience** — How it works comes after they've felt it work

### Guardrails
- **Assume zero knowledge** — User may have never heard of ALIVE
- **Interactive > passive** — Use AskUserQuestion for choices, not freeform dumps
- **Don't overwhelm** — One concept at a time, digestible chunks

## Template Locations

**All files MUST be created from templates — do not make up content.**

Templates are located at:
```
~/.claude/plugins/cache/aliveskills/alive/*/templates/
├── brain/              # _brain/ file templates
│   ├── status.md
│   ├── tasks.md
│   ├── insights.md
│   ├── changelog.md
│   └── manifest.json
├── domains/            # Domain structure templates
│   ├── ventures.md     # Venture types: Agency, Creator, E-commerce, Job, Custom
│   ├── life.md         # Life areas: health, finance, relationships, growth, home
│   ├── experiments.md
│   ├── inputs.md
│   └── archive.md
└── config/
    └── statusline-command.sh
```

**When creating files:**
1. Read the relevant template from the plugin
2. Copy and customize with user's input
3. Never invent file structures or content

---

## How Onboarding Tracking Works

**The `alive.local.yaml` file tracks onboarding progress:**

| Field | Set by | Purpose |
|-------|--------|---------|
| `onboarding_part` | Session 1 | Tracks that Session 1 is complete, Session 2 pending |
| `onboarding_complete` | Session 2 | Marks full onboarding as done |

When Session 1 completes → `onboarding_part: 1` is written.
When Session 2 completes → `onboarding_part` is removed, `onboarding_complete: true` is added.

Other skills check `onboarding_complete` to know if the system is set up.

---

## Full Flow (Overview)

**The arc: Question → Build → Save → Proof → Mechanism → Expand**

```
SESSION 1: THE EXPERIENCE
────────────────────────────────────────
1.  Boot Screen (manifesto + elephant — the emotional setup)
2.  The Question ("What takes up the most mental space?")
3.  The Build (create their first venture or experiment live from their words)
4.  Quick Config (location, timezone, theme, yaml)
5.  System Install (rules, CLAUDE.md, statusline)
6.  The Challenge ("Close terminal. Come back. Ask what you're working on.")
→   EXIT (Claude must restart to load new rules)

SESSION 2: THE PROOF + EXPANSION
────────────────────────────────────────
7.  The Proof (read _brain/, show them everything back)
8.  The Mechanism (NOW explain how it works — domains, _brain/, the loop)
9.  Life Setup (areas, people, goals — the foundation)
10. More Ventures + Experiments
11. Create Remaining Structure (from templates)
12. Verify Installation
13. Import (existing content + AI conversation history)
14. Complete + What's Next
```

---

## Why 2 Sessions?

Claude operates with its loaded rules. When you install rules and CLAUDE.md in Session 1, Claude still has no ALIVE knowledge loaded — it's running from the plugin skill text only.

Only a fresh session loads the new rules from `{alive-root}/.claude/rules/` and the CLAUDE.md identity.

**Session 1** creates the experience — their first venture or experiment built from a real conversation, plus system files installed. The user leaves with an open question: "Will it remember?"

**Session 2** opens with the proof — Claude reads their _brain/ files and recites back everything they shared. THEN explains how it works. Then expands their world with Life, more ventures and experiments, and the full system.

Without the restart, Claude would create ventures and experiments without understanding ALIVE conventions — leading to incorrect folder structures, missing files, and broken patterns.

---

## Detection Logic

When onboarding is invoked, determine which part to run:

```
1. Try to find alive.local.yaml:
   - Check common locations: ~/Desktop/alive/.claude/alive.local.yaml
   - Check ~/alive/.claude/alive.local.yaml
   - Check ~/Documents/alive/.claude/alive.local.yaml
   - Ask user if not found in common locations

2. If alive.local.yaml NOT FOUND:
   → New user. Run Session 1 from Step 1.

3. If alive.local.yaml EXISTS:
   a. Read the file
   b. If onboarding_complete: true → "Already onboarded" (see Returning Users)
   c. If onboarding_part: 1 → Session 1 done. Run Session 2 from Step 7.
   d. If file exists but no onboarding fields → Treat as new user, Session 1.
```

---

## Session 1: THE EXPERIENCE

### Step 1: Boot Screen

Display the full boot screen. This is the user's first impression — make it count.

Show the manifesto box, then the full elephant + wordmark inside the double-line border:

```
  ┌──────────────────────────────────────────────────────────────────────────────┐
  │                                                                              │
  │            Everything on every screen was built from a terminal.             │
  │               For decades, that power belonged to programmers.               │
  │          AI just opened the door — and all you have to do is talk.           │
  │          But AI has no memory. Every conversation starts from zero.          │
  │                                                                              │
  │                             ALIVE changes that.                              │
  │          Your files. Your machine. Context that compounds forever.           │
  │                                                                              │
  └──────────────────────────────────────────────────────────────────────────────┘
```

Then immediately display the full Tier 1 logo (elephant + wordmark from UI Treatment section above) inside the double-line border.

**Do NOT explain what ALIVE is. Do NOT describe the system. The manifesto speaks for itself.** Let it breathe for a moment, then move to The Question.

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Ready?",
    header: "Setup",
    options: [
      { label: "Let's go", description: "Start setup (~10 minutes across 2 sessions)" },
      { label: "I've used ALIVE before", description: "Skip to quick setup" }
    ],
    multiSelect: false
  }]
})
```

---

### Step 2: The Question

**This is the most important step. Don't rush it.**

Instead of explaining ALIVE, ask about THEM:

```
Before I set anything up, I want to understand your world.

What's the one thing taking up the most mental space right now?

This could be:
  - A business you're building
  - A project that keeps you up at night
  - Something in your personal life you're navigating
  - A side project or idea that won't leave your head

Just tell me about it. What is it, and where are you with it?
```

**Wait for their response. Listen.**

Then follow up conversationally — draw out the context that will populate their first venture or experiment:

```
Tell me more:
  - What's the current status? What phase are you in?
  - What needs doing right now? What's urgent?
  - Any blockers or things keeping you stuck?
  - What important knowledge or insights have you gained so far?
```

**You're not just collecting information — you're having a conversation.** The user should feel heard, not interrogated. Use their language back to them. Ask follow-up questions that show you understand.

**Capture mentally (or in working memory) the following from their responses:**
- **Name** (ask if not clear: "What do you call this?")
- **Status/phase** → will populate `status.md`
- **Tasks/to-dos** → will populate `tasks.md`
- **Insights/domain knowledge** → will populate `insights.md`
- **Whether this is a venture (revenue intent) or experiment (exploring)**

**Once you have a clear picture (2-4 exchanges), move to The Build.**

---

### Step 3: The Build

**Now show them the magic. Build their first venture or experiment live while they watch.**

```
Watch this.
```

#### 3a: Choose Directory

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Where do you want to create your ALIVE system?",
    header: "Location",
    options: [
      { label: "Desktop", description: "~/Desktop/alive — easy to find (Recommended)" },
      { label: "Home folder", description: "~/alive — clean and accessible" },
      { label: "Documents", description: "~/Documents/alive — with other docs" },
      { label: "Custom location", description: "I'll specify a path" }
    ],
    multiSelect: false
  }]
})
```

**If Custom:** Ask in conversation: "What's the full path?"

**Validate:** Check parent exists, write permissions, warn if `alive/` already there.

#### 3b: Create Structure

Create the full ALIVE structure AND their first venture or experiment in one go:

```bash
ALIVE_ROOT="{user-chosen-location}"

# Create domain folders
mkdir -p "$ALIVE_ROOT/01_Archive"
mkdir -p "$ALIVE_ROOT/02_Life"
mkdir -p "$ALIVE_ROOT/03_Inputs"
mkdir -p "$ALIVE_ROOT/04_Ventures"
mkdir -p "$ALIVE_ROOT/05_Experiments"
mkdir -p "$ALIVE_ROOT/.claude/rules"
mkdir -p "$ALIVE_ROOT/.claude/state"

# Create their first venture or experiment
DOMAIN="04_Ventures"  # or 05_Experiments based on Step 2
NAME="{kebab-case-name}"
mkdir -p "$ALIVE_ROOT/$DOMAIN/$NAME/.claude"
mkdir -p "$ALIVE_ROOT/$DOMAIN/$NAME/_brain"
mkdir -p "$ALIVE_ROOT/$DOMAIN/$NAME/_working"
mkdir -p "$ALIVE_ROOT/$DOMAIN/$NAME/_references"

# Open in Finder
open "$ALIVE_ROOT"
```

**Platform detection:**
- macOS: `open "$ALIVE_ROOT"`
- Linux: `xdg-open "$ALIVE_ROOT"`
- Windows/WSL: `explorer.exe "$ALIVE_ROOT"`

**IMPORTANT:** Open the folder so the user sees it being built in real time. This is intentional for the "wow" effect.

#### 3c: Populate _brain/ from their words

**This is the key moment.** Create _brain/ files using templates but populated with REAL content from Step 2.

**Use templates from:** `~/.claude/plugins/cache/aliveskills/alive/*/templates/brain/`

Write `status.md`:
```markdown
# Status

**Goal:** [extracted from conversation — what they want to achieve]
**Phase:** [extracted from conversation — Starting/Building/Launching/Growing]
**Updated:** [today's date]

---

## Key People

[Anyone they mentioned working with, or "None yet"]

## State of Play

[Their words about what they're working on RIGHT NOW — use their language]

## Priorities

[What they said is most important right now]

## Blockers

[What they said is keeping them stuck, or "None" if clear]

## Next Milestone

[What they described as the next goal]
```

Write `tasks.md`:
```markdown
# Tasks

## Urgent
[Any tasks they flagged as urgent]

## Active
[Tasks they mentioned are in progress]

## To Do
[Tasks they mentioned but haven't started]

## Done (Recent)
[Anything they mentioned completing recently]
```

Write `insights.md`:
```markdown
# Insights

## [today's date] — Initial Context

**Category:** [strategy | product | process | market]
**Domain knowledge:** [Any insights or domain knowledge they shared]
**Evidence:** Shared during onboarding setup
**Applies to:** [venture/experiment name]
```

Write `changelog.md`:
```markdown
# Changelog

## [today's date] — Created (Onboarding)
**Session:** [session-id]

### Context
- Created during ALIVE onboarding
- [1-2 sentences summarizing what user shared]

### Next
- [The immediate next step they described]
```

Write `manifest.json` from template, customized with venture/experiment details.

Write `.claude/CLAUDE.md` (unit identity):
```markdown
# [Name]

[One-sentence description based on what user shared]

**Goal:** [extracted from conversation]
```

#### 3d: Show them what you built

```
▸ creating your ALIVE system...

ALIVE/
├── 01_Archive/
├── 02_Life/              ← We'll set this up in Session 2
├── 03_Inputs/
├── 04_Ventures/
│   └── [name]/
│       ├── .claude/CLAUDE.md   ← "[goal sentence]"
│       ├── _brain/
│       │   ├── status.md       ← Phase: [phase]. Focus: [their words]
│       │   ├── tasks.md        ← [N] tasks captured from our conversation
│       │   ├── insights.md     ← [insight they shared]
│       │   └── changelog.md    ← This session logged
│       ├── _working/
│       └── _references/
├── 05_Experiments/
└── .claude/

▸ opening folder — check your file manager.

✓ Your first venture is live.
  Everything you just told me is now in files I can read.
```

**Let this land.** Don't immediately rush to the next step. If the user reacts, engage with it. They just watched their words become structured files.

---

### Step 4: Quick Config

```
A few quick preferences before I install the system files.
```

**Timezone** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "What timezone are you in?",
    header: "Timezone",
    options: [
      { label: "Australia (AEST)", description: "Australian Eastern Standard/Daylight" },
      { label: "US Pacific (PT)", description: "Los Angeles, San Francisco" },
      { label: "US Eastern (ET)", description: "New York, Miami" },
      { label: "UK (GMT/BST)", description: "London, Edinburgh" }
    ],
    multiSelect: false
  }]
})
```

(User can select "Other" to specify a different timezone)

**Visual Style** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "How do you like your interface?",
    header: "Theme",
    options: [
      { label: "Vibrant (Recommended)", description: "Full visual experience with boxes and formatting" },
      { label: "Minimal", description: "Clean and fast, less decoration, saves context window" },
      { label: "Loud", description: "Emojis, emphasis, maximum clarity — ADHD-friendly" }
    ],
    multiSelect: false
  }]
})
```

**Working Style** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "How do you typically work?",
    header: "Work style",
    options: [
      { label: "Solo operator", description: "It's mostly just me" },
      { label: "Small team", description: "A few collaborators" },
      { label: "Larger org", description: "Multiple people, shared context needed" }
    ],
    multiSelect: false
  }]
})
```

**Create `{alive-root}/.claude/alive.local.yaml`:**

```yaml
# ALIVE System Configuration
# Created by /alive:onboarding — Session 1
# Location: {alive-root}/.claude/alive.local.yaml

version: 2
system_version: "3.1.0"
onboarding_part: 1
created: "[today's date]"

# System paths
alive_root: "{absolute-path-to-alive-root}"

# User preferences
timezone: "[selection]"
theme: "[selection]"
working_style: "[selection]"
```

```
✓ Config saved
```

---

### Step 5: System Install (CRITICAL)

**Install rules and CLAUDE.md. This is MANDATORY — ALIVE will not work without it.**

**IMPORTANT:** Files install INSIDE the ALIVE directory (location from Step 3a), NOT in the user's home `~/.claude/` folder.

Example: If user chose `~/Desktop/alive/`:
- Rules go to: `~/Desktop/alive/.claude/rules/`
- CLAUDE.md goes to: `~/Desktop/alive/.claude/CLAUDE.md`

#### Rules

```bash
# Copy rules from plugin to ALIVE directory
cp -r ~/.claude/plugins/cache/aliveskills/alive/*/rules/* "$ALIVE_ROOT/.claude/rules/"
```

Files copied: `behaviors.md`, `conventions.md`, `intent.md`, `learning-loop.md`, `ui-standards.md`, `voice.md`, `working-folder-evolution.md`, `anti-patterns.md`

#### CLAUDE.md

```bash
# Copy CLAUDE.md from plugin to ALIVE directory
cp ~/.claude/plugins/cache/aliveskills/alive/*/CLAUDE.md "$ALIVE_ROOT/.claude/CLAUDE.md"
```

Then use Edit to add User Preferences section:
```markdown
## User Preferences

**Timezone:** [selection]
**Theme:** [selection]
**Working Style:** [selection]
```

#### Statusline

**The statusline is essential for ALIVE.** Configure it automatically — do NOT offer to skip.

It shows: `session:abc123 | ctx:32% | $1.24 | 🔥 2 urgent | 📥 5 inputs`

**If user asks "What's a statusline?":**
```
The statusline is the small text bar at the bottom of Claude Code.
By default it shows basic info. With ALIVE, it shows your system
status so you always know what needs attention.
```

**Implementation:**
1. Copy `~/.claude/plugins/cache/aliveskills/alive/*/templates/config/statusline-command.sh` to `~/.claude/statusline-command.sh`
2. Add to `~/.claude/settings.json`:
   ```json
   {
     "statusline": {
       "command": "~/.claude/statusline-command.sh"
     }
   }
   ```

**After installing, display this directly to the user as visible conversation output.** This is a critical explanation moment — do NOT skip or abbreviate it. Output the installation confirmation, then the explanation below it:

```
▸ installing system files...
  └─ .claude/CLAUDE.md     ✓
  └─ .claude/rules/        ✓ (8 files)
  └─ Statusline             ✓

✓ System installed
```

Then explain what just happened and how ALIVE works. **This must be output as regular text the user can read, not hidden in implementation details:**

```
HOW THIS WORKS
─────────────────────────────────────────────────────────────────────────

Those files I just installed? They're what makes ALIVE work.

Every time you start a Claude Code session in this folder, Claude
automatically reads those files before you say anything. They teach
Claude how to use ALIVE — how to read your venture/experiment state, show you
what it's looking at, flag when things are stale, offer to capture
decisions. You don't need to update them. You don't need to think
about them. They just work.

WHAT ARE _brain/ FILES?
─────────────────────────────────────────────────────────────────────────

Every venture, experiment, or life area you create in ALIVE gets a
_brain/ folder. That's where everything about it lives:

  status.md    → Unit summary and state of play (goal, phase, people, priorities)
  tasks.md     → What needs doing
  insights.md  → Unit-scoped domain knowledge
  changelog.md → History of every session
  manifest.json → Map of everything in the venture/experiment

When you say "work on [name]", Claude reads those files and knows
exactly where you left off. That's the whole trick — no database, no
app, no subscription. Just files.

WHY MARKDOWN?
─────────────────────────────────────────────────────────────────────────

You're going to see a lot of .md files. Markdown is just plain text
with simple formatting — headings, bullet points, bold text. Nothing
fancy.

The reason ALIVE uses markdown for everything:
  • YOU can read it. Open any file and it makes sense immediately.
  • AI can read it. Claude understands markdown perfectly.
  • It's just files. They live on your computer (or iCloud, Dropbox,
    wherever you put this folder). No vendor lock-in. No proprietary
    format. No app that might shut down next year.
  • It's searchable. Spotlight, grep, whatever you use — it just works.

Your entire system is files you own, on hardware you control, readable
by any text editor or AI. That's the point.
```

**Important:** This explanation is the first time the user understands what ALIVE actually is. Do NOT condense it. Do NOT skip sections. Output all of it. If the user seems engaged, pause briefly to let it land before continuing to the next step.

---

### Step 6: The Challenge

**This is the exit. Make it feel like a cliffhanger, not a chore.**

```
╭─ NOW FOR THE REAL TEST ───────────────────────────────────────────────╮
│                                                                        │
│  Everything you told me about [name] is saved to files.       │
│  But right now, I'm running from the plugin — I haven't loaded       │
│  the rules I just installed. I need a restart to become the           │
│  full ALIVE system.                                                   │
│                                                                        │
│  Here's the challenge:                                                │
│                                                                        │
│  1. Close this terminal (Ctrl+C or just close it)                    │
│  2. Open a NEW terminal                                               │
│  3. cd into your ALIVE folder:                                        │
│                                                                        │
│     cd {alive-root}                                                    │
│                                                                        │
│     This is critical — Claude reads the rules from this folder.       │
│     If you're not in this directory, ALIVE won't work.                │
│                                                                        │
│  4. Start Claude Code (type: claude)                                  │
│  5. Run /alive:onboarding                                              │
│                                                                        │
│  When you come back, the first thing I'll do is tell you              │
│  everything you just told me — without you saying a word.             │
│                                                                        │
│  Let's see if it works.                                                │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯
```

**STOP. Do not proceed to Session 2 steps. The user MUST restart Claude.**

**Session 2 `cd` check:** When Session 2 starts (Step 7), verify the user is in the correct directory by checking if `.claude/alive.local.yaml` exists in the current working directory. If not, instruct them to `cd {alive-root}` first.

---

## Session 2: THE PROOF + EXPANSION

**Only reached when `alive.local.yaml` has `onboarding_part: 1`.**

### Step 7: The Proof

**This is the aha moment. Don't blow it.**

**First: Verify Session 1 actually completed.** Read `{alive-root}/.claude/alive.local.yaml` and check for `onboarding_part: 1`. Then scan for the venture or experiment that should have been created in Session 1.

**Guard check — find the venture/experiment:** Scan `04_Ventures/` and `05_Experiments/` for any folder with a `_brain/` directory.

**If NO venture or experiment with `_brain/` is found:**
```
Hmm — it looks like Session 1 didn't finish creating your first venture.

That's fine. Let me pick up where we left off.
```
Then jump back to the creation step from Session 1 (Step 4). Do NOT show the "You're back" proof screen — there's nothing to prove yet.

**If a venture or experiment IS found:** Read its `status.md`, `tasks.md`, `insights.md`. Then proceed with the proof display below.

**Display inside the full Tier 1 border with elephant + wordmark:**

```
╭──────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                      │
│  [FULL LOGO]                                                                         │
│                                                                                      │
│    onboarding — session 2                                                            │
│  ──────────────────────────────────────────────────────────────────────────────────  │
│                                                                                      │
│  You're back. Let me show you something.                                             │
│                                                                                      │
│  ▸ reading [name]/_brain/status.md                                                   │
│    └─ Phase: [phase]. Focus: [their words from Session 1]                            │
│                                                                                      │
│  ▸ reading [name]/_brain/tasks.md                                                    │
│    └─ [N] tasks: [list the urgent/active ones by name]                               │
│                                                                                      │
│  ▸ reading [name]/_brain/insights.md                                                 │
│    └─ "[the insight they shared]"                                                    │
│                                                                                      │
│  I remember everything. You didn't have to re-explain a thing.                       │
│                                                                                      │
╰──────────────────────────────────────────────────────────────────────────────────────╯
```

**Pause. Let this land.** This is the moment the user understands what ALIVE does — not because you explained it, but because they FELT it.

Then:
```
That's ALIVE. You talk. I save. You come back. I remember.

No re-explaining. No lost context. No starting from scratch.

Now let me show you how it works — and set up the rest of your world.
```

---

### Step 8: The Mechanism

**NOW explain how ALIVE works. Experience first, explanation second.**

```
HOW IT WORKS
─────────────────────────────────────────────────────────────────────────

What just happened:

1. In Session 1, you told me about [name]
2. I wrote your words into files — structured markdown in _brain/
3. You closed the terminal. I "forgot" everything.
4. You came back. I read the files. Context restored.

The key: your context lives in FILES, not in my memory.
Files persist. My memory doesn't.

  [name]/
  └── _brain/
      ├── status.md     ← Unit summary and state of play
      ├── tasks.md      ← What needs doing?
      ├── insights.md   ← Unit-scoped domain knowledge
      └── changelog.md  ← What happened? (session history)

That's it. Simple markdown. No database. No cloud sync.
You own your context. You can read, edit, move, or back up
these files any time. Nothing is locked in a black box.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Makes sense?",
    header: "Continue",
    options: [
      { label: "Makes sense", description: "Continue to the five domains" },
      { label: "Why files?", description: "Why not a database or cloud service?" }
    ],
    multiSelect: false
  }]
})
```

**If "Why files?":**

```
WHY FILES?
─────────────────────────────────────────────────────────────────────────

Three reasons:

1. PORTABILITY
   Your context isn't locked in a proprietary system.
   It's markdown files you can read, edit, move, or backup.

2. TRANSPARENCY
   You can see exactly what I "remember" about you.
   No black box. Open the file, read the context.

3. SIMPLICITY
   No servers. No accounts. No sync issues.
   Works offline. Works forever.
```

#### The Five Domains

```
THE FIVE DOMAINS
─────────────────────────────────────────────────────────────────────────

Your [name] lives in [04_Ventures or 05_Experiments].
But ALIVE organizes ALL of your context into five areas:

┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  01_Archive      Where completed things rest                        │
│                  (Out of sight, but preserved)                      │
│                                                                     │
│  02_Life         YOUR FOUNDATION — personal areas                   │
│                  (Health, finance, relationships, home...)          │
│                                                                     │
│  03_Inputs       The inbox — stuff to process                       │
│                  (Meeting notes, ideas, links to sort)              │
│                                                                     │
│  04_Ventures     Revenue-generating ventures                        │
│                  (Businesses, freelance, products)                  │
│                                                                     │
│  05_Experiments  Ideas you're testing                               │
│                  (No business model yet, just exploring)            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

Life comes early because it's the foundation — your personal
context that spans everything else.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Want the deep dive on each domain, or continue setting up?",
    header: "Domains",
    options: [
      { label: "Continue", description: "I get it — let's set things up" },
      { label: "Tell me more", description: "Explain each domain in detail" }
    ],
    multiSelect: false
  }]
})
```

**If "Tell me more":**

```
DOMAIN DEEP DIVE
─────────────────────────────────────────────────────────────────────────

01_ARCHIVE
  Things that are done. Completed ventures, old experiments, closed
  chapters. We move things here instead of deleting — nothing is lost.

02_LIFE (Most Important)
  This is YOU. Not your work — your actual life. Health tracking,
  finances, relationships, personal goals. Most productivity systems
  ignore this. ALIVE doesn't.

  Life includes a special folder: people/
  Everyone you know lives here — linked across all your ventures and experiments.
  Your cofounder? They're in people/, referenced from ventures.

03_INPUTS
  A universal inbox. Dump anything here: meeting transcripts, ideas,
  screenshots, voice notes. Later, we process and route them to the
  right place. Nothing gets lost, nothing needs immediate filing.

04_VENTURES
  Work that makes (or will make) money. Each venture gets its own
  _brain/ folder, its own context, its own history.

05_EXPERIMENTS
  Ideas you're testing. No pressure to monetize. No commitment.
  If they work, they graduate to Ventures. If not, they archive.
```

#### The Loop

```
THE LEARNING LOOP
─────────────────────────────────────────────────────────────────────────

ALIVE works best with a daily rhythm:

  /alive:daily  → Start your day. See everything across all ventures,
                  experiments, and life areas. Urgent tasks, inputs to
                  process, what needs attention.

  /alive:work   → Focus on ONE venture, experiment, or life area. Load
                  its context, start working. "work on [name]" or
                  "focus on health"

  /alive:save   → End your session. Log what happened, update context.
                  This is how memory persists.

That's the core loop: DAILY → WORK → SAVE → REPEAT

Context compounds each cycle. Skip the save, lose the context.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Ready to set up the rest of your world?",
    header: "Continue",
    options: [
      { label: "Let's go", description: "Set up Life, add more ventures and experiments" },
      { label: "Other commands", description: "What else can ALIVE do?" }
    ],
    multiSelect: false
  }]
})
```

**If "Other commands":**

```
OTHER USEFUL COMMANDS
─────────────────────────────────────────────────────────────────────────

/alive:capture  Capture context. Dump in anything — a decision,
                transcript, email, article — I'll extract what
                matters and route it to the right place.

/alive:recall   Search your history. "What did we decide about
                pricing?" — I'll find it.

/alive:new      Create a new venture, experiment, or life area.

/alive:archive  Move something to the archive when it's done.

/alive:sweep    Clean up. Find stale content, abandoned drafts.

/alive:help     Quick reference for all commands.
```

---

### Step 9: Life Setup (THE FOUNDATION)

```
╭─ LIFE SETUP ───────────────────────────────────────────────────────────╮
│                                                                        │
│  This is the most important part.                                      │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

Most productivity systems focus on WORK and ignore LIFE.

That's backwards.

Your life is the foundation. Your health affects your work. Your
relationships affect your focus. Your finances affect your stress.
Everything connects.

ALIVE puts Life first. Let's set it up properly.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Set up your Life domain?",
    header: "Life setup",
    options: [
      { label: "Yes — set up Life", description: "Configure health, finance, relationships, etc." },
      { label: "Skip Life", description: "I just want to track work (you can add Life later)" }
    ],
    multiSelect: false
  }]
})
```

**If "Skip Life":**

```
Are you sure?

Without Life setup, ALIVE becomes just another project tracker.
You'll miss:
  - Personal context that compounds over time
  - Relationship tracking across ventures and experiments
  - Health/energy patterns that affect productivity
  - The foundation that makes everything else work
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Set up Life anyway?",
    header: "Confirm skip",
    options: [
      { label: "Set up Life", description: "You're right — let me set it up" },
      { label: "Skip anyway", description: "I'll add it later with /alive:new" }
    ],
    multiSelect: false
  }]
})
```

#### Step 9a: Life Areas

**Life areas come from `templates/domains/life.md`.**

Use AskUserQuestion with multiSelect:
```
AskUserQuestion({
  questions: [{
    question: "What areas of life do you want to track?",
    header: "Life areas",
    options: [
      { label: "Health", description: "Physical and mental health, fitness, medical" },
      { label: "Finance", description: "Money, investments, budgets, tax" },
      { label: "Relationships", description: "Family, friends, community" },
      { label: "Growth", description: "Learning, skills, personal development" }
    ],
    multiSelect: true
  }]
})
```

**Note:** These are the standard areas from the template. Users can add custom areas later with `/alive:new`.

Each selected area gets:
- `02_Life/[area]/.claude/CLAUDE.md` (from template)
- `02_Life/[area]/_brain/` (status.md, tasks.md, insights.md, changelog.md)
- `02_Life/[area]/_working/`
- `02_Life/[area]/_references/`

**For each selected area, brief follow-up using AskUserQuestion:**

Example for Health:
```
AskUserQuestion({
  questions: [{
    question: "What's your main health focus right now?",
    header: "Health",
    options: [
      { label: "Fitness", description: "Training, exercise, physical goals" },
      { label: "Medical", description: "Appointments, conditions, medications" },
      { label: "Mental wellness", description: "Stress, therapy, mindfulness" },
      { label: "General", description: "All of the above, I'll specify as I go" }
    ],
    multiSelect: false
  }]
})
```

Then ask in conversation: "Any current health goals? (Optional — press Enter to skip)"

```
✓ Health area configured
```

*(Repeat brief config for each selected area)*

#### Step 9b: Key People

```
KEY PEOPLE
─────────────────────────────────────────────────────────────────────────

ALIVE has a central place for all the people in your life: people/

This is powerful because:
  - One file per person, linked across all your ventures and experiments
  - I remember context about relationships over time
  - Your cofounder appears in Ventures AND in People
  - Family members have their own context that compounds

Who are the most important people in your life right now?

Think about:
  - Family (partner, parents, kids, siblings)
  - Close friends
  - Key work relationships (boss, cofounder, mentor)
  - Anyone you interact with regularly

Enter names (I'll create a file for each):
> ___

Format: "Sarah (partner), Mum, Ben (boss), Jake (cofounder)"
Or type "skip" to do this later.
```

**After people input:**

```
▸ creating people/

  sarah.md        partner
  mum.md          family
  ben.md          boss
  jake.md         cofounder

Each person gets a simple file. Over time, as you mention them in
conversations, their context builds. Meeting notes, decisions,
relationship history — all linked.

✓ [N] people created in 02_Life/people/
```

#### Step 9c: Life Goals (Optional)

```
LIFE GOALS
─────────────────────────────────────────────────────────────────────────

Do you have any big personal goals right now?
(Things outside of work ventures)

Examples:
  - "Run a marathon by end of year"
  - "Pay off credit card debt"
  - "Spend more quality time with family"
  - "Learn Spanish"

Enter any goals, or skip:
> ___

(These go into 02_Life/_brain/status.md as your personal north star)
```

**Implementation:**
Create `02_Life/_brain/` with status.md, tasks.md, insights.md, changelog.md, manifest.json from templates.
Create `02_Life/people/` folder and individual person files.
Create each life area with _brain/, _working/, _references/, .claude/CLAUDE.md.

---

### Step 10: More Ventures + Experiments

```
╭─ MORE VENTURES + EXPERIMENTS ─────────────────────────────────────────╮
│                                                                        │
│  You already have [name]. Let's add more.                             │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯
```

#### Ventures

```
VENTURES are work with revenue intent.

This could be:
  - A business you run
  - Freelance/consulting work
  - A product you're building to sell
  - A side project that could make money

Do you have any OTHER active ventures? (Besides [name])
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Any other ventures to add?",
    header: "Ventures",
    options: [
      { label: "Yes", description: "I have more ventures to set up" },
      { label: "No", description: "Just [name] for now" },
      { label: "Not sure", description: "Help me figure out what counts" }
    ],
    multiSelect: false
  }]
})
```

**If "Not sure":**

```
WHAT COUNTS AS A VENTURE?
─────────────────────────────────────────────────────────────────────────

Ask yourself: "Is this meant to make money, now or eventually?"

VENTURE examples:
  ✓ Your agency or consultancy
  ✓ An e-commerce store
  ✓ A SaaS product (even pre-revenue)
  ✓ Freelance work under a brand name
  ✓ A course or content business

NOT ventures (these are experiments):
  ✗ "I might start a newsletter"
  ✗ "I'm exploring this idea"
  ✗ "Playing around with a concept"

Experiments are for testing. Ventures are for building.
```

**If "Yes" — For each additional venture, collect: name, TYPE, goal, phase**

**Name** (conversational): "What's the name of your venture?"

**Type** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "What type of venture is this?",
    header: "Venture type",
    options: [
      { label: "Agency", description: "Client work, deliverables, retainers" },
      { label: "Creator", description: "Content, courses, community" },
      { label: "E-commerce", description: "Products, inventory, fulfillment" },
      { label: "Job", description: "Employment brought into ALIVE" }
    ],
    multiSelect: false
  }]
})
```

**Goal** (conversational): "What's the one-sentence goal?"

**Phase** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "What phase is it in?",
    header: "Phase",
    options: [
      { label: "Starting", description: "Idea stage, getting off the ground" },
      { label: "Building", description: "Actively developing, early traction" },
      { label: "Launching", description: "Going to market, finding customers" },
      { label: "Growing", description: "Scaling up, increasing revenue" }
    ],
    multiSelect: false
  }]
})
```

**Venture type creates different folder structures:**
- **Agency:** clients/, templates/, operations/, pipeline/
- **Creator:** content/, products/, community/, funnel/
- **E-commerce:** products/, suppliers/, marketing/, operations/
- **Job:** projects/, docs/, meetings/, growth/
- **Custom:** (minimal) .claude/, _brain/, _working/, _references/

```
✓ [Venture name] configured as [Type]
```

Use AskUserQuestion to ask about more ventures, then continue.

#### Experiments

```
EXPERIMENTS are for exploration.

Ideas you're testing before they become ventures:
  - A newsletter you might start
  - A product concept you're validating
  - A skill you're learning to potentially monetize
  - Anything with uncertainty

The pressure is off. Experiments can fail. That's the point.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Do you have any active experiments?",
    header: "Experiments",
    options: [
      { label: "Yes", description: "I have ideas I'm testing" },
      { label: "No", description: "Nothing in exploration right now" },
      { label: "Maybe", description: "I have some vague ideas" }
    ],
    multiSelect: false
  }]
})
```

**If "Yes" or "Maybe":**

For each experiment, ask conversationally:
- What are you calling this experiment?
- What's the hypothesis or question you're testing?
- What would "success" look like?

```
✓ [Experiment name] configured
```

Use AskUserQuestion to ask about more experiments, then continue.

---

### Step 11: Create Remaining Structure

Create all ventures, experiments, and life areas configured in Steps 9-10. (The first venture or experiment from Session 1 already exists.)

```
╭─ CREATING YOUR WORLD ────────────────────────────────────────────────╮
│                                                                        │
│  Building your personal context infrastructure...                      │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯
```

**For each NEW venture, experiment, or life area, create:**
- `.claude/CLAUDE.md` (unit identity from template)
- `_brain/status.md` (from template, customized with user input)
- `_brain/tasks.md` (from template)
- `_brain/insights.md` (from template)
- `_brain/changelog.md` (from template)
- `_brain/manifest.json` (from template, customized)
- `_working/` (empty)
- `_references/` (empty)

**Also create:**
- `02_Life/_brain/` (Life-level status, tasks, insights, changelog)
- `02_Life/people/` with individual person files
- `.claude/state/session-index.jsonl` (empty)

**Display the tree:**

```
▸ creating structure...

02_Life/
├── _brain/              (Life focus + goals)
├── health/              (Your health tracking)
│   ├── _brain/
│   ├── _working/
│   └── _references/
├── finance/
│   ├── _brain/
│   ├── _working/
│   └── _references/
└── people/
    ├── sarah.md
    └── ben.md

04_Ventures/
├── [first-venture]/     ← Already created in Session 1
└── [new-venture]/
    ├── .claude/CLAUDE.md
    ├── _brain/
    ├── _working/
    ├── _references/
    └── clients/         (Agency-specific)

05_Experiments/
└── [experiment]/
    ├── .claude/CLAUDE.md
    ├── _brain/
    ├── _working/
    └── _references/

✓ All ventures, experiments, and life areas created
```

---

### Step 12: Verify Installation

```
▸ verifying installation...

DOMAINS
  ✓ 01_Archive/ exists
  ✓ 02_Life/ exists
  ✓ 03_Inputs/ exists
  ✓ 04_Ventures/ exists
  ✓ 05_Experiments/ exists

LIFE STRUCTURE
  ✓ 02_Life/_brain/ exists
  ✓ 02_Life/people/ exists ([N] people)
  ✓ [X] life areas configured

SYSTEM FILES
  ✓ .claude/CLAUDE.md exists
  ✓ .claude/rules/ exists (8 files)
  ✓ .claude/state/ exists
  ✓ .claude/alive.local.yaml exists

VENTURES / EXPERIMENTS
  ✓ [first-venture]/_brain/ initialized
  ✓ [venture]/_brain/ initialized
  ✓ [experiment]/_brain/ initialized

CONFIG
  ✓ system_version: 3.1.0
  ✓ alive_root: [path]
  ✓ timezone: [value]
  ✓ theme: [value]

─────────────────────────────────────────────────────────────────────────
All checks passed.
```

**If any check fails:**

```
✗ VERIFICATION FAILED

Missing:
  ✗ .claude/rules/ — rules not installed
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Fix the missing components?",
    header: "Fix",
    options: [
      { label: "Fix now", description: "Install missing components" },
      { label: "Cancel", description: "Cancel onboarding" }
    ],
    multiSelect: false
  }]
})
```

**Do NOT proceed to next step until all checks pass.**

---

### Step 13: Import

#### Existing Content

```
╭─ IMPORT EXISTING CONTENT ────────────────────────────────────────────╮
│                                                                        │
│  One more thing before we finish.                                      │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

Do you have existing content you'd like to bring into ALIVE?

This could be:
  - Meeting transcripts or notes
  - Documents from other systems (Notion, Obsidian, Google Docs)
  - Existing project folders
  - Old notes you want to preserve

ALIVE can import and organize this for you.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Import existing content?",
    header: "Import",
    options: [
      { label: "Yes", description: "I have content to import (after setup)" },
      { label: "Maybe later", description: "Tell me how to import later" },
      { label: "No", description: "I'm starting fresh" }
    ],
    multiSelect: false
  }]
})
```

**If "Yes":**
```
After this setup finishes, run:

  /alive:migrate

This will walk you through importing your existing content.
I'll extract the relevant context and file it in the right places.
```

**If "Maybe later":**
```
No problem. Whenever you're ready, just say:

  "migrate my content" or /alive:migrate

I'll help you import from:
  - Meeting transcripts (I extract action items and decisions)
  - Notion exports
  - Markdown files
  - Any text content

Your existing knowledge doesn't have to start from zero.
```

#### AI Conversation History

```
╭─ AI CONVERSATION HISTORY ────────────────────────────────────────────╮
│                                                                        │
│  One more — this one's optional but powerful.                         │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

You've probably had hundreds of conversations with AI assistants
before ALIVE. All that context — decisions, research, ideas,
problem-solving — is sitting in those chat histories.

ALIVE has a companion plugin that can import your previous AI
conversations, extract the valuable context, and route it into
your ALIVE system.

It works with any AI assistant that lets you export your data.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Want to import your previous AI conversation history into ALIVE?",
    header: "AI history",
    options: [
      { label: "Yes — tell me how", description: "I want to bring in context from previous AI conversations" },
      { label: "Maybe later", description: "Sounds useful but not right now" },
      { label: "No thanks", description: "I'm starting fresh" }
    ],
    multiSelect: false
  }]
})
```

**If "Yes" or "Maybe later":**

```
CONTEXT IMPORT PLUGIN
─────────────────────────────────────────────────────────────────────────

To import AI conversation history, you'll need to install the
ALIVE Context Import plugin:

  aliveos/alive-context-import

This is a separate plugin (not bundled with ALIVE) that handles:
  • Exporting your data from AI assistants
  • Extracting decisions, insights, and action items
  • Routing imported context into your ALIVE ventures, experiments, and life areas
  • Building your _references/ and _brain/ files from history

I've added a task to your Life tasks so you don't forget.
```

**Implementation:**

Add this task to `{alive-root}/02_Life/_brain/tasks.md` under the "To Do" section:

```markdown
- [ ] **Install alive-context-import plugin** — Import previous AI conversation history into ALIVE. Plugin: `aliveos/alive-context-import`. Install via Claude Code plugin system, then run its import skill to extract context from your old conversations.
```

```
▸ adding task to 02_Life/_brain/tasks.md
  └─ "Install alive-context-import plugin"

✓ Task added — you can pick this up whenever you're ready.
```

**If "No thanks":**
```
No worries. If you change your mind later, the plugin is:

  aliveos/alive-context-import

You can install it any time.
```

---

### Step 14: Complete + What's Next

**First: Verify `alive.local.yaml` has all required fields.** Read `{alive-root}/.claude/alive.local.yaml` and check:

| Field | Required | Fix if missing |
|-------|----------|----------------|
| `version` | Yes | Add `version: 2` |
| `system_version` | Yes | Add `system_version: "3.1.0"` |
| `alive_root` | Yes | Add with the current working directory path |
| `timezone` | Yes | Ask the user |
| `theme` | Yes | Default to `vibrant` |
| `working_style` | Yes | Default to `solo` |
| `created` | Yes | Add with today's date |

If any fields are missing, add them silently (don't interrupt the flow — just fix it). Then update the file:
- Remove the line `onboarding_part: 1`
- Add `onboarding_complete: true`

**Display:**

```
╭──────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                      │
│  [FULL LOGO]                                                                         │
│                                                                                      │
│    ✓ SETUP COMPLETE                                                                  │
│  ──────────────────────────────────────────────────────────────────────────────────  │
│                                                                                      │
│  WHAT YOU HAVE NOW:                                                                  │
│    • [name] with full context from our conversation                                  │
│    • 02_Life/ with [X] areas + [Y] people configured                                 │
│    • [N] ventures ready to track                                                     │
│    • [N] experiments ready to explore                                                │
│    • All rules and system files installed                                             │
│    • System version: 3.1.0                                                           │
│                                                                                      │
│  SKILLS — HOW YOU TALK TO ALIVE:                                                     │
│                                                                                      │
│    Skills are slash commands. Type them in the chat to tell ALIVE                     │
│    what you want to do. You've already used one: /alive:onboarding                   │
│                                                                                      │
│    The three you'll use most:                                                        │
│      /alive:daily   → See everything, start your day                                 │
│      /alive:work    → Focus on one venture, experiment, or life area                 │
│      /alive:save    → End session, preserve context                                  │
│                                                                                      │
│    Other useful ones:                                                                │
│      /alive:capture  → Save a decision, note, or email                               │
│      /alive:digest   → Process your 03_Inputs/ inbox                                 │
│      /alive:help     → See all available skills                                      │
│                                                                                      │
│    You can also just talk naturally — "work on acme", "what's in                     │
│    my inbox", "save" — and ALIVE will figure out which skill to use.                 │
│                                                                                      │
│  REMEMBER:                                                                           │
│    • Save before closing (or context is lost)                                        │
│    • Dump stuff in 03_Inputs/ when unsure where it goes                              │
│    • Context compounds — the more you use it, the better it gets                     │
│                                                                                      │
│  ──────────────────────────────────────────────────────────────────────────────────  │
│  Free: Join the ALIVE community → skool.com/aliveoperators                           │
│  (Templates, guides, Q&A with other operators)                                       │
│                                                                                      │
╰──────────────────────────────────────────────────────────────────────────────────────╯
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "What's first?",
    header: "Next",
    options: [
      { label: "/alive:daily", description: "See my full dashboard" },
      { label: "Work on a venture", description: "Start with my main venture" },
      { label: "/alive:migrate", description: "Import my existing content" },
      { label: "Explore", description: "Let me look around first" }
    ],
    multiSelect: false
  }]
})
```

---

## Returning Users

If `onboarding_complete: true` in alive.local.yaml:

```
You've already completed onboarding.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "What would you like to do?",
    header: "Options",
    options: [
      { label: "Quick reference", description: "Show /alive:help" },
      { label: "Re-run setup", description: "Reset onboarding and start over" },
      { label: "Join community", description: "skool.com/aliveoperators" }
    ],
    multiSelect: false
  }]
})
```

---

## Skip Options

At any point during setup, if the user says "skip" or wants to jump ahead:

Create minimal structure (domain folders + .claude/ system files) and mark complete.

For Session 1: Create folders, install rules, create alive.local.yaml with `onboarding_complete: true` (skip Session 2).
For Session 2: Create minimal ventures/experiments with default _brain/ files and mark complete.

---

## Edge Cases

**No ventures or experiments:**
```
That's fine — ALIVE works for any context.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Want me to create a starting point?",
    header: "Starter",
    options: [
      { label: "Personal venture", description: "For side projects and freelance" },
      { label: "Experiment space", description: "For exploring ideas" },
      { label: "Core only", description: "Just 02_Life/ and 03_Inputs/" }
    ],
    multiSelect: false
  }]
})
```

**Existing content found:**
```
[!] Found existing structure in this folder.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Existing content found. What do you want to do?",
    header: "Existing",
    options: [
      { label: "Add ALIVE on top", description: "Keep existing, add ALIVE structure" },
      { label: "Fresh start", description: "Archive existing, start clean" },
      { label: "Cancel", description: "Exit setup" }
    ],
    multiSelect: false
  }]
})
```

**alive.local.yaml exists but no onboarding fields:**
Treat as new user. Run Session 1 from Step 1 but preserve existing yaml fields.

**User runs onboarding while already in Session 2 location (cd'd into alive root):**
The rules are already loaded. Detect `onboarding_part: 1` and proceed to Session 2.

**First venture was actually an Experiment (user described it as a Venture in Session 1):**
In Session 2, after the Proof, offer to move it: "Should [name] be in Ventures or Experiments?"

---

## alive.local.yaml Schema (Complete Reference)

### After Session 1

```yaml
# ALIVE System Configuration
# Created by /alive:onboarding — Session 1
# Location: {alive-root}/.claude/alive.local.yaml

version: 2
system_version: "3.1.0"
onboarding_part: 1
created: "2026-02-10"

# System paths
alive_root: "/Users/will/Desktop/alive"

# User preferences
timezone: "Australia/Sydney"
theme: "vibrant"
working_style: "solo"
```

### After Session 2 (Complete)

```yaml
# ALIVE System Configuration
# Created by /alive:onboarding
# Location: {alive-root}/.claude/alive.local.yaml

version: 2
system_version: "3.1.0"
onboarding_complete: true
created: "2026-02-10"

# System paths
alive_root: "/Users/will/Desktop/alive"

# User preferences
timezone: "Australia/Sydney"
theme: "vibrant"
working_style: "solo"
```

### Field Reference

| Field | Type | Set by | Purpose |
|-------|------|--------|---------|
| `version` | integer | Onboarding | ALIVE framework version (always 2) |
| `system_version` | string | Onboarding / Upgrade | Plugin version installed. Compared against `plugin_version` in skill frontmatter. |
| `onboarding_part` | integer | Session 1 | Tracks partial onboarding. Removed when complete. |
| `onboarding_complete` | boolean | Session 2 | True when full onboarding is done. |
| `created` | string (date) | Onboarding | Date ALIVE was first set up. |
| `alive_root` | string (path) | Onboarding | Absolute path to ALIVE root directory. |
| `timezone` | string | Onboarding | User's timezone for date calculations. |
| `theme` | string | Onboarding | Visual theme: vibrant, minimal, or loud. |
| `working_style` | string | Onboarding | solo, small_team, or larger_org. |

---

## File Templates

**02_Life/_brain/status.md:**
```markdown
# Life Status

**Goal:** [From life goals input, or "Set your life goals"]
**Phase:** [Current life phase]
**Updated:** [DATE]

---

## Key People

See people/ for all contacts.

## State of Play

[Current life situation and focus]

## Priorities

[Most important life priorities right now]

## Blockers

[What's getting in the way, if anything]

## Next Milestone

[Next major life milestone or goal]
```

**Person file template (e.g., 02_Life/people/sarah.md):**
```markdown
# [Name]

**Relationship:** [relationship type]
**Added:** [DATE]

## Context
[To be filled as context accumulates]

## Notes
[Auto-populated from conversations]
```

---

## Related Skills

- `/alive:daily` — Morning entry point (most common next step)
- `/alive:work` — Focus on one venture, experiment, or life area
- `/alive:help` — Quick reference
- `/alive:upgrade` — For v1 → v2 migration (not fresh setup). Also handles version bumps.
- `/alive:migrate` — Import existing content
