# IACM Conference Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `conferences.html` hub page and a `conference-iacm-2026.html` detail page (QR-linked from Yupeng's poster) showing identity/contact and the sponsorship paper, plus nav and cross-link updates across the existing site.

**Architecture:** Static HTML/CSS site (GitHub Pages, no build step, no JS framework). New pages reuse existing CSS classes from `style.css` (`.section`, `.conf-row`, `.placeholder`, `.btn-download`, `.paper-desc`, `.badge`, `.page-title`, `.back-link`) plus two new classes (`.conf-detail-hero`, `.qr-badge`) added to `style.css`. A QR PNG is generated once via a Python script and committed as a static asset.

**Tech Stack:** HTML, CSS, Python 3 (`py -3`) with the `qrcode` package for one-off QR PNG generation.

There is no test runner in this repo (static site). "Tests" in this plan are grep/findstr checks that confirm exact strings exist in the right files, plus a final manual browser check.

---

### Task 1: Add new CSS for the conference detail hero and QR badge

**Files:**
- Modify: `style.css:339` (insert new block right before the `/* ===== CONTACT SPECIFIC ===== */` section, i.e. after the `.ref-list li:last-child { border-bottom: none; }` rule)
- Modify: `style.css:376-382` (the `@media (max-width: 520px)` block)

- [ ] **Step 1: Insert the new CSS block**

In `style.css`, find this existing block:

```css
.ref-list li:last-child { border-bottom: none; }

/* ===== CONTACT SPECIFIC ===== */
```

Replace it with:

```css
.ref-list li:last-child { border-bottom: none; }

/* ===== CONFERENCE DETAIL HERO ===== */
.conf-detail-hero {
  display: flex;
  gap: 1rem;
  align-items: flex-start;
  padding: 1.75rem 0;
  border-bottom: 1px solid var(--border);
}
.conf-detail-hero img.conf-avatar {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  object-fit: cover;
  flex-shrink: 0;
}
.conf-detail-name {
  font-family: var(--font-heading);
  font-weight: 800;
  font-size: 1.3rem;
  color: var(--heading);
  letter-spacing: -0.04em;
  margin-bottom: 0.2rem;
}
.conf-detail-role, .conf-detail-contact {
  font-size: 0.78rem;
  color: var(--muted);
}
.conf-detail-presenting {
  font-size: 0.8rem;
  color: var(--accent);
  font-weight: 600;
  margin-top: 0.4rem;
}
.qr-badge {
  margin-left: auto;
  text-align: center;
  flex-shrink: 0;
}
.qr-badge img {
  width: 64px;
  height: 64px;
  border: 1px solid var(--border);
  border-radius: 4px;
}
.qr-badge span {
  display: block;
  font-size: 0.6rem;
  color: var(--muted);
  margin-top: 0.3rem;
}

/* ===== CONTACT SPECIFIC ===== */
```

- [ ] **Step 2: Update the responsive block to stack the hero on small screens**

Find:

```css
@media (max-width: 520px) {
  nav { flex-direction: column; gap: 0.75rem; align-items: flex-start; }
  .hero { flex-direction: column; }
  .conf-row { flex-direction: column; gap: 0.1rem; }
  .conf-meta { white-space: normal; }
  .footer-inner { flex-direction: column; gap: 0.5rem; align-items: flex-start; }
}
```

Replace with:

```css
@media (max-width: 520px) {
  nav { flex-direction: column; gap: 0.75rem; align-items: flex-start; }
  .hero { flex-direction: column; }
  .conf-row { flex-direction: column; gap: 0.1rem; }
  .conf-meta { white-space: normal; }
  .footer-inner { flex-direction: column; gap: 0.5rem; align-items: flex-start; }
  .conf-detail-hero { flex-direction: column; }
  .qr-badge { margin-left: 0; }
}
```

- [ ] **Step 3: Verify the new classes exist**

Run: `grep -c "conf-detail-hero\|qr-badge" "style.css"`
Expected: a number greater than 0 (multiple matches across the two new rule blocks)

- [ ] **Step 4: Commit**

```bash
git add style.css
git commit -m "style: add conference detail hero and QR badge CSS"
```

---

### Task 2: Add "Conferences" nav link to all existing pages

**Files:**
- Modify: `index.html:21-28`
- Modify: `research.html:20-27`
- Modify: `cv.html:20-27`
- Modify: `contact.html:20-27`
- Modify: `research-self-other-miscalibration-sponsorship.html:20-27`

- [ ] **Step 1: Update `index.html` nav**

Find:

