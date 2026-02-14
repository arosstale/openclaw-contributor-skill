#!/usr/bin/env bash
# Rebase a PR branch onto main and force-push to bump LIFO position.
set -euo pipefail
branch=${1:?usage: rebase.sh BRANCH_NAME}

cd /tmp/openclaw-fork
git fetch origin main
git checkout "$branch"

if git rebase origin/main; then
    git push fork "$branch" --force
    echo "Rebased and pushed $branch"
else
    echo "Conflict — trying cherry-pick method..."
    git rebase --abort
    sha=$(git log "$branch" --oneline -1 | cut -d' ' -f1)
    git checkout -b "${branch}-v2" origin/main
    git cherry-pick "$sha"
    git push fork "${branch}-v2:${branch}" --force
    git checkout main
    git branch -D "${branch}-v2"
    echo "Cherry-picked and pushed $branch"
fi
