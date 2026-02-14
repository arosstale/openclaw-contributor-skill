#!/usr/bin/env bash
# Audit all open PRs for compliance. Flags: missing lobster-biscuit, linked issue, CI fails, conflicts, stale.
set -euo pipefail
repo=openclaw/openclaw
author=arosstale

prs=$(gh pr list --repo "$repo" --author "$author" --state open --json number --jq '.[].number')
count=$(echo "$prs" | wc -w)
echo "Open PRs: $count / 15 max"
echo ""

for pr in $prs; do
    echo "=== #$pr ==="
    body=$(gh pr view "$pr" -R "$repo" --json body --jq '.body')

    echo "$body" | grep -q "lobster-biscuit" || echo "  ✗ missing lobster-biscuit"
    fixes=$(echo "$body" | grep -oiE "(Fixes|Closes) #[0-9]+" || true)
    [ -z "$fixes" ] && echo "  ✗ missing linked issue" || echo "  $fixes"

    fails=$(gh pr checks "$pr" -R "$repo" 2>&1 | grep -c "fail" || true)
    [ "$fails" -gt 0 ] && echo "  ✗ CI failures: $fails"

    mergeable=$(gh pr view "$pr" -R "$repo" --json mergeable --jq '.mergeable')
    [ "$mergeable" = "CONFLICTING" ] && echo "  ✗ merge conflict"

    updated=$(gh pr view "$pr" -R "$repo" --json updatedAt --jq '.updatedAt[:10]')
    echo "  updated: $updated"

    [ "$fails" -eq 0 ] && [ "$mergeable" != "CONFLICTING" ] && echo "  ✓ ok"
done
