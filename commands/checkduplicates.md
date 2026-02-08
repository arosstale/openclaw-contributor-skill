# Check for Duplicate PRs

## Purpose
This is the most important step. We closed 38 of 40 PRs because we skipped this.

## When to Run
- BEFORE analyzing an issue
- BEFORE creating a fix
- BEFORE submitting a PR (final check)

## Steps

### 1. Search by Issue Number
```bash
gh search prs --repo openclaw/openclaw --state open "ISSUE_NUMBER"
```

### 2. Search by Keywords
```bash
gh search prs --repo openclaw/openclaw --state open "distinctive keywords"
```

### 3. Check Issue Comments for Linked PRs
```bash
gh issue view ISSUE_NUMBER --repo openclaw/openclaw --json comments --jq '.comments[].body'
```

### 4. Check the Triage Bot (Glucksberg)
The community triage bot posts comments linking related PRs. Check if it already flagged duplicates.

## Decision

- **No existing PRs found**: Proceed with fix
- **Existing PR found, still open**: STOP. Do not duplicate. Move to next issue.
- **Existing PR found, closed/stale**: Read why it was closed. If the approach was wrong, a fresh PR may be warranted. But comment on the closed PR first explaining your different approach.
