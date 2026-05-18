# BEUMER Presentation Generation Prompt

You are building a branded presentation from two inputs:

1. A design system document describing brand colors, typography, layout principles, and slide templates
2. A content document structured with headings and prose

## Approach

Stay in HTML for layout quality. Write the finished HTML to disk using Python or Node.
Python: `open('beumer-presentation.html', 'w')`
Node: `fs.writeFile('beumer-presentation.html', html)`

If the deliverable must be an editable PowerPoint file, use python-pptx (Python) or PptxGenJS (Node) instead. Be aware that both require coordinate-based layout which is more brittle than CSS.

## Slide Construction

- One idea per slide. If a section has multiple distinct points, split it across slides.
- Titles are short. Body text on the slide is 2-3 lines maximum. All remaining detail goes in an HTML comment as speaker notes.
- Never repeat the same layout twice in a row. Rotate between:
  - Title hero (dark background, large display type, key stat)
  - Two-column (colored sidebar left, body text right)
  - Stat or quote (dark hero, single large number or statement)
  - Grid cards (3 or 4 cards, used for comparisons or options)
  - Full-width content (accent bar left, label, heading, body)
- Every slide gets a slide number and the logo.
- Where the content document contains illustration placeholders, insert a dashed placeholder box with a label describing what the illustration should show.

## Color and Typography

Apply the brand palette from the design document using CSS variables:

```css
--navy:   #003D7A;
--blue:   #0088CC;
--orange: #FF6600;
--teal:   #003D5C;
--white:  #FFFFFF;
--gray:   #F5F5F5;
```

- 60/30/10 rule: white space dominant, navy for structure, orange only for emphasis and calls to action.
- Titles use a condensed bold display font (Barlow Condensed or similar). Body uses regular weight at readable size.
- Dark hero slides use white text. Light slides use navy text.
- Orange appears on maximum 2-3 slides for emphasis. Not decorative.

## Slide Structure

- Open with a hero title slide that includes a key stat or two from the content to establish stakes immediately.
- Close with the strongest argument in the document as a dark hero slide.
- The middle follows the document structure but reorders for narrative momentum: problem before anatomy, anatomy before solution, solution before implementation.

## Output Requirements

- Single self-contained HTML file.
- Logo referenced as a relative path matching the asset filename provided.
- Slide dimensions 1280x720px, displayed as a vertical stack.
- Print-ready: include a `@media print` block that removes gaps between slides and sets page breaks after each slide.
- Use CSS variables throughout so the palette can be swapped by editing the root block.
- Each slide is a `div.slide` with fixed dimensions and `position: relative` so all child elements are absolutely positioned within it.