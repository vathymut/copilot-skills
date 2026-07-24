---
name: exam-ready
description: Use when the user has study notes and/or a syllabus and wants exam-ready material — definitions, key points, practice questions, or MCQ strategies.
---

# exam-ready

## When NOT to use

- The user wants a summary or explanation, not exam prep. This skill produces study-and-practice material (definitions, MCQs, practice questions). If they just want a précis of their notes, use a different approach.
- The material is purely procedural (e.g., a software tutorial) with no recall-based exam format.

## Prioritization heuristic

When time is constrained, order topics by:

1. **Weightage** — if the syllabus gives mark/credit distribution, follow it.
2. **Coverage** — topics that appear most in the provided study material (PDF page count, repetition across chapters).
3. **Breadth** — foundational topics whose keywords recur in other topics.

This order is the default. If the user states a different priority (e.g., "focus on chapters I'm weakest on"), follow that instead.

## Workflow

### 1. Parse inputs
Read study material (PDF/notes) and syllabus. If study material missing, ask. If syllabus missing, ask.

**Sub-steps per topic:**
- Identify the topic heading in the syllabus
- Locate corresponding section in study material
- Note any discrepancy between syllabus topic name and PDF content

### 2. Triage (if time constraint given)
Number topics by priority using the heuristic above.

### 3. Extract per topic
For each syllabus topic, extract:
- Definition (1 sentence)
- Key points (3–5 bullet points)
- Keywords
- Diagram description (what it shows and what to label)
- Exam-ready sentences or MCQ trick
- Practice question

### 4. Cross-reference
Flag keywords that appear across multiple topics.

### 5. Deliver
Present output in the format below.

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
