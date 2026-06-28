# IACM Conference Page — Design Spec

## Purpose

For the IACM Annual Conference 2026 poster session, provide a QR-code-linked
webpage that attendees can scan to see: (1) Yupeng He's identity and contact
info, and (2) the research being presented. This also establishes a reusable
"Conferences" section pattern on the site for future conferences.

## Scope (this round)

- New `conferences.html` hub page
- New `conference-iacm-2026.html` detail page
- QR code asset for the IACM page, shown on the page and usable on the
  physical poster
- Cross-links from `index.html` and `research.html` to the new pages
- Nav bar update

Out of scope for this round: an AOM 2025 detail page (AOM stays a plain-text
row in the hub, like EURAM, until built later).

## 1. `conferences.html` (hub)

Follows the same list pattern as `research.html`'s Working Papers / Conference
Presentations sections — a `.section` with `.conf-row` entries.

- Lists exactly two conferences: **IACM Annual Conference 2026** (clickable,
  links to `conference-iacm-2026.html`) and **AOM Annual Meeting 2025** (plain
  text, no detail page yet).
- Added to the main nav on every page: `Home · Research · Conferences · CV ·
  Contact`.

## 2. `conference-iacm-2026.html` (detail page)

Layout: **identity-first** (selected over poster-first and single-card
options). Reuses existing CSS classes (`page-title`, `section`, `placeholder`,
`btn-download`, `paper-desc`, `badge`) plus a couple of new ones.

```
nav (Conferences link shown with .active state, since this page lives under it)
← Back to Conferences

[new: .conf-detail-hero]
  [avatar img]  Yupeng He
                Ph.D. Candidate, IE Business School · IE University · Madrid
                yupeng.he@student.ie.edu
                presenting at IACM Annual Conference 2026 · Vienna, Austria · Jul 2026
                [new: .qr-badge] small QR image + caption "Scan to share"

[ Poster image — placeholder div until poster file is provided ]

Self–Other Miscalibration in Sponsorship Perceptions
He & Jain · [badge: data collection]

<reuse the existing .paper-desc abstract text from
 research-self-other-miscalibration-sponsorship.html>

[ Download Paper (PDF) ] — .btn-download, links to files/paper-sponsorship.pdf
                            (placeholder file path; PDF to be uploaded later)
```

Notes:
- No link to the existing paper HTML page from this page — only the PDF
  download button. (PDF itself is a placeholder link until Yupeng uploads it.)
- Poster image is a placeholder (`.placeholder` div) until the poster file is
  provided; swap for a real `<img>` at that time.
- Avatar reuses `images/profile.jpg` (same as homepage hero).

## 3. QR code

- Generate `images/qr-iacm-2026.png`, encoding
  `https://heyupeng.com/conference-iacm-2026.html`.
- Generated via a one-off script (Python `qrcode` library, or equivalent),
  not a runtime dependency — just a committed static asset.
- Displayed small on the detail page (`.qr-badge`, near the identity block)
  AND usable standalone — Yupeng can drop the same PNG into the physical
  poster design.

## 4. New CSS (added to `style.css`)

- `.conf-detail-hero` — identity block layout (avatar + name/role/contact/
  "presenting at" line + QR badge), similar structure to existing `.hero`
  but more compact.
- `.qr-badge` — small QR image (~64px) with a one-line caption underneath.

No other new classes needed; everything else reuses `.placeholder`,
`.btn-download`, `.paper-desc`, `.badge`, `.conf-row`, `.section`,
`.page-title`, `.back-link`.

## 5. File/asset layout

```
conferences.html
conference-iacm-2026.html
images/qr-iacm-2026.png
images/conf-iacm-2026/poster.jpg      (placeholder — added when Yupeng provides it)
files/paper-sponsorship.pdf           (placeholder — added when Yupeng provides it)
```

## 6. Cross-links

- `index.html` "Upcoming Presentations" row for IACM → title becomes a link
  to `conference-iacm-2026.html`.
- `research.html` "Conference Presentations" → IACM row title links to
  `conference-iacm-2026.html`; AOM row stays plain text (no page yet); EURAM
  row stays plain text.
- Nav bar: add `Conferences` link between `Research` and `CV` on all pages
  (`index.html`, `research.html`, `cv.html`, `contact.html`, the paper detail
  page, and the two new pages).

## Placeholders to fill in later (not blocking this build)

- Poster image (`images/conf-iacm-2026/poster.jpg`)
- Paper PDF (`files/paper-sponsorship.pdf`)
- AOM 2025 detail page (future round)
