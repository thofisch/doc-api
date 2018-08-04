# API Design

{++

## Building Services API First

API first means that what you are building is an API to be consumed by client applications and services.

Built into every decision you make and every line of code you write is the notion that every functional requirement of your application will be met through the consumption of an API. Even a user interface, be it web or mobile, is really nothing more than a consumer of an API.

By designing your API first, you are able to facilitate discussion with your stakeholders (your internal team, customers, or possibly other teams within your organization who want to consume your API) well before you might have coded yourself past the point of no return. This collaboration then allows you to build user stories, mock your API, and generate documentation that can be used to further socialize the intent and functionality of the service you’re building.

All of this can be done to vet (and test!) your direction and plans without investing too much in the plumbing that supports a given API.

These days, you’ll find that there are myriad tools and standards to support API-first development. There is a standard format for API specification that uses a markdown-like syntax called API Blueprint. This format is far more human readable than JSON (or WSDL, a relic that belongs in a museum) and can be used by code to generate documentation and even server mocks, which are invaluable in testing service ecosystems. Tool suites like Apiary provide things like GitHub integration and server mocks. If someone wants to build a client to your API, all you have to do is give her a link to your application on Apiary, where she can read your API Blueprint, see example code for consuming your service, and even execute requests against a running server mock.

In other words, there is absolutely no excuse for claiming that API first is a difficult or unsupported path. This is a pattern that can be applied to noncloud software development, but it is particularly well suited to cloud development in its ability to allow rapid prototyping, support a services ecosystem, and facilitate the automated deployment testing and continuous delivery pipelines that are some of the hallmarks of modern {==cloud-native/Kubernetes/"cloud-friendly"==} application development.

This pattern is an extension of the contract-first development pattern, where developers concentrate on building the edges or seams of their application first. With the integration points tested continuously via CI servers,[^2] teams can work on their own services and still maintain reasonable assurance that everything will work together properly.

API first frees organizations from the waterfall, deliberately engineered system that follows a preplanned orchestration pattern, and allows products to evolve into organic, self-organizing ecosystems that can grow to handle new and unforeseen demands.

If you’ve built a monolith, or even an ecosystem of monoliths, that all interact in tightly coupled ways, then your ability to adapt to new needs or create new consumers of existing functionality is hindered. On the other hand, if you adopt the mentality that all applications are just backing services (more on those later in the book), and that they should be designed API-first, then your system is free to grow, adapt to new load and demand, and accommodate new consumers of existing services without having to stop the world to re-architect yet another closed system.

Live, eat, and breathe the API-first[^3] lifestyle, and your investment will pay off exponentially.

[^1]: A traditional dependency graph looks very hierarchical, where A relies on B, which relies on C. In modern service ecosystems, the graphs are much flatter and often far more complicated.
[^2]: Continuous integration servers can be used to exercise public APIs and integrations between multiple services. Examples of CI servers include Jenkins, Team City, and Wercker.
[^3]: Check out ProgrammableWeb and API First, as well as the documentation at Apiary and API Blueprint, for more details on the API-first lifestyle.

++}


* The overall point of view on API design is to approach API design from the 'outside-in' perspective.
* The orientation for APIs is to think about design choices from the application developer's point of view. 
* The goal is to make the developers as successful as possible.
* The primary design principle when crafting your API should be to maximize developer productivity and success. This is what we call pragmatic REST.
* You have to get the design right, because design communicates how something will be used.
* The question becomes - what is the design with optimal benefit for the app developer?
* The developer point of view is the guiding principle for all the specific tips and best practices we've compiled
* We call our point of view in API design "pragmatic REST", because it places the success of the developer over and above any other design principle. The developer is the customer for the Web API.
* The success of an API design is measured by how quickly developers can get up to speed and start enjoying success using your API.

Any type of design requires taking well-informed decisions, in order to make a better product. API design is no different. Generally API design decisions can be grouped into four categories:

