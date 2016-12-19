require 'spec_helper'

RSpec.describe 'GET /videochats/:room' do

  # invokes the endpoint with all the interestingly injectible values
  def js_vars( room:              'r',
               account_sid:       'a',
               api_key:           'b',
               api_secret:        'c',
               configuration_sid: 'd',
               time:              Time.new(2001,2,3,4,5,6)
             )

    require 'slackbot_videochat'
    app = SlackbotVideochat

    require 'add_keys'
    app = AddKeys.new(app, twilio: {account_sid: account_sid, api_key: api_key, api_secret: api_secret, configuration_sid: configuration_sid})

    require 'add_timestamp'
    app = AddTimestamp.new app, double(Time, now: time)
    allow(Time).to receive(:now) { time } # Oof: https://github.com/twilio/twilio-ruby/blob/791f7880f23d1aa56927461fee8e6cb3d7034ce0/lib/twilio-ruby/util/access_token.rb#L26

    session     = TestInternetSession.new app
    response    = session.get "/videochats/#{room}"
    assignments = response.body.scan(/^ *var *(\S+) *= *['"](.*)['"]$/)
    assignments.map { |key, value| [key.intern, value] }.to_h
  end

  it 'gives the room name to the javascript so it can connect the users' do
    expect(js_vars(room:  'first')[:roomName]).to eq 'first'
    expect(js_vars(room: 'second')[:roomName]).to eq 'second'
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
