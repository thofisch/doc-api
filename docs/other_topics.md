## Other Topics

    <!-- TODO -->

    dog-food your own API

    ## Chatty APIs

    Let's think about how app developers use that API you're designing and dealing with chatty APIs.

    Imagine how developers will use your API

    When designing your API and resources, try to imagine how developers will use it to say construct a user interface, an iPhone app, or many other apps.

    Some API designs become very chatty - meaning just to build a simple UI or app, you have dozens or hundreds of API calls back to the server.

    The API team can sometimes decide not to deal with creating a nice, resource-oriented RESTful API, and just fall back to a mode where they create the 3 or 4 Java-style getter and setter methods they know they need to power a particular user interface.

    We don't recommend this. You can design a RESTful API and still mitigate the chattiness.

    Be complete and RESTful and provide shortcuts

    First design your API and its resources according to pragmatic RESTful design principles and then provide shortcuts.

    What kind of shortcut? Say you know that 80% of all your apps are going to need some sort of composite response, then build the kind of request that gives them what they need.

    Just don't do the latter instead of the former. First design using good pragmatic RESTful principles!

    Take advantage of the partial response syntax

    The partial response syntax discussed in a previous section can help.

    To avoid creating one-off base URLs, you can use the partial response syntax to drill down to dependent and associated resources.

    In the case of our dogs API, the dogs have association with owners, who in turn have associations with veterinarians, and so on. Keep nesting the partial response syntax using dot notation to get back just the information you need.

    /owners/5678?fields=name,dogs.name

    ## Complement with an SDK

    It's a common question for API providers - do you need to complement your API with code libraries and software development kits (SDKs)?

    If your API follows good design practices, is self consistent, standards-based, and well documented, developers may be able to get rolling without a client SDK. Well-documented code samples are also a critical resource.

    On the other hand, what about the scenario in which building a UI requires a lot of domain knowledge? This can be a challenging problem for developers even when building UI and apps on top of APIs with pretty simple domains – think about the Twitter API with it's primary object of 140 characters of text.

    You shouldn't change your API to try to overcome the domain knowledge hurdle. Instead, you can complement your API with code libraries and a software development kit (SDK).

    In this way, you don't overburden your API design. Often, a lot of what's needed is on the client side and you can push that burden to an SDK.

    The SDK can provide the platform-specific code, which developers use in their apps to invoke API operations - meaning you keep your API clean.

    Other reasons you might consider complementing your API with an SDK include the following:

    Speed adoption on a specific platform. (For example Objective C SDK for iPhone.)

    Many experienced developers are just starting off with objective C+ so an SDK might be helpful.

    Simplify integration effort required to work with your API - If key use cases are complex or need to be complemented by standard on-client processing.

    An SDK can help reduce bad or inefficient code that might slow down service for everyone.

    As a developer resource - good SDKs are a forcing function to create good source code examples and documentation. Yahoo! and Paypal are good examples:

    Yahoo! http://developer.yahoo.com/social/sdk/

    Paypal https://cms.paypal.com/us/cgi-bin/?cmd=_rendercontent&content_ID=developer/library_download_sdks

    To market your API to a specific community - you upload the SDK to a samples or plugin page on a platform's existing developer community.


    <!--

    typical usage (adhere to standard http verbs etc. and how it relates to interacting with various resources)
    communicating with services - public facing API’s
    for the public
    Use HTTP Methods
    testing api’s
    automated in-memory integration tests (with live dependencies stubed out)

    Avoid Operations on Nested Routes
    Implement a “Health-Check” Endpoint

    Rate limiting (Twitter-style):
        X-Rate-Limit-Limit - The number of allowed requests in the current period
        X-Rate-Limit-Remaining - The number of remaining requests in the current period
        X-Rate-Limit-Reset - The number of seconds left in the current period

    -->

    ### SHOULD:: Reduce Bandwidth Needs and Improve Responsiveness

    APIs should support techniques for reducing bandwidth based on client needs. This holds for APIs that (might) have high payloads and/or are used in high-traffic scenarios like the public Internet and telecommunication networks. Typical examples are APIs used by mobile web app clients with (often) less bandwidth connectivity. (Zalando is a 'Mobile First' company, so be mindful of this point.)

    Common techniques include:

    gzip compression
    querying field filters to retrieve a subset of resource attributes (see Support Filtering of Resource Fields below)
    paginate lists of data items (see Pagination below)
    ETag and If-(None-)Match headers to avoid re-fetching of unchanged resources (see Common Headers
    pagination for incremental access of larger (result) lists

    Each of these items is described in greater detail below.


    # Authentication is Key
    By providing your API users with a unique API token, or API key you can tell exactly who is making calls to your API.

     Along with having quick access to determining potential malicious users which can immediately be removed, you can also set permissions and SLAs for users depending on their individual needs.

     This means that you can set a default SLA for most users, giving them say only 4 calls per second, but for silver partners they get 10 calls per second, for gold partners 100 calls per second, etc.

     This means that you can not only identify abuse quickly, but also help prevent it by limiting their access to certain aspects of your API, and by limiting the number of calls they can make to your API.

    # Throttling Isn't Bad
    Throttling and rate limiting isn't a bad thing.

     Again, by throttling your API and setting up different SLA tiers you are able to help prevent abuse – often times completely accidental.

     This means that your API is able to operate optimally for all of your users, instead of having one infinite loop bring it crashing down for everyone.
    And yes, you may have partners that need more calls than others, or who the limits do not make sense for.

      But again, by setting up SLA tiers based on your standard API user's needs, and then creating partner tiers, you can easily give the the permissions they need, while limiting the standard user to prevent abuse.
    The API key, or unique identifier for an user's application also helps you identify who your heavier users are – letting you get in contact with them to make sure their needs are being met, while also learning more about how they are using your API.
    # Tools

    The demand for flexibility and extensibility has driven the development of APIs and tools alike, and in many regards it has never been easier to create an API than it is today with multitudes of frameworks (such as JAX-RS, Apigility, Django REST Framework, Grape), specs (RAML, Swagger, API Blueprint, IO Docs), and tools (API Designer, API Science, APImatic) available.

    # Building an SDK Doesn't Fix Everything

    Last but not least, keep in mind that SDKs or code wrappers/ libraries can be extremely helpful.

     However, if you are building a full out SDK instead of a language wrapper that utilizes the hypermedia to handle responses, remember that you are adding a whole new layer of complexity to your API ecosystem – that you will have to maintain.
    What SDKs/ Code Wrappers offer is a quick, plug and play way for developers to incorporate your API, while also (hopefully) handling error checks/ responses.

     The downside is the more complex your SDK becomes, the more tightly coupled it usually is to your API, making any updates to your API a manual and complex process.

     This means that any new features you roll out will receive rather slow adoption, and you may find yourself providing support to your developers on why they can't do something with your SDK.
    When building your SDK you should try to keep it as decoupled from your API as possible, relying on dynamic responses and calls while also following the best coding practices for that language (be sure to watch Keith Casey's SPOIL talk or read about it here).
    Another option is to utilize a SDK building service such as APIMatic.io or REST United, which automatically generates SDKs for your API based on your RAML, Swagger, or API Blueprint spec.

     This allows you to offer SDKs, automatically have them update when adding new features (although clients will still need to download the updated version), and offer them without adding any additional workload on your end.
    But again, regardless of whether or not you provide an SDK/ Code Library, you will still want to have multiple code examples in your documentation to help developers who want to utilize your API to its fullest capacity, without relying on additional third party libraries to do so.
    To recap, use HTTP Status Codes, use Descriptive Error Messages, and having an SDK may be helpful for a lot of your developers – but make sure you take into consideration all of the challenges that come with it, and remember that having an SDK doesn't replace documentation, if anything – it creates the need for more.

    # Deprecation

    Sometimes it is necessary to phase out an API endpoint (or version). I.e. this may be necessary if a field is no longer supported in the result or a whole business functionality behind an endpoint has to be shut down. There are many other reasons as well.

    ### MUST: Obtain Approval of Clients

    Before shutting down an API (or version of an API) the producer must make sure, that all clients have given their consent to shut down the endpoint. Producers should help consumers to migrate to a potential new endpoint (i.e. by providing a migration manual). After all clients are migrated, the producer may shut down the deprecated API.

    ### MUST: External Partners Must Agree on Deprecation Timespan

    If the API is consumed by any external partner, the producer must define a reasonable timespan that the API will be maintained after the producer has announced deprecation. The external partner (client) must agree to this minimum after-deprecation-lifespan before he starts using the API.

    ### MUST: Reflect Deprecation in API Definition

    API deprecation must be part of the OpenAPI definition. If a method on a path, a whole path or even a whole API endpoint (multiple paths) should be deprecated, the producers must set deprecated=true on each method / path element that will be deprecated (OpenAPI 2.0 only allows you to define deprecation on this level). If deprecation should happen on a more fine grained level (i.e. query parameter, payload etc.), the producer should set deprecated=true on the affected method / path element and add further explanation to the description section.

    If deprecated is set to true, the producer must describe what clients should use instead and when the API will be shut down in the description section of the API definition.

    ### MUST: Monitor Usage of Deprecated APIs

    Owners of APIs used in production must monitor usage of deprecated APIs until the API can be shut down in order to align deprecation and avoid uncontrolled breaking effects. See also the general rule on API usage monitoring

    ### SHOULD:: Add a Warning Header to Responses

    During deprecation phase, the producer should add a Warning header (see RFC 7234 - Warning header) field. When adding the Warning header, the warn-code must be 299 and the warn-text should be in form of "The path/operation/parameter/... {name} is deprecated and will be removed by {date}. Please see {link} for details." with a link to a documentation describing why the API is no longer supported in the current form and what clients should do about it. Adding the Warning header is not sufficient to gain client consent to shut down an API.

    ### SHOULD:: Add Monitoring for Warning Header

    Clients should monitor the Warning header in HTTP responses to see if an API will be deprecated in future.

    ### MUST: Not Start Using Deprecated APIs

    Clients must not start using deprecated parts of an API.

    # API Operation

    ### MUST: Provide Online Access to OpenAPI Reference Definition

    ### SHOULD:: Monitor API Usage

    Owners of APIs used in production should monitor API service to get information about its using clients. This information, for instance, is useful to identify potential review partner for API changes.

    Hint: A preferred way of client detection implementation is by logging of the client-id retrieved from the OAuth token.

    ## Organizing APIs

    ## Consolidate API requests in one subdomain

    We've talked about things that come after the top-level domain. This time, let's explore stuff on the other side of the URL.

    Here's how Facebook, Foursquare, and Twitter handle this:

    Facebook provides two APIs. They started with api.facebook.com, then modified it to orient around the social graph graph.facebook.com.

    - graph.facebook.com
    - api.facebook.com

    Foursquare has one API.

    - api.foursquare.com

    Twitter has three APIs; two of them focused on search and streaming.

    - stream.twitter.com
    - api.twitter.com
    - search.twitter.com

    It's easy to understand how Facebook and Twitter ended up with more than one API. It has a lot to do with timing and acquisition, and it's easy to reconfigure a CName entry in your DNS to point requests to different clusters.

    But if we're making design decisions about what's in the best interest of app developer, we recommend following Foursquare's lead:

    Consolidate all API requests under one API subdomain.

    It's cleaner, easier and more intuitive for developers who you want to build cool apps using your API.

    Facebook, Foursquare, and Twitter also all have dedicated developer portals.

    - developers.facebook.com
    - developers.foursquare.com
    - dev.twitter.com

    ### How to organize all of this?

    Your API gateway should be the top-level domain. For example, api.teachdogrest.com

    In keeping with the spirit of REST, your developer portal should follow this pattern: developers.yourtopleveldomain.

    ### Do Web redirects

    Then optionally, if you can sense from requests coming in from the browser where the developer really needs to go, you can redirect.

    Say a developer types api.teachdogrest.com in the browser but there's no other information for the GET request, you can probably safely redirect to your developer portal and help get the developer where they really need to be.

