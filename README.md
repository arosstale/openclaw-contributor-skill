# OpenClaw Contributor Skill

A Pi skill for contributing to [OpenClaw](https://github.com/openclaw/openclaw) responsibly.

## Track Record

- **9 PRs merged** (including 6 batch-merged by Takhoffman in 36 min)
- **38 PRs closed** (duplicates, broken code, or noise — self-audited)
- **8 PRs open** (all CI green, all compliant)

## What This Skill Does

Guides you through fixing ONE issue at a time:

1. **Triage** — Is this issue worth fixing? (`commands/triage.md`)
2. **Check duplicates** — Anyone already working on this? (`commands/checkdupe.md`)
3. **Analyze** — Find root cause + all pattern instances (`commands/analyze.md`)
4. **Fix** — Minimal change, format, lint (`commands/fix.md`)
5. **Submit** — PR with required template (`commands/submit.md`)
6. **Audit** — Post-session health check on all PRs (`commands/audit.md`)
7. **Rebase** — Keep PRs fresh for LIFO queue (`commands/rebase.md`)
8. **Close** — Honest cleanup of broken PRs (`commands/close.md`)

## Key Strategy

- **LIFO**: Maintainers review most recently updated PRs first
- **Author Batching**: Once noticed, maintainers batch-merge your PRs
- **Quality > Volume**: Silent merges (no review comments) = highest trust
- **Stabilisation Mode**: Bug fixes only — no features, no refactors

## Hard Rules

1. Check for existing PRs FIRST — before any code
2. ONE PR at a time — finish before starting next
3. `pnpm lint` MUST pass
4. Every PR needs `lobster-biscuit`, `Fixes #NNNN`, and Sign-Off
5. Respond to ALL Greptile comments — expand fix if pattern found
6. Close broken PRs immediately
7. Never exceed 15 open PRs
