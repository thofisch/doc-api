# Motivation

The motivation behind the *API Guidelines* is to define standards to successfully establish "consistent API look and feel" quality.


The software architecture centers around decoupled microservices that provide functionality via RESTful APIs.

Small teams own, deploy and operate these microservices.

APIs must purely express what our systems do, and are therefore highly valuable business assets.

Designing high-quality, long-lasting APIs will become increasingly more important.

Our strategy emphasizes developing lots of public APIs for our external business partners to use via third-party applications.

Adopted "API First" where development begins with API definition outside the code and ideally involves ample peer-review feedback to achieve high-quality APIs. Some benefits:

- are easy to understand and learn
- are general and abstracted from specific implementation
- are robust and easy to use
- have a common look and feel
- follow a consistent RESTful style and syntax
- are consistent with other APIs and our global architecture

Ideally, all APIs will look like the same author created them.



Teams are responsible to fulfill these guidelines during API development and are encouraged to contribute to guideline evolution via pull requests.

These guidelines will, to some extent, remain work in progress as our work evolves, but teams can confidently follow and trust them.

In case guidelines are changing, following rules apply:

- existing APIs don't have to be changed, but we recommend it
- clients of existing APIs have to cope with these APIs based on outdated rules
- new APIs have to respect the current guidelines
- Furthermore you should keep in mind that once an API becomes public externally available, it has to be re-reviewed and changed according to current guidelines - for sake of overall consistency.


## API as a Product

We want to deliver products to our (internal and external) customers which can be consumed like a service.

Platform products provide their functionality via (public) APIs; hence, the design of our APIs should be based on the API as a Product principle:

- Treat your API as product and understand the needs of its customers
- Take ownership and advocate for the customer and continuous improvement
- Emphasize easy understanding, discovery and usage of APIs; design APIs irresistible for client engineers
- Actively improve and maintain API consistency over the long term
- Make use of customer feedback and provide service level support
- RESTful API as a Product makes the difference between enterprise integration business and agile, innovative product service business built on a platform of APIs.

Based on your concrete customer use cases, you should carefully check the trade-offs of API design variants and avoid short-term server side implementation optimizations at the expense of unnecessary client side obligations and have a high attention on API quality and client developer experience.

API as a Product is closely related to our API First principle (see next chapter) which is more focused on how we engineer high quality APIs.

## API Design Principles

REST is centered around business (data) entities exposed as resources that are identified via URIs and can be manipulated via standardized CRUD-like methods using different representations, self-descriptive messages and hypermedia.

RESTful APIs tend to be less use-case specific and comes with less rigid client / server coupling and are more suitable as a platform interface being open for diverse client applications.

- We prefer REST-based APIs with JSON payloads
- We prefer systems to be truly RESTful
- We apply the RESTful web service principles to all kind of application components, whether they provide functionality via the Internet or via the intranet as larger application elements. We strive to build interoperating distributed systems that different teams can evolve in parallel.

An important principle for (RESTful) API design and usage is Postel's Law, aka the Robustness Principle (RFC 1122):

Be liberal in what you accept, be conservative in what you send

## Conventions Used in These Guidelines

The following typographical conventions are used in these guidelines:

`Constant width` program listings, as well as within paragraphs to refer to URLs, mime types, HTTP methods, HTTP headers, and HTTP status codes.

Each secton will usually be comprised of one or more lists of recommendations:

- **DO** to signify that you should do this.
- **CONSIDER** to signfy that you should consider doing this.
- **AVOID** to signfy that you should avoid doing this.
- **DO NOT** to signfy that you should not do this.

__*Should we consider using the requirement level keywords "MUST", "SHOULD", etc., from RFC 2119 instead?*__
