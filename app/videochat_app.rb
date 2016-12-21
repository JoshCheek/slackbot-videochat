require 'sinatra/base'
require 'json'

class VideochatApp < Sinatra::Base

  # =====  This is what Slack sends:  =====
  #   POST / HTTP/1.1
  #   User-Agent: Slackbot 1.0 (+https://api.slack.com/robots)
  #   Host: 565969aa.ngrok.io
  #   Accept-Encoding: gzip,deflate
  #   Accept: application/json,*/*
  #   Content-Length: 283
  #   Content-Type: application/x-www-form-urlencoded
  #   X-Forwarded-Proto: https
  #   X-Forwarded-For: 54.89.92.4
  #
  #   token=Z4n2e1acd0Iu7jkiHx0Ng21L&team_id=T3BS49M8A&team_domain=module5&channel_id=C3FDDV63V&channel_name=josh-testing&user_id=U3G2NE4MC&user_name=paddington&command=%2Fvc2&text=&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT3BS49M8A%2F119906407301%2FNr4MLEysnZyEGWGscNSpuljZ
  post '/videochats' do
    content_type 'json'
    url = 'http://example.org/videochats/somechat'
    response = {
      "response_type": "in_channel",
      "attachments": [
        {
          "text": "<@#{params[:user_id]}> has invided you to <#{url}|videochat>",
          "color": "#FF00FF"
        }
      ]
    }
    JSON.dump(response)
  end
end
