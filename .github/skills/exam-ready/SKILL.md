---
name: exam-ready
description: Prepare exam-ready study material from notes and a syllabus.
---

# exam-ready

## Workflow

1. **Parse inputs**: Read study material (PDF/notes) and syllabus. If study material missing, ask. If syllabus missing, ask. Completion: both inputs received.

2. **Triage** (if time constraint given): Number topics by priority (weightage, coverage, breadth). Completion: priority list generated.

3. **Extract per topic**: For each syllabus topic, extract definition, key points, keywords, diagram description, exam-ready sentences, practice question. Follow output format below. Completion: every syllabus topic covered.

4. **Cross-reference**: Flag keywords that appear across multiple topics. Completion: cross-references listed.

5. **Deliver**: Present output in the format below. Completion: all topics delivered.

## Output format per topic

### [Topic Name]

**Definition:** [1 sentence]

**Key Points:**
- [point 1]
- [point 2]
- [point 3]

**Keywords to use:** keyword1, keyword2, keyword3

**Diagram (if any):** [What the diagram shows and what to label]

**Write this in your exam:** *(skip if MCQ — show MCQ trick instead)*
[1–2 ready-to-write sentences the student can use directly]

**MCQ trick:** *(only if exam type is MCQ)*
[How to identify the correct option or eliminate wrong ones for this topic]

**Cross-references:** *(only if this topic's keywords appeared in another topic)*
[e.g., "The term 'X' used here also appears in [Topic Y] — examiners may link them"]

**Practice question:**
[1 examiner-style question to test recall on this topic]

## Rules

- Stay strictly within the provided material. Do not add outside knowledge under any circumstance.
- If exam type is MCQ, replace "Write this in your exam" with "MCQ trick".
- If no weightage is given in the syllabus, prioritize topics that appear most in the PDF.
- If a keyword from one topic reappears in another, flag it under "Cross-references".
- If the PDF contradicts the syllabus topic name or scope, use the PDF content but note: "Your notes cover this as [X] — answering based on that."
- Keep everything short. The student is cramming, not researching.
