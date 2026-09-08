# Contributing to ai-agent-skills

Thank you for wanting to add a skill! Follow these steps to keep the collection consistent and high-quality.

---

## Folder structure

Every skill lives in its own folder inside the right category:

```
skills/
└── <category>/
    └── <skill-name>/
        ├── SKILL.md          ← required
        └── references/       ← optional supporting files referenced from SKILL.md
```

### Categories

| Folder | Use for |
|--------|---------|
| `web` | Frontend, web app quality, launch readiness |
| `python` | Python tooling, packaging, environments |
| `safety` | Data loss prevention, guardrails, consent flows |
| `data` | ML, notebooks, schemas, data pipelines |
| `devops` | CI/CD, infra, deployment, cloud ops |
| `general` | Anything that doesn't fit the above |

If you think a new category is warranted, propose it in your PR description.

---

## SKILL.md frontmatter schema

Every `SKILL.md` **must** start with valid YAML frontmatter:

```yaml
---
name: skill-name-in-kebab-case        # required — must match the folder name
description: |                         # required — one or two sentences. This is what
  Short, precise description of when   # the AI uses to decide whether to load the skill.
  to activate this skill.
license: Apache-2.0                    # required
metadata:
  version: v1                          # required — bump on breaking changes
  publisher: your-github-username      # required
---
```

> [!IMPORTANT]
> The `description` field is the trigger condition. Write it as a clear "use when X, don't use when Y" statement. Vague descriptions cause skills to fire at the wrong time.

---

## Content guidelines

- **Be specific, not general.** A skill should do one thing well.
- **Include explicit activation rules** — when to use and when NOT to use.
- **Avoid duplication.** If a skill overlaps with an existing one, extend or reference it instead.
- **No secrets or credentials** — ever.
- **Use relative links** inside the skill folder for any `references/` files.
- Write instructions as if speaking directly to an AI agent — imperative, precise, unambiguous.

---

## PR checklist

Before opening a PR:

- [ ] Folder name matches `name:` in the frontmatter
- [ ] Frontmatter is valid YAML (no tabs, correct indentation)
- [ ] `description:` clearly states when to use / not use the skill
- [ ] `publisher:` is set to your GitHub username
- [ ] No credentials, API keys, or PII in any file
- [ ] Tested: loaded the skill in Antigravity IDE or a compatible agent and confirmed it activates correctly
- [ ] Added a row to the README catalogue table

---

## Submitting

1. Fork the repo
2. Create a branch: `git checkout -b skill/my-skill-name`
3. Add your skill folder
4. Update `README.md` — add a row to the Skills Catalogue table
5. Open a PR with a short description of what the skill does and why it's useful
