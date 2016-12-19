require 'sinatra/base'
require 'digest/md5'
require 'twilio-ruby'

class SlackbotVideochat < Sinatra::Base
  # Whenever someone says '/videochat'
  # Slack posts to this url (see test for keys)
  # I'm not sure where the docs are for more interesting responses -.-
  post '/videochats' do
    content_type :json
    url = File.join request.url, unique_token
    { parse: 'full',
      attachments: [
        { text: "<@#{params[:user_id]}> invites you to <#{url}|videochat>!",
          color: "#AAAA66",
        }
      ]
    }.to_json
  end

  get '/' do
    erb :main
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

    @room_name = params[:room]
    @identity  = identity
    @token     = user.to_jwt
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
end
