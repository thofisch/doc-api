# Hypermedia

## What is Hypermedia?

One of the challenges to implementing and correctly using hypermedia in your REST API is first understanding what hypermedia is, and what it means to use hypermedia as the engine of application state (HATEOAS).
The term "hypermedia" was coined back in 1965 by Ted Nelson, and over the years has dominated the technology industry.

Hypermedia, in its most basic sense is an extension of hypertext – something you may recognize from HTML.

Hypertext is essentially text that is written in a structured format and contains relationships to other objects via links.

If you think of a webpage, using HTML – the Hypertext Markup Language – text is then interpreted by a browser to become a webpage, or an interactive environment capable of doing more than just providing a blob of text.

However, to be truly interactive and guide the user, the crucial component of all of this is links, something we use everyday when surfing the web.
Enter hypermedia, again just an extension of the term hypertext, hypermedia includes images, video, audio, text, and links.

In a REST API, this means that your API is able to function similarly to a webpage, providing the user with guidance on what type of content they can retrieve, or what actions they can perform, as well as the appropriate links to do so.
Essentially, the easiest way to take advantage of hypermedia in your API is to provide valuable information to direct the user or client to the next possible actions they can take based on the object (whether it be a collection, or item within the resource) or "page" they are on via links.
Another way to think of it is to bring back the Hypercard application from the early Apple days (we're talking Macintosh Classic).

With this application you could create "cards" or slides with links that performed different functions.

Clicking on link might play a sound, another a video, or another would take you to a different card.

On each card you were presented with certain links (whether in the form of a button or text) for the available actions to you on this card.

This is exactly how hypertext links work within RESTful APIs– they are designed to take you to the other components of the API, your other "cards."
By adding these links, because REST is stateless, we are providing the client with a method for determining the state of the current item/ collection that they are on, as well as giving them the roadmap or engine for what they can do with it.

In other words, we are using Hypermedia as the Engine of the Application's State, or implementing HATEOAS.

## The HATEOAS Debate

Currently, there is a lot of disagreement around hypermedia's place in RESTful APIs– with Dr. Roy Fielding saying it is critical to REST, and without it your API cannot be RESTful; and hypermedia skeptics arguing that you are doing nothing more than bloating your API and making it more difficult to use under the guise of usability.
This means you will find many different stances on the web today, ranging from Peter Williams explanation of how hypermedia has helped him, Jeff Krupp's rant against hypermedia, and even Kin Lane's summary of the whole debate.
But what it really comes down to isn't what do others think about hypermedia, as most major frameworks for building APIs now include hypermedia specs such as HAL, JSON-LD, JSON API, Siren, or Collection+JSON, but rather what benefit does hypermedia offer- and is that benefit enough to outweigh the cost/ disadvantages of incorporating hypermedia.

## The Claims For and Against Hypermedia

Some of the most common arguments for and against hypermedia include:

### Hypermedia creates more work

This is absolutely true.

Adding hypermedia or hypertext links to your API output does require more work – and more thought to go into your API.

Going back to the Planning Your API post in this series, hypermedia explains how your API works together, what resources work with which, and what you can do with a collection, or specific items in that collection.

This will add to both the workload and the time it takes to build your API.

However, by having these relationships already drawn out as suggested, the additional time required will be minimal.

### Hypermedia will require more Data-Transfer

Again, absolutely true.

By adding the links to your response you are increasing the amount of data that needs to be sent back, and slowly down the responses ever so slightly.

However, for MOST APIs the amount of data being added will be minimal and the data/ time difference result will realistically be unnoticeable.

What you will do, however, is help avoid unnecessary calls that are not accessible to a particular item, but may be available to other items.

See the next section for more on this.

### You are creating an API for a client that doesn't exist

Another argument against APIs is that unlike web browsers, there are no browsers for APIs.

Likewise a valid argument, however, one I personally believe falls short as like the web we are seeing advances in APIs and recently an explosion of API exploration tools ranging from API Consoles to the API Notebook.

As more and more APIs are developed there will be more and more emphasis on being able to explore them pragmatically.
Another reason I believe this argument falls short is that by utilizing hypermedia you allow the developers USING your API to build their systems around the information you provide them, creating a more dynamic application that relies on the available actions YOU return to them instead of creating rigidity by hardcoding what actions the user can take from their application in relation to your API and returning errors when those actions fail because they simply were not available to begin with.
For example, for one user you may be able to:
Edit
Suspend
Delete
But for another user who has been suspended, maybe you can only:
Restore
Delete
Because this is dynamic data the developer has no way to determine what actions are available and which ones are not, unless they dig through and try to decipher the user's data which has been returned- making assumptions about your architectures rules which may or may not be correct, and may change with future development.

Hypertext links in this case allow the developer to rely on YOUR rules and architecture, rather than trying to mimic it with their own.

### Nobody knows how to use Hypermedia

There is some truth into this.

Despite existing since 1965, many developers are flustered when first running into hypermedia, choosing to ignore it or misunderstanding how to use it (i.e.

hard-coding the links).

What can help with this, however, is more APIs taking advantage of hypermedia (as being encouraged in the most popular development frameworks), and simple explanations within documentation explaining how the hypertext links work (just as we had to explain how to do a GET, POST, PUT, PATCH, and DELETE when REST first came out).

However, unlike many specs and challenges out there, utilizing hypermedia from a client has a very fast learning curve, and most developers are able to implement it quickly and without any real issue once they understand what it is designed to do.

And once implemented correctly, many developers appreciate knowing that as resource URIs change or additional query parameters are required of them, that their application will be able to "automatically upgrade" to these new requirements without any work or concern on their part.

### Hypermedia makes your API MORE Flexible

Absolutely true.

By adding Hypermedia you are able to add new features more seamlessly- making them immediately available to your users.

It also gives you the power to change certain aspects of your API (i.e.

changing resources, requiring additional GET parameters) without necessarily breaking backwards compatibility IF implemented correctly by your users.

### Hypermedia prevents APIs from breaking

Absolutely false.

As mentioned above, Hypermedia does make your API more flexible, but does not excuse poor design or allow you to break backwards compatibility.

One of the reasons for this, is even if you have a purely hypermedia driven API, such as Stormpath's, developers will still hardcode certain URLs to avoid having to make multiple calls.

For example, they may access the /users resource directly to get a list of all users instead of starting from the gateway or entry point of your API and working up to that point through multiple calls.

While this technique does save you (and them) multiple API calls, it does limit your ability to change common or most frequently used resource URIs.
Hypertext links also do nothing for backwards incompatible changes in data– although you could hypothetically use them as a form of versioning.

### Hypermedia replaces Documentation

Hypermedia does increase discoverability of your API's resources and methods, however, it does not replace documentation as it doesn't provide method information, schemas, or examples.

Documentation also serves as a preview to your API, letting developers understand how it works, and potentially make sample calls using an API Console before implementing it into their application.

Hypermedia also does not play a solid role in debugging the implementation of the API when things go wrong.

For this reason, having well written, informative documentation is vital to any API.

In fact, many RESTful hypermedia specs including HAL grant you the ability to embed documentation links for quick reference by developers.

### Hypermedia is a Best Practice

Where hypermedia shines is in its ability to create a flexible API that provides dynamic data for developers based on your architecture and not their own.

In essence, it provides a shortcut for developers that allows them to utilize your API to its fullest without having to rely solely on documentation and writing rules that may or may not not be consistent with those in your application.

Like when building a simple website, one may not see the advantage of Hypermedia right away, but as your API grows and becomes more complex you will find that it becomes a powerful convenience layer, one that will help developers better understand and navigate your API, and one that may prevent you from having to version your API for certain changes that would otherwise be backwards incompatible — if implemented correctly by your users.

As Peter Williams explains in his post, hypermedia turned out to be a saving grace.

And as a key component of REST as defined by Dr. Roy Fielding, it remains a best practice to implement.

### In Summary

Hypermedia is often misunderstood in regards to APIs, but essentially it functions exactly like links on a webpage.

And while the technology is both praised and criticized, it does provide an array of short and long-term gains.

These gains, I believe, become more and more noticeable the larger and more complex your API becomes.

However, the best features of utilizing HATEOAS, in my opinion, are yet to be seen as technology and API exploration tools continue to advance.
Be sure to join us next week as we take a look at implementing hypermedia into your API and the current specs out there to help you do so.

## The Harsh Reality of the State of Hypermedia Specs

Hypermedia sounds great in theory, but theory only goes so far.

Where hypermedia really shines, or completely fails, is in implementation.

Unfortunately, as hypermedia is still a relatively new aspect of web based APIs, there isn't one specified way of doing things.

In fact, you'll find that even some of the most popular APIs operate completely differently from each other.
After all, there are several different hypermedia formats available for API providers to choose from.

Just for starters there is HAL, Collection+JSON, JSON-LD, JSON API, and Siren! But the list doesn't stop there, as some popular APIs have even elected to create their own format.
For example, while PayPal's API closely mimics the JSON API format, it goes a step further and adds a method property (not part of the JSON API spec), creating a more flexible spec and transforming it from being resource driven to being action driven:
This has the potential to let developers create a more agile client based on the actions (and methods) available to them.

However, for developers not familiar with PayPal's format, but familiar with JSON API this may cause slight confusion (although it should be quickly remedied by reading their docs).
VerticalResponse, on the other hand, has taken a different, albeit interesting approach.

For their API they likewise start with the basic JSON API format, but for some reason decided against the universally accepted "href" or Hypertext Reference property, instead opting to use "url" or the uniform resource locator as the link URI identifier:
Personally, I would recommend staying with the uniform "href" attribute as it denotes a reference to a hypertext link and is not as exclusive as an URL- which is not (although it commonly is) to be confused with URI.

But you can read more on that here.
On the other hand, Amazon's AppStream API, Clarify, Microsoft's Lync, and FoxyCart all prefer to follow HAL or the Hypertext Application Language format.

HAL provides a simple format for nest-able links, but like other specs omits the methods property as included by PayPal, making theirs truly unique in that sense:
However FoxyCart takes it one step further, not only taking advantage of hypermedia, but offering multiple formats for their clients to choose from, including HAL+JSON, HAL+XML, and Siren.
This, however, highlights once again one of the biggest challenges with hypermedia driven APIs, the abundance of ideas and specs available for execution.

While on one-hand I believe that by supporting both XML and JSON, as well as having multiple JSON formats FoxyCart is by far the most flexible (format wise) of the APIs, not having a singular standard for each language does present the challenge of forcing developers (and hypermedia clients) to support multiple formats (as they integrate more and more hypermedia APIs), while also having the understanding that not one format meets every API's needs.
The good news, is that despite these growing pains, we are starting to see companies adopting certain specs over others, while also identifying areas for improvement (such as with PayPal's adding of methods to JSON API).

Next week we'll take a look at some of the most popular formats out there in-depth, keying in on the strengths and weaknesses of each.
But it's important that as you build your API, you understand WHY you are building it the way you are.

And this extends into how you build your hypermedia links, and whether or not you choose to take advantage of a standardized format (recommended), or venture off on your own to meet your developers' needs.

One of the best ways to do this is to explore what others have done with their APIs, and learn from their successes, and their mistakes.
It's also important to consider where technology is going.

And as more and more formats become available and change in popularity, it may be smart to follow FoxyCart's lead – taking advantage of the spec that best meets your developers' needs, but also keeping the link format decoupled enough from your data that you are able to return multiple formats based on the content-type received.

Something that will allow you to take advantage of this best practice, while also being prepared for whatever the future may hold.

### Specs

What essentially every hypertext linking spec does provide is a name for the link and a hypertext reference, but outside of that, it's a crapshoot.

As such, it's important to understand the different specs that are out there, which ones are leading the industry, and which ones meet your needs.

We may not be able to get it down to one spec, but at least we'll be able to provide our users with a uniform response that they can easily incorporate into their application:

#### Collection+JSON

Collection+JSON is a JSON-based read/write hypermedia-type designed by Mike Amundsen back in 2011 to support the management and querying of simple collections.

It's based on the Atom Publication and Syndication specs, defining both in a single spec and supporting simple queries through the use of templates.

While originally widely used among APIs, Collection+JSON has struggled to maintain its popularity against JSON API and HAL.
Strengths: strong choice for collections, templated queries, early wide adoption, recognized as a standard Weaknesses: JSON only, lack of identifier for documentation, more complex/ difficult to implement

#### JSON API

JSON API is a newer spec created in 2013 by Steve Klabnik and Yahuda Klaz.

It was designed to ensure separation between clients and servers (an important aspect of REST) while also minimizing the number of requests without compromising readability, flexibility, or discovery.

JSON API has quickly become a favorite receiving wide adoption and is arguably one of the leading specs for JSON based RESTful APIs.

JSON API currently bares a warning that it is a work in progress, and while widely adopted not necessarily stable.
Strengths: simple versatile format, easy to read/ implement, flat link grouping, URL templating, wide adoption, strong community, recognized as a hypermedia standard
Weaknesses: JSON only, lack of identifier for documentation, still a work in progress

#### HAL

HAL is an older spec, created in 2011 by Mike Kelly to be easily consumed across multiple formats including XML and JSON.

One of the key strengths of HAL is that it is nestable, meaning that _links can be incorporated within each item of a collection.

HAL also incorporates CURIEs, a feature that makes it unique in that it allows for inclusion of documentation links in the response – albeit they are tightly coupled to the link name.

HAL is one of the most supported and most widely used hypermedia specs out there today, and is surrounded by a strong and vocal community.
Strengths: dynamic, nestable, easy to read/ implement, multi-format, URL templating, inclusion of documentation, wide adoption, strong community, recognized as a standard hypermedia spec, RFC proposed Weaknesses: JSON/XML formats architecturally different, CURIEs are tightly coupled

#### JSON-LD

JSON-LD is a lightweight spec focused on machine to machine readable data.

Beyond just RESTful APIs, JSON-LD was also designed to be utilized within non-structured or NoSQL databases such as MongoDB or CouchDB.

Developed by the W3C JSON-LD Community group, and formally recommended by W3C as a JSON data linking spec in early 2014, the spec has struggled to keep pace with JSON API and HAL.

However, it has built a strong community around it with a fairly active mailing list, weekly meetings, and an active IRC channel.
Strengths: strong format for data linking, can be used across multiple data formats (Web API & Databases), strong community, large working group, recognized by W3C as a standard
Weaknesses: JSON only, more complex to integrate/ interpret, no identifier for documentation

#### Siren

Created in 2012 by Kevin Swiber, Siren is a more descriptive spec made up of classes, entities, actions, and links.

It was designed specifically for Web API clients in order to communicate entity information, actions for executing state transitions, and client navigation/ discoverability within the API.

Siren was also designed to allow for sub-entities or nesting, as well as multiple formats including XML – although no example or documentation regarding XML usage is provided.

Despite being well intentioned and versatile, Siren has struggled to gain the same level of attention as JSON API and HAL.

Siren is still listed as a work in progress.
Strengths: provides a more verbose spec, query templating, incorporates actions, multi-format
Weaknesses: poor adoption, lacks documentation, work in progress

#### Other Specs

Along with some of the leading specs mentioned above, new specs are being created every day including UBER, Mason, Yahapi, and CPHL.

This presents a very interesting question, and that is are we reinventing the wheel, or is there something missing in the above specs.

I believe the answer is a combination of both, with developers being notorious for reinventing the wheel, but also because each developer looks at the strengths and weaknesses of other specs and envisions a better way of doing things.
You may recognize this issue from the last post, where some specs were modified by the companies using them to meet their individual needs.

For example, PayPal wanted to include methods in their response, but you'll notice that only Siren of the above include methods in the link definition.

### The Future of Specs

Given that new specs are being created every day, each with different ideas and in different formats, it's extremely important to keep your system as decoupled and versatile as possible, and it will be very interesting to see what the future of hypermedia specs will look like.
In the mean-time, it's best to choose the spec that meets your needs, while also being recognized as a standard for easy integration by developers.

Of the specs above, I would personally recommend sticking with HAL or JSON API, although each has its own strengths and weaknesses, and I believe that universal spec of the future has yet to be created.

But by adhering to these common specs while the new specs battle things out, I think we will finally find that standard method of road signs, detours, and a single solution to provide API clients with a standardized GPS system.
For more on the different specs, I highly recommend reading Kevin Sookocheff's review.

I'd also love to hear your thoughts in the comments below.



## Linking and Application State

<!-- TODO -->

    <!--
    HATEOS / HAL / JSONAPI etc.
    -->

    A link provides a mean to navigate from one resource to another.

    Application state is the state the server needs to maintain between each request for each client. Keeping state in clients does not mean serializing session state into URIs or HTML forms.

    If the amount of data is small, the best place to maintain application state is within links in representations of resources, where the server can encode the state within the URI itself. However, the server can stores data in a durable storage and encodes its primary key in the URI. Use a combination of both approaches for managing application state to strike a balance between network performance, scalability and reliability.

    ```
    HTTP/1.1 200 OK
    Content-Type: application/xml;charset=UTF-8

    <quote xmlns:atom="http://www.w3.org/2005/Atom">
        <driver>...</driver>
        <vehicle>...</vehicle>
        <offer>
            <valid-until>2009-10-02</valid-until>
            <atom:link href="http://www.example.org/quotes/buy?quote=abc1234" rel="http://www.example.org/rels/quotes/buy" />
        </offer>
    </quote>
    ```

- **DO** encode application state into URIs, and include those URIs into representations via links.
- **DO** store the application state in a durable storage, and encode a reference to that state in URIs, if the state is large or cannot be transported to the clients for security or privacy reasons.
- **DO** make sure to add checks (such as signatures) to detect/prevent tampering of state, when using application state in links.

<!-- TODO -->
    #### *Links in XML Representations*

    *[Atom](http://www.w3.org/2005/Atom)*

### MUST: Use Common Hypertext Controls

When embedding links to other resources into representations you must use the common hypertext control object. It contains at least one attribute:

href: The URI of the resource the hypertext control is linking to. All our API are using HTTP(s) as URI scheme.
In API that contain any hypertext controls, the attribute name href is reserved for usage within hypertext controls.

The schema for hypertext controls can be derived from this model:

HttpLink:
  description: A base type of objects representing links to resources.
  type: object
  properties:
    href:
      description: Any URI that is using http or https protocol
      type: string
      format: uri
  required: [ "href" ]
The name of an attribute holding such a HttpLink object specifies the relation between the object that contains the link and the linked resource. Implementations should use names from the IANA Link Relation Registry whenever appropriate. As IANA link relation names use hyphen-case notation, while this guide enforces snake_case notation for attribute names, hyphens in IANA names have to be replaced with underscores (e.g. the IANA link relation type version-history would become the attribute version_history)

Specific link objects may extend the basic link type with additional attributes, to give additional information related to the linked resource or the relationship between the source resource and the linked one.

E.g. a service providing "Person" resources could model a person who is married with some other person with a hypertext control that contains attributes which describe the other person (id, name) but also the relationship "spouse" between between the two persons (since):

{
  "id": "446f9876-e89b-12d3-a456-426655440000",
  "name": "Peter Mustermann",
  "spouse": {
    "href": "https://...",
    "since": "1996-12-19",
    "id": "123e4567-e89b-12d3-a456-426655440000",
    "name": "Linda Mustermann"
  }
}
Hypertext controls are allowed anywhere within a JSON model. While this specification would allow HAL, we actually don't recommend/enforce the usage of HAL anymore as the structural separation of meta-data and data creates more harm than value to the understandability and usability of an API.

### Links in JSON Representations

    ## What about attribute names?

    In the previous section, we talked about formats - supporting multiple formats and working with JSON as the default.

    This time, let's talk about what happens when a response comes back.

    You have an object with data attributes on it. How should you name the attributes?

    Here are API responses from a few leading APIs:

    Twitter

    "created_at": "Thu Nov 03 05:19;38 +0000 2011"

    Bing

    "DateTime": "2011-10-29T09:35:00Z"

    Foursquare

    "createdAt": 1320296464

    They each use a different code convention. Although the Twitter approach is familiar to me as a Ruby on Rails developer, we think that Foursquare has the best approach.

    How does the API response get back in the code? You parse the response (JSON parser); what comes back populates the Object. It looks like this

    var myObject = JSON.parse(response);

    If you chose the Twitter or Bing approach, your code looks like this. Its not JavaScript convention and looks weird - looks like the name of another object or class in the system, which is not correct.

    timing = myObject.created_at;

    timing - myObject.DateTime;

    Recommendations

    * Use JSON as default

    * Follow JavaScript conventions for naming attributes

    - Use medial capitalization (aka CamelCase)

    - Use uppercase or lowercase depending on type of object

    This results in code that looks like the following, allowing the JavaScript developer to write it in a way that makes sense for JavaScript.

    "createdAt": 1320296464

    timing = myObject.createdAt;
- **DO** use a `link` property or a `links` property to include several links as an array whose value is a link object or a link object array.
- **DO** include `href` and `rel` properties in each link object

Examples:

```json
{
    "link": {
        "rel": "alternate",
        "href": "http://www.example.org/customers?format=json"
    }
}
```

```json
{
    "link": {
        "alternate": "http://www.example.org/customers?format=json"
    }
}
```

```json
{
    "links": [{
        "rel": "alternate",
        "href": "http://www.example.org/customers?format=json"
    },
    {
        "rel": "http://www.example.org/rels/owner",
        "href": "..."
    }]
}
```

```json
{
    "links": {
        "alternate": "http://www.example.org/customers?format=json"
        "http://www.example.org/rels/owner": "http://www.example.org/owner"
    }
}
```

### Link Header

The `Link` header provides a format-independent means to convey links, which is one of the key benefits, along with visibility at the protocol level. Also the need for documentation on how to discover links in XML or JSON representations is lowered.

```
# Link header format
Link: <{URI}>;rel="{relation}";type="{media type"};title="{title}"...
```

- **DO** use link header when you want to convey links in a format-independent manner
- **DO** use link header when a representation format does not support links. E.g.:
   - Binary format
   - Formats that do not allow for easy discovery of links (e.g., plain-text documents)
   - When your client/server software needs to add links or read links without parsing the body of representations

### Link Relation Types

- **ALWAYS** supply a link relation to act as an identifier for the semantics associated with the link
- **ALWAYS** use URIs (such as http://www.example.org/rels/create-po) to express extended link relation types
- **DO** choose unambiguous value of link relations
- **DO** use one of the [standard relation types](http://www.iana.org/assignments/link-relations/link-relations.xhtml), when appropriate
- **DO** use lowercase for all link relation types
- **DO** use multiple values in link relations, if applicable
- **CONSIDER** providing an informational resource as an HTML document at that URI, describing the semantics of the link relation type. Include details such as HTTP methods supported, formats supported, and business rules about using the link.

> Link relation types meant for public use should register that link relation per the process outlined in section 6.2 of the Web Linking Internet-Draft.

### Managing Application Flow with Links

One of the key applications of hypermedia and links is the ability to decouple the client from learning about the rules the server uses to manage its application flow. The server can provide links containing application state, thereby using Hypermedia As The Engine Of Application State.

This prevents clients from having to learn and hard-code application flow, however, the mere presence of a link will not decouple the client from having to know how to prepare the data and make a request for the transition.

- **DO** design representations such that it contain links that help clients transition to all the next possible steps
- **DO** encode the state that needs to be carried forward in the links
- **DO** document how to find links and the semantics of all extended link relation types.
- **DO**, for clients, assume that absent links means the transition is not possible.

## Ephemeral URIs

{>>Does this belong in Resource Identifiers?<<}

A URI may be temporary and valid only for a single use or may expire after a fixed period of time.

- **DO** communicate ephemeral URIs via links.
- **DO** assign extended relation types for those links and document how long such URIs are valid and what the client should do after expiry.
- **DO** return appropriate `4xx` code when responding to expired URIs, with an instructions in the body of any actions the client can take.

### URI Template

When the server does not have all the information necessary to generate a valid and complete URI for each link.

A URI template is a string consisting of token marked off between matching braces (`{` and `}`). Clients substitute these tokens (including matching braces) with URI-safe strings to convert the template into a valid URI.

For simplicity limit the tokens to the following parts of URIs:

- Path segments
- Values of query parameters
- Values of matrix parameters

To include URI templates in a representation:

- **DO** use `link-template` or `link-templates` properties to convey URI templates, for JSON representations.
- **DO** document the tokens used in you URI template, since URI templates are semi-opaque and contain tokens that clients need to substitute, and you need a way to tell clients what values are valid for each token.
- **CONSIDER** using braces (`{` and `}`) to specify replacement tokens, as this a common standard in a lot of other templating system (e.g., WSDL 2.0 and WADL.

```json
// JSON representation
{
    "link-templates": [{
        "rel": "http://www.example.org/rels/customer",
        "href": "http://www.example.org/customer/{customer-id}"
    }]
}
```
