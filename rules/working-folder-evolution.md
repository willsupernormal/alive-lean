# Working Folder Evolution

When `_working/` accumulates related files, evolve them into proper folders.

---

## The Principle

`_working/` is a staging area, not a permanent home. When multiple related files accumulate around a single project or concept, they should graduate into a proper folder with a README.

---

## When to Evolve

**Trigger conditions:**

| Condition | Evolve? |
|-----------|---------|
| 3+ related files with shared prefix | Yes |
| Logical project grouping (even 2 files) | Yes |
| Files versioned v1, v2, v3... | Yes |
| Single temporary draft | No |
| Unrelated files that happen to coexist | No |

**Signs a folder is ready to evolve:**
- Files share a common prefix (`acme_landing-*`)
- Files represent different aspects of one project (draft, notes, assets)
- You're creating version numbers (v1, v2, v3)
- You keep adding to the same project

---

## How to Evolve

### Before (cluttered _working/)

```
_working/
├── acme_landing-page-v1.md
├── acme_landing-page-v2.md
├── acme_landing-page-notes.md
├── acme_landing-page-copy.md
├── acme_random-draft.md          # Unrelated, stays
```

### After (evolved structure)

```
landing-page/
├── README.md                      # Explains the project
├── v1.md
├── v2.md
├── notes.md
├── copy.md

_working/
├── acme_random-draft.md          # Still in progress
```

### Steps

1. **Create the folder** at the appropriate level (usually sibling to `_working/`)
2. **Add README.md** using the template below
3. **Move files** and simplify names (drop the prefix)
4. **Update manifest.json** if it exists

---

## README Template

Every evolved folder gets a README that explains what it is:

```markdown
# [Project Name]

**Purpose:** [One sentence: what is this project?]
**Status:** [Draft | Active | Complete | On Hold]
**Created:** [DATE]

---

## Contents

| File | Description |
|------|-------------|
| `v1.md` | Initial draft |
| `v2.md` | Revised after feedback |
| `notes.md` | Research and reference notes |
| `copy.md` | Marketing copy drafts |

---

## Context

[2-3 sentences of context. Why does this exist? What problem does it solve? Any constraints or decisions?]

---

## Next Steps

- [ ] Outstanding tasks for this project
```

---

## Examples

### Example 1: Landing Page Project

**Before:**
```
04_Ventures/acme/_working/
├── acme_landing-v0.html
├── acme_landing-v1.html
├── acme_landing-notes.md
├── acme_landing-copy.md
```

**After:**
```
04_Ventures/acme/landing-page/
├── README.md
├── v0.html
├── v1.html
├── notes.md
├── copy.md
```

---

### Example 2: Client Proposal

**Before:**
```
04_Ventures/acme/_working/
├── acme_globex_proposal-draft.md
├── acme_globex_proposal-v1.pdf
├── acme_globex_scope.md
├── acme_globex_pricing.md
```

**After:**
```
04_Ventures/acme/clients/globex/proposal/
├── README.md
├── draft.md
├── v1.pdf
├── scope.md
├── pricing.md
```

---

### Example 3: Content Series

**Before:**
```
04_Ventures/acme/_working/
├── acme_linkedin_ai-series-1.md
├── acme_linkedin_ai-series-2.md
├── acme_linkedin_ai-series-3.md
├── acme_linkedin_ai-series-outline.md
```

**After:**
```
04_Ventures/acme/content/linkedin/ai-series/
├── README.md
├── outline.md
├── post-1.md
├── post-2.md
├── post-3.md
```

---

## When NOT to Evolve

Keep files in `_working/` when:

| Situation | Why |
|-----------|-----|
| Single temporary draft | Not a project yet |
| Scratch notes | Will be deleted soon |
| One-off experiments | No related files expected |
| Truly in-progress work | Still shaping, not ready to organize |

**The test:** Will there be more files? Is this a project? If no to both, leave it.

---

## Naming the Evolved Folder

Choose a name that:
- Describes the project, not the file type
- Is lowercase with hyphens
- Could become a conversation reference

| Good | Bad |
|------|-----|
| `landing-page/` | `landing-page-files/` |
| `proposal/` | `globex-proposal-docs/` |
| `ai-series/` | `linkedin-posts/` |

---

## Proactive Suggestions

Claude should notice when evolution is appropriate:

```
I notice you have 4 related files in _working/ for the landing page project:
- acme_landing-v0.html
- acme_landing-v1.html
- acme_landing-notes.md
- acme_landing-copy.md

Want me to evolve these into a proper landing-page/ folder with a README?
```

---

## Summary

| Question | Answer |
|----------|--------|
| When to evolve? | 3+ related files, or logical project grouping |
| Where to put it? | Sibling to _working/, or appropriate folder |
| What's required? | README.md explaining the project |
| What stays in _working/? | Truly temporary, single-file drafts |
