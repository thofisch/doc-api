## Representations

A *representation* (request/response) is concrete and real. Here we will offer guidelines as to what makes a good response design. To ensure scalability and longevity of the API, along with providing helpful responses that developers can understand and trust, we will cover what HTTP headers are appropriate in a response, which HTTP status codes to return, as well as how to include descriptive error representations on failures.

### HTTP Headers

Headers ensure visibility, discoverability, routing by proxies, caching, optimistic concurrency, and correct operation of HTTP as an application protocol.

Use the following headers to annotate representations that contains a message body.

#### Content-Type

Even though it is perfectly acceptable to use only a single format, in order to keep the API flexible and extendable, it is also important to build for the future. Until recently XML was the format of choice, but then along came JSON.

- **DO** use `Content-Type`, to describe the type of representation, including a `charset` parameter or other parameters defined for that media type.
- **DO** include the `charset` parameter, if the media type supports it, with a value of the character encoding used to convert characters into bytes.
- **DO** use the specified encoding, when you receive a representation with a media type that supports the `charset`parameter.
- **DO** let your parser interpret the character set, if you receive an XML representation with a missing `charset` parameter.
- **AVOID** using the `text/xml` media type for XML-formatted representations. The default charset for `text/xml` is `us-ascii`, whereas `application/xml` uses `UTF-8`.

> Note that Text and XML media types let you specify the character encoding. The JSON media type `application/json` does not specify a `charset` parameter, but uses `UTF-8` as the default encoding.

#### Content-Length

- **DO** use `Content-Length`, to specify the size in bytes of the body. Or specify `Transfer-Encoding: chunked`. Some proxies reject `POST` and `PUT` requests that contain neither of these headers.

#### Content-Language

- **DO** use `Content-Language`, two-letter RFC 5646 language tag, optionally followed by a hyphen (-) and any two-letter country code.

#### Content-Encoding

- **DO** use `Content-Encoding`. Clients can indicate their preference for `Content-Encoding` using the `Accept-Encoding` header, however, there is no standard way for the client to learn whether a server can process representations compressed in a given encoding.
- **DO NOT** use `Content-Encoding` in HTTP requests, unless you know out of band that the target server supports a particular encoding method.

#### Other Common Headers

- **DO** set the appropriate expiration caching headers. See [Caching](/caching).
- **DO** use `Content-MD5`, when sending or receiving large representations over potentially unreliable networks to verify the integrity of the message.
- **DO NOT** use `Content-MD5` as any measure of security.
- **CONSIDER** using `ETag` and/or `Last-Modified` for caching and/or concurrency, the latter applies for responses only.

<!-- TODO -->

    ### SHOULD:: Use Location Header instead of Content-Location Header

    As the correct usage of Content-Location with respect to semantics and caching is difficult, we discourage the use of Content-Location. In most cases it is sufficient to direct clients to the resource location by using the Location header instead without hitting the Content-Location specific ambiguities and complexities.

    More details in RFC 7231 7.1.2 Location, 3.1.4.2 Content-Location

    ### MAY: Use the Prefer header to indicate processing preferences

    The Prefer header defined in RFC7240 allows clients to request processing behaviors from servers. RFC7240 pre-defines a number of preferences and is extensible, to allow others to be defined. Support for the Prefer header is entirely optional and at the discretion of API designers, but as an existing Internet Standard, is recommended over defining proprietary "X-" headers for processing directives.

    Supporting APIs may return the Preference-Applied header also defined in RFC7240 to indicate whether the preference was applied.

### Custom HTTP Headers

    As a general rule, proprietary HTTP headers should be avoided.

    Still they can be useful in cases where context needs to be passed through multiple services in an end-to-end fashion

    As such, a valid use-case for a proprietary header is providing context information, which is not a part of the actual API, but is needed by subsequent communication.

Depending on what clients and servers use custom headers for, custom headers may impede interoperability.

    This section shares definitions of proprietary headers that should be named consistently because they address overarching service-related concerns. Whether services support these concerns or not is optional; therefore, the OpenAPI API specification is the right place to make this explicitly visible. Use the parameter definitions of the resource HTTP methods.

