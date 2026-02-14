# Create Fix

## Prerequisites
- Issue analyzed (root cause identified via `analyze.md`)
- No existing PRs (verified via `checkdupe.md`)
- Reference implementation found

## Steps

### 1. Create Branch
```bash
cd /tmp/openclaw-fork
git fetch origin main
git checkout -b fix/ISSUE_NUMBER-brief-description origin/main
```

### 2. Implement the Fix
- Make the minimal change that fixes the root cause
- **Find the reference implementation** and match it exactly
- **Search the module** for ALL instances of the buggy pattern
- Follow patterns from surrounding code

### 3. Format (MANDATORY)
```bash
pnpm exec oxfmt --write <changed-files>
```

### 4. Lint (MANDATORY)
```bash
pnpm exec oxlint <changed-files>
pnpm lint
```
If lint fails, fix it. Do NOT proceed.

### 5. Review Your Own Diff
```bash
git diff
```
Check for:
- Wrong content format (string vs `{type, text}` array)
- Missing config fallback chain (check `channels.defaults.X`)
- `console.log()` where `process.stdout.write()` needed
- Non-exported imports
- Stray debug lines or copy-paste artifacts

### 6. Commit
```bash
git add <specific files only>
git commit -m "fix(scope): brief description

Fixes #ISSUE_NUMBER"
```

### 7. Push
```bash
git push fork fix/ISSUE_NUMBER-brief-description
```

## For Amending After Feedback
```bash
pnpm exec oxfmt --write <files>
pnpm exec oxlint <files>
git add -A
git commit --amend --no-edit
git push fork fix/ISSUE_NUMBER-brief-description --force
```
