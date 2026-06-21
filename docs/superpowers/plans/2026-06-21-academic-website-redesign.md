# Academic Website Redesign — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Jekyll/academicpages site with a pure HTML/CSS/JS static site deployed on GitHub Pages at heyupeng.com.

**Architecture:** Four HTML files (`index.html`, `research.html`, `cv.html`, `contact.html`) sharing one `style.css`. No build step — GitHub Pages serves the files directly. A `.nojekyll` file tells GitHub Pages not to run Jekyll on the repo.

**Tech Stack:** HTML5, CSS3 (custom properties), no JavaScript, no external fonts, no dependencies. Deployed via git push to `Yupeng77/Yupeng77.github.io` (main branch), custom domain via existing `CNAME`.

---

## File Map

| File | Action | Purpose |
|------|--------|---------|
| `style.css` | **Create** | All styles — variables, nav, hero, sections, footer |
| `index.html` | **Create** | Homepage: hero, updates, papers, presentations |
| `research.html` | **Create** | Full paper entries + conference history |
| `cv.html` | **Create** | Formatted CV with download button |
| `contact.html` | **Create** | Email + links |
| `.nojekyll` | **Create** | Empty file — disables Jekyll processing on GitHub Pages |
| `.gitignore` | **Modify** | Remove Jekyll entries, add `.superpowers/` |
| All Jekyll files | **Delete** | See Task 1 for full list |

**Files to keep unchanged:** `CNAME`, `files/cv_yupeng_he.docx`, `images/profile.jpg`, `LICENSE`

---

## Task 1: Clean up Jekyll files

**Files:**
- Delete: everything Jekyll-specific (listed below)
- Modify: `.gitignore`
- Create: `.nojekyll`

Working directory for all git commands: `C:\Users\Yupeng\Academic Website\Yupeng77.github.io`

- [ ] **Step 1.1: Delete Jekyll directories**

```bash
cd "C:/Users/Yupeng/Academic Website/Yupeng77.github.io"
rm -rf _config.yml _config_docker.yml Gemfile Dockerfile docker-compose.yaml package.json README.md
rm -rf _data _drafts _includes _layouts _pages _portfolio _posts _publications _sass _talks _teaching
rm -rf assets scripts markdown_generator talkmap talkmap.ipynb talkmap.py talkmap_out.ipynb
```

- [ ] **Step 1.2: Create `.nojekyll`**

Create an empty file named `.nojekyll` in the repo root. This is critical — without it GitHub Pages will try to build the site with Jekyll and fail.

```bash
touch .nojekyll
```

On Windows PowerShell if bash is unavailable:
```powershell
New-Item -ItemType File .nojekyll
```

- [ ] **Step 1.3: Update `.gitignore`**

Replace the contents of `.gitignore` with:

```gitignore
# Brainstorming sessions
.superpowers/

# OS
.DS_Store
Thumbs.db
```

- [ ] **Step 1.4: Commit**

```bash
git add -A
git commit -m "chore: remove Jekyll files, add .nojekyll"
```

---

## Task 2: Create `style.css`

**Files:**
- Create: `style.css`

- [ ] **Step 2.1: Create `style.css`**

