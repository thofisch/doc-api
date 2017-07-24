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

# Conventions Used in These Guidelines

~~The requirement level keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" used in this document (case insensitive) are to be interpreted as described in RFC 2119.~~

# Zalando specific information

The purpose of our "RESTful API guidelines" is to define standards to successfully establish "consistent API look and feel" quality.~

The API Guild drafted and owns this document.

Teams are responsible to fulfill these guidelines during API development and are encouraged to contribute to guideline evolution via pull requests.

These guidelines will, to some extent, remain work in progress as our work evolves, but teams can confidently follow and trust them.

In case guidelines are changing, following rules apply:

- existing APIs don't have to be changed, but we recommend it
- clients of existing APIs have to cope with these APIs based on outdated rules
- new APIs have to respect the current guidelines
- Furthermore you should keep in mind that once an API becomes public externally available, it has to be re-reviewed and changed according to current guidelines - for sake of overall consistency.

# Principles

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

# General Guidelines

## Must: Follow API First Principle

As mentioned in the introduction, API First is one of our engineering and architecture principles. In a nutshell API First requires two aspects:

- define APIs outside the code first using a standard specification language
get early review feedback from peers and client developers
- By defining APIs outside the code, we want to facilitate early review feedback and also a development discipline that focus service interface design on...
    - profound understanding of the domain and required functionality
    - generalized business entities / resources, i.e. avoidance of use case specific APIs
    - clear separation of WHAT vs. HOW concerns, i.e. abstraction from implementation aspects — APIs should be stable even if we replace complete service implementation including its underlying technology stack
    - Moreover, API definitions with standardized specification format also facilitate...
- single source of truth for the API specification; it is a crucial part of a contract between service provider and client users
- infrastructure tooling for API discovery, API GUIs, API documents, automated quality checks

An element of API First are also this API Guidelines and a lightweight API review process [internal link] as to get early review feedback from peers and client developers. Peer review is important for us to get high quality APIs, to enable architectural and design alignment and to supported development of client applications decoupled from service provider engineering life cycle.

It is important to learn, that API First is not in conflict with the agile development principles that we love. Service applications should evolve incrementally — and so its APIs. Of course, our API specification will and should evolve iteratively in different cycles; however, each starting with draft status and early team and peer review feedback. API may change and profit from implementation concerns and automated testing feedback. API evolution during development life cycle may include breaking changes for not yet productive features and as long as we have aligned the changes with the clients. Hence, API First does not mean that you must have 100% domain and requirement understanding and can never produce code before you have defined the complete API and get it confirmed by peer review. On the other hand, API First obviously is in conflict with the bad practice of publishing API definition and asking for peer review after the service integration or even the service productive operation has started. It is crucial to request and get early feedback — as early as possible, but not before the API changes are comprehensive with focus to the next evolution step and have a certain quality (including API Guideline compliance), already confirmed via team internal reviews.


## Should: Provide User Manual Documentation

In addition to the API as OpenAPI Reference Definition, it’s good practice to provide an API User Manual documentation to improve client developer experience, especially of engineers that are less experienced in using this API. A helpful API User Manual typically describes the following API aspects:

- API’s scope, purpose and use cases
- concrete examples of API usage
- edge cases, error situation details and repair hints
- architecture context and major dependencies - including figures and sequence flows

## Must: Write APIs in U.S. English

# Security

## Must: Secure Endpoints with OAuth 2.0

# Compatibility

## Must: Don’t Break Backward Compatibility

Change APIs, but keep all consumers running.

Consumers usually have independent release life-cycles, focus on stability, and avoid changes that do not provide additional value. APIs are contracts between service providers and service consumers that cannot be broken via unilateral decisions.

There are two techniques to change APIs without breaking them:

- follow rules for compatible extensions
- introduce new API versions and still support older versions

We strongly encourage using compatible API extensions and discourage versioning. The below guideline rules for service providers and consumers enable us (having Postel’s Law in mind) to make compatible changes without versioning.

Hint: Please note that the compatibility guarantees are for the "on the wire" format. Binary or source compatibility of code generated from an API definition is not covered by these rules. If client implementations update their generation process to a new version of the API definition, it has to be expected that code changes are necessary.

## Should: Prefer Compatible Extensions

API designers should apply the following rules to evolve RESTful APIs for services in a backward-compatible way:

- Add only optional, never mandatory fields.
- Never change the semantic of fields (e.g. changing the semantic from customer-number to customer-id, as both are different unique customer keys)
Input fields may have (complex) constraints being validated via server-side business logic. - - Never change the validation logic to be more restrictive and make sure that all constraints a clearly defined in description.
- Enum ranges can be reduced when used as input parameters, only if the server is ready to accept and handle old range values too. Enum range can be reduced when used as output parameters.
- Enum ranges cannot not be extended when used for output parameters — clients may not be prepared to handle it. However, enum ranges can be extended when used for input parameters.
- Support redirection in case an URL has to change (301 Moved Permanently).

## Must: Prepare Clients To Not Crash On Compatible API Extensions

Service clients should apply the robustness principle:

- Be conservative with API requests and data passed as input, e.g. avoid to exploit definition eficits like passing megabytes for strings with unspecified maximum length.

- Be tolerant in processing and reading data of API responses, more specifically...

Service clients must be prepared for compatible API extensions of service providers:

- Be tolerant with unknown fields in the payload (see also Fowler’s "TolerantReader" post), i.e. ignore new fields but do not eliminate them from payload if needed for subsequent PUT requests.
- Be prepared to handle HTTP status codes not explicitly specified in endpoint definitions. Note also, that status codes are extensible. Default handling is how you would treat the corresponding x00 code (see RFC7231 Section 6).
- Follow the redirect when the server returns HTTP status 301 Moved Permanently.

## Should: Design APIs Conservatively

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

## Must: Always Return JSON Objects As Top-Level Data Structures To Support Extensibility

In a response body, you must always return a JSON objects (and not e.g. an array) as a top level data structure to support future extensibility. JSON objects support compatible extension by additional attributes. This allows you to easily extend your response and e.g. add pagination later, without breaking backwards compatibility.

## Should: Avoid Versioning

When changing your RESTful APIs, do so in a compatible way and avoid generating additional API versions. Multiple versions can significantly complicate understanding, testing, maintaining, evolving, operating and releasing our systems (supplementary reading).

If changing an API can’t be done in a compatible way, then proceed in one of these three ways:

- create a new resource (variant) in addition to the old resource variant
- create a new service endpoint — i.e. a new application with a new API (with a new domain name)
- create a new API version supported in parallel with the old API by the same microservice

As we discourage versioning by all means because of the manifold disadvantages, we suggest to only use the first two approaches.

## Must: Use Media Type Versioning

When API versioning is unavoidable, you have to design your multi-version RESTful APIs using media type versioning (instead of URI versioning, see below). Media type versioning is less tightly coupled since it supports content negotiation and hence reduces complexity of release management.

Media type versioning: Here, version information and media type are provided together via the HTTP Content-Type header — e.g. application/x.zalando.cart+json;version=2. For incompatible changes, a new media type version for the resource is created. To generate the new representation version, consumer and producer can do content negotiation using the HTTP Content-Type and Accept headers. Note: This versioning only applies to the request and response content schema, not to URI or method semantics.

