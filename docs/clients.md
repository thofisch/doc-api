## Resource Identifiers

### Using URIs in Clients

- **DO** update local copies of old URIs when receiving `301 Moved Permanently`.
- **DO** verify that the `Location` URI maps to a trusted server.
- **DO NOT** disable support of redirects in client applications. Instead, consider a sensible limit on the number of redirects a client can follow. Disabling redirects altogether will break the client when the server change URIs.

## Methods

### Using Methods in Clients

- **DO** treat `GET`, `OPTIONS`, and `HEAD` as safe operations, and send as required. Include `If-Unmodified-Since` and/or `If-Match` conditional headers, if applicable.
- **DO** resubmit `GET`, `PUT`, and `DELETE` requests, in case of failures, to confirm.
- **DO** implement retry logic, whenever you encounter a failure for an idempotent method.
- **DO** submit a `POST` request with a representation of the resource to be created to the factory resource.
- **DO NOT** repeat `POST` requests unless the documentation states that is idempotent.
- **DO NOT** treat various HTTP-level errors as failures (network or software) or like exceptions.

## Representations

### HTTP Headers in Clients

- **DO** return `400 Bad Request` on servers, when you receive a representation with no `Content-Type`, avoid guessing the type of the representation.
- **DO** let your network library deal with uncompressing compressed representations (`Content-Encoding`)
- **DO** read and store the value of `Content-Language`
- **DO NOT** use `Content-Encoding` in HTTP requests, unless you know out of band that the target server supports a particular encoding method.
- **DO NOT** check for the presence of the `Content-Length` header without first confirming the absence of `Transfer-Encoding: chunked`

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

### HATEOS

#### Using Links in Clients

- **DO** extract URIs and URI templates from links based on known link relation types. These links along with other resource data constitute the current state of the application.
- **DO** store the URIs and the relation type along with other representation data, if the application is long running.
- **DO** make flow decisions based on the presence or absence of links.
- **DO** store the knowledge of whether a representation contains a given link.
- **DO** check the documentation of the link relation to learn any associated business rules regarding authentication, permanence of the URI, methods, and media types supported, etc.


## Extensibility

### How to Implement Clients to Support Extensibility

If the client is capable of storing the complete representation locally, store everything.

Do not assume that the representation is of a fixed media type, character encoding, content language, or content encoding.

