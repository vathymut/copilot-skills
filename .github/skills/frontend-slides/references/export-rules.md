# Export Rules

## Deploy to Vercel

**If the user has never deployed before, guide them step by step:**

1. Check if Vercel CLI is installed — `npx vercel --version`. If not found, install Node.js first (`brew install node` on macOS).
2. Check if user is logged in — `npx vercel whoami`. If not logged in, walk them through signing up at https://vercel.com/signup, then `vercel login`.
3. Deploy: `bash scripts/deploy.sh <path-to-presentation>` (accepts folder or single HTML file)
4. Share the URL, explain it works on any device, and how to delete from https://vercel.com/dashboard

**Gotchas:**
- Local images/videos must travel with the HTML. The deploy script auto-detects `src="..."` references but may miss CSS `background-image` or unusual paths. Verify after deploying.
- Prefer folder deployments when many assets exist — more reliable than standalone HTML.
- Filenames with spaces work but may cause URL encoding issues. Hyphens preferred.
- Redeploying updates the same URL — no need to share a new link.

## Export to PDF

1. Run: `bash scripts/export-pdf.sh <path-to-html> [output.pdf]`
2. A headless browser captures each slide as a 1920×1080 PNG, combines into PDF
3. Needs Playwright — installs automatically if missing. If Chromium fails: `npx playwright install chromium`

**Gotchas:**
- First run is slow (~150MB Chromium download). Subsequent exports are fast.
- Slides must use `class="slide"`.
- Local images must be relative paths (not absolute filesystem paths).
- Large decks produce large PDFs (~20MB for 18 slides). Over 10MB? Offer `--compact` flag (renders at 1280×720, cuts size 50-70%).
