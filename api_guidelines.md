# API Guidelines

When we refer to an API, we are referring to a web API, more specifically one delivered over HTTP, and as a term, specifies how software should interact. An API specifies how a client can use a public API exposed by a server. What URIs are available, what HTTP methods may be used, what query string parameters it accepts, what data can be sent, and what responses to expect.

Web APIs can typically be broken into two broad categories: *RPC* and *REST*.

> RPC (Remote Procedure Call)
> RPC (e.g., XML-RPC, SOAP, etc.) is generally a poor fit for most web API implementations, as they usually require special purpose libraries or SDKs to work properly. A requirement that a lot of clients cannot meat without a lot of extra work and/or clunky third-party libraries. This, and the fact that most RPC implementations do not use HTTP to its full extend, has let us to **not include RPC in any further discussions**. However, if all of your clients are using legacy systems that depend on SOAP libraries, it may make more sense in that case to build a SOAP API for them. A lot of documentation, best practices and general advise on how to build RPC APIs can be found throughout the web.

We will focus our discussion on REST (REpresentational State Transfer). Especially on how to achieve a more RESTful web API, by leveraging the capabilities of HTTP. For more information about REST itself, please refer to the [Wikipedia article on REST](http://en.wikipedia.org/wiki/Representational_state_transfer) or [WhatIsREST](<http://whatisrest.com>).

Some of the aspects of designing RESTful web APIs include:

- *Unique identification* of resources by using URIs.
- Operation on resources by using the available *HTTP methods*.
- The choice of *media types and formats* that gives clients the ability to specify what representation formats they can render, and for the server to honor those (or indicate if it cannot).
- *Linking* between resources to indicate relationships (e.g., hypermedia links).

Today, most web APIs are not truly REST APIs, instead they tend a varying degree of RESTfulness. Therefore, the [Richardson Maturity Model](http://martinfowler.com/articles/richardsonMaturityModel.html) is often used to describe what it takes to make a well-designed REST API. The higher the level, the more useful:

- Level 0: Uses HTTP as a transport mechanism for RPC, as mentioned above.
- Level 1: Uses URIs for individual resources, but does not use HTTP methods, media types, or linking between resources.
- Level 2: Uses HTTP methods and headers for interactions with resources, and returns appropriate HTTP status codes.
- Level 3: Uses hypermedia controls for discoverability, providing a way of making an API more self-documenting.

So a good REST API should:

- Use unique URIs to expose resources for clients to use.
- Leverage the full spectrum of HTTP, to perform operations on those resources, and allow varying representations of content, enabling HTTP-level caching, etc.
- Provide relational links for resources, to inform the client what can be done next.

Here we will try to offer advise on how to achieve these goals, both in regards to implementing clients as well as servers. Specifically we will focus on:

- How to identify resources by using URIs
- How to use the available HTTP methods
- What representation formats to you expose and what to do when the server cannot fulfill a request for a given representation
- How to report errors, using HTTP status codes and representations
- How to handle security, including HTTP authentication, OAuth2, and API tokens
- How to handle hypermedia linking
- How to document your API
- And more... <!-- TODO -->

But before jumping straight into designing an API, here are some key questions to think about:

- Who is the target audience for the API (customers, third-party services, or even developers looking to extend upon your services for their own customers)?
- What are the use cases for integrating with the API?
- What technologies will the client use to integrate with the API?
- Which products/services to expose? 
- What other services should the API interact with?

<!-- TODO -->

    # Intro

    The software architecture centers around decoupled microservices that provide functionality via RESTful APIs.

    Small teams own, deploy and operate these microservices.

    Our APIs most purely express what our systems do, and are therefore highly valuable business assets.

    Designing high-quality, long-lasting APIs has become even more critical for us since we started developing our new open platform strategy, ~~which transforms Zalando from an online shop into an expansive fashion platform~~.

    Our strategy emphasizes developing lots of public APIs for our external business partners to use via third-party applications.

    Adopted "API First" as one of our key engineering principles.

    Development begins with API definition outside the code and ideally involves ample peer-review feedback to achieve high-quality APIs.

    API First encompasses a set of quality-related standards and fosters a peer review culture including a lightweight review procedure. We encourage our teams to follow them to ensure that our APIs:

    - are easy to understand and learn
    - are general and abstracted from specific implementation and use cases
    - are robust and easy to use
    - have a common look and feel
    - follow a consistent RESTful style and syntax
    - are consistent with other APIs and our global architecture

    Ideally, all APIs will look like the same author created them.

    The purpose of our "RESTful API guidelines" is to define standards to successfully establish "consistent API look and feel" quality.~

    The API Guild drafted and owns this document.

    Teams are responsible to fulfill these guidelines during API development and are encouraged to contribute to guideline evolution via pull requests.

    These guidelines will, to some extent, remain work in progress as our work evolves, but teams can confidently follow and trust them.

    In case guidelines are changing, following rules apply:

    - existing APIs don't have to be changed, but we recommend it
    - clients of existing APIs have to cope with these APIs based on outdated rules
    - new APIs have to respect the current guidelines
    - Furthermore you should keep in mind that once an API becomes public externally available, it has to be re-reviewed and changed according to current guidelines - for sake of overall consistency.

    ## Conventions Used in These Guidelines

    ~~The requirement level keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" used in this document (case insensitive) are to be interpreted as described in RFC 2119.~~

    ## API as a Product

    We want to deliver products to our (internal and external) customers which can be consumed like a service.

    Platform products provide their functionality via (public) APIs; hence, the design of our APIs should be based on the API as a Product principle:

    - Treat your API as product and understand the needs of its customers
    - Take ownership and advocate for the customer and continuous improvement
    - Emphasize easy understanding, discovery and usage of APIs; design APIs irresistible for client engineers
    - Actively improve and maintain API consistency over the long term
    - Make use of customer feedback and provide service level support
    - RESTful API as a Product makes the difference between enterprise integration business and agile, innovative product service business built on a platform of APIs.

    Based on your concrete customer use cases, you should carefully check the trade-offs of API design variants and avoid short-term server side implementation optimizations at the expense of unnecessary client side obligations and have a high attention on API quality and client developer experience.

    API as a Product is closely related to our API First principle (see next chapter) which is more focused on how we engineer high quality APIs.

    ## API Design Principles

    REST is centered around business (data) entities exposed as resources that are identified via URIs and can be manipulated via standardized CRUD-like methods using different representations, self-descriptive messages and hypermedia.

    RESTful APIs tend to be less use-case specific and comes with less rigid client / server coupling and are more suitable as a platform interface being open for diverse client applications.

    - We prefer REST-based APIs with JSON payloads
    - We prefer systems to be truly RESTful
    - We apply the RESTful web service principles to all kind of application components, whether they provide functionality via the Internet or via the intranet as larger application elements. We strive to build interoperating distributed systems that different teams can evolve in parallel.

    An important principle for (RESTful) API design and usage is Postel's Law, aka the Robustness Principle (RFC 1122):

    Be liberal in what you accept, be conservative in what you send

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

## HTTP as the Uniform Interface

Before diving into the specific areas of designing a RESTful API, it is important to recognize that one of the key goals of the REST architecture is to maintain visibility. This will let the API benefit from existing software and infrastructure for features that would otherwise have to built as well.

HTTP is an application-level protocol that is designed to keep interactions between clients and servers visible. HTTP defines operations (along with, e.g., headers), such as `GET`, `POST`, `PUT` and `DELETE`, for transferring representations between clients and servers, eliminating the need for application-specific operations (e.g. *createBooking*, *changeBooking*, etc.). This means that caches, proxies, firewalls, etc., can monitor and participate in the protocol.

> Visibility means that one component of an architecture can monitor (and even participate in) the interaction between other components of the same architecture

For better visibility:

- **DO** make interactions stateless.
- **DO** use HTTP methods.
- **DO** use appropriate headers to describe requests and responses.
- **DO** use appropriate status codes and messages.
- **DO NOT** change syntax and meaning, specified by HTTP, from application to application or from resource to resource.

Keep in mind that focusing solely on visibility may create too fine-grained resources and poor separation of concern between clients and servers. Trading visibility for other benefits is not necessarily bad.

Consider trading visibility:

- when multiple resources share data
- when operations modifies multiple resources
- for better abstraction and loose coupling
- for network efficiency
- for better resource granularity
- or simply for pure client convenience



## Resource Identifiers (URIs)

    <!-- TODO -->
    <!-- *url regression* -->

URIs should be treated as opaque resource identifiers.

Basically, this means that clients should not be concerned with how a server designs its URIs, nor should it try to pick apart URIs in order to work out information from them. Instead URIs should be discovered through links (and the submission of forms). For instance, clients must not use the fact that a URI ends with the `.xml` extension to infer that it resolves to an XML representation, but must rely on the `Content-Type` header of the response. 

Clients should be able to use server-provided URIs to make additional request without having to understand how the server's URIs are structured, and generally the process of creating URIs belongs to the server, not the client. The opacity of URIs are important and help reduce coupling between servers and clients. This has nothing to do with readability or hackability, both of which are extremely important for human users.

- *Readable URIs* help users understand something about the resource that the URI is pointing to. 
- *Hackable URIs* (manipulated by altering/removing portions of the path or query) enable human users to locate other resources that they might be interested in.

### Designing URIs

- **DO** design URIs to last a long time - [Cool URIs don't change](<http://www.w3.org/Provider/Style/URI>).
- **DO** design URIs based on stable concepts, identifiers, and information.
- **DO** use domains and subdomains to logically group or partition resources for localization, distribution, or to enforce various monitoring or security policies.
- **DO** use forward-slash (`/`) in the path segment to indicate a hierarchical relationship between resources.
- **DO** use the hyphen (`-`) and underscore (`_`) characters to improve the readability of long path segments. Pick one or the other for consistency.
- **DO** use ampersand (`&`) to separate query parameters.
- **DO** use the URI only to determine which resource should process a request.
- **DO** provide URIs at runtime using links in the body of representations or headers, whenever possible.
- **DO** use rewrite rules on the server to shield clients from implementation-level changes.
- **DO** use `301 Moved Permanently` with the new URI in the `Location` header, when URIs must change to honor old URIs.
- **DO** monitor request traffic for redirection.
- **DO** maintain redirection services until you are confident the majority of clients have updated their stored links to point to the new URI.
- **DO** communicate an appropriate end-of-life policy for old URIs, when you cannot monitor the old URIs.
- **DO** convert `301 Moved Permanently` to `410 Gone` or `404 Not Found` once the traffic has fallen of or the preset time interval has passed. [**Chapter 9**]
- **CONSIDER** that URIs cannot be permanent if the concepts or identifiers used cannot be permanent for business, technical, or security reasons.
- **CONSIDER** using comma (`,`) and semi-colon (`;`) to indicate nonhierarchical elements in the path segment. The semi-colon (`;`) convention is used to identify matrix parameters. *As not all libraries recognize these as separators and may require custom coding to extract these parameters*.
- **CONSIDER** using "semi-opaque" URI templates, if it is impractical to supply the client with a list of all the possible URIs in the representation (e.g., ad hoc searching). [**See 5.7**]
- **CONSIDER** loosen/ignoring opacity to protect against request tampering using digitally signed URIs or encrypt parts of the URI to shield sensitive information. [**See 12.5**]
- **AVOID** including file extensions, instead rely on the media types.
- **AVOID** using uppercase characters in URIs.
- **AVOID** using trailing forward slash, as some frameworks may incorrectly remove or add such slashes during URI normalization.
- **AVOID** expecting clients to construct URIs.
- **AVOID** unnecessary query strings in URIs.
- **AVOID** leaking implementation details to clients, by keeping the creating of URIs on the server, as those details will become part of the public interface.
- **DO NOT** use an URI as a generic gateway, by tunneling repeated state changes over `POST` using the same URI.
- **DO NOT** use custom headers to overload URIs.

<!-- TODO -->

    ## API Naming

    ### MUST: Use lowercase separate words with hyphens for Path Segments

    ### MUST: Use snake_case (never camelCase) for Query Parameters

    ### MUST: Pluralize Resource Names

    Usually, a collection of resource instances is provided (at least API should be ready here). The special case of a resource singleton is a collection with cardinality 1.

    ### May: Use /api as first Path Segment

    In most cases, all resources provided by a service are part of the public API, and therefore should be made available under the root "/" base path. If the service should also support non-public, internal APIs — for specific operational support functions, for example — add "/api" as base path to clearly separate public and non-public API resources.

    ### MUST: Avoid Trailing Slashes

    The trailing slash must not have specific semantics. Resource paths must deliver the same results whether they have the trailing slash or not.


### URIs For Queries

Queries usually involve filtering, sorting and projections.

- **DO** use query parameters to let clients specify filter conditions, sort fields, and projections.
- **DO** treat query parameters as optional with sensible defaults.
- **DO** document each parameter.
- **CONSIDER** using a generic `sort` parameter to describe sorting rules. To accommodate more complex sorting requirements, let the `sort` parameter take a lift of comma-separated fields, each with a possible unary negative to imply descending sort order. Like: `GET /tickets?sort=-priority,created_at`
- **CONSIDER** using a `fields` query parameter for projections, like `http://www.example.org/customers?fields=name,gender,birthday`
- **CONSIDER** using a `view` query parameter for predefined projections, like `http://www.example.org/customers?view=summary`
- **CONSIDER** supporting aliases for commonly used queries (it may also improve cacheability). For instance, `GET /tickets/recently_closed`
- **AVOID** ad hoc queries that use general-purpose query languages such as *SQL* or *XPath*.
- **AVOID** `Range` requests for implementing queries.

    <!-- TODO -->
    *Filtering, Searching, Sorting, and Projection*

    ### May: Use Conventional Query Strings

    If you provide query support for sorting, pagination, filtering functions or other actions, use the following standardized naming conventions:

    q — default query parameter (e.g. used by browser tab completion); should have an entity specific alias, like sku
    limit — to restrict the number of entries. See Pagination section below. Hint: You can use size as an alternate query string.
    cursor — key-based page start. See Pagination section below.
    offset — numeric offset page start. See Pagination section below. Hint: In combination with limit, you can use page as an alternative to offset.
    sort — comma-separated list of fields to sort. To indicate sorting direction, fields my prefixed with + (ascending) or - (descending, default), e.g. /sales-orders?sort=+id
    fields — to retrieve a subset of fields. See Support Filtering of Resource Fields below.
    embed — to expand embedded entities (ie.: inside of an article entity, expand silhouette code into the silhouette object). Implementing "expand" correctly is difficult, so do it with care. See Embedding resources for more details.

    ### SHOULD:: Support Filtering of Resource Fields

    Depending on your use case and payload size, you can significantly reduce network bandwidth need by supporting filtering of returned entity fields. Here, the client can determine the subset of fields he wants to receive via the fields query parameter — example see Google AppEngine API's partial response:

    Unfiltered

    GET http://api.example.org/resources/123 HTTP/1.1

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
    "id": "cddd5e44-dae0-11e5-8c01-63ed66ab2da5",
    "name": "John Doe",
    "address": "1600 Pennsylvania Avenue Northwest, Washington, DC, United States",
    "birthday": "1984-09-13",
    "partner": {
        "id": "1fb43648-dae1-11e5-aa01-1fbc3abb1cd0",
        "name": "Jane Doe",
        "address": "1600 Pennsylvania Avenue Northwest, Washington, DC, United States",
        "birthday": "1988-04-07"
    }
    }
    Filtered

    GET http://api.example.org/resources/123?fields=(name,partner(name)) HTTP/1.1

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
    "name": "John Doe",
    "partner": {
        "name": "Jane Doe"
    }
    }
    As illustrated by this example, field filtering should be done via request parameter "fields" with value range defined by the following BNF grammar.

    ```
    <fields> ::= <negation> <fields_expression> | <fields_expression>

    <negation> ::= "!"

    <fields_expression> ::= "(" <field_set> ")"

    <field_set> ::= <qualified_field> | <qualified_field> "," <field_set>

    <qualified_field> ::= <field> | <field> <fields_expression>

    <field> ::= <DASH_LETTER_DIGIT> | <DASH_LETTER_DIGIT> <field>

    <DASH_LETTER_DIGIT> ::= <DASH> | <LETTER> | <DIGIT>

    <DASH> ::= "-" | "_"

    <LETTER> ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z" | "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"

    <DIGIT> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
    ```

    A fields_expression as defined by the grammar describes the properties of an object, i.e. (name) returns only the name property of the root object. (name,partner(name)) returns the name and partner properties where partner itself is also an object and only its name property is returned.

    > Hint: OpenAPI doesn't allow you to formally specify whether depending on a given parameter will return different parts of the specified result schema. Explain this in English in the parameter description.

    ### SHOULD:: Allow Optional Embedding of Sub-Resources

    Embedding related resources (also know as Resource expansion) is a great way to reduce the number of requests. In cases where clients know upfront that they need some related resources they can instruct the server to prefetch that data eagerly. Whether this is optimized on the server, e.g. a database join, or done in a generic way, e.g. an HTTP proxy that transparently embeds resources, is up to the implementation.

    See Conventional Query Parameters for naming, e.g. "embed" for steering of embedded resource expansion. Please use the BNF grammar, as already defined above for filtering, when it comes to an embedding query syntax.

    Embedding a sub-resource can possibly look like this where an order resource has its order items as sub-resource (/order/{orderId}/items):

    GET /order/123?embed=(items) HTTP/1.1

    {
    "id": "123",
    "_embedded": {
        "items": [
        {
            "position": 1,
            "sku": "1234-ABCD-7890",
            "price": {
            "amount": 71.99,
            "currency": "EUR"
            }
        }
        ]
    }
    }

### Using URIs in Clients

- **DO** update local copies of old URIs when receiving `301 Moved Permanently`.
- **DO** verify that the `Location` URI maps to a trusted server.
- **DO NOT** disable support of redirects in client applications. Instead, consider a sensible limit on the number of redirects a client can follow. Disabling redirects altogether will break the client when the server change URIs.


## Methods

Before discussing the individual HTTP methods we will offer some general advise:

- **DO** stay consistent with the HTTP verb definitions.
- **DO** use CRUD for most basic operations, as most developers will be familiar with this standardized way of working with an API. This means using `POST` for **C**reating, `GET` for **R**eading, `PUT` for **U**pdating, and `DELETE` for **D**eleting.

HTTP supports the following methods (not all discussed in detail here):

|Method   |Safe|Idempotent|
|---------|----|----------|
|`GET`    |Yes |Yes       |
|`HEAD`   |Yes |Yes       |
|`OPTIONS`|Yes |Yes       |
|`PUT`    |No  |Yes       |
|`DELETE` |No  |Yes       |
|`POST`   |No  |No        |
|`PATCH`  |No  |No        |

Safety and idempotency are guarantees a server must provide to clients:

    ### MUST: Fulfill Safeness and Idempotency Properties

    An operation can be...

    idempotent, i.e. operation will produce the same results if executed once or multiple times (note: this does not necessarily mean returning the same status code)
    safe, i.e. must not have side effects such as state changes
    Method implementations must fulfill the following basic properties:

    HTTP method	safe	idempotent
    OPTIONS	Yes	Yes
    HEAD	Yes	Yes
    GET	Yes	Yes
    PUT	No	Yes
    POST	No	No
    DELETE	No	Yes
    PATCH	No	No
    Please see also Best Practices [internal link] for further hints on how to support the different HTTP methods on resources.

- *Safe methods* (or read-only operations) are expected not to cause side-effects, however, it does not mean the server must return the same response every time.
- *Idempotent methods* must guarantee that every request has the same effect, and is highly important in case of failures.

    ### MUST: Use HTTP Methods Correctly

    Be compliant with the standardized HTTP method semantics summarized as follows:

### `GET`

- **DO** use `GET` to get a *safe* and *idempotent* representation of a resource.
- **DO NOT** use `GET` for unsafe and nonidempotent operations, use `POST` instead.

    GET requests are used to read a single resource or query set of resources.

    GET requests for individual resources will usually generate a 404 if the resource does not exist
    GET requests for collection resources may return either 200 (if the listing is empty) or 404 (if the list is missing)
    GET requests must NOT have request body payload
    Note: GET requests on collection resources should provide a sufficient filter mechanism as well as pagination.

    GET with Body

    APIs sometimes face the problem, that they have to provide extensive structured request information with GET, that may even conflicts with the size limits of clients, load-balancers, and servers. As we require APIs to be standard conform (body in GET must be ignored on server side), API designers have to check the following two options:

    GET with URL encoded query parameters: when it is possible to encode the request information in query parameters, respecting the usual size limits of clients, gateways, and servers, this should be the first choice. The request information can either be provided distributed to multiple query parameters or a single structured URL encoded string.
    POST with body content: when a GET with URL encoded query parameters is not possible, a POST with body content must be used. In this case the endpoint must be documented with the hint GET with body to transport the GET semantic of this call.
    Note: It is no option to encode the lengthy structured request information in header parameters. From a conceptual point of view, the semantic of an operation should always be expressed by resource name and query parameters, i.e. what goes into the URL. Request headers are reserved for general context information, e.g. FlowIDs. In addition, size limits on query parameters and headers are not reliable and depend on clients, gateways, server, and actual settings. Thus, switching to headers does not solve the original problem.

### `PUT`

- **DO** use `PUT` to update a resource.
- **DO NOT** use `PUT` to create new resources unless the clients can decide URIs of resources (e.g., WebDAV), instead use `POST`.

    PUT requests are used to create or update entire resources - single or collection resources. The semantic is best described as »please put the enclosed representation at the resource mentioned by the URL, replacing any existing resource.«.

    PUT requests are usually applied to single resources, and not to collection resources, as this would imply replacing the entire collection
    PUT requests are usually robust against non-existence of resources by implicitly creating before updating
    on successful PUT requests, the server will replace the entire resource addressed by the URL with the representation passed in the payload (subsequent reads will deliver the same payload)
    successful PUT requests will usually generate 200 or 204 (if the resource was updated - with or without actual content returned), and 201 (if the resource was created)
    Note: Resource IDs with respect to PUT requests are maintained by the client and passed as a URL path segment. Putting the same resource twice is required to be idempotent and to result in the same single resource instance. If PUT is applied for creating a resource, only URIs should be allowed as resource IDs. If URIs are not available POST should be preferred.

    To prevent unnoticed concurrent updates when using PUT, the combination of ETag and If-(None-)Match headers should be considered to signal the server stricter demands to expose conflicts and prevent lost updates.

### `DELETE`

- **DO** use `DELETE` to delete a resource. Always return `200 OK`, however, it is impractical to keep track of all deleted resource, so a `404 Not Found` may be a viable alternative. Security policies may also require the server to return `404 Not Found` for any resource that does not currently exist.

    DELETE request are used to delete resources. The semantic is best described as »please delete the resource identified by the URL«.

    DELETE requests are usually applied to single resources, not on collection resources, as this would imply deleting the entire collection
    successful DELETE request will usually generate 200 (if the deleted resource is returned) or 204 (if no content is returned)
    failed DELETE request will usually generate 404 (if the resource cannot be found) or 410 (if the resource was already deleted before)
    HEAD

### `POST`

- **DO** use `POST` to create resources.
- **DO** use `POST` to modify one or more resources.
- **DO** use `POST` to for queries with large inputs.
- **DO** use `POST` to perform any unsafe and nonidempotent operation, when no other HTTP method seems appropriate, and only as a last resort (avoid tunneling like SOAP).
- **AVOID** passing data in query string along `POST` request, use the body instead.
- **DO NOT** use nonstandard custom HTTP methods. Instead, design a controller resource that can abstract such operations, and `POST`.

    POST requests are idiomatically used to create single resources on a collection resource endpoint, but other semantics on single resources endpoint are equally possible. The semantic for collection endpoints is best described as »please add the enclosed representation to the collection resource identified by the URL«. The semantic for single resource endpoints is best described as »please execute the given well specified request on the collection resource identified by the URL«.

    POST request should only be applied to collection resources, and normally not on single resource, as this has an undefined semantic
    on successful POST requests, the server will create one or multiple new resources and provide their URI/URLs in the response
    successful POST requests will usually generate 200 (if resources have been updated), 201 (if resources have been created), and 202 (if the request was accepted but has not been finished yet)
    More generally: POST should be used for scenarios that cannot be covered by the other methods sufficiently. For instance, GET with complex (e.g. SQL like structured) query that needs to be passed as request body payload because of the URL-length constraint. In such cases, make sure to document the fact that POST is used as a workaround.

    Note: Resource IDs with respect to POST requests are created and maintained by server and returned with response payload. Posting the same resource twice is by itself not required to be idempotent and may result in multiple resource instances. Anyhow, if external URIs are present that can be used to identify duplicate requests, it is best practice to implement POST in an idempotent way.

#### Creating Resources

While it is valid to use either `PUT` or `POST` to create new resources, the general consensus is that creating a new resource without knowing the final URI is a `POST` operation (each call will yield a new resource). If the URI (or part of it) is known, use `PUT`, because successive calls will not create a new resource, as `PUT` is idempotent.

- **DO** return `201 Created` and a `Location` header containing the URI of the newly created resource.
- **DO** include a `Content-Location` header containing the URI of the newly created resource, if the response body includes a complete representation of the newly created resource.
- **CONSIDER** including the `Last-Modified` and `ETag` headers of the newly created resource for optimistic concurrency.

#### Large and Stored Queries

Sometimes it may be necessary to support queries with large inputs, and the query string may no longer be an option. For those cases:

- **DO** use `POST` to support large queries, as a necessary trade-off to address a practical limitation, even though this is a misuse of the uniform interface, and a consequence is a loss of cacheability
- **CONSIDER** the fact pagination may also cause extra latency, since `POST`s are not cached.
- **CONSIDER** using stored queries to improve cacheability and reuse across clients:
  - **DO** create a new resource whose state contains the query criteria. Return `201 Created` and a `Location` header referring to a resource created.
  - **DO** implement a `GET` request for the new resource such that it returns query results.
  - **DO** find the resource that matches the request, and redirect the client to the URI of that resource, if the same or another client repeats the same query request using `POST`.
  - **DO** support pagination via `GET` instead of `POST`.
  - **CONSIDER** the number of different queries and evaluate cache hit ratio, and whether named queries are a better option.

#### Asynchronous Tasks

To enable asynchronous processing of request, follow these guidelines (these step are also valid for `DELETE`):

- **DO** use `POST` to create and return a representation of a new *task* resource, and return status code `202 Accepted`. The purpose of this resource is to let a client track the status of the asynchronous task. Design this resource such that its representation includes the current status of the request and related information such as a time estimate.
- **DO** use `GET` to return a representation of the task resource, depending of the current status:
  - **DO** return `200 Ok` and a representation of the task resource with the current status, when *still processing* (pending).
  - **DO** return `303 See Other` and a `Location` header containing a URI of a resource that shows the outcome of the task, once the task has *successfully completed*.
  - **DO** return `200 Ok` with a representation of the task resource informing that the resource creation has *failed*. Clients will need to read the body of the representation to find the reason for failure.

Example of *pending*:

```http
HTTP/1.1 202 Accepted
Content-Type: application/json
Content-Location: http://www.example.org/images/task/1

{
    "state": "pending",
    "message": "Your request is being processed shortly.",
    "pingAfter": "2009-09-13T01:59:27Z",
    "link": {
        "href": "http://www.example.org/images/task/1",
        "rel": "self"
    }
}

```

Example of *done*:

```http
HTTP/1.1 303 See Other
Content-Type: application/json
Location: http://www.example.org/images/1
Content-Location: http://www.example.org/images/task/1

{
    "state": "done",
    "message": "Your request has been processed.",
    "link": {
        "href": "http://www.example.org/images/task/1",
        "rel": "self"
    }
}
```

> Note that the `303 See Other` does not mean that the resource at the request URI has moved to a new location. It merely states that the result exists at the URI indicated in the `Location` header.

### `PATCH`

    It's also important to understand the difference between PUT and PATCH, as PUT is used to perform a complete override of the record (if fields are not included, they are removed) where-as PATCH is used to update a record based on the information provided (or patch it with what you provide), leaving any fields not passed along intact.
    Keep in mind there are several different HTTP Action Verbs available, and it's easy to want to incorporate these new verbs and make your API new and different.

    <!-- TODO -->

    Doing PATCH “properly”
    According to the HTTP specification, PUT must take the full resource representation in the request. This can be a bit cumbersome, so PATCH is increasingly being adopted for partial updates.

    Given that PATCH is only a proposed standard there are details around the semantics of the method that are not widely understood. It’s not a simple replacement for POST and PUT where you supply a flat list of values to change. The request should supply a set of instructions for updating an entity and these should be applied atomically.

    A “set of instructions” is very different from a “set of values” and the specification clearly states that a request should be a different content type to the resource being modified. The detail of the representation is down to you, but RFC6902 describes a JSON format for PATCH where each object represents a single operation, e.g. “add”, “copy”, “delete” and so on. Each type of operation is described in eye-watering detail in the specification.

    The point here is that there is a lot more to PATCH than meets the eye. Unless you adopt a complex semantic format for describing change then you are likely to arouse the ire of the “you’re doing it wrong” brigade.

    <!-- TODO -->

    - 11.8. How to Refine Resources for Partial Updates
    - 11.9. How to use the `PATCH` Method

    PATCH request are only used for partial update of single resources, i.e. where only a specific subset of resource fields should be replaced. The semantic is best described as »please change the resource identified by the URL according to my change request«. The semantic of the change request is not defined in the HTTP standard and must be described in the API specification by using suitable media types.

    PATCH requests are usually applied to single resources, and not on collection resources, as this would imply patching on the entire collection
    PATCH requests are usually not robust against non-existence of resource instances
    on successful PATCH requests, the server will update parts of the resource addressed by the URL as defined by the change request in the payload
    successful PATCH requests will usually generate 200 or 204 (if resources have been updated
    with or without updated content returned)
    Note: since implementing PATCH correctly is a bit tricky, we strongly suggest to choose one and only one of the following patterns per endpoint, unless forced by a backwards compatible change. In preference order:

    use PUT with complete objects to update a resource as long as feasible (i.e. do not use PATCH at all).
    use PATCH with partial objects to only update parts of a resource, when ever possible. (This is basically JSON Merge Patch, a specialized media type application/merge-patch+json that is a partial resource representation.)
    use PATCH with JSON Patch, a specialized media type application/json-patch+json that includes instructions on how to change the resource.
    use POST (with a proper description of what is happening) instead of PATCH if the request does not modify the resource in a way defined by the semantics of the media type.
    In practice JSON Merge Patch quickly turns out to be too limited, especially when trying to update single objects in large collections (as part of the resource). In this cases JSON Patch can shown its full power while still showing readable patch requests (see also).

    To prevent unnoticed concurrent updates when using PATCH, the combination of ETag and If-Match headers should be considered to signal the server stricter demands to expose conflicts and prevent lost updates.

### Using Methods in Clients

- **DO** treat `GET`, `OPTIONS`, and `HEAD` as safe operations, and send as required. Include `If-Unmodified-Since` and/or `If-Match` conditional headers, if applicable.
- **DO** resubmit `GET`, `PUT`, and `DELETE` requests, in case of failures, to confirm.
- **DO** implement retry logic, whenever you encounter a failure for an idempotent method.
- **DO** submit a `POST` request with a representation of the resource to be created to the factory resource.
- **DO NOT** repeat `POST` requests unless the documentation states that is idempotent.
- **DO NOT** treat various HTTP-level errors as failures (network or software) or like exceptions.

<!-- TODO -->

    HEAD requests are used retrieve to header information of single resources and resource collections.

    HEAD has exactly the same semantics as GET, but returns headers only, no body.
    OPTIONS

    OPTIONS are used to inspect the available operations (HTTP methods) of a given endpoint.

    OPTIONS requests usually either return a comma separated list of methods (provided by an Allow:-Header) or as a structured list of link templates
    Note: OPTIONS is rarely implemented, though it could be used to self-describe the full functionality of a resource.

## Resources

A *resource* is an abstract entity that is identified by a URI, and can be data, processing logic, files, or anything else that a service may have access to.

    ## Resources

    ### MUST: Avoid Actions — Think About Resources

    REST is all about your resources, so consider the domain entities that take part in web service interaction, and aim to model your API around these using the standard HTTP methods as operation indicators. For instance, if an application has to lock articles explicitly so that only one user may edit them, create an article lock with PUT or POST instead of using a lock action.

    Request:

    PUT /article-locks/{article-id}

    The added benefit is that you already have a service for browsing and filtering article locks.

    ### SHOULD:: Model complete business processes

    An API should contain the complete business processes containing all resources representing the process. This enables clients to understand the business process, foster a consistent design of the business process, allow for synergies from description and implementation perspective, and eliminates implicit invisible dependencies between APIs.

    In addition, it prevents services from being designed as thin wrappers around databases, which normally tends to shift business logic to the clients.

    ### SHOULD:: Define useful resources

    As a rule of thumb resources should be defined to cover 90% of all its client's use cases. A useful resource should contain as much information as necessary, but as little as possible. A great way to support the last 10% is to allow clients to specify their needs for more/less information by supporting filtering and embedding.

    ### MUST: Keep URLs Verb-Free

    The API describes resources, so the only place where actions should appear is in the HTTP methods. In URLs, use only nouns. Instead of thinking of actions (verbs), it's often helpful to think about putting a message in a letter box: e.g., instead of having the verb cancel in the URL, think of sending a message to cancel an order to the cancellations letter box on the server side.

    ### MUST: Use Domain-Specific Resource Names

    API resources represent elements of the application's domain model. Using domain-specific nomenclature for resource names helps developers to understand the functionality and basic semantics of your resources. It also reduces the need for further documentation outside the API definition. For example, "sales-order-items" is superior to "order-items" in that it clearly indicates which business object it represents. Along these lines, "items" is too general.

    ### MUST: Identify resources and Sub-Resources via Path Segments

    Some API resources may contain or reference sub-resources. Embedded sub-resources, which are not top-level resources, are parts of a higher-level resource and cannot be used outside of its scope. Sub-resources should be referenced by their name and identifier in the path segments.

    Composite identifiers must not contain "/" as a separator. In order to improve the consumer experience, you should aim for intuitively understandable URLs, where each sub-path is a valid reference to a resource or a set of resources. For example, if "/customers/12ev123bv12v/addresses/DE_100100101" is a valid path of your API, then "/customers/12ev123bv12v/addresses", "/customers/12ev123bv12v" and "/customers" must be valid as well in principle.

    Basic URL structure:

    /{resources}/[resource-id]/{sub-resources}/[sub-resource-id]
    /{resources}/[partial-id-1][separator][partial-id-2]
    Examples:

    /carts/1681e6b88ec1/items
    /carts/1681e6b88ec1/items/1
    /customers/12ev123bv12v/addresses/DE_100100101

    ### MAY: Consider Using (Non-) Nested URLs

    If a sub-resource is only accessible via its parent resource and may not exists without parent resource, consider using a nested URL structure, for instance:

    /carts/1681e6b88ec1/cart-items/1
    However, if the resource can be accessed directly via its unique id, then the API should expose it as a top-level resource. For example, customer is a collection for sales orders; however, sales orders have globally unique id and some services may choose to access the orders directly, for instance:

    /customers/1681e6b88ec1
    /sales-orders/5273gh3k525a

    ### SHOULD:: Limit number of Resources

    To keep maintenance and service evolution manageable, we should follow "functional segmentation" and "separation of concern" design principles and do not mix different business functionalities in same API definition. In this sense the number of resources exposed via API should be limited - our experience is that a typical range of resources for a well-designed API is between 4 and 8. There may be exceptions with more complex business domains that require more resources, but you should first check if you can split them into separate subdomains with distinct APIs.

    Nevertheless one API should hold all necessary resources to model complete business processes helping clients to understand these flows.

    ### SHOULD:: Limit number of Sub-Resource Levels

    There are main resources (with root url paths) and sub-resources (or "nested" resources with non-root urls paths). Use sub-resources if their life cycle is (loosely) coupled to the main resource, i.e. the main resource works as collection resource of the subresource entities. You should use <= 3 sub-resource (nesting) levels -- more levels increase API complexity and url path length. (Remember, some popular web browsers do not support URLs of more than 2000 characters)

### Identifying and Naming Resources

Most often when identifying resources, the use of nouns instead of verbs will be obvious, however, sometimes it is necessary to veer from this naming convention, when exposing certain services through the public API.

Care should be taking when identifying resources and finding the right resource granularity:

- **DO** use network efficiency, size of representations, and client convenience to guide resource granularity.
- **DO** analyze use cases to find domain nouns that can be operated using *create*, *read*, *update*, or *delete* operations. Designate each noun as a resource. Use `POST`, `GET`, `PUT`, or `DELETE` operations respectively, on each resource.
- **DO** design resources to suit client's usage patterns and not design them based on what exists in a database or the object model. (Think from the client's perspective)
- **DO** pluralize resource names for collections resources. To keep things simple, pragmatic and consistent always use plural to avoid odd pluralization (person/people).
- **DO** think about frequency of change and cacheability. Try to separate immutable (less frequently changing) resources from less cacheable resources.
- **DO NOT** blindly apply the same techniques for identifying resources, as for object-oriented design and database modeling.
- **DO NOT** bluntly map domain entities into resources, as this may lead to resources that a inefficient and inconvenient to use and also leak irrelevant implementation details out to your public API.
- **DO NOT** limit yourself to identifying resources based on domain nouns alone, you are likely to find that the fixed set of methods in HTTP is quite a limitation. *Using a root-level "Me" endpoint is perfectly valid.*

