Introduction
If you’re reading this, chances are that you care about designing Web APIs that developers
will love and that you’re interested in applying proven design principles and best practices
to your Web API.
One of the sources for our design thinking is REST. Because REST is an architectural style
and not a strict standard, it allows for a lot of flexibly. Because of that flexibility and
freedom of structure, there is also a big appetite for design best practices.
This e-book is a collection of design practices that we have developed in collaboration with
some of the leading API teams around the world, as they craft their API strategy through a
design workshop that we provide at Apigee.
We call our point of view in API design “pragmatic REST”, because it places the success of
the developer over and above any other design principle. The developer is the customer for
the Web API. The success of an API design is measured by how quickly developers can get
up to speed and start enjoying success using your API.
We’d love your feedback – whether you agree, disagree, or have some additional practices
and tips to add. The API Craft Google Group is a place where Web API design enthusiasts
come together to share and debate design practices – we’d love to see you there.
Are you a Pragmatist or a RESTafarian?
Let’s start with our overall point of view on API design. We advocate pragmatic, not
dogmatic REST. What do we mean by dogmatic?
You might have seen discussion threads on true REST - some of them can get pretty strict
and wonky. Mike Schinkel sums it up well - defining a RESTafarian as follows:
“A RESTifarian is a zealous proponent of the REST software architectural style as defined by
Roy T. Fielding in Chapter 5 of his PhD. dissertation at UC Irvine. You can find RESTifarians in
the wild on the REST-discuss mailing list. But be careful, RESTifarians can be extremely
meticulous when discussing the finer points of REST …”
Our view: approach API design from the ‘outside-in’ perspective. This means we start by
asking - what are we trying to achieve with an API?
The API’s job is to make the developer as successful as possible. The orientation for APIs is
to think about design choices from the application developer’s point of view. 
Web API Design - Crafting Interfaces that Developers Love
4
Why? Look at the value chain below – the application developer is the lynchpin of the
entire API strategy. The primary design principle when crafting your API should be to
maximize developer productivity and success. This is what we call pragmatic REST.

You have to get the design right, because design communicates how something will be
used. The question becomes - what is the design with optimal benefit for the app
developer?
The developer point of view is the guiding principle for all the specific tips and best
practices we’ve compiled

Nouns are good; verbs are bad
The number one principle in pragmatic RESTful design is: keep simple things simple.
Keep your base URL simple and intuitive
The base URL is the most important design affordance of your API. A simple and intuitive
base URL design makes using your API easy.
Affordance is a design property that communicates how something should be used without
requiring documentation. A door handle's design should communicate whether you pull or
push. Here's an example of a conflict between design affordance and documentation - not
an intuitive interface!
Web API Design - Crafting Interfaces that Developers Love
5
A key litmus test we use for Web API design is that there should be only 2 base URLs per
resource. Let's model an API around a simple object or resource, a dog, and create a Web
API for it.
The first URL is for a collection; the second is for a specific element in the collection.
/dogs /dogs/1234
Boiling it down to this level will also force the verbs out of your base URLs.
Keep verbs out of your base URLs
Many Web APIs start by using a method-driven approach to URL design. These methodbased
URLs sometimes contain verbs - sometimes at the beginning, sometimes at the end.
For any resource that you model, like our dog, you can never consider one object in
isolation. Rather, there are always related and interacting resources to account for - like
owners, veterinarians, leashes, food, squirrels, and so on.
Web API Design - Crafting Interfaces that Developers Love
6
Think about the method calls required to address all the objects in the dogs’ world. The
URLs for our resource might end up looking something like this.
It's a slippery slope - soon you have a long list of URLs and no consistent pattern making it
difficult for developers to learn how to use your API.
Use HTTP verbs to operate on the collections and elements.
For our dog resources, we have two base URLs that use nouns as labels, and we can operate
on them with HTTP verbs. Our HTTP verbs are POST, GET, PUT, and DELETE. (We think of
them as mapping to the acronym, CRUD (Create-Read-Update-Delete).)
With our two resources (/dogs and /dogs/1234) and the four HTTP verbs, we have a
rich set of capability that's intuitive to the developer. Here is a chart that shows what we
mean for our dogs.
Web API Design - Crafting Interfaces that Developers Love
7
Resource POST
create
GET
read
PUT
update
DELETE
delete
/dogs Create a new
dog
List dogs Bulk update
dogs
Delete all dogs
/dogs/1234 Error Show Bo If exists update
Bo
If not error
Delete Bo
The point is that developers probably don't need the chart to understand how the API
behaves. They can experiment with and learn the API without the documentation.
In summary:
Use two base URLs per resource.
Keep verbs out of your base URLs.
Use HTTP verbs to operate on the collections and elements.

