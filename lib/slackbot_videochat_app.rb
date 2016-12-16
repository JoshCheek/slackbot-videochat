require 'sinatra/base'
require 'json'
require 'digest/md5'

class SlackbotVideochatApp < Sinatra::Base
  # Whenever someone says 'videochat: username-to-chat-with'
  # Slack posts to this url (see test for keys)
  # I'm not sure where the docs are for more interesting responses -.-
  post '/videochats' do
    content_type :json
    # unlikely to be unique b/c it includes timestamp down to nanoseconds
    time  = Time.new
    seed  = time.strftime("%F%H%M%9N")
    token = Digest::MD5.hexdigest seed
    url   = File.join request.url, token
    {text: "Chat at #{url}"}.to_json
  end
end