```css
/* ===== VARIABLES ===== */
:root {
  --white: #ffffff;
  --surface: #f8fafc;
  --border: #dde4ef;
  --tag-bg: #e8edf7;
  --accent: #2c5282;
  --body: #3a4a6b;
  --heading: #1a2744;
  --muted: #8898b8;
  --max-width: 680px;
}

/* ===== RESET ===== */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Helvetica Neue', Arial, sans-serif;
  background: var(--white);
  color: var(--body);
  line-height: 1.7;
  font-size: 0.9rem;
}
a { color: var(--accent); }

/* ===== NAV ===== */
nav {
  background: var(--white);
  border-bottom: 1px solid var(--border);
  padding: 0.85rem 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: sticky;
  top: 0;
  z-index: 100;
}
nav .logo {
  font-size: 1rem;
  font-weight: 800;
  color: var(--heading);
  letter-spacing: -0.04em;
  text-decoration: none;
}
nav .links { display: flex; gap: 1.75rem; }
nav .links a {
  font-size: 0.72rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.09em;
  color: var(--muted);
  text-decoration: none;
  transition: color 0.15s;
  padding-bottom: 2px;
}
nav .links a:hover { color: var(--accent); }
nav .links a.active {
  color: var(--accent);
  border-bottom: 1.5px solid var(--accent);
}

/* ===== LAYOUT ===== */
main {
  max-width: var(--max-width);
  margin: 0 auto;
  padding: 0 1.5rem;
}

/* ===== HERO ===== */
.hero {
  padding: 2.75rem 0 2rem;
  border-bottom: 1px solid var(--border);
  display: flex;
  gap: 1.5rem;
  align-items: flex-start;
}
.hero-avatar {
  width: 76px;
  height: 76px;
  border-radius: 50%;
  object-fit: cover;
  flex-shrink: 0;
}
.hero-name {
  font-size: 1.9rem;
  font-weight: 800;
  color: var(--heading);
  letter-spacing: -0.06em;
  line-height: 1;
  margin-bottom: 0.3rem;
}
.hero-role {
  font-size: 0.78rem;
  color: var(--muted);
  margin-bottom: 0.85rem;
}
.hero-bio {
  font-size: 0.875rem;
  color: var(--body);
  line-height: 1.7;
  margin-bottom: 0.85rem;
}
.hero-bio a { text-decoration: none; }
.hero-bio a:hover { text-decoration: underline; }

/* ===== TAGS ===== */
.tags { display: flex; gap: 0.4rem; flex-wrap: wrap; }
.tag {
  background: var(--tag-bg);
  color: var(--accent);
  padding: 0.2rem 0.65rem;
  border-radius: 4px;
  font-size: 0.72rem;
  font-weight: 500;
}

/* ===== SECTIONS ===== */
.section {
  padding: 2rem 0;
  border-bottom: 1px solid var(--border);
}
.section:last-child { border-bottom: none; }
.section-label {
  font-size: 0.65rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: var(--muted);
  margin-bottom: 1.25rem;
}

/* ===== UPDATES ===== */
.update-row {
  display: flex;
  gap: 1.25rem;
  margin-bottom: 0.6rem;
  align-items: baseline;
}
.update-date {
  font-size: 0.75rem;
  color: var(--muted);
  white-space: nowrap;
  min-width: 4.5rem;
}
.update-text { font-size: 0.85rem; color: var(--body); line-height: 1.55; }
.update-text strong { color: var(--heading); font-weight: 600; }

/* ===== PAPERS ===== */
.paper {
  padding-left: 0.85rem;
  border-left: 2px solid var(--border);
  margin-bottom: 1.5rem;
}
.paper:last-child { margin-bottom: 0; }
.paper-title {
  font-size: 0.9rem;
  font-weight: 600;
  color: var(--heading);
  margin-bottom: 0.2rem;
  line-height: 1.4;
}
.paper-meta { font-size: 0.78rem; color: var(--muted); }
.paper-desc {
  font-size: 0.85rem;
  color: var(--body);
  line-height: 1.65;
  margin-top: 0.5rem;
}
.badge {
  display: inline-block;
  background: var(--tag-bg);
  color: var(--accent);
  font-size: 0.65rem;
  font-weight: 600;
  padding: 0.1rem 0.45rem;
  border-radius: 3px;
  margin-left: 0.4rem;
  vertical-align: middle;
  letter-spacing: 0.02em;
}

/* ===== CONFERENCE ROWS ===== */
.conf-row {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 0.55rem;
  gap: 1rem;
}
.conf-name { font-size: 0.85rem; color: var(--heading); font-weight: 500; }
.conf-meta { font-size: 0.75rem; color: var(--muted); white-space: nowrap; }

/* ===== PAGE TITLE (inner pages) ===== */
.page-title {
  font-size: 1.6rem;
  font-weight: 800;
  color: var(--heading);
  letter-spacing: -0.05em;
  padding: 2.5rem 0 1.5rem;
  border-bottom: 1px solid var(--border);
  margin-bottom: 0;
}

/* ===== CV SPECIFIC ===== */
.cv-section { padding: 1.75rem 0; border-bottom: 1px solid var(--border); }
.cv-section:last-child { border-bottom: none; }
.cv-entry { margin-bottom: 1rem; }
.cv-entry:last-child { margin-bottom: 0; }
.cv-entry-title { font-size: 0.88rem; font-weight: 600; color: var(--heading); }
.cv-entry-sub { font-size: 0.82rem; color: var(--body); }
.cv-entry-meta { font-size: 0.75rem; color: var(--muted); }
.cv-list { list-style: none; }
.cv-list li {
  font-size: 0.85rem;
  color: var(--body);
  padding: 0.3rem 0;
  border-bottom: 1px solid var(--border);
  display: flex;
  justify-content: space-between;
  gap: 1rem;
}
.cv-list li:last-child { border-bottom: none; }
.cv-list li span { color: var(--muted); font-size: 0.78rem; white-space: nowrap; }

.btn-download {
  display: inline-block;
  background: var(--accent);
  color: #fff;
  text-decoration: none;
  padding: 0.55rem 1.1rem;
  border-radius: 5px;
  font-size: 0.8rem;
  font-weight: 600;
  margin-bottom: 2rem;
  transition: background 0.15s;
}
.btn-download:hover { background: #1a3a6b; }

/* ===== CONTACT SPECIFIC ===== */
.contact-item {
  display: flex;
  gap: 1rem;
  align-items: baseline;
  margin-bottom: 0.75rem;
}
.contact-label {
  font-size: 0.65rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--muted);
  min-width: 5rem;
}
.contact-value { font-size: 0.875rem; color: var(--body); }
.contact-value a { color: var(--accent); text-decoration: none; }
.contact-value a:hover { text-decoration: underline; }

/* ===== FOOTER ===== */
footer {
  border-top: 1px solid var(--border);
  padding: 1.25rem 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 0;
}
.footer-copy { font-size: 0.75rem; color: var(--muted); }
.footer-email { font-size: 0.75rem; color: var(--accent); text-decoration: none; }
.footer-email:hover { text-decoration: underline; }

/* ===== RESPONSIVE ===== */
@media (max-width: 520px) {
  nav { flex-direction: column; gap: 0.75rem; align-items: flex-start; }
  .hero { flex-direction: column; }
  .conf-row { flex-direction: column; gap: 0.1rem; }
  .conf-meta { color: var(--muted); }
}
```

