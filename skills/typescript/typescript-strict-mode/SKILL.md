---
name: typescript-strict-mode
description: |
  Enforces TypeScript strict mode configuration and type-safe coding patterns.
  Use when setting up a TypeScript project, reviewing tsconfig.json, fixing type
  errors, or when the user asks about TypeScript strictness, type safety, avoiding
  `any`, or improving their types. Also activates when the agent sees excessive
  use of `any`, type assertions (`as`), or non-null assertions (`!`).
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---

# TypeScript Strict Mode

> [!IMPORTANT]
> TypeScript's value comes entirely from its type system. Using `any`, `as unknown as X`,
> or `!` liberally defeats the purpose. Strict mode catches real bugs at compile time.

---

## The Canonical tsconfig.json

```json
{
  "compilerOptions": {
    "strict": true,                    // enables all strict checks below
    "noUncheckedIndexedAccess": true,  // arr[i] is T | undefined, not T
    "exactOptionalPropertyTypes": true,// {x?: string} ≠ {x: string | undefined}
    "noImplicitReturns": true,         // all code paths must return
    "noFallthroughCasesInSwitch": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "forceConsistentCasingInFileNames": true,
    "esModuleInterop": true,
    "skipLibCheck": false,             // only set true as last resort
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ES2022", "DOM", "DOM.Iterable"]
  }
}
```

`"strict": true` enables: `strictNullChecks`, `strictFunctionTypes`,
`strictBindCallApply`, `strictPropertyInitialization`, `noImplicitAny`,
`noImplicitThis`, `alwaysStrict`.

---

## What `strict` Catches

```ts
// strictNullChecks — null/undefined are not assignable to other types
function greet(name: string) { return `Hello ${name}`; }
greet(undefined);   // ← Error: caught at compile time, not runtime crash

// noImplicitAny — every parameter must be typed
function add(a, b) { return a + b; }   // ← Error
function add(a: number, b: number) { return a + b; }  // ✅

// strictPropertyInitialization — class fields must be assigned
class User {
  name: string;          // ← Error: not definitely assigned
  name: string = '';     // ✅
  constructor(name: string) { this.name = name; }  // ✅
}
```

---

## Patterns to Enforce

### Use `unknown` instead of `any` for external data

```ts
// ❌ any disables all checks
function parse(data: any) { return data.user.name; }

// ✅ unknown forces you to check before use
function parse(data: unknown): string {
  if (
    typeof data === 'object' && data !== null &&
    'user' in data && typeof (data as any).user?.name === 'string'
  ) {
    return (data as { user: { name: string } }).user.name;
  }
  throw new Error('Invalid data shape');
}

// ✅ Even better — use Zod for runtime + compile-time validation
import { z } from 'zod';
const schema = z.object({ user: z.object({ name: z.string() }) });
function parse(data: unknown) { return schema.parse(data).user.name; }
```

### Avoid type assertions — narrow instead

```ts
// ❌ assertion silences the compiler, hides bugs
const el = document.getElementById('root') as HTMLDivElement;

// ✅ narrow with a type guard
const el = document.getElementById('root');
if (!(el instanceof HTMLDivElement)) throw new Error('Root element not found');
el.style.display = 'flex';   // el is HTMLDivElement here
```

### Avoid non-null assertions (`!`)

```ts
// ❌ crashes if user is null
const name = user!.name;

// ✅ assert with a meaningful error
if (!user) throw new Error('User must be defined');
const name = user.name;
```

---

## Utility Types — use these, not manual copying

```ts
type User = { id: number; name: string; email: string; password: string };

Partial<User>              // all fields optional
Required<User>             // all fields required
Readonly<User>             // immutable
Pick<User, 'id' | 'name'> // only those fields
Omit<User, 'password'>    // exclude fields — use for DTOs
Record<string, User>       // dictionary
ReturnType<typeof fn>      // infer return type of a function
Parameters<typeof fn>      // infer param types
Awaited<ReturnType<typeof asyncFn>>  // unwrap Promise
NonNullable<T>             // T without null/undefined
```

---

## Discriminated Unions — model state exhaustively

```ts
type Result<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: Error };

function render(result: Result<User>) {
  switch (result.status) {
    case 'idle':    return <Idle />;
    case 'loading': return <Spinner />;
    case 'success': return <Profile user={result.data} />;
    case 'error':   return <Error msg={result.error.message} />;
    // TypeScript will error if a case is missing (exhaustiveness check)
  }
}
```

---

## Common Anti-Patterns to Block

```ts
// ❌ NEVER do these
const x: any = getValue();
const y = x as string;
const z = x!;
// @ts-ignore  ← only acceptable with a comment explaining why
// @ts-expect-error  ← prefer this over @ts-ignore, documents intent

// ❌ Widening to object
function fn(arg: object) {}   // use a specific interface

// ❌ Empty interface
interface Foo {}   // use `type Foo = Record<string, never>` or just remove it
```

---

## Checklist

- [ ] `"strict": true` in tsconfig
- [ ] `"noUncheckedIndexedAccess": true`
- [ ] No bare `any` types (use `unknown` + narrowing)
- [ ] No unchecked `!` assertions (guard instead)
- [ ] No unchecked `as` casts (narrow instead)
- [ ] External API data validated at runtime (Zod, Valibot)
- [ ] State modelled as discriminated unions
- [ ] Utility types used for derived types (Omit, Pick, Partial)
- [ ] `@ts-ignore` has a comment explaining why
