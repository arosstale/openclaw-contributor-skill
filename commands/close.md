# Close a Bad PR

## When to Use
- PR duplicates someone else's work
- Greptile flagged a bug you cannot fix cleanly
- PR has broken code
- PR does not link to a real user-reported issue
- PR is for a feature/refactor (stabilisation mode = bugs only)
- PR is stale and no longer worth maintaining

## Steps

### 1. Determine the Reason

| Reason | Comment template |
|---|---|
| Duplicate | "Closing — duplicates PR #X by @author, who submitted first." |
| Broken code | "Closing — [specific bug]. Not production ready." |
| No linked issue | "Closing — does not address a specific user-reported issue." |
| Greptile flagged | "Closing — Greptile correctly identified [issue]. Fix requires redesign." |
| Not a bug fix | "Closing — this is a [feature/refactor], not appropriate during stabilisation." |
| Stale | "Closing — no longer maintaining this fix." |

### 2. Close It
```bash
gh pr close PR_NUMBER --repo openclaw/openclaw --comment "Closing — [honest reason]"
```

### 3. Clean Up Branch
```bash
git push fork --delete fix/BRANCH-NAME
```

### 4. Update Slot Count
```bash
remaining=$(gh pr list --repo openclaw/openclaw --author arosstale --state open --json number --jq 'length')
echo "Open PRs: $remaining / 15 max"
```
