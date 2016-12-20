API Mashup!
===========

Initiate video chat (Twilio) from Slack.

**See it at [slackbot-videochat.herokuapp.com](https://slackbot-videochat.herokuapp.com/)!**

NOTE: API here means "remote web service"
([here](list-of-apis.txt) is a list of possibilities).


User Story
----------

On Slack, Jan and Mei have the following conversation:

```
Jan: Hey, Mei, how did the client meeting go?
Mei: Too complicated to express in text, want to talk about it over lunch?
Jan: Can't, I'm WFH, videochat?
Mei: /videochat
Bot: @paddington invites you to videochat! (link)
```

They each click the link and wind up in a hangout/facetime-like video chat
where Mei and Jan sort out how to handle the client's situation.


Setup
-----

* Clone the repo
* Install Bundler if you don't have it: `gem install bundler`
* Install the gems: `bundle install`
* Run the tests: `rake`
* Launch the dev server: `rake serve`


Where to take it with more time
-------------------------------

* Allow multiple users
* Add mute and puase buttons
* Allow users to request a suffix `/videochats lunch-n-learn` to get a more meaningful URL
  Deal with potential URL collision by namespacing videochats under the team
  (they submit a token you can use to identify which slack team sent the request)
* Explore Slack more, I'm still not satisfied with how the user interacts with it
  (eg slash command is either only visible to the sender, or there is an awkward interaction
  where the command is visible to the channel, they designed it this way intentionally,
  but it feels very awkward)
* Generalize the bot so you can use it from other services than just Slack.
* Put React back in so that it can be tested
* Fallback to voice if video is not supported.
* Look into adding screensharing, I think I saw a web app do this once, so it's probably possible.
  Google Hangouts do it, but I think they wrote their own set of browser plugins to pull it off.
* Add video recording so that you could `/videochat record` (or something) and then
  it would post a link to your recorded video to the channel for others to watch later.