- [ ] **Step 2.2: Verify the file exists**

```bash
ls style.css
```

Expected: `style.css` listed.

- [ ] **Step 2.3: Commit**

```bash
git add style.css
git commit -m "feat: add shared stylesheet"
```

---

## Task 3: Create `index.html` (Homepage)

**Files:**
- Create: `index.html`

- [ ] **Step 3.1: Create `index.html`**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Yupeng He</title>
  <meta name="description" content="Ph.D. Candidate in Management at IE Business School, IE University, Madrid. Research on work conflict, negotiation, and prosocial behavior.">
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <nav>
    <a href="index.html" class="logo">Yupeng He</a>
    <div class="links">
      <a href="index.html" class="active">Home</a>
      <a href="research.html">Research</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
  </nav>

  <main>

    <!-- Hero -->
    <div class="hero">
      <img src="images/profile.jpg" alt="Yupeng He" class="hero-avatar">
      <div>
        <div class="hero-name">Yupeng He</div>
        <div class="hero-role">Ph.D. Candidate &middot; IE Business School, IE University &middot; Madrid, Spain</div>
        <p class="hero-bio">
          I study how people navigate <strong>work conflict</strong>, <strong>negotiation</strong>, and <strong>prosocial behavior</strong> in organizations.
          Supervised by <a href="https://www.ie.edu/university/about/faculty/kriti/" target="_blank" rel="noopener noreferrer">Prof. Kriti Jain</a>.
        </p>
        <div class="tags">
          <span class="tag">Work Conflict</span>
          <span class="tag">Negotiation</span>
          <span class="tag">Prosocial Behavior</span>
        </div>
      </div>
    </div>

    <!-- Recent Updates -->
    <div class="section">
      <div class="section-label">Recent Updates</div>

      <div class="update-row">
        <span class="update-date">Jul 2026</span>
        <span class="update-text">Presenting at <strong>IACM Annual Conference</strong>, Vienna, Austria</span>
      </div>
      <div class="update-row">
        <span class="update-date">Jun 2026</span>
        <span class="update-text">Presented at <strong>EURAM Annual Conference</strong>, Kristiansand, Norway</span>
      </div>
      <div class="update-row">
        <span class="update-date">May 2026</span>
        <span class="update-text">Attended <strong>Madrid Work &amp; Organizations Workshop</strong>, Madrid, Spain</span>
      </div>
      <div class="update-row">
        <span class="update-date">Jul 2025</span>
        <span class="update-text">Presented at <strong>AOM Annual Meeting</strong>, Copenhagen, Denmark</span>
      </div>
    </div>

    <!-- Working Papers -->
    <div class="section">
      <div class="section-label">Working Papers</div>

      <div class="paper">
        <div class="paper-title">Work Conflict and Holistic Thinking <span class="badge">target: JOB</span></div>
        <div class="paper-meta">Santos &amp; He</div>
      </div>
      <div class="paper">
        <div class="paper-title">Sponsorship Miscalibration <span class="badge">data collection</span></div>
        <div class="paper-meta">He &amp; Jain</div>
      </div>
      <div class="paper">
        <div class="paper-title">Work Conflict and Perfectionism <span class="badge">theory dev</span></div>
        <div class="paper-meta">Santos, He &amp; Requero</div>
      </div>
    </div>

    <!-- Upcoming Presentations -->
    <div class="section">
      <div class="section-label">Upcoming Presentations</div>

      <div class="conf-row">
        <span class="conf-name">IACM Annual Conference</span>
        <span class="conf-meta">Vienna &middot; Jul 2026</span>
      </div>
      <div class="conf-row">
        <span class="conf-name">EURAM Annual Conference</span>
        <span class="conf-meta">Kristiansand &middot; Jun 2026</span>
      </div>
    </div>

  </main>

  <footer>
    <span class="footer-copy">&copy; 2026 Yupeng He</span>
    <a href="mailto:yupeng.he@student.ie.edu" class="footer-email">yupeng.he@student.ie.edu</a>
  </footer>

