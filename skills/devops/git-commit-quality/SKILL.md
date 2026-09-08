---
name: git-commit-quality
description: |
  Enforces high-quality git commit messages following Conventional Commits.
  Use this skill whenever the agent is about to run `git commit`, write a commit
  message, or help a user stage and commit changes. Blocks vague messages like
  "fix", "update", "changes", "wip". Also activates when the user asks "how
  should I write this commit?" or "help me commit this".
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---

# Git Commit Quality

> [!IMPORTANT]
> **Never generate or accept vague commit messages.** "fix", "update", "stuff",
> "wip", "misc", "changes" are BLOCKED. Every commit must tell a reviewer
> *what changed and why* in one line.

---

## Conventional Commits Format

```
<type>(<scope>): <short summary>

[optional body]

[optional footer: BREAKING CHANGE, Closes #123]
```

### Types

| Type | Use when |
|------|----------|
| `feat` | Adding a new feature |
| `fix` | Fixing a bug |
| `docs` | Documentation only |
| `style` | Formatting, missing semicolons — no logic change |
| `refactor` | Code restructure — no feature or bug change |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `chore` | Build process, dependency updates, tooling |
| `ci` | CI/CD config changes |
| `revert` | Reverting a previous commit |

### Scope

Optional. Name of the module, component, or area affected:
`feat(auth):`, `fix(api):`, `chore(deps):`

---

## Rules

1. **Subject line**: 50 characters max. Imperative mood ("add", not "added" or "adds").
2. **No period** at the end of the subject line.
3. **Body**: wrap at 72 chars. Explain *what* and *why*, not *how*.
4. **Breaking changes**: prefix footer with `BREAKING CHANGE:` and describe the impact.
5. **Issue references**: `Closes #123`, `Fixes #456` in the footer.

---

## Good vs Bad Examples

```diff
- git commit -m "fix stuff"
+ git commit -m "fix(auth): resolve token expiry not clearing session cookie"

- git commit -m "updated readme"
+ git commit -m "docs(readme): add sparse checkout install instructions"

- git commit -m "wip"
+ git commit -m "feat(upload): add drag-and-drop file upload to dashboard"
```

---

## Multi-line commit template

```
feat(scope): short imperative summary under 50 chars

Explain the motivation for this change. What problem does it solve?
What was the behaviour before, and what is it now?

Closes #123
```

---

## Automated enforcement (recommend to user)

If the project doesn't have commit linting, suggest adding it:

```bash
npm install --save-dev @commitlint/cli @commitlint/config-conventional husky
npx husky install
echo "npx --no -- commitlint --edit \$1" > .husky/commit-msg
```

```js
// commitlint.config.js
module.exports = { extends: ['@commitlint/config-conventional'] };
```

---

## Prohibited patterns (refuse to generate these)

- Single-word messages: `fix`, `update`, `test`, `done`, `changes`, `stuff`
- Generic messages: `minor changes`, `small fix`, `various updates`
- Time-based messages: `end of day`, `monday work`, `before meeting`
- Placeholder messages: `TODO`, `WIP` (unless explicitly a draft branch)
