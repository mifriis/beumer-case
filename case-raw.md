# Secure and Reliable Logistics

Beumer has delivered logistics across the world for decades. Be it airports, packaging or airfreight.

The setup so far has relied on software fit for purpose at time of purchase

Software afterwards forked by the customer to match onsite requirements for logging, interoperability, hosting and features.

This has lead to a difficult split from the main trunk of code causing updates, upgrades and patches to become very expensive. Inscentivising not upgrading and instead building security moats around software.

But increasingly so, we are seeing vulnerbilities as a predictable, recurring event. One where an unpatched system is just a bad firewall configuration or moat vulnerbility away from being entirely open to hostile agents.

## Vulnerbilities is the new normal

Every week new vulnerbilities are discovered, patched or exploited. Failing to patch doesnt just put software into a vulnerable state, it begins to compound vulnerbility interest. Last weeks unpatched vulnerbilities just get compunded with 10 new next week. It's entirely likely that a system unpatched for a year can have 500 vulnerbilities or more, with further impact as years are added on top.

<Insert Illustration of compounding vulnerbilities>

Since 2024 all software sold by or on the European market are required to be supported, maintained and with a cyber security strategy for keeping the software resilient. This is captured in the EU Cyber Resilliance act of 2024:
* 2026 - Notification of Conformity starts and manufacturers must report severe incidents and active exploits in their software
* 2027 - Full application of the act sets in and new software must include an active cyber security stategy for 5 years after acquisition

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

A typical usecase of different sites is to have monitoring, logging and surveillance tools that encompass more systems than the one our software is part of. 

By supporting container sidecars we can ensure logs and data is available to a broad variety of tools. 

For companies that dont have their own sidecar, we can deliver one with the software.

<expand illustration with a sidecar>

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

Instead of just relying on HTTP and events for interface, we can also expose our softwares interfaces as an SDK. This lets the sites build their software on the same principles as with the APIs where they are decoupled from our itnernal functionality.

This is the most difficult practice of the three though for us. This shifts our software from being a self-contained container, to being a library in someone elses.

It shifts the responsbility towards the customer where they are now entirely responsible for Layer 1 (operating system) and partially on dependencies. We become just another dependecy in their software, that just so happens to pull in dependencies of their own.

<new container with the SDK inside it>

### Outcome

no longer forks, start with sidecar and API
be curious about SDK, but initial priority last


## Support Model

price model change - from flat purchase to monthly subscription
end2end delivery on a weekly basis - even with no new features just a fresh base image and dependency lock

## Architectural Constraints

architectural constraints like not being dependant on software on their side
kubernetes or similar orchstration platform as a requirement to run our software
fitness functions established to meassure how good we are at the new architecture:
* dependency age
* base image age
* concurrent Pull Requests open
* pull request age
* median pull request length
* SAST findings