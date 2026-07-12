# Ideation Frameworks

Ten complementary ideation lenses for discovering research ideas. Each targets a different cognitive mode — use individually or combine for comprehensive exploration.

## F1. Problem-First vs. Solution-First Thinking

Research ideas originate from two distinct modes. Knowing which mode you are in prevents building solutions without real problems or chasing problems without feasible approaches.

**Problem-First** (pain point → method):
- Start with a concrete failure, bottleneck, or unmet need
- Yields impactful work because motivation is intrinsic
- Risk: may converge on incremental fixes rather than paradigm shifts

**Solution-First** (new capability → application):
- Start with a new tool, insight, or technique seeking application
- Drives breakthroughs by unlocking previously impossible approaches
- Risk: "hammer looking for a nail"

**Workflow**:
1. Write down your idea in one sentence
2. Classify: problem-first or solution-first?
3. If problem-first → verify the problem matters (who suffers? how much?)
4. If solution-first → identify at least two genuine problems it addresses
5. Articulate the gap: what cannot be done today that this enables?

**Self-Check**:
- [ ] Can I name a specific person or community who needs this?
- [ ] Is the problem actually unsolved (not just under-marketed)?
- [ ] If solution-first, does it create new capability or replicate existing ones?

---

## F2. The Abstraction Ladder

Every research problem sits at a particular level of abstraction. Deliberately moving up or down reveals ideas invisible at your current level.

| Direction | Action | Outcome |
|-----------|--------|---------|
| **Move Up** (generalize) | Turn a specific result into a broader principle | Framework papers, theoretical contributions |
| **Move Down** (instantiate) | Test a general paradigm under concrete constraints | Empirical papers, surprising failure analyses |
| **Move Sideways** (analogize) | Apply same abstraction level to adjacent domain | Cross-pollination, transfer papers |

**Workflow**:
1. State your current research focus in one sentence
2. Move UP: What is the general principle behind this?
3. Move DOWN: What is the most specific, constrained instance?
4. Move SIDEWAYS: Where else does this pattern appear in a different field?
5. For each new level, ask: Is this a publishable contribution on its own?

---

## F3. Tension and Contradiction Hunting

Breakthroughs often come from resolving tensions between widely accepted but seemingly conflicting goals.

| Tension Pair | Research Opportunity |
|-------------|---------------------|
| Performance ↔ Efficiency | Can we match SOTA with 10x less compute? |
| Privacy ↔ Utility | Can federated/encrypted methods close the accuracy gap? |
| Generality ↔ Specialization | When does fine-tuning beat prompting, and why? |
| Safety ↔ Capability | Can alignment improve rather than tax capability? |
| Interpretability ↔ Performance | Do mechanistic insights enable better architectures? |
| Scale ↔ Accessibility | Can small models replicate emergent behaviors? |

**Workflow**:
1. Pick your research area
2. List the top 3-5 desiderata
3. Identify pairs commonly treated as trade-offs
4. Ask: Is this trade-off fundamental or an artifact of current methods?
5. If artifact → the reconciliation IS your research contribution
6. If fundamental → characterizing the Pareto frontier is itself valuable

---

## F4. Cross-Pollination (Analogy Transfer)

Borrowing structural ideas from other disciplines. Many foundational techniques emerged this way — attention from cognitive science, genetic algorithms from biology, adversarial training from game theory.

**Requirements for a Valid Analogy**:
- **Structural fidelity**: mapping holds at the mechanism level, not just surface similarity
- **Non-obvious connection**: if the link is well-known, novelty is gone
- **Testable predictions**: analogy should generate concrete hypotheses

**High-Yield Source Fields for ML Research**:

| Source Field | Transferable Concepts |
|-------------|----------------------|
| Neuroscience | Attention, memory consolidation, hierarchical processing |
| Physics | Energy-based models, phase transitions, renormalization |
| Economics | Mechanism design, auction theory, incentive alignment |
| Ecology | Population dynamics, niche competition, co-evolution |
| Linguistics | Compositionality, pragmatics, grammatical induction |
| Control Theory | Feedback loops, stability, adaptive regulation |

**Workflow**:
1. Describe your problem in domain-agnostic language
2. Ask: What other field solves a structurally similar problem?
3. Study that field's solution at the mechanism level
4. Map the solution back, preserving structural relationships
5. Generate testable predictions from the analogy
6. Validate: Does the borrowed idea actually improve outcomes?

---

## F5. The "What Changed?" Principle

Revisiting old problems under new conditions. Advances in hardware, scale, data, or regulations can invalidate prior assumptions.

