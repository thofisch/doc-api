
# Tools

    The demand for flexibility and extensibility has driven the development of APIs and tools alike, and in many regards it has never been easier to create an API than it is today with multitudes of frameworks (such as JAX-RS, Apigility, Django REST Framework, Grape), specs (RAML, Swagger, API Blueprint, IO Docs), and tools (API Designer, API Science, APImatic) available.

# API intro

And while many of these tools are designed to encourage best practices, API design seems to be constantly overlooked for development efficiency.

The problem is, however, that while this lack of focus on best practices provides for a rapid development framework, it is nothing more than building a house without a solid foundation. 

No matter how quickly you build the house, or how nice it looks, without a solid foundation it is just a matter of time before the house crumbles to the ground, costing you more time, energy, and resources then it would have to simply build it right the first time.

The good news is that by following best practices, and carefully implementing these standards, while you may increase development time by weeks, you can shave off months to years of development headaches and potentially save thousands to hundreds of thousands of dollars.

# Understand WHY you are building an API

Perhaps the foundation of the foundation, understanding why you are building an API is a crucial step towards understanding what data/ methods your API should make accessible and how your users will utilize it. Unfortunately, API is a buzzword right now, and many companies are rushing to build APIs with the idea that “we’re going to make our data accessible and our users will love it!” There’s probably some truth to that, but that is not a good enough reason. What exactly are you making accessible and why? Who are your API users – are they your customers, or third party services, or developers who are looking to extend upon your application for their customers? Understanding the market you are serving is vital to the success of any product or service.

Key questions to ask:

- Who is our target user for this API
- Which of our products/ services do we want them to be working with? 
- What are THEIR use cases for integrating with our API?
- What technologies will they be using to integrate with our API?
- What other services will they want our API to interact with?


# List out the user FUNCTIONALITY of your API

Once you understand WHY you are building your API, it’s important to list out what your API needs to do, or create user stories that describe in detail the different actions required.  At this juncture you shouldn’t be focused on things like GET, POST, PUT, DELETE; but rather stating that you need to be able to create a user, edit a user, change a password, reset a password, view profile.  Or in the case of an email system be able to create an email, read an email, create a draft, send a draft, move to a folder, delete, get contacts, etc.
By building out the full list of functionality required and by creating these user stories you can see exactly how your users will be using your API, and how your API needs to work together.  You can also involve customers at this point and ask them what features are important to them, allowing you to prioritize them or even find cases that you didn’t consider before.  

# Understand what TYPE of API you are building

Among the buzzwords of buzzwords is “REST,” or Representational State Transfer.  However, most APIs are not truly REST or RESTful APIs.  Instead they tend to follow some REST ideals or be JSON-RPC.  It’s important to understand that a key constraint of REST is hypermedia, and that while you may disagree, Dr. Roy Fielding who created the theory of REST remains adamant about this.
The good news is your API doesn’t have to be REST, it could be JSON-RPC, or even SOAP… depending on what your customers need.  If all of your clients are using legacy systems that depend on SOAP libraries, it may make more sense in that case to build a SOAP API for them.  If you are building for simplicity, JSON-RPC couldn’t get easier.  However, if you are building for today’s standards and longevity, REST is a clear winner.  The question becomes what type of API meets your needs best, and it is important to understand which format you are using, especially as you have to make tough decisions in the design process.
Take a look at this quick breakdown to show you some of the advantages and disadvantages of each format, but again remember, it comes down to meeting your users’ needs. 

# Think LONG TERM… like 2-3 years down the road

Don’t build your API for today’s product or software roadmap unless you intend to throw it away fairly quickly.  Like building an application it is important to keep your API standardized and extensible.  It’s easy to want to add “quick fixes” to make customers happy, but everything you do should be carefully thought out in order to make sure your API continues to serve not only your needs, but also your clients.
Remember, when you create an API you are creating a contract- your users are depending on your API not just to make their application work, but in order to make a living and feed their families.  When you break things, or when you break backwards compatibility you are taking their time and resources to fix their application instead of adding features and keeping their customers happy.
The industry solution to this has been versioning, however, versioning is merely a Band-Aid, a temporary solution to make migration to the new system less stressful for your clients, but increasingly difficult on you.  Keep in mind, when you have multiple versions of your API you end up supporting and maintaining those versions.  One of the greatest challenges in regards to versioning is getting developers to migrate from one version to another, all while keeping your support staff from going insane.

