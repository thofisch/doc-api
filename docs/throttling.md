# Throttling

Throttling and rate limiting is not necessarily a bad thing. By throttling your API and setting up different SLA tiers you are able to help prevent abuse – often times completely accidental. This means that your API is able to operate optimally for all of your users, instead of having one infinite loop bring it crashing down for everyone.

You may have partners that need more calls than others, or who the limits do not make sense for. By setting up SLA tiers based on your standard API user's needs, and then creating partner tiers, you can easily give the the permissions they need, while limiting the standard user to prevent abuse.

The API key, or unique identifier for an user's application also helps you identify who your heavier users are – letting you get in contact with them to make sure their needs are being met, while also learning more about how they are using your API.

!!! info "Rate limiting (Twitter-style)"
    * X-Rate-Limit-Limit - The number of allowed requests in the current period
    * X-Rate-Limit-Remaining - The number of remaining requests in the current period
    * X-Rate-Limit-Reset - The number of seconds left in the current period

## MUST: Use 429 with Headers for Rate Limits

APIs that wish to manage the request rate of clients must use the '429 Too Many Requests' response code if the client exceeded the request rate and therefore the request can't be fulfilled. Such responses must also contain header information providing further details to the client. There are two approaches a service can take for header information:

Return a 'Retry-After' header indicating how long the client ought to wait before making a follow-up request. The Retry-After header can contain a HTTP date value to retry after or the number of seconds to delay. Either is acceptable but APIs should prefer to use a delay in seconds.

Return a trio of 'X-RateLimit' headers. These headers (described below) allow a server to express a service level in the form of a number of allowing requests within a given window of time and when the window is reset.

The 'X-RateLimit' headers are:

X-RateLimit-Limit: The maximum number of requests that the client is allowed to make in this window.
X-RateLimit-Remaining: The number of requests allowed in the current window.
X-RateLimit-Reset: The relative time in seconds when the rate limit window will be reset.
The reason to allow both approaches is that APIs can have different needs. Retry-After is often sufficient for general load handling and request throttling scenarios and notably, does not strictly require the concept of a calling entity such as a tenant or named account. In turn this allows resource owners to minimise the amount of state they have to carry with respect to client requests. The 'X-RateLimit' headers are suitable for scenarios where clients are associated with pre-existing account or tenancy structures. 'X-RateLimit' headers are generally returned on every request and not just on a 429, which implies the service implementing the API is carrying sufficient state to track the number of requests made within a given window for each named entity.

