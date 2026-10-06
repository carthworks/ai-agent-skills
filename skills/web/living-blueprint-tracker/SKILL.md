---
name: living-blueprint-tracker
description: |
  Maintains and synchronizes a lightweight, token-efficient living blueprint
  (.app-spec.md or ARCHITECTURE.md) during fast-paced AI vibe coding sessions.
  Use when kicking off a new app, tracking feature progression, preventing
  agent context drift, or when resuming work across separate chat sessions.
  Do NOT use for static documentation generation or writing end-user manuals.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
  tags:
    - vibe-coding
    - blueprint
    - spec-driven
    - context-retention
    - architecture
    - state-tracking
    - agent-memory
---

# Living Blueprint Tracker & Context Anchor

> **Quick Install into any project:**
> ```bash
> curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- skills/web/living-blueprint-tracker
> ```

## Mission

Eliminate **agent amnesia and context drift** during AI-assisted vibe coding sessions by maintaining a compact, self-updating project spec (`.app-spec.md`).

When developers vibe code across multiple chat prompts or sessions:
- Agents forget what styling or icon library was chosen and install duplicates (e.g. mixing `lucide-react` with `heroicons`).
- Agents invent contradictory data schemas or duplicate existing routes.
- Completed features get accidentally wiped during subsequent refactors.

This skill instructs agents to maintain a token-efficient, single-source-of-truth **living blueprint** that grounds every prompt in the project's actual state.

---

## The Living Blueprint Structure (`.app-spec.md`)

Keep the blueprint **under 120 lines** so it can be ingested cheaply at the start of any conversation.

```markdown
# App Specification & Living Blueprint

## 1. Project Overview & Tech Stack
- **Product**: Kanban task manager with real-time markdown notes.
- **Framework**: Next.js 14 (App Router) + React 18 + TypeScript (Strict).
- **Styling**: Tailwind CSS + CSS modules for animations.
- **Icons**: Lucide React (DO NOT install other icon sets).
- **State Management**: Zustand (client state) + TanStack Query (server state).
- **Backend / DB**: Supabase (Postgres + Auth).

## 2. Invariants & Guardrails (Unbreakable Rules)
1. All client forms must validate via Zod schemas before API submission.
2. No component file may exceed 250 lines (extract subcomponents and hooks).
3. Dark theme is default; use Tailwind neutral/emerald color palette.

## 3. Active Routes & Navigation
| Route | Screen / Purpose | Status |
|---|---|---|
| `/` | Landing page & CTA | Complete |
| `/login` | Email/password + OAuth login | Complete |
| `/dashboard` | Board list & workspace switcher | Complete |
| `/board/[id]` | Kanban columns & drag-and-drop cards | In Progress |
| `/settings` | User profile & notifications | Planned |

## 4. Domain Data Contracts
- `Workspace`: `id: string, name: string, ownerId: string, createdAt: string`
- `Board`: `id: string, workspaceId: string, title: string, columns: Column[]`
- `Card`: `id: string, columnId: string, title: string, description?: string, priority: 'low'|'med'|'high'`

## 5. Completed Milestones & Next Tasks
- [x] Base layout shell with responsive bottom nav and header.
- [x] Auth flow with Supabase session cookies.
- [x] Board CRUD operations.
- [ ] Card drag-and-drop reordering with optimistic updates.
- [ ] Card detail modal with markdown editor.
```

---

## Agent Protocol & Execution Rules

### 1. Pre-Flight Read
- When beginning a new prompt or feature, check if `.app-spec.md` exists.
- If present, align immediately with the documented tech stack, icon library, and data models. Never install competing packages.

### 2. Auto-Synchronization
Whenever the agent completes a meaningful feature:
- Update Section 3 (Routes) if a new page was created.
- Update Section 4 (Data Contracts) if a schema was modified.
- Mark checkboxes in Section 5 (Milestones).

### 3. Blueprint Creation on Greenfield Projects
If an existing project has no `.app-spec.md`:
- After the user defines their initial idea, generate `.app-spec.md` as the very first file.
- Confirm the 3-5 core technology choices with the user before writing application boilerplate.
