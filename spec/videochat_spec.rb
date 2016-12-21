app_path = File.realdirpath '../app', __dir__
$LOAD_PATH.unshift app_path
require 'videochat_app'
require 'rack/test'

RSpec.describe 'VideochatApp' do
  include Rack::Test::Methods

  def app
    VideochatApp
  end

  describe 'when Slack POSTs to /videochats' do
    def slack_response(url: '/videochats')
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
      post url, from_slack
    end


    it 'responds with a link to a url that the users can videochat' do
      response = slack_response
      expect(response).to be_ok
      expect(response.body).to include "<@UJOSHUSERID> has invited you to <http://example.org/videochats/"
    end

    it 'responds with valid JSON' do
      response = slack_response
      expect(response.content_type).to eq 'application/json'
      expect(JSON.parse response.body).to be_a_kind_of Hash
    end

    describe 'the videochat link' do
      it 'is on the app\'s host' do
        response1 = slack_response url: 'http://example.org/videochats'
        response2 = slack_response url: 'http://subdomain.example.com/videochats'

        expect(response1.body).to include "invited you to <http://example.org/videochats/"
        expect(response2.body).to include "invited you to <http://subdomain.example.com/videochats/"
      end


      it 'respects the scheme' do
        response1 = slack_response url: 'http://example.org/videochats'
        response2 = slack_response url: 'https://example.org/videochats'

        expect(response1.body).to include "invited you to <http://example.org/videochats/"
        expect(response2.body).to include "invited you to <https://example.org/videochats/"
      end

      it 'is a unique room name so that users don\'t all wind up in the same chat' do
        link1 = slack_response.body.scan(/<http.*?>/)
        link2 = slack_response.body.scan(/<http.*?>/)
        expect(link1).to_not eq link2
      end

      it 'does not have slashes in the room name' do
        link = slack_response.body[/<http.*?>/]
        room = link[/videochats\/(.*)\|/, 1]
        expect(room).to_not include '/'
      end
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
