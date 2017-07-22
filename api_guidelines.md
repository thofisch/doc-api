# API Guidelines

    ## Abstract
    
    To achieve a RESTful web service follow the six guiding constraints.
    
    
    REST Constraints
    
    1. Client-server
    2. Stateless
    3. Cacheable
    4. Uniform interface
    5. Layered System
    6. Code on demand (optional)
    
    REST Architectural Goals
    
    * Performance
    * Scalability
    * Simplicity
    * Modifiability
    * Visibility
    * Portability
    * Reliability
    
    The REST uniform contract is based on three fundamental elements:
    
    1. *resource identifier syntax* - How can we express where is the data being transferred to or from?
    2. *methods* - What are the protocol mechanisms used to transfer the data?
    3. *media types* - What type of data is being transferred?
    
    Aspects of designing RESTful web services:
    
    - identification of resources
    - choice of media types and formats
    - application of the uniform interface



## HTTP as the Uniform Interface

One of the key goals of the REST architecture is to maintain visibility, which let you benefit from existing software and infrastructure for features that you would otherwise have to build yourself.

HTTP is an application-level protocol that is designed to keep interactions between clients and servers visible. HTTP defines operations (along with, e.g., headers), such as `GET`, `POST`, `PUT` and `DELETE`, for transferring representations between clients and servers, eliminating the need for application-specific operations (e.g. *createBooking*, *changeBooking*, etc.). This means that caches, proxies, firewalls, etc., can monitor and participate in the protocol.

> Visibility means that one component of an architecture can monitor (and even regulate) the interaction between other components of the same architecture

For better visibility:

- **DO** make interactions stateless
- **DO** use HTTP methods (`GET`, `HEAD`,`POST`,`PUT`,`DELETE`, and `TRACE`).
- **DO** use appropriate headers to describe requests and responses
- **DO** use appropriate status codes and messages
- **DO NOT** change syntax and meaning, specified by HTTP, from application to application or from resource to resource

Keep in mind that focusing solely on visibility may create too fine-grained resources and poor separation of concern between clients and servers, and trading visibility for other benefits is not necessarily bad.

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

### URIs For Queries

Queries usually involve filtering, sorting and projections.

- **DO** use query parameters to let clients specify filter conditions, sort fields, and projections.
- **DO** treat query parameters as optional with sensible defaults.
- **DO** document each parameter.
- **CONSIDER** using a generic `sort` parameter to describe sorting rules. To accommodate more complex sorting requirements, let the `sort` parameter take a lift of comma-separated fields, each with a possible unary negative to imply descending sort order. Like: `GET /tickets?sort=-priority,created_at`
- **CONSIDER** using a `fields` query parameter for projections, like `http://www.example.org/customers?fields=name,gender,birthday`
- **CONSIDER** using a `view` query parameter for predefined projections, like `http://www.example.org/customers?view=summary`
- 
- **CONSIDER** supporting aliases for commonly used queries (it may also improve cacheability). For instance, `GET /tickets/recently_closed`
- **AVOID** ad hoc queries that use general-purpose query languages such as *SQL* or *XPath*.
- **AVOID** `Range` requests for implementing queries.

    <!-- TODO -->
    *Filtering, Searching, Sorting, and Projection*

### Using URIs in Clients

- **DO** update local copies of old URIs when receiving `301 Moved Permanently`.
- **DO** verify that the `Location` URI maps to a trusted server.
- **DO NOT** disable support of redirects in client applications. Instead, consider a sensible limit on the number of redirects a client can follow. Disabling redirects altogether will break the client when the server change URIs.


## Methods

HTTP supports the following methods:

|Method   |Safe|Idempotent|
|---------|----|----------|
|`GET`    |Yes |Yes       |
|`HEAD`   |Yes |Yes       |
|`OPTIONS`|Yes |Yes       |
|`PUT`    |No  |Yes       |
|`DELETE` |No  |Yes       |
|`POST`   |No  |No        |
|`PATCH`  |No  |No        |

Safety and idempotency are guarantees that a server must provide to clients for certain methods:

- *Safe methods* (or read-only operations) are expected not to cause side-effects, however, safety does not mean the server must return the same response every time.
- *Idempotent methods* must guarantee that every request has the same effect, and is highly important in case of failures.

### `GET`

- **DO** use `GET` to get a *safe* and *idempotent* representation of a resource.
- **DO NOT** use `GET` for unsafe and nonidempotent operations, use `POST` instead.

### `PUT`

- **DO** use `PUT` to update a resource.
- **DO NOT** use `PUT` to create new resources unless the clients can decide URIs of resources (e.g., WebDAV), instead use `POST`.

### `DELETE`

- **DO** use `DELETE` to delete a resource. Always return `200 OK`, however, it is impractical to keep track of all deleted resource, so a `404 Not Found` may be a viable alternative. Security policies may also require the server to return `404 Not Found` for any resource that does not currently exist.

### `POST`