- **DO** use custom headers for informational purposes.
- **CONSIDER** using the convention `X-{company-name}-{header-name}`, when introducing custom headers, as there is no established convention for naming custom headers. Avoid camelCase (without hyphens). Exceptions are common abbreviations like `ID`. _**the usage of X- headers is deprecated (RFC-6648)**_
- **CONSIDER** including the information in a custom HTTP header in the body or the URI, if the information is important for the correct interpretation of the request
- **DO NOT** implement clients and servers such that they fail when they do not find expected custom headers.
- **DO NOT** use custom HTTP headers to change behavior of HTTP methods, and limit any behavior-changing headers to `POST`.
- **DO NOT** use `X-HTTP-Method-Override` to override `POST`, use a distinct resource to process the same request using `POST` without the header. Any HTTP intermediary between the client and the server may omit custom headers.

<!-- TODO -->

    ### Use Only the Specified Proprietary Headers

    The following proprietary headers have been specified by this guideline for usage so far. Remember that HTTP header field names are not case-sensitive.

    Header	        Description
    X-Flow-ID	    The flow id of the request, which is written into the logs and passed to called services. 
    X-UID	        Generic user id that owns the passed (OAuth2) access token. May save additional token validation round trips
    X-Sales-Channel
    X-Device-Type
    X-Device-OS
    X-App-Domain
    
    ### Propagate Proprietary Headers

    All proprietary headers are end-to-end headers, and as such must be propagated to the upstream servers. The header names and values must remain unchanged.

    HTTP/1.1 standard (RFC-7230) defines two types of headers: end-to-end and hop-by-hop headers. End-to-end headers must be transmitted to the ultimate recipient of a request or response. Hop-by-hop headers, on the contrary, are meaningful for a single connection only.

### HTTP Headers in Clients

- **DO** return `400 Bad Request` on servers, when you receive a representation with no `Content-Type`, avoid guessing the type of the representation.
- **DO NOT** check for the presence of the `Content-Length` header without first confirming the absence of `Transfer-Encoding: chunked`
- **DO** let your network library deal with uncompressing compressed representations (`Content-Encoding`)
- **DO** read and store the value of `Content-Language`

### Format and a Media Type

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

### JSON Representations

    - Enveloping response data
        - Use Envelopes
        - Don't use an envelope by default, and enveloping only in exceptional cases.

    Use JSON (when possible): JSON, or the JavaScript Object Notation format allows for the quick serialization and deserialization of objects. JSON provides a compact format for accessing data, minimalizing the data transfer required while also offering broader language support than XML. These advantages have made it the format of choice for many developers and the leading format for use within REST APIs. Again, you'll want to choose the format that is best for your clients, but in the event that you're encoding objects as XML, I would strongly suggest also offering JSON as an alternative as the serialization is fairly quick and painless. Keep in mind that one of the advantages to REST is that it is not limited to a single content type, and can return multiple formats if desired.

    Use JSON to Encode Structured Data: Use JSON-encoded body payload for transferring structured data. The JSON payload must follow RFC-7159 by having (if possible)a serialized object as the top-level structure, since it would allow for future extension. This also applies for collection resources where one naturally would assume an array.

    Prefer standard Media type name application/json: Previously, this guideline allowed the use of custom media types like application/x.zalando.article+json. This usage is not recommended anymore and should be avoided, except where it is necessary for cases of media type versioning. Instead, the standard media type name application/json (or application/problem+json for HTTP error details) should be used for JSON-formatted data.

    ## JSON Guidelines

    - Use Consistent Property Names
    - Property names must be snake_case (and never camelCase). No established industry standard exists. It's essential to establish a consistent look and feel such that JSON looks as if it came from the same hand.
    - Property names must be an ASCII subset: Property names are restricted to ASCII encoded strings. The first character must be a letter, an underscore or a dollar sign, and subsequent characters can be a letter, an underscore, a dollar sign, or a number.
    - Array names should be pluralized to indicate they contain multiple values prefer to pluralize array names. This implies that object names should in turn be singular.
    - Use Consistent Property Values
    - Boolean property values must not be null. A boolean is essentially a closed enumeration of two values, true and false. If the content has a meaningful null value, strongly prefer to replace the boolean with enumeration of named values or statuses 
    - Null values should have their fields removed: Swagger/OpenAPI, which is in common use, doesn't support null field values (it does allow omitting that field completely if it is not marked as required). However that doesn't prevent clients and servers sending and receiving those fields with null values. Also, in some cases null may be a meaningful value - for example, JSON Merge Patch RFC 7382) using null to indicate property deletion.
    - Empty array values should not be null. Empty array values can unambiguously be represented as the the empty list, [].
    - Enumerations should be represented as Strings. Strings are a reasonable target for values that are by design enumerations.
    - Use common field names and semantics. There exist a variety of field types that are required in multiple places. To achieve consistency across all API implementations, you must use common field names and semantics whenever applicable. There are some data fields that come up again and again in API data:
        - id: the identity of the object. If used, IDs must opaque strings and not numbers. IDs are unique within some documented context, are stable and don't change for a given object once assigned, and are never recycled cross entities.
        - xyz_id: an attribute within one object holding the identifier of another object must use a name that corresponds to the type of the referenced object or the relationship to the referenced object followed by _id (e.g. customer_id not customer_number; parent_node_id for the reference to a parent node from a child node, even if both have the type Node)
        - created: when the object was created. If used, this must be a date-time construct.
        - modified: when the object was updated. If used, this must be a date-time construct.
        - type: the kind of thing this object is. If used, the type of this field should be a string. Types allow runtime information on the entity provided that otherwise requires examining the Open API file.
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


