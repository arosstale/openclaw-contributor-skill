---
name: remote-agents
description: "Dispatch work to remote coding agents: GitHub Copilot (gh agent-task), Google Jules (REST API), and E2B sandboxes. Use when parallelizing fixes, validating in clean environments, or offloading isolated tasks."
---

# Remote Agents

Three remote execution backends for the OpenClaw contributor pipeline.

## 1. GitHub Copilot Agent (`gh agent-task`)

GitHub's built-in coding agent. Creates PRs directly on repos you own.

```bash
# Create task on our fork
gh agent-task create "Fix issue #NNNN: description" -R arosstale/openclaw --base main

# Create and follow logs
gh agent-task create "Fix issue #NNNN: description" -R arosstale/openclaw --follow

# From file
gh agent-task create -F task.md -R arosstale/openclaw

# List tasks
gh agent-task list

# View task / PR
gh agent-task view <PR_NUMBER_OR_SESSION_ID>
```

**Best for**: Tasks on our own repos. Creates PR directly on `arosstale/openclaw`.
**Limitation**: One repo per task. Works best on repos where we have push access.

## 2. Google Jules (REST API)

Async VM-based agent. Clones repo, installs deps, codes autonomously.

```bash
export JULES_API_KEY="..." # from ~/.bashrc
export PYTHONIOENCODING=utf-8

# Client location
~/Projects/gh-repo/jules-client.sh

# Commands
jules-client.sh sources                    # List connected repos
jules-client.sh sessions                   # List recent sessions
jules-client.sh session <ID>               # Session detail
jules-client.sh fix <ISSUE> [desc]         # Create fix (plan review)
jules-client.sh fix-auto <ISSUE> [desc]    # Create fix (auto-PR)
jules-client.sh approve <ID>               # Approve plan
jules-client.sh wait <ID>                  # Poll until done
jules-client.sh batch 5                    # Find fixable issues
```

**Best for**: Complex fixes needing full VM environment (pnpm install, tests).
**Limitation**: Runs on fork only. One session at a time per issue.

## 3. E2B Sandbox (Cloud VM)

Instant (~150ms) isolated Linux VMs for validation.

```bash
export E2B_API_KEY="..." # from ~/.bashrc

# CLI
e2b sandbox list
e2b sandbox connect <ID>
```

```python
from e2b_code_interpreter import Sandbox

# ⚠️ openclaw pnpm install exceeds hobby sandbox disk (1GB). 
# Use E2B for lightweight tasks only: helm lint, script validation, single-file tests.
# For full pnpm install + tests → use Jules instead.

sandbox = Sandbox.create(timeout=120)
try:
    # Example: helm lint (works great — no Node needed)
    sandbox.commands.run("curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash 2>&1 | tail -2", timeout=60)
    sandbox.commands.run("git clone --depth 1 REPO /home/user/charts", timeout=30)
    result = sandbox.commands.run("helm lint /home/user/charts/charts/NAME 2>&1")
    print(result.stdout)
finally:
    sandbox.kill()
```

**Best for**: Small targeted tools (helm lint, docker validate), single-file tests uploaded via `sandbox.files.write()`.
**Limitation**: 1GB disk (hobby) — not enough for full openclaw install. Node not pre-installed (~90s nvm setup). Always use `/home/user/` paths.
**E2B_API_KEY**: Must be explicitly exported — `~/.bashrc` is not auto-sourced.

## Decision Matrix

| Scenario | Use | Notes |
|---|---|---|
| Fix an issue on fork, want auto-PR | **Copilot** `gh agent-task create -R arosstale/openclaw` | Fast, good quality |
| Full VM fix with pnpm install + tests | **Jules** `fix-auto` | Only works on arosstale/openclaw |
| Validate lightweight tool (helm, docker) | **E2B** sandbox | Great for this |
| Full openclaw pnpm check/test | **Jules** (not E2B) | E2B disk too small |
| Third-party repo review/validation | **E2B** (small tasks only) | Jules won't work on 3rd party |
| Exploratory "does this approach work?" | **Jules** `fix` (plan review mode) | Must approve plan or no code |
| Batch triage + fix open issues | **Jules** `batch` → `fix-auto` | — |

## ⚠️ Known Constraints (Learned in Production)

- **Jules**: Only works on repos with Jules GitHub App installed (`arosstale/openclaw`). Dispatching on 3rd-party repos creates a session that completes without coding.
- **Jules `fix` mode**: Pauses at `AWAITING_PLAN_APPROVAL`. If not approved → session completes with no code. Use `fix-auto` for unattended.
- **Jules output quality**: All sessions this project have needed human review/rewrite before submitting upstream. Jules doesn't know the domain idiom — read merged PRs in the same module first, then rewrite the diff to match. Never use Jules' commit message as the PR description.
- **E2B + openclaw**: Full `pnpm install` fails on hobby sandbox (1GB disk). Use Jules for full installs.
- **E2B path**: Always `/home/user/` — `/repo` gives permission denied.
- **E2B_API_KEY / JULES_API_KEY**: Must be explicitly exported each session — not auto-loaded from `~/.bashrc`.

## Combined Workflow

```
Issue found
  ├─ Simple/quick fix → local (contributor skill)
  ├─ Well-scoped fix needing VM → Jules fix-auto (full pnpm install)
  ├─ Fork-based task → Copilot gh agent-task -R arosstale/openclaw
  └─ Lightweight validation (helm lint etc) → E2B sandbox

PR created on fork
  ├─ CI green → submit upstream
  ├─ CI broken (bun 401 infra) → note in PR description, E2B validated
  └─ CI red (our code) → fix locally → push
```
