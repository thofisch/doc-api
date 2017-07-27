# Application Programming Interfaces

In these guidelines when referring to an API, we are referring to a web API, more specifically one delivered over HTTP.

An API specifies how software should interact. How a client can use a public API exposed by a server. Particularly, what URIs are available, what HTTP methods may be used, what query string parameters it accepts, what data can be sent, and what responses to expect.

Web APIs can typically be broken into two broad categories: *RPC* and *REST*.

> **RPC (Remote Procedure Call)**<br/>
> RPC (e.g., XML-RPC, SOAP, etc.) is generally a poor fit for most web API implementations, as they usually require special purpose libraries or SDKs to work properly. A requirement that a lot of clients cannot meet without a lot of extra work and/or clunky third-party libraries. This, and the fact that most RPC implementations do not use HTTP to its full extend, has led us to **exclude RPC from these guidelines**. However, if all of your clients are using legacy systems that depend on SOAP libraries, it may make more sense in that case to build a SOAP API for them. A lot of documentation, best practices and general advise on how to build RPC APIs can be found throughout the web.

## REST All the Way Down

We will focus our discussion on REST (REpresentational State Transfer). Especially on how to achieve a more RESTful web API, by leveraging the capabilities of HTTP. For more information about REST itself, please refer to the [Wikipedia article on REST](http://en.wikipedia.org/wiki/Representational_state_transfer) or [WhatIsREST](<http://whatisrest.com>).

Some of the aspects of designing RESTful web APIs include:

- *Unique identification* of resources by using URIs.
- Operation on resources by using the available *HTTP methods*.
- A choice of *media types and formats* that allow clients to specify representation formats they can render, and for servers to honor those (or indicate if it cannot).
- *Linking* between resources to indicate relationships (e.g., hypermedia links).

Today, most web APIs are not truly REST APIs, instead they tend to be of a varying degree of RESTful. Therefore, the [Richardson Maturity Model](http://martinfowler.com/articles/richardsonMaturityModel.html) is often used to describe what it takes to make a well-designed REST API:

- **Level 0**: Uses HTTP as a transport mechanism for RPC.
- **Level 1**: Uses URIs for individual resources, but does not use HTTP methods, media types, or linking between resources.
- **Level 2**: Uses HTTP methods and headers for interactions with resources, and returns appropriate HTTP status codes.
- **Level 3**: Uses hypermedia controls for discoverability, which also helps making an API more self-documenting.

So a good REST API should:

- Use unique URIs to expose resources for clients to use.
- Use the full spectrum of HTTP, to perform operations on those resources, and allow different representations of content.
- Provide relational links for resources, to inform the client what can be done next.

In these guidelines we will offer advise on how to achieve this, when implementing clients as well as servers. Specifically we will focus on:

- How to identify resources by using URIs
- How to use the available HTTP methods
- What representation formats to you expose and what to do when the server cannot fulfill a request for a given representation
- How to report errors, using HTTP status codes and representations
- How to handle security, including HTTP authentication, OAuth2, and API tokens
- How to handle hypermedia linking
- How to document your API
- **_And more..._**

Before jumping straight into designing an API, it can be helpful to think about:

- The target audience of the API (customers, third-party services, or other developers looking to take advantage of your services for their own customers)?
- The cases for integrating with the API?
- Technologies used to integrate with the API?
- Which products/services to expose? 
- Other services the API should/might interact with?
