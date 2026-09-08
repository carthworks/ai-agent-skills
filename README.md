# ai-agent-skills

> A curated collection of **SKILL.md** files for [Antigravity IDE](https://antigravity.dev) and compatible AI coding agents.
> Drop any skill folder into your project and your AI agent gains specialised, focused capabilities instantly.

![Skills](https://img.shields.io/badge/skills-1-blueviolet?style=flat-square)
![License](https://img.shields.io/badge/license-Apache--2.0-green?style=flat-square)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square)

---

## What is a skill?

A **skill** is a markdown file (`SKILL.md`) that teaches your AI agent a specialised workflow.
When you drop a skill into `.agents/skills/<skill-name>/`, the agent automatically discovers and applies it
at the right moment — no prompting required.

Skills can also include `references/` subdirectories with supporting cheat-sheets and reference documents
that the agent reads on demand.

---

## Skills Catalogue

| Skill | Category | Description |
|-------|----------|-------------|
| [production-web-app-launch](skills/web/production-web-app-launch/) | `web` | Audit and fix production-readiness gaps — accessibility, SEO, security, forms, mobile, deployment config, and more. Activates when you say "is this ready to ship", "pre-launch check", or similar. |

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
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/ai-agent-skills/main/scripts/install.sh | bash
```

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/ai-agent-skills/main/scripts/install.ps1 | iex
```

Both scripts present an interactive menu — pick skills by number, they land in `.agents/skills/` automatically.

---

### Option C — Sparse git checkout (no full clone)

Download only the skill folder(s) you want without cloning the whole repo:

```bash
git clone --filter=blob:none --sparse https://github.com/YOUR_USERNAME/ai-agent-skills.git
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
│   └── production-web-app-launch/   ← SKILL.md + references/
├── python/
├── safety/
├── data/
└── devops/

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

## License

Apache-2.0 — see [LICENSE](LICENSE).
