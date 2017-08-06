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
