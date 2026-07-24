---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

# Test-Driven Development (TDD)

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

**The Iron Law:** NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST. Write code before the test? Delete it. Start over. No exceptions — don't keep it as "reference", don't "adapt", don't look at it. Implement fresh from tests.

## The Four Phases

### RED — Write failing test

One minimal test, one behavior, clear name, real code (no mocks unless unavoidable).

<Good>
```typescript
test('retries failed operations 3 times', async () => {
  let attempts = 0;
  const operation = () => { attempts++; if (attempts < 3) throw new Error('fail'); return 'success'; };
  const result = await retryOperation(operation);
  expect(result).toBe('success'); expect(attempts).toBe(3);
});
```
</Good>

<Bad>
```typescript
test('retry works', async () => { /* mocks, vague name */ });
```
</Bad>

### Verify RED — Watch it fail

```bash
npm test path/to/test.test.ts
```
MANDATORY. Confirm: test fails (not errors), failure message is expected, fails because feature missing (not typos). Test passes? You're testing existing behavior — fix test.

### GREEN — Minimal code to pass

Write simplest code that passes the test. Don't add features, refactor, or "improve" beyond the test.

```typescript
async function retryOperation<T>(fn: () => Promise<T>): Promise<T> {
  for (let i = 0; i < 3; i++) { try { return await fn(); } catch (e) { if (i === 2) throw e; } }
  throw new Error('unreachable');
}
```

### Verify GREEN — Watch it pass

```bash
npm test path/to/test.test.ts
```
MANDATORY. Confirm: test passes, other tests still pass, output pristine. Test fails? Fix code, not test.

### REFACTOR — Clean up (only after GREEN)

Remove duplication, improve names, extract helpers. Keep tests green. Don't add behavior.

### Repeat

Next failing test for next feature.

## Example: Bug Fix

**RED:** `test('rejects empty email', async () => { const result = await submitForm({ email: '' }); expect(result.error).toBe('Email required'); });`

**Verify RED:** `FAIL: expected 'Email required', got undefined`

**GREEN:** `function submitForm(data) { if (!data.email?.trim()) return { error: 'Email required' }; ... }`

**Verify GREEN:** `PASS`

**REFACTOR:** Extract validation for multiple fields if needed.

## Verification Checklist

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing (feature missing, not typo)
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass, output pristine (no errors/warnings)
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered

Can't check all boxes? You skipped TDD. Start over.

## Red Flags — STOP, delete code, restart

- Code before test / test added "later" / test passes immediately
- Rationalizations: "just this once", "already manually tested", "tests-after achieve same purpose", "keep as reference"
- **All of these mean: Delete code. Start over with TDD.**

## Always verify before claiming done

Run verification command and read fresh output — never "should pass". See `references/verify-before-claiming.md`.

## When Stuck

| Problem | Solution |
|---|---|
| Don't know how to test | Write wished-for API. Write assertion first. Ask. |
| Test too complicated | Design too complicated. Simplify. |
| Must mock everything | Code too coupled. Use dependency injection. |
| Test setup huge | Extract helpers. Still complex? Simplify design. |

## Coverage (after code exists)

```bash
pytest --cov=<package> --cov-report=term-missing
```
Target 100% on changed lines. Each missing line = test to write or dead code to delete.

## Diagram → `references/red-green-refactor.md`

## Final Rule

```
Production code → test exists and failed first
Otherwise → not TDD
```
