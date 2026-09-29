# Study Exams

Ethiopian national-exam style practice papers, published as a static site.

## Site

**Live:** see the Vercel production URL (deploy with `./deploy.sh` or let Vercel build on push).

## How it's built

`site.mjs` scans the exam folders (this repo root) and generates the static site into `site/`:

```
site/
  index.html            # catalog grouped by grade/subject
  search.html           # full-text search over all questions
  assets/               # style.css, exam.js, search.js
  data/search.json      # search index (titles + every question)
  11th/Math/G11-U1-Relations/
    index.html          # "take it online" page
    exam.pdf
    key.pdf
  Math/G9-U1-Sets/
    index.html
    exam.pdf
    key.pdf
```

## Adding an exam

1. Create a folder under `exams/` (this repo root) at `<GRADE>/<SUBJECT>/<G##-U#-Topic>/`.
2. Put `exam.pdf` in it. Optionally add `key.pdf`, and `exam.md` + `key.md` markdown mirrors.
   - `exam.md` drives the online "take it" page and the search index. Supported formats:
     - `1. question` or `**1.** question`
     - options inline `(a) … (b) …` or bulleted `- a) …`
     - `## Section` headings, and plain paragraphs for reading passages.
   - `key.md` needs a `| Q | Ans | Q | Ans | …` table; it powers the auto-grading.
3. Rebuild: `node site.mjs`
4. Deploy: `./deploy.sh` (Vercel) or let Vercel rebuild on push.

The typst templates `practice-paper.typ` (one-page auto-fit) and `practice-mc.typ` (multi-page) live at the repo root; compile exams with:

```bash
typst compile --root . 11th/Math/G11-U1-Relations/exam.typ exam.pdf
```

## Requirements

Node.js ≥ 18, no dependencies. Typst for regenerating PDFs.
