# Secure and Reliable Logistics

Beumer has delivered logistics systems across the world for decades, spanning airports, packaging and airfreight. The software powering those systems was built to solve the problems of its time, and it did.

The problem is that software does not age the way physical infrastructure does. A conveyor belt does not become a security liability by sitting still. Software does. Every day a system goes unpatched is a day the gap between what it knows and what the world knows grows a little wider.

The model of selling software once and letting customers adapt it to their needs made sense when vulnerabilities were rare and isolated events. That world no longer exists.

## Vulnerabilities Are Now a Recurring Cost

Vulnerabilities are not incidents anymore. They are a weekly occurrence across every software ecosystem, from operating systems to open source libraries to development toolchains. The question is no longer whether vulnerabilities will affect our software. It is whether we have a process fast enough to stay ahead of them.

Failing to patch does not hold the line. It compounds. A system unpatched for a week carries last week's risk plus this week's. Unpatched for a year, a system can carry upwards of 500 known vulnerabilities, each a potential vector into the next. The longer the delay, the less the gap looks like a missed update and the more it looks like an open door.

The fork model makes this worse. When customers modify and maintain their own version of our software, patching requires a code merge, not a deployment. That is expensive, slow and easy to defer. Deferred often enough, it stops happening at all, and the security moat that replaced it becomes the only thing standing between the site and a motivated attacker.

That is not a sustainable position for Beumer or for our customers.

<Insert Illustration of compounding vulnerbilities>

## Anatomy of software security risks

Software can have vulnerilities in 3 layers, none of the three can be said to be more or less important to patch as a small vulneraility in the software can lead to a vector in a more severe OS vulnerability.

* Operating System - Base Image. Whether it's a virtual machine or a containers base image, these come stacked with tools and software that allows actions like installing software, internal firewall or accessing internet ressources
* Packages / Libraries and other dependencies. These are the parts of your software that you dont hvae the sourcecode to. They are used by our code because it's productive use of developer time and offer a crucial best practice in areas where we do not want to be specialized; like authentication and cryptography
* Software we develop. Code that developers create on a daily basis to solve domain specific challenges. Incidents involving bad input sanitazation, rainy day scenarios and the typical OWASP top 10 go here.

There's no simple solution to solving these three together, they require a coordinated effort each, individually.

There are additional layers that have been deliberately kept out in this assessment. The hosting infrastructure, be it kubernetes, Windows Server or similar.  Along with Physical or virtual hardware onsite like routers, firewalls and network infrastructure. These are also important points in the armor to maintain, but are outside our control.

### Layer 1 - Operating System

For personal users this is the annoying updates that always seem to come at the wrong time adding an inconvinience. For a modern software enterprise this layer is typically a base image of Linux or Windows that we build our software on top of and deploy as a container in an orchestration env. like Kubernetes, OpenShift or proprietary services like Fargate or ECS from AWS.

All base images are not built equally and can contain many different utilities and software preinstalled. A linux base image might include apt-get, ssh and curl for example that when exploited can install software, call home or initiate shell access.

To secure our operating system we:
* Minimize software found in the image to the bare essentials. Companies like Chainguard make a living out of selling these images
* Use seperate developer images to build our containers without leaking build tools into the finished image
* Deploy regularly to update the base image with the latest fixes and patches.

It's essential that images used in an active environment are scanned with tools like Twistlock or Wiz to understand to what extent they are vulnerable as well as monitor the age of the images to understand where processes are not able to keep a sufficient turnover pace.

### Layer 2 - Dependencies

Toolchain exploits, package takeovers and similar are starting to become daily news. NPM, Pypi, Nuget and Maven are all targets for hostile actors who try to sneak in changes to until now trusted dependnecies.

It's not possible for a company to investigate and understand all their dependencies manually, but certain steps can be taken:

