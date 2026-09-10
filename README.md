# ai-agent-skills

> A curated collection of **SKILL.md** workflows and **Model Context Protocol (MCP)** server configurations for [Antigravity IDE](https://antigravity.dev), Claude Desktop, Cursor, and modern AI coding agents.
> Drop skills into your workspace to teach your agent specialised workflows, and plug in MCP servers to give your agent live runtime superpowers (databases, browser inspection, APIs, cloud deployments).

![Skills](https://img.shields.io/badge/skills-10-blueviolet?style=flat-square)
![MCPs](https://img.shields.io/badge/MCPs-12-blue?style=flat-square)
![License](https://img.shields.io/badge/license-Apache--2.0-green?style=flat-square)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square)
![CI](https://github.com/carthworks/ai-agent-skills/actions/workflows/validate.yml/badge.svg)
[![Marketplace](https://img.shields.io/badge/marketplace-live-blueviolet?style=flat-square)](https://carthworks.github.io/ai-agent-skills/)

![ai-agent-skills banner](ai-skil-set.png)

---

## 🧠 What is a skill?

A **skill** is a markdown file (`SKILL.md`) that teaches your AI agent a specialised workflow and reasoning checklist.
When you drop a skill into `.agents/skills/<skill-name>/`, the agent automatically discovers and applies it
at the right moment — no manual prompting required.

Skills can also include `references/` subdirectories with supporting cheat-sheets and reference documents
that the agent reads on demand.

---

## 🔌 What is MCP & How to use MCP Servers?

The **Model Context Protocol (MCP)** is an open standard that connects AI coding agents directly to live external tools, databases, APIs, browser sessions, and container runtimes.

While **Skills** teach the agent *how* to reason and *what* to check, **MCP Servers** give the agent the *tools* to execute actions in real time:

| Superpower | What the Agent Can Do |
|---|---|
| **Live Database Access** | Inspect schemas, foreign keys, run queries with `postgres` or `supabase` without hallucinating column names. |
| **Interactive Browser QA** | Open headless pages, inspect live DOM, capture console errors with `chrome-devtools` or `playwright`. |
| **API & Webhook Testing** | Test endpoints, inspect headers, and query third-party APIs with `fetch` or `stripe`. |
| **Release & Project Ops** | Create PRs, inspect commits, and manage sprints with `github`, `linear`, `docker`, and `sentry`. |

---

### How to Configure MCP Servers in Your Agent

Every MCP definition in this repository includes a standard command and configuration block. Copy and paste the JSON configuration into your agent's config file:

#### 1. In Antigravity IDE
Add the server definition to your workspace `.agents/mcp_config.json` or global `~/.gemini/config/mcp_config.json`:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://user:password@localhost:5432/mydb"]
    },
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    }
  }
}
```

#### 2. In Claude Desktop
Open Settings → Developer → Edit Config (`claude_desktop_config.json`) and paste the `mcpServers` block.

#### 3. In Cursor
Open **Settings → Features → MCP**, click **Add New MCP Server**, enter the name, command (`npx`/`uvx`), and arguments.

#### 4. Running directly via CLI (Testing & Debugging)
You can test any MCP server directly from your terminal:

```bash
# Node.js MCP server (no install needed)
npx -y @modelcontextprotocol/server-github

# Python MCP server via uvx (fast, isolated)
uvx mcp-server-fetch

# Chrome DevTools debugging server
npx -y chrome-devtools-mcp
```

---

## Skills Catalogue

| Skill | Category | Description |
|-------|----------|-------------|
| [production-web-app-launch](skills/web/production-web-app-launch/) | `web` | Audit and fix production-readiness gaps — accessibility, SEO, security, forms, mobile, deployment config. Activates on "is this ready to ship", "pre-launch check". |
| [web-trust-and-compliance](skills/web/web-trust-and-compliance/) | `web` | Audit legal compliance, privacy policy, cookie/form consent, TOS, refund policy, anti-dark-pattern, pricing transparency, asset licensing, and accessibility. |
| [nextjs-performance](skills/web/nextjs-performance/) | `web` | Optimise Next.js for Core Web Vitals, bundle size, and perceived speed. Covers rendering strategy, `next/image`, fonts, code splitting, and App Router caching. |
| [api-design-rest](skills/web/api-design-rest/) | `web` | Design clean, consistent REST APIs — URL naming, HTTP methods, status codes, error shapes, versioning, pagination, and auth patterns. |
| [typescript-strict-mode](skills/typescript/typescript-strict-mode/) | `typescript` | Enforce TypeScript strict mode, eliminate `any`, use `unknown` + narrowing, discriminated unions, and utility types correctly. |
| [test-coverage-guidance](skills/testing/test-coverage-guidance/) | `testing` | Decide what to unit, integration, and E2E test. Covers testing pyramid, AAA pattern, async testing, coverage targets, and CI setup. |
| [git-commit-quality](skills/devops/git-commit-quality/) | `devops` | Enforce Conventional Commits. Blocks vague messages like "fix", "wip", "update". Generates well-formed commit messages with correct type, scope, and body. |
| [code-review-checklist](skills/devops/code-review-checklist/) | `devops` | Structured PR review across correctness, security, performance, tests, and maintainability. Produces BLOCKER / MAJOR / MINOR findings with fixes. |
| [dockerfile-best-practices](skills/devops/dockerfile-best-practices/) | `devops` | Write secure, minimal Dockerfiles — multi-stage builds, non-root user, layer caching, `.dockerignore`, and production docker-compose patterns. |
| [env-secret-safety](skills/safety/env-secret-safety/) | `safety` | Prevent hardcoded secrets and API keys. Detects credential patterns, enforces `.env` hygiene, and guides safe secret storage across all cloud providers. |

---

## 🔌 Model Context Protocol (MCP) Catalogue

Curated Model Context Protocol servers for product development:

| Server | Category | Command / Runtime | Description |
|---|---|---|---|
| [github](mcps/planning/github/mcp.json) | `planning` | `npx @modelcontextprotocol/server-github` | Search code, manage pull requests, create/update issues and inspect commits. |
| [linear](mcps/planning/linear/mcp.json) | `planning` | `npx linear-mcp-server` | Query, create, and update Linear issues, search project roadmaps and sprints. |
| [chrome-devtools](mcps/browser/chrome-devtools/mcp.json) | `browser` | `npx chrome-devtools-mcp` | Inspect live DOM, capture network logs, take screenshots, troubleshoot UI console errors. |
| [playwright](mcps/browser/playwright/mcp.json) | `browser` | `npx @modelcontextprotocol/server-puppeteer` | Headless browser automation, end-to-end clicks, form fills, multi-page flows. |
| [postgres](mcps/data/postgres/mcp.json) | `data` | `npx @modelcontextprotocol/server-postgres` | Inspect database schemas, table definitions, foreign keys, and run queries without hallucinations. |
| [supabase](mcps/data/supabase/mcp.json) | `data` | `npx @supabase/mcp-server` | Manage Supabase Postgres tables, Auth users, Storage buckets, and Edge Functions. |
| [redis](mcps/data/redis/mcp.json) | `data` | `npx @modelcontextprotocol/server-redis` | Query cache keys, inspect TTLs, view data types (hashes/sets/streams), debug caching. |
| [fetch](mcps/api/fetch/mcp.json) | `api` | `uvx mcp-server-fetch` | Fetch web content, test REST and GraphQL endpoints, download API schemas. |
| [stripe](mcps/api/stripe/mcp.json) | `api` | `npx @stripe/mcp` | Inspect Stripe test-mode charges, customers, subscriptions, and verify webhooks. |
| [docker](mcps/devops/docker/mcp.json) | `devops` | `npx @modelcontextprotocol/server-docker` | Inspect containers, images, volumes, and tail live logs in docker-compose. |
| [cloudflare](mcps/devops/cloudflare/mcp.json) | `devops` | `npx @cloudflare/mcp-server-cloudflare` | Inspect DNS records, Workers, KV namespaces, D1 databases, and R2 storage buckets. |
| [sentry](mcps/quality/sentry/mcp.json) | `quality` | `uvx mcp-server-sentry` | Retrieve live stack traces, crash reports, error breadcrumbs, and issue telemetry. |

> Want to add your own? See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Install a skill

Pick whichever method suits your workflow.

### Option A — Manual copy (no tooling needed)

```bash
# macOS / Linux
cp -r skills/web/production-web-app-launch .agents/skills/

# Windows (PowerShell)
Copy-Item -Recurse skills\web\production-web-app-launch .agents\skills\
```

That's it. Commit the folder and every developer on your team gets the skill.

---

### Option B — One-liner install script

**macOS / Linux (bash):**

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh)"
```

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.ps1 | iex
```

Both scripts present an interactive menu — pick skills by number, they land in `.agents/skills/` automatically.

---

### Option C — Sparse git checkout (no full clone)

Download only the skill folder(s) you want without cloning the whole repo:

```bash
git clone --filter=blob:none --sparse https://github.com/carthworks/ai-agent-skills.git
cd ai-agent-skills
git sparse-checkout set skills/web/production-web-app-launch
# then copy to your project:
cp -r skills/web/production-web-app-launch ../.agents/skills/
```

---

## Project layout

```
skills/
├── web/
│   ├── production-web-app-launch/
│   ├── web-trust-and-compliance/
│   ├── nextjs-performance/
│   └── api-design-rest/
├── typescript/
│   └── typescript-strict-mode/
├── testing/
│   └── test-coverage-guidance/
├── devops/
│   ├── git-commit-quality/
│   ├── code-review-checklist/
│   └── dockerfile-best-practices/
└── safety/
    └── env-secret-safety/

scripts/
├── install.sh    ← Bash interactive installer
└── install.ps1   ← PowerShell interactive installer
```

---

## Where skills go in your project

Skills are loaded from the `.agents/skills/` directory at your project root.
This is automatically discovered by Antigravity IDE and compatible agents.

```
your-project/
└── .agents/
    └── skills/
        └── production-web-app-launch/   ← drop skill folders here
            ├── SKILL.md
            └── references/
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) — the short version:

1. Fork → add your skill folder under `skills/<category>/<skill-name>/`
2. Make sure `SKILL.md` has valid YAML frontmatter (name, description, license, metadata)
3. Add a row to the table above
4. Open a PR

---

## 📖 Blog & Articles

Read about how skills work and why they matter:

- **[I Built a Collection of AI Agent Skills — Here's How They Work](blog/devto-post.md)**
  _A deep dive into the skill format, real examples, and why teams should commit `.agents/skills/` to their repos._

---

## 🗺️ Coming Soon

Skills currently in development:

| Skill | Category | Status |
|-------|----------|--------|
| `react-component-patterns` | `web` | 🔨 In progress |
| `accessibility-audit` | `web` | 📋 Planned |
| `ci-github-actions` | `devops` | 📋 Planned |
| `database-migration-safety` | `safety` | 📋 Planned |
| `openapi-spec-design` | `web` | 📋 Planned |

> Have a skill idea? [Open an issue](https://github.com/carthworks/ai-agent-skills/issues) or submit a PR!

---

## License

Apache-2.0 — see [LICENSE](LICENSE).

---

## Author

**Karthikeyan T** · [@carthworks](https://github.com/carthworks)

- ✉️ [tkarthikeyan@gmail.com](mailto:tkarthikeyan@gmail.com)
- 💼 [Connect on LinkedIn](https://www.linkedin.com/in/carthworks)
- 🐙 [github.com/carthworks](https://github.com/carthworks)

> *Let's build a safer, more inclusive web.*