This doesn’t mean that you shouldn’t plan for versioning.  Rather it means that you should plan to incorporate a version identifier (either in the URI or in the content-header of the response), but work under the mindset that you will only version your API if…

- You have backwards incompatible PLATFORM changes – in other words you completely change the UI or way your platform works
- You find that your API is no longer extendable – which is exactly what we are trying to avoid here
- You find that your spec no longer meets your developer’s needs – for example, they are demanding REST instead of SOAP

You should NOT version your API just because:

- You added additional endpoints
- You added additional data in the response
- You changed technologies – your API should be decoupled from your technology stack
- You changed your applications services or code – your API should be decoupled from your service layer

To clarify on the last two, it shouldn’t matter what technologies you are using, or how your services work.  The API should interact with both, but be decoupled enough that changing something in the background does not effect the API adversely.  Any changes you make to your API in regards to the technology or service layer should be as seamless and transparent as possible.  After all, the less you can break backwards compatibility, the happier you, and your customers will be.  And this can only happen if you go into building your API with a long-term, flexibility, and extensibility focus.

# Spec-Driven Development 

## Define Your API in a Flexible, but Standard Spec

I cannot stress the importance of spec driven development enough.  One of the quickest ways to kill your API is to define the API in your code, instead of coding to its definition.  By utilizing an API modeling spec such as RAML you can quickly build out your API in a consistent manner using code and pattern reuse.
Utilizing pattern design and code reuse helps to ensure that your API remains uniform across the full interface, keeping resources and methods alike standardized and easily implemented by your developers.
Tools like API Designer allow you to view your API as it is being designed and watch for inconsistencies/ dependencies you might have missed otherwise.  And perhaps most importantly, once your spec is in place it keeps everyone on the same page, ensuring that your API works exactly the way you want it to.

> RAML provides a quick, powerful, semantic, yet human readable format for describing your API.  The API Designer makes it simple to get started and even shows you what your API looks like as you describe it.

# Mock Your API and get User Feedback

Another huge advantage of tools like RAML or Swagger is that they allow you to mock your API.  This means that you can not only build your API in a visual interface and take advantage of the very same best practices we utilize in development, but you can also share a mock version of your API with potential clients.
Using MuleSoft’s API Designer you can easily turn on a mocking service that gives you a URL that can be shared with other developers.  This allows your clients to “test out” your API by making real calls as if they would from their application.  By utilizing the example responses defined in the RAML file developers can quickly identify issues and inconsistencies, helping you eliminate the majority of design related issues before development even starts.  And by passing along tools like the API Notebook, developers can interact with your Mock API through JavaScript without having to code any calls themselves, and also having the ability to send you the specific use case back giving you true examples of what your developers are trying to accomplish.

This process can be repeated as necessary, as modifying the spec and creating a new mock only takes minutes, empowering you to perfect the design of your API and ensure that it not only meets your developers’ needs, but also provides a solid, strong foundation for the future of your API.
After all, the nemesis of a long-lived API is not the code, nor the system architecture, but the API design itself.  No matter how careful you are with your API, without a solid foundation it will crumble quickly, costing you thousands to hundreds of thousands of dollars down the road.  It’s better to take the time now, up front and ensure that your API is well designed.

# Code to the Spec… and Don’t Deviate

