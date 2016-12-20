API Mashup!
===========

Initiate video chat (Twilio) from Slack.

See it at [slackbot-videochat.herokuapp.com](slackbot-videochat.herokuapp.com)!

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


How it was implemented
----------------------

* First, I took other people's example code for the two APIs and got them working,
  that took about 45 minutes, but then I explored the Slack API for another 30 or so
  to see what I could do with it.
* Then I TDD'd the app's Slack integration, that took about an hour,
  mostly just due to initial bootstrapping.
* Did more research into Slack and discovered it couldn't support the interaction
  I had planned. They only support replying back to the user, known as
  ephemeral mode, or replying to everyone, but do not allow you to make a message
  visible to only two users within a public chat.
* Because of the above, the problem became more complicated, instead of two users,
  it meant that any number of users could click the link. So I thought of what
  seemed like a simple-enough interface: one larger featured video (the person speaking to the group)
  with a list of available videos underneath (the other participants),
  when the user clicks a video, it becomes featured.
* One of the reasons I typically avoid the frontend is I've not found a good way
  to test it (I typically go with Phantom, but it's not good for complex UI things).
  But I found out React can test entirely in its virtual DOM, so I went through
  some introductory React material, that was probably several hours.
* Then I coded an interface that seemed reasonable for what I wanted, I used
  `img` tags but tried to keep the interface pretty close to what Twilio presents.
  Once I had an interface that I liked (you can see it in examples/react-grid),
  I figured out how to test it so I could be confident in its behaviour.
  It was a pretty good experience, I wound up really liking React.
  That probably took 2 to 4 hours, but then I got caught up on the CSS for quite a while.
* I copied the experiment code into my main app and wired it in. There were some
  difficulties here, Twilio's video code [has a bug](https://github.com/twilio/twilio-video.js/issues/28)
  preventing it from working with React on NPM. When I curled the page to a local
  js file and require it, the `npm run build` script took between 2 and 3 minutes
  to run. Not going to cut it, given how many times I was going to need to build
  to get them working together. Eventually I moved the wiring into the HTML's JS,
  out of React altogether so that it didn't need to know about Twilio.
  Sadly, that meant the wiring code coldn't be tested with React, at this point,
  I conceded that this code would just not be tested.
* Spent a long time trying to resolve a bug where my browser was using 130% of
  the processor, even after closing the page.  I think it is a bug in Opera,
  I didn't get it fixed, but found that Firefox works correctly.
  stayed at 130% even after closing the page.
* I spent a while fixing a React bug where it was generating a lot of DOM elements,
  and not reusing the same video streams. Causing noticeable performance issues.
* One of the biggest issues with choosing this challenge was that I don't have
  a second computer. This was very limiting, because I counldn't systematically
  test what happens when differet users do different things. I had an okay
  workaround of rendering a local video stream twice, I'd written that code while
  debugging the processor spike. The downside is it doesn't go through and both
  streams use the same camera, so you can't check them based on what displays.
  When I got a friend to connect to it with me, I discovered several more bugs.
  I did get the React code to render the video only once, but there
  were still issues with swapping out the featured video and with even seeing
  the other user in the channel. I think they were different faces of the same bug:
  The array of participants that comes back from Twilio is not an array. It has
  a `forEach` method, but as soon as you treat it like an array in any other way,
  it behaves incorrectly. This is nonobvious, until you have two different users.
  I spent enough time trying to figure it out that I eventually decided to just
  remove React and not test the JavaScript.
* At that point, things were pretty smooth, but I'd completely blown my 4 hour
  goal. So I figured, since I'd blown it anyway, I'd at least take the time to
  make it something I was happy with. Improved some abstractions, improved the
  test suite, spent a bit more time on the CSS. Played with the Slack formatting API.
* That brings us here, I can definitely get the same result as what
  I now have here in under 4 hours (exempting CSS).
  But this first-time effort wound up exceeding it.

Favourite things
----------------

* I discovered Ngrok, to make my local sever available publicly. That was amazing,
  I had to deploy to heroku between each effort while debugging the video, it was
  very expensive. Once I realized I could use Ngrok, they could connect directly
  to my server and iteration sped up by an order of magnitude. I even wound up
  using it to play with the Slack API, best part was being able to pry into the
  request and look at the `env` hash for Slack's web hooks.
* React is way cooler than I thought it was. I'll have to look into the state of Elm
  these days, but React at least presents a viable JavaScript testing option.
  It also alleviates some of the difficulty of JavaScript's tendancy to not error
  when things go wrong, which is the biggest reasons I tend to shy from it.
* Twilio is amazing! Their APIs are well though out, and their example code is
  a blessing. They generally seem very developer oriented, even going as far as
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
  I think React would only be fit for large endeavours if you had to wire all
  that stuff together yourself. Their dev server blows away everything like it
  that I've played with (Clojure's figwheel is probably comparable).
