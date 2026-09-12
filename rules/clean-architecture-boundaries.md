---
name: clean-architecture-boundaries
category: architecture
description: Architectural separation of concerns separating UI presentation, domain business logic, and infrastructure/data access layers.
metadata:
  version: v1
  publisher: carthworks
  tags:
    - architecture
    - clean-code
    - boundaries
    - domain-driven
---

# Clean Architecture Boundaries

## Core Layers & Isolation

```
┌────────────────────────────────────────────────────────┐
│ 1. Presentation Layer (React / UI / Components)        │
│    - Pure rendering, UI state, accessible markup       │
├────────────────────────────────────────────────────────┤
│ 2. Application & Domain Layer (Hooks, Services, Logic) │
│    - Business validation, transformations, calculations│
├────────────────────────────────────────────────────────┤
│ 3. Infrastructure & Data Layer (API / DB / Storage)    │
│    - DB queries, ORM calls, HTTP client, external SDKs │
└────────────────────────────────────────────────────────┘
```

## Directives
1. **No Data Access in UI**: UI components must never query databases, invoke raw SQL, or fetch third-party credentials directly.
2. **Server Action Isolation**: In Next.js / fullstack frameworks, Server Actions must act as controllers delegating to domain services.
3. **Dependency Inversion**: High-level modules must depend upon domain abstractions/interfaces, not low-level database drivers.
