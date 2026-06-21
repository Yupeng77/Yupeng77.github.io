# Academic Website Redesign — Design Spec

**Date:** 2026-06-21  
**Site:** heyupeng.com  
**Repo:** Yupeng77/Yupeng77.github.io  

---

## Goal

Replace the existing Jekyll/academicpages site with a hand-crafted pure HTML/CSS/JS static site. Same GitHub Pages deployment, same custom domain (heyupeng.com), but no build step, no Ruby, no Jekyll. The new site should feel clean, professional, and complete — a polished online presence for a Ph.D. candidate.

---

## Visual Design

**Color palette:**
- Background: `#ffffff` (white)
- Surface/section bg: `#f8fafc` (very light blue-gray)
- Border / dividers: `#dde4ef`
- Tag background: `#e8edf7`
- Tag / accent text: `#2c5282` (slate blue)
- Body text: `#3a4a6b`
- Headings / name: `#1a2744` (dark navy)
- Muted / meta text: `#8898b8`

**Typography:**
- Font stack: `-apple-system, BlinkMacSystemFont, 'Helvetica Neue', sans-serif` (no external font dependencies)
- Name: 2rem–2.5rem, weight 800, letter-spacing tight
- Section labels: 0.65rem, weight 700, uppercase, letter-spacing wide, muted color
- Body: 0.9rem, line-height 1.7
- Paper titles: 0.9rem, weight 600

**Layout:**
- Top navigation bar: name on left, page links on right
- Single-column content, max-width 680px, centered
- No sidebar
- Generous vertical padding between sections
- Sections separated by subtle horizontal rules

**Nav links:** Home · Research · CV · Contact  
**Active state:** slate-blue color + bottom border underline

---

## Site Structure

### Files to create

| File | Purpose |
|------|---------|
| `index.html` | Homepage |
| `research.html` | Full research / working papers page |
| `cv.html` | Formatted CV with download link |
| `contact.html` | Contact information |
| `style.css` | Shared stylesheet for all pages |
| `.nojekyll` | Empty file — tells GitHub Pages not to run Jekyll |

### Files to keep from existing repo

| File/Dir | Reason |
|----------|--------|
| `CNAME` | Custom domain (heyupeng.com) — must not be deleted |
| `files/` | CV download (`cv_yupeng_he.docx`) |
| `images/` | Profile photo (`profile.jpg`) |
| `LICENSE` | Keep |
| `.gitignore` | Update to remove Jekyll entries; add `.superpowers/` to ignore brainstorm session files |

### Files/dirs to delete

Everything else — all Jekyll-specific:

- `Dockerfile`, `docker-compose.yaml`
- `Gemfile`, `package.json`
- `_config.yml`, `_config_docker.yml`
- `_data/`, `_drafts/`, `_includes/`, `_layouts/`
- `_pages/`, `_portfolio/`, `_posts/`, `_publications/`
- `_sass/`, `_talks/`, `_teaching/`
- `assets/` (Jekyll asset pipeline)
- `scripts/` (Jekyll helper scripts)
- `markdown_generator/`
- `talkmap/`, `talkmap.ipynb`, `talkmap.py`, `talkmap_out.ipynb`
- `README.md` (academicpages template readme)

---

## Page Designs

### index.html — Homepage

Sections in order, single column:

1. **Nav** — shared across all pages
2. **Hero** — profile photo (circle, ~80px), name, role, one-sentence bio, research keyword tags
3. **Recent Updates** — timestamped list of news items (conferences, paper milestones). Each row: date on left, short sentence on right.
4. **Working Papers** — list of all papers with left border accent, title (bold), co-authors, status badge
5. **Upcoming Presentations** — table-style rows: conference name on left, location + date on right
6. **Footer** — copyright + email

### research.html — Research

Full working paper entries, one per paper:

- Paper title (large, bold)
- Co-authors
- Status badge (target journal / data collection / theory dev)
- Abstract or short description paragraph (when available)
- Links: [PDF] [Abstract ↓] if applicable

Also includes a "Conference Presentations" subsection listing all past conferences.

### cv.html — CV

Formatted version of the CV content, sections:

- Download button → `files/cv_yupeng_he.docx`
- Education
- Research Interests
- Working Papers (brief, links to research.html)
- Conferences & Workshops
- Research Experience
- Awards & Scholarships
- Academic Service
- Skills & Methods
- Languages

### contact.html — Contact

Simple page:

- Email: yupeng.he@student.ie.edu
- Institution: IE Business School, IE University, Madrid
- Links: Google Scholar, GitHub (Yupeng77), LinkedIn (if added later)

---

## Content

### Working papers (from existing site)

1. **Work Conflict and Holistic Thinking** — Santos & He · target: JOB
2. **Sponsorship Miscalibration** — He & Jain · data collection
3. **Work Conflict and Perfectionism** — Santos, He & Requero · theory dev

### Conferences

| Conference | Location | Date | Role |
|-----------|----------|------|------|
| IACM Annual Conference | Vienna, Austria | Jul 2026 | Presenter |
| EURAM Annual Conference | Kristiansand, Norway | Jun 2026 | Presenter |
| Madrid Work & Organizations Workshop | Madrid, Spain | May 2026 | Attendee |
| AOM Annual Meeting | Copenhagen, Denmark | Jul 2025 | Presenter |
| IE Doctoral Consortium | Madrid, Spain | Jun 2025 | Attendee |
| Madrid Work & Organizations Workshop | Madrid, Spain | May 2025 | Attendee |
| Madrid Work & Organizations Workshop | Madrid, Spain | May 2024 | Attendee |

---

## Deployment

1. Delete all Jekyll files (listed above) from the local clone at `C:\Users\Yupeng\Academic Website\Yupeng77.github.io`
2. Add the new HTML/CSS files
3. Add `.nojekyll` (empty file — critical for GitHub Pages to serve HTML directly without Jekyll processing)
4. `git add`, commit, push — GitHub Pages will serve `index.html` at heyupeng.com via the existing CNAME

No changes needed to GitHub Pages settings — it already serves from the root of the main branch.

---

## Out of scope

- Dark mode
- Blog / posts section
- JavaScript animations or interactivity
- External font loading
- Contact form (email link is sufficient)
