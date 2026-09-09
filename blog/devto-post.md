# I Built a Collection of AI Agent Skills — Here's How They Work

> **TL;DR** — I created a free, open-source GitHub repo of drop-in `SKILL.md` files that give your AI coding agent specialised, focused capabilities. Works with Antigravity IDE, and any agent that reads markdown instructions.
> 👉 [github.com/carthworks/ai-agent-skills](https://github.com/carthworks/ai-agent-skills)

---

## The Problem With AI Coding Agents

AI coding agents are powerful — but they're generalists. Ask one to review your code and you'll get a decent answer. Ask it to enforce Conventional Commits, or audit your app for production readiness, or tell you whether your Dockerfile is secure — and the quality becomes inconsistent. The agent has to "guess" what standard to apply.

What if you could just *tell it exactly what to do* for specific situations — once — and have it apply that consistently every time?

That's what **agent skills** solve.

---

## What Is a Skill?

A **skill** is a single markdown file called `SKILL.md`. It lives in a folder inside `.agents/skills/` at your project root.

```
your-project/
└── .agents/
    └── skills/
        └── git-commit-quality/
            └── SKILL.md
```

The file has two parts:

**1. YAML frontmatter** — tells the agent *when* to activate the skill:

```yaml
---
name: git-commit-quality
description: |
  Enforces Conventional Commits. Use when the agent is about to run
  `git commit` or help write a commit message. Blocks vague messages
  like "fix", "update", "wip".
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---
```

**2. Markdown instructions** — tells the agent *what to do*:

```markdown
# Git Commit Quality

## Rules
1. Subject line: 50 chars max, imperative mood
2. No vague messages: "fix", "wip", "update" are BLOCKED
3. Format: <type>(<scope>): <summary>

## Examples
- feat(auth): add JWT refresh token rotation
- fix(api): handle 429 rate limit with exponential backoff
```

That's it. No code. No configuration files. No plugins to install. Just markdown.

---

## How It Works in Practice

When you're working with your AI agent and it's about to write a commit message, it automatically reads the `git-commit-quality` skill and applies those rules. You never have to prompt it. You never have to remind it.

Here's what happens **without** a skill:

> *Agent generates:* `git commit -m "fix stuff"`

Here's what happens **with** the `git-commit-quality` skill:

> *Agent generates:* `git commit -m "fix(auth): resolve token expiry not clearing session cookie"`

The difference is that you taught it once, and it applies that knowledge every time — even across teammates who use the same `.agents/skills/` folder (because you commit it to your repo).

---

## The 9 Skills I've Built So Far

I've published 9 skills covering the most common developer pain points:

### 🌐 Web
| Skill | What it does |
|-------|-------------|
| `production-web-app-launch` | Full pre-launch audit — SEO, accessibility, security, forms, mobile, deployment |
| `nextjs-performance` | Core Web Vitals, rendering strategy (SSG/ISR/SSR), `next/image`, bundle splitting |
| `api-design-rest` | URL naming, HTTP status codes, error shapes, versioning, pagination |

### 🔷 TypeScript
| Skill | What it does |
|-------|-------------|
| `typescript-strict-mode` | Enforces `strict: true`, bans `any`, teaches discriminated unions and utility types |

### 🧪 Testing
| Skill | What it does |
|-------|-------------|
| `test-coverage-guidance` | Decides what to unit/integration/E2E test, AAA pattern, CI setup |

### ⚙️ DevOps
| Skill | What it does |
|-------|-------------|
| `git-commit-quality` | Conventional Commits, blocks vague messages |
| `code-review-checklist` | BLOCKER / MAJOR / MINOR PR review across correctness, security, performance |
| `dockerfile-best-practices` | Multi-stage builds, non-root user, layer caching, `.dockerignore` |

### 🔒 Safety
| Skill | What it does |
|-------|-------------|
| `env-secret-safety` | Detects hardcoded secrets, enforces `.env` hygiene, secret rotation guide |

---

## Installing a Skill Takes 10 Seconds

**Manual copy:**
```bash
# Clone the repo once
git clone https://github.com/carthworks/ai-agent-skills.git

# Drop any skill into your project
cp -r ai-agent-skills/skills/devops/git-commit-quality .agents/skills/
```

**One-liner (bash):**
```bash
curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash
```

**One-liner (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.ps1 | iex
```

Both scripts show an interactive menu — pick the skills you want, they land in `.agents/skills/` automatically. Commit that folder and every developer on your team gets the same AI behaviour, consistently.

---

## Why This Matters for Teams

The real power isn't for solo developers — it's for **teams**.

When you commit `.agents/skills/` to your repo:

- **Consistency** — every developer's AI agent applies the same standards
- **Onboarding** — new developers inherit your team's conventions instantly, through the agent
- **Codified knowledge** — your best practices are written down in a place the AI actually reads
- **No prompt fatigue** — nobody has to remember to ask the agent to follow the style guide

Think of skills as **your team's AI config file** — as important as `.eslintrc` or `tsconfig.json`, but for agent behaviour.

---

## Writing Your Own Skill

The format is minimal on purpose. Here's the full template:

```yaml
---
name: my-skill-name          # kebab-case, matches folder name
description: |
  Use when X. Don't use when Y.
  Be specific — this is how the agent decides to load the skill.
license: Apache-2.0
metadata:
  version: v1
  publisher: your-github-username
---

# My Skill Title

Write your instructions here as markdown.
The agent reads this verbatim — so be precise and imperative.
Use checklists, tables, and code examples.
```

The `description` field is the most important part. It's the activation condition — write it as "use when X, don't use when Y." Vague descriptions cause skills to fire at the wrong time.

---

## What's Next

I'm planning to add more skills:

- `react-component-patterns` — compound components, render props, custom hooks
- `database-migration-safety` — never run destructive migrations without consent
- `ci-github-actions` — canonical workflow patterns for Node.js, Python, Docker
- `accessibility-audit` — WCAG 2.1 AA checklist with specific fixes
- `openapi-spec-design` — writing machine-readable, consumer-friendly specs

**Contributions are very welcome.** If you have a skill that made your workflow significantly better, open a PR. The bar is: does this solve a real, recurring problem in a way an AI agent can reliably apply?

---

## Links

- 🐙 **Repo**: [github.com/carthworks/ai-agent-skills](https://github.com/carthworks/ai-agent-skills)
- 📋 **Contributing guide**: [CONTRIBUTING.md](https://github.com/carthworks/ai-agent-skills/blob/master/CONTRIBUTING.md)
- ✉️ **Contact**: tkarthikeyan@gmail.com

If this saved you time or sparked an idea, a ⭐ on the repo goes a long way.

*Let's build a safer, more inclusive web — one skill at a time.*

---

*Tags: `ai`, `developer-tools`, `productivity`, `llm`, `coding-agent`, `open-source`, `typescript`, `devops`, `nextjs`*
