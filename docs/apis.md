# Web APIs

When we refer to an API, we are referring to a web API, more specifically one delivered over HTTP.
As a term, it specifies how software should interact. An API specifies how a client can use a public API exposed by a server. What URIs are available, what HTTP methods may be used, what query string parameters it accepts, what data can be sent, and what responses to expect.

Web APIs can typically be broken into two broad categories: *RPC* and *REST*.

> RPC (Remote Procedure Call)
> RPC (e.g., XML-RPC, SOAP, etc.) is generally a poor fit for most web API implementations, as they usually require special purpose libraries or SDKs to work properly. A requirement that a lot of clients cannot meat without a lot of extra work and/or clunky third-party libraries. This, and the fact that most RPC implementations do not use HTTP to its full extend, has let us to **not include RPC in any further discussions**. However, if all of your clients are using legacy systems that depend on SOAP libraries, it may make more sense in that case to build a SOAP API for them. A lot of documentation, best practices and general advise on how to build RPC APIs can be found throughout the web.

## REST

We will focus our discussion on REST (REpresentational State Transfer). Especially on how to achieve a more RESTful web API, by leveraging the capabilities of HTTP. For more information about REST itself, please refer to the [Wikipedia article on REST](http://en.wikipedia.org/wiki/Representational_state_transfer) or [WhatIsREST](<http://whatisrest.com>).

Some of the aspects of designing RESTful web APIs include:

- *Unique identification* of resources by using URIs.
- Operation on resources by using the available *HTTP methods*.
- The choice of *media types and formats* that gives clients the ability to specify what representation formats they can render, and for the server to honor those (or indicate if it cannot).
- *Linking* between resources to indicate relationships (e.g., hypermedia links).

Today, most web APIs are not truly REST APIs, instead they tend to be of a varying degree of RESTfulness. Therefore, the [Richardson Maturity Model](http://martinfowler.com/articles/richardsonMaturityModel.html) is often used to describe what it takes to make a well-designed REST API. The higher the level, the more useful:

- Level 0: Uses HTTP as a transport mechanism for RPC, as mentioned above.
- Level 1: Uses URIs for individual resources, but does not use HTTP methods, media types, or linking between resources.
- Level 2: Uses HTTP methods and headers for interactions with resources, and returns appropriate HTTP status codes.
- Level 3: Uses hypermedia controls for discoverability, providing a way of making an API more self-documenting.

So a good REST API should:

- Use unique URIs to expose resources for clients to use.
- Leverage the full spectrum of HTTP, to perform operations on those resources, and allow varying representations of content, enabling HTTP-level caching, etc.
- Provide relational links for resources, to inform the client what can be done next.

Here we will try to offer advise on how to achieve these goals, both in regards to implementing clients as well as servers. Specifically we will focus on:

- How to identify resources by using URIs
- How to use the available HTTP methods
- What representation formats to you expose and what to do when the server cannot fulfill a request for a given representation
- How to report errors, using HTTP status codes and representations
- How to handle security, including HTTP authentication, OAuth2, and API tokens
- How to handle hypermedia linking
- How to document your API
- And more... <!-- TODO -->

But before jumping straight into designing an API, here are some key questions to think about:

- Who is the target audience for the API (customers, third-party services, or even developers looking to extend upon your services for their own customers)?
- What are the use cases for integrating with the API?
- What technologies will the client use to integrate with the API?
- Which products/services to expose? 
- What other services should the API interact with?

    ## API Design Principles

    REST is centered around business (data) entities exposed as resources that are identified via URIs and can be manipulated via standardized CRUD-like methods using different representations, self-descriptive messages and hypermedia.

    RESTful APIs tend to be less use-case specific and comes with less rigid client / server coupling and are more suitable as a platform interface being open for diverse client applications.

    - We prefer REST-based APIs with JSON payloads
    - We prefer systems to be truly RESTful
    - We apply the RESTful web service principles to all kind of application components, whether they provide functionality via the Internet or via the intranet as larger application elements. We strive to build interoperating distributed systems that different teams can evolve in parallel.

    An important principle for (RESTful) API design and usage is Postel's Law, aka the Robustness Principle (RFC 1122):

    Be liberal in what you accept, be conservative in what you send
