require 'slackbot_videochat_app'
require 'rack/test'

# The purpose is to support this interaction:
#
# ```
# Jan: Hey, Mei, how did the client meeting go?
# Mei: Too complicated to express in text, want to talk about it over lunch?
# Jan: Can't, I'm WFH, videochat?
# Mei: videochat: Jan
# Bot: Chat at http://videochat.example.com/j8n3fo1
# ```
#
# They each click the link and wind up in a hangout/facetime-like video chat
# where Mei and Jan sort out how to handle the client's situation.
TestInternetSession = Struct.new :app do
  include Rack::Test::Methods
end

RSpec.describe 'Slack webhook' do
  let(:internet) { TestInternetSession.new SlackbotVideochatApp }

  def slack_params
    { token:        "test-token",
      team_id:      "test-team-id",
      team_domain:  "test-team-domain",
      channel_id:   "test-channel-id",
      channel_name: "josh-test-channel-name",
      user_id:      "test-user-id",
      timestamp:    '1355517523.000005',
      user_name:    "username1",
      text:         "videochat: username2",
      trigger_word: "videochat:",
    }
  end

  def extract_body(response)
    expect(response).to be_successful
    body = JSON.parse response.body
    expect(body.keys).to eq ['text']
    body
  end

  # ideally a DM to each, but for now, just say it aloud
  it 'replies to slack with a the message for the users that tells them the url they can videochat at' do
    # posted to us from Slack,  for slash commands, we get these two instead of trigger_word:
    # {command: "videochat:", response_url: "https://hooks.slack.com/commands/idk/idk/idk"}
    response = internet.post '/videochats', slack_params
    body     = extract_body response
    expect(body['text']).to start_with 'Chat at http://example.org/videochats'
  end

  describe 'Generating a videochat url' do
    it 'is on the current host' do
      response = internet.post('http://1.example.org/videochats', slack_params)
      body     = extract_body response
      url      = body['text'].split.last
      expect(url).to start_with 'http://1.example.org'

      response = internet.post('http://2.example.org/videochats', slack_params)
      body     = extract_body response
      url      = body['text'].split.last
      expect(url).to start_with 'http://2.example.org'
    end

    it 'uses a random endpoint' do
      r1 = internet.post('/videochats', slack_params)
      r2 = internet.post('/videochats', slack_params)
      expect(r1.body).to_not eq r2.body
    end
  end
end
