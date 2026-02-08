# Close a Bad PR

## When to Use
- PR duplicates someone else's work
- Greptile flagged a bug you cannot fix cleanly
- PR has broken code (does not compile, wrong format)
- PR does not link to a real user-reported issue

## Steps

### 1. Determine the Reason
- Duplicate: "Closing - duplicates PR #X by @author, who submitted first."
- Broken code: "Closing - [specific bug]. Not production ready."
- No linked issue: "Closing - does not address a specific user-reported issue."
- Greptile flagged: "Closing - Greptile correctly identified [issue]. Needs redesign."

### 2. Close It
```bash
gh pr close PR_NUMBER --repo openclaw/openclaw --comment "Closing - [honest reason]"
```

### 3. Move On
Closing bad PRs is the responsible thing to do. It reduces noise for maintainers.

## Why This Matters

From discussion #11907:
- 2,286 open PRs in the repo
- 11 duplicate PRs for ONE single-line fix
- Maintainers cannot keep up with the flood
- Every bad PR we leave open makes it worse

Closing our own broken PRs is more valuable than creating new ones.
