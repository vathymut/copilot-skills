---
name: pdf
description: Use when the user needs to read, extract, merge, split, rotate, create, watermark, encrypt, or OCR a PDF file.
---

Process PDFs by identifying the operation, selecting the right tool, implementing, and verifying output.

## When NOT to use

- The task is pure image processing (no PDF involved) — use image-specific tools instead.
- The PDF is a scanned image where no text extraction is needed — the skill handles OCR internally, but if you only need image manipulation of extracted pages, route differently.

## 1. Identify the operation

Determine what the user wants to do:
- **Read/extract:** text, tables, metadata, images
- **Transform:** merge, split, rotate, watermark, encrypt/decrypt
- **Create:** new PDFs from scratch or from other formats
- **OCR:** scanned PDFs that need text recognition

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

Check that the library is installed; install if missing. For the **forms** workflow (detect fillable fields, extract field info, fill, annotate), load [`forms.md`](forms.md) — it routes the bundled `scripts/` helpers. Advanced / second-tier libraries (`pypdfium2`, etc.) are documented in [`reference.md`](reference.md).

### Common code snippets (use directly for routine work)

**Read text with pdfplumber:**
```python
import pdfplumber
with pdfplumber.open("input.pdf") as pdf:
    for page in pdf.pages:
        print(page.extract_text())
```

**Merge PDFs with pypdf:**
```python
from pypdf import PdfWriter
writer = PdfWriter()
for f in ["a.pdf", "b.pdf"]:
    writer.append(f)
writer.write("merged.pdf")
```

**Split PDF with pypdf:**
```python
from pypdf import PdfReader, PdfWriter
reader = PdfReader("input.pdf")
for i, page in enumerate(reader.pages):
    writer = PdfWriter()
    writer.add_page(page)
    writer.write(f"page_{i+1}.pdf")
```

More snippets in [`references/code-snippets.md`](references/code-snippets.md).

## 3. Implement the operation

Write a script that:
- Reads input PDF(s) with the selected library
- Performs the operation
- Writes output to the specified location
- Handles errors (missing files, corrupt PDFs, permission issues)

## 4. Verify output

- Confirm the output file exists and is non-empty
- Spot-check content (e.g., page count, extracted text sample, table row count)
- Report results to the user

## Completion checklist

- [ ] Operation type and input/output files identified
- [ ] Tool selected and available in the environment
- [ ] Script runs without errors
- [ ] Output file exists and is non-empty
- [ ] Content spot-checked (page count, text sample, table row count)
- [ ] User informed of results
