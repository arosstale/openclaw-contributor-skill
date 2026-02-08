# Submit PR

## Prerequisites
- Fix implemented and pushed
- npm run build passed
- npm test passed
- Own diff reviewed for common mistakes

## Steps

### 1. Final Duplicate Check (MANDATORY)
```bash
gh search prs --repo openclaw/openclaw --state open "ISSUE_NUMBER"
```
**If a new PR appeared targeting this issue: STOP. Close our branch.**

### 2. Create PR
```bash
gh pr create   --repo openclaw/openclaw   --head arosstale:fix/ISSUE_NUMBER-brief-description   --base main   --title "fix(scope): brief description"   --body "Fixes #ISSUE_NUMBER

[2-3 sentences: what was broken, root cause, what this changes]"
```

Keep the description short and factual. No padding, no emoji headers.

### 3. Verify
```bash
gh pr view PR_NUMBER --repo openclaw/openclaw --json title,state,url
```

### 4. Check for Automated Reviews (within minutes)
```bash
gh api repos/openclaw/openclaw/pulls/PR_NUMBER/comments --jq '.[].body'
```

If Greptile flags issues:
- Read each comment carefully
- Fix legitimate issues in a follow-up commit
- Push to the same branch
- If the PR is fundamentally broken, close it

### 5. Report
```
PR #NUMBER: [title]
URL: https://github.com/openclaw/openclaw/pull/NUMBER
Status: SUBMITTED
Greptile feedback: NONE / ADDRESSED / NEEDS WORK
```

## Rules
- Final duplicate check before submitting
- Short, honest descriptions
- Respond to Greptile feedback before starting next PR
- If PR is broken, close it
