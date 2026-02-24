# Anti-Patterns

10 rules. Don't break them.

---

## 1. No Orphan Files

Every file belongs in a folder with a README or `_brain/`. If you create a file, it lives inside a structure — never floating at root or in an unnamed directory.

## 2. No Work in 03_Inputs/

`03_Inputs/` is a buffer. Content arrives, gets triaged, gets routed OUT. Never create files, extract content, or do work inside `03_Inputs/`. Route to the correct unit first.

## 3. Always Archive, Never Delete

Move to `01_Archive/` mirroring the original path. No exceptions.

```
# Wrong
rm -rf 04_Ventures/old-venture/

# Right
mv 04_Ventures/old-venture/ 01_Archive/04_Ventures/old-venture/
```

## 4. Manifest After Create

Every new file gets a manifest entry immediately. No "I'll update the manifest later." If you created the file, update `_brain/manifest.json` in the same operation.

## 5. Handoffs Go to _working/sessions/

Pattern: `handoff-{session-id}-{date}.md`

Never put handoffs in `_brain/`, root, or random folders.

## 6. One Spec, Many References

Shared specs live in `rules/conventions.md`. Skills reference the spec — they don't duplicate it. If you find the same pattern described in 4 skills, extract it to conventions and point to it.

## 7. Don't Rename User's Files

Don't rename files the user has intentionally created and named — their documents, working drafts, content files.

**Exception:** When importing content to `_references/`, rename garbage filenames to the `YYYY-MM-DD-descriptive-name.ext` convention (e.g. `CleanShot 2026-02-06 at 14.32.07@2x.png` → `2026-02-06-competitor-landing.png`). See `rules/conventions.md` under "_references/ Structure" for the renaming convention. The original goes in `raw/` with the clean name.

## 8. Working Files Have Context in Name

Pattern: `[unit]_[context]_[name].ext`

Anyone reading the filename should know where it belongs without opening it.

## 9. Update Status on Phase Change

Don't leave "Starting" when you're "Building." Don't leave "Building" when you've launched. `_brain/status.md` reflects reality, not history.

## 10. Confirm Before External Actions

Any action that modifies state outside ALIVE requires explicit user confirmation before executing. This includes MCP tools, APIs, integrations — anything that sends, posts, creates, or deletes in an external service.

**Always ask:** "Do you confirm you want to [action]?"

```
# Wrong — auto-fires
mcp__slack__slack_post_message(channel, text)

# Right — confirm first
"Ready to post this to #general on Slack. Confirm?"
→ User: yes
→ Then send
```

**Applies to:** Sending emails, posting to Slack/Discord, creating GitHub issues/PRs, publishing content, making API calls that write data, any MCP tool that affects the outside world.

**Does NOT apply to:** Reading/fetching data, local file operations within ALIVE, search queries.