I cannot emphasize the importance of coding to the spec enough.  If you have taken advantage of the above steps and carefully laid out your API, carefully designed your spec, user tested, and perfected your API– there is nothing worse than throwing all that work away by deviating from the spec and doing one-off things.
One of the main reasons for REST was to focus on long-term design, or as Dr. Roy Fielding pointed out, we as humans, as developers are very good at short term design, but horrendous at long-term design.  What may seem like a good solution in the short-term, if not carefully thought out and tested long-term is likely to create big problems down the road.
Think of it like this, how many times have you written code only to look back at it three months later and wonder “what was I thinking?!”  Your API is a contract, and unfortunately the one thing you cannot fix is poor design.
For that reason it’s important to avoid editing your spec during the development cycle.  Instead, if you find an issue with the spec, go back to the design phase where you can visualize the changes, prototype them, and get user feedback.  Then once you are sure your spec provides a solid foundation you can continue with development.

After all, you worked hard to involve your users and create the perfect spec, let’s make sure you use it.

# Use Nouns as Resources

If you are building a REST API, be sure that you are using nouns as resources instead of verbs. Verbs are used more with JSON-RPC where you declare the action you are taking in the URL, such as:

/createuser
/edituser/id/1
/deleteuser/id/1

As you can see, verbs are tightly coupled to a specific action and offer very little, if any flexibility.  By using nouns, as recommended with REST and taking advantage of HTTP Action Verbs (such as GET, POST, PUT, etc) you can have loosely coupled resources that are able to accomplish multiple tasks and have new actions added at any time.  Combined with hypermedia, this means that your users would be able to take advantage of any new actions immediately.

Your RESTful endpoints should look like:

/users
/users/id/1
/messages

Keep in mind that it is usually a good idea to use the plural form of the noun unless all available actions are explicit to the singular form.

# Use CRUD

CRUD stands for Create, Read, Update, and Delete. But put more simply, in regards to its use in RESTful APIs, CRUD is the standardized use of HTTP Action Verbs. This means that if you want to create a new record you should be using “POST.” If you are trying to read a record, you should be using “GET.” To update a record utilizing “PUT” or “PATCH.” And to delete a record, using “DELETE.”

It’s also important to understand the difference between PUT and PATCH, as PUT is used to perform a complete override of the record (if fields are not included, they are removed) where-as PATCH is used to update a record based on the information provided (or patch it with what you provide), leaving any fields not passed along intact.
Keep in mind there are several different HTTP Action Verbs available, and it’s easy to want to incorporate these new verbs and make your API new and different. However, when it comes to building an API, that’s the last thing you want to do. Utilize CRUD as that is what developers will be looking for when trying to utilize your API, and by deviating from it you are only make your API harder to use and maintain. Also keep in mind that not all browsers or servers support all the HTTP verbs currently out there.
Last but not least, do not mix HTTP Action Verb definitions – if you are telling your developers to make a POST, do not pass the data along as a querystring. That is not the definition of POST and will only cause more confusion for your users.  Make sure you are staying consistent with the verb definition.

# Use JSON (when possible)

JSON, or the JavaScript Object Notation format allows for the quick serialization and deserialization of objects. JSON provides a compact format for accessing data, minimalizing the data transfer required while also offering broader language support than XML.
These advantages have made it the format of choice for many developers and the leading format for use within REST APIs. Again, you’ll want to choose the format that is best for your clients, but in the event that you’re encoding objects as XML, I would strongly suggest also offering JSON as an alternative as the serialization is fairly quick and painless.
Keep in mind that one of the advantages to REST is that it is not limited to a single content type, and can return multiple formats if desired.

# Use the Content-Type Header

