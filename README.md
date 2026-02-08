# OpenClaw Contributor Skill

A Pi skill for contributing to [OpenClaw](https://github.com/openclaw/openclaw) responsibly.

## What This Skill Does

Guides you through fixing ONE issue at a time:

1. **Check for duplicates** - Search existing PRs before writing any code
2. **Analyze the issue** - Find the root cause, not just the symptom
3. **Implement the fix** - Minimal change, verify it compiles and tests pass
4. **Submit the PR** - Short description, honest about what it does
5. **Respond to feedback** - Fix Greptile/maintainer comments or close the PR

## Why It Exists

We created ~40 PRs across several sessions. Then we audited them honestly:

- **38 were closed** - duplicates, broken code, or noise
- **5 of 10 recent PRs** duplicated work by other contributors
- **Greptile flagged real bugs** in almost every PR (wrong formats, broken templates, non-exported imports)
- **2 survived** - the ones where we actually understood the code

This skill encodes the lessons from that experience.

## Hard Rules

1. **Check for existing PRs FIRST** - before any code
2. **ONE PR at a time** - finish before starting next
3. **`npm run build` MUST pass** - no exceptions
4. **Read every review comment** - fix or close
5. **Close your own broken PRs** - do not leave trash in the queue

## Files

```
SKILL.md                    - Skill definition and complete workflow
AGENTS.md                   - Rules for AI agents using this skill
commands/
  checkduplicates.md        - How to check for existing PRs (MOST IMPORTANT)
  analyzeissue.md           - How to analyze an issue
  createfix.md              - How to implement and verify a fix
  submitpr.md               - How to submit a PR
  closebadpr.md             - How to close your own broken PRs
config.yaml                 - Repository configuration
```

## Context

See [OpenClaw discussion #11907](https://github.com/openclaw/openclaw/discussions/11907#discussioncomment-15736421) for why PR hygiene matters.