Plural nouns and concrete names
Let’s explore how to pick the nouns for your URLs.
Should you choose singular or plural nouns for your resource names? You'll see popular
APIs use both. Let's look at a few examples:
Foursquare GroupOn Zappos
/checkins /deals /Product
Given that the first thing most people probably do with a RESTful API is a GET, we think it
reads more easily and is more intuitive to use plural nouns. But above all, avoid a mixed
model in which you use singular for some resources, plural for others. Being consistent
allows developers to predict and guess the method calls as they learn to work with your
API.
Concrete names are better than abstract
Achieving pure abstraction is sometimes a goal of API architects. However, that abstraction
is not always meaningful for developers.
Take for example an API that accesses content in various forms - blogs, videos, news
articles, and so on.
An API that models everything at the highest level of abstraction - as /items or /assets
in our example - loses the opportunity to paint a tangible picture for developers to know
what they can do with this API. It is more compelling and useful to see the resources listed
as blogs, videos, and news articles.
The level of abstraction depends on your scenario. You also want to expose a manageable
number of resources. Aim for concrete naming and to keep the number of resources
between 12 and 24.
In summary, an intuitive API uses plural rather than singular nouns, and concrete rather
than abstract names.
Web API Design - Crafting Interfaces that Developers Love
9
Simplify associations - sweep complexity under the ‘?’
In this section, we explore API design considerations when handling associations between
resources and parameters like states and attributes.
Associations
Resources almost always have relationships to other resources. What's a simple way to
express these relationships in a Web API?
Let's look again at the API we modeled in nouns are good, verbs are bad - the API that
interacts with our dogs resource. Remember, we had two base URLs: /dogs and
dogs/1234.
We're using HTTP verbs to operate on the resources and collections. Our dogs belong to
owners. To get all the dogs belonging to a specific owner, or to create a new dog for that
owner, do a GET or a POST:
GET /owners/5678/dogs
POST /owners/5678/dogs
Now, the relationships can be complex. Owners have relationships with veterinarians, who
have relationships with dogs, who have relationships with food, and so on. It's not
uncommon to see people string these together making a URL 5 or 6 levels deep. Remember
that once you have the primary key for one level, you usually don't need to include the
levels above because you've already got your specific object. In other words, you shouldn't
need too many cases where a URL is deeper than what we have above
/resource/identifier/resource.
Sweep complexity behind the ‘?’
Most APIs have intricacies beyond the base level of a resource. Complexities can include
many states that can be updated, changed, queried, as well as the attributes associated with
a resource.
Make it simple for developers to use the base URL by putting optional states and attributes
behind the HTTP question mark. To get all red dogs running in the park:
GET /dogs?color=red&state=running&location=park
In summary, keep your API intuitive by simplifying the associations between resources,
and sweeping parameters and other complexities under the rug of the HTTP question
mark.
Web API Design - Crafting Interfaces that Developers Love
10
Handling errors
Many software developers, including myself, don't always like to think about exceptions
and error handling but it is a very important piece of the puzzle for any software developer,
and especially for API designers.
Why is good error design especially important for API designers?
From the perspective of the developer consuming your Web API, everything at the other
side of that interface is a black box. Errors therefore become a key tool providing context
and visibility into how to use an API.
First, developers learn to write code through errors. The "test-first" concepts of the
extreme programming model and the more recent "test driven development" models
represent a body of best practices that have evolved because this is such an important and
natural way for developers to work.
Secondly, in addition to when they're developing their applications, developers depend on
well-designed errors at the critical times when they are troubleshooting and resolving
issues after the applications they've built using your API are in the hands of their users.
How to think about errors in a pragmatic way with REST?
Let's take a look at how three top APIs approach it.
Facebook
HTTP Status Code: 200
{"type" : "OauthException", "message":"(#803) Some of the
aliases you requested do not exist: foo.bar"}
Twilio
HTTP Status Code: 401
{"status" : "401", "message":"Authenticate","code": 20003, "more
info": "http://www.twilio.com/docs/errors/20003"}
SimpleGeo
HTTP Status Code: 401
{"code" : 401, "message": "Authentication Required"}
Web API Design - Crafting Interfaces that Developers Love
11
Facebook
No matter what happens on a Facebook request, you get back the 200-status code -
everything is OK. Many error messages also push down into the HTTP response. Here they
also throw an #803 error but with no information about what #803 is or how to react to it.
Twilio
Twilio does a great job aligning errors with HTTP status codes. Like Facebook, they provide
a more granular error message but with a link that takes you to the documentation.
Community commenting and discussion on the documentation helps to build a body of
information and adds context for developers experiencing these errors.
SimpleGeo
SimpleGeo provides error codes but with no additional value in the payload.
A couple of best practices
Use HTTP status codes
Use HTTP status codes and try to map them cleanly to relevant standard-based codes.
There are over 70 HTTP status codes. However, most developers don't have all 70
memorized. So if you choose status codes that are not very common you will force
application developers away from building their apps and over to Wikipedia to figure out
what you're trying to tell them.
Therefore, most API providers use a small subset. For example, the Google GData API uses
only 10 status codes; Netflix uses 9, and Digg, only 8.
Google GData
200 201 304 400 401 403 404 409 410 500
Netflix
200 201 304 400 401 403 404 412 500
Digg
200 400 401 403 404 410 500 503
How many status codes should you use for your API?
When you boil it down, there are really only 3 outcomes in the interaction between an app
and an API:
• Everything worked - success
• The application did something wrong – client error
• The API did something wrong – server error
Web API Design - Crafting Interfaces that Developers Love
12
Start by using the following 3 codes. If you need more, add them. But you shouldn't need to
go beyond 8.
• 200 - OK
• 400 - Bad Request
• 500 - Internal Server Error
If you're not comfortable reducing all your error conditions to these 3, try picking among
these additional 5:
• 201 - Created
• 304 - Not Modified
• 404 – Not Found
• 401 - Unauthorized
• 403 - Forbidden
(Check out this good Wikipedia entry for all HTTP Status codes.)
It is important that the code that is returned can be consumed and acted upon by the
application's business logic - for example, in an if-then-else, or a case statement.
Make messages returned in the payload as verbose as possible.
Code for code
200 – OK
401 – Unauthorized
Message for people
{"developerMessage" : "Verbose, plain language description of
the problem for the app developer with hints about how to fix
it.", "userMessage":"Pass this message on to the app user if
needed.", "errorCode" : 12345, "more info":
"http://dev.teachdogrest.com/errors/12345"}
In summary, be verbose and use plain language descriptions. Add as many hints as your
API team can think of about what's causing an error.
We highly recommend you add a link in your description to more information, like Twilio
does.
Web API Design - Crafting Interfaces that Developers Love
13
Tips for versioning
Versioning is one of the most important considerations when designing your Web API.
Never release an API without a version and make the version mandatory.
Let's see how three top API providers handle versioning.
Twilio /2010-04-01/Accounts/
salesforce.com /services/data/v20.0/sobjects/Account
Facebook ?v=1.0
Twilio uses a timestamp in the URL (note the European format).
At compilation time, the developer includes the timestamp of the application when the
code was compiled. That timestamp goes in all the HTTP requests.
When a request arrives, Twilio does a look up. Based on the timestamp they identify the
API that was valid when this code was created and route accordingly.
It's a very clever and interesting approach, although we think it is a bit complex. For
example, it can be confusing to understand whether the timestamp is the compilation time
or the timestamp when the API was released.
Salesforce.com uses v20.0, placed somewhere in the middle of the URL.
We like the use of the v. notation. However, we don't like using the .0 because it implies
that the interface might be changing more frequently than it should. The logic behind an
interface can change rapidly but the interface itself shouldn't change frequently.
Facebook also uses the v. notation but makes the version an optional parameter.
This is problematic because as soon as Facebook forced the API up to the next version, all
the apps that didn't include the version number broke and had to be pulled back and
version number added.
Web API Design - Crafting Interfaces that Developers Love
14
How to think about version numbers in a pragmatic way with REST?
Never release an API without a version. Make the version mandatory.
Specify the version with a 'v' prefix. Move it all the way to the left in the URL so that it has
the highest scope (e.g. /v1/dogs).
Use a simple ordinal number. Don't use the dot notation like v1.2 because it implies a
granularity of versioning that doesn't work well with APIs--it's an interface not an
implementation. Stick with v1, v2, and so on.
How many versions should you maintain? Maintain at least one version back.
For how long should you maintain a version? Give developers at least one cycle to react
before obsoleting a version.
Sometimes that's 6 months; sometimes it’s 2 years. It depends on your developers'
development platform, application type, and application users. For example, mobile apps
take longer to rev’ than Web apps.
Should version and format be in URLs or headers?
There is a strong school of thought about putting format and version in the header.
Sometimes people are forced to put the version in the header because they have multiple
inter-dependent APIs. That is often a symptom of a bigger problem, namely, they are
usually exposing their internal mess instead of creating one, usable API facade on top.
That’s not to say that putting the version in the header is a symptom of a problematic API
design. It's not!
In fact, using headers is more correct for many reasons: it leverages existing HTTP
standards, it's intellectually consistent with Fielding's vision, it solves some hard realworld
problems related to inter-dependent APIs, and more.
However, we think the reason most of the popular APIs do not use it is because it's less fun
to hack in a browser.
Simple rules we follow:
If it changes the logic you write to handle the response, put it in the URL so you can see it
easily.
If it doesn't change the logic for each response, like OAuth information, put it in the header.
Web API Design - Crafting Interfaces that Developers Love
15
These for example, all represent the same resource:
dogs/1
Content-Type: application/json
dogs/1
Content-Type: application/xml
dogs/1
Content-Type: application/png
The code we would write to handle the responses would be very different.
There's no question the header is more correct and it is still a very strong API design.

Pagination and partial response
Partial response allows you to give developers just the information they need.
Take for example a request for a tweet on the Twitter API. You'll get much more than a
typical twitter app often needs - including the name of person, the text of the tweet, a
timestamp, how often the message was re-tweeted, and a lot of metadata.
Let's look at how several leading APIs handle giving developers just what they need in
responses, including Google who pioneered the idea of partial response.
LinkedIn
/people:(id,first-name,last-name,industry)
This request on a person returns the ID, first name, last name, and the industry.
LinkedIn does partial selection using this terse :(...) syntax which isn't self-evident.
Plus it's difficult for a developer to reverse engineer the meaning using a search engine.
Facebook
/joe.smith/friends?fields=id,name,picture
Google
?fields=title,media:group(media:thumbnail)
Google and Facebook have a similar approach, which works well.
They each have an optional parameter called fields after which you put the names of fields
you want to be returned.
As you see in this example, you can also put sub-objects in responses to pull in other
information from additional resources.
Add optional fields in a comma-delimited list
The Google approach works extremely well.
Here's how to get just the information we need from our dogs API using this approach:
/dogs?fields=name,color,location
It's simple to read; a developer can select just the information an app needs at a given time;
it cuts down on bandwidth issues, which is important for mobile apps.
Web API Design - Crafting Interfaces that Developers Love
17
The partial selection syntax can also be used to include associated resources cutting down
on the number of requests needed to get the required information.
Make it easy for developers to paginate objects in a database
It's almost always a bad idea to return every resource in a database.
Let's look at how Facebook, Twitter, and LinkedIn handle pagination. Facebook uses offset
and limit. Twitter uses page and rpp (records per page). LinkedIn uses start and count
Semantically, Facebook and LinkedIn do the same thing. That is, the LinkedIn start & count
is used in the same way as the Facebook offset & limit.
To get records 50 through 75 from each system, you would use:
• Facebook - offset 50 and limit 25
• Twitter - page 3 and rpp 25 (records per page)
• LinkedIn - start 50 and count 25
Use limit and offset
We recommend limit and offset. It is more common, well understood in leading databases,
and easy for developers.
/dogs?limit=25&offset=50
Metadata
We also suggest including metadata with each response that is paginated that indicated to
the developer the total number of records available.
What about defaults?
My loose rule of thumb for default pagination is limit=10 with offset=0.
(limit=10&offset=0)
The pagination defaults are of course dependent on your data size. If your resources are
large, you probably want to limit it to fewer than 10; if resources are small, it can make
sense to choose a larger limit.
Web API Design - Crafting Interfaces that Developers Love
18
In summary:
Support partial response by adding optional fields in a comma delimited list.
Use limit and offset to make it easy for developers to paginate objects

What about responses that don’t involve resources?
API calls that send a response that's not a resource per se are not uncommon depending on
the domain. We've seen it in financial services, Telco, and the automotive domain to some
extent.
Actions like the following are your clue that you might not be dealing with a "resource"
response.
Calculate
Translate
Convert
For example, you want to make a simple algorithmic calculation like how much tax
someone should pay, or do a natural language translation (one language in request;
another in response), or convert one currency to another. None involve resources returned
from a database.
In these cases:
Use verbs not nouns
For example, an API to convert 100 euros to Chinese Yen:
/convert?from=EUR&to=CNY&amount=100
Make it clear in your API documentation that these “non-resource” scenarios are
different.
Simply separate out a section of documentation that makes it clear that you use verbs in
cases like this – where some action is taken to generate or calculate the response, rather
than returning a resource directly.
Web API Design - Crafting Interfaces that Developers Love
20
Supporting multiple formats
We recommend that you support more than one format - that you push things out in one
format and accept as many formats as necessary. You can usually automate the mapping
from format to format.
Here's what the syntax looks like for a few key APIs.
Google Data
?alt=json
Foursquare
/venue.json
Digg*
Accept: application/json
?type=json
* The type argument, if present, overrides the Accept header.
Digg allows you to specify in two ways: in a pure RESTful way in the Accept header or in
the type parameter in the URL. This can be confusing - at the very least you need to
document what to do if there are conflicts.
We recommend the Foursquare approach.
To get the JSON format from a collection or specific element:
dogs.json
/dogs/1234.json
Developers and even casual users of any file system are familiar to this dot notation. It also
requires just one additional character (the period) to get the point across.
What about default formats?
In my opinion, JSON is winning out as the default format. JSON is the closest thing we have
to universal language. Even if the back end is built in Ruby on Rails, PHP, Java, Python etc.,
most projects probably touch JavaScript for the front-end. It also has the advantage of being
terse - less verbose than XML.
Web API Design - Crafting Interfaces that Developers Love
21
What about attribute names?
In the previous section, we talked about formats - supporting multiple formats and working
with JSON as the default.
This time, let's talk about what happens when a response comes back.
You have an object with data attributes on it. How should you name the attributes?
Here are API responses from a few leading APIs:
Twitter
"created_at": "Thu Nov 03 05:19;38 +0000 2011"
Bing
"DateTime": "2011-10-29T09:35:00Z"
Foursquare
"createdAt": 1320296464
They each use a different code convention. Although the Twitter approach is familiar to me
as a Ruby on Rails developer, we think that Foursquare has the best approach.
How does the API response get back in the code? You parse the response (JSON parser);
what comes back populates the Object. It looks like this
var myObject = JSON.parse(response);
If you chose the Twitter or Bing approach, your code looks like this. Its not JavaScript
convention and looks weird - looks like the name of another object or class in the system,
which is not correct.
timing = myObject.created_at;
timing - myObject.DateTime;
Recommendations
• Use JSON as default
• Follow JavaScript conventions for naming attributes
- Use medial capitalization (aka CamelCase)
- Use uppercase or lowercase depending on type of object
Web API Design - Crafting Interfaces that Developers Love
22
This results in code that looks like the following, allowing the JavaScript developer to write
it in a way that makes sense for JavaScript.
"createdAt": 1320296464
timing = myObject.createdAt;

Tips for search
While a simple search could be modeled as a resourceful API (for example,
dogs/?q=red), a more complex search across multiple resources requires a different
design.
This will sound familiar if you've read the topic about using verbs not nouns when results
don't return a resource from the database - rather the result is some action or calculation.
If you want to do a global search across resources, we suggest you follow the Google model:
Global search
/search?q=fluffy+fur
Here, search is the verb; ?q represents the query.
Scoped search
To add scope to your search, you can prepend with the scope of the search. For example,
search in dogs owned by resource ID 5678
/owners/5678/dogs?q=fluffy+fur
Notice that we’ve dropped the explicit search in the URL and rely on the parameter ‘q’ to
indicate the scoped query. (Big thanks to the contributors on the API Craft Google group for
helping refine this approach.)
Formatted results
For search or for any of the action oriented (non-resource) responses, you can prepend
with the format as follows:
/search.xml?q=fluffy+fur

Consolidate API requests in one subdomain
We’ve talked about things that come after the top-level domain. This time, let's explore
stuff on the other side of the URL.
Here's how Facebook, Foursquare, and Twitter handle this:
Facebook provides two APIs. They started with api.facebook.com, then modified it to orient
around the social graph graph.facebook.com.
graph.facebook.com
api.facebook.com
Foursquare has one API.
api.foursquare.com
Twitter has three APIs; two of them focused on search and streaming.
stream.twitter.com
api.twitter.com
search.twitter.com
It's easy to understand how Facebook and Twitter ended up with more than one API. It has
a lot to do with timing and acquisition, and it's easy to reconfigure a CName entry in your
DNS to point requests to different clusters.
But if we're making design decisions about what's in the best interest of app developer, we
recommend following Foursquare's lead:
Consolidate all API requests under one API subdomain.
It's cleaner, easier and more intuitive for developers who you want to build cool apps using
your API.
Facebook, Foursquare, and Twitter also all have dedicated developer portals.
developers.facebook.com
developers.foursquare.com
dev.twitter.com
How to organize all of this?
Your API gateway should be the top-level domain. For example, api.teachdogrest.com
Web API Design - Crafting Interfaces that Developers Love
24
In keeping with the spirit of REST, your developer portal should follow this pattern:
developers.yourtopleveldomain. For example,
developers.teachdogrest.com
Do Web redirects
Then optionally, if you can sense from requests coming in from the browser where the
developer really needs to go, you can redirect.
Say a developer types api.teachdogrest.com in the browser but there's no other
information for the GET request, you can probably safely redirect to your developer portal
and help get the developer where they really need to be.
api developers (if from browser)
dev  developers
developer  developers

Tips for handling exceptional behavior
So far, we've dealt with baseline, standard behaviors.
Here we’ll explore some of the exceptions that can happen - when clients of Web APIs
can't handle all the things we've discussed. For example, sometimes clients intercept HTTP
error codes, or support limited HTTP methods.
What are ways to handle these situations and work within the limitations of a specific
client?
When a client intercepts HTTP error codes
One common thing in some versions of Adobe Flash - if you send an HTTP response that is
anything other than HTTP 200 OK, the Flash container intercepts that response and puts
the error code in front of the end user of the app.
Therefore, the app developer doesn't have an opportunity to intercept the error code. App
developers need the API to support this in some way.
Twitter does an excellent job of handling this.
They have an optional parameter suppress_response_codes. If
suppress_response_codes is set to true, the HTTP response is always 200.
/public_timelines.json?
suppress_response_codes=true
HTTP status code: 200 {"error":"Could not authenticate you."}
Notice that this parameter is a big verbose response code. (They could have used
something like src, but they opted to be verbose.)
This is important because when you look at the URL, you need to see that the response
codes are being suppressed as it has huge implications about how apps are going to
respond to it.
Overall recommendations:
1 - Use suppress_response_codes = true
2 - The HTTP code is no longer just for the code
The rules from our previous Handling Errors section change. In this context, the HTTP code
is no longer just for the code - the program - it's now to be ignored. Client apps are never
going to be checking the HTTP status code, as it is always the same.
Web API Design - Crafting Interfaces that Developers Love
26
3 - Push any response code that we would have put in the HTTP response down into the
response message
In my example below, the response code is 401. You can see it in the response message.
Also include additional error codes and verbose information in that message.
Always return OK
/dogs?suppress_response_codes = true
Code for ignoring
200 - OK
Message for people & code
{response_code" : 401, "message" : "Verbose, plain language
description of the problem with hints about how to fix it."
"more_info" : "http://dev.tecachdogrest.com/errors/12345",
"code" : 12345}
When a client supports limited HTTP methods
It is common to see support for GET and POST and not PUT and DELETE.
To maintain the integrity of the four HTTP methods, we suggest you use the following
methodology commonly used by Ruby on Rails developers:
Make the method an optional parameter in the URL.
Then the HTTP verb is always a GET but the developer can express rich HTTP verbs and
still maintain a RESTful clean API.
Create
/dogs?method=post
Read
/dogs
Update
/dogs/1234?method=put&location=park
Delete
/dogs/1234?method=delete
WARNING: It can be dangerous to provide post or delete capabilities using a GET method
because if the URL is in a Web page then a Web crawler like the Googlebot can create or
destroy lots of content inadvertently. Be sure you understand the implications of supporting
this approach for your applications' context.
Web API Design - Crafting Interfaces that Developers Love

Authentication
There are many schools of thought. My colleagues at Apigee and I don't always agree on
how to handle authentication - but overall here's my take.
Let's look at these three top services. See how each of these services handles things
differently:
PayPal
Permissions Service API
Facebook
OAuth 2.0
Twitter
OAuth 1.0a
Note that PayPal's proprietary three-legged permissions API was in place long before
OAuth was conceived.
What should you do?
Use the latest and greatest OAuth - OAuth 2.0 (as of this writing). It means that Web or
mobile apps that expose APIs don’t have to share passwords. It allows the API provider to
revoke tokens for an individual user, for an entire app, without requiring the user to
change their original password. This is critical if a mobile device is compromised or if a
rogue app is discovered.
Above all, OAuth 2.0 will mean improved security and better end-user and consumer
experiences with Web and mobile apps.
Don't do something *like* OAuth, but different. It will be frustrating for app developers if
they can't use an OAuth library in their language because of your variation.

Chatty APIs
Let’s think about how app developers use that API you're designing and dealing with chatty
APIs.
Imagine how developers will use your API
When designing your API and resources, try to imagine how developers will use it to say
construct a user interface, an iPhone app, or many other apps.
Some API designs become very chatty - meaning just to build a simple UI or app, you have
dozens or hundreds of API calls back to the server.
The API team can sometimes decide not to deal with creating a nice, resource-oriented
RESTful API, and just fall back to a mode where they create the 3 or 4 Java-style getter and
setter methods they know they need to power a particular user interface.
We don't recommend this. You can design a RESTful API and still mitigate the chattiness.
Be complete and RESTful and provide shortcuts
First design your API and its resources according to pragmatic RESTful design principles
and then provide shortcuts.
What kind of shortcut? Say you know that 80% of all your apps are going to need some sort
of composite response, then build the kind of request that gives them what they need.
Just don't do the latter instead of the former. First design using good pragmatic RESTful
principles!
Take advantage of the partial response syntax
The partial response syntax discussed in a previous section can help.
To avoid creating one-off base URLs, you can use the partial response syntax to drill down
to dependent and associated resources.
In the case of our dogs API, the dogs have association with owners, who in turn have
associations with veterinarians, and so on. Keep nesting the partial response syntax using
dot notation to get back just the information you need.
/owners/5678?fields=name,dogs.name

Complement with an SDK
It’s a common question for API providers - do you need to complement your API with code
libraries and software development kits (SDKs)?
If your API follows good design practices, is self consistent, standards-based, and well
documented, developers may be able to get rolling without a client SDK. Well-documented
code samples are also a critical resource.
On the other hand, what about the scenario in which building a UI requires a lot of domain
knowledge? This can be a challenging problem for developers even when building UI and
apps on top of APIs with pretty simple domains – think about the Twitter API with it’s
primary object of 140 characters of text.
You shouldn't change your API to try to overcome the domain knowledge hurdle. Instead,
you can complement your API with code libraries and a software development kit (SDK).
In this way, you don't overburden your API design. Often, a lot of what's needed is on the
client side and you can push that burden to an SDK.
The SDK can provide the platform-specific code, which developers use in their apps to
invoke API operations - meaning you keep your API clean.
Other reasons you might consider complementing your API with an SDK include the
following:
Speed adoption on a specific platform. (For example Objective C SDK for iPhone.)
Many experienced developers are just starting off with objective C+ so an SDK might be
helpful.
Simplify integration effort required to work with your API - If key use cases are
complex or need to be complemented by standard on-client processing.
An SDK can help reduce bad or inefficient code that might slow down service for
everyone.
As a developer resource - good SDKs are a forcing function to create good source code
examples and documentation. Yahoo! and Paypal are good examples:
Yahoo! http://developer.yahoo.com/social/sdk/
Paypal https://cms.paypal.com/us/cgi-bin/?cmd=_rendercontent&content_ID=developer/library_download_sdks
To market your API to a specific community - you upload the SDK to a samples or plugin
page on a platform’s existing developer community.







---

# Hypermedia

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

# The HATEOAS Debate

Currently, there is a lot of disagreement around hypermedia's place in RESTful APIs– with Dr. Roy Fielding saying it is critical to REST, and without it your API cannot be RESTful; and hypermedia skeptics arguing that you are doing nothing more than bloating your API and making it more difficult to use under the guise of usability.
This means you will find many different stances on the web today, ranging from Peter Williams explanation of how hypermedia has helped him, Jeff Krupp's rant against hypermedia, and even Kin Lane's summary of the whole debate.
But what it really comes down to isn't what do others think about hypermedia, as most major frameworks for building APIs now include hypermedia specs such as HAL, JSON-LD, JSON API, Siren, or Collection+JSON, but rather what benefit does hypermedia offer- and is that benefit enough to outweigh the cost/ disadvantages of incorporating hypermedia.

# The Claims For and Against Hypermedia

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

One of the reasons for this, is even if you have a purely hypermedia driven API, such as Stormpath‘s, developers will still hardcode certain URLs to avoid having to make multiple calls.

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

# The Harsh Reality of the State of Hypermedia Specs

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

# Specs

What essentially every hypertext linking spec does provide is a name for the link and a hypertext reference, but outside of that, it's a crapshoot.

As such, it's important to understand the different specs that are out there, which ones are leading the industry, and which ones meet your needs.

We may not be able to get it down to one spec, but at least we'll be able to provide our users with a uniform response that they can easily incorporate into their application:

### Collection+JSON

Collection+JSON is a JSON-based read/write hypermedia-type designed by Mike Amundsen back in 2011 to support the management and querying of simple collections.

It's based on the Atom Publication and Syndication specs, defining both in a single spec and supporting simple queries through the use of templates.

While originally widely used among APIs, Collection+JSON has struggled to maintain its popularity against JSON API and HAL.
Strengths: strong choice for collections, templated queries, early wide adoption, recognized as a standard Weaknesses: JSON only, lack of identifier for documentation, more complex/ difficult to implement

### JSON API

JSON API is a newer spec created in 2013 by Steve Klabnik and Yahuda Klaz.

It was designed to ensure separation between clients and servers (an important aspect of REST) while also minimizing the number of requests without compromising readability, flexibility, or discovery.

JSON API has quickly become a favorite receiving wide adoption and is arguably one of the leading specs for JSON based RESTful APIs.

JSON API currently bares a warning that it is a work in progress, and while widely adopted not necessarily stable.
Strengths: simple versatile format, easy to read/ implement, flat link grouping, URL templating, wide adoption, strong community, recognized as a hypermedia standard
Weaknesses: JSON only, lack of identifier for documentation, still a work in progress

### HAL

HAL is an older spec, created in 2011 by Mike Kelly to be easily consumed across multiple formats including XML and JSON.

One of the key strengths of HAL is that it is nestable, meaning that _links can be incorporated within each item of a collection.

HAL also incorporates CURIEs, a feature that makes it unique in that it allows for inclusion of documentation links in the response – albeit they are tightly coupled to the link name.

HAL is one of the most supported and most widely used hypermedia specs out there today, and is surrounded by a strong and vocal community.
Strengths: dynamic, nestable, easy to read/ implement, multi-format, URL templating, inclusion of documentation, wide adoption, strong community, recognized as a standard hypermedia spec, RFC proposed Weaknesses: JSON/XML formats architecturally different, CURIEs are tightly coupled

### JSON-LD

JSON-LD is a lightweight spec focused on machine to machine readable data.

Beyond just RESTful APIs, JSON-LD was also designed to be utilized within non-structured or NoSQL databases such as MongoDB or CouchDB.

Developed by the W3C JSON-LD Community group, and formally recommended by W3C as a JSON data linking spec in early 2014, the spec has struggled to keep pace with JSON API and HAL.

However, it has built a strong community around it with a fairly active mailing list, weekly meetings, and an active IRC channel.
Strengths: strong format for data linking, can be used across multiple data formats (Web API & Databases), strong community, large working group, recognized by W3C as a standard
Weaknesses: JSON only, more complex to integrate/ interpret, no identifier for documentation

### Siren

Created in 2012 by Kevin Swiber, Siren is a more descriptive spec made up of classes, entities, actions, and links.

It was designed specifically for Web API clients in order to communicate entity information, actions for executing state transitions, and client navigation/ discoverability within the API.

Siren was also designed to allow for sub-entities or nesting, as well as multiple formats including XML – although no example or documentation regarding XML usage is provided.

Despite being well intentioned and versatile, Siren has struggled to gain the same level of attention as JSON API and HAL.

Siren is still listed as a work in progress.
Strengths: provides a more verbose spec, query templating, incorporates actions, multi-format
Weaknesses: poor adoption, lacks documentation, work in progress

### Other Specs

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

### MUST: Use REST Maturity Level 2

We strive for a good implementation of REST Maturity Level 2 as it enables us to build resource-oriented APIs that make full use of HTTP verbs and status codes. You can see this expressed by many rules throughout these guidelines, e.g.:

Avoid Actions — Think About Resources
Keep URLs Verb-Free
Use HTTP Methods Correctly
Use Meaningful HTTP Status Codes
Although this is not HATEOAS, it should not prevent you from designing proper link relationships in your APIs as stated in rules below.

### MAY: Use REST Maturity Level 3 - HATEOAS

We do not generally recommend to implement REST Maturity Level 3. HATEOAS comes with additional API complexity without real value in our SOA context where client and server interact via REST APIs and provide complex business functions as part of our e-commerce SaaS platform.

Our major concerns regarding the promised advantages of HATEOAS (see also RESTistential Crisis over Hypermedia APIs, Why I Hate HATEOAS and others):

We follow the API First principle with APIs explicitly defined outside the code with standard specification language. HATEOAS does not really add value for SOA client engineers in terms of API self-descriptiveness: a client engineer finds necessary links and usage description (depending on resource state) in the API reference definition anyway.
Generic HATEOAS clients which need no prior knowledge about APIs and explore API capabilities based on hypermedia information provided, is a theoretical concept that we haven't seen working in practise and does not fit to our SOA set-up. The OpenAPI description format (and tooling based on OpenAPI) doesn't provide sufficient support for HATEOAS either.
In practice relevant HATEOAS approximations (e.g. following specifications like HAL or JSON API) support API navigation by abstracting from URL endpoint and HTTP method aspects via link types. So, Hypermedia does not prevent clients from required manual changes when domain model changes over time.
Hypermedia make sense for humans, less for SOA machine clients. We would expect use cases where it may provide value more likely in the frontend and human facing service domain.
Hypermedia does not prevent API clients to implement shortcuts and directly target resources without 'discovering' them
However, we do not forbid HATEOAS; you could use it, if you checked its limitations and still see clear value for your usage scenario that justifies its additional complexity. If you use HATEOAS please share experience and present your findings in the API Guild [internal link].

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

### SHOULD:: Use Simple Hypertext Controls for Pagination and Self-References

Hypertext controls for pagination inside collections and self-references should use a simple URI value in combination with their corresponding link relations (next, prev, first, last, self) instead of the extensible common hypertext control

See Pagination for information how to best represent paginateable collections.

### MUST: Not Use Link Headers with JSON entities

We don't allow the use of the Link Header defined by RFC 5988 in conjunction with JSON media types. We prefer links directly embedded in JSON payloads to the uncommon link header syntax.

### MUST: Follow Hypertext Control Conventions

APIs that provide hypertext controls (links) to interconnect API resources must follow the conventions for naming and modeling of hypertext controls as defined in section Hypermedia.
