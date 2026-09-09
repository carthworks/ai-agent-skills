---
name: production-web-app-launch
description: Audit and fix production-readiness gaps in websites and web apps — accessibility, SEO, metadata, security, forms, errors, mobile, deployment config, and operational concerns. Use this whenever someone is preparing a web project for launch, deployment, or public release, and also when they say things like "is this ready to ship", "can I go live", "review before I publish", "pre-launch check", or ask for a production readiness review — even if they never use the word "audit". Applies to static sites, React/Next/Vue/Angular apps, full-stack apps, SaaS products, dashboards, ecommerce, landing pages, and portfolios, and to already-live sites being reviewed after the fact.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---

# Production Web App Launch

## Mission

Take a web project from "works locally" to "ready for real users."

Inspect the actual project, find real gaps, fix what is safe to fix, verify the result, and be precise about what you could not verify. A report full of confident PASS marks that nobody actually tested is worse than no report — it converts unknown risk into false confidence.

## The four states

Every finding in this audit resolves to exactly one of these. This vocabulary drives the whole workflow and the final report:

| State | Meaning |
|---|---|
| **VERIFIED** | Implemented and actually exercised — a command ran, a page loaded, a test passed. |
| **IMPLEMENTED, UNVERIFIED** | Code changed, but you had no way to exercise it in this environment. |
| **NOT IMPLEMENTED** | A real gap. Carries a severity. |
| **NEEDS HUMAN DECISION** | Blocked on business, legal, or product judgment you must not invent. |
| **N/A** | Genuinely does not apply to this project shape. Say why in one clause. |

Never report VERIFIED for something you reasoned about but did not run. If you inspected code and it looks correct but nothing executed, that is IMPLEMENTED, UNVERIFIED.

## Non-negotiables

These hold in every phase:

- **Never invent legal or business facts.** Company identity, address, refund terms, retention periods, support contacts, pricing. Unknown means a marked TODO or a question, never a plausible-sounding placeholder.
- **Never print secret values.** Not API keys, tokens, credentials, connection strings, or the contents of environment variables — not in the report, not in logs, not in commit messages. Naming that a variable exists is fine; showing its value is not.
- **Never weaken a security control to make a feature work.** Flag the conflict instead.
- **No destructive changes without explicit approval.** Schema migrations, deletions, dependency swaps, infra changes.

---

# Phase 0 — Capability detection

Do this first, before reading any reference file. It determines what you can honestly claim later.

Establish, concretely:

- **Build**: is there a production build command, and does it run here?
- **Tests / lint / typecheck**: configured? runnable?
- **Dev server**: can the app actually start in this environment?
- **Headless browser**: is Playwright or Puppeteer installed, or installable? Without one, viewport testing, cross-browser checks, console-error inspection, and click-through smoke tests are *not available to you*.
- **Network**: can you reach a deployed URL, if one exists?
- **Live deployment**: is there a production URL to inspect, or only source?

Write this down before proceeding. Every check in the reference files falls into one of two buckets given this list: things you can execute, and things you can only read the source for. Mixing them up is the main failure mode of this skill.

If a whole category is unexecutable — say, cross-browser testing with no browser available — do not quietly skip it and do not describe it as if you did it. Report it as NOT VERIFIED with the reason, and tell the owner what they need to run themselves.

---

# Phase 1 — Detect project shape and route

Identify: framework, build system, router, package manager, styling approach, deployment target, whether a backend exists, whether auth exists, whether a database exists, whether the site is public-facing or internal.

Reuse the project's existing conventions. Do not introduce a dependency, a config format, or a directory layout the project does not already use.

Then read **only the reference files that apply**:

| Read this | When |
|---|---|
| `references/content-and-trust.md` | Always. Legal pages, conversion/CTA, FAQ, content quality. |
| `references/seo-and-metadata.md` | Any public-facing site. Skip for internal-only tools. |
| `references/accessibility.md` | Always. Includes responsive and cross-browser. |
| `references/frontend-quality.md` | Always. Forms, errors, states, dead links, UI polish, performance. |
| `references/security.md` | Always. Deeper sections apply only where auth or a backend exists. |
| `references/backend-and-api.md` | Only when a backend, API, or database exists. |
| `references/ai-and-llm.md` | Only when LLMs, GenAI models, agentic workflows, or AI APIs exist. |
| `references/deployment.md` | Always. PWA section only if the project is meant to be installable. |

Loading all eight on a static landing page wastes context and produces a report padded with irrelevant N/A rows. Route deliberately.

---

# Phase 2 — Scan and triage

Scan first. Do not fix anything yet.

Produce a prioritized findings list using these severities:

- **BLOCKER** — will harm users, leak data, or break a core journey on day one. Exposed secrets, broken signup, unprotected admin routes, a build that fails, unsandboxed autonomous AI code execution, exposed LLM API keys on client.
- **HIGH** — significantly degrades a core journey or the project's credibility. No error handling on the main form, unusable on mobile, missing 404, unhandled LLM 429/timeout errors hanging requests, missing prompt injection isolation on untrusted input.
- **MEDIUM** — real but survivable. Missing OG image, thin metadata, inconsistent empty states, high temperature on deterministic security triage tasks, unverified AI resource citations.
- **LOW** — polish.

Then stop and present the list to the owner with a proposed scope: what you intend to fix now, what you recommend deferring, and what needs their input. A full 28-category implementation pass on a real codebase is unbounded work — confirming scope here is what keeps the audit from ending half-finished with no clean handoff.

Skip this checkpoint only if the owner has already said to just fix everything you can.

---

# Phase 3 — Implement

## Safe to implement without asking

- Missing or duplicated route metadata.
- Favicon wiring when the assets already exist.
- `robots.txt` and `sitemap.xml` for a public site.
- Missing form labels and input associations.
- Broken internal links and dead `#` placeholders that clearly should navigate.
- Loading, error, and empty states where the pattern already exists elsewhere in the codebase.
- Accessibility fixes that preserve intended behavior.
- Responsive CSS fixes.
- Production URL configuration where the intended URL is already defined somewhere in the project.
- Removing debug output, console noise, and leftover dev UI.
- Adding timeout, retry, and schema validation (Zod/Pydantic) around LLM model calls.
- Sanitizing AI-generated markdown outputs before rendering to prevent script injection.

## Ask first

- Any legal or policy wording that depends on business facts.
- Pricing or commercial terms.
- Adding analytics or tracking, or anything that changes what data is collected.
- Authentication provider changes.
- Schema or migration changes with data-loss risk.
- Infrastructure changes that can cause downtime.
- Removing functionality, even functionality that looks unused.
- Major dependency replacements.
- Security changes that visibly alter product behavior.
- Modifying system prompts, AI decision boundaries, or model providers/versions.
- Enabling autonomous write/merge actions without human-in-the-loop signoff.

Fix in small, reviewable increments. After each meaningful change, re-run whatever Phase 0 said you can run — catching a broken build immediately is much cheaper than discovering it at the end of a twenty-file pass.

---

# Phase 4 — Verify

Run everything Phase 0 established is available: production build, tests, lint, typecheck.

If a dev server and headless browser are available, run the smoke test through the core journey: home page, primary navigation, primary CTA, an important form with both a validation failure and a success, auth login/protected page/logout if present, one CRUD operation, a deep link refresh, a mobile viewport, and a 404. Watch the console for unexpected errors and the network panel for failed calls.

If they are not available, say so plainly and hand the smoke test to the owner as a numbered list they can run themselves. That handoff is a legitimate output. Pretending the journey was tested is not.

---

# Report format

```markdown
## Launch Readiness
READY / READY WITH WARNINGS / NOT READY

## Environment
What was runnable here, and what was not. One or two lines.

## Implemented
- [VERIFIED] change — how it was verified
- [IMPLEMENTED, UNVERIFIED] change — why it could not be verified

## Checks
| Area | Status | Note |
|---|---|---|
| Build | PASS / FAIL / NOT CONFIGURED | |
| Tests | PASS / FAIL / NOT CONFIGURED | |
| Lint | PASS / FAIL / NOT CONFIGURED | |
| Type check | PASS / FAIL / NOT CONFIGURED | |
| Accessibility | PASS / ISSUES FOUND / NOT VERIFIED / N/A | |
| Mobile | PASS / ISSUES FOUND / NOT VERIFIED / N/A | |
| SEO & metadata | PASS / ISSUES FOUND / NOT VERIFIED / N/A | |
| Security | PASS / ISSUES FOUND / NOT VERIFIED / N/A | |
| AI & LLM Guardrails | PASS / ISSUES FOUND / NOT VERIFIED / N/A | |
| Performance | PASS / ISSUES FOUND / NOT VERIFIED / N/A | |
| Backend & API | PASS / ISSUES FOUND / NOT VERIFIED / N/A | |
| Deployment config | PASS / ISSUES FOUND / NOT VERIFIED / N/A | |

## Remaining issues
For each: severity, problem, file or route, recommended action.

## Needs human decision
Only items blocked on business, legal, or product judgment.

## Run this yourself
Checks that require tooling unavailable here, as concrete steps.
```

Every row gets a status. `NOT VERIFIED` is an honest and frequently correct answer — reach for it rather than inflating a source-read into a PASS.

---

# The underlying principle

A site is not production ready because it builds, because it looks good, or because the homepage works.

It is production ready when the important user journeys, accessibility, SEO, security, privacy, reliability, mobile experience, metadata, error handling, forms, deployment configuration, and operational concerns have each been *examined*, and the residual risk is written down where the owner can see it. Legibility of what remains unknown is part of the deliverable, not a caveat on it.
