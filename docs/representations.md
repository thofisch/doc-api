# Representations

A *representation* (request/response) is concrete and real. Here we will offer guidelines as to what makes a good response design. To ensure scalability and longevity of the API, along with providing helpful responses that developers can understand and trust, we will cover what HTTP headers are appropriate in a response, which HTTP status codes to return, as well as how to include descriptive error representations on failures.

## HTTP Headers

Headers ensure visibility, discoverability, routing by proxies, caching, optimistic concurrency, and correct operation of HTTP as an application protocol.

Use the following headers to annotate representations that contains a message body.

### Content-Type

Even though it is perfectly acceptable to use only a single format, in order to keep the API flexible and extendable, it is also important to build for the future. Until recently XML was the format of choice, but then along came JSON.

- **DO** use `Content-Type`, to describe the type of representation, including a `charset` parameter or other parameters defined for that media type.
- **DO** include the `charset` parameter, if the media type supports it, with a value of the character encoding used to convert characters into bytes.
- **DO** use the specified encoding, when you receive a representation with a media type that supports the `charset`parameter.
- **DO** let your parser interpret the character set, if you receive an XML representation with a missing `charset` parameter.
- **AVOID** using the `text/xml` media type for XML-formatted representations. The default charset for `text/xml` is `us-ascii`, whereas `application/xml` uses `UTF-8`.

> Note that Text and XML media types let you specify the character encoding. The JSON media type `application/json` does not specify a `charset` parameter, but uses `UTF-8` as the default encoding.

### Content-Length

- **DO** use `Content-Length`, to specify the size in bytes of the body. Or specify `Transfer-Encoding: chunked`. Some proxies reject `POST` and `PUT` requests that contain neither of these headers.

### Content-Language

- **DO** use `Content-Language`, two-letter RFC 5646 language tag, optionally followed by a hyphen (-) and any two-letter country code.

### Content-Encoding

- **DO** use `Content-Encoding`. Clients can indicate their preference for `Content-Encoding` using the `Accept-Encoding` header, however, there is no standard way for the client to learn whether a server can process representations compressed in a given encoding.

### Other Common Headers

- **CONSIDER** using `ETag` and/or `Last-Modified` for caching and/or concurrency, the latter applies for responses only.
- **CONSIDER** using `Content-MD5`, when sending or receiving large representations over potentially unreliable networks to verify the integrity of the message.
- **DO NOT** use `Content-MD5` as any measure of security.

## Custom HTTP Headers

!!! warning
    Generally custom HTTP headers should be avoided, as they may impede interoperability. We discourage the use of hop-by-hop custom HTTP headers.

However, depending on what clients and servers use custom headers for, they can be useful in cases where context information needs to be passed through multiple services in an end-to-end fashion. 

- **DO** use custom headers for informational purposes.
- **CONSIDER** using the convention `X-{company-name}-{header-name}`, when introducing custom headers, as there is no established convention for naming custom headers. Avoid camelCase (without hyphens). Exceptions are common abbreviations like `ID`. _**the usage of X- headers is deprecated (RFC-6648)**_
- **CONSIDER** including the information in a custom HTTP header in the body or the URI, if the information is important for the correct interpretation of the request
- **DO NOT** implement clients and servers such that they fail when they do not find expected custom headers.
- **DO NOT** use custom HTTP headers to change behavior of HTTP methods, and limit any behavior-changing headers to `POST`.
- **DO NOT** use `X-HTTP-Method-Override` to override `POST`, use a distinct resource to process the same request using `POST` without the header. Any HTTP intermediary between the client and the server may omit custom headers.

### End-To-End HTTP Headers

- **DO** use the specified end-to-end HTTP headers.
- **DO** propagate the end-to-end HTTP headers to upstream servers. Header names and values must remain intact.

!!! hint "The following may be candidates for end-to-end HTTP headers"
    1. Correlation ID of the request, which is written into the logs and passed to upstream services. 
    1. Generic user id that owns the passed (OAuth2) access token. May save additional token validation round trips
    1. Sales channel
    1. Device type, OS, and version
    1. App version, etc.

## Format and a Media Type

HTTP's message format is designed to allow different media types and formats for requests and responses.

When it comes to format and media type selection, the rule of thumb is to let the use cases and the types of clients dictate the choice. For this reason, it is important not to pick up a development framework that rigidly enforces one or two formats for all resource with no flexibility to use other formats.

