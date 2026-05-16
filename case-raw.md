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

### Layer 3 - Source code analysis

The final layer is where our skills, training and expertice plays a big role. Software developed inhouse and highly reflective of the domain it's built for.

This is code where SQL vulnerbilities and the other OWASP top 10s tend to sneak in when teams drop their guard or are under pressure.

* Static Application Security Tools like CodeQL, SonarQube and such help scan and understand our newly produced code before it's merged to main. These help flag problematic areas and highlight where best practices aren't met
* Code Reviews by coworkers remain the last bulwark. Companies with a strong review culture and estalished practices are among the most successful. Very strong research shows quality of merged code plummetes when changed lines in a pullrequest starts growing beyond 300 lines with 1000+ essentially being a rubberstamp

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

The first milestone is narrow by design: get both customers running on the weekly delivery cadence with sidecar-only customization. No API, no SDK. We are not avoiding those options. We are refusing to build them before we know they are needed. Where does friction appear? Is it a technical integration problem or is it site administrators encountering a new operating model for the first time? Those require very different responses.

We start with two customers. Not two average ones but rather the easiest customer we can find, and the most difficult. The easiest validates that the pipeline and sidecar model works end to end in a real environment. The most difficult tells us where the model breaks and what we genuinely need to build next.

If the sidecar proves insufficient and API integration is genuinely required, we pivot and build it. If neither customer needs the API, we find the next most difficult customer and ask the same question again. We follow the path of most resistance, not the path of most features.

The SDK remains a future option we watch with curiosity and deploy with reluctance. It fundamentally shifts operational responsibility toward the customer and makes us a dependency in their stack rather than an isolated container we fully control. It solves real problems but creates new ones, and we will not reach for it until the simpler interfaces have been exhausted.

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
