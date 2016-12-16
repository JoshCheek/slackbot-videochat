API Mashup!
===========

Initiate video chat (Twilio) from Slack.

NOTE: API here actually means "remote web service"


Choosing this mashup
--------------------

Started by looking up a bunch of APIs to see what I have to work with
(see [apis.txt](apis.txt)). Came up with a bunch of ideas and narrowed it
down to 3 main candidates (see [ideate.md](ideate.md)).

Chose "Initiate video chat from Slack" based on this criteria:

* Interestingness / funness (bots seem fun)
* Non-annoyingness (no OAuth, one interaction with each API... though the JS could get annoying)
* I could do a good job with my current knowledge (I've seen people integrate with each of these, and it didn't seem difficult)
* Won't take much time (fewest moving pieces of the 3 final candidates)

Additionally, Michael's feedback on the 3 possibilities:

> The Dropbox to s3 looks cool, but video chat would probably look impressive. I think both would be good so choose the one that you're most excited about.


User Story
----------

On Slack, Jan and Mei have the following conversation:

```
Jan: Hey, Mei, how did the client meeting go?
Mei: Too complicated to express in text, want to talk about it over lunch?
Jan: Can't, I'm WFH, videochat?
Mei: videochat: Jan
Bot: Chat at http://videochat.example.com/j8n3fo1
```

They each click the link and wind up in a hangout/facetime-like video chat
where Mei and Jan sort out how to handle the client's situation.


Expected procedure
------------------

* Get the videochat example working
* Get a slack bot to echo at you (it's a webapp, IIRC)
* When notified by Slack of a chat, generate a random string for its id, send back a link to that chat
  The purpose of the random string is to "namespace" chats so that there can be more than one at a time.
* When users click the link, they get dropped on a page that's pretty similar to the example,
  except get rid of the chatroom, restrict participants to 2, and it looked like the example was 1
  person broadcasting, so we'll just need to do that two times.
* How do you test this page? Uhm.... Mock out Twilio, maybe?

---------------

- [x] 1 hour: Get the examples passing (3:43 - 4:38) [video is here](https://www.livecoding.tv/joshcheek/videos/BM9mV-tell-me-what-to-code-killing-15-min-21)
- [ ] 1 hour: Code the real chatbot
- [ ] 2 hours: Twilio integration
