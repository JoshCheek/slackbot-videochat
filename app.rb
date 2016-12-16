require 'sinatra/base'
require 'json'

# Whenever someone says the slash command,
# Slack posts to my url with (not quite this):
#
# slash-command BOT [5:40 PM] Only visible to you
# { "token"=>"y06fTupQI3TjuNFeuP3jk2hL",
#   "team_id"=>"T3BS49M8A",
#   "team_domain"=>"module5",
#   "channel_id"=>"C3FDDV63V",
#   "channel_name"=>"josh-testing",
#   "user_id"=>"U3G2NE4MC",
#   "user_name"=>"paddington",
#   "command"=>"/guibot",
#   "text"=>"hello",
#   "response_url"=>"https://hooks.slack.com/commands/T3BS49M8A/117638796020/AeIqmup9bWRYueY7I5OEkQo1"
# }
#
# Respond with {text: 'some text'}
#   I'm not sure where the docs are for more interesting responses -.-

class SlackbotVideochat < Sinatra::Base
  post '/videochats' do
    content_type :json
    url = 'http://example.org/videochats/123'
    {text: "Chat at #{url}"}.to_json
  end
end