</body>
</html>
```

- [ ] **Step 3.2: Open in browser and verify**

Open `index.html` in a web browser (double-click the file or drag it into Chrome/Edge).

Check:
- Nav shows: Home (blue underline) · Research · CV · Contact
- Hero shows photo, name, role, bio, and three tags
- Four sections render with correct labels and content
- Footer shows copyright and email
- No broken images (profile photo should show)

- [ ] **Step 3.3: Commit**

```bash
git add index.html
git commit -m "feat: add homepage"
```

---

## Task 4: Create `research.html`

**Files:**
- Create: `research.html`

> **Note:** Paper descriptions below are brief placeholders — update them with actual abstracts when available.

- [ ] **Step 4.1: Create `research.html`**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Research — Yupeng He</title>
  <meta name="description" content="Working papers and conference presentations by Yupeng He.">
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <nav>
    <a href="index.html" class="logo">Yupeng He</a>
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html" class="active">Research</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
  </nav>

  <main>
    <div class="page-title">Research</div>

    <!-- Working Papers -->
    <div class="section">
      <div class="section-label">Working Papers</div>

      <div class="paper">
        <div class="paper-title">Work Conflict and Holistic Thinking <span class="badge">target: JOB</span></div>
        <div class="paper-meta">Santos &amp; He</div>
        <p class="paper-desc">
          <!-- Add abstract here when available -->
        </p>
      </div>

      <div class="paper">
        <div class="paper-title">Sponsorship Miscalibration <span class="badge">data collection</span></div>
        <div class="paper-meta">He &amp; Jain</div>
        <p class="paper-desc">
          <!-- Add abstract here when available -->
        </p>
      </div>

      <div class="paper">
        <div class="paper-title">Work Conflict and Perfectionism <span class="badge">theory dev</span></div>
        <div class="paper-meta">Santos, He &amp; Requero</div>
        <p class="paper-desc">
          <!-- Add abstract here when available -->
        </p>
      </div>
    </div>

    <!-- Conference Presentations -->
    <div class="section">
      <div class="section-label">Conference Presentations</div>

      <div class="conf-row">
        <span class="conf-name">IACM Annual Conference</span>
        <span class="conf-meta">Vienna, Austria &middot; Jul 2026</span>
      </div>
      <div class="conf-row">
        <span class="conf-name">EURAM Annual Conference</span>
        <span class="conf-meta">Kristiansand, Norway &middot; Jun 2026</span>
      </div>
      <div class="conf-row">
        <span class="conf-name">AOM Annual Meeting</span>
        <span class="conf-meta">Copenhagen, Denmark &middot; Jul 2025</span>
      </div>
    </div>

  </main>

  <footer>
    <span class="footer-copy">&copy; 2026 Yupeng He</span>
    <a href="mailto:yupeng.he@student.ie.edu" class="footer-email">yupeng.he@student.ie.edu</a>
  </footer>

</body>
</html>
```

