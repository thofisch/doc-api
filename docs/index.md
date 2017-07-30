# Introduction

__*should we talk about microservices/component architecture or overall architectural goals or just these guidelines?*__

    When starting to design and build a RESTful API, there are a lot of decisions to be made. How do you handle authentication? Which data transfer formats do you support? How do you document your APIs? How do you handle versioning? When we started our initial design to migrate from version one to version two of our own API, these were a lot of the questions that we had to answer. Some of them were easy and others incited passionate debates (read: “yelling”) amongst our engineering team.

    # Introduction

    If you're reading this, chances are that you care about designing Web APIs that developers will love and that you're interested in applying proven design principles and best practices to your Web API.

    One of the sources for our design thinking is REST. Because REST is an architectural style and not a strict standard, it allows for a lot of flexibly. Because of that flexibility and freedom of structure, there is also a big appetite for design best practices.

    This e-book is a collection of design practices that we have developed in collaboration with some of the leading API teams around the world, as they craft their API strategy through a design workshop that we provide at Apigee.

    We call our point of view in API design "pragmatic REST", because it places the success of the developer over and above any other design principle. The developer is the customer for the Web API. The success of an API design is measured by how quickly developers can get up to speed and start enjoying success using your API.

    We'd love your feedback – whether you agree, disagree, or have some additional practices and tips to add. The API Craft Google Group is a place where Web API design enthusiasts come together to share and debate design practices – we'd love to see you there.

    ## Are you a Pragmatist or a RESTafarian?

    Let's start with our overall point of view on API design. We advocate pragmatic, not dogmatic REST. What do we mean by dogmatic?

    You might have seen discussion threads on true REST - some of them can get pretty strict and wonky. Mike Schinkel sums it up well - defining a RESTafarian as follows:

    "A RESTifarian is a zealous proponent of the REST software architectural style as defined by Roy T. Fielding in Chapter 5 of his PhD. dissertation at UC Irvine. You can find RESTifarians in the wild on the REST-discuss mailing list. But be careful, RESTifarians can be extremely meticulous when discussing the finer points of REST …"

    Our view: approach API design from the 'outside-in' perspective. This means we start by asking - what are we trying to achieve with an API?

    The API's job is to make the developer as successful as possible. The orientation for APIs is to think about design choices from the application developer's point of view. 

    Why? Look at the value chain below – the application developer is the lynchpin of the entire API strategy. The primary design principle when crafting your API should be to maximize developer productivity and success. This is what we call pragmatic REST.

    You have to get the design right, because design communicates how something will be used. The question becomes - what is the design with optimal benefit for the app developer?

    The developer point of view is the guiding principle for all the specific tips and best practices we've compiled


## Motivation

The motivation behind the *API Guidelines* is to define standards or "best practices" in order to:

- design robust and long-lasting APIs of high quality
- design APIs that are easy to understand and use
- have a consistent API "look and feel" across the board
- facilitate APIs as a Product

## Thinking in Products

When creating APIs intended for use by someone else, whether it is acutally sold or not, it can be thought of as a product. This can be very easy to lose sight of, so before using the more specific advice on how to achieve successful APIs, keep these overall principles in mind:

- **Be customer-centric**

    Do not focus on data rather than customers. Rather focus on target developer's problems, by involving customers early in the design process. Make use of reviews and customers feedbacks, and provide service level support. Make APIs irresistible by having a high attention to API quality and client developer experience.


    ![](./imgs/api-as-a-product-750-3-v4.png)

- **Treat every API as if it was a public API**

    Do not skip on usability and security when creating private or partner APIs, as this can make the transition into a public API difficult. Instead actively improve and maintain API consistency over the long term.

- **Componentize your systems**

    Identifying, breaking apart, and isolating small feature sets in big systems: can help innovation by creating platforms to enable other organizations to build new applications that better suit their needs; offers a higher degree of composability, which makes it possible to offer products as open systems instead of inflexible off-the-shelf solutions; may help monitize existing assets.

## About These Guidelines

These guidelines are a work in progress, and is maintained by API Enablement Team during their initial work. Later teams are responsible to adhere to these guidelines during API design and development, and to continue to evolve these guidelines.*

__*What should we do when the guideline changes? Do existing APIs have to change?*__

## Conventions Used in These Guidelines

In these guidelines when referring to an API, we implicitly mean a web API delivered over HTTP. The terms: API, web API, and public API may be used interchangeably throughtout these guidelines.

The following typographical conventions are used in these guidelines:

`Constant width` program listings, as well as within paragraphs to refer to URLs, mime types, HTTP methods, HTTP headers, and HTTP status codes.

Each secton will usually be comprised of one or more lists of recommendations:

- **DO** to signify that you should do this.
- **CONSIDER** to signfy that you should consider doing this.
- **AVOID** to signfy that you should avoid doing this.
- **DO NOT** to signfy that you should not do this.

__*Should we consider using the requirement level keywords "MUST", "SHOULD", etc., from RFC 2119 instead?*__
