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

# Extensibility and Versioning

Managing change in any distributed client/server environment can be hard. In these environments, clients count on servers to honor their contracts.

When a change is backward compatible, you need not upgrade clients at the same time as you modify the server.

*Forward compatibility* may be important when you have several clients and servers upgraded at different points in time. In this case, some newer clients may be interacting with older servers. The purpose of forward compatibility is to ensure that newer clients can continue to use the older servers without disruption albeit with reduced functionality.

The characteristic that lets you maintain compatibility is *extensibility*. Extensibility is a design process to account for future changes.

As a transfer protocol, HTTP is extensible, but that does not mean that APIs built over HTTP are automatically extensible.

It takes discipline, careful planning, and defensive coding practices.

A one-time simultaneous upgrade of all server and clients is not a realistic task. You need to plan for a gradual rollout of upgrades to servers and clients to maintain the availability of the overall system.

Note that both clients and server need to take the appropriate steps to operate smoothly under change. For the server, the goal is to keep the clients from breaking. For the clients, the objective is not fail when new unknown data or links appear in representations.

### How to Maintain URI Compatibility (*url regression*)

Keeps URIs permanent.

Treat URIs containing the same query parameters but in a different order as the same

When you add new parameters to URIs, continue to honor existing parameters, and treat new parameters as optional.

When changing data formats for query parameters, continue to honor existing formats. If that is not viable, introduce format changes via new query parameters or new URIs.

Treat query parameters in URIs as optional except when need for concurrency and security.

- **DO** use rewrite rules on the server to shield clients from implementation-level changes.
- **DO** use `301 Moved Permanently` with the new URI in the `Location` header, when URIs must change to honor old URIs.
- **DO** monitor request traffic for redirection.
- **DO** maintain redirection services until you are confident the majority of clients have updated their stored links to point to the new URI.
- **DO** communicate an appropriate end-of-life policy for old URIs, when you cannot monitor the old URIs.
- **DO** convert `301 Moved Permanently` to `410 Gone` or `404 Not Found` once the traffic has fallen of or the preset time interval has passed.

### How to Maintain Compatibility of XML and JSON Representations

When making changes to JSON preserve the hierarchical structure so that clients can continue to follow the same structure to extract data.

Make new data elements in requests optional to maintain compatibility with existing clients. Clients that do not send new data fields must be able to continue to function.

Do not remove or rename any data fields from representaions in reponse bodies.

Example: Clients that do not understand new fields may not store them locally. If this causes the server to assume the user has no email address, introduce a new version of the resource that contains the email.

### How to Maintain Compatibility of Links

Avoid removing links
Do not change the value of the `rel` and `href` attributes of links.
When introducing new resources, use links to provide URIs of those resources to clients.

### When to Version

Consider versioning when the server cannot maintain compatibility. Also consider versioning if some clients require behavior or functionality different from other clients.

Versioning may introduce new problems:

- Data stored by the clients for one version may not automatically work with the data from a different version. Clients may have to port resource data stored locally before migrating to the new version.
- Version changes may involve new business rules and new application flow, which requires code changes in clients.
- Maintaining multiple versions of resources at the same time is not trivial.
- When you use links to convey URIs to clients, clients may store them locally. When you assign new URIs, clients will have to upgrade those URIs along with other stored data of resources.

### How to Version RESTful Web Services

Add new resources with new URIs when there is a change in the behavior of resource or a change in the information contained in representations.

Use easily detectable patterns such as `v1` or `v2` in subdomain names, path segments, or query parameters to distinguish URIs by their version.

Avoid treating each version as a new representation with a new media type of the same resource.

Versioning involves versioning resources with new URIs. This is because HTTP dictates everything except URIs of resources and their representations. Although you can add custom HTTP methods and headers, such additions may impair interoperability.

