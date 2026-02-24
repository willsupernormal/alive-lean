---
name: alive-lean
version: 4.0.0
description: Persistent memory for Claude Code — lean edition. No manifest, less bloat, same power.
author: Will Bainbridge
---

# ALIVE Lean

Context infrastructure for Claude Code — stripped back to first principles. Same ALIVE framework, less overhead.

## What Changed from v3

- **Manifest removed** — no more manifest.json bloating every operation
- **Rules trimmed** — conventions and UI standards condensed to essentials
- **Less context consumed** — skills load faster, leave more room for actual work

## What This Does

- Gives Claude persistent memory across sessions
- Organizes your context into domains (Life, Ventures, Experiments)
- Provides skills for capturing, recalling, and managing context
- Logs all changes for full traceability

## Skills Included

| Skill | Purpose |
|-------|---------|
| `/alive:work` | Start a work session |
| `/alive:save` | End session, log progress |
| `/alive:new` | Create venture, experiment, life area, or project |
| `/alive:capture` | Capture context into ALIVE |
| `/alive:recall` | Search past context |
| `/alive:daily` | Morning dashboard |
| `/alive:archive` | Move completed items to archive |
| `/alive:digest` | Process inputs |
| `/alive:sweep` | Audit and clean stale content |
| `/alive:help` | Get guidance |
| `/alive:onboarding` | First-time setup wizard |

## License

MIT
