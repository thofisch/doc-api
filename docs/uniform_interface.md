## HTTP as the Uniform Interface

When designing a RESTful API delivered over HTTP, it is important to maintain a high degree of visibility. This will let the API benefit from existing software and infrastructure for features that you would otherwise have to build yourself.

> Visibility means that one component of an architecture can monitor (and even participate in) the interaction between other components of the same architecture

Luckily HTTP is an application-level protocol designed to keep communication between clients and servers visible.

HTTP defines operations for transferring representations between clients and servers, eliminating the need for application-specific operations (e.g. *createBooking*, *changeBooking*, etc.). Using the capabilities of HTTP means that caches, proxies, firewalls, etc., can monitor and participate in the protocol.

For better visibility:

- **DO** make interactions stateless.
- **DO** use HTTP methods.
- **DO** use appropriate headers to describe requests and responses.
- **DO** use appropriate status codes and messages.
- **DO NOT** change syntax and meaning, specified by HTTP, from application to application nor from resource to resource.

Keep in mind that focusing solely on visibility may create too fine-grained resources and poor separation of concern between clients and servers. Trading visibility for other benefits is not necessarily bad.

Consider trading visibility:

- when multiple resources share data
- when operations modifies multiple resources
- for better abstraction and loose coupling
- for network efficiency
- for better resource granularity
- or simply for pure client convenience
