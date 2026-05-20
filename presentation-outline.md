# Presentation Outline — Secure and Reliable Logistics

## Meta

- 19 slides
- Design system: updated-design.md (BEUMER brand, Barlow font, navy/blue/orange palette)
- Orange used on max 3 slides: slide 1, slide 3, slide 19
- No two adjacent slides share the same layout
- Speaker notes in HTML comments on every slide

---

## Slides

### 1. Opening — Title Hero (dark)
**Layout:** Title Hero (dark teal)
**Title:** "Software Doesn't Stay Safe by Standing Still"
**Subtitle:** Strategy for continuous security, compliant delivery, and replacing the fork model
**Orange CTA element:** "EU CRA Deadline: 2027"
**Illustration placeholder:** BEUMER logistics site — conveyor, airport, packages

---

### 3. The Cost of Inaction — Stat Hero (dark)
**Layout:** Stat / Quote Hero (dark teal)
**Large stat:** 500+ (orange)
**Statement:** Known vulnerabilities in a system left unpatched for one year
**Illustration placeholder:** Compounding vulnerability curve — exponential line over 12 months

---

### 4. Root Cause — Two-Column Split
**Layout:** Two-Column Split
**Left panel (navy):** "The Fork Model Is the Problem"
**Right side:** 3 numbered points
1. Patch = Merge — reconciling customer-specific changes runs to thousands of hours
2. Deferred Becomes Never — expensive enough to defer, it stops happening entirely
3. CRA Makes It Illegal — from 2027 we are accountable for security posture post-delivery

---

### 5. Three Security Layers Overview — Grid Cards
**Layout:** Grid Cards (3 cards)
**Title:** "Three Layers. All Three Matter."
**Cards:**
- Layer 1 — Operating System (navy top border)
- Layer 2 — Dependencies (blue top border)
- Layer 3 — Source Code (orange top border — note: orange card accent, not the headline)
**Each card:** label, title, 2-line body, illustration placeholder

---

### 6. Layer 1 Deep Dive — Left Panel
**Layout:** Left Panel
**Left (navy):** "Layer 1 — Operating System" / Minimize. Build separately. Deploy regularly. Scan continuously.
**Right:** 4 controls — Distroless Base Images, Multi-Stage Builds, Weekly Rebuild Cadence, Runtime Scanning (Twistlock / Wiz)

---

### 7. Layer 2 Deep Dive — Two-Column Split
**Layout:** Two-Column Split
**Left (blue):** "Layer 2 — Dependencies" / Supply chain attacks are now a daily event
**Right:** 4 numbered controls — Trusted Artifactory Mirrors, Dependency Locks, Dependabot Automation, Blackduck / SCA Scanning

---

### 8. Layer 3 Deep Dive — Left Panel
**Layout:** Left Panel
**Left (dark green):** "Layer 3 — Source Code" / The layer no scanner fully understands
**Right:** Two columns — SAST (CodeQL / SonarQube) and Code Review (300-line cliff) with illustration placeholders

---

### 9. Section Pivot — Title Hero (dark)
**Layout:** Title Hero (dark teal, blue accent bar instead of orange)
**Title:** "A Clean Container Is Worthless If It Never Reaches Production"
**Body:** The pipeline secures what we build. The integration model determines whether we can deliver it weekly.

---

### 10. Three Integration Patterns — Grid Cards
**Layout:** Grid Cards (3 cards)
**Title:** "Three Ways to Customise Without Forking"
**Subtitle:** Reach for them in order. Build the next only when the previous proves insufficient.
**Cards:**
- Sidecar (navy top, "Default")
- API (blue top, "When Sidecar Is Insufficient")
- SDK (grey top, "Last Resort")

---

### 11. Sidecar Detail — Full-Width Content
**Layout:** Full-Width Content (navy accent bar)
**Title:** "The Sidecar"
**Left half:** explanation + critical non-negotiable quote
**Right half:** 5 row list — log forwarding, auth enforcement, metrics export, secret injection, audit logging
**Illustration placeholder:** main container + sidecar in same pod, thin config surface

---

### 12. API Detail — Two-Column Split
**Layout:** Two-Column Split
**Left (blue):** "API Integration" / Sites connect their own systems at the boundary
**Right:** 4 components — API Gateway (OpenAPI), Event Distribution (AsyncAPI), Identity Server (OAuth2), Admin CLI
**Illustration placeholder in left panel:** container with API + event pipe at boundary

---

### 13. Implementation: Two Customers — Full-Width Content
**Layout:** Full-Width Content (blue accent bar)
**Title:** "Two Customers. Path of Most Resistance."
**Left:** 3 paragraphs — easiest + hardest selection, choosing the right people, sidecar-only first milestone
**Right:** 3 stacked cards — Easiest Customer, Most Difficult Customer, Next Most Difficult

---

### 14. Internal Teams — Two-Column Split
**Layout:** Two-Column Split
**Left (navy):** "Two Teams. Handpicked." / Not staffed from a resource pool / Practice on the demo rig first
**Right:** Two cards — Sidecar Team (navy top), Pipeline Team (blue top) + expansion note

---

### 15. Upskilling — Left Panel
**Layout:** Left Panel
**Left (dark teal):** "Upskilling and Focus" / "Different Work. Not Less."
**Right:** Two columns side by side
- Architect: boundary ownership, requirements judgement, fitness functions, customer translation
- Developer: Dockerfiles + multi-stage builds, Kubernetes manifests + Helm, pipeline definitions, graceful shutdown + health probes

---

### 16. Support Model — Full-Width Content
**Layout:** Full-Width Content (blue accent bar)
**Title:** "From Licence to Subscription"
**Three panels:** Old model (grey) → arrow → New model (navy)
**Footer:** We are no longer handing off a binary and stepping back.

---

### 17. Fitness Functions — Data / Metrics Grid
**Layout:** Data / Metrics Grid (navy accent bar)
**Title:** "Fitness Functions"
**Subtitle:** Measured continuously. A shared language across teams.
**6 metric cards (2 rows × 3 cols), colour-coded by risk level:**
- Red: Dependency Age, Base Image Age
- Amber: SAST Findings, Open Pull Requests
- Green: Pull Request Age, Median PR Size

---

### 18. Regulatory Clock — Two-Column Split
**Layout:** Two-Column Split
**Left (navy):** "The Clock Is Running" / CRA makes manufacturers legally accountable post-delivery
**Right:** Two milestone rows — 2026 (incident reporting, now) / 2027 (five-year mandate, full application) + pull quote about fork model and legal accountability

---

### 19. Closing — Title Hero (dark)
**Layout:** Title Hero (dark teal, orange accent bar bottom)
**Title:** "A Weekly Cadence, Maintained by Us, With Fitness Functions We Can Report Against"
**Body:** That is the only model that gives us a defensible answer when a regulator asks: what is the current security posture of your software — and how do you know?
**Orange CTA element:** "Sidecar · Pipeline · Weekly · Subscribed"
