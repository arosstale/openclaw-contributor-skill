# Submit PR

## Prerequisites
- Fix implemented and pushed (`fix.md` completed)
- Lint passed
- Own diff reviewed

## Steps

### 1. Final Duplicate Check (MANDATORY)
```bash
gh api "repos/openclaw/openclaw/issues/ISSUE_NUMBER/timeline" --paginate 2>/dev/null | \
  python3 -c "
import json,sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
raw = sys.stdin.read().replace('][', ',')
data = json.loads(raw)
prs = [f'#{s[\"number\"]} @{s.get(\"user\",{}).get(\"login\",\"?\")}' 
       for i in data if i.get('event')=='cross-referenced' 
       for s in [i.get('source',{}).get('issue',{})] 
       if s.get('pull_request') and s.get('state')=='open']
print(' '.join(prs) if prs else 'NONE')
"
```
If a new PR appeared: STOP. Close our branch.

### 2. Check PR Slot Availability
```bash
open_count=$(gh pr list --repo openclaw/openclaw --author arosstale --state open --json number --jq 'length')
echo "Open PRs: $open_count / 15 max"
```
If >= 15: STOP.

### 3. Create PR Body

Write to `/tmp/pr-body.md`. MUST include ALL sections:

```markdown
## Summary
[What was broken and what this fixes]

lobster-biscuit

Fixes #ISSUE_NUMBER

## Root Cause
[Why the bug happened — specific file:line]

## Behavior Changes
| Scenario | Before | After |
|---|---|---|
| [case 1] | [broken] | [fixed] |

## Tests
- Format: `oxfmt --check` pass
- Lint: `oxlint` pass

## Sign-Off
- **Models used**: Claude Sonnet 4 (via pi coding agent)
- **Submitter effort**: [How you found the root cause]
- **Agent notes**: AI-assisted. [Brief description]
```

### 4. Submit
```bash
gh pr create --repo openclaw/openclaw \
  --head arosstale:fix/ISSUE_NUMBER-brief-description \
  --base main \
  --title "fix(scope): brief description" \
  --body-file /tmp/pr-body.md
```

### 5. Check Greptile (within 5 minutes)
```bash
sleep 300
gh api repos/openclaw/openclaw/pulls/PR_NUMBER/comments \
  --jq '.[] | select(.user.login == "greptile-apps[bot]") | .body[:300]'
```

If Greptile flags issues:
1. Search the entire module for the same pattern
2. Fix ALL instances
3. Reply inline explaining the fix
4. Amend and force-push
