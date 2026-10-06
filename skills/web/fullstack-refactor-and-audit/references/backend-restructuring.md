# Backend Restructuring Guide

This guide details patterns for restructuring monolithic or flat backend codebases into scalable, modular `app/` packages.

---

## 1. Core Principles of the `app/` Package Architecture

Monolithic backends (e.g. single-file `app.py`, `server.js`, or flat files sharing global state) become unmaintainable as routes and domain logic grow. The `app/` architecture enforces:

1. **Separation of Concerns**: HTTP routing is strictly decoupled from business logic, database queries, and external integration clients.
2. **Factory Pattern**: The application instance is constructed via a factory function (`create_app()`) rather than instantiated as a global variable at import time. This enables clean unit testing with distinct configs.
3. **Explicit Dependency Injection**: Database sessions, configuration objects, and authenticated user contexts are injected into routes rather than imported as global variables.
4. **Circular Import Immunity**: Module dependencies flow strictly in one direction:
   ```
   Entrypoint (run.py / index.ts)
     ↓
   API Transport Layer (routers / controllers)
     ↓
   Business Services Layer (domain logic / workflows)
     ↓
   Data Layer (models / schemas / repositories)
     ↓
   Core Infrastructure (config / database connections / logger)
   ```

---

## 2. Python Architecture (FastAPI / Flask)

### Recommended Directory Structure

```
backend/
├── app/
│   ├── __init__.py               # Exports create_app or app instance
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py             # Pydantic BaseSettings config
│   │   ├── database.py           # Engine, SessionLocal, Base
│   │   ├── security.py           # Password hashing, JWT creation/verification
│   │   └── logging.py            # Structured logging config
│   ├── api/
│   │   ├── __init__.py
│   │   ├── deps.py               # get_db, get_current_user dependencies
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── api.py            # Central v1 router aggregating all endpoints
│   │       └── endpoints/
│   │           ├── auth.py
│   │           ├── users.py
│   │           └── items.py
│   ├── models/                   # SQLAlchemy / SQLModel database entities
│   │   ├── __init__.py           # Explicit model exports to register with Base
│   │   ├── user.py
│   │   └── item.py
│   ├── schemas/                  # Pydantic input/output validation models
│   │   ├── __init__.py
│   │   ├── user.py
│   │   └── item.py
│   └── services/                 # Pure domain business logic & transactions
│       ├── __init__.py
│       ├── user_service.py
│       └── item_service.py
├── tests/
│   ├── conftest.py               # Fixtures using create_app() & test DB
│   └── test_api/
└── run.py                        # Minimal entrypoint for uvicorn/gunicorn
```

### Pattern: Typed Configuration (`app/core/config.py`)

```python
from pydantic_settings import BaseSettings
from typing import List, Optional

class Settings(BaseSettings):
    PROJECT_NAME: str = "My Application"
    API_V1_STR: str = "/api/v1"
    SECRET_KEY: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24
    DATABASE_URL: str
    CORS_ORIGINS: List[str] = ["http://localhost:3000"]

    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
```

### Pattern: Application Factory (`app/__init__.py`)

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.v1.api import api_router

def create_app() -> FastAPI:
    application = FastAPI(
        title=settings.PROJECT_NAME,
        openapi_url=f"{settings.API_V1_STR}/openapi.json"
    )

    application.add_middleware(
        CORSMiddleware,
        allow_origins=settings.CORS_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    application.include_router(api_router, prefix=settings.API_V1_STR)
    return application

app = create_app()
```

### Pattern: Minimal Entrypoint (`run.py`)

```python
import uvicorn
from app import app

if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
```

---

## 3. Node.js / TypeScript Architecture (Express / Fastify)

### Recommended Directory Structure

```
backend/
├── src/
│   ├── app.ts                    # createApp() factory & middleware setup
│   ├── server.ts                 # Entrypoint starting HTTP listener
│   ├── config/
│   │   ├── env.ts                # Zod-validated environment config
│   │   └── logger.ts             # Pino / Winston structured logger
│   ├── routes/
│   │   ├── index.ts              # Root router mounting /api/v1
│   │   └── v1/
│   │       ├── auth.routes.ts
│   │       └── user.routes.ts
│   ├── controllers/              # Request / response orchestration
│   │   ├── auth.controller.ts
│   │   └── user.controller.ts
│   ├── services/                 # Domain business logic
│   │   ├── auth.service.ts
│   │   └── user.service.ts
│   ├── middlewares/              # Auth, validation, error handler, rate limit
│   │   ├── auth.middleware.ts
│   │   ├── validate.middleware.ts
│   │   └── error.middleware.ts
│   └── schemas/                  # Zod request validation schemas
│       ├── auth.schema.ts
│       └── user.schema.ts
└── tsconfig.json
```

---

## 4. Refactoring Migration Checklist

When refactoring an existing project:

1. [ ] **Snapshot Existing Routes**: Document all active endpoints, query parameters, and expected response codes.
2. [ ] **Create New Folder Skeleton**: Scaffold `app/` (or `src/`) and subdirectories before moving existing code.
3. [ ] **Extract Database & Settings First**: Decouple configuration and database connections before moving routes.
4. [ ] **Migrate One Domain at a Time**:
   - Move models and schemas for Domain A.
   - Move business logic into `services/domain_a.py`.
   - Create router `api/v1/endpoints/domain_a.py` and register it.
   - Run tests or curl endpoints to verify before moving Domain B.
5. [ ] **Eliminate Circular Dependencies**: Never import routers from services or models from API endpoints if schemas exist.
6. [ ] **Clean Up Old Entrypoints**: Replace the old monolithic file with a thin wrapper delegating to `app/`.
