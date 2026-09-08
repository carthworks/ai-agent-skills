---
name: test-coverage-guidance
description: |
  Guides what, when, and how to test code — choosing between unit, integration,
  and end-to-end tests. Use when writing tests, deciding test strategy, setting up
  testing frameworks, or when the user asks "what should I test", "how do I test X",
  "is my test coverage good enough", or "unit vs integration". Applies to any
  language or framework.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
---

# Test Coverage Guidance

> [!TIP]
> The goal is **confidence**, not coverage percentage. A 95% coverage score
> with tests that only check happy paths is worse than 60% coverage with tests
> that catch real regressions.

---

## The Testing Pyramid

```
         /\
        /E2E\          Few — slow, brittle, expensive
       /------\
      /  Integ  \      Some — test units working together
     /------------\
    /     Unit      \  Many — fast, isolated, precise
   /------------------\
```

- **Unit**: one function/class in isolation, dependencies mocked
- **Integration**: multiple units working together (real DB, real HTTP calls)
- **E2E**: full user journey through the UI (Playwright, Cypress)

---

## What to Test — Decision Guide

### Always write tests for:

- **Business logic** — calculation, transformation, validation rules
- **Edge cases** — empty input, null, zero, max values, boundary conditions
- **Error paths** — what happens when the DB is down, input is invalid, token expires
- **Public API contracts** — function signatures and return shapes other code depends on
- **Security boundaries** — auth checks, permission checks, input sanitisation
- **Bug fixes** — write a test that reproduces the bug before fixing it

### Unit test when:
- The logic is pure (same input → same output, no side effects)
- External dependencies can be meaningfully mocked
- Fast feedback during development is important

### Integration test when:
- Testing that two systems work together (app + DB, service + cache)
- The interaction between layers matters more than each layer individually
- Mocking would hide the actual failure mode

### E2E test when:
- Testing a critical user journey (signup, checkout, login)
- Regression protection on flows that involve multiple pages/services
- Keep E2E tests narrow — only core happy paths

---

## What NOT to Test

- Implementation details (private methods, internal state)
- Third-party library internals
- Trivial getters/setters with no logic
- Configuration files (test they're read correctly, not their values)

---

## Test Structure — Arrange, Act, Assert

```ts
describe('calculateDiscount', () => {
  it('applies 10% discount for premium users', () => {
    // Arrange
    const user = { tier: 'premium' };
    const price = 100;

    // Act
    const result = calculateDiscount(user, price);

    // Assert
    expect(result).toBe(90);
  });

  it('returns full price for standard users', () => {
    const user = { tier: 'standard' };
    expect(calculateDiscount(user, 100)).toBe(100);
  });

  it('throws when price is negative', () => {
    expect(() => calculateDiscount({ tier: 'premium' }, -10))
      .toThrow('Price cannot be negative');
  });
});
```

---

## Framework Quick Reference

### JavaScript / TypeScript

| Framework | Best for |
|-----------|----------|
| **Vitest** | Unit + integration, Vite projects, fast |
| **Jest** | Unit + integration, universal |
| **Playwright** | E2E, cross-browser, modern |
| **Cypress** | E2E, component testing |
| **Testing Library** | React/Vue/Angular component tests |

```ts
// Vitest / Jest example
import { describe, it, expect, vi } from 'vitest';

it('sends welcome email on user creation', async () => {
  const sendEmail = vi.fn();
  await createUser({ email: 'a@b.com' }, { sendEmail });
  expect(sendEmail).toHaveBeenCalledWith({
    to: 'a@b.com',
    template: 'welcome',
  });
});
```

### Python

```python
# pytest
def test_calculate_discount_for_premium_user():
    user = User(tier='premium')
    assert calculate_discount(user, price=100) == 90

def test_raises_on_negative_price():
    with pytest.raises(ValueError, match='Price cannot be negative'):
        calculate_discount(User(tier='premium'), price=-10)
```

---

## Testing Async Code

```ts
// ✅ Await the assertion
it('fetches user by id', async () => {
  const user = await getUser(42);
  expect(user.name).toBe('Alice');
});

// ✅ Test rejection
it('throws 404 when user not found', async () => {
  await expect(getUser(999)).rejects.toThrow('User not found');
});

// ✅ Mock fetch / HTTP calls
vi.mock('./api', () => ({
  fetchUser: vi.fn().mockResolvedValue({ id: 1, name: 'Alice' }),
}));
```

---

## Coverage Targets (Practical)

| Area | Target | Rationale |
|------|--------|-----------|
| Business logic / domain | 90%+ | High value, high risk |
| API handlers / controllers | 80%+ | Integration tested |
| UI components | 70%+ | Testing Library for behaviour |
| Config / boilerplate | 0–40% | Low ROI |
| Overall | 70–80% | Above this, diminishing returns |

> Coverage % is a floor, not a ceiling. 70% with meaningful tests beats 95% with trivial ones.

---

## CI Integration

Every repo should run tests in CI on every PR:

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci
      - run: npm test -- --coverage
      - run: npm run test:e2e   # if applicable
```

---

## Test Checklist

- [ ] Happy path tested
- [ ] Edge cases tested (empty, null, boundary values)
- [ ] Error/failure paths tested
- [ ] No tests asserting implementation details
- [ ] Tests are deterministic (no random data, no date.now() without mocking)
- [ ] Async code properly awaited
- [ ] CI runs tests on every PR
- [ ] Coverage ≥ 70% on business logic
