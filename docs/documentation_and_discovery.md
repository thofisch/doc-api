## 14. Documentation and Discovery

    <!-- TODO -->

    ### SHOULD:: Provide User Manual Documentation

    In addition to the API as OpenAPI Reference Definition, it's good practice to provide an API User Manual documentation to improve client developer experience, especially of engineers that are less experienced in using this API. A helpful API User Manual typically describes the following API aspects:

    - API's scope, purpose and use cases
    - concrete examples of API usage
    - edge cases, error situation details and repair hints
    - architecture context and major dependencies - including figures and sequence flows

    <!--
    how to document api’s
    swagger
    for internal developers (readme.md in the repo)

    API documentation (https://apihandyman.io/the-data-the-hypermedia-and-the-documentation/)
        Machine readable documentation
            RAML, Swagger and Blueprint.
            None of them, for now, handles hypermedia APIs definition.
            ALPS
        Human readable documentation

    Documentation: https://blog.smartbear.com/documentation/the-utopia-of-api-documentation/

    For some more or less agreed-upon qualities of good API documentation. It must be:

    adapted for audience — like all good marketing and customer support, perhaps multiple documentation depending on the audience’s needs
    DX-first — made for humans, by humans
    machine-readable
    Google-readable — search engine optimization matters when most people are typing “X API” into Google
    well-organized like a reference guide or table of contents
    entwined with the API itself — dual-screens or opening in new window, allowing users to try something out right away
    not a burden to create
    with pricing and usage policies
    with contact information
    adapted to the learner or user
    riddled with use cases and code examples
    made up of everything you could need to use the API
    paired with a story — why you are doing this to achieve that
    easy to produce, publish and maintain
    adapted to what kind of software is being documented, like SaaS versus platform
    adapted to audience to the people that will use it — end user versus inside your company
    adapted to context — when in the discovery process and how people will use it
    equipped with some sort of way to collect user feedback on how you can further improve it
    easily found, whether within the developer portal or prominently placed on your website

        “If all your APIs are true REST APIs and you always them design them the same way, you lessen the need for documentation. If you write documentation using command and shared structures, templates, and common and shared vocabulary and concepts, they become easier to write, read, understand.”

    Documentation and its subjects are analyzed to check that they are consistent with each other. For example, if you have an API descriptor, the system checks that the API is conforming to that descriptor. This already exists with ReadyAPI from SmartBear. You can take an API descriptor in Swagger, and ReadyAPI will create the basic testing to check that the implementation for the API is correct compared to the API descriptor,”

        remember that Swagger isn’t the final piece of the puzzle. It’ll get down your specs and build the perimeter of your API, but Swagger alone does not make complete API documentation. While formats like Swagger and RAML can automate the raw specification, you can also try a tool like LucyBot, to make Swagger more human-readable.


    - An API is only as good as its documentation.
    - The docs should be easy to find and publically accessible.
    - When the docs are hidden inside a PDF file or require signing in, they're not only difficult to find but also not easy to search.
    The docs should show examples of complete request/response cycles. (Pastable examples)
    - The documentation must include any deprecation schedules and details surrounding externally visible API updates. Updates should be delivered via a blog (i.e. a changelog) or a mailing list (preferably both!).


    -->

    - 14.1. How to Document RESTful Web Services
    - 14.2. How to use `OPTIONS`

