---
name: openclaw-contributor
description: "Contribute bug fixes to openclaw/openclaw. Triage issues, check duplicates, format with oxfmt, submit PRs with required template. Use when fixing OpenClaw issues."
---

# OpenClaw Contributor

Bug fix pipeline for `openclaw/openclaw`. Fork: `arosstale/openclaw`. Work dir: `/tmp/openclaw-fork`. Remotes: `origin` = upstream, `fork` = ours.

## Rules

- Check duplicates first: `{baseDir}/scripts/checkdupe.sh ISSUE`. Exit 1 = stop.
- Stabilisation mode: bug fixes only. No features, no refactors, no observability.
- Format: `pnpm exec oxfmt --write <files>` then `pnpm check`.
- PR body: use template at `{baseDir}/scripts/pr-template.md`. Must include `lobster-biscuit`.
- Max 15 open PRs. Check: `gh pr list -R openclaw/openclaw --author arosstale -s open --json number --jq length`
- Respond to Greptile immediately. Search the module for the same pattern — fix ALL instances.
- Post-session: `{baseDir}/scripts/audit.sh`

## Workflow

1. **Triage** — Read the issue. Skip if: external dep, macOS-only, deep lifecycle, >5 files, vague, has competitor, recent maintainer commit in same area.
2. **Dupe check** — `{baseDir}/scripts/checkdupe.sh ISSUE_NUMBER`
3. **Analyze** — Find root cause. Find the reference implementation. Search module for ALL buggy instances.
4. **Fix**:
   ```bash
   cd /tmp/openclaw-fork && git fetch origin main
   git checkout -b fix/ISSUE-slug origin/main
   # minimal fix, match reference implementation
   pnpm exec oxfmt --write <files> && pnpm check
   git add <files> && git commit -m "fix(scope): description

   Fixes #ISSUE"
   git push fork fix/ISSUE-slug
   ```
5. **Submit** — Final dupe check. `gh pr create` with body from `{baseDir}/scripts/pr-template.md`.
6. **Monitor** — Check Greptile within 5 min. Expand fix if pattern found. Amend + force-push.

## Merge Strategy

- **LIFO**: maintainers review most recently updated PRs. Rebase: `{baseDir}/scripts/rebase.sh BRANCH`
- **Author batching**: Takhoffman batch-merged 6 PRs in 36 min. Get one noticed → cascade.
- **Merge windows**: Takhoffman ~00:30-02:15 UTC. steipete ~14:00-23:00 UTC.
- **Stale timer**: 5 days → stale label. 3 more → auto-close.

## Mistakes We Made

- `console.log()` in CLI → `process.stdout.write()` (bypasses captured handlers)
- `groupPolicy ?? "open"` skipping `channels.defaults` → use full fallback chain
- Fixed 3 of 4 code paths → search module for ALL instances
- PR without `lobster-biscuit` → ignored
- `pnpm build` alone is not enough → use `pnpm check` + `pnpm exec oxfmt`
