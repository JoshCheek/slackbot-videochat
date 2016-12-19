require 'spec_helper'
require 'slackbot_videochat'

# The purpose is to support this interaction:
#
# ```
# Jan: Hey, Mei, how did the client meeting go?
# Mei: Too complicated to express in text, want to talk about it over lunch?
# Jan: Can't, I'm WFH, videochat?
# Mei: /videochat
# Bot: Chat at http://videochat.example.com/j8n3fo1
# ```
#
# They each click the link and wind up in a hangout/facetime-like video chat
# where Mei and Jan sort out how to handle the client's situation.
RSpec.describe 'Slack webhook' do
  let(:internet) { TestInternetSession.new SlackbotVideochat }

  def slack_params(overrides={})
    { token:        "test-token",
      team_id:      "test-team-id",
      team_domain:  "test-team-domain",
      channel_id:   "test-channel-id",
      channel_name: "test-channel-name",
      user_id:      "userid1",
      user_name:    "username1",
      text:         "",
      command:      "/videochat",
      response_url: "https://hooks.slack.com/commands/...",
      **overrides
    }
  end

  def extract_body(response)
    expect(response).to be_successful
    expect(response.content_type).to eq 'application/json'
    JSON.parse response.body
  end

  def text(body)
    body.fetch('attachments').fetch(0).fetch('text')
  end

  def url(body)
    text(body).split.last
  end

  it 'replies to slack with a message saying who requested the videochat and providing the url' do
    response = internet.post '/videochats', slack_params(user_id: 'U112233')
    body     = extract_body response
    expect(text body).to start_with '<@U112233>'
    expect(text body).to include 'http://example.org/videochats'
  end

  describe 'Generating a videochat url' do
    it 'is on the current host' do
      response = internet.post('http://1.example.org/videochats', slack_params)
      body     = extract_body response
      expect(url body).to include 'http://1.example.org'

      response = internet.post('http://2.example.org/videochats', slack_params)
      body     = extract_body response
      expect(url body).to include 'http://2.example.org/'
    end

    it 'uses a random endpoint' do
      r1 = internet.post('/videochats', slack_params)
      r2 = internet.post('/videochats', slack_params)
      expect(r1.body).to_not eq r2.body
    end
  end
end
