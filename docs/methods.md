# Methods

Before discussing the individual HTTP methods we will offer some general advise:

- **DO** stay consistent with the HTTP verb definitions.
- **DO** use CRUD for most basic operations, as most developers will be familiar with this standardized way of working with an API. This means using `POST` for **C**reating, `GET` for **R**eading, `PUT` for **U**pdating, and `DELETE` for **D**eleting.

HTTP supports the following methods (not all discussed in detail here):

|Method   |Safe|Idempotent|
|---------|----|----------|
|`GET`    |Yes |Yes       |
|`HEAD`   |Yes |Yes       |
|`OPTIONS`|Yes |Yes       |
|`PUT`    |No  |Yes       |
|`DELETE` |No  |Yes       |
|`POST`   |No  |No        |
|`PATCH`  |No  |No        |

Safety and idempotency are guarantees a server must provide to clients:

    ### MUST: Fulfill Safeness and Idempotency Properties

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

- *Safe methods* (or read-only operations) are expected not to cause side-effects, however, it does not mean the server must return the same response every time.
- *Idempotent methods* must guarantee that every request has the same effect, and is highly important in case of failures.

    ### MUST: Use HTTP Methods Correctly

    Be compliant with the standardized HTTP method semantics summarized as follows:

### `GET`

- **DO** use `GET` to get a *safe* and *idempotent* representation of a resource.
- **DO NOT** use `GET` for unsafe and nonidempotent operations, use `POST` instead.

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

### `PUT`

- **DO** use `PUT` to update a resource.
- **DO NOT** use `PUT` to create new resources unless the clients can decide URIs of resources (e.g., WebDAV), instead use `POST`.

    PUT requests are used to create or update entire resources - single or collection resources. The semantic is best described as »please put the enclosed representation at the resource mentioned by the URL, replacing any existing resource.«.

    PUT requests are usually applied to single resources, and not to collection resources, as this would imply replacing the entire collection
    PUT requests are usually robust against non-existence of resources by implicitly creating before updating
    on successful PUT requests, the server will replace the entire resource addressed by the URL with the representation passed in the payload (subsequent reads will deliver the same payload)
    successful PUT requests will usually generate 200 or 204 (if the resource was updated - with or without actual content returned), and 201 (if the resource was created)
    Note: Resource IDs with respect to PUT requests are maintained by the client and passed as a URL path segment. Putting the same resource twice is required to be idempotent and to result in the same single resource instance. If PUT is applied for creating a resource, only URIs should be allowed as resource IDs. If URIs are not available POST should be preferred.

    To prevent unnoticed concurrent updates when using PUT, the combination of ETag and If-(None-)Match headers should be considered to signal the server stricter demands to expose conflicts and prevent lost updates.

### `DELETE`

- **DO** use `DELETE` to delete a resource. Always return `200 OK`, however, it is impractical to keep track of all deleted resource, so a `404 Not Found` may be a viable alternative. Security policies may also require the server to return `404 Not Found` for any resource that does not currently exist.

    DELETE request are used to delete resources. The semantic is best described as »please delete the resource identified by the URL«.

    DELETE requests are usually applied to single resources, not on collection resources, as this would imply deleting the entire collection
    successful DELETE request will usually generate 200 (if the deleted resource is returned) or 204 (if no content is returned)
    failed DELETE request will usually generate 404 (if the resource cannot be found) or 410 (if the resource was already deleted before)
    HEAD

### `POST`

- **DO** use `POST` to create resources.
- **DO** use `POST` to modify one or more resources.
- **DO** use `POST` to for queries with large inputs.
- **DO** use `POST` to perform any unsafe and nonidempotent operation, when no other HTTP method seems appropriate, and only as a last resort (avoid tunneling like SOAP).
- **AVOID** passing data in query string along `POST` request, use the body instead.
- **DO NOT** use nonstandard custom HTTP methods. Instead, design a controller resource that can abstract such operations, and `POST`.

    POST requests are idiomatically used to create single resources on a collection resource endpoint, but other semantics on single resources endpoint are equally possible. The semantic for collection endpoints is best described as »please add the enclosed representation to the collection resource identified by the URL«. The semantic for single resource endpoints is best described as »please execute the given well specified request on the collection resource identified by the URL«.

    POST request should only be applied to collection resources, and normally not on single resource, as this has an undefined semantic
    on successful POST requests, the server will create one or multiple new resources and provide their URI/URLs in the response
    successful POST requests will usually generate 200 (if resources have been updated), 201 (if resources have been created), and 202 (if the request was accepted but has not been finished yet)
    More generally: POST should be used for scenarios that cannot be covered by the other methods sufficiently. For instance, GET with complex (e.g. SQL like structured) query that needs to be passed as request body payload because of the URL-length constraint. In such cases, make sure to document the fact that POST is used as a workaround.

    Note: Resource IDs with respect to POST requests are created and maintained by server and returned with response payload. Posting the same resource twice is by itself not required to be idempotent and may result in multiple resource instances. Anyhow, if external URIs are present that can be used to identify duplicate requests, it is best practice to implement POST in an idempotent way.

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

### `PATCH`

    It's also important to understand the difference between PUT and PATCH, as PUT is used to perform a complete override of the record (if fields are not included, they are removed) where-as PATCH is used to update a record based on the information provided (or patch it with what you provide), leaving any fields not passed along intact.
    Keep in mind there are several different HTTP Action Verbs available, and it's easy to want to incorporate these new verbs and make your API new and different.

    <!-- TODO -->

    Doing PATCH “properly”
    According to the HTTP specification, PUT must take the full resource representation in the request. This can be a bit cumbersome, so PATCH is increasingly being adopted for partial updates.

    Given that PATCH is only a proposed standard there are details around the semantics of the method that are not widely understood. It’s not a simple replacement for POST and PUT where you supply a flat list of values to change. The request should supply a set of instructions for updating an entity and these should be applied atomically.

    A “set of instructions” is very different from a “set of values” and the specification clearly states that a request should be a different content type to the resource being modified. The detail of the representation is down to you, but RFC6902 describes a JSON format for PATCH where each object represents a single operation, e.g. “add”, “copy”, “delete” and so on. Each type of operation is described in eye-watering detail in the specification.

    The point here is that there is a lot more to PATCH than meets the eye. Unless you adopt a complex semantic format for describing change then you are likely to arouse the ire of the “you’re doing it wrong” brigade.

    <!-- TODO -->

    - 11.8. How to Refine Resources for Partial Updates
    - 11.9. How to use the `PATCH` Method

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

### Using Methods in Clients

- **DO** treat `GET`, `OPTIONS`, and `HEAD` as safe operations, and send as required. Include `If-Unmodified-Since` and/or `If-Match` conditional headers, if applicable.
- **DO** resubmit `GET`, `PUT`, and `DELETE` requests, in case of failures, to confirm.
- **DO** implement retry logic, whenever you encounter a failure for an idempotent method.
- **DO** submit a `POST` request with a representation of the resource to be created to the factory resource.
- **DO NOT** repeat `POST` requests unless the documentation states that is idempotent.
- **DO NOT** treat various HTTP-level errors as failures (network or software) or like exceptions.

<!-- TODO -->

    HEAD requests are used retrieve to header information of single resources and resource collections.

    HEAD has exactly the same semantics as GET, but returns headers only, no body.
    OPTIONS

    OPTIONS are used to inspect the available operations (HTTP methods) of a given endpoint.

    OPTIONS requests usually either return a comma separated list of methods (provided by an Allow:-Header) or as a structured list of link templates
    Note: OPTIONS is rarely implemented, though it could be used to self-describe the full functionality of a resource.
