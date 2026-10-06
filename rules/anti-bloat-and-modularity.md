---
name: anti-bloat-and-modularity
category: architecture
description: Prevents monolith file bloat and spaghetti architecture during vibe coding by enforcing file size limits, component splitting, and custom hook extraction.
metadata:
  version: v1
  publisher: carthworks
  tags:
    - anti-bloat
    - modularity
    - refactoring
    - component-splitting
    - clean-code
---

# Anti-Bloat & Modularity Guardrails

## The Vibe Coding Anti-Pattern
During rapid AI generation ("vibe coding"), AI agents naturally take the path of least resistance: dumping data fetching, multiple modal dialogs, form handling, and inline styles into a single 1,500-line "god component".

This causes:
- Cascading re-render performance drops.
- Fragile state where touching one feature breaks three others.
- Agent context window degradation on subsequent edits.

---

## Core Guardrail Rules

```
┌────────────────────────────────────────────────────────────────────────┐
│                        MODULAR COMPONENT ARCHITECTURE                  │
├────────────────────────────┬───────────────────────────────────────────┤
│ 1. Component Shell (<250L) │ Pure presentation, composition, styling   │
├────────────────────────────┼───────────────────────────────────────────┤
│ 2. Custom Hooks (`useX`)   │ State machine, effect triggers, data calls│
├────────────────────────────┼───────────────────────────────────────────┤
│ 3. Types & Schemas         │ Zod schemas, TypeScript interfaces        │
├────────────────────────────┼───────────────────────────────────────────┤
│ 4. Extracted Subviews      │ Modals, list items, headers, drawer panels│
└────────────────────────────┴───────────────────────────────────────────┘
```

### 1. The 250-Line Threshold
- Any UI component file that exceeds **250 lines of code** MUST be split before adding new features.
- Never add a new sub-feature into an already bloated file. First extract existing sections, then proceed.

### 2. Mandatory Custom Hook Extraction
- If a component requires more than 3 `useState` hooks or multiple `useEffect` listeners, extract them into a dedicated hook (e.g., `useDashboardState.ts` or `useCartActions.ts`).
- The component body should read declaratively:
  ```tsx
  // GOOD: Declarative, decoupled
  export function ProjectList() {
    const { projects, isLoading, createProject, deleteProject } = useProjects();
    if (isLoading) return <ProjectListSkeleton />;
    return <ProjectGrid items={projects} onAdd={createProject} onDelete={deleteProject} />;
  }
  ```

### 3. Sub-Component Colocation
- Modals, complex form rows, and list items must live in separate files:
  ```
  components/project-card/
  ├── ProjectCard.tsx         # Main entry point (<100 lines)
  ├── ProjectCardHeader.tsx   # Header & badge view
  ├── ProjectCardActions.tsx  # Dropdown menu & buttons
  └── useProjectCardMenu.ts   # Action handlers & confirmation logic
  ```

### 4. Zero Inline Mock Dumps
- Never embed multi-kilobyte mock JSON objects directly within component files.
- Place mock fixtures into `fixtures/` or `mocks/` (e.g., `mocks/mockProjects.ts`).
