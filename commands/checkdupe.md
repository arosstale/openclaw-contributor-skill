# Check for Duplicate PRs

## Purpose
Most important step. We closed 38 of 40 PRs because we skipped this.

## When to Run
- BEFORE analyzing an issue
- BEFORE creating a fix
- BEFORE submitting a PR (final check)
- If more than 1 hour passed since last check (competitors are fast)

## Steps

### 1. Check Issue Timeline (MOST RELIABLE)
```bash
gh api "repos/openclaw/openclaw/issues/ISSUE_NUMBER/timeline" --paginate 2>/dev/null | \
  python3 -c "
import json,sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
raw = sys.stdin.read().replace('][', ',')
data = json.loads(raw)
prs = [f'#{s[\"number\"]} @{s.get(\"user\",{}).get(\"login\",\"?\")} ({s.get(\"state\",\"?\")})'
       for i in data if i.get('event')=='cross-referenced'
       for s in [i.get('source',{}).get('issue',{})]
       if s.get('pull_request')]
print('\n'.join(prs) if prs else 'NONE')
"
```

### 2. Search by Issue Number
```bash
gh search prs --repo openclaw/openclaw --state open "ISSUE_NUMBER"
```

### 3. Search by Keywords
```bash
gh search prs --repo openclaw/openclaw --state open "distinctive keywords"
```

### 4. Check Issue Comments for Intent
```bash
gh issue view ISSUE_NUMBER --repo openclaw/openclaw --json comments \
  --jq '.comments[] | "\(.author.login): \(.body[:100])"'
```

## Decision

| Finding | Action |
|---|---|
| No PRs, no claimed intent | Proceed |
| Open PR by another contributor | STOP — do not duplicate |
| Closed PR (rejected approach) | Read why. Different approach MAY be ok — comment first |
| Intent comment but no PR (>24h) | Proceed cautiously |
| Our own older PR on same issue | Update existing PR instead |
