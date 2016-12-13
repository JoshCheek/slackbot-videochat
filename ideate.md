Ideate
======

Based on the apis in [apis.txt](apis.txt), come up with
a bunch of ideas for API mashups.


Idea 1: Initiate video chat from Slack
--------------------------------------

**Integrates Slack and Twilio.**

* Looks easy to setup video chat https://github.com/TwilioDevEd/video-quickstart-ruby
* Looks easy to integrate with Slack https://api.slack.com/slash-commands

**User Story**

```
Jan: Hey, Mei, how did the client meeting go?
Mei: Too complicated to express in text, want to talk about it over lunch?
Jan: Can't, I'm WFH, videochat?
Mei: /videochat Jan
Bot: Chat at http://videochat.example.com/j8n3fo1
```

They each click the link and wind up in a hangout/facetime-like video chat.

**Expected procedure**

* Get the videochat example working
* Get a slack bot to echo at you (it's a webapp, IIRC)
* When notified by Slack of a chat, generate a random string for its id, send back a link to that chat
  The purpose of the random string is to "namespace" chats so that there can be more than one at a time.
* When users click the link, they get dropped on a page that's pretty similar to the example,
  except get rid of the chatroom, restrict participants to 2, and it looked like the example was 1
  person broadcasting, so we'll just need to do that two times.
* How do you test this page? Uhm.... Mock out Twilio, maybe?


Idea 2: Migrate Dropbox to S3
-----------------------------

**Integrates Dropbox and S3**

* Dropbox may be annoying to integrate with: https://www.dropbox.com/developers/documentation/http/documentation
  The [gem](https://rubygems.org/gems/dropbox) might not be too bad.
* IIRC, S3 isn't too hard to integrate with, it's also got a [gem](https://rubygems.org/gems/s3).

I've been contemplating doing this recently, so it scratches an itch I already have.

**User Story**

* Visit dropbox-to-s3.example.com
* Click the link to oauth with Dropbox
* Submit whatever S3 requires in order to integrate (user may have to go make that info)
* Click "Import"
* Would be nice to see some sort of progress indicator

**Expected procedure**

* Make an app that oauths w/ Dropbox
* Make an example of how to query dropbox info (a folder and a file)
* Make an example of how to make a dir and upload a file to S3
* TDD the user interface
* When they click "Import", spin off a worker to recursively traverse the Dropbox file heirarchy and emit files to be uploaded
* Another worker sees a file to be uploaded and uploads it to S3
* IDK for the progress bar, maybe ActionCable or maybe write it in JavaScript
* For testing, segregate the bits where you actually talk to Dropbox and S3 as much as possible.
  Eg for S3, you ideally give it an object that has 2 methods, `mkdir(dirname)` and `write(dir, content, permissions)`
  then you could swap out the remote end with mocks or a local file system (or even write an adapter that goes the other direction).

Too bad Fog doesn't integrate with both, maybe look to see if there's something that does.
If there is one, then this becomes pretty trivial.


Idea 3: Automatically keep my Ruby app's dependencies current
-------------------------------------------------------------

**Integrates Rubygems and Github**

* Looks easy enough to set up a webhook http://guides.rubygems.org/rubygems-org-api/#webhook-methods
  Doesn't look like there's a client to do this.
* Github:
  * May need to create an app that can receive notifications when devs push >.<
    This probably also needs to get a list of your repos. TBH, this bit might make it take too long / be irritating.
  * Will need to clone and maybe pull
  * Will need to push
  * Will need to create a pull request

**User Story**

It's a PITA keeping my deps up to date, I have to remember to check them and the process
is tedious and feels like it could be scripted. So, I'd like a bot to watch Rubygems
for updates to my dependencies. If they udpate, it should bump the dependencies,
run the tests, and then submit a PR if they pass, and an issue documenting the problem if they don't.

**Expected procedure**

* I go to the site, click the link to sign up, do the oauth thing on Github
* I'm back on the site, I see a list of my repos, I click "autoupdate" on the repo I'm interested in
* I go to my integrations on github and add the app. (this might need to happen before the step above)
* The app figures out my deps (prob clones my repo and cats Gemfile.lock)
* The app then keeps those deps in a hash, keys are gem names, values are a list of apps that depend on it
* When Rubygems notifies the app of an update, it checks if it cares about that update
* If it does care, it adds each app to a queue to have that dep updated (or maybe just fork for each one, choose whichever is simpler)
* To update, it clones the repo (clone on every interaction for simplicity)
* It cds into the repo
* Bumps the version (there should be a command for this, maybe `bundle update`)
* Installs the deps
* Runs the tests (initially, assume test command is `rake` for simplicity)
* If the tests pass, push to a branch named after the dep then submit a pull request (this does imply it has commit access on my repo, you could get around it by having it do this with a fork, but that'd be a lot more work)
* If the tests don't pass, submit an issue.
* Probably those things should have the log output in their messages, but that might be too much.

I think this is my favourite, but it won't work without setting up a GH integration,
and that seems like it's going to be a PITA :(


Other Ideas
-----------

* (Slack/Twilio)    If it's easy enough to get two people in a video chat, a slack bot that users invite each other to video chat (looks easy https://github.com/TwilioDevEd/video-quickstart-ruby testing is probably a PITA)
* (S3/Twilio)       Text images to upload to s3. AWS might also have a service that could be used to view it (lambda?) Could make an event album, people at the event text images to it or tweet @ it, saves them all in an s3 folder and then you hit some page to view a slide show. Might be fun to have it on a screen during the party.
* (S3/.../PrintHug) same as above, but you print the images out. Eg people attend a wedding, when they take pictures they can text/tweet/whatever them to the app, the pictures are browsable and can be printed and mailed, eg to the bride and groom (way cheaper than a wedding photographer). Britney had this idea like a year or two ago. Looks like there's also a reasonable photo sharing app https://ifttt.com/do_camera
* (Tasks/...)      Listen for events on other services and create tasks for them (eg reply to an email, respond to a GH issue, etc)
* (Forms/?)        Pull in form submissions and display them in some useful way? (they prob already do this, it also sounds longer than 4 hours)
* (Watson/YouTube) Cull relevant parts of a video / poscast
* (Twitter/Maps)   Map where people in the world are talking about subject x?
* (S3/Flickr)      Pull images from an s3 account to flickr
* (S3/...)         Consolidate your content from many sources onto S3 (eg tweets, deviantart, flickr, etc)
* (Slack/S3)       Archive Slack conversations to s3 so you don't have to pay for them
* (DataMuse/?)     Use DataMuse to cheat at... boggle, scrabble, letterpress, etc
* (DataMuse/?)     Rewrite lyrics (or some other text) with similar sounding ones
* (Rubygems/Github) Auto-update my dependencies (when my dependencies update, automatically bump the deps, if the tests pass, submit a PR) maybe include useful links in the PR like changelog, commit diffs, whatever (will need: rubygems hook to be notified, server listening, fork off, clone from github, spawn a process to run the tests, git integration to add/commit, push to a branch, github initiate pull request, body should be the logs of all the commands it ran) Might be difficult to track what your deps are, eg do you need a GH integration to pull and record deps for when they add a new one and push?
* (Color Extraction/Vimeo) Input an image, video, and resolution, it takes screenshots from the video to be the pixels of the image at the given resolution
* (Slack/Glot)     Submit code in Slack. It runs it and tells you the output (maybe allow it to be loaded w/ a data set like Jupyter)
* (Rubygems/?)     Notify me (email/text/whatever) when my dependencies update
* (Spotify/Slack)  Jukebox to control Spotify, queue songs via whatever (slack/text/tweet/...) (remembering state across interactions could be a pain)
* (Database/Spreadsheets) Present a spreadsheet view of a database, then people who are comfortable w/ spreadsheets can work with the spreadsheet like they're used to, which implicitly works with the database. BONUS: Replaces CRUD apps
* (Sharpr/Slack)   Teams can aggregate relevant data about w/e (a bug, a feature, etc)
* (Slack/Sticky)   give the bot a url, it replies by posting a heatmap of what the user sees
* (S3/Dropbox)      Migrate dropbox to one of the AWS storage solutions like S3 (I could actually use this)


Idea-ets (one day, they may graduate into ideas)
------------------------------------------------

* Are there APIs for building structured data like graphviz or railroad diagrams? Could pull data in and draw it... lol how about railroad diagrams for all the w3 RFCs :P omg, how about SVG railroad diagrams of SVG's syntax for a thumb to the nose :P
* DataMuse for mad libs?
* (DataMuse/?) Augment writing with hints from DataMuse (looks like you could use https://www.microsoft.com/cognitive-services/en-us/linguistic-analysis-api to analyze the text)
* Is there an API that ranks text on coherence and other metrics? If so, what about trying to generate text about a topic that maximizes this score? Maybe generated from Markov Chains. Maybe there's another service that analyzes text for key points and such, then you could take data from that, and try to verbosify it while maximizing the coherence score, and you'd have an automated book report writer :P
* Process videos to get transcripts (Watson, maybe something to process the video), time map the transcript so you can jump to any given point. Could then seed it w/ video from a given person's speeches or w/e, and have it generate videos their quotes about some topic
* How about you input text and a list of videos, it outputs a video of clips from the input videos, the consolidated clips are the speech for the input text
* If soundcloud can be searched, you could find music w/ given BPM or w/e, generate playlists to fit a mood or activity
* Vimeo + Yahoo's programmable tv thing
* Personal analytics (where did I go? who was I with? what did I say? who do I talk to on X, what sites did I visit? how long was I there? etc)

