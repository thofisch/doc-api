# API Design

Any type of design requires taking well-informed decisions, in order to make a better product. API design decisions can be grouped into four categories:

- **Architectural design decisions**. How to gather, structure, format, deliver, secure and protect data. It is also a choice between a RESTful or RPC architectural style. {>>Our focus is REST - should we mention that?<<}
- **API Frontend Design Decisions** is about what is visible to the API consumers. This is quite important for the success of an API, and what most of these guidelines are about, and especially this page.
- **API Backend Design Decisions**. How to leverage backend systems regarding e.g., integration, transformation, aggregation and security.
- **Non-functional Design Decisions**. Topics such as security, performance, availability, and evolvability should not be an afterthought.

!!! note "What is the difference between API Design and API Architecture?"
    API architecture may refer to the architecture of the complete solution, consisting not only of the API itself.

    When building, running and exposing not only one, but several APIs, it becomes clear that certain building blocks of the API, runtime functionality and management functionality for the API need to be used over and over again.

    An API platform provides an infrastructure for developing, running and managing APIs.

    The API portfolio contains all APIs of the enterprise and needs to be managed like a product.

    API architecture may refer to the design decisions for a particular API. This is what we usually refer to as API proxy architecture.

    API design is one aspect of API architecture. API architecture has a wider scope, considering also the API solution, API platform and API portfolio.

    the API architecture defines the frame, in which API design can take place and does make sense.

## How? <!--Practical API Design-->

Using the following API design approach provides practical guidelines and explains how to develop an API design into an API implementation that consumers can use:

1. Find out, how the majority of consumers would want to use the new API.
1. Design the API, so it fits into the portfolio of different APIs that the company offers.
1. Choose the architectural style.
1. Design a blueprint of the API using an API description language
    - Design the visible frontend interface
    - Build a prototype of the API and simulate its behavior.
    - Collect feedback on the design, check that the design fulfills the non-functional properties.
    - Based on the feedback adapt and iterate. Iteratively the API design is improved.
    - Use a generative API design approach (the generative techniques are only used as far as possible, at some point some code might still need to be written).

!!! tip
    Investing time and energy in building an API that no one wants is a waste of resources.

    We propose to engage with potential API consumers before and during the design of the API and call the approach Consumer-Oriented API Design.

!!! note "API Consumers"
    They are designed with rigorous customer focus, a deep understanding of the customers and compassion for both the needs and desires of the customers.

    So when creating a great customer experience, you in fact need to create a great developer experience!

    A great developer experience requires an API, that is both functional and well-designed - an API that is easy to use, easy to integrate, well- documented and easy to get started with.

    you actually need to figure out the characteristics of your API customer group for each API you build.

    You want to look at API consumers as a group, never a single API consumer. Why? Because you want to build APIs as products, with a high potential for reuse by many different consumers.

!!! note "Consumer-Oriented APIs"
    Consumers often end up choosing the API that is easy to use, easy to integrate, well-documented and easy to get started with.

    Your API should be as simple, clean, clear and approachable as possible from the perspective of the API consumer.

    This is why it is important to design and evaluate APIs from the perspective of the API consumers.

    They should not be built for a particular API consumer, but for a group of API consumers with similar needs.

## Building Consumer-Oriented APIs

You need to identify the target consumers, and engage with them to get to know their needs and learn about the problems they are trying to solve with the API.

You first need to identify the key consumers of your API.

Ideally you have a pilot group of API consumers that can act as a sounding board

Your goal is to develop a reusable API, that can be used by many consumers in many different scenarios and applications.

it is your task to distinguish between the needs and requirements of a particular consumer and the needs and requirements that the majority of consumers will have.

API consumers like a classical requirements engineering process. Alternatively, you may use more interactive techniques such as design thinking, to uncover hidden needs, to allow for more creativity and to find unexpected solutions.

The starting point for a consumer- centric API is an analysis of what is needed by the consumers.

For the API provider it is thus important to ask: What would the consumer want to achieve by using the API? How can I make it easy for the consumer to find the API? How can I help the consumer to build apps with my API and make it convenient for the consumer to use the API?

## API Design and Development Approach

## Foundations

There are two basic methodological approaches. They are known under the names inside- out approach and outside- in approach,

We propose the outside- in approach because it is consumer- oriented.

