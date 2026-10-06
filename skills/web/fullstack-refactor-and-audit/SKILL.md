---
name: fullstack-refactor-and-audit
description: Architectural refactoring, security and QA auditing, and performance hardening for fullstack projects. Activates when asked to restructure a backend into a modular app package, audit and fix backend security and QA bugs, harden the frontend with code-splitting, run test suites, generate an audit report, or prepare clean atomic commits for push. Do NOT use for simple one-line bug fixes or greenfield boilerplate initialization without existing code.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
  tags:
    - refactor
    - security-audit
    - code-splitting
    - architecture
    - qa-audit
    - performance
    - fullstack
---

# Fullstack Refactor & Audit

## Mission

Transform legacy or monolithic fullstack codebases into clean, high-performance, and secure architectures:
1. **Restructure backend** into a decoupled, modular `app/` package optimized for long-term scalability and fast startup.
2. **Audit & fix security and QA bugs** across authentication, authorization, input validation, SQL/data access, and error leakage.
3. **Harden frontend & code-split** using dynamic imports, route-level chunking, strict error boundaries, and defensive UI practices.
4. **Execute tests, generate a rigorous audit report**, and package changes into atomic Conventional Commits ready to push.

Never guess or report false confidence. If a check or test cannot be executed in the current environment, mark it transparently as `IMPLEMENTED, UNVERIFIED`.

---

## The Four States Vocabulary

Every architectural modification, security fix, and QA check must be documented using this standard taxonomy:

| State | Definition |
|---|---|
| **VERIFIED** | Code changed and actively exercised — tests passed, build succeeded, server started, or tool executed without error. |
| **IMPLEMENTED, UNVERIFIED** | Code modified according to best practices, but runtime environment lacks test runner, database, or dependencies to execute. |
| **NOT IMPLEMENTED** | Known gap or vulnerability identified during the audit but not yet addressed. Requires explicit severity rating. |
| **NEEDS HUMAN DECISION** | Blocked on domain-level business logic, legal requirements, or architectural tradeoffs that require user sign-off. |
| **N/A** | Does not apply to the project's stack or topology (e.g. CSRF tokens on stateless JWT APIs). Must state brief rationale. |

---

## Non-Negotiable Guardrails

- **Zero Secret Exposure**: Never write, log, or commit plaintext API keys, tokens, `.env` values, or connection credentials.
- **No Regressive Fixes**: Never weaken security controls (e.g. disabling CORS, bypassing auth guards, or setting `eval` flags) to make a feature pass.
- **Destructive Change Safety**: Never drop database tables, delete user storage, or purge migration histories without explicit user consent.
- **Atomic Progression**: Refactor iteratively. Ensure tests compile between restructuring steps rather than making massive unverified file moves.

---

## Workflow Overview

```
┌────────────────────────────────────────────────────────┐
│ Phase 0: Baseline Discovery & Environment Detection    │
│  - Detect backend/frontend stacks, tooling, git status │
├────────────────────────────────────────────────────────┤
│ Phase 1: Backend Restructuring into `app/` Package     │
│  - Move monolithic scripts to clean modular boundaries │
├────────────────────────────────────────────────────────┤
│ Phase 2: Security & QA Vulnerability Remediation       │
│  - Patch OWASP Top 10, input schemas, auth/IDOR, bugs   │
├────────────────────────────────────────────────────────┤
│ Phase 3: Frontend Hardening & Code-Splitting           │
│  - Route/component lazy loading, error boundaries, CSP │
├────────────────────────────────────────────────────────┤
│ Phase 4: Test Suite Execution & Regression Checks      │
│  - Run unit, integration, lint, and typecheck commands │
├────────────────────────────────────────────────────────┤
│ Phase 5: Structured Audit Report Generation            │
│  - Compile comprehensive Markdown report with states   │
├────────────────────────────────────────────────────────┤
│ Phase 6: Atomic Commits & Push Hygiene                 │
│  - Conventional commits, clean status, push readiness  │
└────────────────────────────────────────────────────────┘
```

