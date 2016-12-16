require 'sinatra/base'
require 'json'
require 'digest/md5'

class SlackbotVideochatApp < Sinatra::Base
  # Whenever someone says 'videochat: username-to-chat-with'
  # Slack posts to this url (see test for keys)
  # I'm not sure where the docs are for more interesting responses -.-
  post '/videochats' do
    content_type :json
    url   = File.join request.url, unique_token
    {text: "Chat at #{url}"}.to_json
  end

  # unlikely to be unique b/c it's a hash of the timestamp down to nanoseconds
  def unique_token
    Digest::MD5.hexdigest Time.new.strftime("%F%H%M%9N")
  end
end
