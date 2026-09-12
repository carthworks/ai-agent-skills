---
name: security-and-secret-hygiene
category: security
description: Strict security rules prohibiting hardcoded credentials, enforcing environment variable validation, and preventing sensitive data leaks.
metadata:
  version: v1
  publisher: carthworks
  tags:
    - security
    - secrets
    - env
    - safety
---

# Security & Secret Hygiene Rules

## Non-Negotiable Directives

1. **Zero Hardcoded Secrets**:
   - Never commit raw API keys, private certificates, DB connection strings, or auth tokens in code or comments.
   - Use `.env.example` with blank dummy values for developer documentation.
2. **Environment Variable Validation**:
   - Enforce type-safe env parsing at server startup using schemas (e.g., `t3-oss/env-nextjs` or Zod).
3. **Public vs. Private Variable Scoping**:
   - Never expose server secrets to client-side code (e.g. `NEXT_PUBLIC_` prefixes must only be used for genuinely public identifiers).
4. **Gitignore Verification**:
   - Verify `.gitignore` explicitly excludes `.env`, `.env.local`, `.env.*.local`, `*.pem`, `*.key`, and `credentials.json`.
