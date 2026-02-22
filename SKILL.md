---
name: openclaw-contributor
description: Contribute bug fixes to openclaw/openclaw. Covers finding bugs, verifying, fix pipeline, and PR submission guidelines.
---

# OpenClaw Contributor

Bug fix pipeline for `openclaw/openclaw`. Fork: `arosstale/openclaw`.
Work dir: `C:/Users/Artale/AppData/Local/Temp/openclaw-fork`.

---

## Reality

- ~4,000 open PRs. External merges: ~9/day. This is slow. Don't optimize for volume.
- Maintainers merge what they understand and trust. Quality beats quantity.
- Talk on Discord first for anything non-trivial: https://discord.gg/qkhbAGHRBT
- The best bugs come from actually using OpenClaw on your own Discord/Telegram/WhatsApp/Slack.

---

## How to Find Real Bugs

Use OpenClaw. When something breaks or annoys you, that's the bug to fix.

Alternatively, scan the code for common patterns:

```bash
cd C:/Users/Artale/AppData/Local/Temp/openclaw-fork
rg -n 'ws://' src/                          # hardcoded scheme ignoring TLS config
rg -n '\?\? "' src/                         # default values that might be wrong
rg -n 'catch.*throw' src/                   # catch blocks that lose context
rg -n 'TODO|FIXME|HACK' src/               # known issues
```

---

## Before Writing a Line of Code

**1. Check for duplicates:**
```bash
gh pr list -R openclaw/openclaw -s open --search "KEYWORD" --json number,title --jq '.[]'
gh issue list -R openclaw/openclaw -s open --search "KEYWORD"
```

**2. Read 2-3 merged PRs in the same file/module:**
```bash
gh api "repos/openclaw/openclaw/pulls?state=closed&sort=updated&direction=desc&per_page=50" \
  --jq '.[] | select(.merged_at != null) | "\(.merged_at[:10]) @\(.user.login) #\(.number) \(.title)"' \
  | grep -i "telegram\|gateway\|slack"

gh pr diff <NUMBER> -R openclaw/openclaw | head -100
```

Match the code style exactly. If you don't understand a domain, don't fix it.

---

## Fix Pipeline

```bash
cd C:/Users/Artale/AppData/Local/Temp/openclaw-fork
git fetch origin main
git checkout -b fix/ISSUE-slug origin/main

# Read the function signature before calling it
grep -n "export.*function FUNCNAME" src/path/to/file.ts

# Fix the bug. Minimal changes only.

# Find all instances — not just the one you noticed
rg -n "pattern" src/

# Format
pnpm format

# Type check
pnpm tsc --noEmit 2>&1 | grep "error TS"

# Full check
pnpm check
```

---

## Commit

```bash
git add <files>
git commit -m "fix(scope): one line description

What broke, why, how the fix works.

Fixes #ISSUE"
```

---

## PR Description (most important thing)

Explain it like the maintainer has never seen this bug:

- **What broke** — what did the user experience?
- **Root cause** — `file.ts:line` — one sentence
- **Before/after** — what changes
- **How to verify** — exact steps to confirm it works
- **Tests** — added a test, or explain why you couldn't

Bad:
```
## Fix
Changed ws:// to wss://.
```

Good:
```
When gateway.tls.enabled is true, `openclaw status` fails with ECONNREFUSED
because the probe URL is hardcoded as ws:// regardless of TLS config.

Root cause: status.gather.ts:185 hardcodes `ws://`.

To reproduce: set gateway.tls.enabled: true, run `openclaw status`.
After this patch: connects successfully.
```

---

## Submit

```bash
git push fork fix/ISSUE-slug

gh pr create \
  --repo openclaw/openclaw \
  --head "arosstale:fix/ISSUE-slug" \
  --base main \
  --title "fix(scope): description" \
  --body "..."
```

Then leave it alone. Don't comment on your own PR. If a reviewer flags something, fix the code and push — don't reply.

---

## What Not To Do

- Don't submit more than 2-3 PRs per day
- Don't rebase just to "stay visible" — it doesn't work at 4000 PRs
- Don't fix bugs you found only from reading issues — fix bugs you actually hit
- Don't add `lobster-biscuit` to commits — it does nothing
- Don't track "merge windows" — maintainers merge when they merge
- Don't comment on your own PRs for any reason

---

## How Steipete Triages PRs (Feb 2026)

50 Codex agents run in parallel, each producing a **JSON signal report** per PR:

```json
{
  "intent": "bug-fix",
  "scope": ["tool-policy"],
  "risk": "low",
  "correctness": "high",
  "vision": "adds read/write/exec to group:openclaw — one-line change per group",
  "duplicates_of": [],
  "merge_candidate": true,
  "auto_close_reason": null
}
```

All reports are ingested into one session. Queries run against the full corpus:
- "Close all duplicates of #X"
- "Show merge candidates with correctness=high and risk=low"
- "Auto-close all features submitted during stabilisation"

**What this means for our PRs:**

| Signal | How we affect it |
|--------|-----------------|
| `intent` | Clean commit message scope — `fix(area):` not `chore:` for bug fixes |
| `correctness` | The diff must actually fix the stated problem — AI reads the code, not the description |
| `vision` | One focused change. Scope creep in the diff = flagged |
| `risk` | Small diffs, existing test coverage, focused scope = `low` |
| `duplicates_of` | Check open PRs by **files changed**, not just title keyword |
| `auto_close_reason` | Features during stabilisation are auto-closed. No exceptions. |

**Duplicate detection is file+intent based**, not title-based. Before pushing:

```bash
# Check who else touched the same files recently
gh api "repos/openclaw/openclaw/pulls?state=open&per_page=100" \
  --jq '.[] | select(.user.login != "arosstale")' | \
  # manually scan for same files
gh pr diff OTHER_PR -R openclaw/openclaw | grep "^diff --git"
```

See the `steipete-pr-triage` skill for the full parallel triage implementation.
