## Resources

A *resource* is an abstract entity that is identified by a URI, and can be data, processing logic, files, or anything else that a service may have access to.

### Identifying and Naming Resources

Most often when identifying resources, the use of nouns instead of verbs will be obvious, however, sometimes it is necessary to veer from this naming convention, when exposing certain services through the public API.

Care should be taking when identifying resources and finding the right resource granularity:

- **DO** use network efficiency, size of representations, and client convenience to guide resource granularity.
- **DO** analyze use cases to find domain nouns that can be operated using *create*, *read*, *update*, or *delete* operations. Designate each noun as a resource. Use `POST`, `GET`, `PUT`, or `DELETE` operations respectively, on each resource.
- **DO** design resources to suit client's usage patterns and not design them based on what exists in a database or the object model. (Think from the client's perspective)
- **DO** pluralize resource names for collections resources. To keep things simple, pragmatic and consistent always use plural to avoid odd pluralization (person/people).
- **DO** think about frequency of change and cacheability. Try to separate immutable (less frequently changing) resources from less cacheable resources.
- **DO NOT** blindly apply the same techniques for identifying resources, as for object-oriented design and database modeling.
- **DO NOT** bluntly map domain entities into resources, as this may lead to resources that are inefficient and inconvenient to use and also leak irrelevant implementation details out to your public API.
- **DO NOT** limit yourself to identifying resources based on domain nouns alone, you are likely to find that the fixed set of methods in HTTP is quite a limitation. *Using a root-level "Me" endpoint is perfectly valid.*

