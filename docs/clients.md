## Resource Identifiers

When using URIs in clients: 

- **DO** update local copies of old URIs when receiving `301 Moved Permanently`.
- **DO** verify that the `Location` URI maps to a trusted server.
- **DO NOT** disable support of redirects in client applications. Instead, consider a sensible limit on the number of redirects a client can follow. Disabling redirects altogether will break the client when the server change URIs.

## Methods

When using methods in clients:

- **DO** treat `GET`, `OPTIONS`, and `HEAD` as safe operations, and send as required. Include `If-Unmodified-Since` and/or `If-Match` conditional headers, if applicable.
- **DO** resubmit `GET`, `PUT`, and `DELETE` requests, in case of failures, to confirm.
- **DO** implement retry logic, whenever you encounter a failure for an idempotent method.
- **DO** submit a `POST` request with a representation of the resource to be created to the factory resource.
- **DO NOT** repeat `POST` requests unless the documentation states that is idempotent.
- **DO NOT** treat various HTTP-level errors as failures (network or software) or like exceptions.

## Representations

When using HTTP Headers in clients:

- **DO** return `400 Bad Request` on servers, when you receive a representation with no `Content-Type`. Avoid guessing the type of the representation. {>>Does it belong here?<<}
- **DO** let your network library deal with uncompressing compressed representations (`Content-Encoding`)
- **DO** read and store the value of `Content-Language`.
- **DO NOT** use `Content-Encoding` in HTTP requests, unless you know out of band that the target server supports a particular encoding method.
- **DO NOT** check for the presence of the `Content-Length` header without first confirming the absence of `Transfer-Encoding: chunked`

#### Errors

!!! warning "Even though they might not be documented - they may very much occur in production!"
    Clients should be prepared for unexpected response codes. In case of doubt handle them like they would handle the corresponding x00 code.
    
    *Adding new response codes (specially error responses) should be considered a compatible API evolution.*

When treating errors in clients:

- **DO** treat `400 Bad Request` by looking into the body of the error representation for hints for the root cause of the problem.
- **DO** retry the request on `401 Unauthorized` responses with the `Authorization` header containing the credentials. If the client is user-facing, prompt the user to supply credentials. In other cases, obtain the necessary security credentials.
- **DO** clean up client stored data on `404 Not Found`.
- **DO** look for the `Allow` header for valid methods on `405 Not Allowed`.
- **DO** treat `406 Not Acceptable`. See [Content Negotiation](/content_negotiation).
- **DO** treat `409 Conflict` by looking for the conflicts listed in the body of the representation.
- **DO** treat `410 Gone` the same as `404 Not Found`.
- **DO** treat `412 Precondition Failed`. See [Caching](/caching).
- **DO** look for hints on valid size in the body of the error on `413 Request Entity Too Large`.
- **DO** see the body of the representation to learn the supported media types for the request on `415 Unsupported Media Type`.
- **DO** log the error, and then notify the server developers of `500 Internal Server Error`.
- **DO** check the response of `503 Service Unavailable` for a `Retry-After` header, avoid retrying until that period of time (back-off logic).
- **DO NOT** repeat the request on `403 Forbidden`.
- **DO NOT** treat HTTP errors as I/O or network exceptions. Treat them as first-class application objects.

## Hypermedia

When using links in clients:

- **DO** extract URIs and URI templates from links based on known link relation types. These links along with other resource data constitute the current state of the application.
- **DO** store the URIs and the relation type along with other representation data, if the application is long running.
- **DO** make flow decisions based on the presence or absence of links.
- **DO** store the knowledge of whether a representation contains a given link.
- **DO** check the documentation of the link relation to learn any associated business rules regarding authentication, permanence of the URI, methods, and media types supported, etc.

## Content Negotiation

- **DO** add an `Accept` header with a comma-separated list of media type preferences. If the client prefers one media type over the other, add a `q` parameter with each media type.
- **DO** add `*;q=0.0` in the `Accept` header to indicate to the server it cannot process anything other than the media types listed in the `Accept` header, if the client can process only certain formats.
- **DO** add an `Accept-Language` header for the preferred language of the representation.
- **DO** add an `Accept-Charset` header with the preferred character set, if the client can process characters of a specific character set only, if not, avoid adding this header.
- **DO** add an `Accept-Encoding` header listing the supported encodings, if the client is able to decompress representations compressed encoding such as `gzip`, `compress`, or `deflate`, if not, skip this header.

- **DO NOT** assume that servers support content negotiation, and be prepared to receive a representation that does not meet the `Accept-*` headers.

## Extensibility

When implementing clients to support extensibility:

* **DO** store everything, if the client is capable of storing the complete representation locally.
* **DO NOT** assume that the representation is of a fixed media type, character encoding, content language, or content encoding.

{++

## Complement with an SDK

It's a common question for API providers - do you need to complement your API with code libraries and software development kits (SDKs)?
If your API follows good design practices, is self consistent, standards-based, and well documented, developers may be able to get rolling without a client SDK. Well-documented code samples are also a critical resource.
On the other hand, what about the scenario in which building a UI requires a lot of domain knowledge? This can be a challenging problem for developers even when building UI and apps on top of APIs with pretty simple domains – think about the Twitter API with it's primary object of 140 characters of text.
You shouldn't change your API to try to overcome the domain knowledge hurdle. Instead, you can complement your API with code libraries and a software development kit (SDK).
In this way, you don't overburden your API design. Often, a lot of what's needed is on the client side and you can push that burden to an SDK.
The SDK can provide the platform-specific code, which developers use in their apps to invoke API operations - meaning you keep your API clean.
Other reasons you might consider complementing your API with an SDK include the following:
Speed adoption on a specific platform. (For example Objective C SDK for iPhone.)
Many experienced developers are just starting off with objective C+ so an SDK might be helpful.
Simplify integration effort required to work with your API - If key use cases are complex or need to be complemented by standard on-client processing.
An SDK can help reduce bad or inefficient code that might slow down service for everyone.
As a developer resource - good SDKs are a forcing function to create good source code examples and documentation. 
To market your API to a specific community - you upload the SDK to a samples or plugin page on a platform's existing developer community.
Last but not least, keep in mind that SDKs or code wrappers/libraries can be extremely helpful.
What SDKs/ Code Wrappers offer is a quick, plug and play way for developers to incorporate your API, while also (hopefully) handling error checks/ responses.

### Building an SDK Doesn't Fix Everything

However, if you are building a full out SDK instead of a language wrapper that utilizes the hypermedia to handle responses, remember that you are adding a whole new layer of complexity to your API ecosystem – that you will have to maintain.
The downside is the more complex your SDK becomes, the more tightly coupled it usually is to your API, making any updates to your API a manual and complex process.
This means that any new features you roll out will receive rather slow adoption, and you may find yourself providing support to your developers on why they can't do something with your SDK.
When building your SDK you should try to keep it as decoupled from your API as possible, relying on dynamic responses and calls while also following the best coding practices for that language (be sure to watch Keith Casey's SPOIL talk or read about it here).

Another option is to utilize a SDK building service such as APIMatic.io or REST United, which automatically generates SDKs for your API based on your RAML, Swagger, or API Blueprint spec.
This allows you to offer SDKs, automatically have them update when adding new features (although clients will still need to download the updated version), and offer them without adding any additional workload on your end.

But again, regardless of whether or not you provide an SDK/ Code Library, you will still want to have multiple code examples in your documentation to help developers who want to utilize your API to its fullest capacity, without relying on additional third party libraries to do so.

Remember that having an SDK doesn't replace documentation, if anything – it creates the need for more.

++}
