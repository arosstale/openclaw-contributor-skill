---
name: openclaw-strategist
description: "Strategic PR queue management for openclaw/openclaw. Nash game theory (merge probability, reciprocity), Carmack (10-min rule, kill darlings), Simons (merge windows, slot-value, LIFO timing). Use when deciding which issue to fix next, whether to close a PR, when to rebase, or how to maximize merge probability."
---

# OpenClaw Strategist

Strategic decision framework for maximizing merge probability across the `openclaw/openclaw` PR queue as contributor `arosstale`.

## The Trio (Mario / Peter / Armin)

The three founders/leads who shape the project. Understanding their roles and preferences is key to getting PRs merged.

### Mario Zechner (@badlogic) — Pi Creator
Austrian. 15+ years: academia, startups (RoboVM→Xamarin), open-source (libGDX). Creator of Pi — 4 tools (Read/Write/Edit/Bash), shortest system prompt of any agent, radical minimalism. Wrote VISION.md. Philosophy: no MCP in core, no downloading extensions — the agent extends itself. "Software building software." Sessions are trees, extensions hot-reload.
- **If Mario comments:** respond precisely and technically. Match Pi's philosophy. Don't over-explain.
- **History with us:** Blocked us for shipping competing Pi Discord package. Lesson learned — respect architectural boundaries.

### Peter Steinberger (@steipete) — OpenClaw Creator → OpenAI
Austrian. Founded PSPDFKit (13 years), sold it. Started OpenClaw as playground → went viral. **Joined OpenAI (Feb 2026)** — OpenClaw moves to a foundation, OpenAI sponsors. "The claw is the law."
- **Style:** High-velocity. Commits directly to main. Batch-merges external PRs after his own cleanup. LIFO scanner. Ghostty + VS Code + Claude Code.
- **Cares about:** Test coverage, oxfmt, clean diffs. Dislikes bundled PRs.
- **Merge window:** ~14:00-23:00 UTC, occasionally 00:00-05:00 UTC. May shift with OpenAI move.
- **Strategy:** Rebase all branches RIGHT BEFORE his window. His transition = our opportunity.

### Armin Ronacher (@mitsuhiko) — Pi Evangelist (NOT a listed maintainer)
Austrian. Creator of Flask, Jinja2, Ruff, Click, Sentry SDK. One of the most respected engineers in open source. Wrote the definitive Pi blog post (lucumr.pocoo.org, Jan 31 2026). Uses Pi "almost exclusively." Replaced all MCPs with agent-built skills. Builds own extensions (/answer, /todos, /review, /files).
- **If Armin comments:** highest-signal event. His reviews are rare but decisive. His blog is canonical.
- **His workflow rule:** "If you use a clanker to commit, you should /review on an empty session locally until the clanker is happy before pushing. All this PR machine code review business is horrible." → **CI is not your debugger. Read the diff yourself before every push.**

### Gustavo Madeira Santana (@gumadeiras) — Core Maintainer
Listed maintainer. Multi-agents, CLI, web UI. Methodical, self-merges infra PRs.
- **Merge window:** ~04:00-06:00 UTC. Rebase after his pushes — they move main frequently.

### Full Maintainer Roster (from CONTRIBUTING.md)
| GitHub | Name | Domain |
|--------|------|--------|
| @steipete | Peter Steinberger | Benevolent Dictator (→ OpenAI) |
| @thewilloftheshadow | Shadow | Discord, Clawhub, community mod |
| @vignesh07 | Vignesh | Memory (QMD), formal modeling, TUI, IRC |
| @joshp123 | Jos | Telegram, API, Nix |
| @obviyus | Ayaan Zaidi | Telegram, iOS app |
| @tyler6204 | Tyler Yust | Agents/subagents, cron, BlueBubbles, macOS |
| @mbelinky | Mariano Belinky | iOS app, Security |
| @sebslight | Seb Slight | Docs, Agent Reliability, Runtime Hardening |
| @cpojer | Christoph Nakazawa | JS Infra (former Facebook, Jest creator) |
| @gumadeiras | Gustavo Madeira Santana | Multi-agents, CLI, web UI |

