require 'sinatra/base'
require 'json'

class SlackbotVideochatApp < Sinatra::Base
  # Whenever someone says 'videochat: username-to-chat-with'
  # Slack posts to this url (see test for keys)
  # I'm not sure where the docs are for more interesting responses -.-
  post '/videochats' do
    content_type :json
    url = 'http://example.org/videochats/123'
    {text: "Chat at #{url}"}.to_json
  end
end