- **DO** determine whether there is a standard format and media type that matches your use cases. Check IANA [^1].
- **DO** use extensible formats such as XML, Atom Syndication Format, or JSON, if there is no standard media type and format.
- **CONSIDER** adding a `Content-Disposition: attachment; filename=<status.xls>` to give a hint of the filename, when using image formats like `image/png` or rich document formats like `application/vnd.ms-excel` or `application/pdf` to provide alternative representations of data.

If you choose to create new media types of your own, consider:

- **DO** use a sub-type that ends with `+xml` in the `Content-Type` header, when using XML
- **DO** use a sub-type starting with `vnd` (`application/vnd.example.org.user+xml`), when the media type is for private use,
- **DO** register your media type with IANA as per RFC 4288, if the media type is for public use,
- **AVOID** introducing new application-specific media types unless they are expected to be broadly used, as this may impede interoperability.

!!! warning
    Although custom media types improve protocol-level visibility, existing protocol-level tools for monitoring, filtering, or routing HTTP traffic pay little or no attention to media types. Hence, using custom media types only for the sake of protocol-level visibility is not necessary.

## Use Portable Data Formats in Representations

- **DO** use decimal, float and double data types defined in the W3C XML Schema for formatting numbers including currency.
- **DO** use ISO 3166 (ISO 3166-1-alpha2) codes for countries and dependent territories.
- **DO** use ISO 4217 alphabetic or numeric codes for denoting currency.
- **DO** use RFC 3339 for dates, times, and date-time values used in representations. Time durations and intervals could conform to ISO 8601
- **DO** use ISO 639-1 language tags for representing the language of text. BCP-47 (based on ISO 639-1) for language variants.
- **DO** use time zone identifiers from the Olson Time Zone Database to convey time zones.
- **DO** use the HTTP-date format defined in RFC 7231 Section 7.1.1.1. (Date/Time Formats) for `Last-Modified`, `Date`, and `Expires` HTTP headers.
- **AVOID** using language-, region-, or country-specific formats or format identifiers, except when the text is meant for presentation to end users.

Also, consider defining the format for numbers and integers. The precision could be described as follows, to prevent clients from guessing the precision:

| Type    | Format  | Specified value range                                 |
|---------|---------|-------------------------------------------------------|
| integer | int32   | integer between -2^31 and 2^31-1                      |
| integer | int64   | integer between -2^63 and 2^63-1                      |
| integer | bigint  | arbitrarily large signed integer number               |
| number  | float   | IEEE 754-2008/ISO 60559:2011 binary64 decimal number  |
| number  | double  | IEEE 754-2008/ISO 60559:2011 binary128 decimal number |
| number  | decimal | arbitrarily precise signed decimal number             |

## JSON Representations

JSON has become the de facto format within RESTful APIs, by providing a compact, human-readable format for accessing data, which can help minimalize the bandwidth required.

One of the advantages to REST is that it is not limited to a single format, and the choice of format should be based on what is most suitable for the clients.

- **DO** prefer JSON over XML to encode structured representations, whenever possible.
- **DO** include a *self* link to the resource in each representation.
- **DO** add a property to indicate the language, if an object in the representation is localized.
- **DO** pretty print the representation by default, as this will help when using a browser to access the public API. Together with compression the additional white-space characters are negligible.
- **DO** use gzip compression, if applicable.
- **DO** prefer `application/json` over more specialized and custom media type like `application/example.booking+json`.
- **DO** use consistent property names.
- **DO** use camelCase for property names.
- **DO** use a subset of `us-ascii`for property names. The first character must be a letter, an underscore or a dollar sign, and subsequent characters can be a letter, an underscore, a dollar sign, or a number.
- **DO** pluralize arrays to indicate they contain multiple values prefer to pluralize array names. This implies that object names should in turn be singular.
- **DO** use consistent property values
- **DO** use string to represent enumerations.
- **CONSIDER** using common field names and semantics to achieve consistency across the API portfolio, as there is very little utility for clients in having different names or value types for these fields across APIs. Candidates are, but not limited to: *id*, *relation_id*, *type*, *created*, *modified/updated*.
- **CONSIDER** including entity identifiers for each of the application domain entities that make up the resource.
- **CONSIDER** the use of an envelope by default. Only use envelopes in exceptional cases.
- **CONSIDER** follow RFC-7159 by having (if possible) a serialized object as the top-level structure, since it would allow for future extension. 
- **DO NOT** return an array as the top-level structure, as this may expose security vunerabilities. Instead use an envelope, like: `{ list: [...]}`.
- **DO NOT** use `null` for boolean property values must not be null. A boolean is essentially a closed enumeration of two values, true and false. If the content has a meaningful null value, strongly prefer to replace the boolean with enumeration of named values or statuses.
- **DO NOT** return `null` for empty array values should not be null. Empty array values can unambiguously be represented as the the empty list, [].

