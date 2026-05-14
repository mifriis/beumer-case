# BEUMER Group Presentation Design System

**Nancy Duarte Slideology Approach**: Contrast, storytelling, minimal text, maximum visual impact.

**Core Principle**: Let the image speak. Text goes in notes. Design breathes.

## Visual Hierarchy Strategy

### The BEUMER Brand Palette

Use color **strategically** for meaning, not decoration:

| Purpose | Color | Hex | Role |
|---------|-------|-----|------|
| **Trust/Authority** | Dark Navy | #003D7A | Header, titles, grounding |
| **Innovation/Energy** | Primary Blue | #0088CC | Accent bar, section divider |
| **Call-to-Action** | Bright Orange | #FF6600 | Primary CTA, hero section button |
| **Breathing Room** | White | #FFFFFF | Dominant background (60%+) |
| **Contrast Layer** | Dark Teal | #003D5C | Dark hero section background |
| **Subtle** | Light Gray | #F5F5F5 | Section break, subtle background |

### The Rule

**60/30/10 Principle** (Duarte + Design Basics):
- 60% White space (emptiness is strength)
- 30% Primary color (Navy for text/structure)
- 10% Accent (Orange for emphasis)

## Typography: Strength Through Simplicity

**Font Family**: Clean sans-serif (Helvetica Neue, Arial)

### Text Minimalism

| Element | Style | Notes |
|---------|-------|-------|
| **Slide Titles** | Bold, 32-48px, Navy | Let it breathe. One line when possible. |
| **Body Text** | Regular, 18-24px, Navy | 2-3 lines max. Use bullet-free when you can. |
| **Large Quote** | Bold, 36px, Orange | Duarte's pattern: single powerful statement |
| **Small Text/Notes** | 14px, Medium Gray | Speaker notes only—never crowd the slide. |

### Anti-Pattern

❌ DON'T: Dense paragraphs, small font, bullet soup  
✅ DO: One strong statement. One image. One idea per slide.

## Logo

**File**: `logo.png`  
**Placement**: Top-left corner (40px height) or footer  
**Strategy**: Use subtly. Don't let branding crowd the message.

---

## The Duarte Principle: Resonate → Direct

Every slide follows this pattern:

1. **Resonate** (emotional connection)
   - Strong visual
   - One clear statement
   - White space

2. **Direct** (call-to-action or next idea)
   - Orange accent or button
   - Clear next step
   - Contrast creates power

## Slide Layouts: Variety is Power

**Anti-Pattern Alert**: Never repeat the same layout. Monotony kills engagement.

### Core Layout Templates

1. **Title + Vertical Accent Bar**
   - 4px Navy bar on left (Duarte white space)
   - Title (Orange or Navy) on white
   - Single key visual on right
   - Speaker notes: Full context here

2. **Dark Hero + Orange CTA**
   - Dark Teal background (#003D5C)
   - White text (1-2 lines max)
   - Orange button or accent
   - Use for: Calls-to-action, pivots, emphasis

3. **Image-Dominant**
   - Full-bleed industrial/logistics image
   - Minimal text overlay (Navy or White)
   - Quote or single statement
   - Logo in corner

4. **Data/Stat Visual**
   - Large number (orange or Navy)
   - 1-2 sentence explanation
   - Icon or visual metaphor
   - Context in speaker notes

5. **Two-Column**
   - Left: Image or visual
   - Right: Navy title + 3-4 bullets (or statement)
   - Plenty of white space between

6. **Quote/Message Slide**
   - Orange statement (Duarte's power of contrast)
   - Navy subtext if needed
   - Minimal background (white or light gray)
   - Use before big reveal

### Spacing Rules

- **Top/Bottom Margin**: Minimum 20px (breathing room)
- **Side Margin**: 40px+ (don't crowd edges)
- **Between Elements**: 30px minimum (white space is not wasted space)
- **Text Width**: 60-70% of slide max (let the right side breathe)

---

## Brand Positioning

**BEUMER Group is**: Industrial. Global. Trusted.

- Professional → Use Navy for authority
- Modern → Clean layouts, white space
- Innovative → Orange sparks energy
- Established → Stability in design

Use this foundation. Let the message come through.

## Speaker Notes Strategy

**The Rule**: Text lives in speaker notes. Slides show visuals.

| Element | Slide | Notes |
|---------|-------|-------|
| **Full explanation** | ❌ | ✅ Put here |
| **Context/data** | ❌ | ✅ Full detail |
| **Transition phrases** | ❌ | ✅ Here |
| **Key statement** | ✅ | (on slide) |
| **Visual** | ✅ | (dominant) |
| **Call-to-action** | ✅ | (1 line max) |

Marp note support:
```markdown
<!-- This is a speaker note in Marp -->
```

## Quick Start: Marp Setup

```markdown
---
marp: true
footer: '![height:25px](logo.png)'
style: |
  section {
    font-family: 'Helvetica Neue', Arial, sans-serif;
    background: white;
  }
  section h1 { color: #003d7a; font-weight: 700; font-size: 48px; }
  section h2 { color: #0088cc; font-weight: 600; border-left: 4px solid #0088cc; padding-left: 12px; }
  section > p { color: #003d7a; font-size: 20px; line-height: 1.6; }
  section.dark { background: #003d5c; }
  section.dark h1, section.dark p { color: white; }
---

# Title Here

<!-- Speaker notes go here. Full context. -->

---

![bg left:50%](image.jpg)

## Key Point

One statement. Right-aligned.

<!-- Notes with data and depth. This is where the story lives. -->
```

---

## Implementation Checklist

- [ ] Choose layouts (aim for 5+ different templates)
- [ ] Every slide: whitespace > content  
- [ ] Orange only for emphasis or CTAs (max 2-3 per presentation)
- [ ] All detail: speaker notes
- [ ] All visuals: professional, on-brand
- [ ] No slide is a duplicate layout
- [ ] Test: Can you read each slide in 3 seconds?

---

**Last Updated**: May 13, 2026  
**Inspiration**: Nancy Duarte (Slideology), Anthropic Skills (PPTX Editing)  
**Brand**: https://www.beumergroup.com/
