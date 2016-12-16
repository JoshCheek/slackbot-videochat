require_relative '../app'
require 'rack/test'

# The purpsoe is to support this interaction:
#
# ```
# Jan: Hey, Mei, how did the client meeting go?
# Mei: Too complicated to express in text, want to talk about it over lunch?
# Jan: Can't, I'm WFH, videochat?
# Mei: /videochat Jan
# Bot: Chat at http://videochat.example.com/j8n3fo1
# ```
#
# They each click the link and wind up in a hangout/facetime-like video chat
# where Mei and Jan sort out how to handle the client's situation.
TestInternetSession = Struct.new :app do
  include Rack::Test::Methods
end

RSpec.describe 'Slack webhook' do
  let(:internet) { TestInternetSession.new SlackbotVideochat }

  # ideally a DM to each, but for now, just say it aloud
  it 'replies to slack with a the message for the users that tells them the url they can videochat at' do
    # posted to us from Slack
    response = internet.post '/videochats', {
      token:        "test-token",
      team_id:      "test-team-id",
      team_domain:  "test-team-domain",
      channel_id:   "test-channel-id",
      channel_name: "josh-test-channel-name",
      user_id:      "test-user-id",
      user_name:    "username1",
      command:      "videochat:",
      text:         "username2",
      response_url: "https://hooks.slack.com/commands/idk/idk/idk",
    }

    expect(response).to be_successful
    body = JSON.parse response.body
    expect(body.keys).to eq ['text']
    expect(body['text']).to start_with 'Chat at http://example.org/videochats'
  end

  describe 'the videochat url' do
    it 'uses a random endpoint'
  end
end
