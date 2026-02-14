---
name: openclaw-contributor
description: Contribute to OpenClaw responsibly. One issue at a time. Check for duplicates first. Verify code compiles. Never add to the PR flood.
---

# OpenClaw Contributor Skill

## HARD-WON RULES (9 merged, 38 closed — learned the hard way)

1. **CHECK FOR EXISTING PRs FIRST** — Before touching any code, run `commands/checkdupe.md`. If someone submitted first, STOP.
2. **ONE PR AT A TIME** — Finish one completely (including review feedback) before starting the next. Exception: batch-rebase for LIFO freshness is maintenance, not new work.
3. **FORMAT & LINT** — Run `pnpm exec oxfmt --write <files>` then `pnpm lint`. Never submit unformatted code.
4. **READ EVERY REVIEW COMMENT** — Address Greptile and maintainer feedback immediately. Greptile often finds real pattern bugs — expand your fix.
5. **CLOSE YOUR OWN BROKEN PRs** — If a PR has quality issues or is a duplicate, close it immediately with an honest comment.
6. **PR BODY REQUIREMENTS** — `lobster-biscuit` code word, `Fixes #NNNN`, Summary/Root Cause/Behavior Changes/Tests/Sign-Off sections.
7. **RESPOND TO ALL GREPTILE COMMENTS** — Reply inline. Search the module for the same pattern — the bug usually exists in more code paths than initially fixed.
8. **POST-SESSION AUDIT** — After each session, run `commands/audit.md` on ALL open PRs.
9. **15-PR HARD LIMIT** — Never exceed 15 open PRs. Track available slots.
10. **SKIP COMPLEX ISSUES** — External deps, macOS-only, deep lifecycle bugs, and issues with competitors are not worth the risk. See `commands/triage.md`.

## Commands

All command files live in `commands/`. Each is self-contained:

| Command | When to use |
|---|---|
| `checkdupe.md` | **ALWAYS FIRST** — before any work on any issue |
| `triage.md` | Evaluate if an issue is worth fixing |
| `analyze.md` | Deep root cause analysis after triage passes |
| `fix.md` | Implement and verify the fix |
| `submit.md` | Create the PR with proper template |
| `audit.md` | Post-session health check on ALL open PRs |
| `rebase.md` | Freshen PRs before merge windows (LIFO strategy) |
| `close.md` | Close broken/duplicate PRs honestly |

## Merge Strategy: LIFO + Author Batching

**Validated with 9 merges (Feb 2026):**

1. **LIFO**: Maintainers review most recently updated PRs first. Rebase before merge windows.
2. **Author Batching**: Takhoffman batch-merged 6 of our PRs in 36 minutes. Get one noticed -> cascade.
3. **Silent Merges = Trust**: All 6 batch-merged PRs had zero review comments.
4. **Merge Windows**: Takhoffman ~00:30-02:15 UTC. steipete ~14:00-23:00 UTC (peak 17-19).
5. **Stale Timer**: 5 days -> stale label. 3 more days -> auto-close.

## Stabilisation Mode

OpenClaw is in **STABILISATION MODE** — bug fixes only. No features, no refactors, no observability. cpojer closed an observability PR instantly while merging a performance fix in the same session.

## Issue Skip Criteria

Skip issues that match ANY of these:
- **External dependency** — bug is in pi-ai SDK, grammY, a provider API, etc.
- **macOS/iOS only** — we cannot test it
- **Deep lifecycle** — session management, multi-agent orchestration, compaction
- **Has competitor** — someone already submitted or commented with intent to fix
- **Vague report** — "it crashes" with no reproduction steps
- **Recent maintainer commit** — the area is actively being changed

## Anti-Patterns (real mistakes we made)

| What we did | What we should have done |
|---|---|
| Created 10 PRs in one session | Created 1, verified it, then the next |
| Never checked existing PRs | Searched first, found 5 duplicates |
| Used `npm run build` | Used `pnpm lint` + `pnpm exec oxfmt` |
| Fixed 3 of 4 code paths | Searched module for ALL instances of the pattern |
| Left Greptile comment unresponded | Replied inline within minutes |
| PR without linked issue | Always include `Fixes #NNNN` |
| PR without lobster-biscuit | Required by maintainers — PR ignored without it |
| Used `console.log()` in CLI tool | Used `process.stdout.write()` (bypasses captured handlers) |
| Wrong content format (string vs array) | Checked how surrounding code handles it |
| Config without defaults fallback | Found reference implementation (provider.ts) and matched it |

## Config

```yaml
target_repo: openclaw/openclaw
fork_repo: arosstale/openclaw
fork_remote: fork
work_dir: /tmp/openclaw-fork
format_tool: oxfmt  # via pnpm exec oxfmt --write
lint_tool: oxlint   # via pnpm exec oxlint
max_open_prs: 15
```
