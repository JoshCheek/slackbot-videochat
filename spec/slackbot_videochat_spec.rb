require 'spec_helper'
require 'slackbot_videochat'
require 'add_keys'
require 'add_timestamp'

# The purpose is to support this interaction:
#
# ```
# Jan: Hey, Mei, how did the client meeting go?
# Mei: Too complicated to express in text, want to talk about it over lunch?
# Jan: Can't, I'm WFH, videochat?
# Mei: /videochat
# Bot: @paddington invites you to videochat! (link)
# ```
#
# They each click the link and wind up in a hangout/facetime-like video chat
# where Mei and Jan sort out how to handle the client's situation.

RSpec.describe 'GET /' do
  it 'renders the homepage' do
    response = TestInternetSession.new(SlackbotVideochat).get('/')
    expect(response).to be_ok
  end
end

RSpec.describe 'POST /videochats' do
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



RSpec.describe 'GET /videochats/:room' do

  # invokes the endpoint with all the interestingly injectible values
  def js_vars( room:              'r',
               account_sid:       'a',
               api_key:           'b',
               api_secret:        'c',
               configuration_sid: 'd',
               time:              Time.new(2001,2,3,4,5,6)
             )

    app = SlackbotVideochat
    app = AddKeys.new(app, twilio: {account_sid: account_sid, api_key: api_key, api_secret: api_secret, configuration_sid: configuration_sid})
    app = AddTimestamp.new app, double(Time, now: time)
    allow(Time).to receive(:now) { time } # Oof: https://github.com/twilio/twilio-ruby/blob/791f7880f23d1aa56927461fee8e6cb3d7034ce0/lib/twilio-ruby/util/access_token.rb#L26

    session     = TestInternetSession.new app
    response    = session.get "/videochats/#{ERB::Util.url_encode room}"
    assignments = response.body.scan(/^ *var *(\S+) *= *['"](.*)['"]$/)
    assignments.map { |key, value| [key.intern, value] }.to_h
  end

  it 'gives the room name to the javascript so it can connect the users' do
    expect(js_vars(room:  'first')[:roomName]).to eq 'first'
    expect(js_vars(room: 'second')[:roomName]).to eq 'second'
  end

  it 'escapes the room name' do
    vars = js_vars(room: '";alert("hi");"')
    expect(vars[:roomName]).to eq '\\";alert(\\"hi\\");\\"'
  end

  context 'twilio token' do
    it 'is based on a random identity for this user' do
      time1 = Time.now
      time2 = time1 + 1

      token1a = js_vars(time: time1)[:token]
      token1b = js_vars(time: time1)[:token]
      token2  = js_vars(time: time2)[:token]

      expect(token1a).to eq token1b
      expect(token1a).to_not eq token2
    end

    it 'is based on our twilio credentials' do
      tokens = [
        js_vars,
        js_vars(account_sid:       "changed"),
        js_vars(api_key:           "changed"),
        js_vars(api_secret:        "changed"),
        js_vars(configuration_sid: "changed"),
      ]
      expect(tokens.uniq.length).to eq tokens.length
    end
  end
end