* Artifactory mirrors can introduce trusted sources where an official product from Microsoft is trusted by default, while a dependency from a lesser known or hobbyist gets its use prevented in the pipelines.
* Artifactory mirrors can also introduce a delayed adoption of packages. This buys the community a few days to catch malicious code that have been sneaked into the package and issue an update and a recall.
* Dependency scanning by tooling like Blackduck offer a view into what vulnerbilities are affecting the depdencies in the scanned artifact
* Dependency locks on build time ensures that the software delivered by the pipeline is deterministic. If dependencies at v 1.2.3 was used at last merge to main, it's the same version we deploy with the next time. We want to prevent the use of sliding version windows where anyhing in v1.X is fine or anything newer than v2.X
* Dependabot or other ways to monitor dependency updates help automate pull requests to our software with new, patched versions. Still requiring a test pipeline to merge but reliable updates.

We want to monitor how far our domain code is drifting from the latest versions of our dependencies and make dependency updates a staple part of every iteration.

### Layer 3 - Source Code

The first two layers are largely solved by tooling and process. This one requires skill. The code our developers write every day to solve domain specific logistics challenges is the layer no scanner fully understands and no base image update can fix.

This is where the OWASP Top 10 lives in practice. SQL injection, broken authentication, insecure direct object references, insufficient input validation. These are not exotic attack vectors. They are the most reliably exploited vulnerabilities in production software, year after year, because they emerge from the pressure and complexity of daily development work rather than from a dependency someone else maintained.

Two practices form the foundation here:

**Static Application Security Testin**g tools like CodeQL and SonarQube analyse code before it merges to main. They flag dangerous patterns, highlight where best practices are not met, and create a documented record of what was checked and when. They do not catch everything, but they catch the repeatable mistakes reliably and at low cost.

**Code review remains the final check**. Research consistently shows that review effectiveness degrades sharply as pull request size grows. Beyond 300 changed lines reviewers lose the thread. Beyond 1000 lines a review is largely a formality. Keeping pull requests small and review culture strong is not a process preference, it is a security control.

Neither practice works in isolation. A codebase with strong SAST coverage and weak review culture will still ship logic flaws that no static tool can detect. A strong review culture without SAST will miss the systematic, pattern-based vulnerabilities that tooling catches in seconds. Together they form a layer of defence that is proportionate to the risks our own code introduces.

### Three layers

We now have established the three layers we wish to secure our pipeline on, how we want to monitor it, what to report and the process software must follow

<Illustration>

But how can we make this pipeline end with updating our customers? a fresh container with close to no vulnerbilities isnt valueable if it's not in production.

## Forked Software

Different customers have different special needs that historically has been handled with essentially a fork of our code and modified either by us or by the customer themselves.

This will not work for a post EU Cybersecurity Resillience Act future. Managing software updates that require code merges on a weekly basis is unstainable and very likely to end up taking longer than the length of the update window.

It's also not viable to reject bespoke changes and modifications as different sites have different requirements.

A multipronged effort is needed, and with a clear design philosophy where it is CRITICAL and NON-NEGOTIABLE to bypass interfaces and use internal functions in the software.

<illustration of software boundary>

### Sidecars

Every site operates within a broader infrastructure that predates our software and will outlast it. Monitoring platforms, SIEM systems, log aggregators, identity providers — these are not ours to control or replace, and attempting to do so would make our software impossible to adopt.

The sidecar pattern solves this without touching the main container. A sidecar is a secondary container that runs alongside ours in the same pod, sharing its network and storage context. It intercepts, enriches or forwards data — logs, metrics, auth tokens — without the main container knowing or caring what happens to them downstream.

This keeps the main container generic, unmodified, and firmly on the weekly delivery cadence. Customization lives in the sidecar. The main codebase stays on the trunk.

<expand illustration with a sidecar>

What sidecars can handle:

