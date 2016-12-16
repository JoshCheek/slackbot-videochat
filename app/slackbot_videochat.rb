require 'sinatra/base'
require 'json'
require 'digest/md5'

require 'twilio-ruby'
require 'sinatra'
require 'sinatra/json'
require 'faker'

class SlackbotVideochat < Sinatra::Base
  set :root, File.dirname(__dir__)

  # Whenever someone says 'videochat: username-to-chat-with'
  # Slack posts to this url (see test for keys)
  # I'm not sure where the docs are for more interesting responses -.-
  post '/videochats' do
    content_type :json
    url = File.join request.url, unique_token
    {text: "Chat at #{url}"}.to_json
  end

  get '/:file.:ext' do
    content_type params[:ext]
    filename = "#{params[:file]}.#{params[:ext]}"
    path     = File.join settings.views, filename
    File.read path
  end

  get '/token' do
    identity = 'username' # ideally, get this from slack
    token = Twilio::Util::AccessToken.new key(:twilio, :account_sid),
                                          key(:twilio, :api_key),
                                          key(:twilio, :api_secret),
                                          3600,
                                          identity

    # Grant access to Video
    grant = Twilio::Util::AccessToken::VideoGrant.new
    grant.configuration_profile_sid = key(:twilio, :configuration_sid)
    token.add_grant grant

    json :identity => identity, :token => token.to_jwt
  end

  # unlikely to be unique b/c it's a hash of the timestamp down to nanoseconds
  def unique_token
    Digest::MD5.hexdigest Time.new.strftime("%F%H%M%9N")
  end

  def key(scope, name)
    env.fetch(:keys).fetch(scope).fetch(name)
  end
end
