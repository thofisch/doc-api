## HTTP as the Uniform Interface

Before diving into the specific areas of designing a RESTful API, it is important to recognize that one of the key goals of the REST architecture is to maintain visibility. This will let the API benefit from existing software and infrastructure for features that would otherwise have to built as well.

HTTP is an application-level protocol that is designed to keep interactions between clients and servers visible. HTTP defines operations (along with, e.g., headers), such as `GET`, `POST`, `PUT` and `DELETE`, for transferring representations between clients and servers, eliminating the need for application-specific operations (e.g. *createBooking*, *changeBooking*, etc.). This means that caches, proxies, firewalls, etc., can monitor and participate in the protocol.

> Visibility means that one component of an architecture can monitor (and even participate in) the interaction between other components of the same architecture

For better visibility:

- **DO** make interactions stateless.
- **DO** use HTTP methods.
- **DO** use appropriate headers to describe requests and responses.
- **DO** use appropriate status codes and messages.
- **DO NOT** change syntax and meaning, specified by HTTP, from application to application or from resource to resource.

Keep in mind that focusing solely on visibility may create too fine-grained resources and poor separation of concern between clients and servers. Trading visibility for other benefits is not necessarily bad.

Consider trading visibility:

- when multiple resources share data
- when operations modifies multiple resources
- for better abstraction and loose coupling
- for network efficiency
- for better resource granularity
- or simply for pure client convenience