---

# Phase 0 — Baseline Discovery & Capability Detection

Before moving files or editing code, establish concrete project capabilities:

1. **Backend Stack Detection**:
   - Python: Look for `requirements.txt`, `pyproject.toml`, `Pipfile`, `main.py`, `app.py`.
   - Node/TypeScript: Look for `package.json`, `tsconfig.json`, `index.ts`, `server.js`.
   - Other: Go, Rust, Java, etc.
2. **Frontend Stack Detection**:
   - Framework: React, Next.js, Vite, Vue, Angular, Svelte.
   - Bundler: Vite, Webpack, Turbopack, Rollup, esbuild.
3. **Execution Tooling**:
   - Check available test runners (`pytest`, `vitest`, `jest`, `npm test`).
   - Check build tools (`npm run build`, `tsc --noEmit`).
   - Check linters (`eslint`, `ruff`, `flake8`, `mypy`).
4. **Git Workspace Cleanliness**:
   - Check `git status` to ensure working tree is clean or identify unstaged pre-existing changes.

*Detailed guide*: Read [testing-and-audit-report.md](references/testing-and-audit-report.md) for tool discovery commands.

---

# Phase 1 — Backend Restructuring into `app/` Package

Convert monolithic entrypoints (e.g., `main.py`, `server.py`, `index.ts`) into a clean domain-driven `app/` package.

### Target Architecture

```
backend/
├── app/
│   ├── __init__.py          # or index.ts (Package exports & app factory)
│   ├── core/                # Core configuration, logging, database connections, security helpers
│   │   ├── config.py
│   │   ├── database.py
│   │   └── security.py
│   ├── api/                 # API transport layer (controllers/routers)
│   │   ├── v1/
│   │   │   ├── endpoints/
│   │   │   └── router.py
│   │   └── deps.py          # Dependency injection (auth user, db session)
│   ├── models/              # Persistence / ORM models
│   ├── schemas/             # Request/response validation schemas (Pydantic / Zod)
│   └── services/            # Business logic layer (isolated from HTTP)
└── run.py                   # Minimal lightweight entrypoint
```

### Steps:
1. **Extract Core Configurations**: Move raw environment variable parsing into a typed config module (e.g., Pydantic `BaseSettings` or `dotenv` schema).
2. **Implement App Factory**: Encapsulate initialization into a factory function (`create_app()`) to facilitate test isolated instances.
3. **Modularize Routes**: Split monolithic routing files into modular domain routers (`api/v1/auth.py`, `api/v1/users.py`, etc.).
4. **Isolate Business Logic**: Move database queries and logic out of route handlers into reusable `services/`.
5. **Update Imports & Entrypoint**: Update all internal relative/absolute imports and keep root `run.py` or `main.py` minimal (3–10 lines).

*Detailed guide*: Read [backend-restructuring.md](references/backend-restructuring.md) for complete Python and Node.js restructuring blueprints.

---

# Phase 2 — Backend Security & QA Bug Fixing

Audit backend code against critical vulnerability vectors and QA logic flaws:

1. **Input Validation**: Enforce strict schema validation on all route parameters, query strings, and payloads (Pydantic / Zod). Disallow `any` / dynamic unvalidated dicts.
2. **Injection Defense**: Ensure all database queries use parameterized ORM calls or prepared statements. Eliminate any raw SQL string interpolation.
3. **Authentication & Session Hardening**:
   - Verify JWT expiration, signature verification algorithms, and secure secret retrieval.
   - Set cookie flags: `HttpOnly; Secure; SameSite=Strict` or `Lax`.
