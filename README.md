# 500px-showcase
Display the most popular photos from 500px, and allow users to log in and like them

# Implementation Decisions

## Encapsulating the 500px API
There are two states that it's possible to be in when interacting with the API. We're either authenticated (acting on behalf of a user with an OAuth token) or unauthenticated (no user logged in).

Both states are currently handled by a single class. There's only one API call that I've implemented that overlaps both states, and the parameters that that call takes and the data it returns are nearly identical (only difference is per user data about voting). Since the interface is consistent I feel that this decision doesn't create any confusion. If in the future I model more of the API and it's no longer possible to remain consistent then it would make sense to split this up.

I decided to make all of the unauthenticated API calls class methods since they don't require any state to be persisted. This includes loading the top 100 photos when the user is not logged in, as well as most of the OAuth calls needed to log in a user.

In contrast, an instance of FiveHundredPX represents a single logged in user. All of the instance methods authenticate to the API with a user's access_token. Making each user an object allows us to set the user's access_token as an attribute so we don't need to pass it to every API call. Even though this web app doesn't currently make more than a single API call per page, it's possible that some future version might be more complicated. Having each user as its own object would also simplify future workloads that might operate on multiple accounts at once.

Each user's access_token is stored as part of their session. This app doesn't perform any API requests in background jobs or without the user's interaction, so there's no need to store it in a database. The browser provides the session id with every request, so the access token will always be available when we need it.

## Layout / Design
Since this is a pretty simple web app, I've only used jQuery, along with bootstrap for the layout. If there were more components and state and actions to keep track of I might have opted for a framework like React/Flux.

The only state that changes is whether or not a specific photo has been liked/unliked, which is simple enough to keep track of. Liking/unliking a photo sends an AJAX request which returns javascript to update the state of the button.
