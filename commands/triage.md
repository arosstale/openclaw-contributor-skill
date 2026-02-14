# Triage Issue

## Purpose
Quickly evaluate if an issue is worth fixing. Most issues are NOT worth it.

## Steps

### 1. Read the Issue
```bash
gh issue view ISSUE_NUMBER --repo openclaw/openclaw --json number,title,body,labels,comments,createdAt
```

### 2. Check Skip Criteria

SKIP if ANY match:

| Criterion | How to check |
|---|---|
| External dependency | Bug is in pi-ai SDK, grammY, Venice, provider API |
| macOS/iOS only | Mentions Xcode, .app, menubar, notarization |
| Deep lifecycle | Session management, compaction, multi-agent orchestration |
| Has competitor | Run checkdupe.md — any open PR = skip |
| Vague report | No reproduction steps, "it crashes", missing logs |
| Recent maintainer commit | git log --oneline -5 -- <file> shows maintainer work |
| Not a bug | Feature request, refactor, discussion |
| Platform untestable | Android app, Docker-specific, cloud provider |
| Too complex | Requires >5 files or core architecture changes |

### 3. Check Freshness
```bash
gh issue view ISSUE_NUMBER --json createdAt --jq '.createdAt'
# Fresh issues (< 24h) are ideal for LIFO
```

### 4. Estimate Effort
- 1-3 lines: Ideal (guards, fallbacks, format fixes)
- 4-15 lines: Good (single-file behavioral fix)
- 16-50 lines: Acceptable if root cause is clear
- 50+ lines: Too risky — skip

### 5. Report
```
Issue #NUMBER: [title]
Age: [hours/days]
Competitors: NONE / #PR by @author
Skip criteria: NONE / [which matched]
Estimated effort: [lines] in [files]
Verdict: FIX / SKIP / NEEDS MORE ANALYSIS
Reason: [one sentence]
```