### Working With Them
- All three are **Austrian**, know each other personally. Peter got Mario and Armin hooked on agents.
- **Mario** = engine (Pi). **Peter** = product (OpenClaw). **Armin** = evangelist bridging both.
- OpenClaw is built ON Pi (`pi-mono` packages). Mario's changes cascade into OpenClaw.
- Never compete with their active work. Match their standards exactly. Respect VISION.md.
- Pi philosophy: 4 tools, minimal core, agent extends itself. PRs adding core complexity → rejected.
- **Peter's OpenAI transition = foundation needs trusted contributors. Be that contributor.**

## Foundational Rule (Martin's Rule)

From Martin Gratzer's [Forging a Workflow](https://mgratzer.com/posts/forging-a-workflow/):

> "The PR is the last reliable mechanism for shared understanding when humans didn't write the code."
> "The planning step is where the human adds the most value. The execution step is where the agent shines."

**What this means for us:**

1. **Read the domain before writing code.** Look at 2-3 merged PRs in the same module. Understand how that maintainer writes. Match the idiom exactly. You cannot produce idiomatic code without reading the idiom first.

2. **The PR description is a teaching document.** The maintainer merging it has never seen this bug. They need to understand: what broke, in what scenario, what the root cause was, and how to verify the fix. "## Problem / ## Fix" is not enough.

3. **Velocity ceiling: 2-3 PRs per day.** Five PRs in 2 hours on a human contributor looks like a bot. Even if every fix is correct, the signal is wrong.

4. **Tests or explanation.** Every PR either adds a test covering the fixed path, or explicitly explains why a test isn't feasible. Silence is not acceptable.

5. **Never comment on your own PR.** Not to explain, not to respond to bots. Put clarifications in the code or commit message. `@arosstale COMMENTED` in the review list is a red flag.

6. **Structure compounds.** Agents orient on existing patterns and produce more of the same. The more your fixes match the codebase idiom, the better every subsequent fix will be. Don't just be correct — be invisible.

## Three Strategists

### 🎯 Nash (Game Theory — Merge Probability)

**Core insight:** Maintainers are rational agents minimizing review effort. Your dominant strategy is to make merging your PRs the path of least resistance.

**Rules:**
- **Quality over quantity.** 15 PRs is the cap, but 8 high-quality PRs with tests and real descriptions will merge faster than 15 thin ones. Merge probability per PR matters more than PR count.
- **Zero outstanding review comments.** Every unanswered comment is friction. Respond within 5 minutes of any Greptile/Copilot/human review — by fixing the code, not by commenting back.
- **Never comment on your own PR.** Responding to bot reviews or adding explanations as comments hurts more than it helps. Fix the code instead.
- **LIFO positioning.** Maintainers review most recently updated PRs first. Rebase all branches whenever `origin/main` moves.
- **Reciprocity at scale.** Review every competitor PR with substance. When a maintainer opens any PR, the first thing they see is your thoughtful review. This makes you the de facto community triage lead.
- **Domain identity beats breadth.** Pick Telegram + Gateway/CLI and own them. A contributor who has fixed 6 Telegram bugs gets trusted on Telegram PRs. A contributor who touched 10 different areas looks like a bot.

**Metrics:**
- `arosstale PRs / total open PRs` → target ≥ 40%
- `time to review response` → target < 5 min
- `competitor PRs reviewed` → target: all non-trivial ones

### 🚀 Carmack (Ship What Works)

**Core insight:** Perfect is the enemy of shipped. Don't gold-plate, don't chase rabbit holes, don't over-engineer.

**Rules:**
- **10-minute rule.** If you can't trace a bug to root cause in 10 minutes of `rg` + `grep` + reading code, skip it. There are always more issues.
- **Ship the fix, not the refactor.** Minimal changes. Match existing patterns. One PR = one issue.
- **Don't touch what you don't understand.** Security code, auth flows, complex lifecycle management — unless you can read every line and explain every branch, leave it alone.
- **Iterate fast.** A merged 3-line fix > an unmerged 300-line rewrite. Get the foot in the door.
- **Kill your darlings.** If a PR isn't getting traction after 2 rebases and review responses, close it and move on. Slots are finite (15 max).

