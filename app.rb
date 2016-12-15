require 'sinatra'
require 'httparty'
require 'json'

# Whenever someone says the slash command,
# Slack posts to my url with (not quite this):
#   -d token=eExRyKtmi3TPoZJM6NcbELvm
#   -d team_id=T0001
#   -d team_domain=example
#   -d channel_id=C2147483705
#   -d channel_name=test
#   -d timestamp=1355517523.000005
#   -d user_id=U2147483697
#   -d user_name=Steve
#   -d 'text=giubot: issues _ twbs/bootstrap'
#   -d 'trigger_word=giubot:'
#
# Respond with {text: 'some text'}
#   I'm not sure where the docs are for more interesting responses -.-


# !!Copied straight from the example, no attempt made to even run it!!
class SlackbotVideochat
  post '/gateway' do
    message = params[:text].gsub(params[:trigger_word], '').strip

    action, repo = message.split('_').map {|c| c.strip.downcase }
    repo_url = "https://api.github.com/repos/#{repo}"

    case action
    when 'issues'
      resp = HTTParty.get(repo_url)
      resp = JSON.parse resp.body
      respond_message "There are #{resp['open_issues_count']} open issues on #{repo}"
    end
  end

  def respond_message message
    content_type :json
    {:text => message}.to_json
  end
end
