## Unique Resource Identifiers (URIs)

An important aspect of API design is to think about how to design unique resource identifiers, and as such, URIs should be treated as *opaque resource identifiers*[^1].

The opacity of URIs helps reduce coupling between servers and clients. This has nothing to do with readability or hackability, both of which may be extremely important aspects for developers consuming the API, where:

- *readable URIs* help developers understand something about the resource.
- *hackable URIs* are manipulated by altering/removing portions of the path or query, and can help developers locate other resources.

!!! important
    Clients should not be concerned with the design of URIs, nor should clients try to pick apart URIs in order to gather information from them. Instead URIs should be discovered through links (and the submission of forms).
    
    For instance, clients must not use the fact that a URI ends with `.xml` to infer that it resolves to an XML representation, instead it must rely on the `Content-Type` header of the response. 

## Designing URIs

When done successfully the result, of a thoughtful URI design, can be the most important *design affordance*[^2] of your API.

So when designing URIs:

- **DO** design URIs to last a long time - [Cool URIs don't change](<http://www.w3.org/Provider/Style/URI>).
- **DO** design URIs based on stable concepts, identifiers, and information. URIs cannot be permanent if the concepts or identifiers used cannot be permanent for business, technical, or security reasons. 
- **DO** keep your base URIs simple and intuitive.
- **DO** use lowercase for URIs.
- **DO** use domains and subdomains to logically group or partition resources for localization, distribution, or to enforce various monitoring or security policies.
- **DO** use forward-slash (`/`) in the path segment to indicate a hierarchical relationship between resources.
- **DO** use the hyphen (`-`) or (`_`) characters to improve the readability of long path segments. *Pick one or the other for consistency*.
- **DO** use ampersand (`&`) to separate query parameters.
- **DO** use the URI only to determine which resource should process a request.
- **CONSIDER** providing URIs at runtime using links in the body of representations or headers, whenever appropriate.
- **CONSIDER** using `/api` as the first path segment, when the API also supports non-public APIs, e.g., for specific operational support functions. Otherwise, consider forgoing the `/api` prefix.
- **CONSIDER** using comma (`,`) and semi-colon (`;`) to indicate nonhierarchical elements in the path segment. The semi-colon (`;`) convention is used to identify matrix parameters. *Not all libraries recognize these as separators and may require custom coding to extract these parameters*.
- **CONSIDER** using URI templates, if it is impractical to supply all the possible URIs in the representation (e.g., ad hoc searching).
- **CONSIDER** disregarding opacity to protect against tampering using digitally signed URIs, or to protect sensitive information by encrypting parts of the URI.
- **AVOID** including file extensions, instead rely on the media types.
- **AVOID** using trailing forward slash, as some frameworks may incorrectly remove or add such slashes during URI normalization.
- **AVOID** expecting clients to construct URIs.
- **AVOID** unnecessary query strings in URIs.
- **AVOID** leaking implementation details to clients, by keeping the creating of URIs on the server, as those details will become part of the public interface.
- **DO NOT** use an URI as a generic gateway, by tunneling repeated state changes over `POST` using the same URI.
- **DO NOT** use custom headers to overload URIs.

## URIs for Queries

Queries usually involve filtering, sorting and projections. When providing query support for these and other actions:

- **DO** use snake_case (*never camelCase*) for Query Parameters.
- **DO** use query parameters to let clients specify filter conditions, sort fields, and projections.
- **DO** treat query parameters as optional with sensible defaults.
- **DO** document each parameter.
- **CONSIDER** using `q` (e.g. used by browser tab completion) as the default query parameter.
- **CONSIDER** using a generic `sort` parameter to describe sorting rules. To accommodate more complex sorting requirements, let the `sort` parameter take a list of comma-separated fields, each with a possible unary negative to imply descending sort order. Like: `GET /tickets?sort=-priority,created_at`
- **CONSIDER** using a `fields` query parameter for projections (partial responses), like `http://www.example.org/customers?fields=name,gender,birthday` or `http://example.org/customer?fields=(firstName,user(email))` and `!` to negate field selection. Depending on the use case and payload size, it can reduce network bandwidth and reduce filtering on clients.
- **CONSIDER** using a `view` query parameter for predefined projections, like `http://www.example.org/customers?view=summary`
- **CONSIDER** supporting aliases for commonly used queries (it may also improve cacheability). For instance, `GET /tickets/recently_closed`
- **CONSIDER** using `embed` to allow for resource expansion. Embedding related resources can help reduce the number of requests.
- **CONSIDER** using a `format` query parameter, if standard content negotiation is not possible.
- **CONSIDER** using `limit` and `offset`, like `http://www.example.org/authors?offset=50&limit=25`, when resource collections are backed by traditional relation databases, as these ties into the general implementation on the data store. Opt for `cursor` and a cursor-based pagination strategy, when the dataset is very large and/or backed by a non-traditional relational data store, like a document database. For more information see [Pagination](representations/#pagination).
- **CONSIDER** using sensible defaults for pagination, e.g. limit=10 and offset=0. The pagination defaults are dependent on your data size.
- **AVOID** ad hoc queries that use general-purpose query languages such as *SQL* or *XPath*.
- **AVOID** `Range` requests for implementing queries.

[^1]: [Opaque URIs != Unreadable URIs](http://www.jenitennison.com/2009/07/25/opaque-uris-unreadable-uris.html)
[^2]: a design property that communicates how something should be used without requiring documentation