In this example, a client wants only the new version of the response:

Accept: application/x.zalando.cart+json;version=2
A server responding to this, as well as a client sending a request with content should use the Content-Type header, declaring that one is sending the new version:

Content-Type: application/x.zalando.cart+json;version=2

Using header versioning should:

- include versions in request and response headers to increase visibility
- include Content-Type in the Vary header to enable proxy caches to differ between versions

> Hint: OpenAPI currently doesn’t support content negotiation, though a comment in this issue mentions a workaround (using a fragment identifier that gets stripped off). Another way would be to document just the new version, but let the server accept the old one (with the previous content-type).

Until an incompatible change is necessary, it is recommended to stay with the standard application/json media type.

## Must: Do Not Use URI Versioning

With URI versioning a (major) version number is included in the path, e.g. /v1/customers. The consumer has to wait until the provider has been released and deployed. If the consumer also supports hypermedia links — even in their APIs — to drive workflows (HATEOAS), this quickly becomes complex. So does coordinating version upgrades — especially with hyperlinked service dependencies — when using URL versioning. To avoid this tighter coupling and complexer release management we do not use URI versioning, and go instead with media type versioning and content negotiation (see above).

# JSON Guidelines

These guidelines provides recommendations for defining JSON data at Zalando. JSON here refers to RFC 7159 (which updates RFC 4627), the "application/json" media type and custom JSON media types defined for APIs. The guidelines clarifies some specific cases to allow Zalando JSON data to have an idiomatic form across teams and services.

## Must: Use Consistent Property Names

## Must: Property names must be snake_case (and never camelCase).

No established industry standard exists. It’s essential to establish a consistent look and feel such that JSON looks as if it came from the same hand.

## Must: Property names must be an ASCII subset

Property names are restricted to ASCII encoded strings. The first character must be a letter, an underscore or a dollar sign, and subsequent characters can be a letter, an underscore, a dollar sign, or a number.

## Should: Array names should be pluralized

To indicate they contain multiple values prefer to pluralize array names. This implies that object names should in turn be singular.

## Must: Use Consistent Property Values

## Must: Boolean property values must not be null

Schema based JSON properties that are by design booleans must not be presented as nulls. A boolean is essentially a closed enumeration of two values, true and false. If the content has a meaningful null value, strongly prefer to replace the boolean with enumeration of named values or statuses - for example accepted\_terms\_and\_conditions with true or false can be replaced with terms\_and\_conditions with values yes, no and unknown.

## Should: Null values should have their fields removed

Swagger/OpenAPI, which is in common use, doesn't support null field values (it does allow omitting that field completely if it is not marked as required). However that doesn't prevent clients and servers sending and receiving those fields with null values. Also, in some cases null may be a meaningful value - for example, JSON Merge Patch RFC 7382) using null to indicate property deletion.

## Should: Empty array values should not be null

Empty array values can unambiguously be represented as the the empty list, [].

## Should: Enumerations should be represented as Strings

Strings are a reasonable target for values that are by design enumerations.

## Should: Date property values should conform to RFC 3399

## May: Time durations and intervals could conform to ISO 8601

## May: Standards could be used for Language, Country and Currency

- ISO 3166-1-alpha2 country
- ISO 639-1 language code
- BCP-47 (based on ISO 639-1) for language variants
- ISO 4217 currency codes

# API Naming

## Must: Use lowercase separate words with hyphens for Path Segments

## Must: Use snake_case (never camelCase) for Query Parameters

## Must: Use Hyphenated HTTP Headers

## Should: Prefer Hyphenated-Pascal-Case for HTTP header Fields

This is for consistency in your documentation (most other headers follow this convention). Avoid camelCase (without hyphens). Exceptions are common abbreviations like "ID."

## May: Use Standardized Headers

## Must: Pluralize Resource Names

Usually, a collection of resource instances is provided (at least API should be ready here). The special case of a resource singleton is a collection with cardinality 1.

## May: Use /api as first Path Segment

In most cases, all resources provided by a service are part of the public API, and therefore should be made available under the root "/" base path. If the service should also support non-public, internal APIs — for specific operational support functions, for example — add "/api" as base path to clearly separate public and non-public API resources.

## Must: Avoid Trailing Slashes

The trailing slash must not have specific semantics. Resource paths must deliver the same results whether they have the trailing slash or not.

## May: Use Conventional Query Strings

If you provide query support for sorting, pagination, filtering functions or other actions, use the following standardized naming conventions:

q — default query parameter (e.g. used by browser tab completion); should have an entity specific alias, like sku
limit — to restrict the number of entries. See Pagination section below. Hint: You can use size as an alternate query string.
cursor — key-based page start. See Pagination section below.
offset — numeric offset page start. See Pagination section below. Hint: In combination with limit, you can use page as an alternative to offset.
sort — comma-separated list of fields to sort. To indicate sorting direction, fields my prefixed with + (ascending) or - (descending, default), e.g. /sales-orders?sort=+id
fields — to retrieve a subset of fields. See Support Filtering of Resource Fields below.
embed — to expand embedded entities (ie.: inside of an article entity, expand silhouette code into the silhouette object). Implementing "expand" correctly is difficult, so do it with care. See Embedding resources for more details.

# Resources

## MUST: Avoid Actions — Think About Resources

REST is all about your resources, so consider the domain entities that take part in web service interaction, and aim to model your API around these using the standard HTTP methods as operation indicators. For instance, if an application has to lock articles explicitly so that only one user may edit them, create an article lock with PUT or POST instead of using a lock action.

Request:

PUT /article-locks/{article-id}

The added benefit is that you already have a service for browsing and filtering article locks.

## SHOULD: Model complete business processes

An API should contain the complete business processes containing all resources representing the process. This enables clients to understand the business process, foster a consistent design of the business process, allow for synergies from description and implementation perspective, and eliminates implicit invisible dependencies between APIs.

In addition, it prevents services from being designed as thin wrappers around databases, which normally tends to shift business logic to the clients.

## SHOULD: Define useful resources

As a rule of thumb resources should be defined to cover 90% of all its client's use cases. A useful resource should contain as much information as necessary, but as little as possible. A great way to support the last 10% is to allow clients to specify their needs for more/less information by supporting filtering and embedding.

## MUST: Keep URLs Verb-Free

The API describes resources, so the only place where actions should appear is in the HTTP methods. In URLs, use only nouns. Instead of thinking of actions (verbs), it's often helpful to think about putting a message in a letter box: e.g., instead of having the verb cancel in the URL, think of sending a message to cancel an order to the cancellations letter box on the server side.

## MUST: Use Domain-Specific Resource Names

API resources represent elements of the application’s domain model. Using domain-specific nomenclature for resource names helps developers to understand the functionality and basic semantics of your resources. It also reduces the need for further documentation outside the API definition. For example, "sales-order-items" is superior to "order-items" in that it clearly indicates which business object it represents. Along these lines, "items" is too general.

## MUST: Identify resources and Sub-Resources via Path Segments

Some API resources may contain or reference sub-resources. Embedded sub-resources, which are not top-level resources, are parts of a higher-level resource and cannot be used outside of its scope. Sub-resources should be referenced by their name and identifier in the path segments.