In order to truly keep your API flexible and extendable for the future, it’s also important to build it not just for today’s leading formats, but also for whatever the future may hold.  Until just recently XML was the format of choice for web services, but then JSON came along.  Everyday new formats are being created and used, most notably YAML.  For this reason it is important that your API does not constrain itself to only one format.
It’s perfectly acceptable to only have one format available if that meets your developer’s needs (for example, only taking advantage of JSON), but that doesn’t mean you shouldn’t be planning ahead.  By taking advantage of the Content-Type header you can see what format of data your users are sending you, and in return send back that same format.  For example, if a user sends a request using text/xml, you could send back an XML response while another user could send an application/json request and you could reply with JSON.
By building this functionality into your API to begin with, as new formats become available, or as you add high profile clients with special needs, you are now able to adapt to these new format requests without impacting other users, or other aspects of your API.  This also means that you can stay on top of the technology curve without worrying about having to migrate users from one format to another, or from one API to another.
Ideally, your API’s architecture should be flexible enough to receive content in one format (as described by the Content-Type header) such as XML and return the response in another format based on the Accept header, such as JSON.  Doing so is NOT a good practice, but it does reinforce just how decoupled your API should be from the technology stack, as well as how important incorporating view libraries to handle the output are.  In other words, your API’s architecture should be versatile enough to do this, but it is probably best just to rely on the content-type instead of mixing data formats based on both the content-type and accept headers.

# Provide Helpful Responses

Building a solid foundation to ensure the scalability and longevity of your API is crucial, but just as crucial is ensuring that developers can understand your API, and trust it to respond with the appropriate header codes and error messages.
In this week’s API best practices, we’re going to cover how to ensure that developers understand exactly what happened with their API call by using the appropriate HTTP Status Codes (something that is often times missed), as well as by returning descriptive error messages on failure.

# Use HTTP Status Codes

One of the most commonly misused HTTP Status Codes is 200 – ok or the request was successful.  Surprisingly, you’ll find that a lot of APIs use 200 when creating an object (status code 201), or even when the response fails:

In the above case, if the developer is solely relying on the status code to see if the request was successful, the program will continue on not realizing that the request failed, and that it did something wrong.  This is especially important if there are dependencies within the program on that record existing.  Instead, the correct status code to use would have been 400 to indicate a “Bad Request.”
By using the correct status codes, developers can quickly see what is happening with the application and do a “quick check” for errors without having to rely on the body’s response.
You can find a full list of status codes in the [HTTP/1.1 RFC](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html), but just for a quick reference, here are some of the most commonly used Status Codes for RESTful APIs:
200	Ok
201	Created
304	Not Modified
400	Bad Request
401	Not Authorized
403	Forbidden
404	Page/ Resource Not Found
405	Method Not Allowed
415	Unsupported Media Type
500	Internal Server Error
Of course, if you feel like being really creative, you can always take advantage of status code:
418	I’m a Teapot
It’s important to note that Twitter’s famed 420 status code – Enhance Your Calm, is not really a standardized response, and you should probably just stick to status code 429 for too many requests instead.

# Use Descriptive Error Messages
Again, status codes help developers quickly identify the result of their call, allowing for quick success and failure checks.  But in the event of a failure, it’s also important to make sure the developer understands WHY the call failed.  This is especially crucial to the initial integration of your API (remember, the easier your API is to integrate, the more likely people are to use it), as well as general maintenance when bugs or other issues come up.
You’ll want your error body to be well formed, and descriptive.  This means telling the developer what happened, why it happened, and most importantly – how to fix it.  You should avoid using generic or non-descriptive error messages such as:
redx   Your request could not be completed
redx   An error occurred
redx   Invalid request
Generic error messages are one of the biggest hinderances to API integration as developers may struggle for hours trying to figure out why the call is failing, even misinterpreting the intent of the error message altogether. And eventually, if they can’t figure it out, they may stop trying altogether.
For example, I struggled for about 30 minutes with one API trying to figure out why I was getting a “This call is not allowed” error response. After repeatedly reformatting my request and trying different approaches, I finally called support (in an extremely frustrated mood) only to find out it was referring to my access token, which just so happened to be one letter off due to my inability to copy and paste such things.
Just the same, an “Invalid Access Token” response would have saved me a ton of hassle, and from feeling like a complete idiot while on the line with support.  It would have also saved them valuable time working on real bugs, instead of trying to troubleshoot the most basic of steps (btw – whenever I get an error the key and token are the first things I check now).
Here are some more examples of descriptive error messages:
greencheckmark   Your API Key is Invalid, Generate a Valid API Key at http://…
greencheckmark   A User ID is required for this action. Read more at http://…
greencheckmark   Your JSON was not properly formed. See example JSON here: http://…
But you can go even further, remember- you’ll want to tell the developer what happened, why it happened, and how to fix it.  One of the best ways to do that is by responding with a standardized error format that returns a code (for support reference), the description of what happened, and a link to the appropriate documentation so that they can learn more/ fix it:

