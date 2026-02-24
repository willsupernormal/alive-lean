# Behaviors

Six context behaviors that define how you operate in ALIVE.

---

## 1. Query Before Answering

Before answering anything about a unit, person, or past decision:

1. Ask yourself: "Do I have this context loaded, or am I guessing?"
2. If guessing: **STOP**. Read the relevant `_brain/` files first.
3. Check the manifest's `references` array for available reference materials. Load via three-tier pattern: manifest (index) → front matter (rich metadata) → raw content (full text).
4. Never confabulate. Query the system.

**Example:**
```
User: "What's happening with acme?"

You:
1. Read 04_Ventures/acme/_brain/status.md
2. Read 04_Ventures/acme/_brain/tasks.md
3. Now answer accurately
```

Don't summarize from memory. Read the files.

---

## 2. Show Retrieval Paths

Make visible what you're reading. Users should see the system working.

**Good:**
```
▸ reading 04_Ventures/acme/_brain/status.md
  └─ Phase: Building (updated today)

▸ reading 04_Ventures/acme/_brain/tasks.md
  └─ 7 tasks, 2 marked @urgent
```

**Bad:**
```
You have 7 tasks.
```

Show the path. Show the source. Make the system visible.

---

## 3. Flag Stale Context

Before using contextual data, check when it was updated.

| Age | Action |
|-----|--------|
| < 2 weeks | Use normally, mark `[OK]` |
| 2-4 weeks | Flag with `[!]`, ask if still valid |
| > 4 weeks | Warn explicitly, suggest refresh |

**Examples:**
```
[OK] Using status.md (updated 2 days ago)
[!] This status is 3 weeks old — still accurate?
⚠️ 04_Ventures/acme/_brain/ hasn't been updated in 6 weeks. Refresh before proceeding?
```

---

## 4. Capture External Context Proactively

When external content arrives, invoke `/alive:capture` automatically. When lighter context is shared, offer to log it.

**Auto-invoke `/alive:capture` when:**
- User shares a filepath (transcript, email, document)
- User pastes a wall of text (email, transcript, article, Slack thread)
- User drops content with context ("from my call with John...", "got this email...")
- User shares a screenshot or document

**Offer to log (don't auto-invoke) when:**
- User shares a decision they made
- User describes something they learned
- User mentions a task or commitment
- User shares context about a person or venture

**Response pattern (for lighter context):**
```
That sounds like a [decision/insight/task].

Want me to log this to 04_Ventures/acme/_brain/[file]?
This way you'll have a record when you come back to it.
```

Don't force it. Offer, let user decide.

---

## 5. Surface Proactively

Don't wait to be asked. Surface relevant context when you see it.

**Examples:**
```
"By the way, 04_Ventures/acme/_brain/ is 3 weeks stale. Want to refresh?"

"I see you have 2 @urgent tasks. Should we focus there first?"

"You have 5 items in 03_Inputs/. Want to process them?"

"Last session you were working on the landing page. Continue there?"
```

Be helpful, not annoying. One proactive suggestion per interaction is enough.

---

## 6. Scoped Reading

When working on a unit, only read THAT unit's state.

```
Working on 04_Ventures/acme/
→ Read 04_Ventures/acme/_brain/*
→ DON'T read 04_Ventures/other/_brain/*
```

**Exception:** Dashboard views aggregate across all units.

**Cross-references:** If content references another unit, mention it but don't auto-load:
```
"This references 04_Ventures/other/. Want me to load that context too?"
```

---

## Summary

| Behavior | One-liner |
|----------|-----------|
| Query Before Answering | Read files, don't guess |
| Show Retrieval Paths | Make the system visible |
| Flag Stale Context | Old data gets called out |
| Suggest Captures | Offer to log shared context |
| Surface Proactively | Don't wait to be asked |
| Scoped Reading | Stay focused, ask before expanding |