* Log forwarding and enrichment — the main container writes to stdout, the sidecar handles routing to whatever the site uses: Splunk, Elastic, a proprietary SIEM
* Auth enforcement — token validation against the site's identity provider, so the main container never handles AuthN logic directly
* Metrics and observability export — Prometheus, Datadog, or site-specific tooling without instrumenting the app itself
* Secret injection — credentials and certificates delivered at runtime without baking them into the image
* Audit logging — request and response capture for compliance purposes, applied uniformly without relying on application teams to implement it

The sidecar is deliberately narrow. It exposes configuration, not code; which log destination, which identity provider, which secrets to mount. Sites fill in values; they do not modify behaviour.

For sites without the capability to build their own, we deliver a default sidecar alongside the main container. For sites with mature platform teams, the contract is thin enough that they can bring their own, provided it honours the same interface.

In a Kubernetes environment the sidecar can be auto-injected by the platform operator, meaning the site customer receives it without building or maintaining anything. It simply arrives.

It is critical and non-negotiable that the sidecar remains the customization path for operational concerns. Not a fork, not a patch to the main container, not a workaround through internal functions. The sidecar is the interface. Everything behind it stays ours.

<zoom into sidecar with thin config surface>

### APIs

Be it syncronous RESTful APIs delivering JSON payloads on request, or an event driven architecture pushing and recieving domain or state transfer events over a streaming platform or bus; APIs are the backbone of the modern internet.

Our software can expose themself to the internal network on site and with a multitiered authorization model offer the capability to hook the sites software up to ours.

By offering a complete API ecosystem at the boundary to our software we can decouple from the sites infrastructure entirely while allowing the sites developers to customize on their side.

* light weight API gateway that exposes the OpenAPI specification of the software and enforces best practices like rate limitations to allow for graceful scaling.
* simple event distribution with AsyncAPI specification as the development contract. Useful for reactive systems or high traffic applications where a more local readcopy not on HTTP is preffered.
* Identity Server that enables OAuth2 tokens to be generated and validated for both event and restful needs
* Administration CLI designed to be operated by site domain admins to expose different parts of the API ecosystem, like issuing OAuth2 clients and defining privileges and authorizations.

This approach prioritizes a decoupled architecture over customer experience. It deliberately does not cater to onsite API gateways, identity servers or existing shared infrastructure. Rather it relies on their expertice (or consultancy from us) to integrate.

With a strong API version practice from us we can ensure no changes we make or they make can cause a situation where the internal system cannot be updated.

<expand container with API and event pipe>

### Software Development Kit

The third option is to expose our software's interfaces as an SDK, allowing sites to build their own applications on top of our domain logic without forking our codebase.

This is the most capable integration option and the most consequential one. When a site builds on our SDK, our software becomes a library inside their container. They own Layer 1 and take on partial ownership of Layer 2. We become a dependency in their stack, one that happens to pull in dependencies of its own.

The SDK is a last resort, reached for only when the sidecar and API have proven insufficient for a customer's genuine integration needs. We will develop our understanding of what an SDK would look like as we learn from early customers, but we will not invest in building it until the demand is proven.

<new container with the SDK inside it>

## Implementation Strategy

The shift away from forks is not a big bang migration. It is a deliberate, friction-first process of learning what our customers actually need before we build more than necessary.

We start with two customers. Not two average ones but rather the easiest customer we can find, and the most difficult. The easiest validates that the pipeline and sidecar model works end to end in a real environment. The most difficult tells us where the model breaks and what we genuinely need to build next.

But the selection is not purely technical. We are also choosing people. At each site we need a counterpart, ideally a site administrator or integration lead, who starts sceptical. A reluctant operator who becomes a success story carries more weight inside the organisation than a clean technical proof of concept ever will. Success stories travel through people, not architecture diagrams.

The first milestone is narrow by design: get both customers running on the weekly delivery cadence with sidecar-only customization. No API, no SDK. We are not avoiding those options. We are refusing to build them before we know they are needed. Where does friction appear? Is it a technical integration problem or is it site administrators encountering a new operating model for the first time? Those require very different responses, and the distinction matters more than it appears.

