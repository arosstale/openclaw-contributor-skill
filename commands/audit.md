# Post-Session Audit

## Purpose
Catch issues before reviewers do. Run after EVERY work session.

## Steps

### 1. List All Open PRs
```bash
prs=$(gh pr list --repo openclaw/openclaw --author arosstale --state open --json number --jq '.[].number' | tr '\n' ' ')
echo "Open PRs: $prs"
echo "Count: $(echo $prs | wc -w) / 15 max"
```

### 2. Check Each PR

For each PR, verify ALL of these:

```bash
for pr in $prs; do
    echo "=== #$pr ==="
    
    # a) lobster-biscuit present
    lobster=$(gh pr view $pr -R openclaw/openclaw --json body --jq '.body' | grep -c "lobster-biscuit")
    [ "$lobster" -eq 0 ] && echo "  MISSING lobster-biscuit"
    
    # b) Linked issue
    fixes=$(gh pr view $pr -R openclaw/openclaw --json body --jq '.body' | grep -oiE "(Fixes|Closes) #[0-9]+")
    [ -z "$fixes" ] && echo "  MISSING linked issue"
    
    # c) CI status
    fails=$(gh pr checks $pr -R openclaw/openclaw 2>&1 | grep -c "fail")
    [ "$fails" -gt 0 ] && echo "  CI FAILURES: $fails"
    
    # d) Merge conflicts
    mergeable=$(gh pr view $pr -R openclaw/openclaw --json mergeable --jq '.mergeable')
    [ "$mergeable" = "CONFLICTING" ] && echo "  MERGE CONFLICT"
    
    # e) Unresponded Greptile comments
    greptile=$(gh api repos/openclaw/openclaw/pulls/$pr/comments \
      --jq '[.[] | select(.user.login == "greptile-apps[bot]")] | length' 2>/dev/null)
    replies=$(gh api repos/openclaw/openclaw/pulls/$pr/comments \
      --jq '[.[] | select(.user.login == "arosstale" and .in_reply_to_id != null)] | length' 2>/dev/null)
    if [ "$greptile" -gt "$replies" ] 2>/dev/null; then
        echo "  UNRESPONDED Greptile ($greptile comments, $replies replies)"
    fi
    
    # f) Summary
    [ "$lobster" -gt 0 ] && [ -n "$fixes" ] && [ "$fails" -eq 0 ] && \
      [ "$mergeable" != "CONFLICTING" ] && echo "  OK"
done
```

### 3. Check for Human Reviews
```bash
for pr in $prs; do
    reviews=$(gh api repos/openclaw/openclaw/pulls/$pr/reviews \
      --jq '[.[] | select(.user.login != "greptile-apps[bot]" and .user.login != "arosstale")] | length' 2>/dev/null)
    [ "$reviews" -gt 0 ] && echo "  #$pr has $reviews human review(s)!"
done
```

### 4. Check Stale Risk
```bash
for pr in $prs; do
    updated=$(gh pr view $pr -R openclaw/openclaw --json updatedAt --jq '.updatedAt[:10]')
    echo "  #$pr last updated: $updated"
done
```

### 5. Fix Any Issues Found
- Missing lobster-biscuit: edit PR body
- Missing linked issue: find issue, add Fixes #NNNN
- CI failure: check logs, fix, amend, force-push
- Merge conflict: rebase (see rebase.md)
- Unresponded Greptile: read comment, reply inline, expand fix if needed