Composite identifiers must not contain "/" as a separator. In order to improve the consumer experience, you should aim for intuitively understandable URLs, where each sub-path is a valid reference to a resource or a set of resources. For example, if "/customers/12ev123bv12v/addresses/DE_100100101" is a valid path of your API, then "/customers/12ev123bv12v/addresses", "/customers/12ev123bv12v" and "/customers" must be valid as well in principle.

Basic URL structure:

/{resources}/[resource-id]/{sub-resources}/[sub-resource-id]
/{resources}/[partial-id-1][separator][partial-id-2]
Examples:

/carts/1681e6b88ec1/items
/carts/1681e6b88ec1/items/1
/customers/12ev123bv12v/addresses/DE_100100101

## SHOULD: Only Use UUIDs If Necessary

Generating IDs can be a scaling problem in high frequency and near real time use cases. UUIDs solve this problem, as they can be generated without collisions in a distributed, non-coordinated way and without additional server roundtrips.

However, they also come with some disadvantages:

pure technical key without meaning; not ready for naming or name scope conventions that might be helpful for pragmatic reasons, e.g. we learned to use names for product attributes, instead of UUIDs
less usable, because...
cannot be memorized and easily communicated by humans
harder to use in debugging and logging analysis
less convenient for consumer facing usage
quite long: readable representation requires 36 characters and comes with higher memory and bandwidth consumption
not ordered along their creation history and no indication of used id volume
may be in conflict with additional backward compatibility support of legacy ids
UUIDs should be avoided were not needed for large scale id generation. Instead, for instance, server side support with id generation can be preferred (POST on id resource, followed by idempotent PUT on entity resource). Usage of UUIDs is especially discouraged as primary keys of master and configuration data, like brand-ids or attribute-ids which have low id volume but widespread steering functionality.

In any case, we should always use string rather than number type for identifiers. This gives us more flexibility to evolve the identifier naming scheme. Accordingly, if used as identifiers, UUIDs should not be qualified using a format property.

Hint: Usually, random UUID is used - see UUID version 4 in RFC 4122. Though UUID version 1 also contains leading timestamps it is not reflected by its lexicographic sorting. This deficit is addressed by ULID (Universally Unique Lexicographically Sortable Identifier). You may favour ULID instead of UUID, for instance, for pagination use cases ordered along creation time.

## MAY: Consider Using (Non-) Nested URLs

If a sub-resource is only accessible via its parent resource and may not exists without parent resource, consider using a nested URL structure, for instance:

/carts/1681e6b88ec1/cart-items/1
However, if the resource can be accessed directly via its unique id, then the API should expose it as a top-level resource. For example, customer is a collection for sales orders; however, sales orders have globally unique id and some services may choose to access the orders directly, for instance:

/customers/1681e6b88ec1
/sales-orders/5273gh3k525a

## SHOULD: Limit number of Resources

To keep maintenance and service evolution manageable, we should follow "functional segmentation" and "separation of concern" design principles and do not mix different business functionalities in same API definition. In this sense the number of resources exposed via API should be limited - our experience is that a typical range of resources for a well-designed API is between 4 and 8. There may be exceptions with more complex business domains that require more resources, but you should first check if you can split them into separate subdomains with distinct APIs.

Nevertheless one API should hold all necessary resources to model complete business processes helping clients to understand these flows.

## SHOULD: Limit number of Sub-Resource Levels

There are main resources (with root url paths) and sub-resources (or "nested" resources with non-root urls paths). Use sub-resources if their life cycle is (loosely) coupled to the main resource, i.e. the main resource works as collection resource of the subresource entities. You should use <= 3 sub-resource (nesting) levels -- more levels increase API complexity and url path length. (Remember, some popular web browsers do not support URLs of more than 2000 characters)

# HTTP

## MUST: Use HTTP Methods Correctly

Be compliant with the standardized HTTP method semantics summarized as follows:

GET

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

PUT

PUT requests are used to create or update entire resources - single or collection resources. The semantic is best described as »please put the enclosed representation at the resource mentioned by the URL, replacing any existing resource.«.

PUT requests are usually applied to single resources, and not to collection resources, as this would imply replacing the entire collection
PUT requests are usually robust against non-existence of resources by implicitly creating before updating
on successful PUT requests, the server will replace the entire resource addressed by the URL with the representation passed in the payload (subsequent reads will deliver the same payload)
successful PUT requests will usually generate 200 or 204 (if the resource was updated - with or without actual content returned), and 201 (if the resource was created)
Note: Resource IDs with respect to PUT requests are maintained by the client and passed as a URL path segment. Putting the same resource twice is required to be idempotent and to result in the same single resource instance. If PUT is applied for creating a resource, only URIs should be allowed as resource IDs. If URIs are not available POST should be preferred.

To prevent unnoticed concurrent updates when using PUT, the combination of ETag and If-(None-)Match headers should be considered to signal the server stricter demands to expose conflicts and prevent lost updates.

POST

POST requests are idiomatically used to create single resources on a collection resource endpoint, but other semantics on single resources endpoint are equally possible. The semantic for collection endpoints is best described as »please add the enclosed representation to the collection resource identified by the URL«. The semantic for single resource endpoints is best described as »please execute the given well specified request on the collection resource identified by the URL«.

POST request should only be applied to collection resources, and normally not on single resource, as this has an undefined semantic
on successful POST requests, the server will create one or multiple new resources and provide their URI/URLs in the response
successful POST requests will usually generate 200 (if resources have been updated), 201 (if resources have been created), and 202 (if the request was accepted but has not been finished yet)
More generally: POST should be used for scenarios that cannot be covered by the other methods sufficiently. For instance, GET with complex (e.g. SQL like structured) query that needs to be passed as request body payload because of the URL-length constraint. In such cases, make sure to document the fact that POST is used as a workaround.

Note: Resource IDs with respect to POST requests are created and maintained by server and returned with response payload. Posting the same resource twice is by itself not required to be idempotent and may result in multiple resource instances. Anyhow, if external URIs are present that can be used to identify duplicate requests, it is best practice to implement POST in an idempotent way.

PATCH

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

DELETE

DELETE request are used to delete resources. The semantic is best described as »please delete the resource identified by the URL«.

DELETE requests are usually applied to single resources, not on collection resources, as this would imply deleting the entire collection
successful DELETE request will usually generate 200 (if the deleted resource is returned) or 204 (if no content is returned)
failed DELETE request will usually generate 404 (if the resource cannot be found) or 410 (if the resource was already deleted before)
HEAD

HEAD requests are used retrieve to header information of single resources and resource collections.

HEAD has exactly the same semantics as GET, but returns headers only, no body.
OPTIONS

OPTIONS are used to inspect the available operations (HTTP methods) of a given endpoint.

OPTIONS requests usually either return a comma separated list of methods (provided by an Allow:-Header) or as a structured list of link templates
Note: OPTIONS is rarely implemented, though it could be used to self-describe the full functionality of a resource.

## MUST: Fulfill Safeness and Idempotency Properties

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

## MUST: Use Specific HTTP Status Codes

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

## MUST: Provide Error Documentation

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

## MUST: Use 207 for Batch or Bulk Requests

