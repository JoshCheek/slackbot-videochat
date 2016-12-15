Copy the .env.example to .env locally, and then replace the values with the
real values that you got at the links here:

| Config Value  | Description |
| :-------------  |:------------- |
Configuration Profile SID | Identifier for a set of config properties for your video application - [find yours here](https://www.twilio.com/console/video/profiles).
Account SID | Your primary Twilio account identifier - find this [in the console here](https://www.twilio.com/console).
API Key | Used to authenticate - [generate one here](https://www.twilio.com/console/video/dev-tools/api-keys).
API Secret | Used to authenticate - [just like the above, you'll get one here](https://www.twilio.com/console/video/dev-tools/api-keys).

Test it out locally:

```
$ rackup config.ru
```

(go to the page, make sure you see yourself)

Then make it a valid rack app, push to heroku (eg I'm at
[https://videochat-example.herokuapp.com/](https://videochat-example.herokuapp.com/))

Set the environment variables on heroku

```sh
$ heroku config:set TWILIO_ACCOUNT_SID=AC14a3854eefc56a19c51ce82c3799a410 TWILIO_API_KEY=SK2d697fa05b50814af4a3211946ffce81 TWILIO_API_SECRET=zFRNJZSzik5Msz5dPMQtpGnlqOuDztyR TWILIO_CONFIGURATION_SID=VSac442a70144f28d5cad69f6693f87332
```



------

Original Readme below

------

# Video Quickstart for Ruby

This application should give you a ready-made starting point for writing your
own video apps with Twilio Video. Before we begin, we need to collect
all the config values we need to run the application:

| Config Value  | Description |
| :-------------  |:------------- |
Configuration Profile SID | Identifier for a set of config properties for your video application - [find yours here](https://www.twilio.com/console/video/profiles).
Account SID | Your primary Twilio account identifier - find this [in the console here](https://www.twilio.com/console).
API Key | Used to authenticate - [generate one here](https://www.twilio.com/console/video/dev-tools/api-keys).
API Secret | Used to authenticate - [just like the above, you'll get one here](https://www.twilio.com/console/video/dev-tools/api-keys).

## A Note on API Keys

When you generate an API key pair at the URLs above, your API Secret will only
be shown once - make sure to save this in a secure location,
or possibly your `~/.bash_profile`.

## Setting Up The Ruby (Sinatra) Application

Create a configuration file for your application:

```bash
cp .env.example .env
```

Edit `.env` with the four configuration parameters we gathered from above.

Next, we need to install our depenedencies:

```bash
bundle install
```

Now we should be all set! Run the application using the `ruby` command.

```bash
bundle exec ruby app.rb
```

Your application should now be running at [http://localhost:4567](http://localhost:4567). Select any room name and join the room. Join the same room with another user in another browser tab or window to start video chatting!

![screenshot of chat app](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/video2.original.png)

## License

MIT