4. **Authorization & IDOR**: Check resource ownership on every mutation and sensitive read (`WHERE id = :id AND user_id = :current_user_id`).
5. **Rate Limiting**: Protect authentication endpoints (login, register, password reset) and compute-heavy endpoints with rate limiters.
6. **Error Handling & Information Disclosure**: Replace generic exception handlers that return raw stack traces or DB errors with sanitized HTTP error responses. Log full errors internally with correlation IDs.

*Detailed guide*: Read [security-and-qa-audit.md](references/security-and-qa-audit.md) for checklists and concrete code patterns.

---

# Phase 3 — Frontend Hardening & Code-Splitting

Optimize frontend bundle distribution, runtime performance, and defensive security:

1. **Route-Based Code-Splitting**:
   - Replace static page imports with `React.lazy()` / `Suspense` or `next/dynamic` for top-level routes.
2. **Heavy Dependency Splitting**:
   - Isolate heavy third-party libraries (charts, rich text editors, PDF viewers, syntax highlighters) into lazily loaded dynamic chunks.
3. **Error Boundaries**:
   - Wrap route boundaries and critical UI widgets in React `ErrorBoundary` components to prevent white-screen crashes on client errors.
4. **Frontend Security Controls**:
   - Audit for unsafe HTML rendering (`dangerouslySetInnerHTML`, `v-html`). Enforce DOMPurify sanitization.
   - Configure Content Security Policy (CSP) headers or meta tags.
   - Prevent open redirects in client navigation.
5. **Memory & State Leaks**:
   - Clean up event listeners, timers, and WebSockets inside `useEffect` cleanup returns or `componentWillUnmount`.

*Detailed guide*: Read [frontend-hardening.md](references/frontend-hardening.md) for implementation patterns.

---

# Phase 4 — Test Suite Execution & Regression Checks

Execute test suites and verify system integrity:

1. **Run Unit & Integration Tests**:
   - Python: `pytest -v` or `python -m unittest`
   - Node: `npm test` or `npx vitest run` or `npx jest`
2. **Run Typecheck & Linting**:
   - `npm run typecheck` or `npx tsc --noEmit`
   - `npm run lint` or `ruff check .`
3. **Verify Build**:
   - Frontend: `npm run build`
   - Backend: Confirm app imports cleanly (`python -c "from app import create_app; create_app()"`)
4. **Classify Results**: Categorize each verification result into `VERIFIED` or `IMPLEMENTED, UNVERIFIED` with precise execution notes.

---

# Phase 5 — Comprehensive Audit Report

Generate a clear, markdown audit report summarizing the entire initiative. The report must contain:

- **Executive Summary**: High-level overview of refactoring, security improvements, and performance gains.
- **Architecture Matrix**: Before-and-after directory layout and dependency flow.
- **Security & QA Findings**: Table of vulnerabilities addressed, severity (CRITICAL, HIGH, MEDIUM, LOW), and verification state.
- **Frontend Performance & Hardening**: Code-splitting chunks created, bundle optimizations, and UI safeguards.
- **Verification Summary**: Test run outputs, pass/fail counts, and unverified areas requiring staging/production execution.
- **Actionable Next Steps**: Items marked `NEEDS HUMAN DECISION` or recommended follow-ups.

*Template*: Read [testing-and-audit-report.md](references/testing-and-audit-report.md#audit-report-template).

---

# Phase 6 — Atomic Commits & Push Protocol

Stage and commit changes in logical, reviewable atomic units following Conventional Commits:

1. **Commit Sequence**:
   - `refactor(backend): restructure into modular app package`
   - `fix(security): resolve auth, input validation, and error leakage bugs`
   - `perf(frontend): implement route code-splitting and dynamic chunk loading`
   - `test(fullstack): add regression tests and verify test suites`
   - `docs(audit): add comprehensive refactoring and security audit report`
2. **Review Working Tree**: Verify `git status` and `git diff --staged` before every commit. Ensure no `.env` files or temporary build artifacts are tracked.
3. **Push to Remote**: Confirm branch name and push cleanly (`git push origin <branch>`).