- [ ] **Step 4.2: Open in browser and verify**

Open `research.html`. Check:
- "Research" link in nav is blue/active
- All three papers appear with badges
- Conference rows display correctly

- [ ] **Step 4.3: Commit**

```bash
git add research.html
git commit -m "feat: add research page"
```

---

## Task 5: Create `cv.html`

**Files:**
- Create: `cv.html`

- [ ] **Step 5.1: Create `cv.html`**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CV — Yupeng He</title>
  <meta name="description" content="Curriculum vitae of Yupeng He, Ph.D. Candidate at IE Business School.">
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <nav>
    <a href="index.html" class="logo">Yupeng He</a>
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html">Research</a>
      <a href="cv.html" class="active">CV</a>
      <a href="contact.html">Contact</a>
    </div>
  </nav>

  <main>
    <div class="page-title">Curriculum Vitae</div>

    <div class="cv-section" style="padding-top: 1.75rem;">
      <a href="files/cv_yupeng_he.docx" class="btn-download" download>Download CV (.docx)</a>
    </div>

    <!-- Education -->
    <div class="cv-section">
      <div class="section-label">Education</div>
      <div class="cv-entry">
        <div class="cv-entry-title">Ph.D. in Management</div>
        <div class="cv-entry-sub">IE Business School, IE University &middot; Madrid, Spain</div>
        <div class="cv-entry-meta">Sep 2023 &ndash; present &middot; Supervisor: Prof. Kriti Jain</div>
      </div>
      <div class="cv-entry">
        <div class="cv-entry-title">M.Sc. in Management and International Business</div>
        <div class="cv-entry-sub">Aalto University &middot; Espoo, Finland</div>
        <div class="cv-entry-meta">Sep 2021 &ndash; Jul 2023</div>
      </div>
      <div class="cv-entry">
        <div class="cv-entry-title">B.Mgmt. in International Business</div>
        <div class="cv-entry-sub">Guangdong University of Foreign Studies &middot; Guangzhou, China</div>
        <div class="cv-entry-meta">Aug 2016 &ndash; Jun 2020</div>
      </div>
    </div>

    <!-- Research Interests -->
    <div class="cv-section">
      <div class="section-label">Research Interests</div>
      <div class="tags">
        <span class="tag">Work Conflict</span>
        <span class="tag">Negotiation</span>
        <span class="tag">Prosocial Behavior</span>
      </div>
    </div>

    <!-- Working Papers -->
    <div class="cv-section">
      <div class="section-label">Working Papers</div>
      <ul class="cv-list">
        <li>
          Santos &amp; He &mdash; Work Conflict and Holistic Thinking
          <span>target: JOB</span>
        </li>
        <li>
          He &amp; Jain &mdash; Sponsorship Miscalibration
          <span>data collection</span>
        </li>
        <li>
          Santos, He &amp; Requero &mdash; Work Conflict and Perfectionism
          <span>theory dev</span>
        </li>
      </ul>
    </div>

    <!-- Conferences -->
    <div class="cv-section">
      <div class="section-label">Conferences &amp; Workshops</div>
      <div class="conf-row"><span class="conf-name">IACM Annual Conference</span><span class="conf-meta">Vienna, Austria &middot; Jul 2026</span></div>
      <div class="conf-row"><span class="conf-name">EURAM Annual Conference</span><span class="conf-meta">Kristiansand, Norway &middot; Jun 2026</span></div>
      <div class="conf-row"><span class="conf-name">Madrid Work &amp; Organizations Workshop</span><span class="conf-meta">Madrid, Spain &middot; May 2026 &middot; Attendee</span></div>
      <div class="conf-row"><span class="conf-name">AOM Annual Meeting</span><span class="conf-meta">Copenhagen, Denmark &middot; Jul 2025</span></div>
      <div class="conf-row"><span class="conf-name">IE Doctoral Consortium</span><span class="conf-meta">Madrid, Spain &middot; Jun 2025 &middot; Attendee</span></div>
      <div class="conf-row"><span class="conf-name">Madrid Work &amp; Organizations Workshop</span><span class="conf-meta">Madrid, Spain &middot; May 2025 &middot; Attendee</span></div>
      <div class="conf-row"><span class="conf-name">Madrid Work &amp; Organizations Workshop</span><span class="conf-meta">Madrid, Spain &middot; May 2024 &middot; Attendee</span></div>
    </div>

    <!-- Research Experience -->
    <div class="cv-section">
      <div class="section-label">Research Experience</div>
      <div class="cv-entry">
        <div class="cv-entry-title">Research Assistant</div>
        <div class="cv-entry-sub">IE Business School, IE University &middot; Madrid</div>
        <div class="cv-entry-meta">Oct 2023 &ndash; present</div>
      </div>
    </div>

    <!-- Awards -->
    <div class="cv-section">
      <div class="section-label">Awards &amp; Scholarships</div>
      <ul class="cv-list">
        <li>IE University Scholarship <span>2023 &ndash; 2027</span></li>
        <li>Aalto University Scholarship <span>2021 &ndash; 2023</span></li>
      </ul>
    </div>

    <!-- Academic Service -->
    <div class="cv-section">
      <div class="section-label">Academic Service</div>
      <ul class="cv-list">
        <li>Reviewer &mdash; IACM, AOM, EURAM <span>2025 &ndash; 2026</span></li>
        <li>Student Volunteer &mdash; IE Doctoral Consortium <span>Madrid, 2025</span></li>
      </ul>
    </div>

    <!-- Skills -->
    <div class="cv-section">
      <div class="section-label">Skills &amp; Methods</div>
      <ul class="cv-list">
        <li>Quantitative Methods <span>Experimental design</span></li>
        <li>Software <span>SPSS, R</span></li>
      </ul>
    </div>

    <!-- Languages -->
    <div class="cv-section">
      <div class="section-label">Languages</div>
      <ul class="cv-list">
        <li>Chinese &mdash; Mandarin &amp; Cantonese <span>Native</span></li>
        <li>English <span>Fluent</span></li>
        <li>Spanish <span>Beginner</span></li>
      </ul>
    </div>

  </main>

  <footer>
    <span class="footer-copy">&copy; 2026 Yupeng He</span>
    <a href="mailto:yupeng.he@student.ie.edu" class="footer-email">yupeng.he@student.ie.edu</a>
  </footer>

