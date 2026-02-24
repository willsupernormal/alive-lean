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
4. **Update parent changelog** if applicable

---

## README Template

Use template at `templates/working-folder-readme.md`.

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

## Naming

Lowercase with hyphens. Describe the project, not the file type.

---

## Proactive Suggestions

Claude should notice when evolution is appropriate and offer to create a proper folder.

---

## Summary

| Question | Answer |
|----------|--------|
| When to evolve? | 3+ related files, or logical project grouping |
| Where to put it? | Sibling to _working/, or appropriate folder |
| What's required? | README.md explaining the project |
| What stays in _working/? | Truly temporary, single-file drafts |