### Use Portable Data Formats in Representations

- **DO** use decimal, float and double data types defined in the W3C XML Schema for formatting numbers including currency.
- **DO** use ISO 3166 codes for countries and dependent territories.
- **DO** use ISO 4217 alphabetic or numeric codes for denoting currency.
- **DO** use RFC 3339 for dates, times, and date-time values used in representations.
- **DO** use BCP 47 language tags for representing the language of text
- **DO** use time zone identifiers from the Olson Time Zone Database to convey time zones.
- **AVOID** using language-, region-, or country-specific formats or format identifiers, except when the text is meant for presentation to end users.

<!-- TODO -->

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


### _**XML Representations**_

*TBD*

*Suggested topics:*<br/>
*Atom resources, AtomPub Service, category documents, AtomPub for feed and entry resources, media resources*

### Binary Data in Representations

- **DO** use multipart media types such as `multipart/mixed`, `multipart/related`, or `multipart/alternative`.
- **CONSIDER** providing a link to fetch the binary data as a separate resource as an alternative. Creating and parsing multipart messages in some programming languages may be cumbersome and complex.
- **AVOID** encoding binary data within textual formats using Base64 encoding.

### Error Representations

    The Box API communicates errors through standard HTTP status codes with details supplied in JSON objects. Generally the following pattern applies:

    2xx - Box received, understood, and accepted a request.
    3xx - The client must take further action in order to complete the request.
    4xx - An error occurred in handling the request. The most common cause of this error is an invalid parameter.
    5xx- Box received and accepted the request, but an error occurred while handling it.

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

    ## Handling errors

    Many software developers, including myself, don't always like to think about exceptions and error handling but it is a very important piece of the puzzle for any software developer, and especially for API designers.

    Why is good error design especially important for API designers?

    From the perspective of the developer consuming your Web API, everything at the other side of that interface is a black box. Errors therefore become a key tool providing context and visibility into how to use an API.

    First, developers learn to write code through errors. The "test-first" concepts of the extreme programming model and the more recent "test driven development" models represent a body of best practices that have evolved because this is such an important and natural way for developers to work.

    Secondly, in addition to when they're developing their applications, developers depend on well-designed errors at the critical times when they are troubleshooting and resolving issues after the applications they've built using your API are in the hands of their users. 

    How to think about errors in a pragmatic way with REST?

    Let's take a look at how three top APIs approach it.

    Facebook

    HTTP Status Code: 200

    {"type" : "OauthException", "message":"(#803) Some of the aliases you requested do not exist: foo.bar"}

    Twilio

    HTTP Status Code: 401

    {"status" : "401", "message":"Authenticate","code": 20003, "more

    info": "http://www.twilio.com/docs/errors/20003"}

    SimpleGeo

    HTTP Status Code: 401

    {"code" : 401, "message": "Authentication Required"}

    Facebook

    No matter what happens on a Facebook request, you get back the 200-status code - everything is OK. Many error messages also push down into the HTTP response. Here they also throw an #803 error but with no information about what #803 is or how to react to it.

    Twilio

    Twilio does a great job aligning errors with HTTP status codes. Like Facebook, they provide a more granular error message but with a link that takes you to the documentation.

    Community commenting and discussion on the documentation helps to build a body of information and adds context for developers experiencing these errors.

    SimpleGeo

    SimpleGeo provides error codes but with no additional value in the payload.

    A couple of best practices

    Use HTTP status codes

    Use HTTP status codes and try to map them cleanly to relevant standard-based codes.

    There are over 70 HTTP status codes. However, most developers don't have all 70 memorized. So if you choose status codes that are not very common you will force application developers away from building their apps and over to Wikipedia to figure out what you're trying to tell them.

    Therefore, most API providers use a small subset. For example, the Google GData API uses only 10 status codes; Netflix uses 9, and Digg, only 8.

    Google GData

    200 201 304 400 401 403 404 409 410 500

    Netflix

    200 201 304 400 401 403 404 412 500

    Digg

    200 400 401 403 404 410 500 503

    How many status codes should you use for your API?

    When you boil it down, there are really only 3 outcomes in the interaction between an app and an API:

    * Everything worked - success
    * The application did something wrong – client error
    * The API did something wrong – server error

    Start by using the following 3 codes. If you need more, add them. But you shouldn't need to go beyond 8.

    * 200 - OK
    * 400 - Bad Request
    * 500 - Internal Server Error

    If you're not comfortable reducing all your error conditions to these 3, try picking among these additional 5:

    * 201 - Created
    * 304 - Not Modified
    * 404 – Not Found
    * 401 - Unauthorized
    * 403 - Forbidden

    (Check out this good Wikipedia entry for all HTTP Status codes.)

    It is important that the code that is returned can be consumed and acted upon by the application's business logic - for example, in an if-then-else, or a case statement.

    Make messages returned in the payload as verbose as possible.

    Code for code

    200 – OK

    401 – Unauthorized

    Message for people

    {"developerMessage" : "Verbose, plain language description of

    the problem for the app developer with hints about how to fix

    it.", "userMessage":"Pass this message on to the app user if

    needed.", "errorCode" : 12345, "more info":

    "http://dev.teachdogrest.com/errors/12345"}

    In summary, be verbose and use plain language descriptions. Add as many hints as your API team can think of about what's causing an error.

    We highly recommend you add a link in your description to more information, like Twilio does.

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
- **DO** return `401 Unauthorized` when the client is not authorized to access the resource, but may be able to gain access after authentication. If your server will not let the client access the resource even after authentication return `403 Forbidden` instead. When returning this error code, include a WWW-Authenticate header field with the authentication method to use.
- **DO** return `403 Forbidden` when your serer will not let the client gain access (authenticated or not).
- **DO** return `404 Not Found` when the resource is not found. If possible, return a reason in the message body.
- **DO** return `405 Not Allowed` when an HTTP method is not allowed. Return an `Allow` header with methods that are valid for the resource.
- **DO** return `406 Not Acceptable`. See [Content Negotiation](/content_negotiation).
- **DO** return `409 Conflict` when the request conflicts with the current state of the resource. Include a body explaining the reason.
- **DO** return `410 Gone` when the resource used to exist, but it does not anymore. You may not be able to return this unless you tracked deleted resources, then return `404 Not Found`.
- **DO** return `412 Precondition Failed`. See [Caching](/caching).
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
- **DO** treat `406 Not Acceptable`. See [Content Negotiation](/content_negotiation).
- **DO** treat `409 Conflict` by looking for the conflicts listed in the body of the representation of `PUT`
- **DO** treat `410 Gone` the same as `404 Not Found`.
- **DO** treat `412 Precondition Failed`. See [Caching](/caching).
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
- **DO** make sure to add checks (such as signatures) to detect/prevent tampering of state, when using application state in links.

<!-- TODO -->
    #### *Links in XML Representations*

    *[Atom](http://www.w3.org/2005/Atom)*

#### Links in JSON Representations

    ## What about attribute names?

    In the previous section, we talked about formats - supporting multiple formats and working with JSON as the default.

    This time, let's talk about what happens when a response comes back.

    You have an object with data attributes on it. How should you name the attributes?

    Here are API responses from a few leading APIs:

    Twitter

    "created_at": "Thu Nov 03 05:19;38 +0000 2011"

    Bing

    "DateTime": "2011-10-29T09:35:00Z"

    Foursquare

    "createdAt": 1320296464

    They each use a different code convention. Although the Twitter approach is familiar to me as a Ruby on Rails developer, we think that Foursquare has the best approach.

    How does the API response get back in the code? You parse the response (JSON parser); what comes back populates the Object. It looks like this

    var myObject = JSON.parse(response);

    If you chose the Twitter or Bing approach, your code looks like this. Its not JavaScript convention and looks weird - looks like the name of another object or class in the system, which is not correct.

    timing = myObject.created_at;

    timing - myObject.DateTime;

    Recommendations

    * Use JSON as default

    * Follow JavaScript conventions for naming attributes

    - Use medial capitalization (aka CamelCase)

    - Use uppercase or lowercase depending on type of object

    This results in code that looks like the following, allowing the JavaScript developer to write it in a way that makes sense for JavaScript.

    "createdAt": 1320296464

    timing = myObject.createdAt;
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
