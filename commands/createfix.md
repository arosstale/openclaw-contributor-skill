# Create Fix

## Prerequisites
- Issue analyzed (root cause identified)
- No existing PRs for this issue (verified)
- User approved the proposed fix

## Steps

### 1. Sync Fork
```bash
cd /tmp/openclaw-fork
git checkout main
git pull origin main
```

### 2. Create Branch
```bash
git checkout -b fix/ISSUE_NUMBER-brief-description
```

### 3. Implement the Fix
- Make the minimal change that fixes the root cause
- Follow patterns from surrounding code
- Check data formats match what callers expect
- Handle edge cases

### 4. Verify It Compiles (MANDATORY)
```bash
npm run build
```
**If this fails, fix it. Do NOT proceed with broken code.**

### 5. Run Tests (MANDATORY)
```bash
npm test
```
**If tests fail, fix them. Do NOT proceed with failing tests.**

### 6. Review Your Own Diff
```bash
git diff
```
Check for:
- Stray debug lines or copy-paste artifacts
- Broken template literals (literal newlines inside backtick strings)
- Wrong content format (string vs [{type, text}] array)
- Wrong key format (plain ID vs provider/model prefixed)
- Non-exported imports
- Logic that changes existing behavior unintentionally

These were all real bugs in our past PRs.

### 7. Commit
```bash
git add <specific files only>
git commit -m "fix(scope): brief description

Fixes #ISSUE_NUMBER

Root cause: [one sentence]
Fix: [one sentence]"
```

### 8. Push
```bash
git push fork fix/ISSUE_NUMBER-brief-description
```

### 9. Report
```
Branch: fix/ISSUE_NUMBER-brief-description
Build: PASS / FAIL
Tests: PASS / FAIL
Files changed: [list]
Ready to submit: YES / NO
```

## Rules
- npm run build MUST pass before committing
- npm test MUST pass before committing
- Review your own diff for common mistakes
- One commit per fix
- Push to fork remote only
