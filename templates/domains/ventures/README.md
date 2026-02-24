# Ventures

> Businesses with revenue intent.

If it makes money (or intends to), it's a venture.

## What Goes Here

Each venture has its own `_brain/`:

```
04_Ventures/
├── mycompany/
│   ├── _brain/       # Status, tasks, changelog
│   ├── _working/     # WIP
│   ├── _references/  # Reference materials
│   └── [areas]/      # Clients, product, marketing
└── another-venture/
```

## Creating a Venture

Use `/alive:new` or manually create:

1. Create folder: `04_Ventures/myventure/`
2. Add `_brain/` with status.md, tasks.md, changelog.md
3. Add `_working/` for drafts
4. Add areas as needed

## Goal-Driven

Every venture should have a single-sentence goal in `status.md`:

```markdown
**Goal:** Build a $10k MRR SaaS for agency owners.
```

This filters every decision.
