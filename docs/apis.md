# Application Programming Interfaces

An API specifies how software should interact. Particularly, how a client can use an API, what URIs are available, what HTTP methods may be used, what query string parameters it accepts, what data can be sent, and what responses to expect.

## API as a Product

When creating APIs intended for use by someone else, whether it is actually sold or not, it can and should most likely be treated as a product in itself.

This can be very easy to lose sight of, so before jumping to the more specific advice on how to achieve successful APIs, keep the following overall principles in mind:

## Be Customer-Centric

Do not focus on data rather than customers. Instead focus on target developer's problems, by involving customers early in the design process. Make use of reviews and customers feedback, and provide service level support. Make APIs irresistible by having a high attention to API quality and client developer experience.

![API as a Product](./imgs/api-as-a-product-750-3-v4.png)

## Treat Every API as if it was a Public API

Do not skip on usability and security when creating private or partner APIs, as this can make the transition into a public API difficult. Instead actively improve and maintain API consistency over the long term.

## Componentize Your Systems

Identifying, breaking apart, and isolating small feature sets in big systems:

- can help innovation by creating platforms to enable other organizations to build new applications that better suit their needs
- offers a higher degree of composability, which makes it possible to offer products as open systems instead of inflexible off-the-shelf solutions
- may help monetize existing assets