The starting point for the inside- out approach is an analysis of what already exists inside the organization of the API provider.

the backend systems already exist

and are used as a basis for defining the API.

an API could be built just by forwarding calls to backends, optionally some data format transformations and some protocol transformations.

Even though building the API may be simple from the perspective of the API provider, it might be quite complex to use the API for the API consumers, since they are confronted with the complex data structures of the backends. Such an API is not likely to be consumer- oriented.

The starting point for the outside- in approach is an analysis of what is needed by the consumers. The consumers are outside the organization of the API provider, thus the API provider needs to start the design process outside her organization.

A measure for the success of an API initiative is the wide- spread use of the API: the API should be used by as many consumers as possible.

It certainly means more work on the side of the API provider, but there is a bigger chance that the consumer gets an API, she actually like to use.

In contract- first design, the central artifact is an explicit contract between API provider and API consumer.

Such a contract is either dictated by the provider– or better– it is specified by provider and consumer together.

In this contract, the API provider guarantees to provide APIs to the consumer, exactly as they were specified in the contract.

Based on this contract, the consumer can already start implementing a solution before having access to the API.

Agility is based on the premise that you can start without having a full set of specs. You can always adapt and change the specs later, as you go and as you have learned more. Through multiple iterations, architectural design can converge to the right solution. If the iterations are performed based on the architectural blueprint and not based on a full implementation, architecture improves the overall efficiency of development.

Before publishing the API, the API can be changed without constraints and the agile approach can be used. Change is easy and possible at any time.

After publishing the API, it becomes more difficult to realize changes.

New versions need to be created for each API change that is not backward compatible.

An agile approach should only be used, until the API is published for the first time. Once the API has been published, changes need to be controlled more strictly and agility is confined to new versions of the API.

Basically every software system has dependencies to other software,

The consequence is sequential development of the components,

Simulations offer a solution: they make it possible to break up the dependencies between software components and allow for integration and development of software components, even though their dependencies have not been developed, yet. Dependencies are replaced by simulations.

In API design there are two use cases for simulations: The simulation of backend systems allows for developing APIs without fully implemented backend systems. The simulation of APIs allows for developing apps (or other API solutions) without fully implemented APIs. Both types of simulations have their place in API design - but in different scenarios.

backends. If the real backend is not available yet, a simulation of the backend can be used in its place.

The development of the API and the development of the mobile app can take place in parallel. The simulation speeds up the development time of the overall API solution,

Simulation- based design of APIs and the contract- first design for APIs actually go hand- in- hand. The contract for the API can be used as a specification for the simulation.

Applying the contract- first ideas to API design, allows for a clear separation of the responsibility between API and client. Applying an agile approach can help to navigate in situations with unclear or vague requirements, but should only be applied until the API is published. Applying ideas of the simulation approach allows for breaking up the dependencies during development. It allows for an independent development of client and API, despite the dependencies between them.

## Design Approach

It is important to collect the feedback as early as possible, when changes to the API are still possible, relatively simple and can be implemented with low risk, low effort and low costs.

Our proposed API design approach is organized in the following six phases: Phase 1: Domain Analysis Phase 2: Architectural Design Phase 3: Prototyping Phase 4: Implementing for Production Phase 5: Publishing Phase 6: Maintenance

The goal of the first phase is to analyze the “problem domain”, identify resources and sketch a simple API description for each resource.

The first step of a domain analysis phase is gaining some clarity on the needs of the consumer and possible usage scenarios.

Start by asking yourself: Who are the consumers of the API? What is the purpose of the API? Which API solutions do the consumers plan to build with the API? Which other API solutions would be possible with the API?

not only the usage scenario at hand, or the obvious usage scenario should be sketched. Ideally, a broad set of usage scenarios for the API should be sketched.

The next step is to build a resource taxonomy for the given usage scenarios. Think from a consumer’s perspective about the usage scenario, try not to have the tinted view of some existing backend structure or existing database tables, since those provide an internal view.

Take on the view of the API consumer.

To create a taxonomy, write down the usage scenario, then select the nouns in the text.

Shortlist the nouns that would make sense as resources, i.e. nouns that describe data objects, which the operations create, read, update or delete can be performed on.

