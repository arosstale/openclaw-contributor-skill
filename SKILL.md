---
name: openclaw-contributor
description: Contribute to OpenClaw responsibly. One issue at a time. Check for duplicates first. Verify code compiles. Never add to the PR flood.
---

# OpenClaw Contributor Skill

## HARD-WON RULES (from closing 38 of our own 40 PRs)

1. **CHECK FOR EXISTING PRs FIRST** — Before touching any code, search for PRs already targeting the same issue. If someone else submitted first, do not duplicate their work.
2. **ONE PR AT A TIME** — Finish one completely before starting the next. No batching. No spray-and-pray.
3. **VERIFY IT COMPILES** — Run `npm run build` locally. If it fails, do not submit.
4. **READ EVERY REVIEW COMMENT** — Address Greptile and maintainer feedback before moving on.
5. **CLOSE YOUR OWN BROKEN PRs** — If a PR has quality issues or is a duplicate, close it immediately with an honest comment.

## Why These Rules Exist

We learned this the hard way. See [discussion #11907](https://github.com/openclaw/openclaw/discussions/11907#discussioncomment-15736421):

> *"The majority of PRs are trash, and I have the impression people are telling their bots 'find ten random issues and post PRs for them' with zero oversight... PRs came in faster than I could read them."* — HenryLoenwind

We were part of that problem. These rules ensure we never are again.

## Workflow

### Step 1: Pick ONE Issue

```bash
gh issue list --repo openclaw/openclaw --state open --limit 20
```

Pick one issue. Read it completely. Understand the user's actual problem.

### Step 2: Check for Existing PRs (MANDATORY)

```bash
# Search by issue number
gh search prs --repo openclaw/openclaw --state open "ISSUE_NUMBER"

# Search by keywords from the issue title
gh search prs --repo openclaw/openclaw --state open "relevant keywords"

# Check if anyone linked a PR in the issue comments
gh issue view ISSUE_NUMBER --repo openclaw/openclaw --json comments
```

**If an existing PR addresses this issue: STOP. Do not create a duplicate.**

### Step 3: Analyze the Code

- Read the relevant source files
- Trace the code path from symptom to root cause
- Identify the exact file and line where the bug occurs
- Understand WHY the current code is wrong

Do NOT start coding until you can explain the root cause clearly.

### Step 4: Implement the Fix

```bash
cd /tmp/openclaw-fork
git checkout main && git pull origin main
git checkout -b fix/ISSUE_NUMBER-brief-description
```

- Make the minimal change that fixes the root cause
- Follow existing code patterns in the file
- Handle edge cases (check how similar code handles them nearby)

### Step 5: Verify Locally (MANDATORY)

```bash
npm run build   # MUST pass — no exceptions
npm test        # MUST pass — no exceptions
```

If either fails, fix the issue. Do NOT submit broken code.

### Step 6: Check Content Format

Before committing, verify your changes handle data structures correctly:
- Are messages `{content: string}` or `{content: [{type: "text", text: "..."}]}`? Check surrounding code.
- Are model IDs `"claude-sonnet-4"` or `"anthropic/claude-sonnet-4"`? Check callers.
- Does the config use `models.providers.*` or flat keys? Check existing patterns.

These content format mismatches were the #1 source of bugs in our PRs.

### Step 7: Commit and Push

```bash
git add <specific files>
git commit -m "fix(scope): brief description

Fixes #ISSUE_NUMBER

Root cause: [one sentence explaining why the bug happened]
Fix: [one sentence explaining what the change does]"

git push fork fix/ISSUE_NUMBER-brief-description
```

### Step 8: Create PR

```bash
gh pr create \
  --repo openclaw/openclaw \
  --head arosstale:fix/ISSUE_NUMBER-brief-description \
  --base main \
  --title "fix(scope): brief description" \
  --body "Fixes #ISSUE_NUMBER

[2-3 sentences: what was broken, why, what this changes]"
```

Keep the description short and honest. No padding.

### Step 9: Monitor and Respond

```bash
# Check for reviews
gh pr view PR_NUMBER --repo openclaw/openclaw --json reviews,comments

# Check Greptile inline comments
gh api repos/openclaw/openclaw/pulls/PR_NUMBER/comments --jq '.[].body'
```

If Greptile or a maintainer flags an issue:
1. Read the feedback carefully
2. Fix it in a follow-up commit
3. Push to the same branch
4. If the fix is too broken, close the PR honestly

### Step 10: Only Then Start the Next One

Do not batch. Do not pipeline. Finish one PR completely — including responding to all review feedback — before starting the next.

## Anti-Patterns (things we actually did wrong)

| What we did | What we should have done |
|---|---|
| Created 10 PRs in one session | Created 1, verified it, then the next |
| Never checked existing PRs | Searched first, found 5 duplicates |
| Shipped broken template literals | Ran `npm run build` before submitting |
| Wrong content format (string vs array) | Checked how surrounding code handles it |
| Wrong model ID key format | Checked what callers pass to the function |
| 10 test-coverage PRs with no linked issue | Only PRs that fix user-reported problems |
| Optimized for "PRs created" count | Optimized for "problems actually solved" |

## Config

```yaml
target_repo: openclaw/openclaw
fork_repo: arosstale/openclaw
fork_remote: fork
```
