---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

# Test-Driven Development (TDD)

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

## When to Use

**Always:**
- New features
- Bug fixes
- Refactoring
- Behavior changes

**Exceptions (ask your human partner):**
- Throwaway prototypes
- Generated code
- Configuration files

Thinking "skip TDD just this once"? Stop. That's rationalization.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

**No exceptions:**
- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Don't look at it
- Delete means delete

Implement fresh from tests. Period.

## The Four Phases

### RED — Write failing test

One minimal test, one behavior, clear name, real code (no mocks unless unavoidable). Before writing the body, name the break it catches: `writing-good-tests.md` (Principle 1 gate).

### Verify RED — Watch it fail

**MANDATORY. Never skip.** Run the project's test command against the new test file.

Confirm: test fails (not errors), failure message is expected, fails because feature missing (not typos). Test passes? You're testing existing behavior — fix test. Test errors? Fix error, re-run until it fails correctly.

### GREEN — Minimal code to pass

Write simplest code that passes the test. Don't add features, refactor, or "improve" beyond the test.

### Verify GREEN — Watch it pass

**MANDATORY.** Run the project's test command against the new test file, then the full suite.

Confirm: test passes, output pristine. Test fails? Fix code, not test.

**"Other tests" means the project's suite, not just your file.** A green run of the test you wrote is not a green suite. Before you call the change done, run the project's test command (bare `pytest`, `npm test`, `cargo test` — whatever the repo uses) even when your task named only one test file. A scope statement in your task bounds the deliverable, not your verification. Any failure that run shows — including one you didn't cause — goes in your report by name; a red test you watched scroll past and didn't mention is a report falsified by omission.

### REFACTOR — Clean up (only after GREEN)

Remove duplication, improve names, extract helpers. Keep tests green. Don't add behavior.

### REFACTOR — Commit

Commit the green step: `git commit -m "feat: <behavior> (RED-GREEN)"`. One behavior per commit.

### Repeat

Next failing test for next feature.

## Good Tests

| Quality | Good | Bad |
|---------|------|-----|
| **Minimal** | One thing. "and" in name? Split it. | `test('validates email and domain and whitespace')` |
| **Clear** | Name describes behavior | `test('test1')` |
| **Shows intent** | Demonstrates desired API | Obscures what code should do |

When writing or changing any test, hold to these rules (full version with gate functions, mutation check, and warning signs: `writing-good-tests.md`):
- Name the production change that would make the test fail — before writing it
- Assert on real behavior, never on mock behavior
- Keep test-only code in test utilities, out of production classes
- Understand a dependency's side effects before mocking it

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests written after pass immediately — which proves nothing. They may test the wrong thing, test the implementation instead of the behavior, or miss the edge case you forgot. You never watched it fail, so you never proved it can catch the bug. Test-first forces that failure. |
| "Tests after achieve same goals (spirit not ritual)" | Tests-after answer "what does this do?"; tests-first answer "what should this do?" Tests written after are biased by the code you already wrote — you verify the cases you remembered, not the ones you'd have discovered. Coverage without proof the tests work. |
| "Already manually tested" | Manual testing is ad-hoc: no record of what you covered, no way to re-run it when the code changes, easy to forget cases under pressure. "Worked when I tried it" ≠ comprehensive. Automated tests run the same way every time. |

## Example: Bug Fix

**RED:** `test('rejects empty email', async () => { const result = await submitForm({ email: '' }); expect(result.error).toBe('Email required'); });`

**Verify RED:** `FAIL: expected 'Email required', got undefined`

**GREEN:** `function submitForm(data) { if (!data.email?.trim()) return { error: 'Email required' }; ... }`

**Verify GREEN:** `PASS` on the file, then full suite green

**REFACTOR:** Extract validation for multiple fields if needed.

## Completion criteria (Verification Checklist)

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing (feature missing, not typo)
- [ ] Wrote minimal code to pass each test
- [ ] Full project suite green; every failure reported by name, including uncaused ones
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered

Can't check all boxes? You skipped TDD. Start over.

## Red Flags — STOP, delete code, restart

- Code before test / test added "later" / test passes immediately
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
