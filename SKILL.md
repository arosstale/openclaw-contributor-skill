---
name: openclaw-contributor
description: Contribute bug fixes to openclaw/openclaw. Checks duplicates, formats with oxfmt, submits PRs with required template. Use when fixing OpenClaw issues.
---

# OpenClaw Contributor

Bug fix pipeline for openclaw/openclaw. Fork at `arosstale/openclaw`, cloned to `/tmp/openclaw-fork`. Remotes: `origin` = upstream, `fork` = ours.

## Rules

- **Check duplicates first**: `./scripts/checkdupe.sh ISSUE`. If exit 1, stop.
- **Stabilisation mode**: bug fixes only. No features, no refactors, no observability.
- **Format**: `pnpm exec oxfmt --write <files>` then `pnpm lint`.
- **PR body must include**: `lobster-biscuit`, `Fixes #NNNN`, Summary, Root Cause, Behavior Changes, Sign-Off.
- **Max 15 open PRs**. Check slots: `gh pr list --repo openclaw/openclaw --author arosstale --state open --json number --jq 'length'`
- **Respond to Greptile immediately**. Search the module for the same pattern — fix ALL instances, not just the one flagged.
- **Post-session audit**: `./scripts/audit.sh`

## Workflow

1. **Triage**: Read the issue. Skip if: external dep, macOS-only, deep lifecycle, >5 files, vague report, has competitor, recent maintainer commit in same area.
2. **Dupe check**: `./scripts/checkdupe.sh ISSUE_NUMBER`
3. **Analyze**: Find root cause. Find the reference implementation (canonical pattern). Search module for ALL buggy instances.
4. **Fix**:
   ```bash
   cd /tmp/openclaw-fork
   git fetch origin main
   git checkout -b fix/ISSUE-slug origin/main
   # implement minimal fix, match reference implementation
   pnpm exec oxfmt --write <files>
   pnpm lint
   git add <files>
   git commit -m "fix(scope): description

   Fixes #ISSUE"
   git push fork fix/ISSUE-slug
   ```
5. **Submit**: Final dupe check, then `gh pr create` with required body (see template below).
6. **Monitor**: Check Greptile within 5 min. Expand fix if pattern found. Amend + force-push.

## PR Body Template

```
## Summary
[What broke, why, what this fixes]

lobster-biscuit

Fixes #ISSUE

## Root Cause
[file:line — one sentence]

## Behavior Changes
| Scenario | Before | After |
|---|---|---|
| [case] | [broken] | [fixed] |

## Tests
- Format: oxfmt ✓
- Lint: oxlint ✓

## Sign-Off
- **Models used**: Claude Sonnet 4 (via pi coding agent)
- **Submitter effort**: [how you found root cause]
- **Agent notes**: AI-assisted.
```

## Merge Strategy

- **LIFO**: maintainers review most recently updated PRs. Rebase before merge windows: `./scripts/rebase.sh BRANCH`
- **Author batching**: Takhoffman batch-merged 6 PRs in 36 min. Get one noticed → cascade.
- **Merge windows**: Takhoffman ~00:30-02:15 UTC. steipete ~14:00-23:00 UTC.
- **Stale timer**: 5 days → stale label. 3 more → auto-close.

## Mistakes We Made

- `console.log()` in CLI → use `process.stdout.write()` (bypasses captured handlers)
- `groupPolicy ?? "open"` skipping `channels.defaults` → use full fallback chain
- Fixed 3 of 4 code paths → search module for ALL instances
- PR without `lobster-biscuit` → ignored by maintainers
- `npm run build` → use `pnpm lint` + `pnpm exec oxfmt`