</body>
</html>
```

- [ ] **Step 5.2: Open in browser and verify**

Open `cv.html`. Check:
- "CV" link in nav is active
- Download button is visible and links to `files/cv_yupeng_he.docx`
- All CV sections display with correct labels and content
- Lists are aligned and readable

- [ ] **Step 5.3: Commit**

```bash
git add cv.html
git commit -m "feat: add CV page"
```

---

## Task 6: Create `contact.html`

**Files:**
- Create: `contact.html`

- [ ] **Step 6.1: Create `contact.html`**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Contact — Yupeng He</title>
  <meta name="description" content="Contact information for Yupeng He.">
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <nav>
    <a href="index.html" class="logo">Yupeng He</a>
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html">Research</a>
      <a href="cv.html">CV</a>
      <a href="contact.html" class="active">Contact</a>
    </div>
  </nav>

  <main>
    <div class="page-title">Contact</div>

    <div class="section">
      <div class="contact-item">
        <span class="contact-label">Email</span>
        <span class="contact-value">
          <a href="mailto:yupeng.he@student.ie.edu">yupeng.he@student.ie.edu</a>
        </span>
      </div>
      <div class="contact-item">
        <span class="contact-label">Institution</span>
        <span class="contact-value">
          <a href="https://www.ie.edu/business-school/" target="_blank" rel="noopener noreferrer">IE Business School, IE University</a><br>
          Madrid, Spain
        </span>
      </div>
      <div class="contact-item">
        <span class="contact-label">Google Scholar</span>
        <span class="contact-value">
          <a href="https://scholar.google.com/citations?user=K0j9fYIAAAAJ&hl=en" target="_blank" rel="noopener noreferrer">View profile</a>
        </span>
      </div>
      <div class="contact-item">
        <span class="contact-label">GitHub</span>
        <span class="contact-value">
          <a href="https://github.com/Yupeng77" target="_blank" rel="noopener noreferrer">Yupeng77</a>
        </span>
      </div>
    </div>
  </main>

  <footer>
    <span class="footer-copy">&copy; 2026 Yupeng He</span>
    <a href="mailto:yupeng.he@student.ie.edu" class="footer-email">yupeng.he@student.ie.edu</a>
  </footer>

</body>
</html>
```

