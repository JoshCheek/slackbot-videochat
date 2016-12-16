require 'sinatra/base'
require 'sinatra/json'
require 'digest/md5'
require 'twilio-ruby'

class SlackbotVideochat < Sinatra::Base
  # Whenever someone says 'videochat: username-to-chat-with'
  # Slack posts to this url (see test for keys)
  # I'm not sure where the docs are for more interesting responses -.-
  post '/videochats' do
    url = File.join request.url, unique_token
    json text: "Chat at #{url}"
  end

  get '/videochats/:room' do
    identity = 'username' # uhm, can we get this from slack?

    token = Twilio::Util::AccessToken.new(
      key(:twilio, :account_sid),
      key(:twilio, :api_key),
      key(:twilio, :api_secret),
      3600, # 1 hour
      identity
    )

    # Grant access to Video
    grant = Twilio::Util::AccessToken::VideoGrant.new
    grant.configuration_profile_sid = key(:twilio, :configuration_sid)
    token.add_grant grant

    @identity  = identity
    @room_name = params[:room]
    @token     = token.to_jwt

    erb :videochat
  end

  # unlikely to be unique b/c it's a hash of the timestamp down to nanoseconds
  def unique_token
    Digest::MD5.hexdigest Time.new.strftime("%F%H%M%9N")
  end

  def key(scope, name)
    env.fetch(:keys).fetch(scope).fetch(name)
  end
end
