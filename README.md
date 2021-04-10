# Melody Match
Final project for CS4550 (web dev)

## Meta
* Who was on your team?
  Brian Austin, Liam Brown, Emma Reed, Patricia Thompson
* What’s the URL of your deployed app?
  https://melody-match.baustin-neu.site
* What’s the URL of your github repository with the code for your
  deployed app? https://github.com/brianjaustin/melody-match
* Is your app deployed and working? Yes.
* For each team member, what work did that person do on the project?
  * Brian Austin - API and system design (backend), chat and
    matchmaking implementation (backend), deployment
  * Liam Brown - Concept, frontend design
  * Emma Reed - Concept, frontend implementation, matching algorithm
  * Patricia Thompson - Concept, REST API implementation (backend)

## App
* What does your project 2 app do?
  Our application is a service that matches users together based on
  the similarity of their most-played Spotify song and approximate 
  location. Once a match is
  found, the users can interact with each other via integrated chat.
  In addition, users can view their top songs from spotify account 
  via the "My Top Tracks" tab. They can also view all previous 
  matches and see the email of previous matches if they want to 
  continue talking off of the platform.
* How has your app concept changed since the proposal?
  Our application concept is the same as presented in the proposal.
  In terms of implementation details, location radius is configured
  as 500 km for all users, rather than configurable per user.
  Additionally, only users' top track is used (rather than an average)
  in order to simplify the matching algorithm.
* How do users interact with your application?
  What can they accomplish by doing so?
  Users interact with the application through the React frontend.
  Once a user has registered and logged in, they can find other
  currently-online users who have similar tastes in music and connect
  with them via chat.
* For each project requirement above, how does your app meet that
  requirement?
  * Persistent data - Spotify tokens, top track for each user,
                      user match history
  * External API - Spotify is used to access a user's top tracks and
    song analysis for those tracks
  * Channels - used for matchmaking and chat functionality
  * Something neat - access user location with the browser's
    location API and use it when making matches.
* What interesting stuff does your app include beyond the project
  requirements?
  * Custom matching algorithm for users, designed by Emma Reed
  * Swappable matcher implementations (useful for testing)
  * Match filtering based on location as reported by the user's
    browser via the location API
* What’s the complex part of your app? How did you design
  that component and why?
  The most complex aspect of our app is the matchmaker. It is
  implemented as a GenServer, similar to how the Bulls And Cows
  server was designed in homework 6. A name may be provided, which
  allows for future segmentation of matching based on some parameters
  (for example, whether the user's id is odd or not) in case of
  scalability issues. The matchmaker server then calls a matcher,
  which is configurable via the application configuration; this
  allows changing out the current matcher (based on Spotify data)
  to one that enables testing (any users match). To join the
  matchmaker, each user connects to a channel with their user ID;
  this allows us to broadcast to that channel when a match is found,
  as well as mitigate scaling concerns raised by having all users
  in a global matchmaking channel.
* What was the most significant challenge you encountered and how
  did you solve it?
  Because we developed the frontend and backend at the same time,
  we faced the challenge of how to use an API without the full
  implementation in place. To solve this, we first documented
  expected structure using OpenAPI, which allowed the creation
  of a mock backend using Mockserver. Unfortunately this was
  not possible for channels, so the channel implementations
  were completed prior to their integration with the frontend.

## Attributions
The following third-party libraries are employed by the backend:
* [not_qwerty123](https://github.com/riverrun/not_qwerty123) for
  password strength validation. This library falls under the
  MIT license.
* [mox](https://github.com/dashbitco/mox) for unit test mock
  implementations. This library falls under the Apache License,
  Version 2.0.
* [geocalc](https://github.com/yltsrc/geocalc) for location
  difference calculation. This library falls under the MIT licencse.

In addition to third-party libraries, we borrowed from Nat Tuck's 
[scratch-repo](https://github.com/NatTuck/scratch-2021-01) for 
support on redux and spa work, 
baustin's [hw06](https://github.com/brianjaustin/cs4550-hw06) repo
for support on sockets integration, Joe Karlsson's 
[article on Spotify integration](https://levelup.gitconnected.com/how-to-build-a-spotify-player-with-react-in-15-minutes-7e01991bc4b6)
for support on navigating the spotify API with the React framework,
bautstin's 
[events-spa](https://github.com/brianjaustin/cs4550-events-spa)
for support integrating the phoenix back-end with the react front-end
 and the 
[spotifriend-experiments](https://github.com/brianjaustin/spotifriend-experiments)
 for pulling in our initial proof of concept work.