```html
    <div class="links">
      <a href="index.html" class="active">Home</a>
      <a href="research.html">Research</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
```

Replace with:

```html
    <div class="links">
      <a href="index.html" class="active">Home</a>
      <a href="research.html">Research</a>
      <a href="conferences.html">Conferences</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
```

- [ ] **Step 2: Update `research.html` nav**

Find:

```html
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html" class="active">Research</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
```

Replace with:

```html
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html" class="active">Research</a>
      <a href="conferences.html">Conferences</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
```

- [ ] **Step 3: Update `cv.html` nav**

Find:

```html
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html">Research</a>
      <a href="cv.html" class="active">CV</a>
      <a href="contact.html">Contact</a>
    </div>
```

Replace with:

```html
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html">Research</a>
      <a href="conferences.html">Conferences</a>
      <a href="cv.html" class="active">CV</a>
      <a href="contact.html">Contact</a>
    </div>
```

- [ ] **Step 4: Update `contact.html` nav**

Find:

```html
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html">Research</a>
      <a href="cv.html">CV</a>
      <a href="contact.html" class="active">Contact</a>
    </div>
```

Replace with:

```html
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html">Research</a>
      <a href="conferences.html">Conferences</a>
      <a href="cv.html">CV</a>
      <a href="contact.html" class="active">Contact</a>
    </div>
```

- [ ] **Step 5: Update `research-self-other-miscalibration-sponsorship.html` nav**

Find:

```html
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html" class="active">Research</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
```

Replace with:

```html
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html" class="active">Research</a>
      <a href="conferences.html">Conferences</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
```

- [ ] **Step 6: Verify every page now has the Conferences nav link**

Run: `grep -L 'href="conferences.html"' index.html research.html cv.html contact.html research-self-other-miscalibration-sponsorship.html`
Expected: no output (empty result means every file matched and none were listed as missing)

- [ ] **Step 7: Commit**

```bash
git add index.html research.html cv.html contact.html research-self-other-miscalibration-sponsorship.html
git commit -m "feat: add Conferences link to site nav"
```

---

### Task 3: Create the `conferences.html` hub page

**Files:**
- Create: `conferences.html`

- [ ] **Step 1: Write the file**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Conferences — Yupeng He</title>
  <meta name="description" content="Conference presentations by Yupeng He, including poster sessions and talks.">
  <meta property="og:title" content="Conferences — Yupeng He">
  <meta property="og:description" content="Conference presentations by Yupeng He, including poster sessions and talks.">
  <meta property="og:url" content="https://heyupeng.com/conferences.html">
  <meta property="og:type" content="website">
  <link rel="canonical" href="https://heyupeng.com/conferences.html">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Archivo:wght@700;800&family=Public+Sans:wght@400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <nav>
    <a href="index.html" class="logo" aria-label="Home — Yupeng He">Yupeng He</a>
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html">Research</a>
      <a href="conferences.html" class="active">Conferences</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
  </nav>

  <main>
    <div class="page-title">Conferences</div>

    <div class="section">
      <div class="section-label">Conference Presentations</div>

      <div class="conf-row">
        <span class="conf-name"><a href="conference-iacm-2026.html">IACM Annual Conference</a></span>
        <span class="conf-meta">Vienna, Austria &middot; Jul 2026</span>
      </div>
      <div class="conf-row">
        <span class="conf-name">AOM Annual Meeting</span>
        <span class="conf-meta">Copenhagen, Denmark &middot; Jul 2025</span>
      </div>
    </div>

  </main>

  <footer>
    <div class="footer-inner">
      <span class="footer-copy">&copy; 2026 Yupeng He</span>
      <a href="mailto:yupeng.he@student.ie.edu" class="footer-email">yupeng.he@student.ie.edu</a>
    </div>
  </footer>

</body>
</html>
```

- [ ] **Step 2: Verify the IACM row is a link and AOM row is plain text**

Run: `grep -n "conf-name" conferences.html`
Expected output (two lines):
```
conferences.html:    <span class="conf-name"><a href="conference-iacm-2026.html">IACM Annual Conference</a></span>
conferences.html:    <span class="conf-name">AOM Annual Meeting</span>
```

- [ ] **Step 3: Commit**

```bash
git add conferences.html
git commit -m "feat: add conferences hub page"
```

---

### Task 4: Generate the IACM QR code PNG

**Files:**
- Create: `images/qr-iacm-2026.png` (binary asset, generated, not hand-written)
- Create (temporary, deleted after use): `generate_qr.py`

- [ ] **Step 1: Install the `qrcode` package**

Run: `py -3 -m pip install qrcode[pil]`
Expected: output ending in `Successfully installed qrcode-...` (or `Requirement already satisfied` if already present)

- [ ] **Step 2: Write the one-off generator script**

Create `generate_qr.py`:

```python
import qrcode

