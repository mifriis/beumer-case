# Speaker Notes

---

## Slide 1 — Software Doesn't Stay Safe by Standing Still

Good morning. I want to start with a single observation: software does not age the way physical infrastructure does.
A conveyor belt does not become a security liability by sitting still. Software does. Every day a system goes unpatched,
the gap between what it knows about the threat landscape and what the world knows grows a little wider.

For over two decades BEUMER has delivered world-class logistics software across airports, packaging facilities and air
freight operations. That software was built to solve the problems of its time. It did that well. But the model that
came with it — sell it, fork it, let the customer adapt it — was built for a world where security vulnerabilities were
occasional events. That world no longer exists. Today I will explain what that means technically, what we need to do
about it, and what it means for the people in this organisation.

---

## Slide 2 — 500+

Let me give you one number that puts the problem in concrete terms. A system left unpatched for a single year
accumulates upwards of 500 known, documented, indexed vulnerabilities with working exploits available.
Each one can serve as a stepping stone into the next.

This is not a dramatic estimate. It is the reality of what happens when you deploy software and then stop updating it.
Security research continues. Dependency vulnerabilities are disclosed. OS patches ship. All of that happens whether
we participate or not. The fork model makes this worse because patching is not a deployment — it is a code merge.
That takes weeks or months. It is expensive and easy to defer. Deferred often enough, it stops happening at all.
This is the problem we are solving today.

---

## Slide 3 — The Fork Model Is the Problem

The fork model worked well for two decades because customisability was the thing that let us win tenders competitors
would not touch. That advantage is real and we are not discarding it.

But the model has a structural flaw. When a customer runs their own modified version of our software, a security
patch is not a deployment. It is a code merge. Every customer-specific change must be reconciled with whatever we
changed on the trunk. For complex sites with years of accumulated modifications, that can take thousands of hours.
Work that expensive is easy to defer. Deferred often enough, it stops entirely.

From 2027 that is not just an operational problem. The EU Cyber Resilience Act makes manufacturers accountable for
the security posture of their software five years after delivery. The fork model does not give us a defensible answer
to that question. So we change the model.

---

## Slide 4 — Three Layers. All Three Matter.

Software security risk exists across three distinct layers and all three need to be addressed independently.
None of them can substitute for the others, and a weakness in any one creates a path into the next.

Layer 1 is the operating system — the base image the container is built on. Controls: minimise what is in the image,
separate build and runtime images, rebuild on a weekly cadence, scan running images continuously.

Layer 2 is dependencies — the third-party packages and libraries our code depends on. Supply chain attacks and
package takeovers are now regular events across NPM, PyPI, NuGet and Maven. Controls: trusted mirrors, version locks
at build time, automated update tooling, SCA scanning.

Layer 3 is source code — what our developers write. This is where the OWASP Top 10 lives. SQL injection, broken
authentication, insecure direct object references. Controls are SAST tooling combined with a genuine review culture
built around small pull requests. Above 300 changed lines, review quality drops sharply. That is a security control,
not a process preference.

I will spend a moment on each layer.

---

## Slide 5 — Operating System

For a modern software enterprise the OS is not something installed on a server. It is the base image the container
is built on and deployed from. And base images are not equal. A standard Linux base image ships with apt-get, curl,
SSH — tools a malicious actor can use to install software, call back to an external server, or open a shell.

The fix is to minimise. Distroless or hardened minimal base images contain only what the runtime application needs.
Nothing else. Companies like Chainguard have built a business on providing these.

Multi-stage builds ensure that the tools you need to compile and test the software never make it into the final
runtime image. The build container has everything. The production container has almost nothing.

And then we rebuild. Every week. Whether or not new features shipped. The base image age metric is what tells
us when that cadence is slipping before it becomes a problem.

---

## Slide 6 — Dependencies

Layer 2 is the code we rely on but did not write. Every product depends on an ecosystem of third-party libraries —
authentication, cryptography, HTTP clients, serialisation. We use them because building everything from scratch is
neither productive nor more secure.

The risk is that we cannot audit all of them. Supply chain attacks — where malicious code is quietly inserted into
a previously trusted package — are now a regular occurrence. Log4Shell affected millions of systems because a widely
used logging library contained a critical flaw that had gone unnoticed.

Our four controls: trusted mirrors that filter what can even enter our builds; version locks so a build is
deterministic and no unexpected change sneaks in between runs; Dependabot so updates happen routinely rather than
in a crisis; and SCA scanning with Blackduck so we have visibility into what vulnerabilities are already inside our
dependency tree. The goal is to keep dependency drift small and visible.

---

## Slide 7 — Source Code

Layer 3 is the code our developers write every day. This is the layer no scanner fully understands and no base
image update can fix. It is also where the most reliably exploited vulnerabilities in production software live.
SQL injection, broken authentication, insecure direct object references. The OWASP Top 10. These appear year after
year not because developers are careless but because they emerge from the pressure and complexity of daily
development work.

