require 'sinatra/base'
require 'json'

# Whenever someone says the slash command,
# Slack posts to my url with (not quite this):
#
# Respond with {text: 'some text'}
#   I'm not sure where the docs are for more interesting responses -.-

class SlackbotVideochatApp < Sinatra::Base
  post '/videochats' do
    content_type :json
    url = 'http://example.org/videochats/123'
    {text: "Chat at #{url}"}.to_json
  end
end
