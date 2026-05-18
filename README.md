# Beumer Case Presentation

A software architecture strategy presentation for BEUMER Group, covering continuous security delivery, CRA compliance, and replacing the fork model with sidecar, API, and SDK integration patterns.

## How This Was Made

### 1. Writing the case
Starting from the case description, the content was written as long-form prose in `case-raw.md` — covering the compounding vulnerability problem, three security layers, the fork model's structural flaws, integration patterns, implementation strategy, upskilling, support model, architectural constraints, and the regulatory timeline.

### 2. Collaborating on the outline
The raw content was refined iteratively: change management was woven into the implementation strategy rather than called out as a separate section, the internal team formation narrative was added, and an upskilling section was split out. The result was reviewed against the original case description to identify gaps.

### 3. Defining the design system
A design guideline was written as a prompt (`updated-design.md`) specifying the BEUMER brand palette, typography, layout templates, spacing rules, and speaker note conventions — detailed enough to fully drive generation without ambiguity.

### 4. Generating the presentation and placeholders
Using the design guideline and content outline, `presentation.html` was generated as a self-contained 18-slide deck with keyboard and button navigation, speaker notes in HTML comments, and print-to-PDF support. Placeholder SVG images were created in `images/` — one per illustration slot, named by slide number (with A/B/C suffixes where a slide has multiple), each carrying the target pixel dimensions and a description for a designer.

### 5. Creating the draw.io brand template
Using the same design guideline, `illustrations.drawio` was generated with the full brand palette on a dedicated page and one canvas per illustration — each showing the dashed target boundary, the colours relevant to that slide's context, and a brief for the designer.

---

## Files

| File | Purpose |
|---|---|
| `case-description.md` | Original case brief |
| `case-raw.md` | Full strategy content in prose |
| `presentation-outline.md` | Slide-by-slide plan |
| `updated-design.md` | Design system prompt / guideline |
| `presentation.html` | Final self-contained presentation |
| `images/` | SVG placeholder images, named by slide |
| `illustrations.drawio` | draw.io brand template for designing illustrations |

## Viewing the Presentation

Open `presentation.html` in a browser. Use the left/right arrow buttons or keyboard arrow keys to navigate. Print to PDF from the browser for a portable version.
