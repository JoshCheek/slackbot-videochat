require 'sinatra'
require 'httparty'
require 'json'

post '/gateway' do
  content_type :json

  message = params[:text].gsub(params[:trigger_word], '').strip

  action, repo = message.split('_').map {|c| c.strip.downcase }

  if action == 'issues'
    repo_url = "https://api.github.com/repos/#{repo}"
    resp = HTTParty.get(repo_url)
    resp = JSON.parse resp.body
    { text: "There are #{resp['open_issues_count']} open issues on #{repo}" }.to_json
  else
    { type:    "message",
      text:    "Echoing: #{params.inspect}",
      channel: params[:user_id],
    }.to_json
  end
end

post '/echo' do
  content_type :json
  { type:    "message",
    text:    params.inspect,
    channel: params[:user_id],
  }.to_json
end