img = qrcode.make("https://heyupeng.com/conference-iacm-2026.html")
img.save("images/qr-iacm-2026.png")
print("saved images/qr-iacm-2026.png")
```

- [ ] **Step 3: Run it**

Run: `py -3 generate_qr.py`
Expected: `saved images/qr-iacm-2026.png`

- [ ] **Step 4: Verify the file was created**

Run: `ls -la images/qr-iacm-2026.png`
Expected: file listing with a non-zero size (a few hundred bytes to a few KB)

- [ ] **Step 5: Delete the one-off script (not needed in the repo going forward)**

Run: `rm generate_qr.py`

- [ ] **Step 6: Commit the generated PNG**

```bash
git add images/qr-iacm-2026.png
git commit -m "feat: add QR code asset for IACM conference page"
```

---

### Task 5: Create the `conference-iacm-2026.html` detail page

**Files:**
- Create: `conference-iacm-2026.html`

This reuses the abstract text already published in `research-self-other-miscalibration-sponsorship.html:45` (the `.paper-desc` paragraph) so the same wording stays consistent in both places.

- [ ] **Step 1: Write the file**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>IACM Annual Conference 2026 — Yupeng He</title>
  <meta name="description" content="Yupeng He's poster presentation at the IACM Annual Conference 2026, Vienna: Self–Other Miscalibration in Sponsorship Perceptions.">
  <meta property="og:title" content="IACM Annual Conference 2026 — Yupeng He">
  <meta property="og:description" content="Yupeng He's poster presentation at the IACM Annual Conference 2026, Vienna: Self–Other Miscalibration in Sponsorship Perceptions.">
  <meta property="og:url" content="https://heyupeng.com/conference-iacm-2026.html">
  <meta property="og:type" content="website">
  <link rel="canonical" href="https://heyupeng.com/conference-iacm-2026.html">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Archivo:wght@700;800&family=Public+Sans:wght@400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <nav>
    <a href="index.html" class="logo" aria-label="Home — Yupeng He">Yupeng He</a>
    <div class="links">
      <a href="index.html">Home</a>
      <a href="research.html">Research</a>
      <a href="conferences.html" class="active">Conferences</a>
      <a href="cv.html">CV</a>
      <a href="contact.html">Contact</a>
    </div>
  </nav>

  <main>
    <a href="conferences.html" class="back-link">&larr; Back to Conferences</a>

    <div class="conf-detail-hero">
      <img src="images/profile.jpg" alt="Yupeng He" class="conf-avatar">
      <div>
        <div class="conf-detail-name">Yupeng He</div>
        <div class="conf-detail-role">Ph.D. Candidate &middot; IE Business School, IE University &middot; Madrid, Spain</div>
        <div class="conf-detail-contact"><a href="mailto:yupeng.he@student.ie.edu">yupeng.he@student.ie.edu</a></div>
        <div class="conf-detail-presenting">Presenting at IACM Annual Conference 2026 &middot; Vienna, Austria &middot; Jul 2026</div>
      </div>
      <div class="qr-badge">
        <img src="images/qr-iacm-2026.png" alt="QR code linking to this page">
        <span>Scan to share</span>
      </div>
    </div>

    <div class="section">
      <div class="placeholder" style="height:280px;display:flex;align-items:center;justify-content:center;">Poster image coming soon</div>
    </div>

    <div class="section">
      <div class="paper">
        <div class="paper-title">Self&ndash;Other Miscalibration in Sponsorship Perceptions <span class="badge">data collection</span></div>
        <div class="paper-meta">He &amp; Jain</div>
        <p class="paper-desc">Sponsorship, third-party advocacy that places a candidate into an opportunity, can be a socially ambiguous signal in the workplace. We propose a self-other miscalibration that is, sponsees (as compared to observers) would perceive themselves to have higher competence, earned success, legitimacy, and lower instrumentality in their relationships. In a scenario-based experimental study, participants evaluated a sponsored analyst from three assessment perspectives: self-assessment (participants as sponsees evaluated themselves), expected peer assessment (participants thought about how others would evaluate them as being sponsees), or peer assessment (participants evaluating their sponsored peers). Participants in both self-assessment and expected peer assessment perspectives tended to report higher perceptions of competence, earned success, and legitimacy, but lower perceptions of instrumentality in relationships as compared to those in the peer assessment perspective, supporting the proposed self&ndash;other miscalibration. Next, we plan to investigate the roles of observer rank (peer vs. superior) and visible homophily in influencing these perceptions.</p>
        <a href="files/paper-sponsorship.pdf" class="btn-download" style="margin-top:1rem;">Download Paper (PDF)</a>
      </div>
    </div>

  </main>

  <footer>
    <div class="footer-inner">
      <span class="footer-copy">&copy; 2026 Yupeng He</span>
      <a href="mailto:yupeng.he@student.ie.edu" class="footer-email">yupeng.he@student.ie.edu</a>
    </div>
  </footer>

</body>
</html>
```