### Collection Resources

Collection resources can give the ability to refer to a group of a resources as one, to perform queries on the collection, or use the collection as a factory to create new resources.

> A collection does not necessarily imply hierarchical containment. A resource may be part of more than one collection resource.

When organizing resources into collections:

- **DO** provide a way of searching the collection for it members, if applicable.
- **DO** provide a filtered view of the collection, if applicable.
- **DO** provide a paginated view of a collection, when appropriate.
- **DO** embed commonly requested relations alongside the resource, for client convenience.
- **DO** organize resources according to relationship (`GET /bookings/1/departures/2`), if a relation can only exist within another resource.
- **CONSIDER** providing a link, if a relation can exist independently of the resource. However, if the relation is commonly requested it might be better to always embed the relation's representation, or perhaps offer a functionality to automatically embed the relation's representation and save the client a second round-trip (`GET /bookings?embed=departures,vehicles`).

### Composite Resources

At times it may prove convenient to identify new composite resources.

- **DO** identify new resources that aggregate other resources to reduce the number of client/server round-trips, based on client usage patterns, performance, and latency requirements.
- **CONSIDER** a snapshot page to summarize information, using an URI of the form `http://www.example.org/customer/1234/snapshot`.
- **CONSIDER**, if requests for composites are rare, or if network latency is an issue, whether caching may be a better option.