??? example
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

### Representations of Collections

- **DO** return an empty collection, if the query does not match any resources.
- **DO** include pagination links.

### Pagination

- **DO** add a self link to the collection resource
- **DO** add link to the next page, if the collection is paginated and has a next page
- **DO** a link to the previous page, if the collection is paginated and has a previous page
- **DO** add an indicator of the size of the collection
- **DO** keep collections homogeneous by include only the homogeneous aspects of its member resources.

!!! tip
    Although the size of the collection is useful for building user interfaces, avoid computing the exact size of the collection. It may be expensive to compute, volatile, or even confidential. Providing a hint is usually good enough.

<!-- TODO -->

    ## PAGINATION

    limit — to restrict the number of entries. See Pagination section below. Hint: You can use size as an alternate query string.
    offset — numeric offset page start. See Pagination section below. Hint: In combination with limit, you can use page as an alternative to offset.
    cursor — key-based page start. See Pagination section below.

    ## Pagination and partial response

    Partial response allows you to give developers just the information they need.

    Take for example a request for a tweet on the Twitter API. You'll get much more than a typical twitter app often needs - including the name of person, the text of the tweet, a timestamp, how often the message was re-tweeted, and a lot of metadata.

    Let's look at how several leading APIs handle giving developers just what they need in responses, including Google who pioneered the idea of partial response.

    LinkedIn

    /people:(id,first-name,last-name,industry)

    This request on a person returns the ID, first name, last name, and the industry.

    LinkedIn does partial selection using this terse :(...) syntax which isn't self-evident.

    Plus it's difficult for a developer to reverse engineer the meaning using a search engine.

    Facebook

    /joe.smith/friends?fields=id,name,picture

    Google

    ?fields=title,media:group(media:thumbnail)

    Google and Facebook have a similar approach, which works well.

    They each have an optional parameter called fields after which you put the names of fields you want to be returned.

    As you see in this example, you can also put sub-objects in responses to pull in other information from additional resources.

    Add optional fields in a comma-delimited list The Google approach works extremely well.

    Here's how to get just the information we need from our dogs API using this approach:

    /dogs?fields=name,color,location

    It's simple to read; a developer can select just the information an app needs at a given time; it cuts down on bandwidth issues, which is important for mobile apps.


    The partial selection syntax can also be used to include associated resources cutting down on the number of requests needed to get the required information.

    Make it easy for developers to paginate objects in a database 

    It's almost always a bad idea to return every resource in a database.

    Let's look at how Facebook, Twitter, and LinkedIn handle pagination. Facebook uses offset and limit. Twitter uses page and rpp (records per page). LinkedIn uses start and count

    Semantically, Facebook and LinkedIn do the same thing. That is, the LinkedIn start & count is used in the same way as the Facebook offset & limit.

    To get records 50 through 75 from each system, you would use:

    * Facebook - offset 50 and limit 25
    * Twitter - page 3 and rpp 25 (records per page)
    * LinkedIn - start 50 and count 25

    ## Use limit and offset

    We recommend limit and offset. It is more common, well understood in leading databases, and easy for developers.

    /dogs?limit=25&offset=50

    ## Metadata

    We also suggest including metadata with each response that is paginated that indicated to the developer the total number of records available.

    What about defaults?

    My loose rule of thumb for default pagination is limit=10 with offset=0. (limit=10&offset=0)

    The pagination defaults are of course dependent on your data size. If your resources are large, you probably want to limit it to fewer than 10; if resources are small, it can make sense to choose a larger limit.

    In summary:

    Support partial response by adding optional fields in a comma delimited list.

    Use limit and offset to make it easy for developers to paginate objects

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

    # Pagination

    ### Support Pagination

    Access to lists of data items must support pagination for best client side batch processing and iteration experience. This holds true for all lists that are (potentially) larger than just a few hundred entries.

    There are two page iteration techniques:

    Offset/Limit-based pagination: numeric offset identifies the first page entry
    Cursor-based — aka key-based — pagination: a unique key element identifies the first page entry (see also Facebook's guide)
    The technical conception of pagination should also consider user experience related issues. As mentioned in this article, jumping to a specific page is far less used than navigation via next/previous page links. This favours cursor-based over offset-based pagination.

    ### Prefer Cursor-Based Pagination, Avoid Offset-Based Pagination

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

    ### Use Pagination Links Where Applicable

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

## _**XML Representations**_

*TBD*

*Suggested topics:*<br/>
*Atom resources, AtomPub Service, category documents, AtomPub for feed and entry resources, media resources*

## HTML Representations

- **DO** provide HTML representations, for resources that are expected to be consumed by end users.
- **CONSIDER**  using microformats or RDFx to annotate data within the markup.
- **AVOID** avoid designing HTML representations for machine clients.

## Binary Data in Representations

- **DO** use multipart media types such as `multipart/mixed`, `multipart/related`, or `multipart/alternative`.
- **CONSIDER** providing a link to fetch the binary data as a separate resource as an alternative. Creating and parsing multipart messages in some programming languages may be cumbersome and complex.
- **AVOID** encoding binary data within textual formats using Base64 encoding.

##   Error Representations

Communicate errors through standard HTTP status codes along with details supplied in the response body. 

Errors are a key element for providing context and visibility, and status codes enable clients to quickly ascertain the status of their request. While well-formed and descriptive error details will tell the client what happened, why it happened, and how to fix it.

- **DO** provide error documentation.
- **DO** include a `Date` header with a value indicating the date-time at which the error occurred.
- **DO** include a body in the representation formatted and localized using content negotiation or in human-readable HTML or plain text, unless the request method is `HEAD`.
- **DO** provide an identifier or a link that can be used to refer to that error, if you are logging errors on the server side for later tracking or analysis.
- **DO** include a brief message describing the error condition
- **DO** include a longer description with information on how to fix the error condition, if applicable
- **DO** describe any action that the client can take to correct the error or to help the server debug and fix the error, if appropriate.
- **CONSIDER** Use Problem JSON: RFC 7807 defines the media type application/problem+json. Operations should return that (together with a suitable status code) when any problem occurred during processing and you can give more details than the status code itself can supply, whether it be caused by the client or the server (i.e. both for 4xx or 5xx errors).
- **CONSIDER** adding a field breakdown, providing detailed errors, along with a fixed top-level error description, for `PUT`, `PATCH` and `POST` requests.
- **CONSIDER** including a link to that document via a `Link` header or a link in the body, if information to correct or debug the error is available as a separate human-readable document. Also consider tracking the hits to these pages to see what areas tend to be more troublesome for your users – allowing you to provide even better documentation and/or build a better API.
- **AVOID** including details such as stack traces, errors from database connections failures, etc.
- **AVOID** using generic or non-descriptive error messages as they are often one of the biggest hinderances to API integration, as developers may struggle for hours trying to figure out why the call is failing, even misinterpreting the intent of the error message altogether.
- **DO NOT** return `2xx` and include a message body that describes an error condition. Doing so prevents HTTP-aware software from detecting errors.

??? example "Error example"
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

??? example "Validation error example"
    ```json
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
    ```

## HTTP Status Codes

!!! tip "**Always return meaningful HTTP Status Codes!**"

By using meaningful status codes, developers can quickly see what is happening with the application and do a "quick check" for errors without having to rely on the body's response.

- **DO** return `2xx` when the request was received, understood, and accepted.
- **DO** return `3xx` when the client needs to take further action. Include the necessary information in order for the client to complete the request.
- **DO** return a representation with a `4xx` status code, for errors due to client inputs.
- **DO** return a representation with a `5xx` status code, for errors due to server implementation or its current state.
- **DO** use the most specific HTTP status code for your concrete resource request processing status or error situation.
- **DO** provide good documentation in the API definition when using HTTP status codes that are less commonly used and not listed below.
- **DO NOT** invent new HTTP status codes; only use standardized HTTP status codes and consistent with its intended semantics.
 
### `2xx` Success

- **DO** return `200 OK` when the request completed without issues.
- **DO** return `201 Created` when a resource was successfully created. Always set the `Location` header with the URI of the newly created resource. Return either an empty response or the created resource.
- **DO** return `202 Accepted` when a request was successful and will be processed asynchronously.
- **DO** return `204 No content` when there is no response body.
- **DO** return `207 Multi-Status` when the response body contains multiple status informations for different parts of a batch/bulk request.

### `3xx` Client Action May Be Required

- **DO** return `301 Moved Permanently` when this and all future requests should be directed to the URI specified in the `Location` header.
- **DO** return `303 See Other` when the response to the request can be found under the URI specified in the `Location` header using a GET method.
- **DO** return `304 Not Modified` when the resource has not been modified since the date or version passed via request headers `If-Modified-Since` or `If-None-Match`.

### `4xx` Client Errors

- **DO** return `400 Bad Request` when your server cannot decipher client requests because of syntactical errors.
- **DO** return `401 Unauthorized` when the client is not authorized to access the resource, but may be able to gain access after authentication. If your server will not let the client access the resource even after authentication return `403 Forbidden` instead. When returning this error code, include a WWW-Authenticate header field with the authentication method to use.
- **DO** return `403 Forbidden` when your serer will not let the client gain access (authenticated or not).
- **DO** return `404 Not Found` when the resource is not found. If possible, return a reason in the message body.
- **DO** return `405 Not Allowed` when an HTTP method is not allowed. Return an `Allow` header with methods that are valid for the resource.
- **DO** return `406 Not Acceptable`. when the resource can only generate content not acceptable according to the `Accept` headers sent in the request.
- **DO** return `408 Request Timeout` when the server times out waiting for the resource.
- **DO** return `409 Conflict` when the request conflicts with the current state of the resource. Include a body explaining the reason.
- **DO** return `410 Gone` when the resource used to exist, but it does not anymore. You may not be able to return this unless you tracked deleted resources, then return `404 Not Found`.
- **DO** return `412 Precondition Failed` for conditional requests, when `If-Match` and/or `ETag` preconditions fail.
- **DO** return `413 Request Entity Too Large` when the body of a `POST` or `PUT` is too large. If possible, specify what is allowed in the body and provide alternatives.
- **DO** return `415 Unsupported Media Type` when a client sends the message body in a form that the server does not understand.
- **DO** return `423 Locked` when using pessimistic locking.
- **DO** return `428 Precondition Required` when the server requires the request to be conditional (e.g. to make sure that the "lost update problem" is avoided).
- **DO** return `429 Too Many Requests` when the client does not consider rate limiting and sent too many requests. Include headers to indicate rate limits.

### `5xx` Server Errors

- **DO** return `500 Internal Server Error` when your code on the server side failed due to come implementation bug.
- **DO** return `501 Not Implemented` to indicate that a future feature may become available.
- **DO** return `503 Service Unavailable` when the server cannot fulfill the request either for some specific interval or undetermined amount of time. If possible, include a `Retry-After` response header with either a date or a number of seconds as a hint.

## Entity Identifiers in Representations

When an API is part of a larger API portfolio or system, information may cross several system boundaries, and entity identifiers can be used to uniformly identify, cross-reference or transform data. Especially when a lot of different technologies are envolved (RPC, SOAP, asynchronous messaging, stored procedures, etc.) and/or third-party applications, the only common denominator may very well be entity identifiers.

- **CONSIDER** consider formatting identifiers as URNs, for each of the application domain entities included in the representation of a resource, to maintain uniqueness of identifiers.
- **CONSIDER** using strings rather than number types for identifiers, as this gives more flexibility to evolve the identifier naming scheme. Accordingly, if used as identifiers, UUIDs should not be qualified using a format property.
- **CONSIDER** using UUIDs as entity identifiers for scaling in high frequency and near real time use cases, as they can be generated without collisions in a distributed, non-coordinated way and without additional server roundtrips.
- **CONSIDER** limiting the use of UUIDs as entity identifiers when it is not strictly necessary, if it possible to come up with a better naming scheme, if the id volume is low, or if the ids have widespread steering functionality.

[^1]: The Internet Assigned Number Authority ([IANA](http://www.iana.org/assignments/media-types/)) media type registry.
