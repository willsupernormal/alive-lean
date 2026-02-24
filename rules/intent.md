# Intent Routing

Route user intent to skills. Match INTENT, not keywords. If uncertain, ask — never guess wrong.

---

## Non-Obvious Triggers

### capture

Users don't always say "capture." Watch for:
- **Paste detection:** User drops a wall of text (email, transcript, Slack thread)
- **Implicit sharing:** "FYI", "here's an email", "from my call with John...", "got this email"
- **Context sharing:** "I decided X", "I learned X", "here's some context"

### digest

Users say "inbox" but the folder is `03_Inputs/`. Both trigger words work. Also: "what came in", "anything to process", "sort these"

### revive

Easily confused with work. Revive = resume a SPECIFIC past session with context extraction. Work = start/continue working on a unit.
- "Pick up where I left off" → revive
- "Work on acme" → work

---

## Disambiguation

| Intent A | Intent B | Trigger | Ask |
|----------|----------|---------|-----|
| work | capture | "about acme..." | "Working on acme, or sharing context about it?" |
| save | capture | "log this" | "Capture this specific context, or wrap the whole session?" |
| recall | work | "the acme venture" | "Looking for past context, or wanting to work on it?" |