```json
{
  "error" : {
    "code" : "e3526",
    "message" : "Missing UserID",
    "description" : "A UserID is required to edit a user.",
    "link" : "http://docs.mysite.com/errors/e3526/"
  }
}
```

On a support and development side, by doing this you can also track the hits to these pages to see what areas tend to be more troublesome for your users – allowing you to provide even better documentation/ build a better API.

# Building an SDK Doesn’t Fix Everything

Last but not least, keep in mind that SDKs or code wrappers/ libraries can be extremely helpful.  However, if you are building a full out SDK instead of a language wrapper that utilizes the hypermedia to handle responses, remember that you are adding a whole new layer of complexity to your API ecosystem – that you will have to maintain.
What SDKs/ Code Wrappers offer is a quick, plug and play way for developers to incorporate your API, while also (hopefully) handling error checks/ responses.  The downside is the more complex your SDK becomes, the more tightly coupled it usually is to your API, making any updates to your API a manual and complex process.  This means that any new features you roll out will receive rather slow adoption, and you may find yourself providing support to your developers on why they can’t do something with your SDK.
When building your SDK you should try to keep it as decoupled from your API as possible, relying on dynamic responses and calls while also following the best coding practices for that language (be sure to watch Keith Casey’s SPOIL talk or read about it here).
Another option is to utilize a SDK building service such as APIMatic.io or REST United, which automatically generates SDKs for your API based on your RAML, Swagger, or API Blueprint spec.  This allows you to offer SDKs, automatically have them update when adding new features (although clients will still need to download the updated version), and offer them without adding any additional workload on your end.
But again, regardless of whether or not you provide an SDK/ Code Library, you will still want to have multiple code examples in your documentation to help developers who want to utilize your API to its fullest capacity, without relying on additional third party libraries to do so.
To recap, use HTTP Status Codes, use Descriptive Error Messages, and having an SDK may be helpful for a lot of your developers – but make sure you take into consideration all of the challenges that come with it, and remember that having an SDK doesn’t replace documentation, if anything – it creates the need for more.

# Design is Important, But…

Over the last several weeks we’ve looked at the design aspect of building APIs.  We’ve covered planning out your API, spec driven development, and best practices.  But your API is really a vehicle for developers to access data and services, much like a plane is a vehicle for transporting people to and from places.  But building the plane isn’t enough, along with having the actual vehicle, you need airports with checkpoints to make sure that only the people who are supposed to be getting in that plane have access, and likewise that no one is trying to do anything malicious.
The hidden danger of an API is that it can expose vulnerabilities within your application.  Both accidental and malicious abuse of your API can hammer your servers causing downtime for you and your customers.  And often times, this is as simple as an inexperienced developer (or even an experienced one) throwing in an infinite loop.

# Authentication is Key
By providing your API users with a unique API token, or API key you can tell exactly who is making calls to your API.  Along with having quick access to determining potential malicious users which can immediately be removed, you can also set permissions and SLAs for users depending on their individual needs.  This means that you can set a default SLA for most users, giving them say only 4 calls per second, but for silver partners they get 10 calls per second, for gold partners 100 calls per second, etc.  This means that you can not only identify abuse quickly, but also help prevent it by limiting their access to certain aspects of your API, and by limiting the number of calls they can make to your API.

