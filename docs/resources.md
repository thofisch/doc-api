## Resources

A *resource* is an abstract entity that is identified by a URI, and can be data, processing logic, files, or basically anything else that can be named.

## Identifying and Naming Resources

Most often when identifying resources, the use of nouns instead of verbs will be obvious, however, sometimes it is necessary to veer from this naming convention, when exposing certain services through the public API.

There is no single approach that will work for all the situations, so care should be taking when identifying resources and finding the right resource granularity, in order for API consumers to get the desired functionality, the API to behave correctly, and for maintainability.

!!! note
    Taking business needs, maintainability, extensibility, and perhaps some sort of cost-benefit analysis or ROI, into consideration may be pertinent.

In order to identify and name resources:

- **DO** analyze use cases to find domain nouns that can be operated using *create*, *read*, *update*, or *delete* operations. Designate each noun as a resource. Use `POST`, `GET`, `PUT`, or `DELETE` operations respectively, on each resource.
- **DO** design resources to suit client's usage patterns and not design them based on what exists in a database or the object model. (Think from the client's perspective)
- **DO** use network efficiency, size of representations, and client convenience to guide resource granularity.
- **DO** think about frequency of change and cacheability. Try to separate immutable (less frequently changing) resources from less cacheable resources.
- **CONSIDER** keeping verbs out of your URIs, instead HTTP verbs to operate on them.
- **CONSIDER** blindly apply the same techniques for identifying resources, as for object-oriented design and database modeling.
- **CONSIDER** bluntly map domain entities into resources, as this may lead to resources that are inefficient and inconvenient to use and also leak irrelevant implementation details out to your public API.
- **CONSIDER** the level of abstraction, as it is not always meaningful for developers, if the information conveyed in URIs are too abstract. 
- **CONSIDER** limiting the number of resources to between _**(4/12)**_ and _**(8/24)**_ to keep maintenance and service evolution manageable. Avoid mixing different business functionalities in same API.
- **DO NOT** limit yourself to identifying resources based on domain nouns alone, you are likely to find that the fixed set of methods in HTTP is quite a limitation. *E.g., using a root-level "Me" endpoint is perfectly valid.*

### Collection Resources

Resources almost always have relationships to other resources, and *collection resources* can give the ability to refer to a group of a resources as one, to perform queries on the collection, or use the collection as a factory to create new resources.

!!! tip
    A collection resource does not necessarily imply hierarchical containment. A resource may be part of more than one collection resource.

A collection resources should provide sufficient filter mechanisms, as well as pagination. So when organizing resources into collections:

- **DO** pluralizing collection resource names. To keep things simple, pragmatic and consistent always use plural to avoid odd pluralization (person/people). Using a mixed model, in which you use singular for some resources and plural for others will make it harder for developers reason about the API.
- **DO** provide a way of searching the collection for it members, if applicable.
- **DO** provide a filtered view of the collection, if applicable.
- **DO** provide a paginated view of a collection, when appropriate.
- **DO** embed commonly requested relations alongside the resource, for client convenience.
- **DO** organize resources according to relationship using path segments (`/`), if a relation can only exist within another resource. Sub-resources should be referenced by their name and identifier in the path segments: `/{resource}/{resource_id}/{sub_resource}/{sub_resource_id}`.
- **CONSIDER** providing a link, if a relation can exist independently of the resource. However, if the relation is commonly requested it might be better to always embed the relation's representation, or perhaps offer a functionality to automatically embed the relation's representation and save the client a second round-trip (`GET /bookings?embed=departures,vehicles`).
- **AVOID** sub-sub-resource levels, etc. Try to simplify the association between resources.

### Composite Resources

At times it may prove convenient to identify new composite resources.

- **DO** identify new resources that aggregate other resources to reduce the number of client/server round-trips, based on client usage patterns, performance, and latency requirements.
- **CONSIDER** a snapshot page to summarize information, using an URI of the form `http://www.example.org/customer/1234/snapshot`.
- **CONSIDER**, if requests for composites are rare, or if network latency is an issue, whether caching may be a better option.

### Processing Functions

Having the public API expose means to support business processes, like, calculate, translate, and convert, is not uncommon depending on the domain. These may often not map well to nouns in our domain, but usually are in the form of verbs. By using processing functions to abstract specific services the clients is able to perform tasks such computation or data validation.

- **DO** treat the processing function as a resourcee, as most often it will be difficult to find appropriate nouns. So when validating a vehicle registration number: `http://www.example.org/vehicles/validate?regnum=ZY12345`
- **DO** use `GET` to fetch a representation containing the output of the processing function.
- **DO** use query parameters to supply inputs to the processing function.
- **DO** document these resources, and make use verbs clear.

### Controller Resources

A *controller* is a resource that can atomically make changes to resources. It can help abstract complex business operations, which increase the separation of concerns and reduces coupling between clients and servers, which in turn may improve network efficiency.

- **DO** designate a controller resource for each distinct operation.
- **DO** use `POST` to submit a request to trigger the operation.
- **DO**, if the output of the operation is the creation of a new resource, return `201 Created` with a `Location` header referring to the URI of the newly created resource.
- **DO**, if the outcome is the modification of one or more existing resource, return `303 See Other` with a `Location` to a URI that clients can use to fetch a representation of those modifications.
- **DO**, if the server cannot provide a single URI to all the modified resources, return `200 OK` with a representation in the body that clients can use to learn about the outcome.
- **DO** handle errors as described in [Errors](representations/#error-representations)
- **AVOID** tunneling at all costs. Instead, use a distinct resource (such as a controller) for each operation. Tunneling occurs whenever the client is using the same method on a single URI for different actions. Tunneling reduces protocol-level visibility, because the visible parts of requests such as the request URI, the HTTP method used, headers, and media types do not unambiguously describe the operation.
