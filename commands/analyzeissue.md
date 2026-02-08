# Analyze Issue

## Task
Analyze ONE GitHub issue. Determine if we should fix it or skip it.

## Steps

### 1. Fetch the Issue
```bash
gh issue view ISSUE_NUMBER --repo openclaw/openclaw --json number,title,body,labels,comments
```

Read everything: title, body, all comments.

### 2. Check for Existing PRs (STOP if found)
```bash
# By issue number
gh search prs --repo openclaw/openclaw --state open "ISSUE_NUMBER"

# By keywords
gh search prs --repo openclaw/openclaw --state open "key words from title"
```

**If ANY open PR already targets this issue: STOP. Report "Already has PR #X by @author. Skip."**

This is the most important step. We closed 38 of our 40 PRs because we skipped this check.

### 3. Find the Root Cause
- Read the source files mentioned in the issue
- Trace the code path that triggers the bug
- Identify the exact file and line
- Understand WHY the code is wrong (not just WHERE)

### 4. Check Data Formats
Before proposing a fix, verify:
- What format does the data have at this point? (string vs array vs object)
- What format do callers expect?
- How does surrounding code handle the same data?

Format mismatches were our #1 bug source.

### 5. Report

```
Issue #NUMBER: [Title]

Existing PRs: NONE / PR #X by @author (SKIP if exists)

Root Cause: [file.ts:line] - [one sentence]

Proposed Fix: [one sentence]

Files to change: [list]

Risk: LOW / MEDIUM / HIGH

Recommendation: FIX / SKIP / NEEDS MORE INFO
```

## Rules
- Do NOT write any code
- Do NOT commit anything
- If existing PR found, report it and STOP
- If root cause unclear, report "NEEDS MORE INFO" and STOP
