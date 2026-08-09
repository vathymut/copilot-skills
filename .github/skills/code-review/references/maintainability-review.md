# Maintainability Review

Deep standards behind `code-review` Factor 4. Loaded when structural concerns are found. Read for the depth behind the checklist in SKILL.md; report restructuring findings — never implement them.

## Non-Negotiable Standards

0. **Be ambitious about structural simplification.** Look for the "code judo" move: reframing the change so whole branches, helpers, modes, or layers disappear. Assume a simpler arrangement usually exists; prefer the solution that feels inevitable in hindsight. If you see a path to delete complexity rather than rearrange it, push hard for it.

1. **Do not push a file past 1000 lines without a very strong reason.** A diff crossing that threshold is a smell by default — ask whether the code should be decomposed first. Waive only for a compelling structural reason and a still-organized file.

2. **Do not allow random spaghetti growth.** New ad-hoc conditionals, scattered special cases, or one-off branches inserted into unrelated flows are design problems, not stylistic nits. Push the logic into a dedicated abstraction (helper, state machine, policy object, module) instead of tangling an existing path.

3. **Bias toward cleaning the design.** If behavior can stay the same while the structure becomes meaningfully cleaner, push for the cleaner version. Do not rubber-stamp "it works" implementations that leave the codebase messier. Deleting moving pieces beats spreading the same complexity around.

4. **Prefer direct, boring, maintainable code.** Flag brittle, ad-hoc, or "magic" behavior; thin abstractions; identity wrappers; and pass-through helpers that add indirection without buying clarity. If a branch relies on silent fallback to paper over an unclear invariant, ask whether the boundary should be explicit instead.

5. **Keep logic in the canonical layer.** Flag feature logic leaking into shared paths or implementation details leaking through APIs. Prefer existing canonical utilities over bespoke one-offs. Push code toward the package, service, or module that owns the concept.

6. **Treat avoidable orchestration complexity as a design smell.** If independent work is serialized for no good reason, ask whether it should run in parallel. If related updates can leave state half-applied, push for a more atomic structure.

## Flags

Escalate findings when you see:

- A complicated implementation where a cleaner reframing could delete whole categories of complexity
- Refactors that move code around but fail to reduce the concepts a reader must hold in their head
- A file crossing 1000 lines due to the diff
- New conditionals bolted onto unrelated code paths; one-off booleans or nullable modes complicating control flow
- Feature-specific logic leaking into general-purpose modules
- Generic "magic" handling that hides simple structure
- Thin wrappers, identity abstractions, unnecessary casts / `any` / `unknown` / optional params muddying the real contract
- Copy-pasted logic instead of extracted helpers; bespoke helpers where a canonical utility exists
- Narrow edge-case handling in the middle of an already busy function
- "Temporary" branching likely to become permanent debt
- Refactors that pass tests but make the code less modular or less readable
- Sequential async flow where parallel would stay simpler; partial-update logic that leaves state non-atomic
- **AI-generated slop**: verbose comments explaining the obvious, defensive `try/except` or `if` blocks that do not match normal paths, broad exception swallowing (`except Exception:`), casts to `any` / `type: ignore`, deep nesting fixable with early returns, anything inconsistent with the surrounding codebase

## Preferred Remedies

- Delete a layer of indirection rather than polish it
- Reframe the state model so conditionals disappear instead of centralizing them
- Change the ownership boundary so the feature becomes a natural extension of an existing abstraction
- Turn special-case logic into a simpler default flow with fewer exceptions
- Extract a helper or pure function; split a large file into focused modules
- Replace condition chains with a typed model or explicit dispatcher; make type boundaries explicit
- Separate orchestration from business logic; parallelize independent work; restructure into atomic flows
- Reuse the canonical helper instead of a near-duplicate; move logic to the layer that owns the concept
- Delete wrappers that do not meaningfully clarify the API

Do not settle for "maybe rename this" when the real issue is structural, and do not settle for a cleaner version of a messy idea when a much simpler one is plausible.

## Priority and Tone

Order findings: structural regressions > missed dramatic simplifications > spaghetti/branching increases > boundary/type-contract problems > file-size > modularity > legibility. Prefer a few high-conviction comments over a list of cosmetic notes.

Be direct, serious, and demanding without being rude. If the code is making the codebase messier or missed an obvious simplification, say so plainly. Do not approve merely because behavior seems correct — the bar is: no structural regression, no obvious missed path to a dramatically simpler implementation, no unjustified file-size explosion, no spaghetti growth from special-case branching, no needless wrapper/cast/optionality churn, no boundary leak or canonical-helper duplication.
