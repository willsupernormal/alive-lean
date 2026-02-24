# Experiments Domain Template

**Domain:** 05_Experiments/
**Purpose:** Testing grounds, no revenue model yet

---

## Structure

```
05_Experiments/
└── [name]/           # Each experiment is a unit
    ├── .claude/
    │   └── CLAUDE.md # Identity
    ├── _brain/
    │   ├── status.md
    │   ├── tasks.md
    │   ├── insights.md
    │   ├── changelog.md
    │   └── manifest.json
    ├── _working/     # Drafts
    ├── _references/  # Reference materials
    └── [areas]/      # Optional folders
```

---

## What Makes an Experiment

Experiments are:
- Ideas being tested
- Ideas without a clear revenue model
- Explorations that might become ventures
- Learning exercises

**Experiments graduate to ventures** when they have:
- Validated demand
- Clear revenue model
- Commitment to build

---

## CLAUDE.md Template

```markdown
# [Experiment Name]

**Type:** Experiment
**Phase:** [Exploring | Validating | Pivoting | Graduating | Abandoned]
**Created:** [DATE]

---

## Hypothesis

[What are we testing? What do we believe is true?]

---

## Success Criteria

[How do we know if this experiment succeeded?]
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

---

## Constraints

- **Time:** [Deadline or timeframe]
- **Budget:** [What can we spend?]
- **Scope:** [What's in/out?]

---

## State

Everything current lives in `_brain/`:
- `status.md` — Current phase
- `tasks.md` — What to do next
- `insights.md` — Domain knowledge
- `changelog.md` — History
```

---

## status.md Template

```markdown
# Status

**Goal:** [What are you testing?]
**Phase:** Starting
**Updated:** [DATE]

---

## Key People

## State of Play

## Priorities

## Blockers

## Next Milestone

## Hypothesis

## Evidence Gathered

## Decision Point
```

---

## Experiment Phases

| Phase | Meaning |
|-------|---------|
| **Exploring** | Initial research, ideation |
| **Validating** | Testing hypothesis with real data |
| **Pivoting** | Changing direction based on evidence |
| **Graduating** | Success! Moving to 04_Ventures/ |
| **Abandoned** | Didn't work, archive insights |

---

## Graduating to Venture

When an experiment succeeds:

1. Extract insights to preserve
2. Create new venture with `/alive:new`
3. Migrate relevant content with `/alive:migrate`
4. Archive experiment with `/alive:archive`
5. Reference experiment in venture's changelog

```markdown
# In 04_Ventures/new-venture/_brain/changelog.md

## [DATE] — Created from Experiment

Graduated from 05_Experiments/[name]/.
Original hypothesis: [what we tested]
Key insights: [what we learned]
```

---

## Archiving Failed Experiments

When an experiment doesn't work:

1. Document why in status.md (final update)
2. Log key insights to insights.md
3. Consider: Are insights valuable elsewhere?
4. Archive with `/alive:archive`

**Insights are gold.** A failed experiment that generates valuable insights is still successful.

---

## Example Areas

```
05_Experiments/[name]/
├── research/         # Market research, competitor analysis
├── prototypes/       # Quick builds, MVPs
├── interviews/       # User research
└── metrics/          # Data, analytics
```

---

## Notes

- Keep experiments lightweight
- Time-box experiments (set deadlines)
- Document domain knowledge religiously
- Failed experiments are valuable (if you capture insights)
