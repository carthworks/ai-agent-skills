---
name: api-design-rest
description: |
  Guides designing clean, consistent, and developer-friendly REST APIs.
  Use when creating new API endpoints, reviewing API contracts, writing OpenAPI/Swagger
  specs, or when the user asks about URL naming, HTTP status codes, error responses,
  versioning, pagination, or authentication patterns. Do NOT use for GraphQL design.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---

# REST API Design

> [!NOTE]
> A great API is a product. Design it for the developer who will consume it,
> not for the database schema behind it.

---

## URL Structure

### Naming Rules

```
# Use nouns (resources), not verbs
GET  /users           ✅
GET  /getUsers        ❌

# Plural resource names
GET  /users           ✅
GET  /user            ❌

# Nested resources for relationships
GET  /users/42/orders       ✅  (orders belonging to user 42)
GET  /orders?userId=42      ✅  (also acceptable for filtering)

# No file extensions
GET  /users/42.json   ❌
GET  /users/42        ✅

# Hyphens for multi-word, not camelCase or underscores
GET  /user-profiles   ✅
GET  /userProfiles    ❌
GET  /user_profiles   ❌
```

### Depth Limit

Keep nesting to max 2 levels: `/resource/{id}/sub-resource`
Deeper than 2 levels → use query params instead.

---

## HTTP Methods

| Method | Purpose | Idempotent | Body |
|--------|---------|------------|------|
| `GET` | Read resource(s) | ✅ | No |
| `POST` | Create resource | ❌ | Yes |
| `PUT` | Replace resource entirely | ✅ | Yes |
| `PATCH` | Partial update | ✅ | Yes |
| `DELETE` | Remove resource | ✅ | No |

---

## HTTP Status Codes

### Success
| Code | Meaning | When to use |
|------|---------|-------------|
| `200 OK` | Success with body | GET, PUT, PATCH |
| `201 Created` | Resource created | POST — include `Location` header |
| `204 No Content` | Success, no body | DELETE, PATCH with no response body |

### Client Errors
| Code | Meaning | When to use |
|------|---------|-------------|
| `400 Bad Request` | Invalid input | Validation failures |
| `401 Unauthorized` | Not authenticated | Missing/invalid auth token |
| `403 Forbidden` | Not authorised | Authenticated but no permission |
| `404 Not Found` | Resource missing | ID doesn't exist |
| `409 Conflict` | State conflict | Duplicate, optimistic lock failure |
| `422 Unprocessable` | Semantic validation failure | Valid JSON but invalid business logic |
| `429 Too Many Requests` | Rate limited | Include `Retry-After` header |

### Server Errors
| Code | Meaning |
|------|---------|
| `500 Internal Server Error` | Unexpected failure |
| `502 Bad Gateway` | Upstream service failed |
| `503 Service Unavailable` | Maintenance / overload |

---

## Error Response Shape

Always return structured errors — never bare strings:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      { "field": "email", "message": "Must be a valid email address" },
      { "field": "age",   "message": "Must be at least 18" }
    ],
    "requestId": "req_abc123"
  }
}
```

**Rules:**
- `code` — machine-readable, UPPER_SNAKE_CASE
- `message` — human-readable, safe to show in UI
- `details` — array, for field-level validation errors
- `requestId` — trace ID for debugging, always include
- **Never** expose stack traces, SQL, or internal paths in errors

---

## Versioning

Use URL path versioning — most visible, easiest to route:

```
/v1/users
/v2/users
```

- Start at `v1`
- Never remove a version without a deprecation period (minimum 6 months)
- Add `Deprecation` and `Sunset` headers on deprecated endpoints
- Breaking changes = new major version. Non-breaking additions = no new version

---

## Pagination

### Cursor-based (preferred for large datasets)

```json
GET /users?limit=20&cursor=eyJpZCI6MTAwfQ

{
  "data": [...],
  "pagination": {
    "nextCursor": "eyJpZCI6MTIwfQ",
    "hasMore": true
  }
}
```

### Offset-based (simpler, acceptable for small datasets)

```json
GET /users?page=2&limit=20

{
  "data": [...],
  "pagination": {
    "page": 2,
    "limit": 20,
    "total": 450,
    "totalPages": 23
  }
}
```

Always include: `limit` cap (max 100), default limit, `total` count.

---

## Filtering, Sorting, Searching

```
GET /users?status=active&role=admin          # filtering
GET /users?sort=createdAt&order=desc         # sorting
GET /users?q=john                            # full-text search
GET /users?fields=id,name,email              # sparse fieldsets
```

---

## Response Envelope

Wrap responses in a consistent envelope:

```json
{
  "data": { ... },          // the resource or array
  "meta": {                 // optional metadata
    "requestId": "req_123",
    "version": "v1"
  }
}
```

---

## Authentication Headers

```
Authorization: Bearer <jwt-token>       # JWT / OAuth2
X-API-Key: <key>                        # API key (server-to-server)
```

Never accept auth in query strings (`?token=...`) — it appears in logs.

---

## Design Checklist

- [ ] URLs use nouns, plural, hyphens
- [ ] Correct HTTP method for each operation
- [ ] Correct status codes (201 on create, 204 on delete)
- [ ] Consistent error shape with `code`, `message`, `requestId`
- [ ] Versioned (`/v1/`)
- [ ] Pagination on all list endpoints
- [ ] Auth tokens in headers only
- [ ] No secrets or internal info in error messages
- [ ] Rate limiting headers present (`X-RateLimit-*`, `Retry-After`)
