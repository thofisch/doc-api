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