When friction is technical, we build. When friction is organisational, we teach and listen. The harder case to spot is internal. Developers and architects who have spent years building expertise around fork customization will feel their value is at risk. That concern is legitimate and must be addressed directly rather than dismissed. Their knowledge of site-specific requirements does not disappear under the new model. It migrates. The architect who understood why a particular site needed a modified authentication flow now owns the sidecar configuration that achieves the same outcome without touching the trunk. The developer who maintained a customer branch now designs the API integration that replaces it. That is a reframe of where their expertise lives, not a signal that it has become redundant.

We follow the path of most resistance, not the path of most features. If the sidecar proves insufficient and API integration is genuinely required, we pivot and build it. If neither customer needs the API, we find the next most difficult customer and ask the same question again. This principle is also how we bring architects along. They are not being asked to trust a blueprint handed down from a strategy document. Their feedback from real customer friction actively shapes what gets built next. The architecture evolves because they report what broke, what was missing, what the customer actually asked for that the model could not accommodate. They are participants in the design, not recipients of it.

Internally we start with two small teams. A sidecar team and a pipeline team. Not large groups staffed from a resource pool but handpicked engineers and architects chosen because they are curious, technically sharp, and trusted by their peers. Being selected for this work should feel like an opportunity, not an assignment. These are the people who will define how the new model actually works in practice, and their names will be attached to what comes out of it.

The sidecar team owns the integration surface. They figure out what configuration a site actually needs, how thin the interface can remain while still being useful, and where the boundary between our container and the customer's world sits in reality rather than on a whiteboard. The pipeline team owns the delivery machinery. They build the weekly cadence, wire the scanning layers together, and prove that a fresh, patched container can ship reliably without human intervention on a schedule that satisfies the regulation.

Both teams practice on Beumer's physical demo setup before touching a live customer. The demo environment is where assumptions break safely. It is where the sidecar team discovers that their configuration surface missed something obvious, and where the pipeline team learns that their image rebuild takes longer than expected under realistic load. Mistakes made on the demo rig cost nothing. The same mistakes at a customer site cost credibility.

As these two teams prove the model works and begin delivering to the first customers, the work naturally expands. New teams form around new needs as they emerge, not before. An API team when the sidecar proves genuinely insufficient. A platform team when the number of active deliveries outgrows manual oversight. Each new team inherits a model that already works in production and joins a community that already has answers to the first hundred questions. Nobody starts cold.

The fitness functions described in the architectural constraints section serve a second purpose beyond early warning. When dependency age, base image freshness and pull request size are visible and shared across teams, they create a common language. Developers and architects reason about the same numbers, set the same thresholds, and see the same drift. The new architecture becomes something teams can own together rather than something imposed from above and measured from outside.

The SDK remains a future option we watch with curiosity and deploy with reluctance. It fundamentally shifts operational responsibility toward the customer and makes us a dependency in their stack rather than an isolated container we fully control. It solves real problems but creates new ones, and we will not reach for it until the simpler interfaces have been exhausted.

## Upskilling and Focus

The work demands different things from architects and developers than the fork model did. Neither role becomes less technical. Both become differently technical.

The architect's job shifts from designing bespoke solutions per customer to owning the boundary. They need a deep understanding of what a customer might genuinely need from the sidecar and API surface, but equally they need the judgement to recognise where a requirement can be simplified or redirected rather than accommodated at full complexity. Not every request deserves a new integration point. Some deserve a conversation about whether the underlying need can be met with configuration that already exists. That judgement, knowing when to build and when to push back with a simpler alternative, is the core architectural skill in this model. They also own the fitness functions. Not as a reporting obligation but as the instrument through which they read the health of what they have designed. If dependency drift is climbing or image age is creeping, the architect is the one who understands why and decides what to do about it. The metrics are theirs to interpret and act on.

