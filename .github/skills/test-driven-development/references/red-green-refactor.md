# RED → GREEN → REFACTOR cycle

```mermaid
flowchart LR
    A[RED: write failing test] --> B[Verify RED: watch it fail]
    B --> C[GREEN: minimal code to pass]
    C --> D[Verify GREEN: watch it pass]
    D --> E[REFACTOR: clean up, tests stay green]
    E --> F{Next behavior?}
    F -->|yes| A
    F -->|no| G[Done]
```

## Loop rules

- **RED first, always.** No production code without a failing test first.
- **Verify at every phase.** Watch it fail; watch it pass. "Should pass" is not a verification.
- **REFACTOR only after GREEN.** Never refactor before the test passes.
- **One behavior per loop.** Each pass through the cycle adds one behavior, one test, one minimal implementation.
