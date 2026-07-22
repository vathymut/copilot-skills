# Parallel Dispatch

When tasks are **fully independent** — different subsystems, different files, no shared state — dispatch one subagent per problem domain and run them concurrently instead of task-by-task. Typical trigger: several unrelated test files or subsystems broken independently.

**Use when:** each problem can be understood without context from the others, and agents won't edit the same code.

**Don't use when:** failures are related (fixing one may fix others), you need full system state, or agents would touch shared files.

**Pattern:**

1. **Group by independent domain.** One subagent per domain (e.g. one per failing test file / subsystem).
2. **Write focused prompts.** Each is self-contained: specific scope, clear goal, constraints ("don't change other code"), and the exact output you want back. Paste the real error messages and test names — never "fix the race condition".
3. **Dispatch concurrently.** Launch all subagents in one batch.
4. **Review and integrate.** Read each summary, check for conflicting edits, run the full suite, spot-check for systematic errors.

**Prompt smells:** too broad ("fix all the tests"), no context ("fix the race condition"), no constraints (agent refactors everything), vague output ("fix it"). Each is fixed by being specific.

**Good agent prompt structure** — focused, self-contained, specific about output:

```markdown
Fix the 3 failing tests in src/agents/agent-tool-abort.test.ts:

1. "should abort tool with partial output capture" - expects 'interrupted at' in message
2. "should handle mixed completed and aborted tools" - fast tool aborted instead of completed
3. "should properly track pendingToolCount" - expects 3 results but gets 0

These are timing/race condition issues. Your task:

1. Read the test file and understand what each test verifies
2. Identify root cause - timing issues or actual bugs?
3. Fix by:
   - Replacing arbitrary timeouts with event-based waiting
   - Fixing bugs in abort implementation if found
   - Adjusting test expectations if testing changed behavior

Do NOT just increase timeouts - find the real issue.

Return: Summary of what you found and what you fixed.
```

**Common mistakes:**

- Too broad: "Fix all the tests" — agent gets lost. Specific: name the file.
- No context: "Fix the race condition" — agent doesn't know where. Paste the error messages and test names.
- No constraints: agent might refactor everything. "Do NOT change production code" / "Fix tests only".
- Vague output: "Fix it" — you don't know what changed. "Return summary of root cause and changes".

**When NOT to use parallel dispatch:** failures are related (fixing one may fix others); you need full system state; exploratory debugging where you don't yet know what's broken; or agents would interfere (editing the same files, using the same resources).

**Real example:** 6 test failures across 3 files after a refactor — `agent-tool-abort.test.ts` (3 timing failures), `batch-completion-behavior.test.ts` (2, tools not executing), `tool-approval-race-conditions.test.ts` (1, execution count = 0). Dispatched 3 agents concurrently; fixes were independent, zero conflicts, full suite green.

# Inline Fallback (no subagents)

If the platform has no subagents, execute the plan yourself in-session:

1. **Load and review the plan critically.** Identify gaps or concerns; raise them with your human partner before starting. If clean, create a TodoWrite and proceed.
2. **Execute each task** in order: mark in-progress, follow the plan's bite-sized steps exactly, run the verifications it specifies, mark complete.
3. **Stop and ask — don't guess —** on any blocker: missing dependency, failing test, unclear instruction, or repeated verification failure.
4. **Finish** the development branch — verify tests, then offer merge / PR / keep / discard.

Never start implementation on main/master without explicit user consent.