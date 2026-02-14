#!/usr/bin/env bash
# Check if an issue already has open PRs. Exit 1 if duplicates found.
set -euo pipefail
issue=${1:?usage: checkdupe.sh ISSUE_NUMBER}
repo=openclaw/openclaw

echo "Checking #$issue for existing PRs..."

# Timeline API (most reliable — catches Fixes #N links)
prs=$(gh api "repos/$repo/issues/$issue/timeline" --paginate 2>/dev/null | \
  python3 -c "
import json,sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
raw = sys.stdin.read().replace('][', ',')
data = json.loads(raw) if raw.strip() else []
for i in data:
    if i.get('event') == 'cross-referenced':
        s = i.get('source', {}).get('issue', {})
        if s.get('pull_request') and s.get('state') == 'open':
            print(f'#{s[\"number\"]} @{s.get(\"user\",{}).get(\"login\",\"?\")}')
" 2>/dev/null || true)

if [ -n "$prs" ]; then
    echo "DUPLICATE(S) FOUND:"
    echo "$prs"
    exit 1
fi

# Keyword search fallback
hits=$(gh search prs --repo "$repo" --state open "$issue" --json number --jq 'length' 2>/dev/null || echo 0)
if [ "$hits" -gt 0 ]; then
    echo "POSSIBLE DUPLICATES: $hits open PRs mention '$issue'"
    gh search prs --repo "$repo" --state open "$issue" --json number,title --jq '.[] | "#\(.number) \(.title[:60])"'
    exit 1
fi

echo "CLEAR — no duplicates found"
