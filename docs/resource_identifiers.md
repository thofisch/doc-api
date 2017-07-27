## Resource Identifiers (URIs)

URIs should be treated as opaque resource identifiers.

This means that clients should not be concerned with how a server designs its URIs, nor should they try to pick apart URIs in order to work out information from them. Instead URIs should be discovered through links (and the submission of forms).

For instance, clients must not use the fact that a URI ends with the `.xml` extension to infer that it resolves to an XML representation, but must rely on the `Content-Type` header of the response. 

The opacity of URIs are important and help reduce coupling between servers and clients. This has nothing to do with readability or hackability, both of which are extremely important for human users.

- *Readable URIs* help users understand something about the resource that the URI is pointing to. 
- *Hackable URIs* (manipulated by altering/removing portions of the path or query) enable human users to locate other resources that they might be interested in.

### Designing URIs

- **DO** design URIs to last a long time - [Cool URIs don't change](<http://www.w3.org/Provider/Style/URI>).
- **DO** design URIs based on stable concepts, identifiers, and information.
- **DO** use domains and subdomains to logically group or partition resources for localization, distribution, or to enforce various monitoring or security policies.
- **DO** use forward-slash (`/`) in the path segment to indicate a hierarchical relationship between resources.
- **DO** use lowercase for URIs.
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
- **CONSIDER** using `/api` as the first path segment, when the API should also support non-public APIs. E.g. for specific operational support functions. Otherwise, consider forgoing the `/api` prefix.
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

Queries usually involve filtering, sorting and projections. When providing query support for these and other actions:

- **DO** use snake_case (never camelCase) for Query Parameters.
- **DO** use query parameters to let clients specify filter conditions, sort fields, and projections.
- **DO** treat query parameters as optional with sensible defaults.
- **DO** document each parameter.
- **CONSIDER** using `q` as the default query parameter (e.g. used by browser tab completion).
- **CONSIDER** using a generic `sort` parameter to describe sorting rules. To accommodate more complex sorting requirements, let the `sort` parameter take a lift of comma-separated fields, each with a possible unary negative to imply descending sort order. Like: `GET /tickets?sort=-priority,created_at`
- **CONSIDER** using a `fields` query parameter for projections, like `http://www.example.org/customers?fields=name,gender,birthday`. Depending on the use case and payload size, it can reduce network bandwidth and reduce filtering on clients.
- **CONSIDER** using a `view` query parameter for predefined projections, like `http://www.example.org/customers?view=summary`
- **CONSIDER** supporting aliases for commonly used queries (it may also improve cacheability). For instance, `GET /tickets/recently_closed`
- **CONSIDER** using `embed` to allow for resource expansion. Embedding related resources can help reduce the number of requests.
- **AVOID** ad hoc queries that use general-purpose query languages such as *SQL* or *XPath*.
- **AVOID** `Range` requests for implementing queries.

    <!-- TODO -->
    ## PAGINATION

    limit — to restrict the number of entries. See Pagination section below. Hint: You can use size as an alternate query string.
    cursor — key-based page start. See Pagination section below.
    offset — numeric offset page start. See Pagination section below. Hint: In combination with limit, you can use page as an alternative to offset.

    ### SHOULD:: Support Filtering of Resource Fields

    Unfiltered:

    GET http://api.example.org/resources/123 HTTP/1.1

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
        "id": "cddd5e44-dae0-11e5-8c01-63ed66ab2da5",
        "name": "John Doe",
        "address": "1600 Pennsylvania Avenue Northwest, Washington, DC, United States",
        "birthday": "1984-09-13",
        "partner": {
            "id": "1fb43648-dae1-11e5-aa01-1fbc3abb1cd0",
            "name": "Jane Doe",
            "address": "1600 Pennsylvania Avenue Northwest, Washington, DC, United States",
            "birthday": "1988-04-07"
        }
    }

    Filtered:

    GET http://api.example.org/resources/123?fields=(name,partner(name)) HTTP/1.1

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
        "name": "John Doe",
        "partner": {
            "name": "Jane Doe"
        }
    }

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