- **Architectural design decisions**. How to gather, structure, format, deliver, secure and protect data. It is also a choice between a RESTful or RPC architectural style. {>>Our focus is REST - should we mention that?<<}
- **API Frontend Design Decisions** is about what is visible to the API consumers. This is quite important for the success of an API, and what most of these guidelines are about, and especially this page.
- **API Backend Design Decisions**. How to leverage backend systems regarding e.g., integration, transformation, aggregation and security.
- **Non-functional Design Decisions**. Topics such as security, performance, availability, and evolvability should not be an afterthought.

## Architectural Design Decisions

- **DO** use [Richardson Maturity Model](rest/#richardson-maturity-model) Level 2. Strive for a good implementation of Level 2 as it enables building resource-oriented APIs that make full use of HTTP verbs and status codes. Although this is not HATEOAS, it should not prevent you from designing proper link relationships in your APIs.

!!! note "What is the difference between API Design and API Architecture?"
    * API architecture may refer to the architecture of the complete solution, consisting not only of the API itself.
    * When building, running and exposing not only one, but several APIs, it becomes clear that certain building blocks of the API, runtime functionality and management functionality for the API need to be used over and over again.
    * An API platform provides an infrastructure for developing, running and managing APIs.
    * The API portfolio contains all APIs of the enterprise and needs to be managed like a product.
    * API architecture may refer to the design decisions for a particular API. This is what we usually refer to as API proxy architecture.
    * API design is one aspect of API architecture. API architecture has a wider scope, considering also the API solution, API platform and API portfolio.
    * the API architecture defines the frame, in which API design can take place and does make sense.

## API Frontend Design Decisions

Remember API Frontend Design Decisions will be based on the Architectural design decisions. Using the following overall API design guidelines provides a practical way to develop a RESTful API:

- **DO** do build a [Consumer-Oriented API](#consumer-oriented-apis) by finding out, how the majority of consumers would want to use the new API.
- **DO** use a [Contract-First](#contract-first) approach when designing a new API.
- **DO** design the API, so it fits into the API portfolio.
- **DO** choose REST as the architectural style (for this guide to make sense).
- **DO** design a blueprint of the API using an [API description language](#api-description-languages).

### Consumer-Oriented APIs

Investing time and energy in building an API that no one wants is a waste of resources. Therefore, engage with potential API consumers before and during the design of the API.

- **DO** identify the target consumers, and engage with them to get to know their needs and learn about the problems they are trying to solve with the API. Ideally you have a pilot group of API consumers that can act as a sounding board.
- **DO** aim to develop a reusable API that can be used by many consumers in many different scenarios and applications. Distinguish between the needs and requirements of a particular consumer and the needs and requirements that the majority of consumers will have.
- **DO** start by analyzing what is needed by the consumers. What would the consumer want to achieve by using the API? How can I make it easy for the consumer to find the API? How can I help the consumer to build apps with my API and make it convenient for the consumer to use the API?
- **DO** use the outside-in approach by analysing what is needed by the consumers. If the consumers are outside the organization, the design process needs to start outside organization. It certainly means more work on the side of the API provider, but there is a bigger chance that the consumer gets an API, she actually like to use.
- **DO** collect the feedback as early as possible, when changes to the API are still possible, relatively simple and can be implemented with low risk, low effort and low costs.
- **CONSIDER** using a classical requirements engineering process. 
- **CONSIDER** using more interactive techniques such as workshops or design thinking, to quickly uncover hidden needs, to allow for more creativity and to find unexpected solutions.

!!! note "Outside-in vs. inside-out"
    There are two basic approaches for API design:

    * **Inside-out**, where the starting point is using already existing backend systems as a basis for defining the API. An API could be built just by forwarding calls to backends, even though building the API may be simple from the perspective of the API provider, it might be quite complex to use the API for the API consumers, since they are confronted with the complex data structures of the backends.
    * **Outside-in** is the opposite where you start with the contract and where the consumers are in focus. **This is the approach we recommend**.

### Contract-First

Using a contract-first approach to API design, allows for a clear separation of the responsibility between API and client.

- **DO** create a central artifact as an explicit contract between API provider and API consumer.
- **DO** use a contract to provide guarantees to the API consumer, exactly as they were specified in the contract.
- **DO** use an API description language to create a contract.
- **DO** use these guidelines and a lightweight API review process to get early review feedback from peers and client developers. Peer review is important to get high quality APIs, to enable architectural and design alignment and to supported development of client applications decoupled from service provider engineering life cycle.

### Agile Process

It is important to know that contract-first is not in conflict with the agile development principles. Contract-first does not mean that you must have complete domain and requirement understanding, and an agile approach can help to navigate in situations with unclear or vague requirements.

- **DO** use an agile approach until the API is published for the first time. 
- **DO** allow for breaking changes, of not yet published features, during the contract development life cycle.

!!! warning
    Once an API has been published, changes need to be controlled more strictly and agility is confined to new versions of the API.

    New versions may need to be created for each API change that is not backward compatible. See [Versioning and extensibility](versioning-and-extensibility) for more info.

### Design Approach

The API design approach can be organized in the following phases:

* [Analysis](#analysis)
* [Prototyping](#prototyping)
* [Implementation](#implementation)
* [Publishing](#publishing)
* [Maintenance](#maintenance)

#### Analysis

* The goal of the first phase is to analyze the “problem domain”, identify resources and sketch a simple API description for each resource. The first step of a domain analysis phase is gaining some clarity on the needs of the consumer and possible usage scenarios. Start by asking yourself: Who are the consumers of the API? What is the purpose of the API? Which API solutions do the consumers plan to build with the API? Which other API solutions would be possible with the API? not only the usage scenario at hand, or the obvious usage scenario should be sketched. Ideally, a broad set of usage scenarios for the API should be sketched.

* The next step is to build a resource taxonomy for the given usage scenarios. Think from a consumer’s perspective about the usage scenario, try not to have the tinted view of some existing backend structure or existing database tables, since those provide an internal view. To create a taxonomy, write down the usage scenario, then select the nouns in the text. Shortlist the nouns that would make sense as resources, i.e. nouns that describe data objects, which the operations create, read, update or delete can be performed on.

* The resources in the taxonomy have states and during the execution of the app, the resources may change their states and transition into new states. Express the states and transitions in a state diagram. The transitions in the diagram provide an indicator for the HTTP methods that need to be supported.

* questions, a first, low-fidelity API prototype should be built. the API prototype should not be implemented manually, but it should be constructed automatically by generating a simulation based on the API description.
* it should be avoided to reinvent the wheel for common APIs. Instead, published or company-specific API templates should be used. APIs should also be designed as a part of the API portfolio, meaning that the designed API should be consistent with the other APIs in the same portfolio.

* The simplest demo app would be a little bit more than a curl call.

* The demo app created in the previous phase can be reused for integration testing of the simulated API.

#### Prototyping

* There are thus two goals for proper prototyping:
    * practical insights into critical implementation
    * and usability issues and a low effort for the creation of the prototype.
- **DO** let the API prototype should conform to the API description
- **DO** use real data from real backends, if possible.

* If the real backends are available, they may be integrated, otherwise a simulation of the backend is used.
* input and output need to be validated and security needs to be implemented and configured,
* To maximize the learnings from prototyping, one should focus on implementing the aspects, which are most critical.
* Pilot consumers need to be API consumers, who are willing to work with unfinished APIs with changing interfaces, broken clients, frequent updates, unavailability and low performance of the API. In short: a pilot customer must be able to bear some pain.
* This is why pilot consumers are typically recruited from inside the organization of the API provider, for example from a department of the API provider.
* Such a test should include JSON wellformedness checks and JSON schema validation of the results. Both of these tests can be generated from the API description.

#### Implementation

* When an API has reached this phase of the approach, the API description has been properly designed, has gone through several feedback loops has been verified from several perspectives. The API description should thus be stable.

#### Publishing

* the API and its documentation become publicly available, API consumers will start building API clients and start using the API.
* Publishing the API also means freezing its interface specification.
* After publishing, there is no agility in the development process any longer. Changes on published APIs require a traditional change management process.
* For each published API, the API provider has an implicit contract with all its API consumers,
* This is why once an API gets published, its interface can never change and the API needs to be maintained for a long time.
* Publishing an API requires an appropriate documentation for consumers.
* This can be avoided by generating both the implementation skeleton and the documentation from the same single source of truth, from the API description.
* To be able to find out if and how this expectation is actually fulfilled by the API, usage of the API has to be monitored, measured and analyzed.
* Some of the metrics, which might be interesting in this context are: the total number of API calls per time frame, the number of API calls per consumer, and how many API calls resulted in an error vs in success. Not only quantitative analysis is relevant, but also some qualitative analysis.
* Qualitative analysis includes for example understanding and categorizing the solutions, which the API consumers build with the API.
* Which of the usage scenarios were correctly predicted and which new usage scenarios evolved?
* portfolio. A relevant metric is the number successful API calls, especially if compared to the number of unsuccessful API calls.
* The performance and availability metrics such as status reports, up-time and response time should not only be available to the API provider, but also to the API consumers.

####  Maintenance

* The simple rule for API evolution is, that the externally observable behavior of an API (from the perspective of the clients) cannot be changed, once the API has been published.
* longevity and stability are important aspects of published APIs.
* APIs need to stay backward- (and forward-) compatible, so that old clients do not break and new clients can use the new and improved features.

## API Description Languages

1. Design a blueprint of the API using an API description language

    - Design the visible frontend interface
    - Build a prototype of the API and simulate its behavior.
    - Collect feedback on the design, check that the design fulfills the non-functional properties.
    - Based on the feedback adapt and iterate. Iteratively the API design is improved.
    - Use a generative API design approach (the generative techniques are only used as far as possible, at some point some code might still need to be written).

* One of the quickest ways to get feedback on your API is to define it using a specification language. An API specification language allows for building APIs in a consistent manner, utilizing pattern design and code reuse to help ensure that the APIs remains uniform across the full interface, keeping resources and methods standardized.
* API description languages are domain specific languages, which are especially suited for describing APIs. They are both human readable and machine readable languages,
* They are intuitive languages that can be easily written, read and understood by API developers and API designers alike.
* API description languages are also precise, leave little room for ambiguity. They are very expressive and powerful. And they have a well-defined syntax, which makes it possible to process them automatically by software.
* API description languages use a higher level of abstraction and a declarative paradigm. This means that they can be used to express the “what” instead of the “how”.
* Be aware that none of the popular specification frameworks support Hypermedia Links (let alone HATEOS).
* API description languages can serve as the single source of truth and as the main reference for all aspects of API design and development.
* API descriptions also enable the creation of an interactive documentation. Interactive documentation is not only meant to be read like regular documentation, it also includes a testing bed for the APIs.
* API consumers can make test calls to the real API or to a simulation of the API directly from the documentation page.
* The API description can be used by the API provider to automatically generate API skeletons. An API skeleton contains some important pieces of the implementation, it is, however, not complete. The skeleton needs to be extended and filled with manual implementation before the API can be used.
* When the first iteration of the API implementation is generated from the API description, the API implementation is created from scratch. There is no prior implementation to take care of and the API implementation initially only consists of the API skeleton. A challenge for automated code generation are updates to the API description. If a previous implementation already exists, the newly generated code needs to be merged with the existing code. Depending on the code generation framework, this might be supported by specific code markers, which are used to separate the generated code skeleton from the API implementation.

##### OpenAPI/Swagger

* Especially the frontend design decisions and architectural design decisions, which are visible to the consumer, can be captured by API description languages.
* they can be used for code generation of the API, code generation of the API clients, generation of documentation, generation of tests, and the generation of mocks.

- **DO** define Your API in a flexible, but standard specification language (e.g. RAML, Swagger, JSON-API, etc.).
- **DO NOT** not Code to the Spec... and Don't Deviate. If you have taken advantage of the above steps and carefully laid out your API, carefully designed your spec, user tested, and perfected your API – there is nothing worse than throwing all that work away by deviating from the spec and doing one-off things.
- **DO** Follow API First Principle.
- **DO** define APIs outside the code first using a standard specification language. By defining APIs outside the code, we want to facilitate early review feedback and also a development discipline that focus service interface design on a profound understanding of the domain and required functionality
- **DO** get early review feedback from peers and client 
- **DO** generalize business entities / resources, i.e. avoidance of use case specific APIs
- **DO** a clear separation of WHAT vs. HOW concerns, i.e. abstraction from implementation aspects — APIs should be stable even if we replace complete service implementation including its underlying technology stack
- Moreover, API definitions with standardized specification format also facilitate...
- **DO** use a single source of truth for the API specification; it is a crucial part of a contract between service provider and client users
- **DO** infrastructure tooling for API discovery, API GUIs, API documents, automated quality checks
- **DO** write APIs in U.S. English.
- **CONSIDER** omitting further description of the following status codes from API specifications (includes but is not limited to):
    - `401 Unauthorized`
    - `403 Forbidden`
    - `404 Not Found` unless it has some additional semantics
    - `405 Method Not Allowed`
    - `406 Not Acceptable`
    - `408 Request Timeout`
    - `413 Payload Too Large`
    - `414 URI Too Long`
    - `415 Unsupported Media Type`
    - `500 Internal Server Error`
    - `503 Service Unavailable`
    
    As they are generally self explanatory.

- **DO** Provide Online Access to OpenAPI Reference Definition
- **DO** Dog-food your own API

- **AVOID** Chatty APIs. Some API designs become very chatty - meaning just to build a simple UI or app, you have dozens or hundreds of API calls back to the server. The API team can sometimes decide not to deal with creating a nice, resource-oriented RESTful API, and just fall back to a mode where they create the 3 or 4 Java-style getter and setter methods they know they need to power a particular user interface. We don't recommend this. You can design a RESTful API and still mitigate the chattiness. Be complete and RESTful and provide shortcuts. First design your API and its resources according to pragmatic RESTful design principles and then provide shortcuts. What kind of shortcut? Say you know that 80% of all your apps are going to need some sort of composite response, then build the kind of request that gives them what they need. Take advantage of the partial response syntax.

## API Backend Design Decisions

It is beyond the scope of these guidelines to go into details about API backend design decision, however, the following high-level advice should be taken into account:

- **CONSIDER** mocking backends when developing APIs, if the real backend is not available yet, a critical production system, etc. See [Mocking](mocking) for further details.
- **AVOID** letting the API Backend Design Decisions influence too heavily the API Frontend Design Decisions.

## Non-functional Design Decisions

* Some of the most important non-functional aspects of APIs are security, performance, and availability.

{++

## Tools

The demand for flexibility and extensibility has driven the development of APIs and tools alike, and in many regards it has never been easier to create an API than it is today with multitudes of frameworks (such as JAX-RS, Apigility, Django REST Framework, Grape), specs (RAML, Swagger, API Blueprint, IO Docs), and tools (API Designer, API Science, APImatic) available.

## MAY: Use REST Maturity Level 3 - HATEOAS

We do not generally recommend to implement REST Maturity Level 3. HATEOAS comes with additional API complexity without real value in our SOA context where client and server interact via REST APIs and provide complex business functions as part of our e-commerce SaaS platform.

Our major concerns regarding the promised advantages of HATEOAS (see also RESTistential Crisis over Hypermedia APIs, Why I Hate HATEOAS and others):

We follow the API First principle with APIs explicitly defined outside the code with standard specification language. HATEOAS does not really add value for SOA client engineers in terms of API self-descriptiveness: a client engineer finds necessary links and usage description (depending on resource state) in the API reference definition anyway.
Generic HATEOAS clients which need no prior knowledge about APIs and explore API capabilities based on hypermedia information provided, is a theoretical concept that we haven't seen working in practise and does not fit to our SOA set-up. The OpenAPI description format (and tooling based on OpenAPI) doesn't provide sufficient support for HATEOAS either.
In practice relevant HATEOAS approximations (e.g. following specifications like HAL or JSON API) support API navigation by abstracting from URL endpoint and HTTP method aspects via link types. So, Hypermedia does not prevent clients from required manual changes when domain model changes over time.
Hypermedia make sense for humans, less for SOA machine clients. We would expect use cases where it may provide value more likely in the frontend and human facing service domain.
Hypermedia does not prevent API clients to implement shortcuts and directly target resources without 'discovering' them
However, we do not forbid HATEOAS; you could use it, if you checked its limitations and still see clear value for your usage scenario that justifies its additional complexity. If you use HATEOAS please share experience and present your findings in the API Guild [internal link].

++}
