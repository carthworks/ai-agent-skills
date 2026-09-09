# Community Skills

This folder is for **community-contributed skills** — submissions from developers who
want to share useful agent workflows but aren't yet part of the curated `skills/` collection.

---

## How it works

1. **Contribute** — add your skill to `community/<your-github-username>/<skill-name>/`
2. **Get reviewed** — maintainers review the skill for quality and usefulness
3. **Graduate** — high-quality skills move to `skills/<category>/<skill-name>/` and appear in the marketplace

This keeps the main collection curated while still giving contributors a clear path to get their skills in.

---

## How to submit a community skill

1. **Fork** the repo
2. **Create a folder**: `community/<your-github-username>/<skill-name>/`
3. **Add your SKILL.md** — must pass frontmatter validation (see `skill.schema.json`)
4. **Open a PR** with the tag `[community skill]`

The PR description should include:
- What problem the skill solves
- A real before/after example showing what the agent does differently with the skill loaded
- Which AI agents/tools you tested it with

---

## Quality bar for graduation to `skills/`

A community skill graduates to the curated collection when:

- [ ] Solves a common, recurring developer problem
- [ ] Passes schema validation (`npm run validate`)
- [ ] `description:` clearly states activation conditions (when to use and when NOT to use)
- [ ] Contains real code examples and a checklist
- [ ] Has been tested with at least one AI coding agent
- [ ] Receives positive feedback from at least 2 community members

---

## Community skill folder structure

```
community/
└── your-github-username/
    └── my-skill-name/
        ├── SKILL.md          ← required
        └── references/       ← optional
```

Your `SKILL.md` frontmatter must include `publisher: your-github-username`.

---

## Current community skills

> None yet — be the first! See [CONTRIBUTING.md](../CONTRIBUTING.md) for the full guide.
