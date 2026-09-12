---
name: typescript-strict-guardrails
category: quality
description: Strict TypeScript rules prohibiting any, enforcing discriminated unions, runtime schema validation (Zod), and exhaustive type guards.
metadata:
  version: v1
  publisher: carthworks
  tags:
    - typescript
    - types
    - strict
    - quality
---

# TypeScript Strict Guardrails

## Core Requirements

1. **Zero `any` Policy**:
   - The `any` type is strictly forbidden. Use `unknown` with narrowing or generic type parameters.
   - Prohibit `@ts-ignore` without an attached Jira/Issue tracking reference.
2. **Discriminated Unions for State**:
   - Model asynchronous state using tagged unions (`status: 'idle' | 'loading' | 'success' | 'error'`) rather than multiple optional booleans.
3. **Runtime Boundary Validation**:
   - Validate all external inputs (API payloads, query parameters, webhooks, `.env` vars) at the application boundary using Zod or ArkType.
4. **Exhaustive Matching**:
   - Use `assertNever(x: never)` in switch statements to ensure total coverage when extending unions.
