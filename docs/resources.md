## Resources

A *resource* is an abstract entity that is identified by a URI, and can be data, processing logic, files, or anything else that a service may have access to.

    ## Resources

    ### MUST: Avoid Actions — Think About Resources

    REST is all about your resources, so consider the domain entities that take part in web service interaction, and aim to model your API around these using the standard HTTP methods as operation indicators. For instance, if an application has to lock articles explicitly so that only one user may edit them, create an article lock with PUT or POST instead of using a lock action.

    Request:

    PUT /article-locks/{article-id}

    The added benefit is that you already have a service for browsing and filtering article locks.

    ### SHOULD:: Model complete business processes

    An API should contain the complete business processes containing all resources representing the process. This enables clients to understand the business process, foster a consistent design of the business process, allow for synergies from description and implementation perspective, and eliminates implicit invisible dependencies between APIs.

    In addition, it prevents services from being designed as thin wrappers around databases, which normally tends to shift business logic to the clients.

    ### SHOULD:: Define useful resources

    As a rule of thumb resources should be defined to cover 90% of all its client's use cases. A useful resource should contain as much information as necessary, but as little as possible. A great way to support the last 10% is to allow clients to specify their needs for more/less information by supporting filtering and embedding.

    ### MUST: Keep URLs Verb-Free

    The API describes resources, so the only place where actions should appear is in the HTTP methods. In URLs, use only nouns. Instead of thinking of actions (verbs), it's often helpful to think about putting a message in a letter box: e.g., instead of having the verb cancel in the URL, think of sending a message to cancel an order to the cancellations letter box on the server side.

    ### MUST: Use Domain-Specific Resource Names

    API resources represent elements of the application's domain model. Using domain-specific nomenclature for resource names helps developers to understand the functionality and basic semantics of your resources. It also reduces the need for further documentation outside the API definition. For example, "sales-order-items" is superior to "order-items" in that it clearly indicates which business object it represents. Along these lines, "items" is too general.

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

    ### MAY: Consider Using (Non-) Nested URLs

    If a sub-resource is only accessible via its parent resource and may not exists without parent resource, consider using a nested URL structure, for instance:

    /carts/1681e6b88ec1/cart-items/1
    However, if the resource can be accessed directly via its unique id, then the API should expose it as a top-level resource. For example, customer is a collection for sales orders; however, sales orders have globally unique id and some services may choose to access the orders directly, for instance:

    /customers/1681e6b88ec1
    /sales-orders/5273gh3k525a

    ### SHOULD:: Limit number of Resources

    To keep maintenance and service evolution manageable, we should follow "functional segmentation" and "separation of concern" design principles and do not mix different business functionalities in same API definition. In this sense the number of resources exposed via API should be limited - our experience is that a typical range of resources for a well-designed API is between 4 and 8. There may be exceptions with more complex business domains that require more resources, but you should first check if you can split them into separate subdomains with distinct APIs.

    Nevertheless one API should hold all necessary resources to model complete business processes helping clients to understand these flows.

    ### SHOULD:: Limit number of Sub-Resource Levels

    There are main resources (with root url paths) and sub-resources (or "nested" resources with non-root urls paths). Use sub-resources if their life cycle is (loosely) coupled to the main resource, i.e. the main resource works as collection resource of the subresource entities. You should use <= 3 sub-resource (nesting) levels -- more levels increase API complexity and url path length. (Remember, some popular web browsers do not support URLs of more than 2000 characters)

### Identifying and Naming Resources

Most often when identifying resources, the use of nouns instead of verbs will be obvious, however, sometimes it is necessary to veer from this naming convention, when exposing certain services through the public API.

Care should be taking when identifying resources and finding the right resource granularity:

- **DO** use network efficiency, size of representations, and client convenience to guide resource granularity.
- **DO** analyze use cases to find domain nouns that can be operated using *create*, *read*, *update*, or *delete* operations. Designate each noun as a resource. Use `POST`, `GET`, `PUT`, or `DELETE` operations respectively, on each resource.
- **DO** design resources to suit client's usage patterns and not design them based on what exists in a database or the object model. (Think from the client's perspective)
- **DO** pluralize resource names for collections resources. To keep things simple, pragmatic and consistent always use plural to avoid odd pluralization (person/people).
- **DO** think about frequency of change and cacheability. Try to separate immutable (less frequently changing) resources from less cacheable resources.
- **DO NOT** blindly apply the same techniques for identifying resources, as for object-oriented design and database modeling.
- **DO NOT** bluntly map domain entities into resources, as this may lead to resources that a inefficient and inconvenient to use and also leak irrelevant implementation details out to your public API.
- **DO NOT** limit yourself to identifying resources based on domain nouns alone, you are likely to find that the fixed set of methods in HTTP is quite a limitation. *Using a root-level "Me" endpoint is perfectly valid.*

### Collection Resources

Collection resources can give the ability to refer to a group of a resources as one, to perform queries on the collection, or use the collection as a factory to create new resources.

> A collection does not necessarily imply hierarchical containment. A resource may be part of more than one collection resource.

When organizing resources into collections:

- **DO** provide a way of searching the collection for it members, if applicable.
- **DO** provide a filtered view of the collection, if applicable.
- **DO** provide a paginated view of a collection, when appropriate.
- **DO** embed commonly requested relations alongside the resource, for client convenience.
- **DO** organize resources according to relationship (`GET /bookings/1/departures/2`), if a relation can only exist within another resource.
- **CONSIDER** providing a link, if a relation can exist independently of the resource. However, if the relation is commonly requested it might be better to always embed the relation's representation, or perhaps offer a functionality to automatically embed the relation's representation and save the client a second round-trip (`GET /bookings?embed=departures,vehicles`).

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

### Controller Resources

A *controller* is a resource that can atomically make changes to resources. It can help abstract complex business operations, which increase the separation of concerns and reduces coupling between clients and servers, which in turn may improve network efficiency.

- **DO** designate a controller resource for each distinct operation.
- **DO** use `POST` to submit a request to trigger the operation.
- **DO**, if the output of the operation is the creation of a new resource, return `201 Created` with a `Location` header referring to the URI of the newly created resource.
- **DO**, if the outcome is the modification of one or more existing resource, return `303 See Other` with a `Location` to a URI that clients can use to fetch a representation of those modifications.
- **DO**, if the server cannot provide a single URI to all the modified resources, return `200 OK` with a representation in the body that clients can use to learn about the outcome.
- **DO** handle errors as described in [Errors](#errors)
- **AVOID** tunneling at all costs. Instead, use a distinct resource (such as a controller) for each operation. Tunneling occurs whenever the client is using the same method on a single URI for different actions. Tunneling reduces protocol-level visibility, because the visible parts of requests such as the request URI, the HTTP method used, headers, and media types do not unambiguously describe the operation.