Two practices form the foundation. SAST — tools like CodeQL and SonarQube — analyses code before it merges.
It catches the repeatable, pattern-based mistakes that a tool can recognise. Not everything. But a lot, reliably,
at low cost.

The second practice is code review, and there is specific research worth knowing here. Review quality degrades
sharply as pull request size grows. Above 300 changed lines reviewers start losing the thread. Above 1,000 lines
a review is largely a formality. Keeping PRs small is therefore not just good engineering hygiene. It is a
security control. You need both practices. Neither is sufficient alone.

---

## Slide 8 — A Clean Container Is Worthless If It Never Reaches Production

We have covered how we secure what we build. Three layers, continuous scanning, a weekly cadence from a freshly
patched base image. But none of that matters if the software cannot reach the customer.

Under the current model, reaching the customer requires a code merge. That is the bottleneck that makes the weekly
cadence impossible. So the second half of this strategy is about replacing the fork model with an integration
architecture that allows us to meet customer needs without ever modifying the core container.

There are three tools for doing that. I'll walk through them in order of preference.

---

## Slide 9 — Three Ways to Customise Without Forking

Three integration patterns, ordered by preference. We start with the simplest and only move to the next when the
previous genuinely cannot solve the problem.

The sidecar is the default. It handles the operational concerns that vary by site — log routing, auth tokens,
secrets injection, metrics export — without touching the main container at all. The main container stays generic,
unmodified, and on the weekly delivery cadence.

The API is the second option. When a site needs deeper integration — triggering events, reading state, building
their own tooling on top of our domain logic — we expose that through a versioned API boundary. They build on
their side. We build on ours. Our updates do not break their integrations.

The SDK is the last resort and we will not invest in building it until the demand from real customers has been
proven. It makes us a dependency inside their container and shifts security responsibility toward them.
I will spend a moment on each.

---

## Slide 10 — The Sidecar

The sidecar is a Kubernetes pattern. A sidecar container runs alongside the main application container in the same
pod, sharing its network and storage context. It can see everything the main container produces, but the main
container does not need to know the sidecar exists.

Every site we deploy to has existing infrastructure we cannot control: log aggregators, SIEM systems, identity
providers, monitoring platforms. We do not want to replace those. We want to connect to them. The sidecar is the
connection point. Log routing, authentication token handling, secrets management, metrics export, audit logging —
all of this lives in the sidecar. The main container just writes to stdout and reads its configuration.

The sidecar exposes configuration, not code. A site fills in values: which log destination, which identity
provider, which secrets to mount. They do not modify behaviour. They do not access our internal functions.

In Kubernetes the sidecar can be auto-injected by the platform operator. It simply arrives alongside the main
container. Sites with mature platform teams can bring their own sidecar, provided it honours the same interface.
For everyone else we deliver a default one.

---

## Slide 11 — API Integration

When the sidecar is not enough — when a site needs to trigger actions in our software, read operational state, or
build their own tooling on top of our domain logic — we expose that through an API boundary.

Four components. A lightweight API gateway that enforces versioning and rate limiting. An event distribution layer
for reactive integrations where HTTP polling is not appropriate. An OAuth2 identity server so access is authorised
consistently across both interfaces. And an admin CLI so site administrators can manage their own access without
dependency on us.

The model is deliberately opinionated. It does not try to connect to whatever identity provider or gateway the site
already has. It brings its own and expects the site to integrate to ours. That is a deliberate choice: adapting to
every site's existing infrastructure would make variation across sites expensive to maintain.

The critical constraint is API versioning. Our updates must never break a running integration. Strong versioning
discipline on our side means we can ship weekly and their systems keep working.

---

## Slide 12 — Two Customers. Path of Most Resistance.

The implementation does not start with a full migration. It starts with two customers, chosen deliberately.

The easiest available and the most difficult. The easiest gives us a clean proof of concept — does the pipeline work,
does the sidecar cover what a site actually needs, can we deliver on a weekly cadence in a real environment?
The most difficult is the one that tells us what we do not yet know. Where does the model break? What did we not
build that we should have?

But we are also choosing the right people. At each site we want someone who starts sceptical — an integration lead
or site administrator who has to be convinced. When they are convinced, their story travels. Architecture diagrams
do not convince people. Other people do.

The first milestone is deliberately narrow. Sidecar only. We refuse to build what we have not yet proven is needed.
The friction we encounter is data. If the sidecar proves insufficient and API integration is genuinely needed, we
build it. If neither customer needs the API, we find the next most difficult customer and ask again.

---

## Slide 13 — Two Teams. Handpicked.

Internally we start with two small teams. Not whoever is available — handpicked.