Some APIs are required to provide either batch or bulk requests using POST for performance reasons, i.e. for communication and processing efficiency. In this case services may be in need to signal multiple response codes for each part of an batch or bulk request. As HTTP does not provide proper guidance for handling batch/bulk requests and responses, we herewith define the following approach:

A batch or bulk request always has to respond with HTTP status code 207, unless it encounters a generic or unexpected failure before looking at individual parts.
A batch or bulk response with status code 207 always returns a multi-status object containing sufficient status and/or monitoring information for each part of the batch or bulk request.
A batch or bulk request may result in a status code 400/500, only if the service encounters a failure before looking at individual parts or, if an unanticipated failure occurs.
The before rules apply even in the case that processing of all individual part fail or each part is executed asynchronously! They are intended to allow clients to act on batch and bulk responses by inspecting the individual results in a consistent way.

Note: while a batch defines a collection of requests triggering independent processes, a bulk defines a collection of independent resources created or updated together in one request. With respect to response processing this distinction normally does not matter.

## MUST: Use 429 with Headers for Rate Limits

APIs that wish to manage the request rate of clients must use the '429 Too Many Requests' response code if the client exceeded the request rate and therefore the request can't be fulfilled. Such responses must also contain header information providing further details to the client. There are two approaches a service can take for header information:

Return a 'Retry-After' header indicating how long the client ought to wait before making a follow-up request. The Retry-After header can contain a HTTP date value to retry after or the number of seconds to delay. Either is acceptable but APIs should prefer to use a delay in seconds.

Return a trio of 'X-RateLimit' headers. These headers (described below) allow a server to express a service level in the form of a number of allowing requests within a given window of time and when the window is reset.

The 'X-RateLimit' headers are:

X-RateLimit-Limit: The maximum number of requests that the client is allowed to make in this window.
X-RateLimit-Remaining: The number of requests allowed in the current window.
X-RateLimit-Reset: The relative time in seconds when the rate limit window will be reset.
The reason to allow both approaches is that APIs can have different needs. Retry-After is often sufficient for general load handling and request throttling scenarios and notably, does not strictly require the concept of a calling entity such as a tenant or named account. In turn this allows resource owners to minimise the amount of state they have to carry with respect to client requests. The 'X-RateLimit' headers are suitable for scenarios where clients are associated with pre-existing account or tenancy structures. 'X-RateLimit' headers are generally returned on every request and not just on a 429, which implies the service implementing the API is carrying sufficient state to track the number of requests made within a given window for each named entity.

## SHOULD: Explicitly define the Collection Format of Query Parameters

