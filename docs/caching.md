## Caching and Conditional Requests

Caching is one of the most useful features built on top of HTTP's uniform interface. You can take advantage of caching to reduce end user perceived latency, to increase reliasbility, to reduce bandwidth usage and cost, and to reduce server load. They can be in server network, content delivery networks (CDNs), or in the client network (forward proxies).

It is common to use the word *cache* to refer to either an object cache (memcached) or HTTP caches. Both of these caches improve performacne and have key roles to play in the overall web service deployment architecture. But there is an important difference between the two. HTTP caches do not require clients and servers to call any special programming API to manage data in the cache, as long as you are using HTTP as defined.

### *origin server*

They are slightly different - the ETag does not have any information that the client can use to determine whether or not to make a request for that file again in the future. If ETag is all it has, it will always have to make a request. However, when the server reads the ETag from the client request, the server can then determine whether to send the file (HTTP 200) or tell the client to just use their local copy (HTTP 304). An ETag is basically just a checksum for a file that semantically changes when the content of the file changes.

The Expires header is used by the client (and proxies/caches) to determine whether or not it even needs to make a request to the server at all. The closer you are to the Expires date, the more likely it is the client (or proxy) will make an HTTP request for that file from the server.

So really what you want to do is use BOTH headers - set the Expires header to a reasonable value based on how often the content changes. Then configure ETags to be sent so that when clients DO send a request to the server, it can more easily determine whether or not to send the file back.

One last note about ETag - if you are using a load-balanced server setup with multiple machines running Apache you will probably want to turn off ETag generation. This is because inodes are used as part of the ETag hash algorithm which will be different between the servers. You can configure Apache to not use inodes as part of the calculation but then you'd want to make sure the timestamps on the files are exactly the same, to ensure the same ETag gets generated for all servers.

- How to set Expiration Caching Headers

Expiration caching is based on the `Cache-Control` and `Expires` headers. These headers instruct clients and caches to keep a copy of the representation returned by the server for a specific length of time.

Based on the frequency of updates, determine a time period (the *freshness lifetime*) during which caches can serve a representation. After this time, caches will consider cached representations stale.

When serving a representation, include a `Cache-Control` header with a `max-age` value (in seconds) equal to the freshness lifetime. The `Cache-Control` header is a HTTP 1.1 header. To support legacy HTTP 1.0 caches, include a `Expires` header with the expiration date-time. The expiration date-time is a time at which the server generated the representation plus the freshness lifetime. Also include a `Date` header with a date-time at which the server returned the response. Including this header helps clients compute the freshness lifetime as the difference between the values of the `Expires` and `Date` headers.

If the caches must not serve cached copies, add `Cache-Control: no-cache` to the HTTP headers. Also add a `Pragma: no-cache` to support HTTP 1.0 caches.

List of `Cache-Control` directives:

- *public* (default): when the request is authenticated, but you still want to allow shared caches to serve cached responses.
- *private*: when the response is preivate to the client or user. Any client-side caches (browsers/forward proxies) can cache the representation, but sharede caches along the network must not cache it.
- *no-cache* and *no-store*: prevents any cache from storing or serving a cached response.
- *max-age*: the freshness lifetime in seconds.
- *s-maxage*: life *max-age*, but is meant only for shared caches. Just use *max-age*.
- *must-revalidate*: caches must check the origin server before serving stale representations.
- *proxy-revalidate*: same as *must-revalidate* but only for shared caches.

The `Age` header is added by the cache. It indicates how long ago the cache retrieved the representation from the origin server.

The key to optimal expiration caching is calculating a resonable freshness lifetime value for the resource representation. If you gave historical information such as update logs for the representations, use them to establish a base lifetime. 

When to set Expiration Caching Headers

- Set expiration caching headers for responses of `GET` and `HEAD` request for all successful response codes.
- Consider adding caching headers to:
    - `300 Multiple Choices`: The representation with this status may not change often.
    - `301 Moved Permanently`
    - `404 Not Found`
    - `405 Method Not Allowed`
    - `410 Gone`

- When and how to use Expiration Headers in Clients

Avoid implementing support for expiration caching within clients, instead deploy a forward proxy in the client network, and avoid implementing you own caching layer in the client code.

### Conditional Request

Conditional request address two programs. For `GET` request conditional request help clients and caches validate that a cached representation can still be considered fresh. For unsafe request such as `PUT`, `POST` and `DELETE` conditional requests provide concurrency control.

Not supporting conditional `GET` request reduces performance.

Not makeing unsafe requests conditional, when facing concurrency, ay affect the integrity of the application. In absence of adequate concurrency control checks, the server is susceptible to "lost updates" and "stale deletes".

Perssimistic concurrency control, the client gets a lock, obtain the current state of a resource, makes modifications, and then releases the lock. During this process the server present other clients from aquiring a lock to the same resource.

Optimistic concurrency control, the client gets a token, and attempts a write operation with the token. The operation success if the token is still valid or fails otherwise.

HTTP, being stateless, is designed for optimistic concurrency control.