<!-- TODO -->

    ## Nouns are good; verbs are bad

    The number one principle in pragmatic RESTful design is: keep simple things simple.

    Keep your base URL simple and intuitive

    The base URL is the most important design affordance of your API. A simple and intuitive base URL design makes using your API easy.

    Affordance is a design property that communicates how something should be used without requiring documentation. A door handle's design should communicate whether you pull or push. Here's an example of a conflict between design affordance and documentation - not an intuitive interface!

    A key litmus test we use for Web API design is that there should be only 2 base URLs per resource. Let's model an API around a simple object or resource, a dog, and create a Web API for it.

    The first URL is for a collection; the second is for a specific element in the collection.

    /dogs /dogs/1234

    Boiling it down to this level will also force the verbs out of your base URLs.

    Keep verbs out of your base URLs

    Many Web APIs start by using a method-driven approach to URL design. These method-based URLs sometimes contain verbs - sometimes at the beginning, sometimes at the end.

    For any resource that you model, like our dog, you can never consider one object in isolation. Rather, there are always related and interacting resources to account for - like owners, veterinarians, leashes, food, squirrels, and so on.

    Think about the method calls required to address all the objects in the dogs' world. The URLs for our resource might end up looking something like this.

    It's a slippery slope - soon you have a long list of URLs and no consistent pattern making it difficult for developers to learn how to use your API.

    Use HTTP verbs to operate on the collections and elements.

    For our dog resources, we have two base URLs that use nouns as labels, and we can operate on them with HTTP verbs. Our HTTP verbs are POST, GET, PUT, and DELETE. (We think of them as mapping to the acronym, CRUD (Create-Read-Update-Delete).)

    With our two resources (/dogs and /dogs/1234) and the four HTTP verbs, we have a rich set of capability that's intuitive to the developer. Here is a chart that shows what we mean for our dogs.


    The point is that developers probably don't need the chart to understand how the API behaves. They can experiment with and learn the API without the documentation.

    In summary:

    - Use two base URLs per resource.
    - Keep verbs out of your base URLs.
    - Use HTTP verbs to operate on the collections and elements.

    ## Plural nouns and concrete names

    Let's explore how to pick the nouns for your URLs.

    Should you choose singular or plural nouns for your resource names? You'll see popular APIs use both. Let's look at a few examples:

    Foursquare GroupOn Zappos

    /checkins /deals /Product

    Given that the first thing most people probably do with a RESTful API is a GET, we think it reads more easily and is more intuitive to use plural nouns. But above all, avoid a mixed model in which you use singular for some resources, plural for others. Being consistent allows developers to predict and guess the method calls as they learn to work with your API.

    ## Concrete names are better than abstract

    Achieving pure abstraction is sometimes a goal of API architects. However, that abstraction is not always meaningful for developers.

    Take for example an API that accesses content in various forms - blogs, videos, news articles, and so on.

    An API that models everything at the highest level of abstraction - as /items or /assets in our example - loses the opportunity to paint a tangible picture for developers to know what they can do with this API. It is more compelling and useful to see the resources listed as blogs, videos, and news articles.

    The level of abstraction depends on your scenario. You also want to expose a manageable number of resources. Aim for concrete naming and to keep the number of resources between 12 and 24.

    In summary, an intuitive API uses plural rather than singular nouns, and concrete rather than abstract names.

    ### SHOULD:: Define useful resources

    As a rule of thumb resources should be defined to cover 90% of all its client's use cases. A useful resource should contain as much information as necessary, but as little as possible. A great way to support the last 10% is to allow clients to specify their needs for more/less information by supporting filtering and embedding.

    ### MUST: Use Domain-Specific Resource Names

    API resources represent elements of the application's domain model. Using domain-specific nomenclature for resource names helps developers to understand the functionality and basic semantics of your resources. It also reduces the need for further documentation outside the API definition.
    
    ### SHOULD:: Limit number of Resources

    To keep maintenance and service evolution manageable, we should follow "functional segmentation" and "separation of concern" design principles and do not mix different business functionalities in same API definition.
    
    In this sense the number of resources exposed via API should be limited - our experience is that a typical range of resources for a well-designed API is between 4 and 8.
    
    There may be exceptions with more complex business domains that require more resources, but you should first check if you can split them into separate subdomains with distinct APIs.

    Nevertheless one API should hold all necessary resources to model complete business processes helping clients to understand these flows.

    ### SHOULD:: Model complete business processes

    An API should contain the complete business processes containing all resources representing the process. This enables clients to understand the business process, foster a consistent design of the business process, allow for synergies from description and implementation perspective, and eliminates implicit invisible dependencies between APIs.

    In addition, it prevents services from being designed as thin wrappers around databases, which normally tends to shift business logic to the clients.

    ## Simplify associations - sweep complexity under the '?'

    In this section, we explore API design considerations when handling associations between resources and parameters like states and attributes.

    ### Associations

    Resources almost always have relationships to other resources. What's a simple way to express these relationships in a Web API?

    Let's look again at the API we modeled in nouns are good, verbs are bad - the API that interacts with our dogs resource. Remember, we had two base URLs: /dogs and dogs/1234.

    We're using HTTP verbs to operate on the resources and collections. Our dogs belong to owners. To get all the dogs belonging to a specific owner, or to create a new dog for that owner, do a GET or a POST:

    GET /owners/5678/dogs

    POST /owners/5678/dogs

    Now, the relationships can be complex. Owners have relationships with veterinarians, who have relationships with dogs, who have relationships with food, and so on. It's not uncommon to see people string these together making a URL 5 or 6 levels deep. Remember that once you have the primary key for one level, you usually don't need to include the levels above because you've already got your specific object. In other words, you shouldn't need too many cases where a URL is deeper than what we have above /resource/identifier/resource.

    ### Sweep complexity behind the '?'

    Most APIs have intricacies beyond the base level of a resource. Complexities can include many states that can be updated, changed, queried, as well as the attributes associated with a resource.

    Make it simple for developers to use the base URL by putting optional states and attributes behind the HTTP question mark. To get all red dogs running in the park:

    GET /dogs?color=red&state=running&location=park

    In summary, keep your API intuitive by simplifying the associations between resources, and sweeping parameters and other complexities under the rug of the HTTP question mark.


### Collection Resources

Collection resources can give the ability to refer to a group of a resources as one, to perform queries on the collection, or use the collection as a factory to create new resources.

> A collection does not necessarily imply hierarchical containment. A resource may be part of more than one collection resource.

When organizing resources into collections:

    Note: GET requests on collection resources should provide a sufficient filter mechanism as well as pagination.