Avoid introducing new media types for each version since it leads to media type proliferation, which reduce interoperability.



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



    The API will inevitably need to be modified in ways that will impact customer client code. Not all customer clients will be able to make the necessary changes in their code right away, so the API should maintain older versions for some time after releasing the new version, usually a minimum of 90 days.



    In the ‘When to Version’ section should you mention APIs that use enum types? My company’s API reference documentation has attributes with an enum type and we list all values. We ran into a problem when a requirement added an enum value to an existing attribute and it broke a partner app. The partner had coded to the defined enum values in the documentation and their app wasn’t expecting new values with future releases. I corrected the problem by removing the new enum value and I defined any request to add a new enum value to an existing attribute requires a new API version. Last, going forward new attributes with an enum type will be defined as String in the documentation and we will indicate the values are not limited to the ones defined.



    Versioning Content Types

    The use of content negotiation with custom MIME types allows for finer grained versioning at the resource level without the need to create a plethora of new endpoints. New versions must be communicated to developers through existing channels – email, developer blogs, etc. When a content version is no longer supported, the body of the HTTP error should include a list of supported content types.

    Versioning URIs

    The use of both hyper links and content negotiation should all but eliminate the need to version at the URI level. However, there may be instances where the entire structure of the API must be changed, particularly when moving from one API style to another, such when moving from an RPC-type style to NARWHL. To prepare for these possibilities, it’s recommended that a version be embedded within each API endpoint. The version can either be embedded at the root for all endpoints of a given API, such as:

    http://api.example.com/v1

    Or within the fully qualified domain name for the endpoint:

    http://apiv1.example.com

    The version need not be numeric, nor specified using the “v[x]” syntax. Alternatives include dates, project names, seasons or other identifiers that are meaningful enough to the team producing the APIs and flexible enough to change as the versions change.


    Subbu Allamaraju, revisits one of the recurring debates in the REST community; the standard media types vs. custom media types and tries to determine the best practices when using them. He starts with the stating dichotomous views on the use of media types.

    Opinion 1: Web services must use standard media types to be RESTful.
    Opinion 2: Custom media types are necessary to keep interactions visible, and to serve as contracts.
    The first opinion which, if adhered to strictly, per Roy Fieldings thesis, “the use of media types such as application/vnd.example.myway+xml is not RESTful”. Subbu believes that understanding the impact of such media type usage in the real world is more important than following the thesis to the letter. There are however comments that suggest that this interpretation of the thesis might be up for debate as well.

    To the contrary, the second opinion, he says, leads to visibility of the messages at the protocol level via the use of custom media types.

    […] For instance, how can anyone know if a representation that uses application/xml media type describes a purchase order, or a photo album? If the web service uses media types likeapplication/vnd.example.po and application/vnd.example.album, then any one can interpret the semantics of the representation without parsing the body of the representation. Per this line of thinking, a media type is an identifier for message semantics, and message recipients use media types to trigger processing code.

    “So what is the right thing to do?”  He asks, as he puts forth his idea, in a effort to democratically determine the best practices

    - If the sender is formatting representations using standard extensible formats such as XML or JSON, use standard media types such as application/xml and application/json.
    - Mint new media types when you invent new formats.
    - If you are just looking for a way to communicate application level semantics for XML and JSON messages, use something else (e.g. XML namespaces and conventions).
    - If the goal is versioning, use version identifiers in URIs.
    Giving java-like examples, He asserts that though its possible to peek into the messages to see how a request can be processed, it compromises visibility or opacity as the case may be.

    Media types such as application/xml and application/json are good enough for XML and JSON message processing in code. […] URI based approaches are guaranteed to work across the stack. Ignoring real-world interoperability for the sake of "architectual purity" or "RESTful contracts" may eventually back fire.

    Via the post is the solution presented by Subbu found the right balance between architectural purity and interoperable real-world solutions? Be sure to visit the original post to weigh in your opinion.

    ## Tips for versioning

    Versioning is one of the most important considerations when designing your Web API.

    Never release an API without a version and make the version mandatory.

    Let's see how three top API providers handle versioning.

    Twilio /2010-04-01/Accounts/

    salesforce.com /services/data/v20.0/sobjects/Account

    Facebook ?v=1.0

    Twilio uses a timestamp in the URL (note the European format).

    At compilation time, the developer includes the timestamp of the application when the code was compiled. That timestamp goes in all the HTTP requests.

    When a request arrives, Twilio does a look up. Based on the timestamp they identify the API that was valid when this code was created and route accordingly.

    It's a very clever and interesting approach, although we think it is a bit complex. For example, it can be confusing to understand whether the timestamp is the compilation time or the timestamp when the API was released.

    Salesforce.com uses v20.0, placed somewhere in the middle of the URL.

    We like the use of the v. notation. However, we don't like using the .0 because it implies that the interface might be changing more frequently than it should. The logic behind an interface can change rapidly but the interface itself shouldn't change frequently.

    Facebook also uses the v. notation but makes the version an optional parameter.

    This is problematic because as soon as Facebook forced the API up to the next version, all the apps that didn't include the version number broke and had to be pulled back and version number added.

    ## How to think about version numbers in a pragmatic way with REST?

    Never release an API without a version. Make the version mandatory.

    Specify the version with a 'v' prefix. Move it all the way to the left in the URL so that it has the highest scope (e.g. /v1/dogs).

    Use a simple ordinal number. Don't use the dot notation like v1.2 because it implies a granularity of versioning that doesn't work well with APIs--it's an interface not an implementation. Stick with v1, v2, and so on.

    How many versions should you maintain? Maintain at least one version back.

    For how long should you maintain a version? Give developers at least one cycle to react before obsoleting a version.

    Sometimes that's 6 months; sometimes it's 2 years. It depends on your developers' development platform, application type, and application users. For example, mobile apps take longer to rev' than Web apps.

    Should version and format be in URLs or headers?

    There is a strong school of thought about putting format and version in the header.

    Sometimes people are forced to put the version in the header because they have multiple inter-dependent APIs. That is often a symptom of a bigger problem, namely, they are usually exposing their internal mess instead of creating one, usable API facade on top.

    That's not to say that putting the version in the header is a symptom of a problematic API design. It's not!

    In fact, using headers is more correct for many reasons: it leverages existing HTTP standards, it's intellectually consistent with Fielding's vision, it solves some hard realworld problems related to inter-dependent APIs, and more.

    However, we think the reason most of the popular APIs do not use it is because it's less fun to hack in a browser.

    Simple rules we follow:

    If it changes the logic you write to handle the response, put it in the URL so you can see it easily.

    If it doesn't change the logic for each response, like OAuth information, put it in the header.

    The code we would write to handle the responses would be very different.

    There's no question the header is more correct and it is still a very strong API design.

## Deprecation

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
