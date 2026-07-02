# PDF Code Snippets

## pypdf — Basic Operations

```python
from pypdf import PdfReader, PdfWriter

# Read
reader = PdfReader("document.pdf")
text = "".join(page.extract_text() for page in reader.pages)

# Merge
writer = PdfWriter()
for pdf_file in ["doc1.pdf", "doc2.pdf"]:
    for page in PdfReader(pdf_file).pages:
        writer.add_page(page)
writer.write(open("merged.pdf", "wb"))

# Split
reader = PdfReader("input.pdf")
for i, page in enumerate(reader.pages):
    w = PdfWriter()
    w.add_page(page)
    w.write(open(f"page_{i+1}.pdf", "wb"))

# Rotate
page = PdfReader("input.pdf").pages[0]
page.rotate(90)

# Metadata
meta = PdfReader("document.pdf").metadata

# Watermark
watermark = PdfReader("watermark.pdf").pages[0]
for page in PdfReader("document.pdf").pages:
    page.merge_page(watermark)

# Encrypt
writer = PdfWriter()
writer.add_page(page)
writer.encrypt("userpass", "ownerpass")
```

## pdfplumber — Text and Table Extraction

```python
import pdfplumber
import pandas as pd

with pdfplumber.open("document.pdf") as pdf:
    for page in pdf.pages:
        text = page.extract_text()
        tables = page.extract_tables()

# Tables to DataFrame
with pdfplumber.open("document.pdf") as pdf:
    all_tables = []
    for page in pdf.pages:
        for table in page.extract_tables():
            if table:
                df = pd.DataFrame(table[1:], columns=table[0])
                all_tables.append(df)
    combined = pd.concat(all_tables, ignore_index=True)
```

## reportlab — Create PDFs

```python
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak
from reportlab.lib.styles import getSampleStyleSheet

# Canvas
c = canvas.Canvas("hello.pdf", pagesize=letter)
c.drawString(100, 700, "Hello World!")
c.save()

# Platypus
doc = SimpleDocTemplate("report.pdf", pagesize=letter)
styles = getSampleStyleSheet()
story = [Paragraph("Title", styles['Title']), Spacer(1, 12),
         Paragraph("Body text", styles['Normal']), PageBreak()]
doc.build(story)

# Subscripts/superscripts — use tags, NOT Unicode
Paragraph("H<sub>2</sub>O", styles['Normal'])       # subscript
Paragraph("x<super>2</super>", styles['Normal'])    # superscript
```

## Command-Line Tools

```bash
# pdftotext
pdftotext -layout input.pdf output.txt
pdftotext -f 1 -l 5 input.pdf output.txt   # pages 1-5

# qpdf
qpdf --empty --pages file1.pdf file2.pdf -- merged.pdf
qpdf input.pdf --pages . 1-5 -- pages1-5.pdf
qpdf input.pdf output.pdf --rotate=+90:1
qpdf --password=mypassword --decrypt encrypted.pdf decrypted.pdf

# OCR
# pip install pytesseract pdf2image
```

## Task-to-Tool Reference

| Task | Best Tool |
|------|-----------|
| Merge | pypdf or qpdf |
| Split | pypdf or qpdf |
| Extract text | pdfplumber |
| Extract tables | pdfplumber |
| Create PDFs | reportlab |
| OCR scanned | pytesseract + pdf2image |
| Fill forms | pypdf or pdf-lib |
