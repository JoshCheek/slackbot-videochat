app_path = File.realdirpath '../app', __dir__
$LOAD_PATH.unshift app_path
require 'videochat_app'
require 'rack/test'
require 'middleware'

RSpec.describe 'VideochatApp' do
  include Rack::Test::Methods

  def app
    Middleware::AddToEnv.new VideochatApp, keys: @keys
  end

  before do
    @keys = {
      twilio: {
        account_sid:       'xxxxx',
        api_key:           'xxxxx',
        api_secret:        'xxxxx',
        configuration_sid: 'xxxxx',
      }
    }
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
    def videochat_response(url: '/videochats/someroom')
      get(url).tap { |response| expect(response).to be_ok }
    end

    def videochat_vars(**request_args)
      videochat_response(**request_args)
        .body.scan(/var *(.*?) *= *(.*?)$/)
        .map { |name, value| [name.to_sym, value] }.to_h
    end

    it 'provides a twilio video token' do
      expect(videochat_vars).to have_key :token
    end

    it 'gets the room name from the url' do
      vars1 = videochat_vars(url: '/videochats/room1')
      vars2 = videochat_vars(url: '/videochats/room2')
      expect(vars1.fetch :roomName).to eq '"room1"'
      expect(vars2.fetch :roomName).to eq '"room2"'
    end

    it 'HTML escapes the room' do
      room = Rack::Utils.escape '";alert("hi");"'
      vars = videochat_vars(url: "/videochats/#{room}")
      expect(vars.fetch :roomName).to eq '"\\";alert(\\"hi\\");\\""'
    end

    # Instructions to get keys are here:
    # https://github.com/TwilioDevEd/video-quickstart-ruby
    specify 'the token grants video access and depends on a unique identity, profile sid, account sid, account key, account secret' do
      @keys = {
        twilio: {
          account_sid:       'test-account-sid',
          api_key:           'test-api-key',
          api_secret:        'test-api-secret',
          configuration_sid: 'test-configuration-sid',
        }
      }
      escaped_token = videochat_vars[:token]
      encoded_token = JSON.parse escaped_token, quirks_mode: true

      # account secret
      token = JWT.decode(encoded_token, 'test-api-secret').shift

      # api key and account sid
      expect(token.fetch 'iss').to eq 'test-api-key'
      expect(token.fetch 'sub').to eq 'test-account-sid'

      # depends on the user's identity
      grants = token.fetch 'grants'
      expect(grants.fetch 'identity').to eq 'some identity'

      # video access and profile sid
      expect(grants.fetch('video').fetch 'configuration_profile_sid')
        .to eq 'test-configuration-sid'
    end
  end
end
