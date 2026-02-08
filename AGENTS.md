# Agent Rules

## The One Rule

**Check for existing PRs before doing anything.** If someone already submitted a fix, move on.

## Before ANY Fix

1. `gh search prs --repo openclaw/openclaw --state open "ISSUE_NUMBER"` - if results, STOP
2. `gh search prs --repo openclaw/openclaw --state open "keywords"` - if results, STOP
3. Read the issue completely (title, body, all comments)
4. Trace the code to the root cause
5. Verify data formats match (string vs array, plain ID vs prefixed)

## During Fix

1. Make minimal changes
2. Follow patterns from surrounding code
3. `npm run build` - MUST pass
4. `npm test` - MUST pass
5. Review own diff for common mistakes:
   - Stray copy-paste artifacts
   - Broken template literals
   - Wrong content format
   - Non-exported imports
   - Unintended behavior changes

## After Fix

1. Final duplicate check before submitting
2. Short, honest PR description (2-3 sentences)
3. Check Greptile feedback within minutes
4. Fix feedback or close PR if broken

## Common Mistakes We Made (real examples)

- **Wrong content format**: Messages are `{content: [{type: "text", text: "..."}]}`, not `{content: "string"}`. We wrote a filter that checked `typeof msg.content === "string"` - it never matched.
- **Wrong key format**: MODEL_CACHE is keyed by "claude-sonnet-4" but we stored overrides under "anthropic/claude-sonnet-4". They never matched.
- **Stray markers**: `==> compact.ts <==` from a head command ended up in source code. Broke compilation.
- **Broken template literals**: Multiline strings inside backticks had literal newlines instead of escaped ones. Broke parsing.
- **Non-exported imports**: Test file imported IGNORED_DIR_PATTERNS which was not exported.
- **Changed behavior unintentionally**: Added `continue` to skip duplicates, which changed plugin load order from last-wins to first-wins.

## Forbidden

- `git push -f` (force push)
- `git add -A` (stage everything)
- Creating multiple PRs in one session without finishing each one
- Submitting without `npm run build` passing
- Ignoring Greptile review comments
- Leaving broken PRs open
