
## Security

    <!-- TODO -->

    ## Security

    ### MUST: Secure Endpoints with OAuth 2.0

    <!--
    Out-of-band authentication
    CORS

    Use Access and Refresh Tokens
        Access Tokens
        Refresh Tokens
        Logging In
        Renewing a Token
        Validating a Token
        Terminating a Session
        Keep JWTs Small

    Always use SSL. No exceptions. One thing to watch out for is non-SSL access to API URLs. Do not redirect these to their SSL counterparts. Throw a hard error instead!

    A RESTful API should be stateless. This means that request authentication should not depend on cookies or sessions. Instead, each request should come with some sort authentication credentials.

    -->

    # Security.

    Security.

    Security.
    An API Manager should also be designed to handle security, not just by validating a boarding pass (API key) and directing them to their appropriate gate (permissions, SLA tier), but your API Manager should watch out for other dangerous threats, such as malicious IPs, DDoS, content threats (such as with JSON or XML), and others.
    It should also be designed to work with your current user validation systems such as OAuth2 to help protect your user's sensitive data (such as their username and password) within your API.

     Keep in mind that even the most righteous of applications are still prone to being hacked – and if they have access to your user's sensitive data, that means that hackers might get access to it too.

     It's always better to never have your users expose their credentials through the API (such as with basic auth) but instead rely on your website to handle logins and then return back an access token as OAuth2 does.

    ## But... Security is Hard

    One of my favorite talks, by Anthony Ferrara sums this up very nicely...  Don't do it.

     Leave it for the Experts.

     Granted, his talk was specifically on encryption, but there's a lot of careful thought, planning, and considerations that need to be taken when building an API Management tool.

     You can certainly build it yourself, and handling API keys or doing IP white-listing/ black-listing is fairly easy to do.

     However, like an airport, what you don't see is all of the stuff happening in the background, all the things being monitored carefully, security measures implemented by experts with years of experience in risk mitigation.
    For that reason, as tempting as it might be to build one yourself, I would strongly encourage you to take a look at a professional API Management company- such as MuleSoft (of course, I might be a little biased).

    ## Authentication

    There are many schools of thought. My colleagues at Apigee and I don't always agree on how to handle authentication - but overall here's my take.

    Let's look at these three top services. See how each of these services handles things differently:

    PayPal

    Permissions Service API

    Facebook

    OAuth 2.0

    Twitter

    OAuth 1.0a

    Note that PayPal's proprietary three-legged permissions API was in place long before OAuth was conceived.

    What should you do?

    Use the latest and greatest OAuth - OAuth 2.0 (as of this writing). It means that Web or mobile apps that expose APIs don't have to share passwords. It allows the API provider to revoke tokens for an individual user, for an entire app, without requiring the user to change their original password. This is critical if a mobile device is compromised or if a rogue app is discovered.

    Above all, OAuth 2.0 will mean improved security and better end-user and consumer experiences with Web and mobile apps.

    Don't do something *like* OAuth, but different. It will be frustrating for app developers if they can't use an OAuth library in their language because of your variation.

## Security

Securing may require:
- ensure that only authenticated users access resources
- ensure the condidentiality and integrity of information right from the moment it is collected until the time it is stored and later presented to authorized entities or users.
- prevent unauthorized or malicious clients from abusing resources and data.
- maintain privacy, and follow the laws of the land that govern various security aspects.

How to use Basic Authentication to Authenticate Clients

- return `401 Authorization Required` along with a `WWW-Authenticate: Basic realm="Some name"`.

On the client, concatenate the client identifier (a username if the client is making a request on behalf of a user) and the shared secret (password) as `<identifier>:<secret>` and then compute the Base64 encoding on this text. Include the value in the `Authorization: Basic <Base64 encoded value`. On the server decode the text and verify the values.

Do not use basic authentication unless using TLS to connect to the server.

How to use Three-Legged OAuth
How to use Two-Legged OAuth
How to Deal with Sensitive Information in URIs

How to Maintain the Confidentiality and Integrity of Representations

    use TLS and make resource accessible over a server configured to serve request only using HTTPS.


