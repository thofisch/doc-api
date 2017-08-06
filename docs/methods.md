# Methods

Before discussing the individual HTTP methods we will offer some general advise:

- **DO** use HTTP methods correctly.
- **DO** stay consistent with the HTTP verb definitions.
- **DO** use CRUD for basic operations, as most developers will be familiar with this way of working with an API. This means using `POST` for **C**reating, `GET` for **R**eading, `PUT` for **U**pdating, and `DELETE` for **D**eleting.

HTTP supports the following methods:

|Method   |Safe|Idempotent|
|---------|----|----------|
|`GET`    |Yes |Yes       |
|`HEAD`   |Yes |Yes       |
|`OPTIONS`|Yes |Yes       |
|`PUT`    |No  |Yes       |
|`DELETE` |No  |Yes       |
|`PATCH`  |No  |No        |
|`POST`   |No  |No        |

Safety and idempotency are guarantees a server must provide to clients. An operation can be:

- *Safe methods* (or read-only operations) are expected not to cause side-effects, however, it does not mean the server must return the same response every time.
- *Idempotent methods* must guarantee that every request has the same effect, however, this does not necessarily mean returning the same status code. This is highly important in case of failures.

### GET

- **DO** use `GET` to get a *safe* and *idempotent* representation of a resource.
- **DO** use `GET` as the preferred method of requesting resources using URL encoded query parameter. When these become too extensive use `POST` instead.
- **DO** use `GET` to read an individual resource or query a collection of resources.
- **DO** return `404 Not Found` if an individual resource or resource collection does not exist.
- **CONSIDER** returning `200 Ok` if the resource collection is empty, along with a representation of an empty collection.
- **DO NOT** add request body payload as these will be ignored, use `POST` instead.
- **DO NOT** use `GET` for unsafe and nonidempotent operations, use `POST` instead.

### HEAD

HEAD requests are used to retrieve header information of resources, and has the exact same semantics as `GET`, but only returns headers. 

- **CONSIDER** using `HEAD` to check whether a resource exists or get its metadata.

### OPTIONS

`OPTIONS` is rarely implemented. Although `OPTIONS` could be used at runtime to discover methods supported by the resource, doing so is expensive. The method is not cacheable.

- **DO** return a comma separated list of methods in the `Allow` header. When a resource supports `PATCH` add an `Accept-Patch` header with the supported media types.
- **DO** use `OPTIONS` to get a list of available HTTP methods supported by a given resource.
- **DO** use `OPTIONS` to ping the server or find the supported HTTP version `OPTIONS * HTTP/1.1`
- **CONSIDER** adding a `Link` header containing a link to a human-readble document that describes the resource. This can be used to develop a browser plug-in to automatically show the documentation when you type the resource URI in the browser.
- **AVOID** relying on `OPTIONS` at runtime for discovery, instead use documentation and links to discover URIs and make requests.

### PUT

- **DO** use `PUT` to update an entire single resource. The operation implies that the entire resource located at the URI will be replaced with the new representation in the request.
- **DO** return `200 Ok` or `204 No Content` if the resource was updated.
- **DO** use a comibation of `ETag` and `If-Match` header for concurrency.
- **DO** return `404 Not Found` is `PUT` does not support creation.
- **CONSIDER** before using `PUT` on a collection resources as it implies replacing the entire collection.
- **CONSIDER** using `PATCH` if making partial updates to entire resources become increasingly cumbersome.
- **DO NOT** use `PUT` to create new resources unless the clients can decide URIs of resources (e.g., WebDAV), instead use `POST`.

### DELETE

- **DO** use `DELETE` to delete a resource. Always return `200 OK`, however, it is impractical to keep track of all deleted resource, so a `404 Not Found` may be a viable alternative. Security policies may also require the server to return `404 Not Found` for any resource that does not currently exist.
- **CONSIDER** before using `DELETE` on a collection resources as it implies deleting the entire collection.

### PATCH

It is important to understand the difference between `PUT` and `PATCH`.

`PUT` is designed to update/replace the entire resource. This means that omitted fields will be removed, which is rarely the desired effect.

`PATCH` is designed to support partial updates. This means the request should supply a *set of changes* (or instructions) for updating a resource and these should be applied atomically, leaving any fields not passed along intact.

> Be aware, even though `PATCH` has gain a lot of use, `PATCH` is only a proposed standard, and details around the semantics are not widely understood. It's not an alternative to `POST` or `PUT` where you supply a flat list of values to change. Please see [RFC-5789](https://tools.ietf.org/html/rfc5789) for more information.

