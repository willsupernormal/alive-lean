# Intent Routing

Route user intent to skills. Match INTENT, not keywords. People phrase things differently.

**If uncertain, ask.** Never guess wrong.

---

## How This Works

1. User says something
2. Match their intent to a skill using the tables below
3. Invoke the skill
4. If unclear between two skills, ask: "Are you wanting to X, or Y?"

---

## Skill Triggers by Prompting Style

### /alive:daily — Morning Dashboard

See everything across all units. The heartbeat.

| Style | Examples |
|-------|----------|
| **Command** | "daily", "dashboard", "morning", "overview", "show me everything" |
| **Question** | "what's happening?", "what should I work on?", "what's the state of things?" |
| **Statement** | "let's go", "start my day", "time to work" |
| **Casual** | "morning", "let's see", "what's up" |

---

### /alive:work — Start Work

Load context, check what's in progress, begin working.

| Style | Examples |
|-------|----------|
| **Command** | "work on X", "open X", "load X", "start X", "focus on X" |
| **Question** | "what's happening with X?", "where are we with X?", "what's the status of X?", "how's X going?" |
| **Statement** | "let's work", "time to work", "I want to work on X", "need to focus on X" |
| **Casual** | "whatsup", "what's up", "continue", "resume", "pick up where we left off", "back to it" |

---

### /alive:save — End Session

Log session to changelog, update state, wrap up.

| Style | Examples |
|-------|----------|
| **Command** | "save", "wrap up", "end session", "log this", "commit", "done for now" |
| **Question** | "can you save this?", "should we wrap up?", "time to save?" |
| **Statement** | "I'm done for now", "that's it for today", "finished for now", "wrapping up" |
| **Casual** | "brb", "gotta go", "peace", "stepping away", "taking a break" |

---

### /alive:new — Create Venture, Experiment, or Life Area

Scaffold a new venture, experiment, life area, or folder.

| Style | Examples |
|-------|----------|
| **Command** | "create X", "new venture", "new experiment", "add a venture", "set up X" |
| **Question** | "can you create X?", "how do I add a new venture?", "can we set up X?" |
| **Statement** | "I'm starting something new", "need a new venture", "want to add X" |
| **Casual** | "new thing", "add X", "spin up X" |

---

### /alive:capture — Capture Context

Capture any content into ALIVE — quick notes, emails, transcripts, articles, decisions, anything worth preserving.

| Style | Examples |
|-------|----------|
| **Command** | "capture this", "note this", "remember this", "process this", "digest this" |
| **Question** | "can you capture that?", "should we note this?", "what should I do with this?" |
| **Statement** | "I learned something", "had a call with X", "just decided X", "FYI", "here's an email", "from my call" |
| **Casual** | "note", "fyi", "btw", "oh also", "quick note", "here's some context" |
| **Paste** | User pastes external content (email, transcript, article, Slack messages) |

---

### /alive:recall — Search Past Context

Find past decisions, sessions, context across the system.

| Style | Examples |
|-------|----------|
| **Command** | "find X", "search for X", "look up X", "recall X", "when did we X" |
| **Question** | "what did we decide about X?", "when did we discuss X?", "where's that thing about X?" |
| **Statement** | "I need to find X", "looking for X", "trying to remember X" |
| **Casual** | "where's X", "that thing about X", "remember when we X" |

---

### /alive:migrate — Bulk Import Context

Import existing content, transcripts, documents into ALIVE structure.

| Style | Examples |
|-------|----------|
| **Command** | "migrate X", "import X", "bring in X", "load from X", "bulk add" |
| **Question** | "can you import this?", "how do I migrate my stuff?", "can we bring this in?" |
| **Statement** | "I have content to import", "need to migrate from X", "want to bring in X" |
| **Casual** | "import", "bring in", "load these" |

---

### /alive:archive — Move to Archive

Move completed/inactive items to archive.

| Style | Examples |
|-------|----------|
| **Command** | "archive X", "move X to archive", "shelve X", "close X", "deactivate X" |
| **Question** | "can we archive this?", "should X go to archive?", "is X done?" |
| **Statement** | "X is done", "finished with X", "don't need X anymore", "X is complete" |
| **Casual** | "done with X", "shelve it", "put it away" |

---

### /alive:digest — Process Inputs