Developers need to become fluent in the infrastructure their code now ships inside. Dockerfiles, Kubernetes manifests, Helm charts, YAML configuration, pipeline definitions. These are no longer the platform team's problem handed over at deployment time. They are part of the product. A developer who writes application code but cannot reason about how it is built, scanned, packaged and deployed weekly is only doing half the job. Container construction, multi-stage builds, base image selection, resource limits, health probes, graceful shutdown behaviour. These are daily concerns, not occasional ones. The pipeline is not something that runs after development. It is part of development.

Neither set of skills is exotic. They are the standard toolkit of modern software delivery. But they represent a genuine shift from the fork model where a developer's world ended at the repository boundary and an architect's world ended at the design document. In the new model both roles extend into production, and the demo rig is where that extension begins safely.

## Support Model

The commercial model changes to match the delivery model. A flat purchase price made sense when software was delivered once and maintained by the customer. It does not make sense when we are delivering a fresh, patched container every week regardless of whether new features shipped.

The new model is a monthly subscription. What customers are buying is not a feature release but rather it is a continuously maintained, secure, supported software system. Every week brings a new base image, updated dependency locks, and a pipeline that has passed the full suite of security checks. Some weeks that includes new functionality. Every week it includes a current security posture.

This also changes the support relationship. We are no longer handing off a binary and stepping back. We are in a continuous delivery relationship with every active customer, which means incidents, patches and critical CVEs are our problem to resolve on the weekly cadence, not theirs to absorb and manage alone.

## Architectural Constraints

The new architecture carries explicit constraints. These are not preferences but rather they are load-bearing decisions that make the security and delivery model function.

**Platform requirement**: Kubernetes or an equivalent container orchestration platform is a prerequisite to running our software. This enables sidecar injection, rolling deployments, and the operational model the weekly cadence depends on. Sites that cannot meet this requirement cannot participate in the new model until they can.

**No external dependencies at runtime:** Our containers must not depend on software, services or infrastructure on the customer side to function. Configuration is injected. Integrations are outbound through our API boundary. We do not take runtime dependencies on what the site happens to have installed.

**Fitness functions:** The health of the architecture is measured continuously, not audited annually. The following metrics are tracked across all active deliveries:

* Dependency age: how far declared dependencies have drifted from current patched versions
* Base image age: time since the deployed image was last rebuilt from a fresh base
* Concurrent open pull requests: a proxy for integration debt accumulating in the pipeline
* Pull request age: how long changes are sitting unmerged and undeployed
* Median pull request size: a leading indicator of review quality. Beyond 300 changed lines, review effectiveness drops sharply
* SAST findings: open static analysis findings by severity, tracked over time and not just at point of scan

These are not vanity metrics. They are the early warning system for the compounding vulnerability problem described at the start of this document. A rising base image age or a growing backlog of SAST findings is the same signal as an unpatched system it's just caught earlier.

## The Regulatory Clock is Running

Since 2024 the EU Cyber Resilience Act has fundamentally changed what it means to sell software on the European market. For the first time, manufacturers are legally accountable for the security posture of their software after it leaves their hands.

The act rolls out in two stages:

* 2026: Manufacturers must notify authorities of severe incidents and actively exploited vulnerabilities in their software
* 2027: Full application. Any new software sold must ship with an active cybersecurity strategy covering the five years following acquisition

This is not a compliance checkbox. It is a structural change to the support relationship between Beumer and every site running our software.

Under the current model, a customer who forked three years ago and never merged an update is running software we have no visibility into and no control over. If that software contains an actively exploited vulnerability in 2027, the question of who is responsible becomes a legal one, not just an operational one.

The fork model does not just make updates expensive. It makes compliance structurally impossible.

A subscription model with weekly delivery, maintained by us, with fitness functions we can report against, is not just better engineering. It is the only model that gives us a defensible answer when a regulator or a customer asks: what is the current security posture of your software, and how do you know?
