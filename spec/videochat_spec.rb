app_path = File.expand_path '../app', __dir__
$LOAD_PATH.unshift app_path
require 'videochat_app'
require 'rack/test'

RSpec.describe 'VideochatApp' do
  include Rack::Test::Methods

  def app
    VideochatApp
  end

  describe 'when Slack POSTs to /videochats' do
    it 'responds with a link to a url that the users can videochat' do
      from_slack = {
        token:         "Z4n2e1acd0Iu7jkiHx0Ng21L",
        team_id:       "T3BS49M8A",
        team_domain:   "module5",
        channel_id:    "C3FDDV63V",
        channel_name:  "josh-testing",
        user_id:       "UJOSHUSERID",
        user_name:     "paddington",
        command:       "%2Fvc2",
        text:          "",
        response_url:  "https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT3BS49M8A%2F119906407301%2FNr4MLEysnZyEGWGscNSpuljZ",
      }

      response = post '/videochats', from_slack

      expect(response).to be_ok
      expect(response.body).to include "<@UJOSHUSERID> has invided you to <http://example.org/videochats/"
    end

    it 'responds with valid JSON'

    describe 'the videochat link' do
      it 'is on the app\'s host'
      it 'respects the scheme'
      it 'is a unique url so that users don\'t all wind up in the same chat'
    end
  end


  describe 'when users follow a videochat link' do
    it 'provides a twilio video token'
    it 'gets the room name from the url'

    # Instructions to get keys are here:
    # https://github.com/TwilioDevEd/video-quickstart-ruby
    describe 'the token' do
      it 'depends on a unique identity (random value for now)'
      it 'depends on the profile sid'
      it 'depends on the account sid'
      it 'depends on the api key'
      it 'depends on the api secret'
    end
  end
end