### Processing Function

Use processing functions to abstract specific services through the public API that allows clients to perform tasks such computation or data validation.

- **DO** treat the processing function as a resource
- **DO** use `GET` to fetch a representation containing the output of the processing function.
- **DO** use query parameters to supply inputs to the processing function.
- **DO** treating the processing function as a resource, as most often it will be difficult to find appropriate nouns. So when validating a vehicle registration number: `http://www.example.org/vehicles/validate?regnum=ZY12345`

### Controller Resources

A *controller* is a resource that can atomically make changes to resources. It can help abstract complex business operations, which increase the separation of concerns and reduces coupling between clients and servers, which in turn may improve network efficiency.

- **DO** designate a controller resource for each distinct operation.
- **DO** use `POST` to submit a request to trigger the operation.
- **DO**, if the output of the operation is the creation of a new resource, return `201 Created` with a `Location` header referring to the URI of the newly created resource.
- **DO**, if the outcome is the modification of one or more existing resource, return `303 See Other` with a `Location` to a URI that clients can use to fetch a representation of those modifications.
- **DO**, if the server cannot provide a single URI to all the modified resources, return `200 OK` with a representation in the body that clients can use to learn about the outcome.
- **DO** handle errors as described in [Errors](#errors)
- **AVOID** tunneling at all costs. Instead, use a distinct resource (such as a controller) for each operation. Tunneling occurs whenever the client is using the same method on a single URI for different actions. Tunneling reduces protocol-level visibility, because the visible parts of requests such as the request URI, the HTTP method used, headers, and media types do not unambiguously describe the operation.

## Representations

A *representation* (request/response) is concrete and real.

    <!-- TODO -->
    Concerns:
    - What is good response design
    - Enveloping response data
        - Use Envelopes
        - Don't use an envelope by default, and enveloping only in exceptional cases.

    # Provide Helpful Responses

    Building a solid foundation to ensure the scalability and longevity of your API is crucial, but just as crucial is ensuring that developers can understand your API, and trust it to respond with the appropriate header codes and error messages.
    In this week's API best practices, we're going to cover how to ensure that developers understand exactly what happened with their API call by using the appropriate HTTP Status Codes (something that is often times missed), as well as by returning descriptive error messages on failure.

### HTTP Headers

    ### MUST: Use Hyphenated HTTP Headers

    ### SHOULD:: Prefer Hyphenated-Pascal-Case for HTTP header Fields

    This is for consistency in your documentation (most other headers follow this convention). Avoid camelCase (without hyphens). Exceptions are common abbreviations like "ID."

    ### May: Use Standardized Headers

    # Use the Content-Type Header

    In order to truly keep your API flexible and extendable for the future, it's also important to build it not just for today's leading formats, but also for whatever the future may hold.

    Until just recently XML was the format of choice for web services, but then JSON came along.

    Everyday new formats are being created and used, most notably YAML.

    For this reason it is important that your API does not constrain itself to only one format.
    It's perfectly acceptable to only have one format available if that meets your developer's needs (for example, only taking advantage of JSON), but that doesn't mean you shouldn't be planning ahead.

    By taking advantage of the Content-Type header you can see what format of data your users are sending you, and in return send back that same format.

    For example, if a user sends a request using text/xml, you could send back an XML response while another user could send an application/json request and you could reply with JSON.
    By building this functionality into your API to begin with, as new formats become available, or as you add high profile clients with special needs, you are now able to adapt to these new format requests without impacting other users, or other aspects of your API.

    This also means that you can stay on top of the technology curve without worrying about having to migrate users from one format to another, or from one API to another.
    Ideally, your API's architecture should be flexible enough to receive content in one format (as described by the Content-Type header) such as XML and return the response in another format based on the Accept header, such as JSON.

    Doing so is NOT a good practice, but it does reinforce just how decoupled your API should be from the technology stack, as well as how important incorporating view libraries to handle the output are.

    In other words, your API's architecture should be versatile enough to do this, but it is probably best just to rely on the content-type instead of mixing data formats based on both the content-type and accept headers.

    # Common Headers

    This section describes a handful of headers, which we found raised the most questions in our daily usage, or which are useful in particular circumstances but not widely known.

    ### MUST: Use Content Headers Correctly

    Content or entity headers are headers with a Content- prefix. They describe the content of the body of the message and they can be used in both, HTTP requests and responses. Commonly used content headers include but are not limited to:

    Content-Disposition can indicate that the representation is supposed to be saved as a file, and the proposed file name.
    Content-Encoding indicates compression or encryption algorithms applied to the content.
    Content-Length indicates the length of the content (in bytes).
    Content-Language indicates that the body is meant for people literate in some human language(s).
    Content-Location indicates where the body can be found otherwise (see below for more details).
    Content-Range is used in responses to range requests to indicate which part of the requested resource representation is delivered with the body.
    Content-Type indicates the media type of the body content.

    ### MAY: Use Content-Location Header

    The Content-Location header is optional and can be used in successful write operations (PUT, POST or PATCH) or read operations (GET, HEAD) to guide caching and signal a receiver the actual location of the resource transmitted in the response body. This allows clients to identify the resource and to update their local copy when receiving a response with this header.

    The Content-Location header can be used to support the following use cases:

    For reading operations GET and HEAD, a different location than the requested URI can be used to indicate that the returned resource is subject to content negotiations, and that the value provides a more specific identifier of the resource.
    For writing operations PUT and PATCH, an identical location to the requested URI, can be used to explicitly indicate that the returned resource is the current representation of the newly created or updated resource.
    For writing operations POST and DELETE, a content location can be used to indicate that the body contains a status report resource in response to the requested action, which is available at provided location.
    Note: When using the Content-Location header, the Content-Type header has to be set as well. For example:

    GET /products/123/images HTTP/1.1

    HTTP/1.1 200 OK
    Content-Type: image/png
    Content-Location: /products/123/images?format=raw

    ### SHOULD:: Use Location Header instead of Content-Location Header

    As the correct usage of Content-Location with respect to semantics and caching is difficult, we discourage the use of Content-Location. In most cases it is sufficient to direct clients to the resource location by using the Location header instead without hitting the Content-Location specific ambiguities and complexities.

    More details in RFC 7231 7.1.2 Location, 3.1.4.2 Content-Location

    ### MAY: Use the Prefer header to indicate processing preferences

    The Prefer header defined in RFC7240 allows clients to request processing behaviors from servers. RFC7240 pre-defines a number of preferences and is extensible, to allow others to be defined. Support for the Prefer header is entirely optional and at the discretion of API designers, but as an existing Internet Standard, is recommended over defining proprietary "X-" headers for processing directives.

    Supporting APIs may return the Preference-Applied header also defined in RFC7240 to indicate whether the preference was applied.

    ### MAY: Consider using ETag together with If-(None-)Match header

    When creating or updating resources it may be necessary to expose conflicts and to prevent the lost update problem. This can be best accomplished by using the ETag header together with the If-Match and If-None-Match. The contents of an ETag: <entity-tag> header is either (a) a hash of the response body, (b) a hash of the last modified field of the entity, or (c) a version number or identifier of the entity version.

    To expose conflicts between concurrent update operations via PUT, POST, or PATCH, the If-Match: <entity-tag> header can be used to force the server to check whether the version of the updated entity is conforming to the requested <entity-tag>. If no matching entity is found, the operation is supposed a to respond with status code 412 - precondition failed.

    Beside other use cases, the If-None-Match: header with parameter * can be used in a similar way to expose conflicts in resource creation. If any matching entity is found, the operation is supposed a to respond with status code 412 - precondition failed.

    The ETag, If-Match, and If-None-Match headers can be defined as follows in the API definition:

    Etag:
        name: Etag
        description: |
        The RFC7232 ETag header field in a response provides the current entity-tag for the
        selected resource. An entity-tag is an opaque identifier for different versions of
        a resource over time, regardless whether multiple versions are valid at the same time.
        An entity-tag consists of an opaque quoted string, possibly prefixed by a weakness
        indicator.

        in: header
        type: string
        required: false
        example: W/"xy", "5", "7da7a728-f910-11e6-942a-68f728c1ba70"

    IfMatch:
        name: If-Match
        description: |
        The RFC7232 If-Match header field in a request requires the server to only operate
        on the resource that matches at least one of the provided entity-tags. This allows
        clients express a precondition that prevent the method from being applied, if there
        have been any changes to the resource.

        in: header
        type: string
        required: false
        example:  "5", "7da7a728-f910-11e6-942a-68f728c1ba70"

    IfNoneMatch:
        name: If-None-Match
        description: |
        The RFC7232 If-None-Match header field in a request requires the server to only
        operate on the resource if it does not match any of the provided entity-tags. If
        the provided entity-tag is `*`, it is required that the resource does not exist
        at all.

        in: header
        type: string
        required: false
        example: "7da7a728-f910-11e6-942a-68f728c1ba70", *

    # Proprietary Headers

    This section shares definitions of proprietary headers that should be named consistently because they address overarching service-related concerns. Whether services support these concerns or not is optional; therefore, the OpenAPI API specification is the right place to make this explicitly visible. Use the parameter definitions of the resource HTTP methods.

    ### MUST: Use Only the Specified Proprietary Zalando Headers

    As a general rule, proprietary HTTP headers should be avoided. Still they can be useful in cases where context needs to be passed through multiple services in an end-to-end fashion. As such, a valid use-case for a proprietary header is providing context information, which is not a part of the actual API, but is needed by subsequent communication.

    From a conceptual point of view, the semantics and intent of an operation should always be expressed by URLs path and query parameters, the method, and the content. Headers are more often used to implement functions close to the protocol considerations, such as flow control, content negotiation, and authentication. Thus, headers are reserved for general context information (RFC-7231).

    X- headers were initially reserved for unstandardized parameters, but the usage of X- headers is deprecated (RFC-6648). This complicates the contract definition between consumer and producer of an API following these guidelines, since there is no aligned way of using those headers. Because of this, the guidelines restrict which X- headers can be used and how they are used.

    The Internet Engineering Task Force's states in RFC-6648 that company specific header' names should incorporate the organization's name. We aim for backward compatibility, and therefore keep the X- prefix.

    The following proprietary headers have been specified by this guideline for usage so far. Remember that HTTP header field names are not case-sensitive.

    Header field name	Type	Description	Header field value example
    X-Flow-ID	String	The flow id of the request, which is written into the logs and passed to called services. Helpful for operational troubleshooting and log analysis. It supports traceability of requests and identifying request flows through system of many services. It should be a string consisting of just printable ASCII characters (i.e. without whitespace). Verify in a received request that it fits to a specific format, has a sensible maximum length and possibly throw out or escape characters/bytes which could crash your log parsing (line breaks, tabs, spaces, NULL). If a legacy subsystem can only work with flow IDs of a specific format, it needs to define this in its API, or make its own ones.	GKY7oDhpSiKY_gAAAABZ_A
    X-UID	String	Generic user id of OpenId account that owns the passed (OAuth2) access token. E.g. additionally provided by OpenIG proxy after access token validation -- may save additional token validation round trips.	w435-dker-jdh357
    X-Tenant-ID	String	The tenant id for future platform multitenancy support. Should not be used unless new platform multitenancy is truly supported. But should be used by New Platform Prototyping services. Must be validated for external retailer, supplier, etc. tenant users via OAuth2; details in clarification. Currently only used by New Platform Prototyping services.	9f8b3ca3-4be5-436c-a847-9cd55460c495
    X-Sales-Channel	String	Sales channels are owned by retailers and represent a specific consumer segment being addressed with a specific product assortment that is offered via CFA retailer catalogs to consumers (see platform glossary [internal link])	101
    X-Frontend-Type	String	Consumer facing applications (CFAs) provide business experience to their customers via different frontend application types, for instance, mobile app or browser. Info should be passed-through as generic aspect -- there are diverse concerns, e.g. pushing mobiles with specific coupons, that make use of it. Current range is mobile-app, browser, facebook-app, chat-app	mobile-app
    X-Device-Type	String	There are also use cases for steering customer experience (incl. features and content) depending on device type. Via this header info should be passed-through as generic aspect. Current range is smartphone, tablet, desktop, other	tablet
    X-Device-OS	String	On top of device type above, we even want to differ between device platform, e.g. smartphone Android vs. iOS. Via this header info should be passed-through as generic aspect. Current range is iOS, Android, Windows, Linux, MacOS	Android
    X-App-Domain	Integer	The app domain (i.e. shop channel context) of the request. Note, app-domain is a legacy concept that will be replaced in new platform by combinations of main CFA concerns like retailer, sales channel, country	16
    Exception: The only exception to this guideline are the conventional hop-by-hop X-RateLimit- headers which can be used as defined in HTTP/Must-Use-429-with-Headers-For-Rate-Limits.

    ### MUST: Propagate Proprietary Headers

    All Zalando's proprietary headers are end-to-end headers.

    All headers specified above must be propagated to the services down the call chain. The header names and values must remain unchanged.

    For example, the values of the custom headers like X-Device-Type can affect the results of queries by using device type information to influence recommendation results. Besides, the values of the custom headers can influence the results of the queries (e.g. the device type information influences the recommendation results).

    Sometimes the value of a proprietary header will be used as part of the entity in a subsequent request. In such cases, the proprietary headers must still be propagated as headers with the subsequent request, despite the duplication of information.

    Footnote:

    HTTP/1.1 standard (RFC-7230) defines two types of headers: end-to-end and hop-by-hop headers. End-to-end headers must be transmitted to the ultimate recipient of a request or response. Hop-by-hop headers, on the contrary, are meaningful for a single connection only.


Headers ensure visibility, discoverability, routing by proxies, caching, optimistic concurrency, and correct operation of HTTP as an application protocol.

#### Using Headers to Annotate Representations

Use the following headers to annotate representations that contain message bodies:

- **DO** use `Content-Type`, to describe the type of representation, including a `charset` parameter or other parameters defined for that media type.
- **DO** use `Content-Length`, to specify the size in bytes of the body. Or specify `Transfer-Encoding: chunked`. Some proxies reject `POST` and `PUT` requests that contain neither of these headers.
- **DO** use `Content-Language`, two-letter RFC 5646 language tag, optionally followed by a hyphen (-) and any two-letter country code.
- **DO** use `Content-MD5`, when sending or receiving large representations over potentially unreliable networks to verify the integrity of the message.
- **DO** set the appropriate expiration caching headers [**9.1**]
- **DO NOT** use `Content-MD5` as a measure of security.
- **DO** use `Content-Encoding`. Clients can indicate their preference for `Content-Encoding` using the `Accept-Encoding` header, however, there is no standard way for the client to learn whether a server can process representations compressed in a given encoding.
- **DO NOT** use `Content-Encoding` in HTTP requests, unless you know out of band that the target server supports a particular encoding method.
- **CONSIDER** using `Last-Modified`, this header applies for responses only. [See **Chapter 9**]

#### Interpreting Entity Headers

- **DO** return `400 Bad Request` on servers, when you receive a representation with no `Content-Type`, avoid guessing the type of the representation.
- **DO NOT** check for the presence of the `Content-Length` header without first confirming the absence of `Transfer-Encoding: chunked`
- **DO** let your network library deal with uncompressing compressed representations (`Content-Encoding`)
- **DO** read and store the value of `Content-Language`

#### Avoiding Character Encoding Mismatch

- **DO** include the `charset` parameter, if the media type supports it, with a value of the character encoding used to convert characters into bytes.
- **DO** use the specified encoding, when you receive a representation with a media type that supports the `charset`parameter.
- **DO** let your parser interpret the character set, if you receive an XML representation with a missing `charset` parameter.
- **AVOID** using the `text/xml` media type for XML-formatted representations. The default charset for `text/xml` is `us-ascii`, whereas `application/xml` uses `UTF-8`.

> Note that Text and XML media types let you specify the character encoding. The JSON media type `application/json` does not specify a `charset` parameter, but uses `UTF-8` as the default encoding.

#### Custom HTTP Headers

Depending on what clients and servers use custom headers for, custom headers may impede interoperability.

- **DO** use custom headers for informational purposes.
- **CONSIDER** using the convention `X-{company-name}-{header-name}`, when introducing custom headers, as there is no established convention for naming custom headers.
- **CONSIDER** including the information in a custom HTTP header in the body or the URI, if the information is important for the correct interpretation of the request
- **DO NOT** implement clients and servers such that they fail when they do not find expected custom headers.
- **DO NOT** use custom HTTP headers to change behavior of HTTP methods, and limit any behavior-changing headers to `POST`.
- **DO NOT** use `X-HTTP-Method-Override` to override `POST`, use a distinct resource to process the same request using `POST` without the header. Any HTTP intermediary between the client and the server may omit custom headers.

### Representation Format and a Media Type

HTTP's message format is designed to allow different media types and formats for requests and responses.

When it comes to format and media type selection, the rule of thumb is to let the use cases and the types of clients dictate the choice. For this reason, it is important not to pick up a development framework that rigidly enforces one or two formats for all resource with no flexibility to use other formats.

- **DO** determine whether there is a standard format and media type that matches your use cases. Check the Internet Assigned Number Authority (IANA, http://www.iana.org/assignments/media-types/) media type registry.
- **DO** use extensible formats such as XML, Atom Syndication Format, or JSON, if there is no standard media type and format.
- **CONSIDER** adding a `Content-Disposition: attachment; filename=<status.xls>` to give a hint of the filename, when using image formats like `image/png` or rich document formats like `application/vnd.ms-excel` or `application/pdf` to provide alternative representations of data.

If you choose to create new media types of your own, consider:

- **DO** use a sub-type that ends with `+xml` in the `Content-Type` header, when using XML
- **DO** use a sub-type starting with `vnd` (`application/vnd.example.org.user+xml`), when the media type is for private use,
- **DO** register your media type with IANA as per RFC 4288, if the media type is for public use,
- **AVOID** introducing new application-specific media types unless they are expected to be broadly used, as this may impede interoperability.

> Note that although custom media types improve protocol-level visibility, existing protocol-level tools for monitoring, filtering, or routing HTTP traffic pay little or no attention to media types. Hence, using custom media types only for the sake of protocol-level visibility is not necessary.

    #### *XML Representations*

    *TBD*

    *Suggested topics:*<br/>
    *Atom resources, AtomPub Service, category documents, AtomPub for feed and entry resources, media resources*

#### JSON Representations

    ### MUST: Use JSON to Encode Structured Data

    Use JSON-encoded body payload for transferring structured data. The JSON payload must follow RFC-7159 by having (if possible) a serialized object as the top-level structure, since it would allow for future extension. This also applies for collection resources where one naturally would assume an array. See the pagination section for an example.

    ### SHOULD:: Prefer standard Media type name application/json

    Previously, this guideline allowed the use of custom media types like application/x.zalando.article+json. This usage is not recommended anymore and should be avoided, except where it is necessary for cases of media type versioning. Instead, the standard media type name application/json (or application/problem+json for HTTP error details) should be used for JSON-formatted data.

    Custom media types with subtypes beginning with x bring no advantage compared to the standard media type for JSON, and make automated processing more difficult. They are also discouraged by RFC 6838.


    ### MAY: Use non JSON Media Types for Binary Data or Alternative Content Representations

    Other media types may be used in following cases:

    Transferring binary data or data whose structure is not relevant. This is the case if payload structure is not interpreted and consumed by clients as is. Example of such use case is downloading images in formats JPG, PNG, GIF.
    In addition to JSON version alternative data representations (e.g. in formats PDF, DOC, XML) may be made available through content negotiation.

    # Use JSON (when possible)

    JSON, or the JavaScript Object Notation format allows for the quick serialization and deserialization of objects.

    JSON provides a compact format for accessing data, minimalizing the data transfer required while also offering broader language support than XML.
    These advantages have made it the format of choice for many developers and the leading format for use within REST APIs.

    Again, you'll want to choose the format that is best for your clients, but in the event that you're encoding objects as XML, I would strongly suggest also offering JSON as an alternative as the serialization is fairly quick and painless.
    Keep in mind that one of the advantages to REST is that it is not limited to a single content type, and can return multiple formats if desired.

    ## JSON Guidelines

    These guidelines provides recommendations for defining JSON data at Zalando. JSON here refers to RFC 7159 (which updates RFC 4627), the "application/json" media type and custom JSON media types defined for APIs. The guidelines clarifies some specific cases to allow Zalando JSON data to have an idiomatic form across teams and services.

    ### MUST: Use Consistent Property Names

    ### MUST: Property names must be snake_case (and never camelCase).

    No established industry standard exists. It's essential to establish a consistent look and feel such that JSON looks as if it came from the same hand.

    ### MUST: Property names must be an ASCII subset

    Property names are restricted to ASCII encoded strings. The first character must be a letter, an underscore or a dollar sign, and subsequent characters can be a letter, an underscore, a dollar sign, or a number.

    ### SHOULD:: Array names should be pluralized

    To indicate they contain multiple values prefer to pluralize array names. This implies that object names should in turn be singular.

    ### MUST: Use Consistent Property Values

    ### MUST: Boolean property values must not be null

    Schema based JSON properties that are by design booleans must not be presented as nulls. A boolean is essentially a closed enumeration of two values, true and false. If the content has a meaningful null value, strongly prefer to replace the boolean with enumeration of named values or statuses - for example accepted\_terms\_and\_conditions with true or false can be replaced with terms\_and\_conditions with values yes, no and unknown.

    ### SHOULD:: Null values should have their fields removed

    Swagger/OpenAPI, which is in common use, doesn't support null field values (it does allow omitting that field completely if it is not marked as required). However that doesn't prevent clients and servers sending and receiving those fields with null values. Also, in some cases null may be a meaningful value - for example, JSON Merge Patch RFC 7382) using null to indicate property deletion.

    ### SHOULD:: Empty array values should not be null

    Empty array values can unambiguously be represented as the the empty list, [].

    ### SHOULD:: Enumerations should be represented as Strings

    Strings are a reasonable target for values that are by design enumerations.

    ### MUST: Use common field names and semantics

    There exist a variety of field types that are required in multiple places. To achieve consistency across all API implementations, you must use common field names and semantics whenever applicable.

    Generic Fields

    There are some data fields that come up again and again in API data:

    id: the identity of the object. If used, IDs must opaque strings and not numbers. IDs are unique within some documented context, are stable and don't change for a given object once assigned, and are never recycled cross entities.

    xyz_id: an attribute within one object holding the identifier of another object must use a name that corresponds to the type of the referenced object or the relationship to the referenced object followed by _id (e.g. customer_id not customer_number; parent_node_id for the reference to a parent node from a child node, even if both have the type Node)

    created: when the object was created. If used, this must be a date-time construct.

    modified: when the object was updated. If used, this must be a date-time construct.

    type: the kind of thing this object is. If used, the type of this field should be a string. Types allow runtime information on the entity provided that otherwise requires examining the Open API file.

    These properties are not always strictly necessary, but making them idiomatic allows API client developers to build up a common understanding of Zalando's resources. There is very little utility for API consumers in having different names or value types for these fields across APIs.

- **DO** include a *self* link to the resource in each representation.
- **DO** add a property to indicate the language, if an object in the representation is localized.
- **DO** pretty print the representation by default, as this will help when using a browser to access the public API. Together with compression the additional white-space characters are negligible.
- **CONSIDER** including entity identifiers for each of the application domain entities that make up the resource.

<!-- TODO -->

    ### SHOULD:: Use gzip Compression

    Compress the payload of your API's responses with gzip, unless there's a good reason not to — for example, you are serving so many requests that the time to compress becomes a bottleneck. This helps to transport data faster over the network (fewer bytes) and makes frontends respond faster.

    Though gzip compression might be the default choice for server payload, the server should also support payload without compression and its client control via Accept-Encoding request header -- see also RFC 7231 Section 5.3.4. The server should indicate used gzip compression via the Content-Encoding header.



```json
{
    "name": "John",
    "id": "urn:example:user:1234",
    "link": {
        "rel": "self",
        "href": "http://www.example.org/person/john"
    },
    "address": {
        "id": "urn:example:address:4567",
        "link": {
            "rel": "self",
            "href": "http://www.example.org/person/john/address"
        }
    },
    "content": {
        "text": [{
          "value": "..."
        }, {
            "lang": "en-GB",
            "value": "..."
        }, {
            "lang": "en-US",
            "value": "..."
        }]
    }
}
```

#### Representations of Collections

- **DO** return an empty collection, if the query does not match any resources.
- **DO** include pagination links.

#### Pagination

    <!-- TODO -->

    Pagination: The right way to include pagination details today is using the Link header introduced by RFC 5988. An API that requires sending a count can use a custom HTTP header like X-Total-Count.

    - OData
    - The GitHub way:
    ```
    # Request
    GET /user/repos?page=4&per_page=2

    # Response
    Link: <https://api.github.com/user/repos?page=5&per_page=2>; rel="next",
          <https://api.github.com/user/repos?page=8&per_page=2>; rel="last",
          <https://api.github.com/user/repos?page=1&per_page=2>; rel="first",
          <https://api.github.com/user/repos?page=3&per_page=2>; rel="prev"
    ```
    - Pivotal Tracker
    ```
    # Request
    GET projects/1/stories?offset=1300&limit=300

    # Response
    X-Tracker-Pagination-Total: 1543
    X-Tracker-Pagination-Limit: 300
    X-Tracker-Pagination-Offset: 1300
    X-Tracker-Pagination-Returned: 243
    ```
    ```
    # Request
    GET projects/1/stories?offset=1300&limit=300&envelope=true

    # Response
    {
       "data": { /* ... */ },
       "pagination": {
           "total": 1543,
           "limit": 300,
           "offset": 1300,
           "returned": 243
       }
    }
    ```

- **DO** add a self link to the collection resource
- **DO** add link to the next page, if the collection is paginated and has a next page
- **DO** a link to the previous page, if the collection is paginated and has a previous page
- **DO** add an indicator of the size of the collection
- **DO** keep collections homogeneous by include only the homogeneous aspects of its member resources.

> **TIP**
> Although the size of the collection is useful for building user interfaces, avoid computing the exact size of the collection. It may be expensive to compute, volatile, or even confidential. Providing a hint is usually good enough.

<!-- TODO -->

    # Pagination

    ### MUST: Support Pagination

    Access to lists of data items must support pagination for best client side batch processing and iteration experience. This holds true for all lists that are (potentially) larger than just a few hundred entries.

    There are two page iteration techniques:

    Offset/Limit-based pagination: numeric offset identifies the first page entry
    Cursor-based — aka key-based — pagination: a unique key element identifies the first page entry (see also Facebook's guide)
    The technical conception of pagination should also consider user experience related issues. As mentioned in this article, jumping to a specific page is far less used than navigation via next/previous page links. This favours cursor-based over offset-based pagination.

    ### SHOULD:: Prefer Cursor-Based Pagination, Avoid Offset-Based Pagination

    Cursor-based pagination is usually better and more efficient when compared to offset-based pagination. Especially when it comes to high-data volumes and / or storage in NoSQL databases.

    Before choosing cursor-based pagination, consider the following trade-offs:

    Usability/framework support:

    Offset / limit based pagination is more known than cursor-based pagination, so it has more framework support and is easier to use for API clients
    Use case: Jump to a certain page

    If jumping to a particular page in a range (e.g., 51 of 100) is really a required use case, cursor-based navigation is not feasible
    Variability of data may lead to anomalies in result pages

    Offset-based pagination may create duplicates or lead to missing entries if rows are inserted or deleted between two subsequent paging requests.
    When using cursor-based pagination, paging cannot continue when the cursor entry has been deleted while fetching two pages
    Performance considerations - efficient server-side processing using offset-based pagination is hardly feasible for:

    Higher data list volumes, especially if they do not reside in the database's main memory
    Sharded or NoSQL databases
    Cursor-based navigation may not work if you need the total count of results and / or backward iteration support

    Further reading:

    Twitter
    Use the Index, Luke
    Paging in PostgreSQL

    ### MAY: Use Pagination Links Where Applicable

    API implementing HATEOS may use simplified hypertext controls for pagination within collections.
    Those collections should then have an items attribute holding the items of the current page. The collection may contain additional metadata about the collection or the current page (e.g. index, page_size) when necessary.

    You should avoid providing a total count in your API unless there's a clear need to do so. Very often, there are systems and performance implications to supporting full counts, especially as datasets grow and requests become complex queries or filters that drive full scans (e.g., your database might need to look at all candidate items to count them). While this is an implementation detail relative to the API, it's important to consider your ability to support serving counts over the life of a service.

    If the collection consists of links to other resources, the collection name should use IANA registered link relations as names whenever appropriate, but use plural form.

    E.g. a service for articles could represent the collection of hyperlinks to an article's authors like that:

    {
    "self": "https://.../articles/xyz/authors/",
    "index": 0,
    "page_size": 5,
    "items": [
        {  
        "href": "https://...",
        "id": "123e4567-e89b-12d3-a456-426655440000",
        "name": "Kent Beck"
        },
        {  
        "href": "https://...",
        "id": "987e2343-e89b-12d3-a456-426655440000",
        "name": "Mike Beedle"
        },
        ...
    ],
    "first": "https://...",
    "next": "https://...",
    "prev": "https://...",
    "last": "https://..."
    }


#### Use Portable Data Formats in Representations

- **DO** use decimal, float and double data types defined in the W3C XML Schema for formatting numbers including currency.
- **DO** use ISO 3166 codes for countries and dependent territories.
- **DO** use ISO 4217 alphabetic or numeric codes for denoting currency.
- **DO** use RFC 3339 for dates, times, and date-time values used in representations.
- **DO** use BCP 47 language tags for representing the language of text
- **DO** use time zone identifiers from the Olson Time Zone Database to convey time zones.
- **AVOID** using language-, region-, or country-specific formats or format identifiers, except when the text is meant for presentation to end users.

    ### SHOULD:: Date property values should conform to RFC 3399

    ### May: Time durations and intervals could conform to ISO 8601

    ### May: Standards could be used for Language, Country and Currency

    - ISO 3166-1-alpha2 country
    - ISO 639-1 language code
    - BCP-47 (based on ISO 639-1) for language variants
    - ISO 4217 currency codes

    # Data Formats


    ### MUST: Use Standard Date and Time Formats

    Use the HTTP date format defined in RFC 7231.

    ### MAY: Use Standards for Country, Language and Currency Codes

    Use the following standard formats for country, language and currency codes:

    - ISO 3166-1-alpha2 country codes
    - ISO 639-1 language code
    - BCP-47 (based on ISO 639-1) for language variants
    - ISO 4217 currency codes

    ### MUST: Define Format for Type Number and Integer

    Whenever an API defines a property of type number or integer, the precision must be defined by the format as follows to prevent clients from guessing the precision incorrectly, and thereby changing the value unintentionally:

    type	format	specified value range
    integer	int32	integer between -231 and 231-1
    integer	int64	integer between -263 and 263-1
    integer	bigint	arbitrarily large signed integer number
    number	float	IEEE 754-2008/ISO 60559:2011 binary64 decimal number
    number	double	IEEE 754-2008/ISO 60559:2011 binary128 decimal number
    number	decimal	arbitrarily precise signed decimal number

    ### SHOULD:: Use a Decimal for Money/Amount Objects


#### Binary Data in Representations

- **DO** use multipart media types such as `multipart/mixed`, `multipart/related`, or `multipart/alternative`.
- **CONSIDER** providing a link to fetch the binary data as a separate resource as an alternative. Creating and parsing multipart messages in some programming languages may be cumbersome and complex.
- **AVOID** encoding binary data within textual formats using Base64 encoding.

#### Error Representations

- **DO** return a representation with a `4xx` status code, for errors due to client inputs,
- **DO** return a representation with a `5xx` status code, for errors due to server implementation or its current state.
- **DO** include a `Date` header with a value indicating the date-time at which the error occurred.
- **DO** include a body in the representation formatted and localized using content negotiation or in human-readable HTML or plain text, unless the request method is `HEAD`.
- **DO** provide an identifier or a link that can be used to refer to that error, if you are logging errors on the server side for later tracking or analysis.
- **DO** include a brief message describing the error condition
- **DO** include a longer description with information on how to fix the error condition, if applicable
- **DO** describe any action that the client can take to correct the error or to help the server debug and fix the error, if appropriate.
- **CONSIDER** including a link to that document via a `Link` header or a link in the body, if information to correct or debug the error is available as a separate human-readable document.
- **AVOID** including details such as stack traces, errors from database connections failures, etc.
- **DO NOT** return `2xx` (`OK`), but include a message body that describes an error condition. Doing so prevents HTTP-aware software from detecting errors.

<!-- TODO -->


    ### MUST: Do not expose Stack Traces

    Stack traces contain implementation details that are not part of an API, and on which clients should never rely. Moreover, stack traces can leak sensitive information that partners and third parties are not allowed to receive and may disclose insights about vulnerabilities to attackers.

    ### MUST: Use Problem JSON

    RFC 7807 defines the media type application/problem+json. Operations should return that (together with a suitable status code) when any problem occurred during processing and you can give more details than the status code itself can supply, whether it be caused by the client or the server (i.e. both for 4xx or 5xx errors).

    A previous version of this guideline (before the publication of that RFC and the registration of the media type) told to return application/x.problem+json in these cases (with the same contents). Servers for APIs defined before this change should pay attention to the Accept header sent by the client and set the Content-Type header of the problem response correspondingly. Clients of such APIs should accept both media types.

    // Use Descriptive Error Messages
    Again, status codes help developers quickly identify the result of their call, allowing for quick success and failure checks.

     But in the event of a failure, it's also important to make sure the developer understands WHY the call failed.

     This is especially crucial to the initial integration of your API (remember, the easier your API is to integrate, the more likely people are to use it), as well as general maintenance when bugs or other issues come up.
    You'll want your error body to be well formed, and descriptive.

     This means telling the developer what happened, why it happened, and most importantly – how to fix it.

     You should avoid using generic or non-descriptive error messages such as:
    redx   Your request could not be completed
    redx   An error occurred
    redx   Invalid request
    Generic error messages are one of the biggest hinderances to API integration as developers may struggle for hours trying to figure out why the call is failing, even misinterpreting the intent of the error message altogether.

    And eventually, if they can't figure it out, they may stop trying altogether.
    For example, I struggled for about 30 minutes with one API trying to figure out why I was getting a "This call is not allowed" error response.

    After repeatedly reformatting my request and trying different approaches, I finally called support (in an extremely frustrated mood) only to find out it was referring to my access token, which just so happened to be one letter off due to my inability to copy and paste such things.
    Just the same, an "Invalid Access Token" response would have saved me a ton of hassle, and from feeling like a complete idiot while on the line with support.

     It would have also saved them valuable time working on real bugs, instead of trying to troubleshoot the most basic of steps (btw – whenever I get an error the key and token are the first things I check now).
    Here are some more examples of descriptive error messages:
    greencheckmark   Your API Key is Invalid, Generate a Valid API Key at http://...
    greencheckmark   A User ID is required for this action.

    Read more at http://...
    greencheckmark   Your JSON was not properly formed.

    See example JSON here: http://...
    But you can go even further, remember- you'll want to tell the developer what happened, why it happened, and how to fix it.

     One of the best ways to do that is by responding with a standardized error format that returns a code (for support reference), the description of what happened, and a link to the appropriate documentation so that they can learn more/ fix it:

    ```json
    {
      "error" : {
        "code" : "e3526",
        "message" : "Missing UserID",
        "description" : "A UserID is required to edit a user.",
        "link" : "http://docs.mysite.com/errors/e3526/"
      }
    }
    ```

    On a support and development side, by doing this you can also track the hits to these pages to see what areas tend to be more troublesome for your users – allowing you to provide even better documentation/ build a better API.
    Use HTTP Status Codes and Error Responses
        Field Validation Errors
        Operational Validation Errors

    Updates & creation should return a resource representation

    Validation errors for PUT, PATCH and POST requests will need a field breakdown. This is best modeled by using a fixed top-level error code for validation failures and providing the detailed errors in an additional errors field, like so:


    {
      "code" : 1024,
      "message" : "Validation Failed",
      "errors" : [
        {
          "code" : 5432,
          "field" : "first_name",
          "message" : "First name cannot have fancy characters"
        },
        {
           "code" : 5622,
           "field" : "password",
           "message" : "Password cannot be blank"
        }
      ]
    }

    ### MUST: Provide Error Documentation

    APIs should define the functional, business view and abstract from implementation aspects. Errors become a key element providing context and visibility into how to use an API. The error object should be extended by an application-specific error identifier if and only if the HTTP status code is not specific enough to convey the domain-specific error semantic. For this reason, we use a standardized error return object definition — see Use Common Error Return Objects.

    The OpenAPI specification shall include definitions for error descriptions that will be returned; they are part of the interface definition and provide important information for service clients to handle exceptional situations and support troubleshooting. You should also think about a troubleshooting board — it is part of the associated online API documentation, provides information and handling guidance on application-specific errors and is referenced via links of the API definition. This can reduce service support tasks and contribute to service client and provider performance.

    Service providers should differentiate between technical and functional errors. In most cases it's not useful to document technical errors that are not in control of the service provider unless the status code convey application-specific semantics. The list of status code that can be omitted from API specifications includes but is not limited to:

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
    502 Bad Gateway
    503 Service Unavailable
    504 Gateway Timeout
    Even though they might not be documented - they may very much occur in production, so clients should be prepared for unexpected response codes, and in case of doubt handle them like they would handle the corresponding x00 code. Adding new response codes (specially error responses) should be considered a compatible API evolution.

    Functional errors on the other hand, that convey domain-specific semantics, must be documented and are strongly encouraged to be expressed with Problem types.


### HTML Representations

- **DO** provide HTML representations, for resources that are expected to be consumed by end users.
- **CONSIDER**  using microformats or RDFx to annotate data within the markup.
- **AVOID** avoid designing HTML representations for machine clients.

### HTTP Status Codes

    # Use HTTP Status Codes

    One of the most commonly misused HTTP Status Codes is 200 – ok or the request was successful.

     Surprisingly, you'll find that a lot of APIs use 200 when creating an object (status code 201), or even when the response fails:

    In the above case, if the developer is solely relying on the status code to see if the request was successful, the program will continue on not realizing that the request failed, and that it did something wrong.

     This is especially important if there are dependencies within the program on that record existing.

     Instead, the correct status code to use would have been 400 to indicate a "Bad Request."
    By using the correct status codes, developers can quickly see what is happening with the application and do a "quick check" for errors without having to rely on the body's response.
    You can find a full list of status codes in the [HTTP/1.1 RFC](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html), but just for a quick reference, here are some of the most commonly used Status Codes for RESTful APIs:
    200	Ok
    201	Created
    304	Not Modified
    400	Bad Request
    401	Not Authorized
    403	Forbidden
    404	Page/ Resource Not Found
    405	Method Not Allowed
    415	Unsupported Media Type
    500	Internal Server Error
    Of course, if you feel like being really creative, you can always take advantage of status code:
    418	I'm a Teapot
    It's important to note that Twitter's famed 420 status code – Enhance Your Calm, is not really a standardized response, and you should probably just stick to status code 429 for too many requests instead.

    ### MUST: Use Specific HTTP Status Codes

    This guideline groups the following rules for HTTP status codes usage:

    You must not invent new HTTP status codes; only use standardized HTTP status codes and consistent with its intended semantics.
    You should use the most specific HTTP status code for your concrete resource request processing status or error situation.
    You should provide good documentation in the API definition when using HTTP status codes that are less commonly used and not listed below.
    There are ~60 different HTTP status codes with specific semantics defined in the HTTP standards (mainly RFC7231 and RFC-6585) - and there are upcoming new ones, e.g. draft legally-restricted-status (see overview on all error codes on Wikipedia or via https://httpstatuses.com/). And there are unofficial ones, e.g. used by specific web servers like Nginx.

    Our list of most commonly used and best understood HTTP status codes:

    Success Codes

    Code	Meaning	Methods
    200	OK - this is the standard success response	All
    201	Created - Returned on successful entity creation. You are free to return either an empty response or the created resource in conjunction with the Location header. (More details found in the Common Headers section.) Always set the Location header.	POST, PUT
    202	Accepted - The request was successful and will be processed asynchronously.	POST, PUT, DELETE, PATCH
    204	No content - There is no response body	PUT, DELETE
    207	Multi-Status - The response body contains multiple status informations for different parts of a batch/bulk request. See "Use 207 for Batch or Bulk Requests".	POST
    Redirection Codes

    Code	Meaning	Methods
    301	Moved Permanently - This and all future requests should be directed to the given URI.	All
    303	See Other - The response to the request can be found under another URI using a GET method.	PATCH, POST, PUT, DELETE
    304	Not Modified - resource has not been modified since the date or version passed via request headers If-Modified-Since or If-None-Match.	GET
    Client Side Error Codes

    Code	Meaning	Methods
    400	Bad request - generic / unknown error	All
    401	Unauthorized - the users must log in (this often means "Unauthenticated")	All
    403	Forbidden - the user is not authorized to use this resource	All
    404	Not found - the resource is not found	All
    405	Method Not Allowed - the method is not supported, see OPTIONS	All
    406	Not Acceptable - resource can only generate content not acceptable according to the Accept headers sent in the request	All
    408	Request timeout - the server times out waiting for the resource	All
    409	Conflict - request cannot be completed due to conflict, e.g. when two clients try to create the same resource or if there are concurrent, conflicting updates	PUT, DELETE, PATCH
    410	Gone - resource does not exist any longer, e.g. when accessing a resource that has intentionally been deleted	All
    412	Precondition Failed - returned for conditional requests, e.g. If-Match if the condition failed. Used for optimistic locking.	PUT, DELETE, PATCH
    415	Unsupported Media Type - e.g. clients sends request body without content type	PUT, DELETE, PATCH
    423	Locked - Pessimistic locking, e.g. processing states	PUT, DELETE, PATCH
    428	Precondition Required - server requires the request to be conditional (e.g. to make sure that the "lost update problem" is avoided).	All
    429	Too many requests - the client does not consider rate limiting and sent too many requests. See "Use 429 with Headers for Rate Limits".	All
    Server Side Error Codes:

    Code	Meaning	Methods
    500	Internal Server Error - a generic error indication for an unexpected server execution problem (here, client retry may be senseful)	All
    501	Not Implemented - server cannot fulfill the request (usually implies future availability, e.g. new feature).	All
    503	Service Unavailable - server is (temporarily) not available (e.g. due to overload) -- client retry may be senseful.	All

    ### MUST: Use 207 for Batch or Bulk Requests

    Some APIs are required to provide either batch or bulk requests using POST for performance reasons, i.e. for communication and processing efficiency. In this case services may be in need to signal multiple response codes for each part of an batch or bulk request. As HTTP does not provide proper guidance for handling batch/bulk requests and responses, we herewith define the following approach:

    A batch or bulk request always has to respond with HTTP status code 207, unless it encounters a generic or unexpected failure before looking at individual parts.
    A batch or bulk response with status code 207 always returns a multi-status object containing sufficient status and/or monitoring information for each part of the batch or bulk request.
    A batch or bulk request may result in a status code 400/500, only if the service encounters a failure before looking at individual parts or, if an unanticipated failure occurs.
    The before rules apply even in the case that processing of all individual part fail or each part is executed asynchronously! They are intended to allow clients to act on batch and bulk responses by inspecting the individual results in a consistent way.

    Note: while a batch defines a collection of requests triggering independent processes, a bulk defines a collection of independent resources created or updated together in one request. With respect to response processing this distinction normally does not matter.

    ### MUST: Use 429 with Headers for Rate Limits

    APIs that wish to manage the request rate of clients must use the '429 Too Many Requests' response code if the client exceeded the request rate and therefore the request can't be fulfilled. Such responses must also contain header information providing further details to the client. There are two approaches a service can take for header information:

    Return a 'Retry-After' header indicating how long the client ought to wait before making a follow-up request. The Retry-After header can contain a HTTP date value to retry after or the number of seconds to delay. Either is acceptable but APIs should prefer to use a delay in seconds.

    Return a trio of 'X-RateLimit' headers. These headers (described below) allow a server to express a service level in the form of a number of allowing requests within a given window of time and when the window is reset.

    The 'X-RateLimit' headers are:

    X-RateLimit-Limit: The maximum number of requests that the client is allowed to make in this window.
    X-RateLimit-Remaining: The number of requests allowed in the current window.
    X-RateLimit-Reset: The relative time in seconds when the rate limit window will be reset.
    The reason to allow both approaches is that APIs can have different needs. Retry-After is often sufficient for general load handling and request throttling scenarios and notably, does not strictly require the concept of a calling entity such as a tenant or named account. In turn this allows resource owners to minimise the amount of state they have to carry with respect to client requests. The 'X-RateLimit' headers are suitable for scenarios where clients are associated with pre-existing account or tenancy structures. 'X-RateLimit' headers are generally returned on every request and not just on a 429, which implies the service implementing the API is carrying sufficient state to track the number of requests made within a given window for each named entity.


Always return meaningful HTTP Status Codes.

#### Errors due to client inputs: `4xx`

- **DO** return `400 Bad Request` when your server cannot decipher client requests because of syntactical errors.
- **DO** return `401 Unauthorized` when the client is not authorized to access the resource, but may be able to gain access after authentication. If your server will not let the client access the resource even after authentication return `403 Forbidden` instead. When returning this error code, include a WWW-Authenticate header field with the authentication method to use. [See **Chapter 12**]
- **DO** return `403 Forbidden` when your serer will not let the client gain access (authenticated or not).
- **DO** return `404 Not Found` when the resource is not found. If possible, return a reason in the message body.
- **DO** return `405 Not Allowed` when an HTTP method is not allowed. Return an `Allow` header with methods that are valid for the resource. [**See 14.2**]
- **DO** return `406 Not Acceptable` [**See 7.7**]
- **DO** return `409 Conflict` when the request conflicts with the current state of the resource. Include a body explaining the reason.
- **DO** return `410 Gone` when the resource used to exist, but it does not anymore. You may not be able to return this unless you tracked deleted resources, then return `404 Not Found`.
- **DO** return `412 Precondition Failed` [**See 10.4**]
- **DO** return `413 Request Entity Too Large` when the body of a `POST` or `PUT` is too large. If possible, specify what is allowed in the body and provide alternatives.
- **DO** return `415 Unsupported Media Type` when a client sends the message body in a form that the server does not understand.

#### Errors due to server errors: `5xx`

- **DO** return `500 Internal Server Error` when your code on the server side failed due to come implementation bug.
- **DO** return `503 Service Unavailable` when the server cannot fulfill the request either for some specific interval or undetermined amount of time. If possible, include a `Retry-After` response header with either a date or a number of seconds as a hint.

### How to Treat Errors in Clients

- **DO** treat `400 Bad Request` by looking into the body of the error representation for hints for the root cause of the problem.
- **DO** retry the request on `401 Unauthorized` responses with the `Authorization` header containing the credentials. If the client is user-facing, prompt the user to supply credentials. In other cases, obtain the necessary security credentials.
- **DO NOT** repeat the request on `403 Forbidden`
- **DO** clean up client stored data on `404 Not Found`
- **DO** Look for the `Allow` header for valid methods on `405 Not Allowed`
- **DO** `406 Not Acceptable` [**See 7.7**]
- **DO** treat `409 Conflict` by looking for the conflicts listed in the body of the representation of `PUT`
- **DO** treat `410 Gone` the same as `404 Not Found`.
- **DO** `412 Precondition Failed` **See 10.4**
- **DO** look for hints on valid size in the body of the error on `413 Request Entity Too Large`
- **DO** see the body of the representation to learn the supported media types for the request on `415 Unsupported Media Type`
- **DO** log the error, and then notify the server developers of `500 Internal Server Error`
- **DO** check the response of `503 Service Unavailable` for a `Retry-After` header, avoid retrying until that period of time (back-off logic).
- **DO NOT** treat HTTP errors as I/O or network exceptions. Treat them as first-class application objects.

### Entity Identifiers in Representations

<!-- TODO -->

    When a client or a server is part of a larger heterogeneous set of applications, information from resources may cross several system boundaries, and identifiers can be used to cross-reference or transform data.

    For each of the application domain entities included in the representation of a resource, include identifiers formatted as URNs.

    Entity identifiers can come in handy for the following:

    - When your clients and servers are part of a larger environment containing applications using RPC, SOAP, asynchronous messaging, stored procedures, and even third-party applications, entity identifiers may be the only common denominator across all those systems to provide the identity of data uniformly.
    - Clients and servers can maintain their own stored copies of entities included in a resource without having to decode from resource URIs or having to use URIs as database keys. Although not ideal, URIs may change. Clients can use these identifiers to cross-reference various entities referred to form different representations.
    - When not all entities in your application domain are mapped to resources.

    To maintain uniqueness of identifiers, consider formatting identifiers as URNs.

    ### SHOULD:: Only Use UUIDs If Necessary

    Generating IDs can be a scaling problem in high frequency and near real time use cases. UUIDs solve this problem, as they can be generated without collisions in a distributed, non-coordinated way and without additional server roundtrips.

    However, they also come with some disadvantages:

    - pure technical key without meaning; not ready for naming or name scope conventions that might be helpful for pragmatic reasons, e.g. we learned to use names for product attributes, instead of UUIDs
    - less usable, because...
    - cannot be memorized and easily communicated by humans
    - harder to use in debugging and logging analysis
    - less convenient for consumer facing usage
    - quite long: readable representation requires 36 characters and comes with higher memory and bandwidth consumption
    - not ordered along their creation history and no indication of used id volume
    - may be in conflict with additional backward compatibility support of legacy ids

    UUIDs should be avoided were not needed for large scale id generation. Instead, for instance, server side support with id generation can be preferred (POST on id resource, followed by idempotent PUT on entity resource). Usage of UUIDs is especially discouraged as primary keys of master and configuration data, like brand-ids or attribute-ids which have low id volume but widespread steering functionality.

    In any case, we should always use string rather than number type for identifiers. This gives us more flexibility to evolve the identifier naming scheme. Accordingly, if used as identifiers, UUIDs should not be qualified using a format property.

    > Hint: Usually, random UUID is used - see UUID version 4 in RFC 4122. Though UUID version 1 also contains leading timestamps it is not reflected by its lexicographic sorting. This deficit is addressed by ULID (Universally Unique Lexicographically Sortable Identifier). You may favour ULID instead of UUID, for instance, for pagination use cases ordered along creation time.

### Linking and Application State

<!-- TODO -->

    <!--
    HATEOS / HAL / JSONAPI etc.
    -->

    A link provides a mean to navigate from one resource to another.

    Application state is the state the server needs to maintain between each request for each client. Keeping state in clients does not mean serializing session state into URIs or HTML forms.

    If the amount of data is small, the best place to maintain application state is within links in representations of resources, where the server can encode the state within the URI itself. However, the server can stores data in a durable storage and encodes its primary key in the URI. Use a combination of both approaches for managing application state to strike a balance between network performance, scalability and reliability.

    ```
    HTTP/1.1 200 OK
    Content-Type: application/xml;charset=UTF-8

    <quote xmlns:atom="http://www.w3.org/2005/Atom">
        <driver>...</driver>
        <vehicle>...</vehicle>
        <offer>
            <valid-until>2009-10-02</valid-until>
            <atom:link href="http://www.example.org/quotes/buy?quote=abc1234" rel="http://www.example.org/rels/quotes/buy" />
        </offer>
    </quote>
    ```

- **DO** encode application state into URIs, and include those URIs into representations via links.
- **DO** store the application state in a durable storage, and encode a reference to that state in URIs, if the state is large or cannot be transported to the clients for security or privacy reasons.
- **DO** make sure to add checks (such as signatures) to detect/prevent tampering of state, when using application state in links. [**Chapter 12**]

<!-- TODO -->
    #### *Links in XML Representations*

    *[Atom](http://www.w3.org/2005/Atom)*

#### Links in JSON Representations


- **DO** use a `link` property or a `links` property to include several links as an array whose value is a link object or a link object array.
- **DO** include `href` and `rel` properties in each link object

Examples:

```json
{
    "link": {
        "rel": "alternate",
        "href": "http://www.example.org/customers?format=json"
    }
}
```

```json
{
    "link": {
        "alternate": "http://www.example.org/customers?format=json"
    }
}
```

```json
{
    "links": [{
        "rel": "alternate",
        "href": "http://www.example.org/customers?format=json"
    },
    {
        "rel": "http://www.example.org/rels/owner",
        "href": "..."
    }]
}
```

```json
{
    "links": {
        "alternate": "http://www.example.org/customers?format=json"
        "http://www.example.org/rels/owner": "http://www.example.org/owner"
    }
}
```

#### Link Header

The `Link` header provides a format-independent means to convey links, which is one of the key benefits, along with visibility at the protocol level. Also the need for documentation on how to discover links in XML or JSON representations is lowered.

```
# Link header format
Link: <{URI}>;rel="{relation}";type="{media type"};title="{title}"...
```

- **DO** use link header when you want to convey links in a format-independent manner
- **DO** use link header when a representation format does not support links. E.g.:
   - Binary format
   - Formats that do not allow for easy discovery of links (e.g., plain-text documents)
   - When your client/server software needs to add links or read links without parsing the body of representations

#### Link Relation Types

- **ALWAYS** supply a link relation to act as an identifier for the semantics associated with the link
- **ALWAYS** use URIs (such as http://www.example.org/rels/create-po) to express extended link relation types
- **DO** choose unambiguous value of link relations
- **DO** use one of the [standard relation types](http://www.iana.org/assignments/link-relations/link-relations.xhtml), when appropriate
- **DO** use lowercase for all link relation types
- **DO** use multiple values in link relations, if applicable
- **CONSIDER** providing an informational resource as an HTML document at that URI, describing the semantics of the link relation type. Include details such as HTTP methods supported, formats supported, and business rules about using the link.

> Link relation types meant for public use should register that link relation per the process outlined in section 6.2 of the Web Linking Internet-Draft.

#### Managing Application Flow with Links

One of the key applications of hypermedia and links is the ability to decouple the client from learning about the rules the server uses to manage its application flow. The server can provide links containing application state, thereby using Hypermedia As The Engine Of Application State.

This prevents clients from having to learn and hard-code application flow, however, the mere presence of a link will not decouple the client from having to know how to prepare the data and make a request for the transition.

- **DO** design representations such that it contain links that help clients transition to all the next possible steps
- **DO** encode the state that needs to be carried forward in the links
- **DO** document how to find links and the semantics of all extended link relation types.
- **DO**, for clients, assume that absent links means the transition is not possible.

#### Ephemeral URIs

A URI may be temporary and valid only for a single use or may expire after a fixed period of time.

- **DO** communicate ephemeral URIs via links.
- **DO** assign extended relation types for those links and document how long such URIs are valid and what the client should do after expiry.
- **DO** return appropriate `4xx` code when responding to expired URIs, with an instructions in the body of any actions the client can take.

#### URI Template

When the server does not have all the information necessary to generate a valid and complete URI for each link.

A URI template is a string consisting of token marked off between matching braces (`{` and `}`). Clients substitute these tokens (including matching braces) with URI-safe strings to convert the template into a valid URI.

For simplicity limit the tokens to the following parts of URIs:

- Path segments
- Values of query parameters
- Values of matrix parameters

To include URI templates in a representation:

- **DO** use `link-template` or `link-templates` properties to convey URI templates, for JSON representations.
- **DO** document the tokens used in you URI template, since URI templates are semi-opaque and contain tokens that clients need to substitute, and you need a way to tell clients what values are valid for each token.
- **CONSIDER** using braces (`{` and `}`) to specify replacement tokens, as this a common standard in a lot of other templating system (e.g., WSDL 2.0 and WADL.

```json
// JSON representation
{
    "link-templates": [{
        "rel": "http://www.example.org/rels/customer",
        "href": "http://www.example.org/customer/{customer-id}"
    }]
}
```

#### Using Links in Clients

- **DO** extract URIs and URI templates from links based on known link relation types. These links along with other resource data constitute the current state of the application.
- **DO** store the URIs and the relation type along with other representation data, if the application is long running.
- **DO** make flow decisions based on the presence or absence of links.
- **DO** store the knowledge of whether a representation contains a given link.
- **DO** check the documentation of the link relation to learn any associated business rules regarding authentication, permanence of the URI, methods, and media types supported, etc.



## Content Negotiation (conneg)

There are two types of content negotiation:

- *Server-driven* negotiation, uses request headers to select a variant
- *Agent-driven* negotiation, uses a distinct URI for each variant

### Server-Driven Negotiation

- **DO** support multiple variants only when your clients need them.
- **DO** support multiple variants only when each variant contains the same information
- **DO NOT** use server-driven negotiation when the information content is different, use [agent-driven negotiation](#agent-driven-negotiation) instead.

#### Indicating Client Preferences

It is important for the client to indicate its preferences and capabilities to the server, including:

- representation formats
- languages
- character encoding
- support for compression.

Even when you know out of band this information, clearly indicating the client's preferences and capabilities can help the client in the face of change. It is better to ask for a specific representation instead of getting a default one, because the default can change.

When making a request:

- **DO** add an `Accept` header with a comma-separated list of media type preferences. If the client prefers one media type over the other, add a `q` parameter with each media type.
- **DO** add `*;q=0.0` in the `Accept` header to indicate to the server it cannot process anything other than the media types listed in the `Accept` header, if the client can process only certain formats.
- **DO** add an `Accept-Charset` header with the preferred character set, if the client can process characters of a specific character set only, if not, avoid adding this header
- **DO** add an `Accept-Language` header for the preferred language of the representation.
- **DO** add an `Accept-Encoding` header listing the supported encodings,if the client is able to decompress representations compressed encoding such as `gzip`, `compress`, or `deflate`, add an `Accept-Encoding` header listing the supported encodings, if not, skip this header
- **DO NOT** assume that servers support content negotiation, and be prepared to receive a representation that does not meet the `Accept-*` headers.

#### Content Type Negotiation

*content negotiation (include or exclude and force to e.g. json)?*

- **DO** return a representation using the default format, if the request has no `Accept` header.
- **DO** parse the header, sort the values of media types by the `q` parameters in descending order, if the request has an `Accept` header, then select a media type from the list that the server supports.
- **DO** handle [content negotiation failures](#7.7) to determine an appropriate response
- **CONSIDER** including a `Vary` (see [Vary](#vary)) response header [**See 7.6**]
- **CONSIDER** using [*agent-driven negotiation*](#agent-driven-negotiation), if the server starts out ignoring `Accept`, e.g. by returning `Content-Type: application/xml` for `Accept: application/json` requests, adding content negotiation (here by adding `Content-Type: application/json`) will likely break compatibility for working clients.

#### Language Negotiation

- **DO** return a representation with all human-readable text in a default language, if the request has no `Accept-Language` header.
- **DO** parse the header, sort the languages by the `q` parameters in descending order, and select the first language in the list that the server can support, if the request has an `Accept-Language` header
- **DO** use a default language for the response, if the server does not support any languages in the list, and the `Accept-Language` header does not contain `*;q=0.0`.
- **CONSIDER** including a `Vary` (see [The Vary Header](#the-vary-header)) response header.

This approach is best suited when representations in different languages differ only in terms of the language used for any human-readable text. If the differences between representations are more significant, use other means of localization such as the client's IP address or region/language-specific URIs.

#### Character Encoding Negotiation

- **DO** encode the textual representation of the response using the encoding the client ask for via the `Accept-Charset` header. Encoding the response using that encoding promotes interoperability.
- **DO** return a representation using `UTF-8` encoding, if the request has no `Accept-Charset` header.
- **DO** parse the header, sort the character set by the `q` parameters in descending order, and select the first character set that the server can support for encoding.
- **DO** return a representation using `UTF-8` encoding, if the server does not support any requested character set and the `Accept-Charset` header does not contain `*;q=0.0`.
- **DO** include the `charset` parameter in the `Content-Type` header, in all cases, if the media type is textual and allows a `charset` parameter.
- **CONSIDER** including a `Vary` (see [The Vary Header](#the-vary-header)) response header.
- **AVOID** using `text/xml` since its default encoidng is `us-ascii`.

#### Supporting Compression

To support compression or *content encoding*:

- **DO** use the compression technique from the `Accept-Encoding` header, if the server is capable of compressing the response body.
- **DO** parse the header, sort the character set by the `q` parameters in descending order, and select the first content encoding the server supports.
- **DO** ignore this header, if no encoding in this header matches the server's supported encodings.
- **CONSIDER** including a `Vary` (see [The Vary Header](#the-vary-header)) response header.
- **DO NOT** compress representations, if the request has no `Accept-Encoding` header.

#### The Vary Header

When a server uses content negotiation to select a representation, the same URI can yield different representations based on `Accept-*` headers. The `Vary` header tells clients which request headers the server used when selecting a representation. Caches may use the `Vary` header as part of cache keys to maintain variants of a resource.

- **CONSIDER** including a `Vary` header whenever multiple representations are available for a resource. The value of this header is a comma-separated list of *request headers* the server uses when choosing representation.
- **CONSIDER** including a `Vary` header with a value of `*`, if the server uses information other then the headers in the request, such as a client's IP address, time of day, user personalization, etc.

#### Negotiation Failures

- **CONSIDER** that servers are free to serve any available representation for a given resource. However, clients may not be able to handle arbitrary media types.
- **DO** return `406 Not Acceptable` with either the body of the representation containing the list of representations, or a `Link` in the header, when the server cannot serve a representation that meets the client's preferences and if the client explicitly included a `*;q=0.0`.
- **DO** serve the representation without applying any content encoding, if the server is unable to support the requested `Accept-Encoding` value.

### Agent-Driven Content Negotiation

Although server-driven negotiation is built into HTTP, it has limitations:

- Content negotiation does not include elements such as currency units, distance units, date formats, and other regional flavors for any human-readable text in representations.
- In some cases, because of complex localization requirements, the server may decide to maintain different resources for different locales.

Agent-driven negotiation simply mean providing distinct URIs for each variant and allow the client to use that URI to select the desired representation.

- **CONSIDER** using agent-driven negotiation when the client cannot communicate its preferences using `Accept-*` headers.
- **CONSIDER** using one or more of these common approaches:
   - Query parameters, like `http://www.example.org/status?format={format}`
   - URI extensions, appending a dot (`.`) and a shorthand media type to the base URI. Like `http://www.example.org/status.json`
   - Subdomains, like `http://dk.example.org/status`
- **CONSIDER** letting the server advertise alternatives using links with the `alternate` link relation type, when using agent-driven negotiation.
- **DO** use out-of-band information from the server to determine which URI to use. If the representation exists, the server returns it, if not, it return `404 Not Found`.

Although it is possible to implement agent-driven negotiation for all `Accept-*` headers, in practice it is most commonly used for media types and languages.



## Caching and Conditional Requests

    <!-- TODO -->

    - 9.1. How to set Expiration Caching Headers
    - 9.2. When to set Expiration Caching Headers
    - 9.3. When and how to use Expiration Headers in Clients
    - 9.4. How to Support Caching for Composite Resources
    - 9.5. How to Keep Caches Fresh and Warm
    - 10.1. How to Generate `Last-Modified` and `ETag` Headers
    - 10.2. How to Implement Conditional `GET` Requests in Servers
    - 10.3. How to Submit Conditional `GET` and `HEAD` Requests from Clients
    - 10.4. How to Implement Conditional `PUT` Requests in Servers
    - 10.5. How to Implement Conditional `DELETE` Requests in Servers
    - 10.6. How to Make Unconditional `GET` Requests from Clients
    - 10.7. How to Submit Conditional `PUT` and `DELETE` Requests from Clients
    - 10.8. How to Make `POST` Requests Conditional
    - 10.9. How to Generate One-Time URIs

## Security

    <!-- TODO -->

    ## Security

    ### MUST: Secure Endpoints with OAuth 2.0

    <!--
    Out-of-band authentication
    CORS

    Use Access and Refresh Tokens
        Access Tokens
        Refresh Tokens
        Logging In
        Renewing a Token
        Validating a Token
        Terminating a Session
        Keep JWTs Small

    Always use SSL. No exceptions. One thing to watch out for is non-SSL access to API URLs. Do not redirect these to their SSL counterparts. Throw a hard error instead!

    A RESTful API should be stateless. This means that request authentication should not depend on cookies or sessions. Instead, each request should come with some sort authentication credentials.

    -->

    # Security.

    Security.

    Security.
    An API Manager should also be designed to handle security, not just by validating a boarding pass (API key) and directing them to their appropriate gate (permissions, SLA tier), but your API Manager should watch out for other dangerous threats, such as malicious IPs, DDoS, content threats (such as with JSON or XML), and others.
    It should also be designed to work with your current user validation systems such as OAuth2 to help protect your user's sensitive data (such as their username and password) within your API.

     Keep in mind that even the most righteous of applications are still prone to being hacked – and if they have access to your user's sensitive data, that means that hackers might get access to it too.

     It's always better to never have your users expose their credentials through the API (such as with basic auth) but instead rely on your website to handle logins and then return back an access token as OAuth2 does.

    ## But... Security is Hard

    One of my favorite talks, by Anthony Ferrara sums this up very nicely...  Don't do it.

     Leave it for the Experts.

     Granted, his talk was specifically on encryption, but there's a lot of careful thought, planning, and considerations that need to be taken when building an API Management tool.

     You can certainly build it yourself, and handling API keys or doing IP white-listing/ black-listing is fairly easy to do.

     However, like an airport, what you don't see is all of the stuff happening in the background, all the things being monitored carefully, security measures implemented by experts with years of experience in risk mitigation.
    For that reason, as tempting as it might be to build one yourself, I would strongly encourage you to take a look at a professional API Management company- such as MuleSoft (of course, I might be a little biased).
    - 12.1. How to use Basic Authentication to Authenticate Clients
    - 12.2. How to use Digest Authentication to Authenticate Clients
    - 12.3. How to use Three-Legged OAuth
    - 12.4. How to use Two-Legged OAuth
    - 12.5. How to Deal with Sensitive Information in URIs
    - 12.6. How to Maintain the Confidentiality and Integrity of Representations

## 13. Versioning and Extensibility

    <!-- TODO -->

    <!-- 
    versioning
        Use API Versioning
    what is a breaking change
    breaking changes

    http://www.jenitennison.com/2009/07/22/versioning-uris.html

    A lot of things that we want to talk about (make RDF assertions about) are non-information resources. We give them URIs to name them, so that we can talk about them unambiguously, and we give them HTTP URIs so that we have a way of finding information resources (documents) that give us information about them.

    non-information resource URIs must not include information that is likely to change
    non-information resource URIs must not include unnecessary hierarchy


    Always version your API. Versioning helps you iterate faster and prevents invalid requests from hitting updated endpoints. It also helps smooth over any major API version transitions as you can continue to offer old API versions for a period of time.
    However, the version needs to be in the URL to ensure browser explorability of the resources across versions
    Well documented and announced multi-month deprecation schedules can be an acceptable practice for many APIs.
    https://stripe.com/docs/api#versioning

    -->

    - Like building an application it is important to keep your API standardized and extensible.
    - It's easy to want to add "quick fixes" to make customers happy, but everything you do should be carefully thought out in order to make sure your API continues to serve not only your needs, but also your clients.
    - Remember, when you create an API you are creating a contract- your users are depending on your API not just to make their application work, but in order to make a living and feed their families.
    - When you break things, or when you break backwards compatibility you are taking their time and resources to fix their application instead of adding features and keeping their customers happy.

    The industry solution to this has been versioning, however, versioning is merely a Band-Aid, a temporary solution to make migration to the new system less stressful for your clients, but increasingly difficult on you.

    Keep in mind, when you have multiple versions of your API you end up supporting and maintaining those versions.

    One of the greatest challenges in regards to versioning is getting developers to migrate from one version to another, all while keeping your support staff from going insane.

    This doesn't mean that you shouldn't plan for versioning.

    Rather it means that you should plan to incorporate a version identifier (either in the URI or in the content-header of the response), but work under the mindset that you will only version your API if...

    - You have backwards incompatible PLATFORM changes – in other words you completely change the UI or way your platform works
    - You find that your API is no longer extendable – which is exactly what we are trying to avoid here
    - You find that your spec no longer meets your developer's needs – for example, they are demanding REST instead of SOAP

    You should NOT version your API just because:

    - You added additional endpoints
    - You added additional data in the response
    - You changed technologies – your API should be decoupled from your technology stack
    - You changed your applications services or code – your API should be decoupled from your service layer

    To clarify on the last two, it shouldn't matter what technologies you are using, or how your services work.

    The API should interact with both, but be decoupled enough that changing something in the background does not effect the API adversely.

    Any changes you make to your API in regards to the technology or service layer should be as seamless and transparent as possible.

    After all, the less you can break backwards compatibility, the happier you, and your customers will be.

    And this can only happen if you go into building your API with a long-term, flexibility, and extensibility focus.

    - 13.1. How to Maintain URI Compatibility
    - 13.2. How to Maintain Compatibility of XML and JSON Representations
    - 13.3. How to Extend Atom
    - 13.4. How to Maintain Compatibility of Links
    - 13.5. How to Implement Clients to Support Extensibility
    - 13.6. When to Version
    - 13.7. How to Version RESTful Web Services

    # Compatibility

    ### MUST: Don't Break Backward Compatibility

    Change APIs, but keep all consumers running.

    Consumers usually have independent release life-cycles, focus on stability, and avoid changes that do not provide additional value. APIs are contracts between service providers and service consumers that cannot be broken via unilateral decisions.

    There are two techniques to change APIs without breaking them:

    - follow rules for compatible extensions
    - introduce new API versions and still support older versions

    We strongly encourage using compatible API extensions and discourage versioning. The below guideline rules for service providers and consumers enable us (having Postel's Law in mind) to make compatible changes without versioning.

    Hint: Please note that the compatibility guarantees are for the "on the wire" format. Binary or source compatibility of code generated from an API definition is not covered by these rules. If client implementations update their generation process to a new version of the API definition, it has to be expected that code changes are necessary.

    ### SHOULD:: Prefer Compatible Extensions

    API designers should apply the following rules to evolve RESTful APIs for services in a backward-compatible way:

    - Add only optional, never mandatory fields.
    - Never change the semantic of fields (e.g. changing the semantic from customer-number to customer-id, as both are different unique customer keys)
    - Input fields may have (complex) constraints being validated via server-side business logic. - - Never change the validation logic to be more restrictive and make sure that all constraints a clearly defined in description.
    - Enum ranges can be reduced when used as input parameters, only if the server is ready to accept and handle old range values too. Enum range can be reduced when used as output parameters.
    - Enum ranges cannot not be extended when used for output parameters — clients may not be prepared to handle it. However, enum ranges can be extended when used for input parameters.
    - Support redirection in case an URL has to change (301 Moved Permanently).

    ### MUST: Prepare Clients To Not Crash On Compatible API Extensions

    Service clients should apply the robustness principle:

    - Be conservative with API requests and data passed as input, e.g. avoid to exploit definition eficits like passing megabytes for strings with unspecified maximum length.
    - Be tolerant in processing and reading data of API responses, more specifically...

    Service clients must be prepared for compatible API extensions of service providers:

    - Be tolerant with unknown fields in the payload (see also Fowler's "TolerantReader" post), i.e. ignore new fields but do not eliminate them from payload if needed for subsequent PUT requests.
    - Be prepared to handle HTTP status codes not explicitly specified in endpoint definitions. Note also, that status codes are extensible. Default handling is how you would treat the corresponding x00 code (see RFC7231 Section 6).
    - Follow the redirect when the server returns HTTP status 301 Moved Permanently.

    ### SHOULD:: Design APIs Conservatively

    Designers of service provider APIs should be conservative and accurate in what they accept from clients:

    - Unknown input fields in payload or URL should not be ignored; servers should provide error feedback to clients via an HTTP 400 response code.
    - Be accurate in defining input data constraints (like formats, ranges, lengths etc.) — and check constraints and return dedicated error information in case of violations.
    - Prefer being more specific and restrictive (if compliant to functional requirements), e.g. by defining length range of strings. It may simplify implementation while providing freedom for further evolution as compatible extensions.

    Not ignoring unknown input fields is a specific deviation from Postel's Law (e.g. see also
    The Robustness Principle Reconsidered) and a strong recommendation. Servers might want to take different approach but should be aware of the following problems and be explicit in what is supported:

    Ignoring unknown input fields is actually not an option for PUT, since it becomes asymmetric with subsequent GET response and HTTP is clear about the PUT "replace" semantics and default round-trip expectations (see RFC7231 Section 4.3.4). Note, accepting (i.e. not ignoring) unknown input fields and returning it in subsequent GET responses is a different situation and compliant to PUT semantics.

    Certain client errors cannot be recognized by servers, e.g. attribute name typing errors will be ignored without server error feedback. The server cannot differentiate between the client intentionally providing an additional field versus the client sending a mistakenly named field, when the client's actual intent was to provide an optional input field.
    Future extensions of the input data structure might be in conflict with already ignored fields and, hence, will not be compatible, i.e. break clients that already use this field but with different type.

    In specific situations, where a (known) input field is not needed anymore, it either can stay in the API definition with "not used anymore" description or can be removed from the API definition as long as the server ignores this specific parameter.

    ### MUST: Always Return JSON Objects As Top-Level Data Structures To Support Extensibility

    In a response body, you must always return a JSON objects (and not e.g. an array) as a top level data structure to support future extensibility. JSON objects support compatible extension by additional attributes. This allows you to easily extend your response and e.g. add pagination later, without breaking backwards compatibility.

    ### SHOULD:: Avoid Versioning

    When changing your RESTful APIs, do so in a compatible way and avoid generating additional API versions. Multiple versions can significantly complicate understanding, testing, maintaining, evolving, operating and releasing our systems (supplementary reading).

    If changing an API can't be done in a compatible way, then proceed in one of these three ways:

    - create a new resource (variant) in addition to the old resource variant
    - create a new service endpoint — i.e. a new application with a new API (with a new domain name)
    - create a new API version supported in parallel with the old API by the same microservice

    As we discourage versioning by all means because of the manifold disadvantages, we suggest to only use the first two approaches.

    ### MUST: Use Media Type Versioning

    When API versioning is unavoidable, you have to design your multi-version RESTful APIs using media type versioning (instead of URI versioning, see below). Media type versioning is less tightly coupled since it supports content negotiation and hence reduces complexity of release management.

    Media type versioning: Here, version information and media type are provided together via the HTTP Content-Type header — e.g. application/x.zalando.cart+json;version=2. For incompatible changes, a new media type version for the resource is created. To generate the new representation version, consumer and producer can do content negotiation using the HTTP Content-Type and Accept headers. Note: This versioning only applies to the request and response content schema, not to URI or method semantics.

    In this example, a client wants only the new version of the response:

    Accept: application/x.zalando.cart+json;version=2
    A server responding to this, as well as a client sending a request with content should use the Content-Type header, declaring that one is sending the new version:

    Content-Type: application/x.zalando.cart+json;version=2

    Using header versioning should:

    - include versions in request and response headers to increase visibility
    - include Content-Type in the Vary header to enable proxy caches to differ between versions

    > Hint: OpenAPI currently doesn't support content negotiation, though a comment in this issue mentions a workaround (using a fragment identifier that gets stripped off). Another way would be to document just the new version, but let the server accept the old one (with the previous content-type).

    Until an incompatible change is necessary, it is recommended to stay with the standard application/json media type.

    ### MUST: Do Not Use URI Versioning

    With URI versioning a (major) version number is included in the path, e.g. /v1/customers. The consumer has to wait until the provider has been released and deployed. If the consumer also supports hypermedia links — even in their APIs — to drive workflows (HATEOAS), this quickly becomes complex. So does coordinating version upgrades — especially with hyperlinked service dependencies — when using URL versioning. To avoid this tighter coupling and complexer release management we do not use URI versioning, and go instead with media type versioning and content negotiation (see above).

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

## Other Topics

    <!-- TODO -->

    dog-food your own API

    <!--

    typical usage (adhere to standard http verbs etc. and how it relates to interacting with various resources)
    communicating with services - public facing API’s
    for the public
    Use HTTP Methods
    testing api’s
    automated in-memory integration tests (with live dependencies stubed out)

    Avoid Operations on Nested Routes
    Implement a “Health-Check” Endpoint

    Rate limiting (Twitter-style):
        X-Rate-Limit-Limit - The number of allowed requests in the current period
        X-Rate-Limit-Remaining - The number of remaining requests in the current period
        X-Rate-Limit-Reset - The number of seconds left in the current period

    -->

    ### SHOULD:: Reduce Bandwidth Needs and Improve Responsiveness

    APIs should support techniques for reducing bandwidth based on client needs. This holds for APIs that (might) have high payloads and/or are used in high-traffic scenarios like the public Internet and telecommunication networks. Typical examples are APIs used by mobile web app clients with (often) less bandwidth connectivity. (Zalando is a 'Mobile First' company, so be mindful of this point.)

    Common techniques include:

    gzip compression
    querying field filters to retrieve a subset of resource attributes (see Support Filtering of Resource Fields below)
    paginate lists of data items (see Pagination below)
    ETag and If-(None-)Match headers to avoid re-fetching of unchanged resources (see Common Headers
    pagination for incremental access of larger (result) lists

    Each of these items is described in greater detail below.


    # Authentication is Key
    By providing your API users with a unique API token, or API key you can tell exactly who is making calls to your API.

     Along with having quick access to determining potential malicious users which can immediately be removed, you can also set permissions and SLAs for users depending on their individual needs.

     This means that you can set a default SLA for most users, giving them say only 4 calls per second, but for silver partners they get 10 calls per second, for gold partners 100 calls per second, etc.

     This means that you can not only identify abuse quickly, but also help prevent it by limiting their access to certain aspects of your API, and by limiting the number of calls they can make to your API.

    # Throttling Isn't Bad
    Throttling and rate limiting isn't a bad thing.

     Again, by throttling your API and setting up different SLA tiers you are able to help prevent abuse – often times completely accidental.

     This means that your API is able to operate optimally for all of your users, instead of having one infinite loop bring it crashing down for everyone.
    And yes, you may have partners that need more calls than others, or who the limits do not make sense for.

      But again, by setting up SLA tiers based on your standard API user's needs, and then creating partner tiers, you can easily give the the permissions they need, while limiting the standard user to prevent abuse.
    The API key, or unique identifier for an user's application also helps you identify who your heavier users are – letting you get in contact with them to make sure their needs are being met, while also learning more about how they are using your API.
    # Tools

    The demand for flexibility and extensibility has driven the development of APIs and tools alike, and in many regards it has never been easier to create an API than it is today with multitudes of frameworks (such as JAX-RS, Apigility, Django REST Framework, Grape), specs (RAML, Swagger, API Blueprint, IO Docs), and tools (API Designer, API Science, APImatic) available.

    # Building an SDK Doesn't Fix Everything

    Last but not least, keep in mind that SDKs or code wrappers/ libraries can be extremely helpful.

     However, if you are building a full out SDK instead of a language wrapper that utilizes the hypermedia to handle responses, remember that you are adding a whole new layer of complexity to your API ecosystem – that you will have to maintain.
    What SDKs/ Code Wrappers offer is a quick, plug and play way for developers to incorporate your API, while also (hopefully) handling error checks/ responses.

     The downside is the more complex your SDK becomes, the more tightly coupled it usually is to your API, making any updates to your API a manual and complex process.

     This means that any new features you roll out will receive rather slow adoption, and you may find yourself providing support to your developers on why they can't do something with your SDK.
    When building your SDK you should try to keep it as decoupled from your API as possible, relying on dynamic responses and calls while also following the best coding practices for that language (be sure to watch Keith Casey's SPOIL talk or read about it here).
    Another option is to utilize a SDK building service such as APIMatic.io or REST United, which automatically generates SDKs for your API based on your RAML, Swagger, or API Blueprint spec.

     This allows you to offer SDKs, automatically have them update when adding new features (although clients will still need to download the updated version), and offer them without adding any additional workload on your end.
    But again, regardless of whether or not you provide an SDK/ Code Library, you will still want to have multiple code examples in your documentation to help developers who want to utilize your API to its fullest capacity, without relying on additional third party libraries to do so.
    To recap, use HTTP Status Codes, use Descriptive Error Messages, and having an SDK may be helpful for a lot of your developers – but make sure you take into consideration all of the challenges that come with it, and remember that having an SDK doesn't replace documentation, if anything – it creates the need for more.

    # Deprecation

    Sometimes it is necessary to phase out an API endpoint (or version). I.e. this may be necessary if a field is no longer supported in the result or a whole business functionality behind an endpoint has to be shut down. There are many other reasons as well.

    ### MUST: Obtain Approval of Clients

    Before shutting down an API (or version of an API) the producer must make sure, that all clients have given their consent to shut down the endpoint. Producers should help consumers to migrate to a potential new endpoint (i.e. by providing a migration manual). After all clients are migrated, the producer may shut down the deprecated API.

    ### MUST: External Partners Must Agree on Deprecation Timespan

    If the API is consumed by any external partner, the producer must define a reasonable timespan that the API will be maintained after the producer has announced deprecation. The external partner (client) must agree to this minimum after-deprecation-lifespan before he starts using the API.

    ### MUST: Reflect Deprecation in API Definition

    API deprecation must be part of the OpenAPI definition. If a method on a path, a whole path or even a whole API endpoint (multiple paths) should be deprecated, the producers must set deprecated=true on each method / path element that will be deprecated (OpenAPI 2.0 only allows you to define deprecation on this level). If deprecation should happen on a more fine grained level (i.e. query parameter, payload etc.), the producer should set deprecated=true on the affected method / path element and add further explanation to the description section.

    If deprecated is set to true, the producer must describe what clients should use instead and when the API will be shut down in the description section of the API definition.

    ### MUST: Monitor Usage of Deprecated APIs

    Owners of APIs used in production must monitor usage of deprecated APIs until the API can be shut down in order to align deprecation and avoid uncontrolled breaking effects. See also the general rule on API usage monitoring

    ### SHOULD:: Add a Warning Header to Responses

    During deprecation phase, the producer should add a Warning header (see RFC 7234 - Warning header) field. When adding the Warning header, the warn-code must be 299 and the warn-text should be in form of "The path/operation/parameter/... {name} is deprecated and will be removed by {date}. Please see {link} for details." with a link to a documentation describing why the API is no longer supported in the current form and what clients should do about it. Adding the Warning header is not sufficient to gain client consent to shut down an API.

    ### SHOULD:: Add Monitoring for Warning Header

    Clients should monitor the Warning header in HTTP responses to see if an API will be deprecated in future.

    ### MUST: Not Start Using Deprecated APIs

    Clients must not start using deprecated parts of an API.

    # API Operation

    ### MUST: Provide Online Access to OpenAPI Reference Definition

    ### SHOULD:: Monitor API Usage

    Owners of APIs used in production should monitor API service to get information about its using clients. This information, for instance, is useful to identify potential review partner for API changes.

    Hint: A preferred way of client detection implementation is by logging of the client-id retrieved from the OAuth token.


## Spec-Driven Development 

One of the quickest ways to get feedback on your API is to define it using a specification language. An API specification language allows for building APIs in a consistent manner, utilizing pattern design and code reuse to help ensure that the APIs remains uniform across the full interface, keeping resources and methods standardized.

- **DO** define Your API in a flexible, but standard specification language (e.g. RAML, Swagger, JSON-API, etc.).

> Be aware that none of the popular specification frameworks support Hypermedia Links (let alone HATEOS). <!-- TODO: link to Jimmy Bogart blog -->

    ### Code to the Spec... and Don't Deviate

    If you have taken advantage of the above steps and carefully laid out your API, carefully designed your spec, user tested, and perfected your API – there is nothing worse than throwing all that work away by deviating from the spec and doing one-off things.



## Mocking

    Mock Your API and get User Feedback

    Another huge advantage of tools like RAML or Swagger is that they allow you to mock your API.

     This means that you can not only build your API in a visual interface and take advantage of the very same best practices we utilize in development, but you can also share a mock version of your API with potential clients.
    Using MuleSoft's API Designer you can easily turn on a mocking service that gives you a URL that can be shared with other developers.

     This allows your clients to "test out" your API by making real calls as if they would from their application.

     By utilizing the example responses defined in the RAML file developers can quickly identify issues and inconsistencies, helping you eliminate the majority of design related issues before development even starts.

     And by passing along tools like the API Notebook, developers can interact with your Mock API through JavaScript without having to code any calls themselves, and also having the ability to send you the specific use case back giving you true examples of what your developers are trying to accomplish.

    This process can be repeated as necessary, as modifying the spec and creating a new mock only takes minutes, empowering you to perfect the design of your API and ensure that it not only meets your developers' needs, but also provides a solid, strong foundation for the future of your API.
    After all, the nemesis of a long-lived API is not the code, nor the system architecture, but the API design itself.

     No matter how careful you are with your API, without a solid foundation it will crumble quickly, costing you thousands to hundreds of thousands of dollars down the road.

     It's better to take the time now, up front and ensure that your API is well designed.



## B. Overview of REST

    <!-- TODO -->

    - Uniform Resource Identifier
    - Resources
    - Representations
    - Uniform Interface
    - Hypermedia And Application State

## References

- Boyer, P. (2017, May 31). "RESTful API Design Tips from Experience". Medium. .  https://medium.com/studioarmix/learn-restful-api-design-ideals-c5ec915a430f

- <http://whatisrest.com>
- <https://en.wikipedia.org/wiki/Representational_state_transfer#Architectural_constraints>
- <http://apistylebook.com/>
- <https://apihandyman.io/api-design-tips-and-tricks-getting-creating-updating-or-deleting-multiple-resources-in-one-api-call/>
- <http://www.ben-morris.com/the-restafarian-flame-wars-common-points-of-disagreement-over-rest-api-design/>
- <http://www.jenitennison.com/2009/07/25/opaque-uris-unreadable-uris.html>
- <https://www.w3.org/DesignIssues/Axioms.html#opaque>
- <http://www.jenitennison.com/2009/07/25/opaque-uris-unreadable-uris.html>
- <http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api>
- <https://medium.com/studioarmix/learn-restful-api-design-ideals-c5ec915a430f>
- <http://www.jerriepelser.com/blog/paging-in-aspnet-webapi-introduction/?mb=0>
- <https://blogs.mulesoft.com/dev/api-dev/api-best-practices-series-intro/>
- <https://apigility.org/documentation/api-primer/what-is-an-api>
- <http://zalando.github.io/restful-api-guidelines>

### Citations
### Bibliography

Allamaraju, S. (2010). RESTful web services cookbook: Solutions for improving scalability and simplicity. Yahoo Press.
