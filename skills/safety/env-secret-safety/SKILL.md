---
name: env-secret-safety
description: |
  Prevents hardcoded secrets, API keys, passwords, and credentials in source code.
  Use this skill whenever the agent is writing code that connects to external services,
  reads config, handles authentication, or when a user asks about environment variables,
  .env files, or API keys. Also activates on "how do I store my API key", "is this safe
  to commit", or when the agent spots a string that looks like a credential.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---

# Environment & Secret Safety

> [!CAUTION]
> **NEVER write a real secret, API key, token, password, or connection string into
> source code.** If you spot one in the codebase, flag it immediately. Do not
> reproduce it in output, logs, or comments.

---

## The Golden Rule

```diff
- const apiKey = "sk-proj-abc123realkey...";      ← NEVER
+ const apiKey = process.env.OPENAI_API_KEY;       ← ALWAYS
```

---

## Secret Detection — Flag These Patterns

When reading code, flag any of the following as a potential secret:

| Pattern | Examples |
|---------|---------|
| High-entropy strings (20+ chars) in assignments | `"sk-..."`, `"ghp_..."`, `"AKIA..."` |
| Keys matching known prefixes | `sk-`, `pk_live_`, `ghp_`, `AKIA`, `xoxb-`, `ya29.`, `AIza` |
| Passwords in connection strings | `postgresql://user:PASSWORD@host` |
| Private key blocks | `-----BEGIN RSA PRIVATE KEY-----` |
| Bearer tokens in source | `Authorization: Bearer eyJ...` hardcoded |
| AWS/GCP credential files | Inline `access_key_id`, `secret_access_key` |

---

## Correct Pattern: .env files

### Project setup

```bash
# .env.local (never committed)
OPENAI_API_KEY=sk-your-real-key
DATABASE_URL=postgresql://user:pass@localhost/db
STRIPE_SECRET_KEY=sk_live_...

# .env.example (committed — shows shape, no real values)
OPENAI_API_KEY=
DATABASE_URL=postgresql://user:pass@localhost/dbname
STRIPE_SECRET_KEY=
```

### .gitignore — always include

```gitignore
.env
.env.local
.env.*.local
*.pem
*.key
secrets/
```

---

## Accessing env vars by runtime

**Node.js / Next.js**
```js
const key = process.env.OPENAI_API_KEY;
if (!key) throw new Error("OPENAI_API_KEY is not set");
```

**Python**
```python
import os
key = os.environ["OPENAI_API_KEY"]  # raises KeyError if missing — good
# or with fallback:
key = os.getenv("OPENAI_API_KEY") or raise ValueError("OPENAI_API_KEY not set")
```

**Go**
```go
key := os.Getenv("OPENAI_API_KEY")
if key == "" {
    log.Fatal("OPENAI_API_KEY is required")
}
```

---

## Validation at startup (recommend to user)

Always validate required env vars at app startup, not at the point of use:

```ts
// lib/env.ts — validate once at boot
const required = ["OPENAI_API_KEY", "DATABASE_URL", "NEXTAUTH_SECRET"];
for (const key of required) {
  if (!process.env[key]) throw new Error(`Missing required env var: ${key}`);
}
```

Or use a schema validator:
```ts
import { z } from "zod";
const env = z.object({
  OPENAI_API_KEY: z.string().min(1),
  DATABASE_URL: z.string().url(),
}).parse(process.env);
```

---

## If a secret is already committed

Tell the user to:

1. **Rotate the secret immediately** — assume it is compromised.
2. Remove it from history: `git filter-repo --path-glob '*.env' --invert-paths`
3. Force-push all branches.
4. Add the file to `.gitignore` before re-adding.

> [!WARNING]
> `git rm` alone does NOT remove a secret from git history. Rotation is mandatory.

---

## Secret storage in production

| Environment | Recommended approach |
|-------------|---------------------|
| Local dev | `.env.local` (gitignored) |
| CI/CD | GitHub Actions Secrets / GitLab CI Variables |
| Cloud (GCP) | Secret Manager |
| Cloud (AWS) | Secrets Manager / Parameter Store |
| Cloud (Azure) | Key Vault |
| Docker | Runtime env vars / Docker Secrets — never `ENV` in Dockerfile |
