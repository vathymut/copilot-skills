---
name: pdf
description: >
  Process PDF files — read, extract, merge, split, rotate, create, watermark, encrypt, or OCR.
  Use when: user mentions a .pdf file, asks to produce a PDF, or wants any PDF operation;
  trigger on "pdf", ".pdf", "extract from PDF", "merge PDFs", "OCR scanned".
---

Process PDFs by identifying the operation, selecting the right tool, implementing, and verifying output.

## 1. Identify the operation

Determine what the user wants to do:
- **Read/extract:** text, tables, metadata, images
- **Transform:** merge, split, rotate, watermark, encrypt/decrypt
- **Create:** new PDFs from scratch or from other formats
- **OCR:** scanned PDFs that need text recognition

**Completion criterion:** operation type and input/output files identified.

## 2. Select library or tool

Choose based on the operation:

| Operation | Primary tool | Alternative |
|-----------|-------------|-------------|
| Read/extract text | pdfplumber | pypdf |
| Extract tables | pdfplumber + pandas | — |
| Merge/split/rotate | pypdf | qpdf (CLI) |
| Create PDFs | reportlab | — |
| OCR | pytesseract + pdf2image | — |
| Forms | pypdf | pdf-lib (JS) |
| Encrypt/decrypt | pypdf | qpdf (CLI) |

Check that the library is installed; install if missing. Code snippets for each library are in [`references/code-snippets.md`](references/code-snippets.md).

**Completion criterion:** tool selected and available in the environment.

## 3. Implement the operation

Write a script that:
- Reads input PDF(s) with the selected library
- Performs the operation
- Writes output to the specified location
- Handles errors (missing files, corrupt PDFs, permission issues)

**Completion criterion:** script runs without errors.

## 4. Verify output

- Confirm the output file exists and is non-empty
- Spot-check content (e.g., page count, extracted text sample, table row count)
- Report results to the user

**Completion criterion:** output verified; user informed of results.