# Throttling Isn’t Bad
Throttling and rate limiting isn’t a bad thing.  Again, by throttling your API and setting up different SLA tiers you are able to help prevent abuse – often times completely accidental.  This means that your API is able to operate optimally for all of your users, instead of having one infinite loop bring it crashing down for everyone.
And yes, you may have partners that need more calls than others, or who the limits do not make sense for.   But again, by setting up SLA tiers based on your standard API user’s needs, and then creating partner tiers, you can easily give the the permissions they need, while limiting the standard user to prevent abuse.
The API key, or unique identifier for an user’s application also helps you identify who your heavier users are – letting you get in contact with them to make sure their needs are being met, while also learning more about how they are using your API.

# Security. Security. Security.
An API Manager should also be designed to handle security, not just by validating a boarding pass (API key) and directing them to their appropriate gate (permissions, SLA tier), but your API Manager should watch out for other dangerous threats, such as malicious IPs, DDoS, content threats (such as with JSON or XML), and others.
It should also be designed to work with your current user validation systems such as OAuth2 to help protect your user’s sensitive data (such as their username and password) within your API.  Keep in mind that even the most righteous of applications are still prone to being hacked – and if they have access to your user’s sensitive data, that means that hackers might get access to it too.  It’s always better to never have your users expose their credentials through the API (such as with basic auth) but instead rely on your website to handle logins and then return back an access token as OAuth2 does.

## But… Security is Hard

One of my favorite talks, by Anthony Ferrara sums this up very nicely…  Don’t do it.  Leave it for the Experts.  Granted, his talk was specifically on encryption, but there’s a lot of careful thought, planning, and considerations that need to be taken when building an API Management tool.  You can certainly build it yourself, and handling API keys or doing IP white-listing/ black-listing is fairly easy to do.  However, like an airport, what you don’t see is all of the stuff happening in the background, all the things being monitored carefully, security measures implemented by experts with years of experience in risk mitigation.
For that reason, as tempting as it might be to build one yourself, I would strongly encourage you to take a look at a professional API Management company- such as MuleSoft (of course, I might be a little biased).


1. Planning Your API – The first and most basic step, is understanding what it is that you’re actually building. Understand what your customers want (this means involving them), understand what different types of APIs there are out there, and why you are building the kind you are (REST, REST-like, SOAP, RPC). Lastly, it’s important to map out the functionality that your users need – and to not get stuck in a resources/CRUD mindset when doing so.
2. Utilizing Spec Driven Development – Using a spec like RAML to model your API, lets you get an immediate visual representation of what it is that you’re actually building while taking advantage of code reuse and design patterns for consistency. Keep your users involved and prototype (mock) your API for them to test out using tools like the API Notebook. Keep making revisions to your design until you have a solid foundation and have fixed 99% of the design flaws. Then start building!
3. Using Nouns for Resources – Keep your resources versatile and flexible. By using nouns you can stay true to REST principles and avoid tightly coupling your resources to methods or actions. Remember that you generally want your resources in the plural form (users) and they should map to the objects or areas that your clients are trying to manipulate (ie: /users to modify users).
4. Following CRUD and use HTTP Action Verbs – By thinking of actions in a Create, Read, Update, and Delete format you can take advantage of the HTTP Action Verbs or methods and make it easier for developers to utilize your API. Be sure to understand the difference between POST, PUT, and PATCH – and when to use which.
5. Using JSON when possible – JSON is more compact and more widely supported by languages than XML, YAML, and other formats. However, some clients may require other formats, such as XML – which is where the Content-type header comes in!
6. Using the Content-type header – Even if you’re only planning on returning back one format (such as JSON), the Content-type header gives you the flexibility to add in more formats down the road and support multiple client’s needs without having to modify your API.
7. Hypermedia… Hypermedia… Hypermedia – Yes it’s a challenge, but by adding hypertext links to your API result with a standardized format such as HAL or JSON API, you’re giving developers the tools to better understand and discover your API, while also providing them with the application state (can an item be edited, deleted, etc).
8. Utilizing HTTP Status Codes – Tell your clients what’s happening, when things are successful (200, 201) or when they’re not (304, 400, 500).
9. Providing descriptive error messages – When something doesn’t work, don’t just tell them it didn’t work, tell them why. Take a look at some of the more popular error messaging formats including Google Errors, vnd.error, and JSON API’s error format.
10. Remembering that SDKs can be part of the solution, but they can also be part of the problem – Don’t expect an SDK to solve your problems or reduce your workload – instead look at them for what they are – a tool to help developers get started more quickly with your API. And a tool that you’ll need to be maintaining.
11. Taking advantage of an API Management tool – such as MuleSoft’s Anypoint Platform for APIs. API Managers are designed to protect and help scale your API– keeping threats out and protecting you from both unintentional and malicious attacks on your API– while also handling authentication, provisioning, and throttling to keep your API running optimally.
And that brings us to number 12… one of the best pieces of advice I’ve ever received for building an API:
12. Keep it Simple. As you design your API there will be temptation to do fancy or “innovative” things within your API – don’t. Instead, remember that you are building a foundation for future development. The fancier you get, the more likely you are to limit yourself or fall victim to bad practices. Instead, the simpler you keep your API, the longer you’ll be able to extend it, and the easier it will be for your clients to utilize. Simplicity is key.

