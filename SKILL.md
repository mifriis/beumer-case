# BEUMER Presentation Workflow Skill

## Overview

This skill documents how to create professional presentations using **Marp** + **design.md** principles.

**Key Principle**: Design thinking → Content strategy → Marp implementation

---

## Workflow: Design-First Approach

### Phase 1: Plan (Design.md)

**Before touching slides**, use `design.md` as your reference:

1. **Understand the palette**
   - 60% white space
   - 30% Navy (structure)
   - 10% Orange (emphasis only)

2. **Choose layouts** (min 5 different)
   - Title + visual
   - Dark hero + CTA
   - Image-dominant
   - Data/stat
   - Two-column
   - Quote/message

3. **Plan speaker notes**
   - All detail goes in notes
   - Slides show visuals only
   - One idea per slide

### Phase 2: Structure (case.md)

**Marp frontmatter** (from design.md quick start):

```markdown
---
marp: true
footer: '![height:25px](logo.png)'
style: |
  section {
    font-family: 'Helvetica Neue', Arial, sans-serif;
    background: white;
    padding: 60px;
  }
  section h1 { color: #003d7a; font-weight: 700; font-size: 56px; }
  section h2 { color: #0088cc; font-weight: 600; border-left: 4px solid #0088cc; padding-left: 12px; }
  section > p { color: #003d7a; font-size: 24px; }
---
```

**Slide structure** (per layout type):

```markdown
# Title Slide

Text minimal. Visual focus.

<!-- Speaker notes: Full context, transitions, data -->

---

## Section Header

Key point.

<!-- Notes with depth -->
```

### Phase 3: Build (build.sh)

**Generate presentation**:

```bash
chmod +x build.sh
./build.sh              # Builds case.md → presentation.html
./build.sh --pdf       # Also creates PDF
```

---

## Content Mapping

### When to use each layout:

| Content Type | Layout | Example |
|--------------|--------|---------|
| Introduction | Title + visual | "Who We Are" |
| Key message | Dark hero + CTA | "Solutions That Move" |
| Feature list | Bullets (minimal) | "Industries" |
| Data/metrics | Large number | "6,000+ employees" |
| Process | Two-column | "How it works" |
| Emphasis | Quote slide | "Our commitment" |

---

## Writing for Marp (Slideology Rules)

### On the Slide ✅

- Title (1 line max)
- One statement or visual
- Logo in footer
- Accent color strategically

### In Speaker Notes ✅

- Full explanation
- Data and context
- Transition phrases
- Questions to address
- Call-to-action details

### Never on Slide ❌

- Dense paragraphs
- Bullet soup (use 3 bullets max)
- Small text
- Unnecessary decoration

---

## Example: Content to Slide

### Your content:

"BEUMER Group has 6,000 employees across 70 countries. We provide baggage handling for airports, sortation for e-commerce, conveyor systems for manufacturing, and terminal automation for ports. Our key differentiators are proven reliability, global support networks, and fully customizable solutions."

### Marp slide:

```markdown
## Who We Are

**6,000+ employees | 70+ countries**

---

<!-- 
Speaker notes:
BEUMER Group is an international quality leader in intralogistics. We serve:
- Airports (baggage handling, CrisBag ICS)
- E-Commerce (high-speed sortation)
- Manufacturing (conveyor networks)
- Ports (terminal automation)

Key differentiators: proven reliability, global support, custom solutions.

Use this moment to speak to the audience. Let the slide breathe.
-->
```

---

## Marp Syntax Quick Ref

```markdown
# H1 Title
## H2 Subtitle
### H3 Header

**bold** *italic*

- Bullet list
- Keep minimal

![image alt](image.jpg)           # Inline image
![bg](image.jpg)                  # Full background
![bg left:50%](image.jpg)         # Split layout

<!-- Speaker notes here -->       # HTML comments (notes)

---                                # Slide separator

<!-- Classes for styling -->
<!-- <!-- _class: dark --> -->     # Dark slide
```

---

## Design Validation Checklist

Before presenting:

- [ ] No layout repeats (5+ unique templates used)
- [ ] Every slide readable in 3 seconds
- [ ] Orange used only for CTAs or emphasis (max 3x)
- [ ] All detail in speaker notes
- [ ] All visuals on-brand (professional, BEUMER colors)
- [ ] White space > content (60/30/10 rule)
- [ ] Logo in footer or once per section
- [ ] Titles are statements, not questions
- [ ] One idea per slide (no crowding)
- [ ] Marp builds cleanly (`./build.sh` succeeds)

---

## Troubleshooting

### Marp not building
```bash
marp --version                    # Check installation
npm install -g @marp-team/marp-cli # Reinstall
```

### Images not showing
- Use absolute URLs or relative paths from project root
- Check file names (case-sensitive)
- Use `![](logo.png)` for local files

### Styling not applied
- CSS must be in frontmatter `style: |` block
- Use `section` for all slides, `section.dark` for dark slides
- Check Marp CSS syntax (use valid CSS)

### PDF build fails
- Some images may not embed in PDF
- Try `--allow-local-files` flag if needed
- Fallback: Print HTML to PDF from browser

---

## File Structure

```
beumer-case/
├── case.md              # Main presentation (edit this)
├── design.md            # Design system reference (read this)
├── build.sh             # Build script (run this)
├── logo.png             # Brand logo
├── presentation.html    # Generated (ignore)
├── presentation.pdf     # Generated (ignore)
├── README.md            # Project info
└── SKILL.md             # This file
```

---

## Workflow Summary

1. **Edit** `case.md` (content + marp syntax)
2. **Reference** `design.md` (design principles)
3. **Run** `./build.sh` (generate HTML)
4. **View** `presentation.html` (test in browser)
5. **Repeat** steps 1-4 until done

---

## Why This Works

- **Design-first**: design.md sets the rules. No debate.
- **Content-focused**: Minimal on-screen text forces clarity.
- **Speaker notes**: Full context where it belongs.
- **Marp simplicity**: Markdown = fast iteration.
- **Nancy Duarte**: Contrast + white space = engagement.
- **Script automation**: One command to build.

---

**Last Updated**: May 13, 2026  
**Tool**: Marp CLI  
**Framework**: Nancy Duarte Slideology + Anthropic Skills Approach
