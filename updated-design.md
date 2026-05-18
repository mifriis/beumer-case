# BEUMER Group Presentation Design System

You are generating a branded presentation for BEUMER Group. This document is your complete instruction set. Follow it precisely. Do not invent layout patterns or colors not defined here.

**Approach**: Nancy Duarte Slideology. Contrast, storytelling, minimal text, maximum visual impact. Let the slide breathe. Detail lives in speaker notes, not on the slide.

---

## How to Generate

Produce a single self-contained HTML file. Slides are `div.slide` elements stacked vertically, each 1280x720px with `position: relative` so child elements are absolutely positioned within them. Use CSS variables for all colors. Include a `@media print` block that removes gaps and sets a page break after each slide so the file prints cleanly to PDF from a browser.

Logo is referenced as `logo.png` in the same directory. Place it top-left on every slide at 32-40px height.

Speaker notes go in HTML comments inside each slide div.

Where the content calls for an illustration, insert a dashed placeholder box with a short label describing what the illustration should show.

---

## Brand Palette

Use color strategically for meaning, not decoration.

| Purpose | Name | Hex |
|---------|------|-----|
| Trust / Authority | Dark Navy | #003D7A |
| Innovation / Energy | Primary Blue | #0088CC |
| Call-to-Action | Bright Orange | #FF6600 |
| Breathing Room | White | #FFFFFF |
| Contrast Layer | Dark Teal | #003D5C |
| Subtle Background | Light Gray | #F5F5F5 |

Define these as CSS variables at `:root` so the palette can be changed by editing six lines.

**60/30/10 rule**: 60% white space, 30% navy for structure and text, 10% orange for emphasis only. Orange on more than 2-3 slides is too much.

---

## Typography

Font: Barlow + Barlow Condensed from Google Fonts. Fall back to Helvetica Neue, Arial.

| Element | Style |
|---------|-------|
| Slide titles | Barlow Condensed, 700-800 weight, 44-72px, Navy or White |
| Body text | Barlow Regular, 15-18px, Navy, max 3 lines on slide |
| Large stat or quote | Barlow Condensed, 800 weight, 80-100px, Orange |
| Labels / eyebrows | Barlow, 700, 11-13px, uppercase, letter-spacing 0.15-0.2em |
| Speaker notes | HTML comment, not visible on slide |

Never put dense paragraphs on a slide. Never use bullet soup. One strong statement per slide is the goal.

---

## Logo

File: `logo.png`
Placement: Top-left corner, 32-40px height, z-index above all other elements.
On dark slides: apply `filter: brightness(0) invert(1)` to show white.
Use subtly. Do not let branding crowd the message.

---

## Slide Structure

**Opening slide**: Dark hero. Large display title. One or two key stats to establish stakes immediately. Orange CTA element.

**Closing slide**: Dark hero. The strongest single argument from the document as a large statement. Orange accent. No hedging.

**Middle slides**: Follow the document structure but reorder for narrative momentum if needed. Problem before context, context before solution, solution before implementation.

**One idea per slide.** If a section has multiple distinct points, split across slides.

---

## Layout Templates

Never repeat the same layout twice in a row. Rotate across these templates. Aim for at least 5 different layouts in any deck.

### 1. Title Hero (Dark)
- Background: Dark Teal (#003D5C)
- Large condensed title, white
- Supporting stat or subtitle, white at reduced opacity
- Orange accent element (bar, button, or label)
- Use for: opening, closing, pivots, major section breaks

### 2. Left Panel
- Left column (380-500px wide): solid color background (Navy, Orange, or Blue), white text
- Layer tag + large condensed title + short body in the panel
- Right column: white background, 3-5 bullet points or sub-sections with dot or bar accents
- Use for: layer breakdowns, feature details, process steps

### 3. Full-Width Content
- White background
- 6px vertical accent bar on left edge (Blue or Orange)
- Label (uppercase, small, colored), heading, body text
- Supporting columns or cards below
- Use for: overviews, summaries, multi-point arguments

### 4. Stat / Quote Hero (Dark)
- Background: Dark Teal
- One very large number or short statement, Orange
- 1-2 sentence explanation, white
- Illustration placeholder if relevant
- Use for: establishing scale, compounding effects, single powerful facts

### 5. Grid Cards
- White background
- 3 or 4 equal cards in a row
- Each card: top border accent (color-coded), badge label, title, short body
- Use for: comparing options, showing a hierarchy, listing components

### 6. Two-Column Split
- Left: dark colored panel with label + title + short context
- Right: white with detailed points
- Use for: problem/solution pairs, before/after, layer details

### 7. Data / Metrics Grid
- White background
- Accent bar left
- Heading and 1-2 line explanation above
- 2x3 or 3x2 grid of metric cards, each with a name, description, and color-coded top border (severity or priority)
- Use for: fitness functions, KPIs, measurement frameworks

---

## Spacing Rules

- Side margins: 80px minimum
- Top margin from logo to first content element: 60px minimum
- Between elements: 30px minimum
- Text width: 60-70% of slide width maximum on full-width layouts
- White space is not wasted space. Emptiness creates focus.

---

## Speaker Notes

All detail, context, data, and transition language goes in speaker notes as HTML comments inside the slide div. The slide shows the point. The notes tell the story.

---

## Checklist Before Finishing

- No two adjacent slides share the same layout
- Orange appears on 3 slides maximum
- Every slide readable in under 3 seconds
- All illustration placeholders are labeled with what should go there
- Logo present on every slide, white version on dark backgrounds
- Print CSS block included
- All colors reference CSS variables, not hardcoded hex values
