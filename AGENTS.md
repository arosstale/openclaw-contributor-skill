# Agent Rules

## The One Rule

**Check for existing PRs before doing anything.** If someone already submitted a fix, move on.

## Before ANY Fix

1. Run `commands/checkdupe.md` — uses timeline API for cross-referenced PRs (most reliable)
2. Read the issue completely (title, body, all comments)
3. Run `commands/triage.md` — skip external deps, macOS-only, deep lifecycle
4. Trace the code to the root cause
5. **Find the reference implementation** — search for the canonical pattern and match it
6. **Search the module for ALL instances** of the buggy pattern, not just the one in the issue

## During Fix

1. Make minimal changes
2. Follow patterns from surrounding code
3. `pnpm exec oxfmt --write <files>` — format first
4. `pnpm exec oxlint <files>` — lint check
5. `pnpm lint` — full lint MUST pass
6. Review own diff for common mistakes:
   - Wrong content format (string vs `{type, text}` array)
   - Missing config fallback chain (`channels.defaults.X`)
   - `console.log()` where `process.stdout.write()` needed
   - Non-exported imports
   - Unintended behavior changes

## After Fix

1. Final duplicate check before submitting (competitors appear fast)
2. PR body MUST include: `lobster-biscuit`, `Fixes #NNNN`, Summary, Root Cause, Behavior Changes, Sign-Off
3. Check Greptile feedback within minutes
4. If Greptile finds pattern inconsistency -> expand fix to ALL instances in module
5. Reply to ALL Greptile inline comments
6. Run `commands/audit.md` on all open PRs

## Common Mistakes We Made (real examples)

- **Wrong content format**: Messages are `{content: [{type: "text", text: "..."}]}`, not `{content: "string"}`.
- **Missing config fallback**: `discordConfig?.groupPolicy ?? "open"` skips `channels.defaults.groupPolicy`. Must use full chain.
- **Stray markers**: `==> compact.ts <==` from a `head` command ended up in source code.
- **console.log in CLI**: Captured by console handler. Use `process.stdout.write()` for raw output.
- **Non-exported imports**: Test file imported symbol which was not exported.

## Quick Reference

```bash
# Setup
cd /tmp/openclaw-fork
git fetch origin main

# New branch
git checkout -b fix/ISSUE-desc origin/main

# Format & lint
pnpm exec oxfmt --write src/path/to/file.ts
pnpm exec oxlint src/path/to/file.ts
pnpm lint

# Commit
git add <specific files>
git commit -m "fix(scope): description"

# Push (new branch)
git push fork fix/ISSUE-desc

# Push (amend existing)
git commit --amend --no-edit
git push fork fix/ISSUE-desc --force

# Create PR
gh pr create --repo openclaw/openclaw \
  --head arosstale:fix/ISSUE-desc --base main \
  --title "fix(scope): description" --body-file /tmp/pr-body.md

# Check CI
gh pr checks PR_NUM -R openclaw/openclaw

# Check Greptile
gh api repos/openclaw/openclaw/pulls/PR_NUM/comments \
  --jq '.[].body[:200]'

# Close bad PR
gh pr close PR_NUM -R openclaw/openclaw -c "Closing — [reason]"
```

## Forbidden

- Submitting without `pnpm lint` passing
- Ignoring Greptile review comments
- Leaving broken PRs open
- Exceeding 15 open PRs
- PRs without `lobster-biscuit` or `Fixes #NNNN`
- Touching issues in stabilisation mode that are not bugs
