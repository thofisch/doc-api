# Introduction

When designing and building APIs, there are a lot of things to consider. Among these are [security](security), [media types](representations/#format-and-a-media-type), [documentation](documentation-and-discovery), and [versioning](versioning-and-extensibility). These, and a lot of other concerns, are what we address here, in order to offer comprehensible guidelines on how to design APIs.

## Motivation

The motivation behind the *API Guidelines* is to define standards or "best practices" in order to:

- design robust and long-lasting APIs of high quality
- design APIs that are easy to understand and use
- have a consistent API "look and feel" across the board
- facilitate APIs as a Product

## About These Guidelines

These guidelines are a work in progress, and are maintained by the **API Enablement Team** {>>Now defunct - who then?<<} during their initial work. Later teams are responsible for adhering to these guidelines during API design and development, and to continue to evolve these guidelines.

{>>What should we do when the guideline changes? Do existing APIs have to be changed as well?<<}

## Conventions Used in These Guidelines

In these guidelines when referring to an API, we implicitly mean a web API delivered over HTTP.

The terms: API, web API, and public API may be used interchangeably throughout these guidelines.

The following typographical conventions are used in these guidelines:

`Constant width` program listings, as well as within paragraphs to refer to URLs, mime types, HTTP methods, HTTP headers, and HTTP status codes.

Each section will usually be comprised of one or more lists of recommendations:

- **DO** to signify that you should do this.
- **CONSIDER** to signify that you should consider doing this.
- **AVOID** to signify that you should avoid doing this.
- **DO NOT** to signify that you should not do this.

{>>Should we consider using the requirement level keywords "MUST", "SHOULD", etc., from RFC 2119 instead?<<}

### Admonitions

!!! note
    these sections hold additional information

!!! tip 
    these sections hold tips

!!! warning
    these sections hold cautions

!!! example "Larger blocks of code and examples"
    ```bash
    curl https://example.org/api/resource | jq
    ```