The sidecar team and the pipeline team. Chosen because they are curious, technically sharp, and respected by the
people around them. Being asked to join one of these teams should feel like recognition, not a rotation. These are
the people who will define how this model actually works in practice. Their names will be attached to what comes out.

Before they touch a live customer, both teams work on Beumer's physical demo setup. The demo environment is where
assumptions break safely. The sidecar team will discover their configuration surface missed something obvious.
The pipeline team will find their image rebuild takes longer than expected under realistic load. Those discoveries
on the demo rig cost nothing. The same discoveries at a customer site cost credibility.

As these teams prove the model and start delivering to the first customers, the work expands organically. An API
team when the sidecar genuinely is not enough. A platform team when active customer count outgrows manual oversight.
Each new team inherits a model already working in production. Nobody starts cold.

---

## Slide 14 — Different Work. Not Less.

The new model asks different things from both architects and developers. I want to be direct about what those are.

For architects: the job shifts from designing bespoke solutions per customer to owning the boundary. Their deep
knowledge of what individual sites need does not go away — it becomes the thing that makes them good at sidecar
design. Understanding which requirements genuinely need a custom integration and which can be met with configuration
that already exists. That judgement is the core architectural skill in this model. They also take ownership of the
fitness functions — not as a reporting task but as an instrument for reading the health of what they designed.

For developers: the boundary of the job expands to include the infrastructure their code ships inside. Dockerfiles,
Kubernetes manifests, Helm charts, pipeline definitions. These are not the platform team's responsibility handed
over at deployment. They are part of the product. A developer who cannot reason about how their code is built,
scanned, packaged and deployed is only doing half the job.

None of these skills are exotic. They are the standard toolkit of modern software delivery. The demo rig is where
both roles start extending into production safely.

---

## Slide 15 — From Licence to Subscription

The commercial model has to change to match the delivery model. A flat purchase price made sense when software
was sold once and the customer maintained it from that point forward. It does not make sense when we are now
delivering a freshly patched, rebuilt container every single week.

What customers are buying under the new model is not a feature release. It is a continuously maintained security
posture. Every week brings a new base image from the latest patched source, updated dependency locks, and a full
pass through the scanning pipeline. Some weeks that includes new functionality. Every week it includes current
security.

This also changes the support relationship fundamentally. Under the old model we handed off a binary and stepped
back. Under the new model, critical CVEs and security incidents are our problem to fix on the weekly cadence.
We are in a continuous delivery relationship with every active customer. That is a significantly different and
stronger value proposition — especially in the context of the CRA.

---

## Slide 16 — Fitness Functions

The health of this architecture is measured continuously. Six metrics across three risk levels.

The two red metrics — dependency age and base image age — are the leading indicators of the compounding
vulnerability problem we described at the start. When these start rising, the system is drifting back toward the
same exposure profile the fork model created.

SAST findings and open PR count are amber. A growing backlog of static analysis findings means vulnerabilities
are being identified but not resolved. A growing PR count means integration debt is accumulating.

PR age and median PR size are the metrics that tell you whether engineering culture is holding. Long-lived PRs
mean patches are not reaching production. Large PRs mean review quality is degrading — and review is a security
control.

What makes these more than a dashboard is the second thing they do: they create a shared language. When developers
and architects reason about the same six numbers, set the same thresholds, watch the same trends, the architecture
becomes something teams own together rather than something imposed from above.

---

## Slide 17 — The Clock Is Running

The EU Cyber Resilience Act is not coming. It is here. We are in 2026, which means the incident reporting
obligation is already in force. If a severe incident affects software we manufactured and delivered, we are
required to notify the relevant authorities. That means we need to know what is running at every customer site
and what its current security posture is. Under the fork model, we do not have that visibility.

In 2027 the full act applies. Any new software sold after that date must ship with an active, documented
cybersecurity strategy covering the five years following acquisition. Not a form. An actual strategy with
a delivery model behind it.

The fork model does not just make this expensive. It makes it structurally impossible. A customer who forked
our software three years ago and never merged an update is running a system we cannot see, cannot update and
cannot report on. If that system contains an actively exploited vulnerability, the CRA makes the question of
who is responsible a legal one. The strategy I have described today is the answer to that question.

---

## Slide 18 — Closing

I'll close with what I think is the single most important sentence in this entire strategy.

A subscription model with weekly delivery, maintained by us, with fitness functions we can report against, is not
just better engineering. It is the only model that gives us a defensible answer when a regulator or a customer
asks: what is the current security posture of your software, and how do you know?

Under the current fork model, we cannot answer that question. We do not know what is running at customer sites.
We do not control what gets patched or when. We cannot report on it.

Under the model I have described today, we can. Every site, every week, same pipeline, same standards,
same visibility.

The regulation has given us a deadline. The architecture gives us the answer. The two founding teams are where
we start. The demo rig is where we prove it. Thank you.
