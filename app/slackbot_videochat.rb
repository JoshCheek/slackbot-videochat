require 'sinatra/base'
require 'digest/md5'
require 'twilio-ruby'

class SlackbotVideochat < Sinatra::Base
  get '/' do
    erb :main
  end

  # Slack posts to this url (see test for keys)
  # https://api.slack.com/docs/message-formatting
  # https://api.slack.com/docs/message-attachments
  post '/videochats' do
    content_type :json
    url = File.join request.url, unique_token
    JSON.dump parse: 'full',
              response_type: "in_channel",
              attachments: [
                { text: "<@#{params[:user_id]}> invites you to <#{url}|videochat>!",
                  color: "#AAAA66",
                }
              ]
  end

  get '/videochats/:room' do
    @identity  = unique_token # A random value since we can't get their name from Slack
    @room_name = params[:room]
    @token     = twilio_token(identity: @identity, duration_seconds: 3600)
    @devmode   = self.class.development? && ('dev' == params[:room])
    erb :videochat
  end

  private

  # likely to be unique b/c it's a hash of the timestamp down to nanoseconds
  def unique_token(time=Time.now)
    str = time.strftime("%F%H%M%9N")
    b64 = Digest::MD5.base64digest(str)
    b64[0...-2] # remove trailing equal signs (they're ugly)
  end

  def key(scope, name)
    env.fetch(:keys).fetch(scope).fetch(name)
  end

  def twilio_token(identity:, duration_seconds:)
    token = Twilio::Util::AccessToken.new(
      key(:twilio, :account_sid),
      key(:twilio, :api_key),
      key(:twilio, :api_secret),
      duration_seconds,
      identity,
    )
    token.add_grant video_grant
    token.to_jwt # https://jwt.io/
  end

  def video_grant
    grant = Twilio::Util::AccessToken::VideoGrant.new
    grant.configuration_profile_sid = key(:twilio, :configuration_sid)
    grant
  end
end
