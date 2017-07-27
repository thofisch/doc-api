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

    - 13.1. How to Maintain URI Compatibility (*url regression*)
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
