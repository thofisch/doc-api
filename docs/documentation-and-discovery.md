## Documentation and Discovery

### ERRORS

Service providers should differentiate between technical and functional errors.

In most cases it's not useful to document technical errors that are not in control of the service provider unless the status code convey application-specific semantics.

Functional errors on the other hand, that convey domain-specific semantics, must be documented and are strongly encouraged to be expressed with Problem types.

### SHOULD:: Provide User Manual Documentation

In addition to the API as OpenAPI Reference Definition, it's good practice to provide an API User Manual documentation to improve client developer experience, especially of engineers that are less experienced in using this API. A helpful API User Manual typically describes the following API aspects:

- API's scope, purpose and use cases
- concrete examples of API usage
- edge cases, error situation details and repair hints
- architecture context and major dependencies - including figures and sequence flows

how to document api’s

- swagger
- for internal developers (readme.md in the repo)

API documentation (https://apihandyman.io/the-data-the-hypermedia-and-the-documentation/)

- Machine readable documentation
    * RAML, Swagger and Blueprint.
    * None of them, for now, handles hypermedia APIs definition.
    * ALPS
- Human readable documentation

Documentation: https://blog.smartbear.com/documentation/the-utopia-of-api-documentation/

For some more or less agreed-upon qualities of good API documentation. It must be:

- adapted for audience — like all good marketing and customer support, perhaps multiple documentation depending on the audience’s needs
- DX-first — made for humans, by humans
- machine-readable
- Google-readable — search engine optimization matters when most people are typing “X API” into Google
- well-organized like a reference guide or table of contents
- entwined with the API itself — dual-screens or opening in new window, allowing users to try something out right away
- not a burden to create
- with pricing and usage policies
- with contact information
- adapted to the learner or user
- riddled with use cases and code examples
- made up of everything you could need to use the API
- paired with a story — why you are doing this to achieve that
- easy to produce, publish and maintain
- adapted to what kind of software is being documented, like SaaS versus platform
- adapted to audience to the people that will use it — end user versus inside your company
- adapted to context — when in the discovery process and how people will use it
- equipped with some sort of way to collect user feedback on how you can further improve it
- easily found, whether within the developer portal or prominently placed on your website

> “If all your APIs are true REST APIs and you always them design them the same way, you lessen the need for documentation. If you write documentation using command and shared structures, templates, and common and shared vocabulary and concepts, they become easier to write, read, understand.”
> 
> Documentation and its subjects are analyzed to check that they are consistent with each other. For example, if you have an API descriptor, the system checks that the API is conforming to that descriptor. This already exists with ReadyAPI from SmartBear. You can take an API descriptor in Swagger, and ReadyAPI will create the basic testing to check that the implementation for the API is correct compared to the API descriptor,”
> 
> remember that Swagger isn’t the final piece of the puzzle. It’ll get down your specs and build the perimeter of your API, but Swagger alone does not make complete API documentation. While formats like Swagger and RAML can automate the raw specification, you can also try a tool like LucyBot, to make Swagger more human-readable.

- An API is only as good as its documentation.
- The docs should be easy to find and publically accessible.
- When the docs are hidden inside a PDF file or require signing in, they're not only difficult to find but also not easy to search.
The docs should show examples of complete request/response cycles. (Pastable examples)
- The documentation must include any deprecation schedules and details surrounding externally visible API updates. Updates should be delivered via a blog (i.e. a changelog) or a mailing list (preferably both!).

When building RESTful web services, you need to address two kinds of discoverability. These are design-time dicoverability and runtime discoverability.
Design-time discoverability helps others design and build clients. It describes all the essentials that client developer teams and administrators need to know in order to build and launch clients.
Runtime discoverability helps maintain loose coupling between clients and severs and enables plung-and-play style automation. Runtime discovery invlolves HTTP's uniforma interface, mean types, links, and link relations. This chapter is about design-time discoverability.

Design-time dicoverability simply mean describing you web service in prose, whether such prove is generated by some tools or created manually by the designers or developers of the web service. Client developers can consult this prose to understand the "semantics" of the resources, media types, link relations, and so on, and implement clients.

The best way to promote design- and development-time dicoverability is to unambiguously document the information needed to implement clients.

Fully describe the following in human-readable documentation:

- All resources and methods supported for each resource.
- Media types and representation formats for resources in requests and responses.
- Each link relation used, its business significance, HTTP method to be used, and resource that the link identifies.
- All fixed URIs that are not supported via links.
- Query parameters used for all fixed URIs.
- URI templates and token substitution rules.
- Authenticaton and security credentials for accessing resources.

For XML representations, if your clients and servers are capable of supporting XML schemas, use a schema language as a "convention" to describe the structure of XML documents used for representation un requests and responses. For other formats, use conventions to describe representations in prose.

No machine-readable description can replace human-readable documentation. Documenting your web service in human-readble format such as HTML is the most useful way to enable design-time dicovery. When documenting your service, include all the information necessary to implement a client.