The resources in the taxonomy have states and during the execution of the app, the resources may change their states and transition into new states. Express the states and transitions in a state diagram.

The transitions in the diagram provide an indicator for the HTTP methods that need to be supported.

questions, a first, low- fidelity API prototype should be built.

the API prototype should not be implemented manually, but it should be constructed automatically by generating a simulation based on the API description.

The simplest demo app would be a little bit more than a curl call.

it should be avoided to reinvent the wheel for common APIs. Instead, published or company- specific API templates should be used. APIs should also be designed as a part of the API portfolio, meaning that the designed API should be consistent with the other APIs in the same portfolio.

The demo app created in the previous phase can be reused for integration testing of the simulated API.

There are thus two goals for proper prototyping: practical insights into critical implementation and usability issues and a low effort for the creation of the prototype.

The API prototype should conform to the API description and use real data from real backends.

If the real backends are available, they may be integrated, otherwise a simulation of the backend is used.

input and output need to be validated and security needs to be implemented and configured,

To maximize the learnings from prototyping, one should focus on implementing the aspects, which are most critical.

Pilot consumers need to be API consumers, who are willing to work with unfinished APIs with changing interfaces, broken clients, frequent updates, unavailability and low performance of the API. In short: a pilot customer must be able to bear some pain.

This is why pilot consumers are typically recruited from inside the organization of the API provider, for example from a department of the API provider.

Such a test should include JSON wellformedness checks and JSON schema validation of the results. Both of these tests can be generated from the API description.

Some of the most important non- functional aspects of APIs are security, performance, and availability.

When an API has reached this phase of the approach, the API description has been properly designed, has gone through several feedback loops has been verified from several perspectives. The API description should thus be stable.

the API and its documentation become publicly available, API consumers will start building API clients and start using the API.

Publishing the API also means freezing its interface specification.

After publishing, there is no agility in the development process any longer. Changes on published APIs require a traditional change management process.

For each published API, the API provider has an implicit contract with all its API consumers,

This is why once an API gets published, its interface can never change and the API needs to be maintained for a long time.

Publishing an API requires an appropriate documentation for consumers.

This can be avoided by generating both the implementation skeleton and the documentation from the same single source of truth, from the API description.

To be able to find out if and how this expectation is actually fulfilled by the API, usage of the API has to be monitored, measured and analyzed.

Some of the metrics, which might be interesting in this context are: the total number of API calls per time frame, the number of API calls per consumer, and how many API calls resulted in an error vs in success. Not only quantitative analysis is relevant, but also some qualitative analysis.

Qualitative analysis includes for example understanding and categorizing the solutions, which the API consumers build with the API.

Which of the usage scenarios were correctly predicted and which new usage scenarios evolved?

portfolio. A relevant metric is the number successful API calls, especially if compared to the number of unsuccessful API calls.

The performance and availability metrics such as status reports, up- time and response time should not only be available to the API provider, but also to the API consumers.

The simple rule for API evolution is, that the externally observable behavior of an API (from the perspective of the clients) cannot be changed, once the API has been published.

longevity and stability are important aspects of published APIs.

APIs need to stay backward- (and forward-) compatible, so that old clients do not break and new clients can use the new and improved features.

## 4 API Design with API Description Languages

## What are API Description Languages?

API description languages are domain specific languages, which are especially suited for describing APIs. They are both human readable and machine readable languages,

They are intuitive languages that can be easily written, read and understood by API developers and API designers alike.

API description languages are also precise, leave little room for ambiguity. They are very expressive and powerful. And they have a well- defined syntax, which makes it possible to process them automatically by software.

API description languages use a higher level of abstraction and a declarative paradigm. This means that they can be used to express the “what” instead of the “how”.

## Usage

API description languages can serve as the single source of truth and as the main reference for all aspects of API design and development.

API descriptions also enable the creation of an interactive documentation. Interactive documentation is not only meant to be read like regular documentation, it also includes a testing bed for the APIs.

API consumers can make test calls to the real API or to a simulation of the API directly from the documentation page.

The API description enables contract- first design. Both contracting parties negotiate this contract, decide on it and rely on this contract during the implementation and maintenance phases.

Contract- first design allows starting the implementation of the app by the consumer before the provider has finished building the API.

