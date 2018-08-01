# Application Programming Interfaces

An API specifies how software should interact. Particularly, how a client can use an API, what URIs are available, what HTTP methods may be used, what query string parameters it accepts, what data can be sent, and what responses to expect.

## API as a Product

When creating APIs intended for use by someone else, whether it is actually sold or not, it can and should most likely be treated as a product in itself.

This can be very easy to lose sight of, so before jumping to the more specific advice on how to achieve successful APIs, keep the following overall principles in mind:

## Be Customer-Centric

Do not focus on data rather than customers. Instead focus on target developer's problems, by involving customers early in the design process. Make use of reviews and customers feedback, and provide service level support. Make APIs irresistible by having a high attention to API quality and client developer experience.

![API as a Product](./imgs/api-as-a-product-750-3-v4.png)

## Treat Every API as if it was a Public API

Do not skip on usability and security when creating private or partner APIs, as this can make the transition into a public API difficult. Instead actively improve and maintain API consistency over the long term.

## Componentize Your Systems

Identifying, breaking apart, and isolating small feature sets in big systems:

- can help innovation by creating platforms to enable other organizations to build new applications that better suit their needs
- offers a higher degree of composability, which makes it possible to offer products as open systems instead of inflexible off-the-shelf solutions
- may help monetize existing assets

## Types of APIs

Web APIs can typically be broken into two broad categories: **RPC** and **REST**. These guidelines will only deal with REST.

??? info "RPC (Remote Procedure Call)"
    RPC (e.g., gRPC and SOAP) is generally a poor fit for most public API implementations, as they usually require special purpose libraries or SDKs to work properly. A requirement that a lot of clients cannot meet without a lot of extra work and/or clunky third-party libraries.
    
    This, and the fact that most RPC implementations do not use HTTP to its full extend, has led us to **exclude RPC from these guidelines**. However, if all of your clients are using legacy systems that depend on SOAP libraries, it may make more sense in that case to build a SOAP API for them.
    
    A lot of documentation, best practices and general advise on how to build RPC APIs can be found throughout the web.

## Organizing APIs

Large API vendors (like Facebook, Twitter, and Foursquare) usually have their APIs organized behind one or more subdomains, like e.g.:

| Facebook           | Twitter            | Forsquare          |
|--------------------|--------------------|--------------------|
| graph.facebook.com | stream.twitter.com | api.foursquare.com |
| api.facebook.com   | api.twitter.com    |                    |
|                    | search.twitter.com |                    |

It is not difficult to imagine how Facebook and Twitter ended up with more than one API - timing, team organization, acquisitions have likely played their part. However, following Foursquare's lead and consolidating all API requests under one API subdomain, might be the best interest of API consumers.

- **DO** consolidate API requests in one subdomain, e.g. `https://api.example.org`. It is cleaner, easier and more intuitive for developers who want to build cool stuff using your APIs.

### Developer Portal

A developer portal might be a good idea for hosting examples, application notes, authentication guidance, human-readable documentation, error scenarios and descriptions, etc. Again some of the major API vendors all have dedicated developer portals:

| Facebook                | Twitter         | Forsquare                 |
|-------------------------|-----------------|---------------------------|
| developers.facebook.com | dev.twitter.com | developers.foursquare.com |

- **DO** use the `dev.example.org` or `developers.example.org` subdomains to expose your developer portal, if the API subdomain resides on `api.example.org`.
- **CONSIDER** using redirects, if you can gather based on the incoming request from a browser where the developer really needs to go. E.g., if a developer types `api.example.org` in the browser without any furher information in the `GET` request, it is probably safe to redirect to the developer portal and help get the developer.

## API Operation

- **DO** setup instrumentation from the outset of the API implementation to monitor important business metrics/KPIs.
- **DO** gather information about the clients. This information, for instance, is useful to identify potential review partners for API changes.

{++

## Tools

The demand for flexibility and extensibility has driven the development of APIs and tools alike, and in many regards it has never been easier to create an API than it is today with multitudes of frameworks (such as JAX-RS, Apigility, Django REST Framework, Grape), specs (RAML, Swagger, API Blueprint, IO Docs), and tools (API Designer, API Science, APImatic) available.

++}