- **DO** use `POST` to create resources.
- **DO** use `POST` to modify one or more resources.
- **DO** use `POST` to for queries with large inputs.
- **DO** use `POST` to perform any unsafe and nonidempotent operation, when no other HTTP method seems appropriate, and only as a last resort (avoid tunneling like SOAP).
- **DO NOT** use nonstandard custom HTTP methods. Instead, design a controller resource that can abstract such operations, and `POST`.

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

```
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

```
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

    <!-- TODO -->
    
    Doing PATCH “properly”
    According to the HTTP specification, PUT must take the full resource representation in the request. This can be a bit cumbersome, so PATCH is increasingly being adopted for partial updates.
    
    Given that PATCH is only a proposed standard there are details around the semantics of the method that are not widely understood. It’s not a simple replacement for POST and PUT where you supply a flat list of values to change. The request should supply a set of instructions for updating an entity and these should be applied atomically.
    
    A “set of instructions” is very different from a “set of values” and the specification clearly states that a request should be a different content type to the resource being modified. The detail of the representation is down to you, but RFC6902 describes a JSON format for PATCH where each object represents a single operation, e.g. “add”, “copy”, “delete” and so on. Each type of operation is described in eye-watering detail in the specification.
    
    The point here is that there is a lot more to PATCH than meets the eye. Unless you adopt a complex semantic format for describing change then you are likely to arouse the ire of the “you’re doing it wrong” brigade.
    
    <!-- TODO -->
    
    - 11.8. How to Refine Resources for Partial Updates
    - 11.9. How to use the `PATCH` Method

### Using Methods in Clients

- **DO** treat `GET`, `OPTIONS`, and `HEAD` as safe operations, and send as required. Include `If-Unmodified-Since` and/or `If-Match` conditional headers, if applicable.
- **DO** resubmit `GET`, `PUT`, and `DELETE` requests, in case of failures, to confirm.
- **DO** implement retry logic, whenever you encounter a failure for an idempotent method.
- **DO** submit a `POST` request with a representation of the resource to be created to the factory resource.
- **DO NOT** repeat `POST` requests unless the documentation states that is idempotent.
- **DO NOT** treat various HTTP-level errors as failures (network or software) or like exceptions.

## Resources

A *resource* is an abstract entity that is identified by a URI, and can be data, processing logic, files, or anything else that a service may have access to.

### Identifying and Naming Resources

Care should be taking when identifying resources and finding the right resource granularity.

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

- **DO** identify new resources that aggregate other resources to reduce the number of client/server round-trips, based on client usage patterns, performance, and latency requirements.
- **CONSIDER** a snapshot page to summarize information, using an URI of the form `http://www.example.org/customer/1234/snapshot`.
- **CONSIDER**, if requests for composites are rare, or if network latency is an issue, whether caching may be a better option.

### Processing Functions

- **DO** treat the processing function as a resource
- **DO** use `GET` to fetch a representation containing the output of the processing function.
- **DO** use query parameters to supply inputs to the processing function.

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

### HTTP Headers

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

- **DO** include a *self* link to the resource in each representation.
- **DO** add a property to indicate the language, if an object in the representation is localized.
- **DO** pretty print the representation by default, as this will help when using a browser to access the public API. Together with compression the additional white-space characters are negligible.
- **CONSIDER** including entity identifiers for each of the application domain entities that make up the resource.

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

> ###### TIP
> Although the size of the collection is useful for building user interfaces, avoid computing the exact size of the collection. It may be expensive to compute, volatile, or even confidential. Providing a hint is usually good enough.

#### Use Portable Data Formats in Representations

- **DO** use decimal, float and double data types defined in the W3C XML Schema for formatting numbers including currency.
- **DO** use ISO 3166 codes for countries and dependent territories.
- **DO** use ISO 4217 alphabetic or numeric codes for denoting currency.
- **DO** use RFC 3339 for dates, times, and date-time values used in representations.
- **DO** use BCP 47 language tags for representing the language of text
- **DO** use time zone identifiers from the Olson Time Zone Database to convey time zones.
- **AVOID** using language-, region-, or country-specific formats or format identifiers, except when the text is meant for presentation to end users.

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

### HTML Representations

- **DO** provide HTML representations, for resources that are expected to be consumed by end users.
- **CONSIDER**  using microformats or RDFx to annotate data within the markup.
- **AVOID** avoid designing HTML representations for machine clients.

### HTTP Status Codes

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
    
    - 13.1. How to Maintain URI Compatibility
    - 13.2. How to Maintain Compatibility of XML and JSON Representations
    - 13.3. How to Extend Atom
    - 13.4. How to Maintain Compatibility of Links
    - 13.5. How to Implement Clients to Support Extensibility
    - 13.6. When to Version
    - 13.7. How to Version RESTful Web Services

## 14. Documentation and Discovery

    <!-- TODO -->
    
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

### Citations
### Bibliography

Allamaraju, S. (2010). RESTful web services cookbook: Solutions for improving scalability and simplicity. Yahoo Press.