Triage 03_Inputs/, extract and route content to appropriate locations.

| Style | Examples |
|-------|----------|
| **Command** | "process inbox", "process inputs", "digest", "triage", "handle inbox", "sort these" |
| **Question** | "what's in inbox?", "what's in inputs?", "anything to process?", "should we triage?" |
| **Statement** | "need to process inbox", "inputs is full", "time to triage" |
| **Casual** | "inbox", "inputs", "what came in", "sort it out" |

**Note:** Users may say "inbox" even though the folder is `03_Inputs/`. Both trigger words work.

---

### /alive:sweep — Clean Up Stale Context

Audit system for stale content, suggest cleanup.

| Style | Examples |
|-------|----------|
| **Command** | "sweep", "clean up", "audit", "check for stale", "maintenance" |
| **Question** | "anything stale?", "what needs cleanup?", "how old is my context?" |
| **Statement** | "system feels cluttered", "need to clean up", "time for maintenance" |
| **Casual** | "spring cleaning", "tidy up", "housekeeping" |

---

### /alive:help — Quick Reference

Get help with ALIVE, understand the system.

| Style | Examples |
|-------|----------|
| **Command** | "help", "show commands", "what can you do", "list skills" |
| **Question** | "how does X work?", "what's the command for X?", "how do I X?" |
| **Statement** | "I'm confused", "don't understand X", "need help with X" |
| **Casual** | "?", "huh", "lost", "explain" |

---

### /alive:onboarding — First-Time Setup

Guide new users through initial setup.

| Style | Examples |
|-------|----------|
| **Command** | "setup", "get started", "initialize", "onboarding" |
| **Question** | "how do I start?", "what do I do first?", "new here, where to begin?" |
| **Statement** | "I'm new", "just installed", "first time using this" |
| **Casual** | "new here", "getting started", "show me around" |

---

### /alive:revive — Resume Old Session

Pick up a specific past session with full context.

| Style | Examples |
|-------|----------|
| **Command** | "revive", "resume session X", "pick up where I left off on X" |
| **Question** | "can I resume that session?", "where did we leave off?" |
| **Statement** | "I want to continue that work", "back to the session from yesterday" |
| **Casual** | "pick up", "get me back", "that thing from last time" |

---

### /alive:upgrade — Update System

Sync rules, structure, and skills to latest version.

| Style | Examples |
|-------|----------|
| **Command** | "upgrade", "update", "sync", "update system" |
| **Question** | "is there an update?", "am I on the latest version?" |
| **Statement** | "need to upgrade", "system seems outdated" |
| **Casual** | "update", "sync up" |

**Note:** Also triggers automatically when version mismatch is detected by other skills.

---

## Disambiguation

When intent is unclear between skills:

### do vs capture-context
```
User: "about acme..."

Ask: "Are you wanting to start working on acme, or capture some context about it?"
```

### save vs capture-context
```
User: "log this"

Ask: "Do you want to capture this specific context, or wrap up the whole session?"
```

### recall vs do
```
User: "the acme venture"

Ask: "Are you looking for past context about acme, or wanting to work on it now?"
```

---

## System Suggestions

Proactively suggest skills based on system state:

| Condition | Suggest |
|-----------|---------|
| Session start (first message) | "Welcome back. `/alive:daily` to see everything, or `/alive:work` to jump in?" |
| 03_Inputs/ has items | "You have X items in 03_Inputs/. `/alive:digest`?" |
| _brain/ is stale (>2 weeks) | "X hasn't been updated in Y days. `/alive:sweep`?" |
| No recent save | "You haven't saved in a while. `/alive:save`?" |
| User shares decision/insight | "Want me to capture that? `/alive:capture`" |
| Version mismatch detected | "[!] System update available. `/alive:upgrade`?" |
| Ongoing thread from previous session | "You have an ongoing thread from yesterday. `/alive:revive`?" |
| Work is done / completed | "Looks like X is complete. `/alive:archive`?" |

---

## Intent Matching Rules

1. **Match intent, not keywords** — "whatsup" = work mode, not a greeting
2. **Context matters** — "save" after work = save session; "save" with content = capture
3. **Confirm if uncertain** — Ask before invoking wrong skill
4. **Default to asking** — Better to ask than guess wrong
5. **One skill at a time** — Don't chain without confirmation