There are different ways of supplying a set of values as a query parameter. One particular type should be selected and stated explicitly in the API definition. The OpenAPI property [collectionFormat](http://swagger.io/specification/) is used to specify the format of the query parameter.

Only the csv or multi formats should be used for multi-value query parameters as described below.

Collection Format	Description	Example
csv	Comma separated values	?parameter=value1,value2,value3
multi	Multiple parameter instances	?parameter=value1&parameter=value2&parameter=value3
When choosing the collection format, take into account the tool support, the escaping of special characters and the maximal URL length.

# Performance

## SHOULD: Reduce Bandwidth Needs and Improve Responsiveness

APIs should support techniques for reducing bandwidth based on client needs. This holds for APIs that (might) have high payloads and/or are used in high-traffic scenarios like the public Internet and telecommunication networks. Typical examples are APIs used by mobile web app clients with (often) less bandwidth connectivity. (Zalando is a 'Mobile First' company, so be mindful of this point.)

Common techniques include:

gzip compression
querying field filters to retrieve a subset of resource attributes (see Support Filtering of Resource Fields below)
paginate lists of data items (see Pagination below)
ETag and If-(None-)Match headers to avoid re-fetching of unchanged resources (see Common Headers
pagination for incremental access of larger (result) lists

Each of these items is described in greater detail below.

## SHOULD: Use gzip Compression

Compress the payload of your API’s responses with gzip, unless there’s a good reason not to — for example, you are serving so many requests that the time to compress becomes a bottleneck. This helps to transport data faster over the network (fewer bytes) and makes frontends respond faster.

Though gzip compression might be the default choice for server payload, the server should also support payload without compression and its client control via Accept-Encoding request header -- see also RFC 7231 Section 5.3.4. The server should indicate used gzip compression via the Content-Encoding header.

## SHOULD: Support Filtering of Resource Fields

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

## SHOULD: Allow Optional Embedding of Sub-Resources

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

# Pagination

## MUST: Support Pagination

Access to lists of data items must support pagination for best client side batch processing and iteration experience. This holds true for all lists that are (potentially) larger than just a few hundred entries.

There are two page iteration techniques:

Offset/Limit-based pagination: numeric offset identifies the first page entry
Cursor-based — aka key-based — pagination: a unique key element identifies the first page entry (see also Facebook’s guide)
The technical conception of pagination should also consider user experience related issues. As mentioned in this article, jumping to a specific page is far less used than navigation via next/previous page links. This favours cursor-based over offset-based pagination.

## SHOULD: Prefer Cursor-Based Pagination, Avoid Offset-Based Pagination

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

Higher data list volumes, especially if they do not reside in the database’s main memory
Sharded or NoSQL databases
Cursor-based navigation may not work if you need the total count of results and / or backward iteration support

Further reading:

Twitter
Use the Index, Luke
Paging in PostgreSQL

## MAY: Use Pagination Links Where Applicable

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

# Data Formats

## MUST: Use JSON to Encode Structured Data

Use JSON-encoded body payload for transferring structured data. The JSON payload must follow RFC-7159 by having (if possible) a serialized object as the top-level structure, since it would allow for future extension. This also applies for collection resources where one naturally would assume an array. See the pagination section for an example.

## MAY: Use non JSON Media Types for Binary Data or Alternative Content Representations

Other media types may be used in following cases:

Transferring binary data or data whose structure is not relevant. This is the case if payload structure is not interpreted and consumed by clients as is. Example of such use case is downloading images in formats JPG, PNG, GIF.
In addition to JSON version alternative data representations (e.g. in formats PDF, DOC, XML) may be made available through content negotiation.

## MUST: Use Standard Date and Time Formats

Use the HTTP date format defined in RFC 7231.

## MAY: Use Standards for Country, Language and Currency Codes

Use the following standard formats for country, language and currency codes:

- ISO 3166-1-alpha2 country codes
- ISO 639-1 language code
- BCP-47 (based on ISO 639-1) for language variants
- ISO 4217 currency codes

## MUST: Define Format for Type Number and Integer

Whenever an API defines a property of type number or integer, the precision must be defined by the format as follows to prevent clients from guessing the precision incorrectly, and thereby changing the value unintentionally:

type	format	specified value range
integer	int32	integer between -231 and 231-1
integer	int64	integer between -263 and 263-1
integer	bigint	arbitrarily large signed integer number
number	float	IEEE 754-2008/ISO 60559:2011 binary64 decimal number
number	double	IEEE 754-2008/ISO 60559:2011 binary128 decimal number
number	decimal	arbitrarily precise signed decimal number

## SHOULD: Prefer standard Media type name application/json

Previously, this guideline allowed the use of custom media types like application/x.zalando.article+json. This usage is not recommended anymore and should be avoided, except where it is necessary for cases of media type versioning. Instead, the standard media type name application/json (or application/problem+json for HTTP error details) should be used for JSON-formatted data.

Custom media types with subtypes beginning with x bring no advantage compared to the standard media type for JSON, and make automated processing more difficult. They are also discouraged by RFC 6838.

# Common Data Types

Definitions of data objects that are good candidates for wider usage:

## SHOULD: Use a Decimal for Money/Amount Objects

## MUST: Use common field names and semantics

There exist a variety of field types that are required in multiple places. To achieve consistency across all API implementations, you must use common field names and semantics whenever applicable.

Generic Fields

There are some data fields that come up again and again in API data:

id: the identity of the object. If used, IDs must opaque strings and not numbers. IDs are unique within some documented context, are stable and don't change for a given object once assigned, and are never recycled cross entities.

xyz_id: an attribute within one object holding the identifier of another object must use a name that corresponds to the type of the referenced object or the relationship to the referenced object followed by _id (e.g. customer_id not customer_number; parent_node_id for the reference to a parent node from a child node, even if both have the type Node)

created: when the object was created. If used, this must be a date-time construct.

modified: when the object was updated. If used, this must be a date-time construct.

type: the kind of thing this object is. If used, the type of this field should be a string. Types allow runtime information on the entity provided that otherwise requires examining the Open API file.

These properties are not always strictly necessary, but making them idiomatic allows API client developers to build up a common understanding of Zalando's resources. There is very little utility for API consumers in having different names or value types for these fields across APIs.

## MUST: Use Problem JSON

RFC 7807 defines the media type application/problem+json. Operations should return that (together with a suitable status code) when any problem occurred during processing and you can give more details than the status code itself can supply, whether it be caused by the client or the server (i.e. both for 4xx or 5xx errors).

A previous version of this guideline (before the publication of that RFC and the registration of the media type) told to return application/x.problem+json in these cases (with the same contents). Servers for APIs defined before this change should pay attention to the Accept header sent by the client and set the Content-Type header of the problem response correspondingly. Clients of such APIs should accept both media types.

## MUST: Do not expose Stack Traces

Stack traces contain implementation details that are not part of an API, and on which clients should never rely. Moreover, stack traces can leak sensitive information that partners and third parties are not allowed to receive and may disclose insights about vulnerabilities to attackers.

# Common Headers

This section describes a handful of headers, which we found raised the most questions in our daily usage, or which are useful in particular circumstances but not widely known.

## MUST: Use Content Headers Correctly

Content or entity headers are headers with a Content- prefix. They describe the content of the body of the message and they can be used in both, HTTP requests and responses. Commonly used content headers include but are not limited to:

Content-Disposition can indicate that the representation is supposed to be saved as a file, and the proposed file name.
Content-Encoding indicates compression or encryption algorithms applied to the content.
Content-Length indicates the length of the content (in bytes).
Content-Language indicates that the body is meant for people literate in some human language(s).
Content-Location indicates where the body can be found otherwise (see below for more details).
Content-Range is used in responses to range requests to indicate which part of the requested resource representation is delivered with the body.
Content-Type indicates the media type of the body content.

## MAY: Use Content-Location Header

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

## SHOULD: Use Location Header instead of Content-Location Header

As the correct usage of Content-Location with respect to semantics and caching is difficult, we discourage the use of Content-Location. In most cases it is sufficient to direct clients to the resource location by using the Location header instead without hitting the Content-Location specific ambiguities and complexities.

More details in RFC 7231 7.1.2 Location, 3.1.4.2 Content-Location

## MAY: Use the Prefer header to indicate processing preferences

The Prefer header defined in RFC7240 allows clients to request processing behaviors from servers. RFC7240 pre-defines a number of preferences and is extensible, to allow others to be defined. Support for the Prefer header is entirely optional and at the discretion of API designers, but as an existing Internet Standard, is recommended over defining proprietary "X-" headers for processing directives.

Supporting APIs may return the Preference-Applied header also defined in RFC7240 to indicate whether the preference was applied.

## MAY: Consider using ETag together with If-(None-)Match header

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

## MUST: Use Only the Specified Proprietary Zalando Headers

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

## MUST: Propagate Proprietary Headers

All Zalando's proprietary headers are end-to-end headers.

All headers specified above must be propagated to the services down the call chain. The header names and values must remain unchanged.

For example, the values of the custom headers like X-Device-Type can affect the results of queries by using device type information to influence recommendation results. Besides, the values of the custom headers can influence the results of the queries (e.g. the device type information influences the recommendation results).

Sometimes the value of a proprietary header will be used as part of the entity in a subsequent request. In such cases, the proprietary headers must still be propagated as headers with the subsequent request, despite the duplication of information.

Footnote:

HTTP/1.1 standard (RFC-7230) defines two types of headers: end-to-end and hop-by-hop headers. End-to-end headers must be transmitted to the ultimate recipient of a request or response. Hop-by-hop headers, on the contrary, are meaningful for a single connection only.

# Deprecation

Sometimes it is necessary to phase out an API endpoint (or version). I.e. this may be necessary if a field is no longer supported in the result or a whole business functionality behind an endpoint has to be shut down. There are many other reasons as well.

## MUST: Obtain Approval of Clients

Before shutting down an API (or version of an API) the producer must make sure, that all clients have given their consent to shut down the endpoint. Producers should help consumers to migrate to a potential new endpoint (i.e. by providing a migration manual). After all clients are migrated, the producer may shut down the deprecated API.

## MUST: External Partners Must Agree on Deprecation Timespan

If the API is consumed by any external partner, the producer must define a reasonable timespan that the API will be maintained after the producer has announced deprecation. The external partner (client) must agree to this minimum after-deprecation-lifespan before he starts using the API.

## MUST: Reflect Deprecation in API Definition

API deprecation must be part of the OpenAPI definition. If a method on a path, a whole path or even a whole API endpoint (multiple paths) should be deprecated, the producers must set deprecated=true on each method / path element that will be deprecated (OpenAPI 2.0 only allows you to define deprecation on this level). If deprecation should happen on a more fine grained level (i.e. query parameter, payload etc.), the producer should set deprecated=true on the affected method / path element and add further explanation to the description section.

If deprecated is set to true, the producer must describe what clients should use instead and when the API will be shut down in the description section of the API definition.

## MUST: Monitor Usage of Deprecated APIs

Owners of APIs used in production must monitor usage of deprecated APIs until the API can be shut down in order to align deprecation and avoid uncontrolled breaking effects. See also the general rule on API usage monitoring

## SHOULD: Add a Warning Header to Responses

During deprecation phase, the producer should add a Warning header (see RFC 7234 - Warning header) field. When adding the Warning header, the warn-code must be 299 and the warn-text should be in form of "The path/operation/parameter/... {name} is deprecated and will be removed by {date}. Please see {link} for details." with a link to a documentation describing why the API is no longer supported in the current form and what clients should do about it. Adding the Warning header is not sufficient to gain client consent to shut down an API.

## SHOULD: Add Monitoring for Warning Header

Clients should monitor the Warning header in HTTP responses to see if an API will be deprecated in future.

## MUST: Not Start Using Deprecated APIs

Clients must not start using deprecated parts of an API.

# API Operation

## MUST: Provide Online Access to OpenAPI Reference Definition

## SHOULD: Monitor API Usage

Owners of APIs used in production should monitor API service to get information about its using clients. This information, for instance, is useful to identify potential review partner for API changes.

Hint: A preferred way of client detection implementation is by logging of the client-id retrieved from the OAuth token.



---



# Hypermedia

One of the challenges to implementing and correctly using hypermedia in your REST API is first understanding what hypermedia is, and what it means to use hypermedia as the engine of application state (HATEOAS).
The term "hypermedia" was coined back in 1965 by Ted Nelson, and over the years has dominated the technology industry.

Hypermedia, in its most basic sense is an extension of hypertext – something you may recognize from HTML.

Hypertext is essentially text that is written in a structured format and contains relationships to other objects via links.

If you think of a webpage, using HTML – the Hypertext Markup Language – text is then interpreted by a browser to become a webpage, or an interactive environment capable of doing more than just providing a blob of text.

However, to be truly interactive and guide the user, the crucial component of all of this is links, something we use everyday when surfing the web.
Enter hypermedia, again just an extension of the term hypertext, hypermedia includes images, video, audio, text, and links.

In a REST API, this means that your API is able to function similarly to a webpage, providing the user with guidance on what type of content they can retrieve, or what actions they can perform, as well as the appropriate links to do so.
Essentially, the easiest way to take advantage of hypermedia in your API is to provide valuable information to direct the user or client to the next possible actions they can take based on the object (whether it be a collection, or item within the resource) or "page" they are on via links.
Another way to think of it is to bring back the Hypercard application from the early Apple days (we're talking Macintosh Classic).

With this application you could create "cards" or slides with links that performed different functions.

Clicking on link might play a sound, another a video, or another would take you to a different card.

On each card you were presented with certain links (whether in the form of a button or text) for the available actions to you on this card.

This is exactly how hypertext links work within RESTful APIs– they are designed to take you to the other components of the API, your other "cards."
By adding these links, because REST is stateless, we are providing the client with a method for determining the state of the current item/ collection that they are on, as well as giving them the roadmap or engine for what they can do with it.

In other words, we are using Hypermedia as the Engine of the Application's State, or implementing HATEOAS.

# The HATEOAS Debate

Currently, there is a lot of disagreement around hypermedia's place in RESTful APIs– with Dr. Roy Fielding saying it is critical to REST, and without it your API cannot be RESTful; and hypermedia skeptics arguing that you are doing nothing more than bloating your API and making it more difficult to use under the guise of usability.
This means you will find many different stances on the web today, ranging from Peter Williams explanation of how hypermedia has helped him, Jeff Krupp's rant against hypermedia, and even Kin Lane's summary of the whole debate.
But what it really comes down to isn't what do others think about hypermedia, as most major frameworks for building APIs now include hypermedia specs such as HAL, JSON-LD, JSON API, Siren, or Collection+JSON, but rather what benefit does hypermedia offer- and is that benefit enough to outweigh the cost/ disadvantages of incorporating hypermedia.

# The Claims For and Against Hypermedia

Some of the most common arguments for and against hypermedia include:

## Hypermedia creates more work

This is absolutely true.

Adding hypermedia or hypertext links to your API output does require more work – and more thought to go into your API.

Going back to the Planning Your API post in this series, hypermedia explains how your API works together, what resources work with which, and what you can do with a collection, or specific items in that collection.

This will add to both the workload and the time it takes to build your API.

However, by having these relationships already drawn out as suggested, the additional time required will be minimal.

## Hypermedia will require more Data-Transfer

Again, absolutely true.

By adding the links to your response you are increasing the amount of data that needs to be sent back, and slowly down the responses ever so slightly.

However, for MOST APIs the amount of data being added will be minimal and the data/ time difference result will realistically be unnoticeable.

What you will do, however, is help avoid unnecessary calls that are not accessible to a particular item, but may be available to other items.

See the next section for more on this.

## You are creating an API for a client that doesn't exist

Another argument against APIs is that unlike web browsers, there are no browsers for APIs.

Likewise a valid argument, however, one I personally believe falls short as like the web we are seeing advances in APIs and recently an explosion of API exploration tools ranging from API Consoles to the API Notebook.

As more and more APIs are developed there will be more and more emphasis on being able to explore them pragmatically.
Another reason I believe this argument falls short is that by utilizing hypermedia you allow the developers USING your API to build their systems around the information you provide them, creating a more dynamic application that relies on the available actions YOU return to them instead of creating rigidity by hardcoding what actions the user can take from their application in relation to your API and returning errors when those actions fail because they simply were not available to begin with.
For example, for one user you may be able to:
Edit
Suspend
Delete
But for another user who has been suspended, maybe you can only:
Restore
Delete
Because this is dynamic data the developer has no way to determine what actions are available and which ones are not, unless they dig through and try to decipher the user's data which has been returned- making assumptions about your architectures rules which may or may not be correct, and may change with future development.

Hypertext links in this case allow the developer to rely on YOUR rules and architecture, rather than trying to mimic it with their own.

## Nobody knows how to use Hypermedia

There is some truth into this.

Despite existing since 1965, many developers are flustered when first running into hypermedia, choosing to ignore it or misunderstanding how to use it (i.e.

hard-coding the links).

What can help with this, however, is more APIs taking advantage of hypermedia (as being encouraged in the most popular development frameworks), and simple explanations within documentation explaining how the hypertext links work (just as we had to explain how to do a GET, POST, PUT, PATCH, and DELETE when REST first came out).

However, unlike many specs and challenges out there, utilizing hypermedia from a client has a very fast learning curve, and most developers are able to implement it quickly and without any real issue once they understand what it is designed to do.

And once implemented correctly, many developers appreciate knowing that as resource URIs change or additional query parameters are required of them, that their application will be able to "automatically upgrade" to these new requirements without any work or concern on their part.

## Hypermedia makes your API MORE Flexible

Absolutely true.

By adding Hypermedia you are able to add new features more seamlessly- making them immediately available to your users.

It also gives you the power to change certain aspects of your API (i.e.

changing resources, requiring additional GET parameters) without necessarily breaking backwards compatibility IF implemented correctly by your users.

## Hypermedia prevents APIs from breaking

Absolutely false.

As mentioned above, Hypermedia does make your API more flexible, but does not excuse poor design or allow you to break backwards compatibility.

One of the reasons for this, is even if you have a purely hypermedia driven API, such as Stormpath‘s, developers will still hardcode certain URLs to avoid having to make multiple calls.

For example, they may access the /users resource directly to get a list of all users instead of starting from the gateway or entry point of your API and working up to that point through multiple calls.

While this technique does save you (and them) multiple API calls, it does limit your ability to change common or most frequently used resource URIs.
Hypertext links also do nothing for backwards incompatible changes in data– although you could hypothetically use them as a form of versioning.

## Hypermedia replaces Documentation

Hypermedia does increase discoverability of your API's resources and methods, however, it does not replace documentation as it doesn't provide method information, schemas, or examples.

Documentation also serves as a preview to your API, letting developers understand how it works, and potentially make sample calls using an API Console before implementing it into their application.

Hypermedia also does not play a solid role in debugging the implementation of the API when things go wrong.

For this reason, having well written, informative documentation is vital to any API.

In fact, many RESTful hypermedia specs including HAL grant you the ability to embed documentation links for quick reference by developers.

## Hypermedia is a Best Practice

Where hypermedia shines is in its ability to create a flexible API that provides dynamic data for developers based on your architecture and not their own.

In essence, it provides a shortcut for developers that allows them to utilize your API to its fullest without having to rely solely on documentation and writing rules that may or may not not be consistent with those in your application.

Like when building a simple website, one may not see the advantage of Hypermedia right away, but as your API grows and becomes more complex you will find that it becomes a powerful convenience layer, one that will help developers better understand and navigate your API, and one that may prevent you from having to version your API for certain changes that would otherwise be backwards incompatible — if implemented correctly by your users.

As Peter Williams explains in his post, hypermedia turned out to be a saving grace.

And as a key component of REST as defined by Dr. Roy Fielding, it remains a best practice to implement.

## In Summary

Hypermedia is often misunderstood in regards to APIs, but essentially it functions exactly like links on a webpage.

And while the technology is both praised and criticized, it does provide an array of short and long-term gains.

These gains, I believe, become more and more noticeable the larger and more complex your API becomes.

However, the best features of utilizing HATEOAS, in my opinion, are yet to be seen as technology and API exploration tools continue to advance.
Be sure to join us next week as we take a look at implementing hypermedia into your API and the current specs out there to help you do so.

# The Harsh Reality of the State of Hypermedia Specs

Hypermedia sounds great in theory, but theory only goes so far.

Where hypermedia really shines, or completely fails, is in implementation.

Unfortunately, as hypermedia is still a relatively new aspect of web based APIs, there isn't one specified way of doing things.

In fact, you'll find that even some of the most popular APIs operate completely differently from each other.
After all, there are several different hypermedia formats available for API providers to choose from.

Just for starters there is HAL, Collection+JSON, JSON-LD, JSON API, and Siren! But the list doesn't stop there, as some popular APIs have even elected to create their own format.
For example, while PayPal's API closely mimics the JSON API format, it goes a step further and adds a method property (not part of the JSON API spec), creating a more flexible spec and transforming it from being resource driven to being action driven:
This has the potential to let developers create a more agile client based on the actions (and methods) available to them.

However, for developers not familiar with PayPal's format, but familiar with JSON API this may cause slight confusion (although it should be quickly remedied by reading their docs).
VerticalResponse, on the other hand, has taken a different, albeit interesting approach.

For their API they likewise start with the basic JSON API format, but for some reason decided against the universally accepted "href" or Hypertext Reference property, instead opting to use "url" or the uniform resource locator as the link URI identifier:
Personally, I would recommend staying with the uniform "href" attribute as it denotes a reference to a hypertext link and is not as exclusive as an URL- which is not (although it commonly is) to be confused with URI.

But you can read more on that here.
On the other hand, Amazon's AppStream API, Clarify, Microsoft's Lync, and FoxyCart all prefer to follow HAL or the Hypertext Application Language format.

HAL provides a simple format for nest-able links, but like other specs omits the methods property as included by PayPal, making theirs truly unique in that sense:
However FoxyCart takes it one step further, not only taking advantage of hypermedia, but offering multiple formats for their clients to choose from, including HAL+JSON, HAL+XML, and Siren.
This, however, highlights once again one of the biggest challenges with hypermedia driven APIs, the abundance of ideas and specs available for execution.

While on one-hand I believe that by supporting both XML and JSON, as well as having multiple JSON formats FoxyCart is by far the most flexible (format wise) of the APIs, not having a singular standard for each language does present the challenge of forcing developers (and hypermedia clients) to support multiple formats (as they integrate more and more hypermedia APIs), while also having the understanding that not one format meets every API's needs.
The good news, is that despite these growing pains, we are starting to see companies adopting certain specs over others, while also identifying areas for improvement (such as with PayPal's adding of methods to JSON API).

Next week we'll take a look at some of the most popular formats out there in-depth, keying in on the strengths and weaknesses of each.
But it's important that as you build your API, you understand WHY you are building it the way you are.

And this extends into how you build your hypermedia links, and whether or not you choose to take advantage of a standardized format (recommended), or venture off on your own to meet your developers' needs.

One of the best ways to do this is to explore what others have done with their APIs, and learn from their successes, and their mistakes.
It's also important to consider where technology is going.

And as more and more formats become available and change in popularity, it may be smart to follow FoxyCart's lead – taking advantage of the spec that best meets your developers' needs, but also keeping the link format decoupled enough from your data that you are able to return multiple formats based on the content-type received.

Something that will allow you to take advantage of this best practice, while also being prepared for whatever the future may hold.

# Specs

What essentially every hypertext linking spec does provide is a name for the link and a hypertext reference, but outside of that, it's a crapshoot.

As such, it's important to understand the different specs that are out there, which ones are leading the industry, and which ones meet your needs.

We may not be able to get it down to one spec, but at least we'll be able to provide our users with a uniform response that they can easily incorporate into their application:

## Collection+JSON

Collection+JSON is a JSON-based read/write hypermedia-type designed by Mike Amundsen back in 2011 to support the management and querying of simple collections.

It's based on the Atom Publication and Syndication specs, defining both in a single spec and supporting simple queries through the use of templates.

While originally widely used among APIs, Collection+JSON has struggled to maintain its popularity against JSON API and HAL.
Strengths: strong choice for collections, templated queries, early wide adoption, recognized as a standard Weaknesses: JSON only, lack of identifier for documentation, more complex/ difficult to implement

## JSON API

JSON API is a newer spec created in 2013 by Steve Klabnik and Yahuda Klaz.

It was designed to ensure separation between clients and servers (an important aspect of REST) while also minimizing the number of requests without compromising readability, flexibility, or discovery.

JSON API has quickly become a favorite receiving wide adoption and is arguably one of the leading specs for JSON based RESTful APIs.

JSON API currently bares a warning that it is a work in progress, and while widely adopted not necessarily stable.
Strengths: simple versatile format, easy to read/ implement, flat link grouping, URL templating, wide adoption, strong community, recognized as a hypermedia standard
Weaknesses: JSON only, lack of identifier for documentation, still a work in progress

## HAL

HAL is an older spec, created in 2011 by Mike Kelly to be easily consumed across multiple formats including XML and JSON.

One of the key strengths of HAL is that it is nestable, meaning that _links can be incorporated within each item of a collection.

HAL also incorporates CURIEs, a feature that makes it unique in that it allows for inclusion of documentation links in the response – albeit they are tightly coupled to the link name.

HAL is one of the most supported and most widely used hypermedia specs out there today, and is surrounded by a strong and vocal community.
Strengths: dynamic, nestable, easy to read/ implement, multi-format, URL templating, inclusion of documentation, wide adoption, strong community, recognized as a standard hypermedia spec, RFC proposed Weaknesses: JSON/XML formats architecturally different, CURIEs are tightly coupled

## JSON-LD

JSON-LD is a lightweight spec focused on machine to machine readable data.

Beyond just RESTful APIs, JSON-LD was also designed to be utilized within non-structured or NoSQL databases such as MongoDB or CouchDB.

Developed by the W3C JSON-LD Community group, and formally recommended by W3C as a JSON data linking spec in early 2014, the spec has struggled to keep pace with JSON API and HAL.

However, it has built a strong community around it with a fairly active mailing list, weekly meetings, and an active IRC channel.
Strengths: strong format for data linking, can be used across multiple data formats (Web API & Databases), strong community, large working group, recognized by W3C as a standard
Weaknesses: JSON only, more complex to integrate/ interpret, no identifier for documentation

## Siren

Created in 2012 by Kevin Swiber, Siren is a more descriptive spec made up of classes, entities, actions, and links.

It was designed specifically for Web API clients in order to communicate entity information, actions for executing state transitions, and client navigation/ discoverability within the API.

Siren was also designed to allow for sub-entities or nesting, as well as multiple formats including XML – although no example or documentation regarding XML usage is provided.

Despite being well intentioned and versatile, Siren has struggled to gain the same level of attention as JSON API and HAL.

Siren is still listed as a work in progress.
Strengths: provides a more verbose spec, query templating, incorporates actions, multi-format
Weaknesses: poor adoption, lacks documentation, work in progress

## Other Specs

Along with some of the leading specs mentioned above, new specs are being created every day including UBER, Mason, Yahapi, and CPHL.

This presents a very interesting question, and that is are we reinventing the wheel, or is there something missing in the above specs.

I believe the answer is a combination of both, with developers being notorious for reinventing the wheel, but also because each developer looks at the strengths and weaknesses of other specs and envisions a better way of doing things.
You may recognize this issue from the last post, where some specs were modified by the companies using them to meet their individual needs.

For example, PayPal wanted to include methods in their response, but you'll notice that only Siren of the above include methods in the link definition.

## The Future of Specs

Given that new specs are being created every day, each with different ideas and in different formats, it's extremely important to keep your system as decoupled and versatile as possible, and it will be very interesting to see what the future of hypermedia specs will look like.
In the mean-time, it's best to choose the spec that meets your needs, while also being recognized as a standard for easy integration by developers.

Of the specs above, I would personally recommend sticking with HAL or JSON API, although each has its own strengths and weaknesses, and I believe that universal spec of the future has yet to be created.

But by adhering to these common specs while the new specs battle things out, I think we will finally find that standard method of road signs, detours, and a single solution to provide API clients with a standardized GPS system.
For more on the different specs, I highly recommend reading Kevin Sookocheff's review.

I'd also love to hear your thoughts in the comments below.

## MUST: Use REST Maturity Level 2

We strive for a good implementation of REST Maturity Level 2 as it enables us to build resource-oriented APIs that make full use of HTTP verbs and status codes. You can see this expressed by many rules throughout these guidelines, e.g.:

Avoid Actions — Think About Resources
Keep URLs Verb-Free
Use HTTP Methods Correctly
Use Meaningful HTTP Status Codes
Although this is not HATEOAS, it should not prevent you from designing proper link relationships in your APIs as stated in rules below.

## MAY: Use REST Maturity Level 3 - HATEOAS

We do not generally recommend to implement REST Maturity Level 3. HATEOAS comes with additional API complexity without real value in our SOA context where client and server interact via REST APIs and provide complex business functions as part of our e-commerce SaaS platform.

Our major concerns regarding the promised advantages of HATEOAS (see also RESTistential Crisis over Hypermedia APIs, Why I Hate HATEOAS and others):

We follow the API First principle with APIs explicitly defined outside the code with standard specification language. HATEOAS does not really add value for SOA client engineers in terms of API self-descriptiveness: a client engineer finds necessary links and usage description (depending on resource state) in the API reference definition anyway.
Generic HATEOAS clients which need no prior knowledge about APIs and explore API capabilities based on hypermedia information provided, is a theoretical concept that we haven't seen working in practise and does not fit to our SOA set-up. The OpenAPI description format (and tooling based on OpenAPI) doesn't provide sufficient support for HATEOAS either.
In practice relevant HATEOAS approximations (e.g. following specifications like HAL or JSON API) support API navigation by abstracting from URL endpoint and HTTP method aspects via link types. So, Hypermedia does not prevent clients from required manual changes when domain model changes over time.
Hypermedia make sense for humans, less for SOA machine clients. We would expect use cases where it may provide value more likely in the frontend and human facing service domain.
Hypermedia does not prevent API clients to implement shortcuts and directly target resources without 'discovering' them
However, we do not forbid HATEOAS; you could use it, if you checked its limitations and still see clear value for your usage scenario that justifies its additional complexity. If you use HATEOAS please share experience and present your findings in the API Guild [internal link].

## MUST: Use Common Hypertext Controls

When embedding links to other resources into representations you must use the common hypertext control object. It contains at least one attribute:

href: The URI of the resource the hypertext control is linking to. All our API are using HTTP(s) as URI scheme.
In API that contain any hypertext controls, the attribute name href is reserved for usage within hypertext controls.

The schema for hypertext controls can be derived from this model:

HttpLink:
  description: A base type of objects representing links to resources.
  type: object
  properties:
    href:
      description: Any URI that is using http or https protocol
      type: string
      format: uri
  required: [ "href" ]
The name of an attribute holding such a HttpLink object specifies the relation between the object that contains the link and the linked resource. Implementations should use names from the IANA Link Relation Registry whenever appropriate. As IANA link relation names use hyphen-case notation, while this guide enforces snake_case notation for attribute names, hyphens in IANA names have to be replaced with underscores (e.g. the IANA link relation type version-history would become the attribute version_history)

Specific link objects may extend the basic link type with additional attributes, to give additional information related to the linked resource or the relationship between the source resource and the linked one.

E.g. a service providing "Person" resources could model a person who is married with some other person with a hypertext control that contains attributes which describe the other person (id, name) but also the relationship "spouse" between between the two persons (since):

{
  "id": "446f9876-e89b-12d3-a456-426655440000",
  "name": "Peter Mustermann",
  "spouse": {
    "href": "https://...",
    "since": "1996-12-19",
    "id": "123e4567-e89b-12d3-a456-426655440000",
    "name": "Linda Mustermann"
  }
}
Hypertext controls are allowed anywhere within a JSON model. While this specification would allow HAL, we actually don't recommend/enforce the usage of HAL anymore as the structural separation of meta-data and data creates more harm than value to the understandability and usability of an API.

## SHOULD: Use Simple Hypertext Controls for Pagination and Self-References

Hypertext controls for pagination inside collections and self-references should use a simple URI value in combination with their corresponding link relations (next, prev, first, last, self) instead of the extensible common hypertext control

See Pagination for information how to best represent paginateable collections.

## MUST: Not Use Link Headers with JSON entities

We don't allow the use of the Link Header defined by RFC 5988 in conjunction with JSON media types. We prefer links directly embedded in JSON payloads to the uncommon link header syntax.

## MUST: Follow Hypertext Control Conventions

APIs that provide hypertext controls (links) to interconnect API resources must follow the conventions for naming and modeling of hypertext controls as defined in section Hypermedia.