- **DO** use `PATCH` for partial updates of a single resources, i.e. where only a specific subset of fields should be replaced.
- **DO** document the semantic of the `PATCH` changeset, as it is not defined in the HTTP standard.
- **DO** return `200 Ok` or `204 No Content` for successful `PATCH` requests.
- **DO** use a comibation of `ETag` and `If-Match` (and/or `If-Unmodified-Since`) header for concurrency. Return `412 Precondition Failed` if the supplied preconditions do not match.
- **DO** include the `Content-Location` header along with the entire representation of the resource. If not, the client must issue an unconditional `GET` request to fetch the updated representation of the resource, along with fresh `ETag` and/or `If-Unmodified-Since` if applicable.
- **DO** include the latest `Last-Modified` and/or `ETag` headers to support conditional requests.
- **DO** return `415 Unsupported Media Type` when the client sends a patch document format that the server does not support. Include the `Accept-Patch` header with the supported media types.
- **DO** return `422 Unprocessable Entity` when the server cannot honor the request because it might result in a bad state for the resource.
- **CONSIDER** using suitable media types to describe the changeset.
- **CONSIDER** using the lightweight JSON merge patch (RFC 7386) to describe changesets in JSON format.
- **CONSIDER** using the JSON Patch (RFC 6902) to describe changesets in JSON format.
- **CONSIDER** before using `PATCH` on a collection resources as it implies patching the entire collection.
- **CONSIDER** overloading `POST`, not `PUT`, when `PATCH` is not an option.
- **CONSIDER** using `PUT` instead of `PATCH`, if possible, either to update the entire resource, or by designing a new resource to encapsulate the parts of the original resource that can be updated. *Such resources may seem inconsistent (or even polluting), but anything that is appropriate for retrival and updates is a candidate as a resource*.
- **CONSIDER** advertising the support for `PATCH` via the `Allow` header of the `OPTIONS`response, also including an `Accept-Patch` header with the supported media types for the `PATCH` method.
- **CONSIDER** designing a specific format for each resource, to ensure that `PATCH` request only include valid combinations of changes.
- **DO NOT** repeat `PATCH` requests unless explicitly stated in the documentation.

### POST

`POST` requests are most often used to create resources, by using a collection resource as a factory. However, `POST` may also be used for other operations that fall outside the scope of the other methods. 

- **DO** use `POST` to create resources.
- **DO** use `POST` to modify one or more resources.
- **DO** use `POST` to for queries with large inputs.
- **DO** use `POST` to perform any unsafe and nonidempotent operation, when no other HTTP method seems appropriate, and only as a last resort.
- **AVOID** passing data in query string along `POST` request, use the body instead.
- **AVOID** using `POST`for tunneling, like SOAP.
- **DO NOT** use nonstandard custom HTTP methods. Instead, design a controller resource that can abstract such operations, and `POST`.

### Creating Resources

While it is valid to use either `PUT` or `POST` to create new resources, the general consensus is that creating a new resource without knowing the final URI is a `POST` operation (each call will yield a new resource). If the URI (or part of it) is known, use `PUT`, because successive calls will not create a new resource, as `PUT` is idempotent.

- **DO** return `201 Created` and a `Location` header containing the URI of the newly created resource.
- **DO** include a `Content-Location` header containing the URI of the newly created resource, if the response body includes a complete representation of the newly created resource.
- **CONSIDER** including the `Last-Modified` and `ETag` headers of the newly created resource for optimistic concurrency.

### Large and Stored Queries

Sometimes it may be necessary to support queries with large inputs, and the query string may no longer be an option. For those cases:

- **DO** use `POST` to support large queries, as a necessary trade-off to address a practical limitation, even though this is a misuse of the uniform interface, and a consequence is a loss of cacheability
- **CONSIDER** the fact tha pagination may also cause extra latency, since `POST`s are not cached.
- **CONSIDER** using stored queries to improve cacheability and reuse across clients:
  - **DO** create a new resource whose state contains the query criteria. Return `201 Created` and a `Location` header referring to a resource created.
  - **DO** implement a `GET` request for the new resource such that it returns query results.
  - **DO** find the resource that matches the request, and redirect the client to the URI of that resource, if the same or another client repeats the same query request using `POST`.
  - **DO** support pagination via `GET` instead of `POST`.
  - **CONSIDER** the number of different queries and evaluate cache hit ratio, and whether named queries are a better option.

### Asynchronous Tasks

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

### **_Batch Operations_**

**_TBD_**