| Change Type | Example | Research Implication |
|------------|---------|---------------------|
| **Compute** | GPUs 10x faster | Methods dismissed as too expensive become feasible |
| **Scale** | Trillion-token datasets | Statistical arguments that failed at small scale may now hold |
| **Regulation** | EU AI Act, GDPR | Creates demand for compliant alternatives |
| **Tooling** | New frameworks, APIs | Reduces implementation barrier for complex methods |
| **Failure** | High-profile system failures | Exposes gaps in existing approaches |
| **Cultural** | New user behaviors | Shifts what problems matter most |

**Workflow**:
1. Pick a well-known negative result or abandoned approach (3-10 years old)
2. List the assumptions that led to its rejection
3. For each assumption: Is this still true today?
4. If any assumption invalidated → re-run the idea under new conditions
5. Frame: "X was previously impractical because Y, but Z has changed"

---

## F6. Failure Analysis and Boundary Probing

Understanding where a method breaks is often as valuable as showing where it works.

**Types of Boundaries to Probe**:
- **Distributional**: Out-of-distribution inputs?
- **Scale**: Degradation at 10x or 0.1x typical scale?
- **Adversarial**: Can the method be deliberately broken?
- **Compositional**: Does performance hold when combining capabilities?
- **Temporal**: Degradation over time (concept drift)?

**Workflow**:
1. Select a widely-used method with strong reported results
2. Identify implicit assumptions in its evaluation
3. Systematically violate each assumption
4. Document where and how the method breaks
5. Diagnose the root cause of each failure
6. Propose a fix or explain why the failure is fundamental

---

## F7. The Simplicity Test

Before accepting complexity, ask whether a simpler approach suffices.

**Warning Signs of Unnecessary Complexity**:
- Many hyperparameters with narrow optimal ranges
- Ablations show most components contribute marginally
- A simple baseline was never properly tuned or evaluated
- Improvement over baselines is within noise on most benchmarks

**Workflow**:
1. Identify the current SOTA method
2. Strip to its simplest possible core
3. Build that minimal version with careful engineering
4. Compare fairly: same compute budget, same tuning effort
5. If gap is small → contribution is the simplicity itself
6. If gap is large → you now understand what the complexity buys

---

## F8. Stakeholder Rotation

Viewing a system from multiple perspectives reveals distinct research questions.

| Stakeholder | Key Questions |
|-------------|---------------|
| **End User** | Is this usable? What errors are unacceptable? |
| **Developer** | Is this debuggable? Maintenance burden? |
| **Theorist** | Why does this work? Formal guarantees? |
| **Adversary** | How can this be exploited? Attack surfaces? |
| **Ethicist** | Who is harmed? What biases are embedded? |
| **Regulator** | Is this auditable? Can decisions be explained? |
| **Operator** | What is the cost? How does it scale? |

**Workflow**:
1. Describe your system in one paragraph
2. Assume each stakeholder perspective (5 min per role)
3. For each perspective, list top 3 concerns
4. Identify which concerns are unaddressed by existing work
5. The unaddressed concern with broadest impact is your research question

---

## F9. Composition and Decomposition

Novelty often emerges from recombination or modularization.

**Composition** (combining existing techniques):
- Identify two methods solving complementary subproblems
- Ask: What emergent capability arises from combining them?
- Example: RAG + Chain-of-Thought → retrieval-augmented reasoning

**Decomposition** (breaking apart monolithic systems):
- Identify a complex system with entangled components
- Ask: Which component is the actual bottleneck?
- Example: Decomposing "fine-tuning" reveals data selection often matters most

**Workflow**:
1. List 5-10 key components/techniques in your area
2. **Compose**: Pick pairs and ask what happens when combined
3. **Decompose**: Pick a complex method, isolate each component's contribution
4. For compositions: Does the combination create emergent capabilities?
5. For decompositions: Does isolation reveal a dominant or redundant component?

---

## F10. The "Explain It to Someone" Test

A strong research idea should be defensible in two sentences to a smart non-expert.

**The Two-Sentence Template**:
> **Sentence 1** (Problem): "[Domain] currently struggles with [specific problem], which matters because [concrete consequence]."
> **Sentence 2** (Insight): "We [approach] by [key mechanism], which works because [reason]."

**If You Cannot Fill This Template**:
- Problem not well-defined → return to F1
- Insight not clear → return to F7 (simplify)
- Significance not established → return to F3 (find the tension)

**Calibration Questions**:
- Would a smart colleague outside your subfield understand why this matters?
- Does the explanation stand without jargon?
- Can you predict what a skeptic's first objection would be?
