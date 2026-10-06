---
name: git-vibe-checkpoint
description: |
  Automates micro-checkpoints, lightweight git stashes, branch snapshots,
  and one-command rollback points during rapid AI prototyping and vibe coding
  sessions. Use when starting an experimental feature, refactoring multiple
  files, asking an agent to rewrite complex logic, or when a vibe prompt broke
  working code and the user needs to revert cleanly. Do NOT use for production
  release tagging, semver releases, or merge conflict resolution in complex
  CI/CD pipelines.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
  tags:
    - vibe-coding
    - git
    - checkpoint
    - rollback
    - safety
    - devops
    - version-control
    - undo
---

# Git Vibe Checkpoint & Fearless Rollback

> **Quick Install into any project:**
> ```bash
> curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- skills/devops/git-vibe-checkpoint
> ```

## Mission

Give developers and AI agents the safety net to experiment boldly during rapid "vibe coding" sessions without fear of breaking working code or losing progress.

Vibe coding moves fast: agents edit dozens of files, install npm packages, and refactor architecture in seconds. Without micro-checkpoints:
- A single bad prompt can mutate 15 files and introduce obscure runtime regressions.
- Developers get trapped in "prompt spiral" trying to fix an issue with more prompts instead of rolling back.
- Working prototype states are lost because manual commits weren't created.

This skill establishes automated **micro-checkpoints, lightweight stashes, and one-command rollbacks** that make every vibe session 100% reversible.

---

## The 3-Tier Checkpoint Architecture

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              VIBE CHECKPOINT ARCHITECTURE                              │
├──────────────────────────────┬──────────────────────────────┬──────────────────────────┤
│ Tier 1: Micro-Checkpoint     │ Tier 2: Working Vibe Anchor  │ Tier 3: Instant Rollback │
│ • Pre-prompt git snapshot    │ • Tagged known-good state    │ • 1-command reset to tag │
│ • Ephemeral branch or commit │ • `git tag -f vibe-working`  │ • Preserves untracked wip│
│ • "checkpoint(vibe): [goal]" │ • Milestone verification     │ • Full emergency reflog  │
└──────────────────────────────┴──────────────────────────────┴──────────────────────────┘
```

---

## The Checkpoint Workflow

### 1. Pre-Flight Check (Before Starting a Multi-File Edit)
Before instructing an agent or applying an extensive prompt, inspect the current state:

```bash
# Check if working tree has unstaged edits
git status --porcelain
```

If dirty, create an immediate micro-checkpoint before proceeding:

```bash
# Snapshot current progress into an atomic micro-checkpoint
git add -A
git commit -m "checkpoint(vibe): save progress before [feature-name]"
```

### 2. Setting the "Working Vibe" Anchor
Whenever the application reaches a milestone that builds and runs properly (e.g., "auth works", "dashboard table loads"):

```bash
# Tag the known-good working state (movable pointer)
git tag -f vibe-working
```

This establishes an immutable anchor point that can be returned to instantly.

---

## One-Command Rollback Playbooks

When a prompt hallucinates, breaks the dev server, or takes the architecture in the wrong direction, **never prompt to fix hallucinations—roll back immediately**:

### Scenario A: Soft Rollback (Undo Agent Edits, Keep Changes in Working Tree)
Use when the code just needs slight manual adjustment:
```bash
git reset --soft HEAD~1
```

### Scenario B: Hard Revert to Last Clean Checkpoint
Use when the agent's edits are unsalvageable:
```bash
# Restore working directory and index to the last checkpoint commit
git reset --hard HEAD
git clean -fd
```

### Scenario C: Instant Return to Last Known-Good Vibe (`vibe-working`)
Use when multiple subsequent prompts compounded errors:
```bash
# Jump straight back to the verified working state
git reset --hard vibe-working
git clean -fd
```

### Scenario D: The Emergency Reflog Lifeline
If a developer accidentally ran `git reset --hard` and lost code they wanted to keep:
```bash
# View all recent HEAD transitions
git reflog -n 10

# Resurrect any commit ID from the reflog:
git checkout -b vibe-rescue <commit-hash>
```

---

## Recommended Shell Shortcuts & Aliases

Add these helper aliases to `~/.bashrc`, `~/.zshrc`, or PowerShell `$PROFILE` for instant terminal execution:

### Bash / Zsh
```bash
# Create quick micro-checkpoint
alias vibe-save='git add -A && git commit -m "checkpoint(vibe): $(date +%H:%M:%S) - ${1:-update}"'

# Tag current commit as working
alias vibe-good='git tag -f vibe-working && echo "⚓ Tagged current state as vibe-working"'

# Instant rollback to last commit
alias vibe-undo='git reset --hard HEAD && git clean -fd'

# Revert back to known good state
alias vibe-reset='git reset --hard vibe-working && git clean -fd'

# View recent vibe commits
alias vibe-log='git log --oneline -n 10 --grep="checkpoint(vibe)"'
```

### PowerShell (`$PROFILE`)
```powershell
function vibe-save($msg = "update") {
    $timestamp = Get-Date -Format "HH:mm:ss"
    git add -A
    git commit -m "checkpoint(vibe): $timestamp - $msg"
}

function vibe-good {
    git tag -f vibe-working
    Write-Host "⚓ Tagged current state as vibe-working" -ForegroundColor Green
}

function vibe-undo {
    git reset --hard HEAD
    git clean -fd
}

function vibe-reset {
    git reset --hard vibe-working
    git clean -fd
}
```

---

## Agent Protocol & Guidelines

When acting as an AI assistant in a repository with `git-vibe-checkpoint`:

1. **Self-Preservation Rule**: If asked to perform a large refactor or change > 3 files, suggest or run `git add -A && git commit -m "checkpoint(vibe): before [task]"` first.
2. **Never Stash Silently**: If stashing changes, always name the stash:
   ```bash
   git stash push -u -m "vibe-stash: [description]"
   ```
3. **Verify Before Progressing**: Run a fast smoke test (`npm run build` or `npm test`) before tagging `vibe-working`.
4. **Offer Instant Rollback on Error**: If a generated solution fails to compile, immediately provide the exact `git reset --hard` command to the user so they are never stranded.
