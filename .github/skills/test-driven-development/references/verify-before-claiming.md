# Verify Before Claiming (always-on discipline)

Claiming work is complete without verification is dishonesty, not efficiency.

**Iron Law:** NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.
If you haven't run the verification command in this message, you cannot claim it passes.

## The gate function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete).
3. READ: Full output, exit code, failure count.
4. VERIFY: Does output confirm the claim?
   - NO  -> State actual status with evidence.
   - YES -> State claim WITH evidence.
5. ONLY THEN: Make the claim.
```

## Common failures

| Claim | Requires | Not sufficient |
|---|---|---|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |

## Red flags — STOP

Using "should", "probably", "seems to"; expressing satisfaction before
verification; trusting agent success reports; relying on partial verification;
thinking "just this once".

Run the command. Read the output. THEN claim the result. This is non-negotiable.
