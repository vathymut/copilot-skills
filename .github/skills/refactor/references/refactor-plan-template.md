# Refactor Plan Template

Use this template when the refactor touches more than one file or the user asks for a written plan first.

## Refactor Plan: [title]

### Current State

Brief description of how things work now.

### Target State

Brief description of how things will work after.

### Affected Files

| File | Change Type | Dependencies |
|------|-------------|--------------|
| path | modify/create/delete | blocks X, blocked by Y |

### Execution Plan

#### Phase 1: Types and Interfaces

- [ ] Step 1.1: [action] in `file.ts`
- [ ] Verify: [how to check it worked]

#### Phase 2: Implementation

- [ ] Step 2.1: [action] in `file.ts`
- [ ] Verify: [how to check]

#### Phase 3: Tests

- [ ] Step 3.1: Update tests in `file.test.ts`
- [ ] Verify: Run `npm test`

#### Phase 4: Cleanup

- [ ] Remove deprecated code
- [ ] Update documentation

### Rollback Plan

If something fails:

1. [Step to undo]
2. [Step to undo]

### Risks

- [Potential issue and mitigation]