---

# What Is an API?

API stands for "Application Programming Interface," and as a term, specifies how software should interact.

Generally speaking, when we refer to APIs today, we are referring more specifically to web APIs, those delivered over HTTP. For this specific case, then, an API specifies how a consumer can consume the service the API exposes: what URIs are available, what HTTP methods may be used with each URI, what query string parameters it accepts, what data may be sent in the request body, and what the consumer can expect as a response.

## Types of APIs

Web APIs can be broken into two general categories:

- Remote Procedure Call (RPC)
- REpresentational State Transfer (REST)

### RPC

RPC is generally characterized as a single URI on which many operations may be called, usually solely via POST. Exemplars include XML-RPC and SOAP. Usually, you will pass a structured request that includes the operation name to invoke and any arguments you wish to pass to the operation; the response will be in a structured format.

One thing to note here is that RPC usually is doing all error reporting in the response body; the HTTP status code will not vary, meaning that you need to inspect the return value to determine if an error occurred!

Finally, many RPC implementations also provide documentation to their end users via the protocol itself. For SOAP, this is WSDL; for XML-RPC, this is through the various "system." methods. This self-documenting feature when implemented (it isn't always!) can provide invaluable information to the consumer on how to interact with the service.

The points to remember about RPC are:

One service endpoint, many operations.
One service endpoint, one HTTP method (usually POST).
Structured, predictable request format, structured, predictable response format.
Structured, predictable error reporting format.
Structured documentation of available operations.
All that said, RPC is often a poor fit for web APIs:

You cannot determine via the URI how many resources are available.
Lack of HTTP caching, inability to use native HTTP verbs for common operations; lack of HTTP response codes for error reporting requires introspection of results to determine if an error occurred.
"One size fits all" format can be limiting; clients that consume alternate serialization formats cannot be used, and message formats often impose unnecessary restrictions on the types of data that can be submitted or returned.
In a nutshell, most RPC variants commonly in usage for web APIs do not use HTTP to its full capabilities.

### REST

REpresentational State Transfer (REST) is not a specification, but an architecture designed around the HTTP specification. The [Wikipedia article on REST](http://en.wikipedia.org/wiki/Representational_state_transfer) provides an excellent overview of the concepts, and copious resources.

REST leverages HTTP's strengths, and builds on:

URIs as unique identifiers for resources.
Rich set of HTTP verbs for operations on resources.
The ability for clients to specify representation formats they can render, and for the server to honor those (or indicate if it cannot).
Linking between resources to indicate relationships. (E.g., hypermedia links, such as those found in plain old HTML documents!)
When talking about REST, the Richardson Maturity Model is often used to describe the concerns necessary when implementing a well-designed REST API. It consists of four levels, indexed from zero:

When talking about REST, the [Richardson Maturity Model](http://martinfowler.com/articles/richardsonMaturityModel.html) is often used to describe the concerns necessary when implementing a well-designed REST API. It consists of four levels, indexed from zero:

- Level 0: HTTP as a transport mechanism for remote procedure calls. Essentially, this is RPC as described in a previous section. HTTP is being used as a tunnelling mechanism, with a single entry point for all services, and does not take advantage of the hypermedia aspects of HTTP: URIs to denote unique resources, HTTP verbs, ability to specify and return multiple media types, or to link between services. (Note: some Level 0 services will use more than one HTTP verb, but usually only a mix of POST (for operations that may cause data changes) and GET (when only fetching data).)
- Level 1: Using URIs to denote individual resources as services. This differentiates from Level 0 by using a URI per operation or "resource" (the "R" in "URI" stands for "Resource" after all!). Instead of a /services URI, you will have one per service: /users, /contacts, etc; furthermore, you will likely allow addressing individual items within the service as well via unique URIs: /users/mwop would allow access to the "mwop" user. However, at Level 1, you're still not using HTTP verbs well, varying media types, or linking between services.
- Level 2: Using HTTP verbs and headers for interactions with resources. Building on Level 1, a Level 2 service starts using the full spectrum of HTTP request methods: PATCH, PUT, and DELETE are added to the arsenal. GET is used for safe operations that do not change state, and can be used any number of times in order to get the same results; in other words, it's cacheable using HTTP request caching. The service returns appropriate HTTP response statuses for errors, based on the error type; no more 200 OK with errors embedded in the body. HTTP headers can be used to vary responses; for instance, different representations may be returned based on the Accept header (and the Accept header is used to request alternate representations, instead of a file extension, in order to promote the idea that the same resource is being manipulated regardless of representation).
- Level 3: Hypermedia controls. Most API designers get as far as Level 2, and feel they've done their job well; they have. However, one more aspect to the API can make it even more usable: linking resources. Consider this: you make a request to an API for available event tickets. At Level 2, the response might be a list of tickets; Level 3, however, goes a step further, and provides links to each ticket resource, so that you can reserve any one of them!
The point of links is to tell the API consumer what can be done next. One aspect of this is it allows the server to change the URIs to resources, on the assumption that the consumer will follow only those links that the server itself has returned. Another aspect is that the links help the API document itself; a consumer can follow links in the API in order to understand how the various resources are related, and what they can do.


Essentially, a good REST API:

- Uses unique URIs for services and the items exposed by those services.
- Uses the full spectrum of HTTP verbs to perform operations on those resources, and the full spectrum of HTTP to allow varying representations of content, enabling HTTP-level caching, etc.
- Provides relational links for resources, to tell the consumer what can be done next.

All of this theory helps tell us how REST services should act, but tell us very little about how to implement them. This is somewhat by design; REST is more of an architectural consideration. However, it means that the API designer now has to make a ton of choices:

- What representation formats will you expose? How will you report that you cannot fulfill a request for a given representation? REST does not dictate any specific formats.
- How will you report errors? Again, REST does not dictate any specific error reporting format, beyond suggesting that appropriate HTTP response codes should be used; however, these alone do not provide enough detail to be useful for consumers.
- How will you advertise which HTTP methods are available for a given resource? What will you do if the consumer uses a request method you do not support?
- How will you handle features such as authentication? Web APIs are generally stateless, and should not rely on features such as session cookies; how will the consumer provide their credentials on each request? Will you use - HTTP authentication, or OAuth2, or create API tokens?
- How will you handle hypermedia linking? Some formats, such as XML, essentially have linking built-in; others, such as JSON, have no native format, which means you need to choose how you will provide links.
- How will you document what resources are available? Unlike RPC, there are no "built-in" mechanisms for describing REST services; while hypermedia linking will assist, the consumer still needs to know the various entry points for your API.

These are not trivial questions, and in many cases, the choices you make for one will impact the choices you make for another.

In a nutshell, most REST provides incredible flexibility and power, but requires you to make many choices in order to provide a solid, quality experience for consumers.