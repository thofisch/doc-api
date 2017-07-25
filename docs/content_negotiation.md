## Content Negotiation (conneg)

There are two types of content negotiation:

- *Server-driven* negotiation, uses request headers to select a variant
- *Agent-driven* negotiation, uses a distinct URI for each variant

### Server-Driven Negotiation

- **DO** support multiple variants only when your clients need them.
- **DO** support multiple variants only when each variant contains the same information
- **DO NOT** use server-driven negotiation when the information content is different, use [agent-driven negotiation](#agent-driven-negotiation) instead.

#### Indicating Client Preferences

It is important for the client to indicate its preferences and capabilities to the server, including:

- representation formats
- languages
- character encoding
- support for compression.

Even when you know out of band this information, clearly indicating the client's preferences and capabilities can help the client in the face of change. It is better to ask for a specific representation instead of getting a default one, because the default can change.

When making a request:

- **DO** add an `Accept` header with a comma-separated list of media type preferences. If the client prefers one media type over the other, add a `q` parameter with each media type.
- **DO** add `*;q=0.0` in the `Accept` header to indicate to the server it cannot process anything other than the media types listed in the `Accept` header, if the client can process only certain formats.
- **DO** add an `Accept-Charset` header with the preferred character set, if the client can process characters of a specific character set only, if not, avoid adding this header
- **DO** add an `Accept-Language` header for the preferred language of the representation.
- **DO** add an `Accept-Encoding` header listing the supported encodings,if the client is able to decompress representations compressed encoding such as `gzip`, `compress`, or `deflate`, add an `Accept-Encoding` header listing the supported encodings, if not, skip this header
- **DO NOT** assume that servers support content negotiation, and be prepared to receive a representation that does not meet the `Accept-*` headers.

#### Content Type Negotiation

*content negotiation (include or exclude and force to e.g. json)?*

- **DO** return a representation using the default format, if the request has no `Accept` header.
- **DO** parse the header, sort the values of media types by the `q` parameters in descending order, if the request has an `Accept` header, then select a media type from the list that the server supports.
- **DO** handle [content negotiation failures](#7.7) to determine an appropriate response
- **CONSIDER** including a `Vary` (see [Vary](#vary)) response header [**See 7.6**]
- **CONSIDER** using [*agent-driven negotiation*](#agent-driven-negotiation), if the server starts out ignoring `Accept`, e.g. by returning `Content-Type: application/xml` for `Accept: application/json` requests, adding content negotiation (here by adding `Content-Type: application/json`) will likely break compatibility for working clients.

#### Language Negotiation

- **DO** return a representation with all human-readable text in a default language, if the request has no `Accept-Language` header.
- **DO** parse the header, sort the languages by the `q` parameters in descending order, and select the first language in the list that the server can support, if the request has an `Accept-Language` header
- **DO** use a default language for the response, if the server does not support any languages in the list, and the `Accept-Language` header does not contain `*;q=0.0`.
- **CONSIDER** including a `Vary` (see [The Vary Header](#the-vary-header)) response header.

This approach is best suited when representations in different languages differ only in terms of the language used for any human-readable text. If the differences between representations are more significant, use other means of localization such as the client's IP address or region/language-specific URIs.

#### Character Encoding Negotiation

- **DO** encode the textual representation of the response using the encoding the client ask for via the `Accept-Charset` header. Encoding the response using that encoding promotes interoperability.
- **DO** return a representation using `UTF-8` encoding, if the request has no `Accept-Charset` header.
- **DO** parse the header, sort the character set by the `q` parameters in descending order, and select the first character set that the server can support for encoding.
- **DO** return a representation using `UTF-8` encoding, if the server does not support any requested character set and the `Accept-Charset` header does not contain `*;q=0.0`.
- **DO** include the `charset` parameter in the `Content-Type` header, in all cases, if the media type is textual and allows a `charset` parameter.
- **CONSIDER** including a `Vary` (see [The Vary Header](#the-vary-header)) response header.
- **AVOID** using `text/xml` since its default encoidng is `us-ascii`.

#### Supporting Compression

To support compression or *content encoding*:

- **DO** use the compression technique from the `Accept-Encoding` header, if the server is capable of compressing the response body.
- **DO** parse the header, sort the character set by the `q` parameters in descending order, and select the first content encoding the server supports.
- **DO** ignore this header, if no encoding in this header matches the server's supported encodings.
- **CONSIDER** including a `Vary` (see [The Vary Header](#the-vary-header)) response header.
- **DO NOT** compress representations, if the request has no `Accept-Encoding` header.

#### The Vary Header

When a server uses content negotiation to select a representation, the same URI can yield different representations based on `Accept-*` headers. The `Vary` header tells clients which request headers the server used when selecting a representation. Caches may use the `Vary` header as part of cache keys to maintain variants of a resource.

- **CONSIDER** including a `Vary` header whenever multiple representations are available for a resource. The value of this header is a comma-separated list of *request headers* the server uses when choosing representation.
- **CONSIDER** including a `Vary` header with a value of `*`, if the server uses information other then the headers in the request, such as a client's IP address, time of day, user personalization, etc.

#### Negotiation Failures

- **CONSIDER** that servers are free to serve any available representation for a given resource. However, clients may not be able to handle arbitrary media types.
- **DO** return `406 Not Acceptable` with either the body of the representation containing the list of representations, or a `Link` in the header, when the server cannot serve a representation that meets the client's preferences and if the client explicitly included a `*;q=0.0`.
- **DO** serve the representation without applying any content encoding, if the server is unable to support the requested `Accept-Encoding` value.

### Agent-Driven Content Negotiation

Although server-driven negotiation is built into HTTP, it has limitations:

- Content negotiation does not include elements such as currency units, distance units, date formats, and other regional flavors for any human-readable text in representations.
- In some cases, because of complex localization requirements, the server may decide to maintain different resources for different locales.

Agent-driven negotiation simply mean providing distinct URIs for each variant and allow the client to use that URI to select the desired representation.

- **CONSIDER** using agent-driven negotiation when the client cannot communicate its preferences using `Accept-*` headers.
- **CONSIDER** using one or more of these common approaches:
   - Query parameters, like `http://www.example.org/status?format={format}`
   - URI extensions, appending a dot (`.`) and a shorthand media type to the base URI. Like `http://www.example.org/status.json`
   - Subdomains, like `http://dk.example.org/status`
- **CONSIDER** letting the server advertise alternatives using links with the `alternate` link relation type, when using agent-driven negotiation.
- **DO** use out-of-band information from the server to determine which URI to use. If the representation exists, the server returns it, if not, it return `404 Not Found`.

Although it is possible to implement agent-driven negotiation for all `Accept-*` headers, in practice it is most commonly used for media types and languages.

