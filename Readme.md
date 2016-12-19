API Mashup!
===========

Initiate video chat (Twilio) from Slack.

NOTE: API here actually means "remote web service"


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


How it was implemented
----------------------

* First, I took other people's example code for the two APIs and got them working,
  that took about 45 minutes, but then I explored the Slack API for another 30 or so
  to see what I could do with it.
* Then I TDD'd the app's Slack integration, that took about an hour,
  mostly just for bootstrapping purposes.
* Did a more research into Slack and discovered it couldn't support the interaction
  I was initially intending (they only support replying back to the user, known as
  ephemeral mode, or replying to everyone, but do not allow you to make a message
  visible to only two users within a public chat, or to customize the display of
  the message for each user, hence when users click the link back to our site, we
  do not know who they are)
* Because of the above, the problem became more complicated, instead of two users,
  it meant that any number of users could click the link. So I thought of what
  felt like a simple-enough interface, one featured video (the person speaking to the group)
  with a list of available videos underneath (the other participants), user
  clicks the video they want to be featured.
* One of the reasons I typically avoid the frontend is I've not found a good way
  to test it (I typically go with Phantom, but it's not good for complex UI things).
  But I found out React can test entirely in the virtual DOM, so I went through
  some introductory React material, that was probably several hours.
* Then I coded an interface that seemed reasonable for what I wanted, I used
  `img` tags but tried to keep the interface pretty close to what Twilio presents
  based on the example app I found. Whe I had an interface that I liked (you can
  see it in examples/react-grid), I referenced https://github.com/applegrain/react-tdd-exercises
  and docs until I was able to get it tested). It was a pretty good experience,
  I wound up really liking React. That probably took 2 to 4 hours, but then I got
  caught up on the CSS for a while.
* I copied the experiment code into my main app and wired it in. There were some
  difficulties here, Twilio's video code [has a bug](https://github.com/twilio/twilio-video.js/issues/28)
  preventing it from working with React on NPM. When I curled the page to a local
  js file and require it, the `npm run build` script took between 2 and 3 minutes
  to run. Not going to cut it, given how many times I was going to need to build
  to get them working together. Eventually I moved the wiring JS out of React
  altogether so that it didn't need to know about Twilio. Sadly, that meant
  the wiring code coldn't be tested with React, at this point, I resigned that
  code to be untested.
* Spent a long time trying to resolve a bug where my browser was using 130% of
  the processor. I think it was a bug in Opera that I exacerbated because every
  React generates a lot of DOM elements, and I hadn't figured out how to get it
  to reuse the same video streams, so it was creating a large number of video
  streams, but you couldn't see that as a user. Firefox was stabler, so I made
  progress on Firefox until I eventually understood that this was the problem.
  On Opera, there may have been a memory error somewhere, because the processor
  stayed at 130% even after closing the page.
* One of the biggest issues with choosing this challenge was that I don't have
  a second computer. This was very limiting, because I counldn't systematically
  test what happens when differet users do different things. I had an okay
  workaround of rendering a local video stream twice, I'd written that code while
  debugging the processor spike. The downside is it doesn't go through and both
  streams use the same camera, so you can't check them based on what displays.
  When I got a friend to connect to it with me, I discovered several more bugs.
  In retrospect, I got the react code to render the video only once, but there
  were still issues with swapping out the featured video and with even seeing
  the other user in the channel. I think they were different faces of the same bug:
  The array of participants that comes back from Twilio is not an array. It has
  a `forEach` method, but as soon as you treat it like an array in any other way,
  it behaves incorrectly. This is nonobvious, until you have two different users.
  I spent enough time trying to figure it out that I eventually decided to just
  remove the react code and test none of the JavaScript.
* At that point, things were pretty smooth, but I'd completely blown my 4 hour
  goal. So I figured, since I'd blown it anyway, I'd at least take the time to
  make it something I was happy with. Improved some abstractions, improved the
  test suite, spent a bit more time on the CSS. Played with the Slack formatting API.
* That brings us here, I could definitely get the same result as what
  I have here in under 4 hours (exempting CSS). But this first-time effort wound
  up exceeding it.

Favourite things
----------------

* I discovered Ngrok, to make my local sever available publicly. That was amazing,
  I had to deploy to heroku between each effort while debugging the video, it was
  very expensive. Once I realized I could use Ngrok, they could connect directly
  to my server and iteration sped up by an order of magnitude. I even wound up
  using it to play with the Slack API, best part was being able to pry into the
  request and look at the `env` hash that Slack sent.
* React is way cooler than I thought it was. I'll have to look into the state of Elm
  these days, but React at least presents a viable JavaScript testing option.
  It also alleviates some of the difficulty of JavaScript's tendancy to not error
  when things go wrong, which is the biggest reasons I tend to shy from it.
* Twilio is amazing! Their APIs are well though out, and their example code is
  a blessing. They generall seem very developer oriented, even going as far as
  helping you decouple from their APIs so you can swap out things like their
  servers with your own if you need. Their docs site needs some love (I must have
  looked at it 5 times before I realized it had the information I needed) but
  since their code was open source, I was able to clone the repo and just reference
  their code to answer most of my questions.
* `create-react-app` is a really cool tool, it takes what would otherwise be a
  problematic amount of abstraction overhead and wires it up in a really reasonable
  set of defaults so that you can quickly get a viable React app going.
* Webpack is a really cool tool. It needs some interface love (its DSL is pretty
  incomprehensible to me, maybe better docs are the solution here, I'm not sure)
  I think react would only be fit for large endeavours if you had to wire all
  that stuff together yourself. Their dev server blows away everything like it
  that I've played with (Clojure's figwheel is probably comparable).

Conclusions I drew
------------------

* The Javascript community is doing awesome things
* Elm will encroach on JavaScript in the next 3 to 8 years.
  All the abstractions the JS community are putting into place in order to mitigate
  the pains of that environment will prime them for Elm. They're already transpiling,
  have sophisticated build tools, opt for immutability, have a syntax (JSX) that
  makes it natural to work with ADTs (Elm calls them Union types), there are
  multiple type systems being developed by big players in JS...  At some point
  the disparity will be so low Elm won't present any significant hurdles over
  what they're already doing. And since Elm does all these things better and
  with less baggage and moving parts, devs will start making that jump.
  It's probably not there yet, but it's really close.
* Slack needs to construct lower level abstractions for their API. They seem to
  implement each new feature in isolation, which leads to 4 or 5 largely overlapping
  capabilities. Instead of pushing the common functionality down to a lower API
  that can be used to build the higher level abilities, they exist largely in
  isolation. For example, ephemeral responses shouldn't be a thing, or if they are,
  should utilize a simpler lower level API that lets you specify who a message is visible to.
  Instead, you can show to everyone, or to only the sender. This makes the API
  complicated (confusing context based options) and doesn't allow any granularity
  between 1 and all, which precludes many apps. Eg, you can't post a link and
  customize it for each user, which is why you don't see usernames under the videos,
  you can't let people interact individually channel a channel, which is why you
  have to run `/videochat` from a direct message instead of being able to say
  `/videochat @user` in a public channel.
* CSS is hard >.<
* Feedback tools make the difference between success and failure. If I'd better
  understood how to use the React devtools, or could `binding.pry` in JavaScript,
  I probably would have saved a lot of hours and the React solution would have worked,
  which in turn would have allowed an arbitrary number of people to join rather
  than just two.
