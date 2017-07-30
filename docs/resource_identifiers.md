## Resource Identifiers (URIs)

An important aspect of API design is to think about how to design unique resource identifiers, and as such, URIs should be treated as opaque resource identifiers.

This means that clients should not be concerned with the design of URIs, nor should clients try to pick apart URIs in order to gather information from them. Instead URIs should be discovered through links (and the submission of forms).

> For instance, clients must not use the fact that a URI ends with `.xml` to infer that it resolves to an XML representation, instead it must rely on the `Content-Type` header of the response. 

The opacity of URIs helps reduce coupling between servers and clients. This has nothing to do with readability or hackability, both of which may be extremely important aspects for developers consuming the API, where:

- *readable URIs* help developers understand something about the resource.
- *hackable URIs* are manipulated by altering/removing portions of the path or query, and can help developers locate other resources.

### Designing URIs

    The base URI is the most important design affordance of your API. A simple and intuitive base URI design makes using your API easy. Affordance is a design property that communicates how something should be used without requiring documentation. 

When designing URIs:

- **DO** design URIs to last a long time - [Cool URIs don't change](<http://www.w3.org/Provider/Style/URI>).
- **DO** design URIs based on stable concepts, identifiers, and information.
- **CONSIDER** that URIs cannot be permanent if the concepts or identifiers used cannot be permanent for business, technical, or security reasons.- 
- **DO** keep your base URI simple and intuitive.
- **DO** use lowercase for URIs.
- **DO** use domains and subdomains to logically group or partition resources for localization, distribution, or to enforce various monitoring or security policies.
- **DO** use forward-slash (`/`) in the path segment to indicate a hierarchical relationship between resources.
- **DO** use the hyphen (`-`) or (`_`) characters to improve the readability of long path segments. Pick one or the other for consistency.
- **DO** use ampersand (`&`) to separate query parameters.
- **DO** use the URI only to determine which resource should process a request.
- **CONSIDER** provide URIs at runtime using links in the body of representations or headers, whenever appropriate.
- **CONSIDER** using `/api` as the first path segment, when the API also supports non-public APIs, e.g., for specific operational support functions. Otherwise, consider forgoing the `/api` prefix.
- **CONSIDER** using comma (`,`) and semi-colon (`;`) to indicate nonhierarchical elements in the path segment. The semi-colon (`;`) convention is used to identify matrix parameters. *As not all libraries recognize these as separators and may require custom coding to extract these parameters*.
- **CONSIDER** using URI templates, if it is impractical to supply all the possible URIs in the representation (e.g., ad hoc searching).
- **CONSIDER** disregarding opacity to protect against tampering using digitally signed URIs, or to protect sensitive information by encrypting parts of the URI.
- **AVOID** including file extensions, instead rely on the media types.
- **AVOID** using trailing forward slash, as some frameworks may incorrectly remove or add such slashes during URI normalization.
- **AVOID** expecting clients to construct URIs.
- **AVOID** unnecessary query strings in URIs.
- **AVOID** leaking implementation details to clients, by keeping the creating of URIs on the server, as those details will become part of the public interface.
- **DO NOT** use an URI as a generic gateway, by tunneling repeated state changes over `POST` using the same URI.
- **DO NOT** use custom headers to overload URIs.

### URIs for Queries

Queries usually involve filtering, sorting and projections. When providing query support for these and other actions:

- **DO** use snake_case (never camelCase) for Query Parameters.
- **DO** use query parameters to let clients specify filter conditions, sort fields, and projections.
- **DO** treat query parameters as optional with sensible defaults.
- **DO** document each parameter.
- **CONSIDER** using `q` (e.g. used by browser tab completion) as the default query parameter.
- **CONSIDER** using a generic `sort` parameter to describe sorting rules. To accommodate more complex sorting requirements, let the `sort` parameter take a lift of comma-separated fields, each with a possible unary negative to imply descending sort order. Like: `GET /tickets?sort=-priority,created_at`
- **CONSIDER** using a `fields` query parameter for projections, like `http://www.example.org/customers?fields=name,gender,birthday`. Depending on the use case and payload size, it can reduce network bandwidth and reduce filtering on clients.
- **CONSIDER** using a `view` query parameter for predefined projections, like `http://www.example.org/customers?view=summary`
- **CONSIDER** supporting aliases for commonly used queries (it may also improve cacheability). For instance, `GET /tickets/recently_closed`
- **CONSIDER** using `embed` to allow for resource expansion. Embedding related resources can help reduce the number of requests.
- **COSIDER** using a `format` query parameter, if standard content negotiation is not possible.
- **AVOID** ad hoc queries that use general-purpose query languages such as *SQL* or *XPath*.
- **AVOID** `Range` requests for implementing queries.

    <!-- TODO -->

    ## PAGINATION

    limit — to restrict the number of entries. See Pagination section below. Hint: You can use size as an alternate query string.
    cursor — key-based page start. See Pagination section below.
    offset — numeric offset page start. See Pagination section below. Hint: In combination with limit, you can use page as an alternative to offset.

    ### SHOULD:: Support Filtering of Resource Fields

    GET http://api.example.org/resources/123?fields=(name,partner(name)) HTTP/1.1

    As illustrated by this example, field filtering should be done via request parameter "fields" with value range defined by the following BNF grammar.

    ```
    <fields> ::= <negation> <fields_expression> | <fields_expression>

    <negation> ::= "!"

    <fields_expression> ::= "(" <field_set> ")"

    <field_set> ::= <qualified_field> | <qualified_field> "," <field_set>

    <qualified_field> ::= <field> | <field> <fields_expression>

    <field> ::= <DASH_LETTER_DIGIT> | <DASH_LETTER_DIGIT> <field>

    <DASH_LETTER_DIGIT> ::= <DASH> | <LETTER> | <DIGIT>

    <DASH> ::= "-" | "_"

    <LETTER> ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z" | "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"

    <DIGIT> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
    ```

    A fields_expression as defined by the grammar describes the properties of an object, i.e. (name) returns only the name property of the root object. (name,partner(name)) returns the name and partner properties where partner itself is also an object and only its name property is returned.

    ### SHOULD:: Allow Optional Embedding of Sub-Resources

    Please use the BNF grammar, as already defined above for filtering, when it comes to an embedding query syntax.

### Using URIs in Clients

- **DO** update local copies of old URIs when receiving `301 Moved Permanently`.
- **DO** verify that the `Location` URI maps to a trusted server.
- **DO NOT** disable support of redirects in client applications. Instead, consider a sensible limit on the number of redirects a client can follow. Disabling redirects altogether will break the client when the server change URIs.