The API description can be used by the API provider to automatically generate API skeletons. An API skeleton contains some important pieces of the implementation, it is, however, not complete. The skeleton needs to be extended and filled with manual implementation before the API can be used.

When the first iteration of the API implementation is generated from the API description, the API implementation is created from scratch. There is no prior implementation to take care of and the API implementation initially only consists of the API skeleton. A challenge for automated code generation are updates to the API description. If a previous implementation already exists, the newly generated code needs to be merged with the existing code. Depending on the code generation framework, this might be supported by specific code markers, which are used to separate the generated code skeleton from the API implementation.

## OpenAPI/Swagger

Especially the frontend design decisions and architectural design decisions, which are visible to the consumer, can be captured by API description languages.

they can be used for code generation of the API, code generation of the API clients, generation of documentation, generation of tests, and the generation of mocks.

---

{++

## Spec-Driven Development

The overall point of view on API design is to approach API design from the 'outside-in' perspective.

The orientation for APIs is to think about design choices from the application developer's point of view. 

The goal is to make the developers as successful as possible.

The primary design principle when crafting your API should be to maximize developer productivity and success. This is what we call pragmatic REST.

You have to get the design right, because design communicates how something will be used.

The question becomes - what is the design with optimal benefit for the app developer?

The developer point of view is the guiding principle for all the specific tips and best practices we've compiled

We call our point of view in API design "pragmatic REST", because it places the success of the developer over and above any other design principle. The developer is the customer for the Web API.

The success of an API design is measured by how quickly developers can get up to speed and start enjoying success using your API.

### Feedback

One of the quickest ways to get feedback on your API is to define it using a specification language. An API specification language allows for building APIs in a consistent manner, utilizing pattern design and code reuse to help ensure that the APIs remains uniform across the full interface, keeping resources and methods standardized.

- **DO** define Your API in a flexible, but standard specification language (e.g. RAML, Swagger, JSON-API, etc.).

> Be aware that none of the popular specification frameworks support Hypermedia Links (let alone HATEOS). <!-- TODO: link to Jimmy Bogart blog -->

### Code to the Spec... and Don't Deviate

If you have taken advantage of the above steps and carefully laid out your API, carefully designed your spec, user tested, and perfected your API – there is nothing worse than throwing all that work away by deviating from the spec and doing one-off things.

## MUST: Follow API First Principle

As mentioned in the introduction, API First is one of our engineering and architecture principles. In a nutshell API First requires two aspects:

- define APIs outside the code first using a standard specification language get early review feedback from peers and client developers
- By defining APIs outside the code, we want to facilitate early review feedback and also a development discipline that focus service interface design on...
- profound understanding of the domain and required functionality
- generalized business entities / resources, i.e. avoidance of use case specific APIs
- clear separation of WHAT vs. HOW concerns, i.e. abstraction from implementation aspects — APIs should be stable even if we 
    replace complete service implementation including its underlying technology stack
- Moreover, API definitions with standardized specification format also facilitate...
- single source of truth for the API specification; it is a crucial part of a contract between service provider and client users
- infrastructure tooling for API discovery, API GUIs, API documents, automated quality checks

An element of API First are also this API Guidelines and a lightweight API review process [internal link] as to get early review feedback from peers and client developers. Peer review is important for us to get high quality APIs, to enable architectural and design alignment and to supported development of client applications decoupled from service provider engineering life cycle.

It is important to learn, that API First is not in conflict with the agile development principles that we love. Service applications should evolve incrementally — and so its APIs. Of course, our API specification will and should evolve iteratively in different cycles; however, each starting with draft status and early team and peer review feedback. API may change and profit from implementation concerns and automated testing feedback. API evolution during development life cycle may include breaking changes for not yet productive features and as long as we have aligned the changes with the clients. Hence, API First does not mean that you must have 100% domain and requirement understanding and can never produce code before you have defined the complete API and get it confirmed by peer review. On the other hand, API First obviously is in conflict with the bad practice of publishing API definition and asking for peer review after the service integration or even the service productive operation has started. It is crucial to request and get early feedback — as early as possible, but not before the API changes are comprehensive with focus to the next evolution step and have a certain quality (including API Guideline compliance), already confirmed via team internal reviews.

### MUST: Write APIs in U.S. English

The API Guild drafted and owns this document.

The list of status code that can be omitted from API specifications includes but is not limited to:

401 Unauthorized
403 Forbidden
404 Not Found unless it has some additional semantics
405 Method Not Allowed
406 Not Acceptable
408 Request Timeout
413 Payload Too Large
414 URI Too Long
415 Unsupported Media Type
500 Internal Server Error
503 Service Unavailable

### MUST: Provide Online Access to OpenAPI Reference Definition

## MUST: Use REST Maturity Level 2

We strive for a good implementation of REST Maturity Level 2 as it enables us to build resource-oriented APIs that make full use of HTTP verbs and status codes. You can see this expressed by many rules throughout these guidelines, e.g.:

Avoid Actions — Think About Resources
Keep URLs Verb-Free
Use HTTP Methods Correctly
Use Meaningful HTTP Status Codes
Although this is not HATEOAS, it should not prevent you from designing proper link relationships in your APIs as stated in rules below.

### MAY: Use REST Maturity Level 3 - HATEOAS

We do not generally recommend to implement REST Maturity Level 3. HATEOAS comes with additional API complexity without real value in our SOA context where client and server interact via REST APIs and provide complex business functions as part of our e-commerce SaaS platform.

Our major concerns regarding the promised advantages of HATEOAS (see also RESTistential Crisis over Hypermedia APIs, Why I Hate HATEOAS and others):

We follow the API First principle with APIs explicitly defined outside the code with standard specification language. HATEOAS does not really add value for SOA client engineers in terms of API self-descriptiveness: a client engineer finds necessary links and usage description (depending on resource state) in the API reference definition anyway.
Generic HATEOAS clients which need no prior knowledge about APIs and explore API capabilities based on hypermedia information provided, is a theoretical concept that we haven't seen working in practise and does not fit to our SOA set-up. The OpenAPI description format (and tooling based on OpenAPI) doesn't provide sufficient support for HATEOAS either.
In practice relevant HATEOAS approximations (e.g. following specifications like HAL or JSON API) support API navigation by abstracting from URL endpoint and HTTP method aspects via link types. So, Hypermedia does not prevent clients from required manual changes when domain model changes over time.
Hypermedia make sense for humans, less for SOA machine clients. We would expect use cases where it may provide value more likely in the frontend and human facing service domain.
Hypermedia does not prevent API clients to implement shortcuts and directly target resources without 'discovering' them
However, we do not forbid HATEOAS; you could use it, if you checked its limitations and still see clear value for your usage scenario that justifies its additional complexity. If you use HATEOAS please share experience and present your findings in the API Guild [internal link].


## Dog-food your own API

## Chatty APIs

Let's think about how app developers use that API you're designing and dealing with chatty APIs.

Imagine how developers will use your API

When designing your API and resources, try to imagine how developers will use it to say construct a user interface, an iPhone app, or many other apps.

Some API designs become very chatty - meaning just to build a simple UI or app, you have dozens or hundreds of API calls back to the server.

The API team can sometimes decide not to deal with creating a nice, resource-oriented RESTful API, and just fall back to a mode where they create the 3 or 4 Java-style getter and setter methods they know they need to power a particular user interface.

We don't recommend this. You can design a RESTful API and still mitigate the chattiness.

Be complete and RESTful and provide shortcuts

First design your API and its resources according to pragmatic RESTful design principles and then provide shortcuts.

What kind of shortcut? Say you know that 80% of all your apps are going to need some sort of composite response, then build the kind of request that gives them what they need.

Just don't do the latter instead of the former. First design using good pragmatic RESTful principles!

Take advantage of the partial response syntax

The partial response syntax discussed in a previous section can help.

To avoid creating one-off base URLs, you can use the partial response syntax to drill down to dependent and associated resources.

In the case of our dogs API, the dogs have association with owners, who in turn have associations with veterinarians, and so on. Keep nesting the partial response syntax using dot notation to get back just the information you need.

/owners/5678?fields=name,dogs.name

++}

---

{++

## Tools

The demand for flexibility and extensibility has driven the development of APIs and tools alike, and in many regards it has never been easier to create an API than it is today with multitudes of frameworks (such as JAX-RS, Apigility, Django REST Framework, Grape), specs (RAML, Swagger, API Blueprint, IO Docs), and tools (API Designer, API Science, APImatic) available.

++}
