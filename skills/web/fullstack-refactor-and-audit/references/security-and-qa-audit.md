# Backend Security & QA Audit Guide

This guide provides concrete inspection checklists, vulnerability signatures, and remediation patterns for backend security and QA auditing.

---

## 1. Vulnerability Checklist & Audit Targets

| Category | Vulnerability / Flaw | Risk Level | Detection Pattern | Remediation |
|---|---|---|---|---|
| **Injection** | SQL Injection | CRITICAL | String concatenation or formatted strings in queries: `f"SELECT * FROM users WHERE id = '{uid}'"` | Parameterized queries or ORM models (`db.query(User).filter(User.id == uid)`) |
| **Broken Auth** | Insecure JWT Verification | HIGH | Missing expiration check, accepting `none` algorithm, hardcoded secret keys | Strict algorithm enforcement (`algorithms=["HS256"]`), verify `exp`, load secret from validated config |
| **Broken Auth** | Insecure Cookies | MEDIUM | Missing `HttpOnly`, `Secure`, or `SameSite` flags | Always set `httponly=True, secure=True, samesite="lax"` on session cookies |
| **Broken Access** | IDOR (Insecure Direct Object Reference) | CRITICAL | Fetching resource by ID without checking user ownership: `db.get(Invoice, id)` | Verify ownership: `db.filter(Invoice.id == id, Invoice.user_id == current_user.id)` |
| **Validation** | Mass Assignment / Unvalidated Inputs | HIGH | Accepting raw dictionary into ORM: `User(**request.json)` | Enforce strict schemas (Pydantic / Zod) with `extra="forbid"` |
| **Availability** | Missing Rate Limiting | HIGH | Auth endpoints (login, register, forgot-password) without rate limiting | Implement slowapi / express-rate-limit with Redis or in-memory bucket |
| **Info Leak** | Verbose Error Disclosure | MEDIUM | Returning `str(e)`, stack traces, or raw database error strings to client | Return generic messages (`"Internal server error"`); log details with trace ID |
| **CORS** | Wildcard Origins with Credentials | HIGH | `allow_origins=["*"]` combined with `allow_credentials=True` | Enforce explicit allowed domain whitelist from config |
| **Secrets** | Hardcoded Credentials | CRITICAL | Plaintext API keys, passwords, database URIs in code | Extract to `.env` + typed config; scan using `git-secrets` / regex |

---

## 2. Hardened Implementation Patterns

### Pattern A: Parameterized Database Queries (SQLAlchemy)

```python
# ❌ VULNERABLE: SQL Injection via string formatting
def get_user_vulnerable(db, email: str):
    return db.execute(f"SELECT * FROM users WHERE email = '{email}'").fetchall()

# ✅ SECURE: ORM parameter binding
def get_user_secure(db, email: str):
    return db.query(UserModel).filter(UserModel.email == email).first()
```

### Pattern B: IDOR Prevention (FastAPI / SQLAlchemy)

```python
# ❌ VULNERABLE: Any authenticated user can view any project by ID
@router.get("/projects/{project_id}")
def get_project(project_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    project = db.query(Project).filter(Project.id == project_id).first()
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")
    return project

# ✅ SECURE: Scope query strictly to the current user
@router.get("/projects/{project_id}")
def get_project(project_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    project = db.query(Project).filter(
        Project.id == project_id,
        Project.owner_id == current_user.id
    ).first()
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")
    return project
```

### Pattern C: Strict Request Validation & Extra Field Forbidding (Pydantic v2)

```python
from pydantic import BaseModel, EmailStr, ConfigDict, Field

class UserCreate(BaseModel):
    model_config = ConfigDict(extra="forbid")  # Rejects unexpected/malicious fields

    email: EmailStr
    password: str = Field(..., min_length=8, max_length=128)
    full_name: str = Field(..., min_length=1, max_length=100)
```

### Pattern D: Sanitized Global Error Handling

```python
from fastapi import Request, status
from fastapi.responses import JSONResponse
import logging
import uuid

logger = logging.getLogger("app.security")

async def global_exception_handler(request: Request, exc: Exception):
    error_id = str(uuid.uuid4())
    # Log full error with stack trace and context internally
    logger.error(f"Unhandled exception [ID: {error_id}] on {request.method} {request.url.path}: {exc}", exc_info=True)
    
    # Return sanitized response to client — zero internal details leaked
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "error": "Internal Server Error",
            "message": "An unexpected error occurred. Please contact support with this reference ID.",
            "error_id": error_id
        }
    )
```

---

## 3. QA Logic & Edge-Case Audit

Review endpoints against common QA bugs:

1. **Boundary Values**:
   - Zero, negative numbers, maximum integers in pagination (`limit`, `offset`, `page`).
   - Empty arrays, strings with only whitespace.
2. **Race Conditions**:
   - Concurrent creation of unique resources (e.g. usernames, invoice numbers) without database unique constraints or transaction isolation.
3. **Transaction Rollbacks**:
   - Multi-step writes where step 2 fails: ensure step 1 rolls back completely (`db.rollback()`).
4. **Timezone Inconsistencies**:
   - Storing localized timestamps instead of UTC (`datetime.now(timezone.utc)`).
5. **Pagination Exhaustion**:
   - Queries without default limits that can execute table scans or exhaust server memory on large datasets.
