# Rebase / Freshness Bump

## Purpose
Keep open PRs at the top of the LIFO review queue. Maintainers sort by "recently updated."

## When to Run
- Before expected merge windows (Takhoffman ~00:30 UTC, steipete ~17:00 UTC)
- When a PR approaches the 5-day stale timer
- After main has significant new commits that could cause conflicts

## Steps

### 1. Check Which PRs Need Freshening
```bash
cd /tmp/openclaw-fork

for pr in PR1 PR2 PR3; do
    updated=$(gh pr view $pr -R openclaw/openclaw --json updatedAt --jq '.updatedAt')
    title=$(gh pr view $pr -R openclaw/openclaw --json title --jq '.title[:45]')
    echo "  #$pr [$updated] $title"
done
```

### 2. Sync Fork
```bash
git fetch origin main
```

### 3. Rebase Each Branch
```bash
git checkout fix/BRANCH-NAME
git rebase origin/main

# If conflicts: resolve, git add, git rebase --continue
# If complex conflicts: git rebase --abort and skip

git push fork fix/BRANCH-NAME --force
```

### 4. Cherry-Pick Method (for shallow clones)

If rebase fails due to shallow history:
```bash
commit_sha=$(git log fix/BRANCH-NAME --oneline -1 | cut -d' ' -f1)
git checkout -b fix/BRANCH-NAME-v2 origin/main
git cherry-pick $commit_sha
git push fork fix/BRANCH-NAME-v2:fix/BRANCH-NAME --force
git branch -D fix/BRANCH-NAME-v2
```

### 5. Verify CI Triggered
```bash
for pr in PR1 PR2 PR3; do
    pending=$(gh pr checks $pr -R openclaw/openclaw 2>&1 | grep -c "pending")
    echo "#$pr: $pending pending checks"
done
```

## DO NOT TOUCH
- PRs that a specific maintainer is actively tracking
- PRs with ongoing review conversations
- PRs already at the top of the queue

## Timing
- Rebase 2-4 hours before expected merge window
- Don't rebase during a merge window
