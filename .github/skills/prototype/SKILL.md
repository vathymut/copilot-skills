---
name: prototype
description: Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check logic, a state model, or a UI direction — NOT for production code, full feature implementation, or executing an existing plan.
---

A prototype is **throwaway code that answers a question**.

## Pick the branch

- **Logic / state model** → [references/LOGIC.md](references/LOGIC.md).
- **UI direction** → [references/UI.md](references/UI.md).

If the question is ambiguous and the user isn't reachable, default to the branch that matches the surrounding code.

## Rules

1. **Mark it throwaway.** Name files/paths so a casual reader can tell this is not production code.
2. **One command to run.** Use the project's task runner.
3. **No persistence by default.** State lives in memory. If persistence is the question, use a clearly-labeled scratch store.
4. **Skip the polish.** No tests, no abstractions, no error handling beyond "runnable".
5. **Surface state after every action or variant switch.**
6. **Capture the answer when done.** Fold validated decisions into real code. Archive the prototype on a throwaway branch and leave a pointer in the issue.

## Completion criteria

- [ ] The question is answered concretely.
- [ ] The prototype runs with one command.
- [ ] The decision and pointer are recorded.
