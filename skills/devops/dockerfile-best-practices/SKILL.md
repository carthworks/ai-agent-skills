---
name: dockerfile-best-practices
description: |
  Guides writing secure, efficient, production-grade Dockerfiles and
  docker-compose files. Use when creating or reviewing a Dockerfile, docker-compose.yml,
  or .dockerignore. Also activates when the user asks about containerising an app,
  reducing image size, running Docker in production, or non-root containers.
  Do NOT use for Kubernetes manifests — use a dedicated k8s skill for that.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---

# Dockerfile Best Practices

> [!IMPORTANT]
> Always produce the smallest, most secure image possible. Every layer costs
> space and every root process is a security risk.

---

## The Non-Negotiables

1. **Multi-stage builds** — never ship build tools in production.
2. **Non-root user** — never run the app as root.
3. **Pin base image versions** — never use `:latest`.
4. **`.dockerignore`** — always present.
5. **No secrets in the image** — not in `ENV`, `ARG`, or `COPY`.

---

## Multi-Stage Build Pattern

### Node.js / Next.js

```dockerfile
# ---- build stage ----
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --frozen-lockfile
COPY . .
RUN npm run build

# ---- production stage ----
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Non-root user
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 3000
CMD ["node", "server.js"]
```

### Python / FastAPI

```dockerfile
FROM python:3.12-slim AS base
WORKDIR /app

FROM base AS builder
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM base AS runner
COPY --from=builder /install /usr/local
COPY . .

RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## Layer Caching — Order Matters

```dockerfile
# WRONG — invalidates cache on every code change
COPY . .
RUN npm install

# CORRECT — npm install cached unless package.json changes
COPY package*.json ./
RUN npm install
COPY . .
```

**Rule**: copy dependency manifests first, install, then copy source.

---

## Base Image Selection

| Use case | Image | Why |
|----------|-------|-----|
| Node.js prod | `node:20-alpine` | Minimal, ~50MB |
| Python prod | `python:3.12-slim` | Minimal, no extras |
| Go | `scratch` or `gcr.io/distroless/static` | Zero OS overhead |
| General Linux | `debian:bookworm-slim` | When Alpine musl causes issues |
| Avoid | `:latest`, `ubuntu`, `node:20` (full) | Too large, unpredictable |

---

## .dockerignore (always create this)

```dockerignore
.git
.gitignore
.env
.env.*
node_modules
.next
dist
build
coverage
*.log
*.md
.DS_Store
Dockerfile*
docker-compose*
```

---

## Security Rules

```dockerfile
# Pin digest for critical images (most secure)
FROM node:20-alpine@sha256:abc123...

# Never do this — exposes secrets in image layers
ARG API_KEY
ENV API_KEY=$API_KEY   # ← secret baked into image, visible in docker history

# Never run as root
USER root  # ← prohibited in production images
```

---

## HEALTHCHECK — always add in production

```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1
```

---

## docker-compose.yml production patterns

```yaml
services:
  app:
    build:
      context: .
      target: runner          # target the production stage
    restart: unless-stopped
    environment:
      - NODE_ENV=production
      # Pass secrets as env vars, never hardcode
      - DATABASE_URL=${DATABASE_URL}
    ports:
      - "3000:3000"
    read_only: true           # filesystem immutability
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

---

## Image Size Checklist

- [ ] Multi-stage build used
- [ ] Alpine or slim base image
- [ ] `npm ci --frozen-lockfile` (not `npm install`)
- [ ] `--no-cache-dir` on pip
- [ ] devDependencies excluded from production stage
- [ ] `.dockerignore` excludes `node_modules`, `.git`, `.env`
- [ ] Build artifacts only (not full source) copied to final stage