Conditional `GET` request can extend the life of stale representations.

- How to Generate `Last-Modified` and `ETag` Headers

Use `Last-Modified` and `ETag` response headers to drive conditional requests. Clients use the following:

- `If-Modified-Since` and `If-None-Match` for validating cached representations
- `If-Unmodified-Since` and `If-Match` as preconditions for concurrency control

a timestamp for the modifed date-time and/or a sequence number of keep track of a version.

use an MD5 hash of the representation body, or of some field of the data that changes every time the resource ip updated

make sure to use a different `ETag` value of each representation of the resource (this include different media types, etc.).

`Last-Modified` has a 1 second resolution is considered a "weak" validator.
`ETag` is a strong validator since its value can change every time the entity is modified.
Entity tag is an object hash code

You do not need to use both `Last-Modified` and `ETag` headers to support conditional requests. Use either or both consistently to support conditional requests.

- How to Implement Conditional `GET` Requests in Servers

Send `If-Modified-Since` and `If-None-Match` headers based `Last-Modified` and `ETag` headers from a previous request.

Conditional requests do not cut down on the number of requests from the client, but they can reduce the number of times a server needs to send a fresh representation.

Check `If-None-Match` against `ETag`, and check `If-Modified-Since` against `Last-Modified`, if either checks are false or missing return the latest copy of the representation including new `ETag` and/or `Last-Modified`, else return `304 Not Modified`. To support validation to extend the life of a cached copy the server must return expiration headers as well.

The values of `ETag`, `If-Match`, and `If-None-Match` are quoted strings.

- How to Submit Conditional `GET` and `HEAD` Requests from Clients

Store `ETag` and/or `Last-Modified` along with the representation data.
and reply them on future requests.

Include `If-Modified-Since` with the value from `Last-Modified`
Include `If-None-Match` with the value from `ETag`

Do not send conditional requests unless you have a copy of the representaton stored locally on the client.

- How to Implement Conditional `PUT` Requests in Servers

If the resource exists:

- If the client does not include `If-Unmodified-Since` and/or `If-Match` header return `403 Forbidden`. Explain why in the body.
- If the suppiled `If-Unmodified-Since` or `If-Match` do not match the server values return `412 Precondition Failed`. Explain why in the body.
- If the conditions match return `200 OK` or `204 No Content` and update the resource. Optionally include `Last-Modified` and/or `ETag` headers provided the response also include a `Content-Location` header with the URI of the updated resource.

- How to Implement Conditional `DELETE` Requests in Servers

- If the client does not include `If-Unmodified-Since` and/or `If-Match` header return `403 Forbidden`. Explain why in the body.
- If the suppiled `If-Unmodified-Since` or `If-Match` do not match the server values return `412 Precondition Failed`. Explain why in the body.
- If the conditions match return `200 OK` or `204 No Content` and delete the resource.

- How to Make Unconditional `GET` Requests from Clients

HTTP 1.1 allows clients to modify expiration caching and ash for fresh representations. To get a fresh represention after you receive `412 Precondition Failed` or even after a successful `PUT` or `PATCH` to get the latest representation.

Include `Cache-Control: no-cache` and `Pragma: no-cache` in the `GET` request.

Do not make unconditional `GET` request unless necessary as the downgrade performacne and increase latency.

- How to Submit Conditional `PUT` and `DELETE` Requests from Clients

Include `If-Unmodified-Since` with the stored value of `Last-Modified`
Include `If-Match` with the stored value of `ETag`
If the server return `412 Precondition Failed` submit an unconditional request to ontain a fresh `Last-Modified` and `ETag`, verify the decision to update or delete the resource is still valid per the fresh representation, and then repeat the `PUT` or `DELETE` with the new header values.

Do not use `HEAD` to obtain fresh `Last-Modified` and `ETag` you will also new the current satet of the resource to determine if you can go ahead with the operation.

- How to Make `POST` Requests Conditional
- How to Generate One-Time URIs

Common methods of ETag generation include using a collision-resistant hash function of the resource's content, a hash of the last modification timestamp, or even just a revision number.

### MAY: Consider using ETag together with If-(None-)Match header

When creating or updating resources it may be necessary to expose conflicts and to prevent the lost update problem. This can be best accomplished by using the ETag header together with the If-Match and If-None-Match. The contents of an ETag: <entity-tag> header is either (a) a hash of the response body, (b) a hash of the last modified field of the entity, or (c) a version number or identifier of the entity version.

To expose conflicts between concurrent update operations via PUT, POST, or PATCH, the If-Match: <entity-tag> header can be used to force the server to check whether the version of the updated entity is conforming to the requested <entity-tag>. If no matching entity is found, the operation is supposed a to respond with status code 412 - precondition failed.

Beside other use cases, the If-None-Match: header with parameter * can be used in a similar way to expose conflicts in resource creation. If any matching entity is found, the operation is supposed a to respond with status code 412 - precondition failed.

The ETag, If-Match, and If-None-Match headers can be defined as follows in the API definition:

```
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
```
