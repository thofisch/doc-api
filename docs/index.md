# Motivation

The motivation behind the *API Guidelines* is to define standards or "best practices" in order to:

- design robust and long-lasting APIs of high quality
- design APIs that are easy to understand and use
- have a consistent API "look and feel" across the board
- facilitate APIs as a Product
- __*should we talk about microservices/component architecture or overall architectural goals?*__

Before using the more specific advice on how to achieve successful APIs, follow these overall principles:

- **Be customer-centric**: Do not focus on data rather than customers. Rather focus on target developer's problems, by
 involving customers early in the design process. Make use of reviews and customers feedbacks, and provide service level support. Make APIs irresistible by having a high attention to API quality and client developer experience.
- **Treat every API as if it was a public API**: Do not skip on usability and security when creating private or partner APIs, as this can make the transition into a public API difficult. Instead actively improve and maintain API consistency over the long term.

![](./imgs/api-as-a-product-750-3-v4.png)

## About These Guidelines

These guidelines are a work in progress, and is maintained by API Enablement Team during their initial work. Later teams are responsible to adhere to these guidelines during API design and development, and to continue to evolve these guidelines.*

__*What should we do when the guideline changes? Do existing APIs have to change?*__

## Conventions Used in These Guidelines

The following typographical conventions are used in these guidelines:

`Constant width` program listings, as well as within paragraphs to refer to URLs, mime types, HTTP methods, HTTP headers, and HTTP status codes.

Each secton will usually be comprised of one or more lists of recommendations:

- **DO** to signify that you should do this.
- **CONSIDER** to signfy that you should consider doing this.
- **AVOID** to signfy that you should avoid doing this.
- **DO NOT** to signfy that you should not do this.

__*Should we consider using the requirement level keywords "MUST", "SHOULD", etc., from RFC 2119 instead?*__
