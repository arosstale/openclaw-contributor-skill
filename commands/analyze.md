# Analyze Issue

## Prerequisites
- Triage passed (`triage.md` verdict: FIX)
- Duplicate check passed (`checkdupe.md` result: NONE)

## Steps

### 1. Fetch Full Issue Context
```bash
gh issue view ISSUE_NUMBER --repo openclaw/openclaw --json number,title,body,labels,comments
```

Read everything. Maintainer comments are especially valuable.

### 2. Find the Root Cause
```bash
cd /tmp/openclaw-fork
git fetch origin main
git checkout origin/main
```

- Read the source files mentioned in the issue
- Trace the code path that triggers the bug
- Identify the exact file and line
- Understand WHY the code is wrong (not just WHERE)

### 3. Find the Reference Implementation

Search for the canonical version of the pattern:
```bash
grep -rn "PATTERN" src/ --include="*.ts" | head -20
```

The reference implementation tells you what the fix SHOULD look like.

### 4. Search for ALL Instances

If the bug exists in one code path, it likely exists in others:
```bash
grep -rn "BUGGY_PATTERN" src/ --include="*.ts"
```

Count total instances. Your fix should cover ALL of them.

### 5. Check Data Formats
- What format does the data have at this point? (string vs array vs object)
- Does `channels.defaults.X` exist? Is it respected?
- How does surrounding code handle the same data?

### 6. Report
```
Issue #NUMBER: [Title]
Root Cause: [file.ts:line] — [one sentence]
Reference Implementation: [file.ts:line]
Buggy Instances: [N] across [M] files
Proposed Fix: [one sentence]
Files to change: [list]
Risk: LOW / MEDIUM / HIGH
Recommendation: PROCEED / SKIP / NEEDS CLARIFICATION
```

## Rules
- Do NOT write any code yet
- If root cause unclear after 15 minutes, report NEEDS CLARIFICATION and move on
- If fix requires >5 files, report as SKIP
