## Mocking

Mock Your API and get User Feedback

Another huge advantage of tools like RAML or Swagger is that they allow you to mock your API.

This means that you can not only build your API in a visual interface and take advantage of the very same best practices we utilize in development, but you can also share a mock version of your API with potential clients.
Using MuleSoft's API Designer you can easily turn on a mocking service that gives you a URL that can be shared with other developers.

This allows your clients to "test out" your API by making real calls as if they would from their application.

By utilizing the example responses defined in the RAML file developers can quickly identify issues and inconsistencies, helping you eliminate the majority of design related issues before development even starts.

And by passing along tools like the API Notebook, developers can interact with your Mock API through JavaScript without having to code any calls themselves, and also having the ability to send you the specific use case back giving you true examples of what your developers are trying to accomplish.

This process can be repeated as necessary, as modifying the spec and creating a new mock only takes minutes, empowering you to perfect the design of your API and ensure that it not only meets your developers' needs, but also provides a solid, strong foundation for the future of your API.
After all, the nemesis of a long-lived API is not the code, nor the system architecture, but the API design itself.

No matter how careful you are with your API, without a solid foundation it will crumble quickly, costing you thousands to hundreds of thousands of dollars down the road.

It's better to take the time now, up front and ensure that your API is well designed.

---

- testing api’s
- automated in-memory integration tests (with live dependencies stubed out)
- Implement a “Health-Check” Endpoint

---

#### Simulation

* Basically every software system has dependencies to other software,
* The consequence is sequential development of the components,
* Simulations offer a solution: they make it possible to break up the dependencies between software components and allow for integration and development of software components, even though their dependencies have not been developed, yet.
* Dependencies are replaced by simulations.
* In API design there are two use cases for simulations:
    * The simulation of backend systems allows for developing APIs without fully implemented backend systems. If the real backend is not available yet, a simulation of the backend can be used in its place.
    * The simulation of APIs allows for developing apps (or other API solutions) without fully implemented APIs.
    * Both types of simulations have their place in API design - but in different scenarios.
* The development of the API and the development of the mobile app can take place in parallel. The simulation speeds up the development time of the overall API solution,
* Simulation-based design of APIs and the contract-first design for APIs actually go hand-in-hand. The contract for the API can be used as a specification for the simulation.
* Applying ideas of the simulation approach allows for breaking up the dependencies during development. It allows for an independent development of client and API, despite the dependencies between them.