- **DO** provide a way of searching the collection for it members, if applicable.
- **DO** provide a filtered view of the collection, if applicable.
- **DO** provide a paginated view of a collection, when appropriate.
- **DO** embed commonly requested relations alongside the resource, for client convenience.
- **DO** organize resources according to relationship (`GET /bookings/1/departures/2`), if a relation can only exist within another resource.
- **CONSIDER** providing a link, if a relation can exist independently of the resource. However, if the relation is commonly requested it might be better to always embed the relation's representation, or perhaps offer a functionality to automatically embed the relation's representation and save the client a second round-trip (`GET /bookings?embed=departures,vehicles`).

    ### MAY: Consider Using (Non-) Nested URLs

    If a sub-resource is only accessible via its parent resource and may not exists without parent resource, consider using a nested URL structure, for instance:

    /carts/1681e6b88ec1/cart-items/1
    However, if the resource can be accessed directly via its unique id, then the API should expose it as a top-level resource. For example, customer is a collection for sales orders; however, sales orders have globally unique id and some services may choose to access the orders directly, for instance:

    /customers/1681e6b88ec1
    /sales-orders/5273gh3k525a


    ### MUST: Identify resources and Sub-Resources via Path Segments

    Some API resources may contain or reference sub-resources. Embedded sub-resources, which are not top-level resources, are parts of a higher-level resource and cannot be used outside of its scope. Sub-resources should be referenced by their name and identifier in the path segments.

    Composite identifiers must not contain "/" as a separator. In order to improve the consumer experience, you should aim for intuitively understandable URLs, where each sub-path is a valid reference to a resource or a set of resources. For example, if "/customers/12ev123bv12v/addresses/DE_100100101" is a valid path of your API, then "/customers/12ev123bv12v/addresses", "/customers/12ev123bv12v" and "/customers" must be valid as well in principle.

    Basic URL structure:

    /{resources}/[resource-id]/{sub-resources}/[sub-resource-id]
    /{resources}/[partial-id-1][separator][partial-id-2]
    Examples:

    /carts/1681e6b88ec1/items
    /carts/1681e6b88ec1/items/1
    /customers/12ev123bv12v/addresses/DE_100100101

    ### SHOULD:: Limit number of Sub-Resource Levels

    There are main resources (with root url paths) and sub-resources (or "nested" resources with non-root urls paths). Use sub-resources if their life cycle is (loosely) coupled to the main resource, i.e. the main resource works as collection resource of the subresource entities. You should use <= 3 sub-resource (nesting) levels -- more levels increase API complexity and url path length. (Remember, some popular web browsers do not support URLs of more than 2000 characters)

### Composite Resources

At times it may prove convenient to identify new composite resources.

- **DO** identify new resources that aggregate other resources to reduce the number of client/server round-trips, based on client usage patterns, performance, and latency requirements.
- **CONSIDER** a snapshot page to summarize information, using an URI of the form `http://www.example.org/customer/1234/snapshot`.
- **CONSIDER**, if requests for composites are rare, or if network latency is an issue, whether caching may be a better option.

### Processing Function

Use processing functions to abstract specific services through the public API that allows clients to perform tasks such computation or data validation.

- **DO** treat the processing function as a resource
- **DO** use `GET` to fetch a representation containing the output of the processing function.
- **DO** use query parameters to supply inputs to the processing function.
- **DO** treating the processing function as a resource, as most often it will be difficult to find appropriate nouns. So when validating a vehicle registration number: `http://www.example.org/vehicles/validate?regnum=ZY12345`

    ## What about responses that don't involve resources?

    API calls that send a response that's not a resource per se are not uncommon depending on the domain. We've seen it in financial services, Telco, and the automotive domain to some extent.

    Actions like the following are your clue that you might not be dealing with a "resource" response.

    - Calculate
    - Translate
    - Convert

    For example, you want to make a simple algorithmic calculation like how much tax someone should pay, or do a natural language translation (one language in request; another in response), or convert one currency to another. None involve resources returned from a database.

    In these cases:

    Use verbs not nouns

    For example, an API to convert 100 euros to Chinese Yen:

    /convert?from=EUR&to=CNY&amount=100

    Make it clear in your API documentation that these "non-resource" scenarios are different.

    Simply separate out a section of documentation that makes it clear that you use verbs in cases like this – where some action is taken to generate or calculate the response, rather than returning a resource directly.

### Controller Resources

A *controller* is a resource that can atomically make changes to resources. It can help abstract complex business operations, which increase the separation of concerns and reduces coupling between clients and servers, which in turn may improve network efficiency.

- **DO** designate a controller resource for each distinct operation.
- **DO** use `POST` to submit a request to trigger the operation.
- **DO**, if the output of the operation is the creation of a new resource, return `201 Created` with a `Location` header referring to the URI of the newly created resource.
- **DO**, if the outcome is the modification of one or more existing resource, return `303 See Other` with a `Location` to a URI that clients can use to fetch a representation of those modifications.
- **DO**, if the server cannot provide a single URI to all the modified resources, return `200 OK` with a representation in the body that clients can use to learn about the outcome.
- **DO** handle errors as described in [Errors](#errors)
- **AVOID** tunneling at all costs. Instead, use a distinct resource (such as a controller) for each operation. Tunneling occurs whenever the client is using the same method on a single URI for different actions. Tunneling reduces protocol-level visibility, because the visible parts of requests such as the request URI, the HTTP method used, headers, and media types do not unambiguously describe the operation.