**Heuristics for skipping issues:**
- External dependency bug (not our code)
- macOS/iOS only (can't test on Windows)
- Deep lifecycle/state machine (>5 files touched)
- Vague reproduction steps
- Maintainer committed in same area recently (they'll fix it themselves)
- Competitor already has a PR

### 📊 Simons (Quantitative Edge)

**Core insight:** Systematic advantages compound. Measure everything, automate the edge, exploit timing.

**Rules:**
- **Merge window detection.** Track when maintainers are active:
  - `steipete`: ~14:00-23:00 UTC (European daytime), occasionally 00:00-05:00 UTC
  - `obviyus`: ~03:00-04:00 UTC (late night)
  - `gumadeiras`: ~04:00-06:00 UTC (self-merges, then may review)
  - `tyler6204`: ~22:00-00:00 UTC
  - `mbelinky`: sporadic (security/iOS fast lane)
  - `joshavant`, `mbelinky`, `onutc`: sporadic
- **LIFO rebase timing.** Rebase ALL branches when a maintainer starts their session. Their first scan of the queue will show your PRs at the top.
- **Pre-built inventory.** When at the 15-PR cap, build fixes on local branches. The moment a PR merges (freeing a slot), push the highest-priority pre-built fix within minutes. Instant backfill.
- **Slot value optimization.** Each slot has expected merge value = P(merge) × impact. Swap low-value PRs (comment-only, competing with simpler alternatives) for high-value ones (unique fix, no competitor, clean diff).
- **Stale timer awareness.** 5 days → stale label. 3 more → auto-close. Rebase before day 5 to reset the timer.

**Tracking commands:**
```bash
# Our PR count
gh pr list -R openclaw/openclaw --author arosstale -s open --json number --jq length

# Total open PRs
gh pr list -R openclaw/openclaw -s open --json number --jq length

# Latest merges (detect active maintainers)
gh api "repos/openclaw/openclaw/pulls?state=closed&sort=updated&direction=desc&per_page=5" \
  --jq '.[] | select(.merged_at != null) | "\(.merged_at[:16]) @\(.merged_by.login // "?") ← @\(.user.login) #\(.number)"'

# Latest commits (detect active committers)
gh api "repos/openclaw/openclaw/commits" \
  --jq '.[:5] | .[] | "\(.commit.committer.date[:16]) @\(.committer.login) \(.commit.message | split("\n")[0][:55])"'

# Non-CI notifications
gh api notifications --jq '.[] | select(.reason != "ci_activity") | "\(.reason)|\(.subject.title[:55])"'
```

## Decision Matrix

When deciding what to do next, score options:

| Action | Nash Value | Carmack Value | Simons Value |
|--------|-----------|--------------|-------------|
| Fix a new issue | +slot if <15 | Only if traceable in 10min | Pick highest P(merge) |
| Review competitor PR | +reciprocity | Skip if >200 lines | Review during merge windows |
| Rebase all branches | +LIFO position | 0 (maintenance) | Time it with maintainer sessions |
| Respond to review | +friction removal | Do it immediately | <5 min response time |
| Close a low-value PR | +slot for better PR | Kill darlings | Swap for higher E[merge] |
| Pre-build a fix | 0 (not visible yet) | Ship-ready inventory | Instant backfill on slot open |

## PR Lifecycle

```
Issue Found → Dupe Check → 10-min Trace → Build Fix → Test → oxfmt
    ↓              ↓            ↓            ↓         ↓       ↓
  Skip if      Stop if       Skip if     Commit    vitest   pnpm check
  taken       duplicate     too complex   locally    pass      pass
                                            ↓
                                    Push (if slot open)
                                    OR Pre-build (if at cap)
                                            ↓
                                    Monitor reviews → respond <5min
                                            ↓
                                    Rebase on main movement
                                            ↓
                                    MERGED or CLOSE (swap for better)
```

## Steipete's AI Triage System (Feb 2026 — affects everything)

Steipete is running 50 Codex agents in parallel to generate JSON signal reports for every open PR:

```json
{
  "intent": "bug-fix",
  "vision": "one sentence: what the diff actually does",
  "correctness": "high|medium|low|unknown",
  "risk": "low|medium|high",
  "duplicates_of": [23513],
  "auto_close_reason": null
}
```

**What this changes about strategy:**

- **Nash/LIFO positioning is dead for dedup.** Duplicate detection is now file+intent based. Rebasing doesn't hide a competing fix — the AI sees the diff.
- **`vision` scores your PR, not your title.** The AI reads the diff and generates its own one-sentence description. If your diff does something other than what you claim, that's `correctness=low`.
- **Features get auto-closed.** Steipete stated explicitly: stabilisation mode = features rejected programmatically. No exceptions. Don't waste a slot.
- **8 PRs for the same bug = 7 auto-closed.** The dedup pass is automated. If you're #3 to submit the same fix, you get closed.
- **Bundled PRs score `risk=medium/high`.** The AI flags scope creep in the diff. One issue per PR is enforced at signal level, not just review time.
- **Small, focused diffs score `risk=low`.** A 3-line fix with a test and a CHANGELOG entry is the ideal profile.

**Revised priority: diff quality > slot count > timing.**

See the `steipete-pr-triage` skill for the full implementation of his pipeline.

## Anti-Patterns (Learned the Hard Way)

- **Don't compete with maintainers.** If steipete just committed in the same file, he'll fix it himself.
- **Don't bundle unrelated changes.** VISION.md says one PR = one issue. Reviewers will flag it. Triage AI flags it too.
- **Don't push features during stabilisation.** Auto-closed programmatically now, not just manually.
- **Don't ask to be maintainer.** Let them offer. Your work speaks louder.
- **Don't ignore the bun 401 CI issue.** It's infrastructure, not your code. E2B validates instead.
- **Don't chase intermittent bugs without stack traces.** No repro = no fix.
- **Don't hold a slot for a PR that's been superseded.** Close graciously, credit the other contributor.
- **Don't use CI as a debugger.** (Mitsuhiko rule) Read the diff and check function signatures before pushing. A fixup commit after CI failure looks sloppy. #20831 is the example.
- **Don't submit 30 PRs.** 15 is the cap. Beyond that = spam signal.
- **Don't comment on your own PRs.** Never reply to Greptile/Copilot bot reviews. Never add clarifications as comments. Looks bad, hurts merge probability.
- **Don't submit 5 PRs in one day.** Even if all correct, that velocity looks like a bot. Max 2-3 per day.
- **Don't skip reading the domain.** Writing code without reading 2-3 merged PRs in the same module produces non-idiomatic code that gets style comments and delays merge.
- **Don't write thin PR descriptions.** "## Problem / ## Fix" with no repro steps or test plan is not enough. The PR description is a teaching document for the maintainer who's never seen the bug.
- **Don't submit pre-built PRs without checking for competitors first.** Triage AI detects duplicates automatically. If someone already has a fix in flight, close yours immediately.

## Session Startup

Run `{baseDir}/../../scripts/dashboard.sh` first. Then:
1. Respond to any non-CI notifications — by fixing code, not commenting
2. If maintainer is active → `{baseDir}/../../scripts/rebase-all.sh`
3. `{baseDir}/../../scripts/slot-check.sh` — push pre-built fixes if slots open
4. Hunt new issues in Telegram + Gateway/CLI domain (our cluster)
5. **Before investigating any new issue: read 2-3 merged PRs in the same module**
6. Review competitor PRs with substance (reciprocity)

## Scripts

- **Dashboard:** `{baseDir}/../../scripts/dashboard.sh` — PR count, merges, maintainer activity, notifications
- **Rebase all:** `{baseDir}/../../scripts/rebase-all.sh` — rebase + force-push all open PR branches
- **Slot check:** `{baseDir}/../../scripts/slot-check.sh` — cap status + pre-built branches ready to push
- **Dupe check:** `{baseDir}/../../scripts/checkdupe.sh ISSUE` — check if issue has competing PR

## Delta Hunting

Find bugs by comparing documentation to code:
1. Fetch CLI docs: `visit.py https://docs.openclaw.ai/cli/index`
2. Extract documented commands, flags, behaviors
3. Cross-reference with `src/cli/` and `src/commands/`
4. Look for: missing params, undocumented commands, wrong defaults, dead code paths

Previous finds from this method:
- `model-forward-compat.ts` — Opus/Sonnet 4.6 missing from context window map (#19646)
- `streaming.ts` — missing `recipient_team_id` for multi-workspace Slack (#19791)
- `schema.help.ts` — grok missing from web_search provider list (#19554)
