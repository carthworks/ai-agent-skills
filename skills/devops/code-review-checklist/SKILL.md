---
name: code-review-checklist
description: |
  Provides a structured, thorough code review checklist covering correctness,
  security, performance, tests, and maintainability. Use this skill whenever
  asked to review a pull request, diff, or piece of code. Also activates when
  the user says "review this", "check my code", "is this PR ready", or "what
  did I miss". Apply to any language or framework.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---

# Code Review Checklist

> [!NOTE]
> Work through each section in order. Report findings as **BLOCKER**, **MAJOR**,
> or **MINOR**. Fix BLOCKERs before anything else. Compliment what is done well —
> good reviews are specific AND encouraging.

---

## Phase 1 — Understand the Change

Before reviewing any line:

1. Read the PR description. If there is none, ask for one.
2. Identify the intended behaviour change.
3. Identify the blast radius — what could break?
4. Check if tests exist *before* reading implementation.

---

## Section 1 — Correctness

- [ ] Does the code do what the PR description says it does?
- [ ] Are edge cases handled? (empty input, null, 0, negative numbers, max values)
- [ ] Are error paths handled? (network failure, DB timeout, bad user input)
- [ ] Is there an off-by-one error possibility in any loops or slices?
- [ ] Are async operations properly awaited? Any missing `await`?
- [ ] Are race conditions possible? (concurrent writes, shared state)
- [ ] Does new code handle the case where external APIs are down?

---

## Section 2 — Security

- [ ] Is user input sanitised before use in queries or shell commands?
- [ ] Is SQL built with parameterised queries — never string concatenation?
- [ ] Are secrets/credentials absent from code and logs?
- [ ] Is authentication checked before any protected operation?
- [ ] Is authorisation checked? (user can only access *their own* resources)
- [ ] Are file paths validated? (no path traversal: `../../etc/passwd`)
- [ ] Are dependencies added? If so, are they well-maintained and non-vulnerable?
- [ ] Does error output expose internal details (stack traces, DB schema)?

---

## Section 3 — Performance

- [ ] Are there N+1 query patterns? (loop with a DB call inside)
- [ ] Are large datasets paginated or streamed — never fully loaded into memory?
- [ ] Are expensive operations cached where appropriate?
- [ ] Are database queries indexed on the columns they filter/sort by?
- [ ] Is there unnecessary re-rendering, re-computation, or duplicate work?
- [ ] Are large files/payloads validated for size before processing?

---

## Section 4 — Tests

- [ ] Are there tests for the new behaviour?
- [ ] Are edge cases tested (not just the happy path)?
- [ ] Do tests assert behaviour, not implementation details?
- [ ] Would these tests catch a regression if the code was reverted?
- [ ] Are there tests for error and failure paths?
- [ ] Is test coverage adequate for the risk level of this change?

---

## Section 5 — Maintainability

- [ ] Is the code readable without needing inline comments to explain *what* it does?
- [ ] Are functions and variables named clearly and specifically?
- [ ] Is there duplicated logic that should be extracted?
- [ ] Are magic numbers/strings replaced with named constants?
- [ ] Is the change scoped? (does it mix unrelated concerns in one PR?)
- [ ] Is the change backwards compatible? If not, is migration handled?
- [ ] Are TODOs left behind — and if so, are they tracked as issues?

---

## Section 6 — Documentation & Types

- [ ] Are public APIs / exported functions documented?
- [ ] Is there a type change? Is it reflected in type definitions / schemas?
- [ ] Is the README or runbook updated if behaviour visible to users changed?
- [ ] Is there a migration guide if this is a breaking change?

---

## Review Output Format

```
## Summary
One paragraph: what the PR does, overall quality, recommendation.

## BLOCKERs (must fix before merge)
- [BLOCKER] file.ts:42 — SQL query built with string concatenation; use parameterised query.

## MAJORs (should fix)
- [MAJOR] api/users.ts:88 — Missing auth check; any authenticated user can delete any record.

## MINORs (nice to fix)
- [MINOR] utils.ts:12 — Magic number 86400; extract as SECONDS_PER_DAY constant.

## Praise (specific, genuine)
- Clean separation between service and controller layers.
- Edge case on empty array handled correctly at line 34.

## Questions
- Is the cache TTL of 5 minutes intentional or a placeholder?
```

---

## Tone Rules

- Be specific: "line 42" not "somewhere in the file"
- Explain *why* something is a problem, not just that it is
- Offer a fix or direction, not just a flag
- Never use absolutes like "this is wrong" — prefer "this could cause X because Y"
