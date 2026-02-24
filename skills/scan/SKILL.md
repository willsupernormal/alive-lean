---
user-invocable: false
description: Scan Claude Code session history to extract patterns, preferences, and past ventures/experiments for personalized ALIVE setup. Called by onboarding when user opts in to session analysis.
plugin_version: "3.1.0"
---

# Power User Install

Scan existing Claude Code session history to build a user profile. Called by `/alive:onboarding` when user opts in.

## UI Treatment

Uses the **ALIVE Shell** — Tier 3: Utility.

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · scan                           [unit-name]       │
│  ──────────────────────────────────────────────────────── │
│  [Scan results + structure overview]                      │
│  ──────────────────────────────────────────────────────── │
│  [Stats]                                                  │
╰──────────────────────────────────────────────────────────╯
```

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## When Invoked

Called internally by onboarding skill when:
- User is an existing Claude Code user
- User opts in to "scan my session history"

**Not directly invocable.** Users trigger this through onboarding.

---

## What It Does

1. Find session transcripts in `~/.claude/projects/`
2. Dispatch agents to extract patterns across sessions
3. Build user profile with discovered context
4. Save to `.claude/state/user-profile.md`
5. Return to onboarding with results

---

## Step 1: Locate Sessions

Find the user's Claude Code sessions:

```bash
# Session transcripts live here
ls ~/.claude/projects/*/

# Each project has session files
# Format: [session-id].jsonl
```

**Output:** List of session files with timestamps.

---

## Step 2: Sample Recent Sessions

Don't analyze everything — sample strategically:

| Session Age | Action |
|-------------|--------|
| Last 7 days | Analyze all |
| 7-30 days | Sample 5 most recent |
| 30+ days | Skip (too stale) |

**Target:** 10-15 sessions max for reasonable analysis time.

---

## Step 3: Dispatch Extraction Agents

Run 3 parallel agents over the sampled sessions:

### Agent 1: Ventures, Experiments & Life Areas

```
Read the session transcripts at [PATHS]

Extract all ventures, experiments, and life areas the user works on:
- Names and types (web app, CLI tool, content, etc.)
- Technologies used (languages, frameworks, tools)
- Recurring themes or domains
- Any named ventures, experiments, or areas

Format as a structured list with frequency counts.
```

### Agent 2: Work Patterns

```
Read the session transcripts at [PATHS]

Analyze the user's work patterns:
- How do they typically start sessions?
- What tasks do they commonly work on?
- Do they prefer planning first or diving in?
- How verbose or terse are their requests?
- Any recurring pain points or frustrations?

Format as observations with evidence.
```

### Agent 3: Preferences & Style

```
Read the session transcripts at [PATHS]

Extract user preferences and communication style:
- Preferred terminology or naming conventions
- Tool preferences (git workflow, testing approach, etc.)
- Communication style (direct, detailed, casual)
- Things they explicitly like or dislike
- Any stated goals or priorities

Format as a profile with specific examples.
```

---

## Step 4: Synthesize Results

Combine agent outputs into a user profile:

```markdown
# User Profile

**Generated:** [DATE]
**Sessions analyzed:** [COUNT]

## Ventures & Experiments Discovered

| Name | Type | Technologies | Frequency |
|---------|------|--------------|-----------|
| [name] | [type] | [tech] | [count] sessions |

## Work Patterns

- [Pattern 1 with evidence]
- [Pattern 2 with evidence]

## Preferences

- **Communication:** [style]
- **Workflow:** [approach]
- **Tools:** [preferences]

## Suggested ALIVE Structure

Based on your history, consider:
- 04_Ventures/[venture1]/ — [reason]
- 04_Ventures/[venture2]/ — [reason]
- 05_Experiments/[experiment]/ — [reason]

## Notes for Claude

When working with this user:
- [Observation 1]
- [Observation 2]
```

---

## Step 5: Save Profile

Write to `.claude/state/user-profile.md`:

```
▸ saving user profile...
  └─ .claude/state/user-profile.md

✓ Profile saved. Found:
  - [X] ventures/experiments across [Y] domains
  - Work style: [summary]
  - Suggested structure: [summary]
```

---

## Step 6: Return to Onboarding

Return control to onboarding with summary:

```
Analysis complete.

Found [X] ventures/experiments in your history:
- [name1] ([type])
- [name2] ([type])
- [name3] ([type])

Work style: [brief summary]

This context will inform your ALIVE setup. Continuing onboarding...
```

---

## Privacy Considerations

- **Local only** — All analysis happens locally
- **No transmission** — Nothing leaves the machine
- **User control** — Opt-in only, can delete profile anytime
- **Transparent** — Show what was discovered

---

## Error Handling

| Error | Response |
|-------|----------|
| No sessions found | "No Claude Code history found. Skipping analysis." |
| Sessions unreadable | "Couldn't read some sessions. Proceeding with available data." |
| Analysis timeout | "Analysis taking too long. Saving partial results." |
| Empty results | "Couldn't extract patterns. Starting fresh setup." |

---

## Output Files

| File | Purpose |
|------|---------|
| `.claude/state/user-profile.md` | Persistent user profile |

This profile is referenced by:
- Onboarding (for personalized setup suggestions)
- Daily (for context-aware suggestions)
- Any skill that benefits from user context

---

## Integration with Onboarding

Onboarding calls this skill like:

```
User opts in to session analysis
→ Invoke scan
→ Wait for completion
→ Read .claude/state/user-profile.md
→ Use profile to personalize remaining onboarding
→ Suggest ALIVE structure based on discovered ventures and experiments
```

---

## Step 7: Configure Sync Scripts (Optional)

After profile analysis, offer to set up external sync sources:

```
▸ external sync setup

Do you want to sync content from external sources into ALIVE?

Available integrations:
[1] Slack — Sync messages/threads to 03_Inputs/
[2] Gmail — Sync important emails to 03_Inputs/
[3] Skip — Set up later
```

**If user selects integrations:**

1. Create `.claude/scripts/` folder if needed
2. Copy sync script templates
3. Configure `alive.local.yaml` at ALIVE root:

```yaml
# alive.local.yaml
theme: vibrant
sync:
  slack: .claude/scripts/slack-sync.mjs
  gmail: .claude/scripts/gmail-sync.mjs
```

4. Prompt user for credentials/API keys (stored in `.env` or system keychain)

**Script templates location:** Bundled with ALIVE plugin, copied on setup.

**Daily integration:** Once configured, `/alive:daily` will run sync scripts before showing dashboard.

---

## Notes

- This skill is expensive (reads many files, dispatches agents)
- Only run once during initial setup
- Profile can be regenerated with `/alive:onboarding --rescan`
- Keep analysis under 2 minutes to avoid user frustration
- Sync scripts are optional power-user features

