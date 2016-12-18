require 'sinatra/base'
require 'sinatra/json'
require 'digest/md5'
require 'twilio-ruby'

class SlackbotVideochat < Sinatra::Base

  get('/') { redirect '/videochats/dev' } if ENV['RACK_ENV'] == 'development'

  # Whenever someone says 'videochat: username-to-chat-with'
  # Slack posts to this url (see test for keys)
  # I'm not sure where the docs are for more interesting responses -.-
  post '/videochats' do
    url = File.join request.url, unique_token
    json text: "Chat at #{url}"
  end

  get '/videochats/:room' do
    # Ideally we could use their name from Slack
    # probably not possible, for now we'll just give them a random unique value
    identity = unique_token

    user = Twilio::Util::AccessToken.new(
      key(:twilio, :account_sid),
      key(:twilio, :api_key),
      key(:twilio, :api_secret),
      3600, # 1 hour
      identity
    )

    # Grant access to Video
    grant = Twilio::Util::AccessToken::VideoGrant.new
    grant.configuration_profile_sid = key(:twilio, :configuration_sid)
    user.add_grant grant

    @identity  = identity
    @room_name = params[:room]
    @token     = user.to_jwt

    erb :videochat
  end

  # unlikely to be unique b/c it's a hash of the timestamp down to nanoseconds
  def unique_token
    time = Time.new.strftime("%F%H%M%9N")
    b64  = Digest::MD5.base64digest(time)
    b64[0...-2] # remove trailing equal signs (they're ugly)
  end

  def key(scope, name)
    env.fetch(:keys).fetch(scope).fetch(name)
  end
end
