## Other Topics

    <!-- TODO -->

    dog-food your own API

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