- [ ] **Step 2: Verify the page references the QR image, the placeholder poster, and the PDF download link**

Run: `grep -n "qr-iacm-2026.png\|Poster image coming soon\|paper-sponsorship.pdf" conference-iacm-2026.html`
Expected: 3 matching lines (one per term)

- [ ] **Step 3: Commit**

```bash
git add conference-iacm-2026.html
git commit -m "feat: add IACM 2026 conference detail page"
```

---

### Task 6: Link the IACM row on `index.html` and `research.html` to the new detail page

**Files:**
- Modify: `index.html:97-100`
- Modify: `research.html:58-61`

- [ ] **Step 1: Update `index.html`**

Find:

```html
      <div class="conf-row">
        <span class="conf-name">IACM Annual Conference</span>
        <span class="conf-meta">Vienna &middot; Jul 2026</span>
      </div>
```

Replace with:

```html
      <div class="conf-row">
        <span class="conf-name"><a href="conference-iacm-2026.html">IACM Annual Conference</a></span>
        <span class="conf-meta">Vienna &middot; Jul 2026</span>
      </div>
```

- [ ] **Step 2: Update `research.html`**

Find:

```html
      <div class="conf-row">
        <span class="conf-name">IACM Annual Conference</span>
        <span class="conf-meta">Vienna, Austria &middot; Jul 2026</span>
      </div>
```

Replace with:

```html
      <div class="conf-row">
        <span class="conf-name"><a href="conference-iacm-2026.html">IACM Annual Conference</a></span>
        <span class="conf-meta">Vienna, Austria &middot; Jul 2026</span>
      </div>
```

- [ ] **Step 3: Verify both rows now link to the detail page, and the AOM/EURAM rows on `research.html` are unchanged (still plain text)**

Run: `grep -n "conf-name" index.html research.html`
Expected: the `IACM Annual Conference` line in each file now wraps an `<a href="conference-iacm-2026.html">` tag; the `EURAM Annual Conference` and `AOM Annual Meeting` lines in `research.html` remain plain `<span class="conf-name">...</span>` with no `<a>` tag.

- [ ] **Step 4: Commit**

```bash
git add index.html research.html
git commit -m "feat: link IACM conference rows to detail page"
```

---

### Task 7: Manual verification in browser

**Files:** none (verification only)

- [ ] **Step 1: Serve the site locally**

Run: `py -3 -m http.server 8000` (from the `Yupeng77.github.io` directory)

- [ ] **Step 2: Check the hub page**

Open `http://localhost:8000/conferences.html` in a browser. Confirm:
- Nav shows "Conferences" as active
- "IACM Annual Conference" is a clickable link
- "AOM Annual Meeting" is plain text (not a link)

- [ ] **Step 3: Check the detail page**

Click into the IACM row. Confirm:
- Identity block shows avatar, name, role, email (mailto link works), "Presenting at..." line
- Small QR code image renders correctly (not broken) and visually scans to the same URL pattern (spot-check by eye, or use a phone camera if available)
- Poster section shows the "Poster image coming soon" placeholder
- Abstract text matches the existing paper page
- "Download Paper (PDF)" button is present (will 404 until the PDF is uploaded — expected for now)

- [ ] **Step 4: Check cross-links**

Open `http://localhost:8000/index.html` and `http://localhost:8000/research.html`. Confirm the IACM row in each is now a clickable link to the same detail page, and nav "Conferences" link works from every page.

- [ ] **Step 5: Stop the local server**

Press `Ctrl+C` in the terminal running `http.server`.

---

## Follow-up (not part of this plan)

- Upload the real poster image and swap the `.placeholder` block in `conference-iacm-2026.html` for an `<img>` tag.
- Upload `files/paper-sponsorship.pdf` so the download button resolves.
- Build `conference-aom-2025.html` in a future round (AOM stays plain text in `conferences.html` and `research.html` until then).