- [ ] **Step 6.2: Open in browser and verify**

Open `contact.html`. Check:
- "Contact" link in nav is active
- Email, institution, Google Scholar, and GitHub all appear with working links
- Layout is clean and readable

- [ ] **Step 6.3: Commit**

```bash
git add contact.html
git commit -m "feat: add contact page"
```

---

## Task 7: Final check and push to GitHub Pages

- [ ] **Step 7.1: Cross-page navigation check**

Open `index.html` in a browser. Click every nav link and verify:
- Each page loads correctly
- The correct nav item is active (blue + underline) on each page
- Back button works as expected

- [ ] **Step 7.2: Mobile check**

Open browser DevTools (F12), switch to mobile view (iPhone SE or similar, ~375px wide). Check:
- Nav wraps cleanly on small screens
- Hero stacks vertically (photo above text)
- No horizontal scroll

- [ ] **Step 7.3: Verify repo state**

```bash
cd "C:/Users/Yupeng/Academic Website/Yupeng77.github.io"
git status
```

Expected: `nothing to commit, working tree clean`

Verify critical files are present:
```bash
ls index.html research.html cv.html contact.html style.css .nojekyll CNAME
```

Expected: all six files listed, no errors.

Verify Jekyll files are gone:
```bash
ls _config.yml 2>/dev/null && echo "STILL PRESENT — delete it" || echo "OK — not found"
```

Expected: `OK — not found`

- [ ] **Step 7.4: Push to GitHub Pages**

```bash
git push origin master
```

Wait ~1–2 minutes, then open https://heyupeng.com in a browser and verify the new site is live.

- [ ] **Step 7.5: Check heyupeng.com**

Confirm in the browser:
- Homepage loads with new design (not the old Jekyll site)
- Nav links work
- No 404 errors on any page
- Profile photo loads

---

## Post-launch: add paper abstracts

When you have abstracts ready, edit `research.html` and fill in the `<p class="paper-desc">` block inside each `.paper` div. Then commit and push.
