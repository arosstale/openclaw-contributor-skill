---
name: jules-cli
description: "Dispatch async fix tasks to Google Jules via REST API. Jules clones the repo in a VM, writes code, and optionally creates PRs. Use for parallel issue fixes that don't need local context."
---

# Jules CLI — Google's Async Coding Agent

Jules runs in a remote VM. It clones your repo, installs deps, and writes code autonomously.
**No local CLI needed** — we use the REST API directly via `jules-client.sh`.

## API

Base: `https://jules.googleapis.com/v1alpha`
Auth: `X-Goog-Api-Key: $JULES_API_KEY`

### Session Lifecycle

```
QUEUED → PLANNING → AWAITING_PLAN_APPROVAL → IN_PROGRESS → COMPLETED
                                            → FAILED
```

### Automation Modes

- `requirePlanApproval: true` — we review plan before coding
- `AUTO_CREATE_PR` — Jules auto-creates branch + PR when done

## Official CLI (`@google/jules`)

```bash
npm install -g @google/jules
jules login                        # One-time Google OAuth
jules version                      # Check install
```

### Commands

```bash
# List repos and sessions
jules remote list --repo
jules remote list --session

# Create a new session (infers repo from cwd)
jules remote new --repo arosstale/openclaw --session "Fix issue #NNNN: description"

# Parallel sessions
jules remote new --repo arosstale/openclaw --session "Write tests" --parallel 3

# Pull results from completed session
jules remote pull --session <SESSION_ID>

# Interactive TUI dashboard
jules
```

## REST API Client (primary — use this, not the npm CLI)

Location: `~/Projects/gh-repo/jules-client.sh`
Auth: **must explicitly export** — `~/.bashrc` is not auto-sourced:

```bash
export JULES_API_KEY=$(grep "export JULES_API_KEY" ~/.bashrc | head -1 | sed 's/.*="\(.*\)"/\1/')
export PYTHONIOENCODING=utf-8
cd ~/Projects/gh-repo
```

```bash
./jules-client.sh sources                  # List connected repos
./jules-client.sh sessions [n]             # List recent sessions (default 10)
./jules-client.sh session <ID>             # Session detail + outputs
./jules-client.sh activities <ID>          # Steps within a session

./jules-client.sh fix <ISSUE> [desc]       # Create fix (plan review required)
./jules-client.sh fix-auto <ISSUE> [desc]  # Create fix (auto-PR, no review)
./jules-client.sh approve <ID>             # Approve plan → starts coding
./jules-client.sh message <ID> <msg>       # Send follow-up to session
./jules-client.sh wait <ID>                # Poll until done
./jules-client.sh batch [n]                # Find n fixable issues (default 3)
```

### ⚠️ Plan Approval Mode Gotcha

`fix` (not `fix-auto`) creates a session that PAUSES at `AWAITING_PLAN_APPROVAL`.
You must call `./jules-client.sh approve <ID>` or visit the Jules web URL.
If you don't approve, Jules completes without writing any code — session shows
`COMPLETED` but no branch is created. **Use `fix-auto` for unattended runs.**

## GitHub Label Trigger

Apply label `jules` (case-insensitive) to any GitHub issue → Jules auto-starts a task and comments on the issue with a link to the PR.

Requires: Jules GitHub App installed on `arosstale/openclaw` fork.

## Integration with Contributor Workflow

Jules creates PRs on the **fork** (`arosstale/openclaw`). Our contributor pipeline then:

1. Jules fixes → creates branch on fork
2. We review the branch locally or via `gh pr diff`
3. Run `pnpm check` / tests
4. If clean → submit upstream PR to `openclaw/openclaw` with our PR template (`lobster-biscuit`)
5. Greptile reviews → maintainer merges

### When to Use Jules vs Local

| Use Jules | Use Local |
|---|---|
| Well-scoped bug with clear repro | Complex multi-file refactor |
| We're at 10+ PRs and need parallel capacity | Needs local debugging |
| Exploratory "does this approach work?" | Security-sensitive changes |
| Full pnpm install + test needed (Jules VM handles it) | Quick one-liner fix |

### Rules

- **Jules only works on `arosstale/openclaw` fork** — it has the GitHub App installed. Don't dispatch Jules on third-party repos — session will fail or do nothing.
- **Use `fix-auto` for unattended runs.** `fix` requires manual plan approval or Jules finishes without coding.
- **One session at a time per issue.** Never spin up parallel sessions for the same bug.
- **Always run dupe check** (`scripts/checkdupe.sh`) before submitting upstream.
- **Jules output always needs human rewrite before submitting upstream.** Jules doesn't know the domain idiom. Read 2-3 merged PRs in the same module, then rewrite the diff to match. A Jules fix submitted as-is will get style comments and delay merge.
- **Jules doesn't write PR descriptions.** You write the teaching document — what broke, root cause, how to verify, test coverage. Never copy Jules' commit message as the PR body.
- **Steipete's triage AI reads the diff, not the description.** A Jules-generated fix with scope creep scores `risk=medium` even with a perfect PR title. Keep the diff focused — trim anything Jules added that's not the minimal fix.
- Jules VMs have: Node 22, pnpm 10, Python 3.12, Go, Rust, Docker.

## Environment Setup

Jules reads `AGENTS.md` in repo root for context. Our fork's setup script:
```
pnpm install
pnpm check
```

## Existing Sessions

Check `~/Projects/gh-repo/jules-sessions.json` for tracked sessions.
To check their status: `./jules-client.sh sessions`
